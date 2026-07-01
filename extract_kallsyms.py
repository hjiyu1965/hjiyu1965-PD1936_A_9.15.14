#!/usr/bin/env python3
"""Extract kallsyms from ARM64 Linux kernel (4.14).

Layout (4.14 with CONFIG_KALLSYMS_BASE_RELATIVE=y, which Android kernels use):
    kallsyms_addresses  OR  kallsyms_offsets + kallsyms_relative_base
    kallsyms_num_syms    (u32)
    kallsyms_names       (compressed)
    kallsyms_markers     (long array)
    kallsyms_token_table (strings separated by \0)
    kallsyms_token_index (u16 array, 256 entries)

We locate kallsyms_token_table first via heuristic, then walk backwards.
"""
import struct
import sys

KERNEL = '/workspace/boot_unpacked/kernel'

with open(KERNEL, 'rb') as f:
    data = f.read()

print(f'Kernel size: {len(data):,} bytes')

# === Step 1: Locate kallsyms_token_table ===
# Heuristic: scan for a region with many short null-terminated strings,
# total around 256 entries, lengths 1-8 chars, mostly ASCII.
# Then verify by checking kallsyms_token_index immediately after.

def is_token_table_text(b):
    """Check if buffer looks like a token table region."""
    if not b:
        return 0
    n = 0
    pos = 0
    total = len(b)
    while pos < total:
        end = b.find(b'\x00', pos)
        if end < 0:
            break
        tok_len = end - pos
        if tok_len == 0 or tok_len > 10:
            return n
        # Must be ASCII printable
        for c in b[pos:end]:
            if c < 0x20 or c > 0x7e:
                return n
        n += 1
        pos = end + 1
    return n

print('\n[1] Scanning for kallsyms_token_table (looking for >=100 short null-terminated strings)...')
# Search in the last 25% of the kernel (kallsyms is near the end usually)
candidates = []
search_start = len(data) // 2
window = 4096
step = 256
best = None
for off in range(search_start, len(data) - window, step):
    n = is_token_table_text(data[off:off+window])
    if n >= 80:
        candidates.append((off, n))
        if best is None or n > best[1]:
            best = (off, n)

# Take the highest-quality candidate
if not best:
    print('  No candidate found.')
    sys.exit(1)

# Now find exact start: walk backward while previous byte is the end of a token
# Actually, find the first token start by going backward to find a non-token char
print(f'  Best candidate region: 0x{best[0]:x} with {best[1]} tokens in 4KB window')

# Refine: find the precise start of token_table.
# Token table starts right after some non-ASCII or alignment. Walk backward.
off = best[0]
# Walk back while we see ASCII + \0 patterns
while off > 0:
    prev = data[off-1]
    if prev == 0:
        # could be end of previous token, check char before
        if off-2 >= 0 and 0x20 <= data[off-2] <= 0x7e:
            off -= 2
            continue
    if 0x20 <= prev <= 0x7e:
        # char in middle of token, walk back to start
        o = off - 1
        while o > 0 and 0x20 <= data[o-1] <= 0x7e:
            o -= 1
        # o is now start of a token; verify the byte before is \0 or non-ascii
        if o-1 >= 0 and data[o-1] == 0:
            off = o
            continue
        elif o-1 < 0:
            off = o
            break
        else:
            break
    break

token_table_off = off
print(f'  Estimated kallsyms_token_table start: 0x{token_table_off:x}')

# Parse all tokens
tokens = []
pos = token_table_off
while True:
    end = data.find(b'\x00', pos)
    if end < 0 or end - pos > 12:
        break
    tok = data[pos:end]
    if not all(0x20 <= c <= 0x7e for c in tok):
        break
    tokens.append(tok.decode('latin-1'))
    pos = end + 1
    if len(tokens) >= 256:
        break
print(f'  Parsed {len(tokens)} tokens, first 10: {tokens[:10]}')
print(f'  Last 10: {tokens[-10:]}')
token_table_end = pos  # points to byte after final \0

# === Step 2: Parse kallsyms_token_index (u16 array, 256 entries) ===
# Token index immediately follows token table (after alignment to 4 bytes maybe)
idx_off = (token_table_end + 3) & ~3
# Or it might be unaligned. Let's try idx_off directly first.
# Verify: token_index[0] should == 0 (offset of first token in token_table)
print(f'\n[2] Looking for kallsyms_token_index near 0x{idx_off:x}')
found_idx_off = None
for try_off in range(token_table_end, token_table_end + 16, 2):
    vals = struct.unpack_from('<256H', data, try_off)
    # First entry should be 0 (offset of first token)
    if vals[0] == 0 and vals[1] < len(tokens[0]) + 1 + 20:
        # Check monotonicity roughly
        ok = all(vals[i] <= vals[i+1] for i in range(0, 255, 1))
        # Check last value points within token_table
        if ok and vals[255] < (token_table_end - token_table_off + 10):
            found_idx_off = try_off
            token_index = vals
            print(f'  Found kallsyms_token_index @ 0x{try_off:x}')
            print(f'  First 10 indices: {list(vals[:10])}')
            print(f'  Last 10 indices:  {list(vals[-10:])}')
            break
if not found_idx_off:
    print('  Token index not found.')
    sys.exit(1)

# Build a function: token_id -> string
def token_str(tid):
    off = token_index[tid]
    end = data.find(b'\x00', token_table_off + off)
    return data[token_table_off + off : end].decode('latin-1')

# Sanity check
print(f'  Verify: token_str(0)={token_str(0)!r}, token_str(1)={token_str(1)!r}')

# === Step 3: Walk backwards to find kallsyms_markers ===
# markers is an array of 'long' (8 bytes on ARM64). Each entry is the byte offset
# (into kallsyms_names) of the start of each 256-symbol chunk.
# We don't know its size yet, but we can walk back from token_table.
# The marker right before token_table should be 0 (start), and entries should be increasing.
print(f'\n[3] Walking back from token_table to find kallsyms_markers...')
# Markers end = token_table_off (approximately; may have alignment)
# Try to find markers end by checking the last marker value is the total compressed size
# of names.
# Walk back looking for increasing 8-byte values, ending near 0 at the start.

markers_end = token_table_off
# Align to 8 bytes downward
markers_end = markers_end & ~7
# Walk back while we see plausible marker values
# Markers should be increasing positive values <= ~5MB (compressed names size)
# and the first marker (last when walking back) is 0.
marker_count = 0
walk = markers_end
prev_val = None
while walk >= 8:
    val = struct.unpack_from('<Q', data, walk - 8)[0]
    if val == 0 and marker_count > 0:
        # This might be the first marker (start). Verify by checking next value > 0.
        next_val = struct.unpack_from('<Q', data, walk)[0] if walk + 8 <= markers_end else None
        if next_val is not None and 0 < next_val < 0x1000000:
            walk -= 8  # include this 0 marker
            marker_count += 1
            break
        else:
            break
    if val > 0x10000000:  # too big, not a marker
        break
    if prev_val is not None and val > prev_val:
        break  # not monotonically increasing when going back
    prev_val = val
    walk -= 8
    marker_count += 1
    if marker_count > 100000:
        break

markers_start = walk
print(f'  kallsyms_markers @ 0x{markers_start:x} - 0x{markers_end:x} ({marker_count} entries)')
markers = struct.unpack_from(f'<{marker_count}Q', data, markers_start)
print(f'  First 5 markers: {list(markers[:5])}')
print(f'  Last 5 markers:  {list(markers[-5:])}')

# === Step 4: kallsyms_names sits between kallsyms_num_syms and kallsyms_markers ===
# Format: each symbol = length byte + (token_id bytes until length exhausted)
# Total length = markers[-1] + size of last chunk
# Walk forward from names_start (= ?) until we hit markers_start.
# But we don't know names_start yet. It's after kallsyms_num_syms.
# Strategy: parse names from a guessed start, count symbols, compare to num_syms.

# We need num_syms first. It's a u32 located before names.
# names_end == markers_start
names_end = markers_start
print(f'\n[4] kallsyms_names ends @ 0x{names_end:x}')
# We need to find names_start. Approach: try to parse names backwards from names_end - 1.
# Each entry: [len][tokens...]. Walking backwards is hard because we don't know entry boundaries.
# Alternative: find num_syms first. num_syms is a u32, just before names_start.
# num_syms is typically between 50,000 and 200,000 for a kernel this size.
# Try all positions backward from names_end, looking for plausible num_syms,
# then verify by parsing forward.

print(f'  Searching for kallsyms_num_syms (plausible u32 value 50K-300K)...')
num_syms = None
num_syms_off = None
# Try a range of offsets. names_start should be 4-byte aligned after num_syms.
for back in range(4, 0x100, 4):
    off = names_end - back
    if off < 0:
        break
    val = struct.unpack_from('<I', data, off)[0]
    if 50000 <= val <= 400000:
        # Tentatively: names_start = off + 4 (after num_syms)
        names_start = off + 4
        # Try to parse `val` symbols from names_start, see if total length matches names_end
        try:
            pos = names_start
            cnt = 0
            ok = True
            while cnt < val:
                if pos >= names_end:
                    ok = False
                    break
                ln = data[pos]
                if ln == 0:
                    ok = False
                    break
                pos += 1 + ln
                cnt += 1
                if pos > names_end:
                    ok = False
                    break
            if ok and pos == names_end:
                num_syms = val
                num_syms_off = off
                names_start_actual = names_start
                print(f'  Found kallsyms_num_syms @ 0x{off:x}: {val}')
                print(f'  kallsyms_names @ 0x{names_start_actual:x} - 0x{names_end:x}')
                break
        except Exception:
            continue

if num_syms is None:
    print('  Failed to locate kallsyms_num_syms with simple heuristic.')
    sys.exit(1)

# === Step 5: Parse all symbol names ===
print(f'\n[5] Parsing {num_syms} symbol names...')
pos = names_start_actual
names = []
for i in range(num_syms):
    ln = data[pos]
    pos += 1
    sym = ''
    for j in range(ln):
        tid = data[pos]
        pos += 1
        sym += token_str(tid)
    names.append(sym)
assert pos == names_end, f'Names parse end mismatch: pos=0x{pos:x} != names_end=0x{names_end:x}'
print(f'  Parsed {len(names)} names. Sample:')
for n in names[:5]:
    print(f'    {n}')
print(f'  ...')
for n in names[-5:]:
    print(f'    {n}')

# === Step 6: Find kallsyms_addresses or kallsyms_offsets + relative_base ===
# They sit before num_syms. For 4.14 with CONFIG_KALLSYMS_BASE_RELATIVE=y
# (typical on Android arm64), the layout is:
#   kallsyms_offsets   (s32 array, num_syms entries) - 4 bytes each
#   kallsyms_relative_base  (s64) - 8 bytes
#   kallsyms_num_syms (u32) <- we have this at num_syms_off
# Otherwise:
#   kallsyms_addresses (unsigned long array, num_syms entries) - 8 bytes each
#   kallsyms_num_syms (u32)
print(f'\n[6] Locating kallsyms_addresses or kallsyms_offsets+relative_base...')

# Try the BASE_RELATIVE variant first
# size = num_syms * 4 (offsets) + 8 (relative_base)
offsets_size = num_syms * 4
offsets_end = num_syms_off - 8  # relative_base is 8 bytes before num_syms
offsets_start = offsets_end - offsets_size
print(f'  Trying BASE_RELATIVE variant:')
print(f'    offsets @ 0x{offsets_start:x} - 0x{offsets_end:x} (size {offsets_size})')
print(f'    relative_base @ 0x{offsets_end:x} - 0x{offsets_end+8:x}')

relative_base = struct.unpack_from('<q', data, offsets_end)[0]
print(f'    relative_base = 0x{relative_base:x}')
# Sanity: relative_base should be in kernel address space (0xffff800000000000 or similar)
# or a small offset if KASLR-relative

# Read offsets as s32 array
offsets = struct.unpack_from(f'<{num_syms}i', data, offsets_start)
# Sample some
print(f'    Sample offsets (first 5): {offsets[:5]}')
print(f'    Sample offsets (last 5):  {offsets[-5:]}')

# Verify by checking first symbol (_head or _text) address
# Reconstruct first address
addr0 = (relative_base + offsets[0]) & 0xffffffffffffffff
print(f'    Reconstructed addr[0] = 0x{addr0:x}  (expected ~0xffff800010000000)')

# Decide if this variant is correct
if 0xffff000000000000 <= addr0 <= 0xffffffffffffffff or addr0 < 0x100000000:
    print(f'  -> BASE_RELATIVE variant looks valid')
    syms = [(relative_base + o) & 0xffffffffffffffff for o in offsets]
else:
    # Try the addresses variant (8 bytes each)
    print(f'  -> BASE_RELATIVE invalid, trying addresses variant')
    addrs_size = num_syms * 8
    addrs_end = num_syms_off
    addrs_start = addrs_end - addrs_size
    addresses = struct.unpack_from(f'<{num_syms}Q', data, addrs_start)
    print(f'    addresses @ 0x{addrs_start:x} - 0x{addrs_end:x}')
    print(f'    addr[0] = 0x{addresses[0]:x}')
    syms = list(addresses)

# === Step 7: Output symbol table ===
print(f'\n[7] Output symbol table...')
out_path = '/workspace/boot_unpacked/kallsyms.txt'
with open(out_path, 'w') as f:
    for i in range(num_syms):
        f.write(f'0x{syms[i]:016x} {names[i]}\n')
print(f'  Wrote {num_syms} symbols to {out_path}')

# === Step 8: Find key functions ===
print(f'\n[8] Key function addresses:')
key_funcs = ['_text', 'stext', 'start_kernel', 'paging_init',
             '__primary_switch', '__primary_switched',
             '__create_page_tables', 'setup_arch', 'rest_init',
             'kernel_init', 'panic', 'printk', 'dump_stack',
             'cpu_resume', 'secondary_startup']
sym_map = {}
for i in range(num_syms):
    sym_map[names[i]] = syms[i]
for fn in key_funcs:
    if fn in sym_map:
        addr = sym_map[fn]
        file_off = addr - 0xffff800010000000  # rough; ignores KASLR slide
        # Adjust for the fact that stext is at file_offset 0x2180000 but vaddr
        # is 0xffff800012180000. So file_off = vaddr - 0xffff800010000000.
        print(f'  {fn:<24s} 0x{addr:016x}  (file_off ~0x{file_off:x})')
    else:
        print(f'  {fn:<24s} (not in symbol table)')

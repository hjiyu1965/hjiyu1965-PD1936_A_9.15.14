#!/usr/bin/env python3
"""Categorize and analyze vivo custom driver symbols."""
import re
import subprocess
from collections import defaultdict

# Load symbol table via llvm-objdump
result = subprocess.run(['/root/.swiftly/bin/llvm-objdump', '--syms', '/workspace/boot_unpacked/kernel.elf'],
                       capture_output=True, text=True)
all_syms = []
for line in result.stdout.splitlines():
    # ffffff800a200558 T start_kernel   OR
    # ffffff800a200558 l     F .kernel 0000000000000000 start_kernel
    parts = line.split()
    if len(parts) < 4:
        continue
    try:
        addr = int(parts[0], 16)
    except ValueError:
        continue
    flags = parts[1]
    name = parts[-1]
    all_syms.append((addr, flags, name))

print(f'Total symbols: {len(all_syms)}')

# Filter vendor symbols by prefix
vendor_prefixes = ['vivo_', 'rsc_', 'bbk_', 'ftm_', 'iwifi_', 'longcheer_',
                   'oplus_', 'oppo_', 'huawei_', 'samsung_', 'vdev_', 'v_',
                   'vivo-', 'longcheer-', 'ftm-', 'qwerty_']
vendor_syms = [(a, f, n) for a, f, n in all_syms
               if any(n.startswith(p) or n.lower().startswith(p.lower())
                      for p in vendor_prefixes)]

# Group by prefix
groups = defaultdict(list)
for addr, flags, name in vendor_syms:
    for p in vendor_prefixes:
        if name.startswith(p):
            groups[p].append((addr, flags, name))
            break

print('\n=== Vendor symbols by prefix ===')
for p in sorted(groups.keys(), key=lambda x: -len(groups[x])):
    print(f'  {p:<14s} {len(groups[p]):4d} symbols')

# Vivo symbols: categorize by subsystem
print('\n\n=== vivo_* symbols by subsystem ===')
vivo_subsystems = defaultdict(list)
for addr, flags, name in groups['vivo_']:
    # Determine subsystem from name
    if name.startswith('vivo_wdt'):
        sub = 'watchdog'        # vivo_wdt_monitor_*
    elif name.startswith('vivo_touch') or name.startswith('vivo_ts_'):
        sub = 'touchscreen'     # vivo_touchscreen_*, vivo_ts_*
    elif name.startswith('vivo_display') or name.startswith('vivo_smart_aod') or name.startswith('vivo_panel'):
        sub = 'display'         # vivo_display_*, vivo_smart_aod_*
    elif name.startswith('vivo_board'):
        sub = 'board_info'      # vivo_board_id, vivo_board_name
    elif name.startswith('vivo_cpu'):
        sub = 'cpu'             # vivo_cpu_freq, vivo_cpu_type
    elif name.startswith('vivo_hall'):
        sub = 'hall_sensor'     # vivo_hall_*
    elif name.startswith('vivo_intf'):
        sub = 'interface'       # vivo_intf_*
    elif name.startswith('vivo_vib'):
        sub = 'vibrator'        # vivo_vib_*
    elif name.startswith('vivo_ud_flag'):
        sub = 'ud_flag'         # vivo_ud_flag_set (under-display)
    elif name.startswith('vivo_fg_custom'):
        sub = 'fuel_gauge'      # vivo_fg_custom_parse_table
    elif name.startswith('vivo_set_chg'):
        sub = 'charger'         # vivo_set_chg_term_current
    elif name.startswith('vivo_get'):
        sub = 'getter'
    elif name.startswith('vivo_show'):
        sub = 'sysfs_attr'
    elif name.startswith('vivo_snd'):
        sub = 'audio'
    elif name.startswith('vivo_sre'):
        sub = 'sre'             # vivo_sre_check_enable (security)
    elif name.startswith('vivo_key'):
        sub = 'key'
    elif name.startswith('vivo_hung_task'):
        sub = 'hung_task'
    elif name.startswith('vivo_exception'):
        sub = 'exception'
    elif name.startswith('vivo_ddrinfo'):
        sub = 'ddr'
    elif name.startswith('vivo_clear_before_ts_load_usb_charger'):
        sub = 'usb_charger'
    elif name.startswith('vivo_notifier'):
        sub = 'notifier'
    elif name.startswith('vivo_rsc'):
        sub = 'rsc_bridge'      # vivo_rsc - bridge to rsc subsystem
    else:
        sub = 'misc'
    vivo_subsystems[sub].append((addr, flags, name))

for sub in sorted(vivo_subsystems.keys(), key=lambda x: -len(vivo_subsystems[x])):
    syms_in_sub = vivo_subsystems[sub]
    print(f'\n  [{sub}] ({len(syms_in_sub)} symbols)')
    for addr, fl, nm in sorted(syms_in_sub)[:10]:
        print(f'    0x{addr:016x}  {nm}')
    if len(syms_in_sub) > 10:
        print(f'    ... +{len(syms_in_sub)-10} more')

# rsc_ symbols: categorize
print('\n\n=== rsc_* symbols by subsystem ===')
rsc_subsystems = defaultdict(list)
for addr, flags, name in groups['rsc_']:
    if name.startswith('rsc_app_boost') or name.startswith('rsc_appboost'):
        sub = 'app_boost'
    elif name.startswith('rsc_boost'):
        sub = 'boost'
    elif name.startswith('rsc_block_chain'):
        sub = 'block_chain'
    elif name.startswith('rsc_blur'):
        sub = 'blur'
    elif name.startswith('rsc_cow'):
        sub = 'cow'             # copy-on-write
    elif name.startswith('rsc_ion') or name.startswith('rsc_zs') or name.startswith('rsc_atomic'):
        sub = 'memory'
    elif name.startswith('rsc_big') or name.startswith('rsc_cluster') or name.startswith('rsc_cpu'):
        sub = 'cpu_topology'
    elif name.startswith('rsc_cgroup'):
        sub = 'cgroup'
    elif name.startswith('rsc_check') or name.startswith('rsc_chown'):
        sub = 'security'
    elif name.startswith('rsc_lpm') or name.startswith('rsc_clear_lpm'):
        sub = 'lpm'
    elif name.startswith('rsc_suspend') or name.startswith('rsc_resume'):
        sub = 'suspend'
    elif name.startswith('rsc_alloc'):
        sub = 'alloc'
    elif re.match(r'rsc_\d+_system_(cnt|time)', name):
        sub = 'system_counter'
    elif name.startswith('rsc_seq'):
        sub = 'seq_buf'
    elif name.startswith('rsc_wait'):
        sub = 'wait'
    elif name.startswith('rsc_aud') or name.startswith('rsc_snd'):
        sub = 'audio'
    elif name.startswith('rsc_cam') or name.startswith('rsc_jpeg'):
        sub = 'camera'
    else:
        sub = 'misc'
    rsc_subsystems[sub].append((addr, flags, name))

for sub in sorted(rsc_subsystems.keys(), key=lambda x: -len(rsc_subsystems[x])):
    syms_in_sub = rsc_subsystems[sub]
    print(f'\n  [{sub}] ({len(syms_in_sub)} symbols)')
    for addr, fl, nm in sorted(syms_in_sub)[:8]:
        print(f'    0x{addr:016x}  {nm}')
    if len(syms_in_sub) > 8:
        print(f'    ... +{len(syms_in_sub)-8} more')

# bbk_ symbols
print('\n\n=== bbk_* symbols by subsystem ===')
bbk_subsystems = defaultdict(list)
for addr, flags, name in groups['bbk_']:
    if name.startswith('bbk_chipone'):
        sub = 'ts_chipone'      # Chipone touchscreen
    elif name.startswith('bbk_goodix') or name.startswith('bbk_gdix'):
        sub = 'ts_goodix'       # Goodix touchscreen
    elif name.startswith('bbk_focaltech'):
        sub = 'ts_focaltech'
    elif name.startswith('bbk_syna'):
        sub = 'ts_synaptics'
    elif name.startswith('bbk_driver'):
        sub = 'driver_framework'
    elif name.startswith('bbk_fw') or 'fw_update' in name or 'fwu' in name:
        sub = 'firmware_update'
    elif name.startswith('bbk_board'):
        sub = 'board'
    elif name.startswith('bbk_devices'):
        sub = 'devices'
    elif name.startswith('bbk_get') or name.startswith('bbk_set'):
        sub = 'getset'
    elif 'gesture' in name:
        sub = 'gesture'
    elif 'rawordiff' in name or 'jitter' in name or 'channel_comp' in name:
        sub = 'ts_debug'
    else:
        sub = 'misc'
    bbk_subsystems[sub].append((addr, flags, name))

for sub in sorted(bbk_subsystems.keys(), key=lambda x: -len(bbk_subsystems[x])):
    syms_in_sub = bbk_subsystems[sub]
    print(f'\n  [{sub}] ({len(syms_in_sub)} symbols)')
    for addr, fl, nm in sorted(syms_in_sub)[:6]:
        print(f'    0x{addr:016x}  {nm}')
    if len(syms_in_sub) > 6:
        print(f'    ... +{len(syms_in_sub)-6} more')

# Save full list
with open('/workspace/boot_unpacked/vendor_symbols.txt', 'w') as f:
    f.write('# Vendor symbols (vivo_, rsc_, bbk_)\n')
    f.write(f'# Total: {len(vendor_syms)}\n\n')
    for prefix in ['vivo_', 'rsc_', 'bbk_', 'ftm_', 'samsung_']:
        if prefix in groups:
            f.write(f'\n===== {prefix} =====\n')
            for addr, fl, nm in sorted(groups[prefix]):
                f.write(f'0x{addr:016x}  {nm}\n')

print('\n\nFull list saved to vendor_symbols.txt')

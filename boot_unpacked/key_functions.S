
kernel.elf:	file format elf64-littleaarch64

Disassembly of section .kernel:

ffffff80094a3288 <rest_init>:
ffffff80094a3288:      	stp	x29, x30, [sp, #-0x20]!
ffffff80094a328c:      	stp	x20, x19, [sp, #0x10]
ffffff80094a3290:      	mov	x29, sp
ffffff80094a3294:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a3298:      	adrp	x1, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a329c:      	add	x0, x0, #0xd8f
ffffff80094a32a0:      	add	x1, x1, #0xd99
ffffff80094a32a4:      	bl	0xffffff800834e780 <kstep_log>
ffffff80094a32a8:      	bl	0xffffff80081640e8 <rcu_scheduler_starting>
ffffff80094a32ac:      	adrp	x0, 0xffffff80094a3000 <device_node_gen_full_name+0x108>
ffffff80094a32b0:      	mov	x1, xzr
ffffff80094a32b4:      	add	x0, x0, #0x380
ffffff80094a32b8:      	mov	w2, #0x200      // =512
ffffff80094a32bc:      	bl	0xffffff80080bbf08 <kernel_thread>
ffffff80094a32c0:      	mrs	x20, SP_EL0
ffffff80094a32c4:      	ldr	w8, [x20, #0x4f0]
ffffff80094a32c8:      	adrp	x19, 0xffffff800a832000 <event_signal_generate+0x78>
ffffff80094a32cc:      	add	x19, x19, #0x9a8
ffffff80094a32d0:      	mov	x1, x19
ffffff80094a32d4:      	add	w8, w8, #0x1
ffffff80094a32d8:      	str	w8, [x20, #0x4f0]
ffffff80094a32dc:      	bl	0xffffff80080e8468 <find_task_by_pid_ns>
ffffff80094a32e0:      	adrp	x9, 0xffffff800a555000 <bp_hardening_data>
ffffff80094a32e4:      	mrs	x8, TPIDR_EL1
ffffff80094a32e8:      	add	x9, x9, #0x18
ffffff80094a32ec:      	adrp	x10, 0xffffff8009609000 <str__cpuhp__trace_system_name+0x4>
ffffff80094a32f0:      	ldr	w8, [x8, x9]
ffffff80094a32f4:      	add	x10, x10, #0x8
ffffff80094a32f8:      	and	x9, x8, #0x3f
ffffff80094a32fc:      	lsr	x8, x8, #3
ffffff80094a3300:      	and	x8, x8, #0x1ffffff8
ffffff80094a3304:      	add	x9, x10, x9, lsl #3
ffffff80094a3308:      	sub	x8, x9, x8
ffffff80094a330c:      	add	x1, x8, #0x8
ffffff80094a3310:      	bl	0xffffff80080fbb98 <set_cpus_allowed_ptr>
ffffff80094a3314:      	bl	0xffffff800815e1c0 <__rcu_read_unlock>
ffffff80094a3318:      	adrp	x0, 0xffffff80080ea000 <kernel_param_unlock+0x20>
ffffff80094a331c:      	mov	x1, xzr
ffffff80094a3320:      	add	x0, x0, #0xf30
ffffff80094a3324:      	mov	w2, #0x600      // =1536
ffffff80094a3328:      	bl	0xffffff80080bbf08 <kernel_thread>
ffffff80094a332c:      	ldr	w8, [x20, #0x4f0]
ffffff80094a3330:      	mov	x1, x19
ffffff80094a3334:      	add	w8, w8, #0x1
ffffff80094a3338:      	str	w8, [x20, #0x4f0]
ffffff80094a333c:      	bl	0xffffff80080e8468 <find_task_by_pid_ns>
ffffff80094a3340:      	adrp	x8, 0xffffff800aac9000 <unbound_pool_hash+0xb8>
ffffff80094a3344:      	str	x0, [x8, #0x190]
ffffff80094a3348:      	bl	0xffffff800815e1c0 <__rcu_read_unlock>
ffffff80094a334c:      	adrp	x0, 0xffffff800a2d3000 <boot_command_line+0xfff>
ffffff80094a3350:      	adrp	x8, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff80094a3354:      	mov	w9, #0x1        // =1
ffffff80094a3358:      	add	x0, x0, #0x10
ffffff80094a335c:      	str	w9, [x8, #0xf80]
ffffff80094a3360:      	bl	0xffffff800812ef50 <complete>
ffffff80094a3364:      	bl	0xffffff80094aca30 <schedule_preempt_disabled>
ffffff80094a3368:      	mov	w0, #0xca       // =202
ffffff80094a336c:      	bl	0xffffff800812f570 <cpu_startup_entry>
ffffff80094a3370:      	ldp	x20, x19, [sp, #0x10]
ffffff80094a3374:      	ldp	x29, x30, [sp], #0x20
ffffff80094a3378:      	ret
ffffff80094a337c:      	nop

ffffff80094a3380 <kernel_init>:
ffffff80094a3380:      	stp	x29, x30, [sp, #-0x20]!
ffffff80094a3384:      	stp	x20, x19, [sp, #0x10]
ffffff80094a3388:      	mov	x29, sp
ffffff80094a338c:      	bl	0xffffff800a201540 <kernel_init_freeable>
ffffff80094a3390:      	bl	0xffffff80080eee98 <async_synchronize_full>
ffffff80094a3394:      	bl	0xffffff80080a7c48 <free_initmem>
ffffff80094a3398:      	adrp	x8, 0xffffff800a0f8000 <iw_priv_type_size+0x7a7>
ffffff80094a339c:      	ldrb	w8, [x8, #0xab5]
ffffff80094a33a0:      	cbz	w8, 0xffffff80094a33b0 <kernel_init+0x30>
ffffff80094a33a4:      	bl	0xffffff8008163760 <rcu_barrier_sched>
ffffff80094a33a8:      	bl	0xffffff80080a94a8 <mark_rodata_ro>
ffffff80094a33ac:      	b	0xffffff80094a33bc <kernel_init+0x3c>
ffffff80094a33b0:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a33b4:      	add	x0, x0, #0xefc
ffffff80094a33b8:      	bl	0xffffff800814dca8 <printk>
ffffff80094a33bc:      	adrp	x8, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff80094a33c0:      	mov	w9, #0x2        // =2
ffffff80094a33c4:      	str	w9, [x8, #0xf80]
ffffff80094a33c8:      	bl	0xffffff800815e180 <rcu_end_inkernel_boot>
ffffff80094a33cc:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a33d0:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff80094a33d4:      	mov	w9, #0x1        // =1
ffffff80094a33d8:      	add	x0, x0, #0xda3
ffffff80094a33dc:      	str	w9, [x8, #0x94]
ffffff80094a33e0:      	bl	0xffffff800834e780 <kstep_log>
ffffff80094a33e4:      	bl	0xffffff8008169330 <vivo_wdt_monitor_stop>
ffffff80094a33e8:      	adrp	x20, 0xffffff800aabc000 <bsp_test_mode>
ffffff80094a33ec:      	adrp	x19, 0xffffff800a81e000 <inet6_offloads+0x2a0>
ffffff80094a33f0:      	add	x19, x19, #0xa28
ffffff80094a33f4:      	ldr	x0, [x20, #0xb8]
ffffff80094a33f8:      	cbz	x0, 0xffffff80094a342c <kernel_init+0xac>
ffffff80094a33fc:      	str	x0, [x19]
ffffff80094a3400:      	bl	0xffffff80082b8898 <getname_kernel>
ffffff80094a3404:      	adrp	x2, 0xffffff800a81e000 <inet6_offloads+0x2a0>
ffffff80094a3408:      	mov	x1, x19
ffffff80094a340c:      	add	x2, x2, #0x908
ffffff80094a3410:      	bl	0xffffff80082b59d8 <do_execve>
ffffff80094a3414:      	cbz	w0, 0xffffff80094a3454 <kernel_init+0xd4>
ffffff80094a3418:      	mov	w2, w0
ffffff80094a341c:      	ldr	x1, [x20, #0xb8]
ffffff80094a3420:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a3424:      	add	x0, x0, #0xdb5
ffffff80094a3428:      	bl	0xffffff800814dca8 <printk>
ffffff80094a342c:      	adrp	x20, 0xffffff800aabc000 <bsp_test_mode>
ffffff80094a3430:      	ldr	x0, [x20, #0xb0]
ffffff80094a3434:      	cbz	x0, 0xffffff80094a3464 <kernel_init+0xe4>
ffffff80094a3438:      	str	x0, [x19]
ffffff80094a343c:      	bl	0xffffff80082b8898 <getname_kernel>
ffffff80094a3440:      	adrp	x2, 0xffffff800a81e000 <inet6_offloads+0x2a0>
ffffff80094a3444:      	mov	x1, x19
ffffff80094a3448:      	add	x2, x2, #0x908
ffffff80094a344c:      	bl	0xffffff80082b59d8 <do_execve>
ffffff80094a3450:      	cbnz	w0, 0xffffff80094a3580 <kernel_init+0x200>
ffffff80094a3454:      	ldp	x20, x19, [sp, #0x10]
ffffff80094a3458:      	mov	w0, wzr
ffffff80094a345c:      	ldp	x29, x30, [sp], #0x20
ffffff80094a3460:      	ret
ffffff80094a3464:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a3468:      	add	x0, x0, #0xdfd
ffffff80094a346c:      	str	x0, [x19]
ffffff80094a3470:      	bl	0xffffff80082b8898 <getname_kernel>
ffffff80094a3474:      	adrp	x2, 0xffffff800a81e000 <inet6_offloads+0x2a0>
ffffff80094a3478:      	mov	x1, x19
ffffff80094a347c:      	add	x2, x2, #0x908
ffffff80094a3480:      	bl	0xffffff80082b59d8 <do_execve>
ffffff80094a3484:      	cmn	w0, #0x2
ffffff80094a3488:      	b.eq	0xffffff80094a34a8 <kernel_init+0x128>
ffffff80094a348c:      	mov	w2, w0
ffffff80094a3490:      	cbz	w0, 0xffffff80094a3454 <kernel_init+0xd4>
ffffff80094a3494:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a3498:      	adrp	x1, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a349c:      	add	x0, x0, #0xf22
ffffff80094a34a0:      	add	x1, x1, #0xdfd
ffffff80094a34a4:      	bl	0xffffff800814dca8 <printk>
ffffff80094a34a8:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a34ac:      	add	x0, x0, #0xe08
ffffff80094a34b0:      	str	x0, [x19]
ffffff80094a34b4:      	bl	0xffffff80082b8898 <getname_kernel>
ffffff80094a34b8:      	adrp	x2, 0xffffff800a81e000 <inet6_offloads+0x2a0>
ffffff80094a34bc:      	mov	x1, x19
ffffff80094a34c0:      	add	x2, x2, #0x908
ffffff80094a34c4:      	bl	0xffffff80082b59d8 <do_execve>
ffffff80094a34c8:      	cmn	w0, #0x2
ffffff80094a34cc:      	b.eq	0xffffff80094a34ec <kernel_init+0x16c>
ffffff80094a34d0:      	mov	w2, w0
ffffff80094a34d4:      	cbz	w0, 0xffffff80094a3454 <kernel_init+0xd4>
ffffff80094a34d8:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a34dc:      	adrp	x1, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a34e0:      	add	x0, x0, #0xf22
ffffff80094a34e4:      	add	x1, x1, #0xe08
ffffff80094a34e8:      	bl	0xffffff800814dca8 <printk>
ffffff80094a34ec:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a34f0:      	add	x0, x0, #0xe12
ffffff80094a34f4:      	str	x0, [x19]
ffffff80094a34f8:      	bl	0xffffff80082b8898 <getname_kernel>
ffffff80094a34fc:      	adrp	x2, 0xffffff800a81e000 <inet6_offloads+0x2a0>
ffffff80094a3500:      	mov	x1, x19
ffffff80094a3504:      	add	x2, x2, #0x908
ffffff80094a3508:      	bl	0xffffff80082b59d8 <do_execve>
ffffff80094a350c:      	cmn	w0, #0x2
ffffff80094a3510:      	b.eq	0xffffff80094a3530 <kernel_init+0x1b0>
ffffff80094a3514:      	mov	w2, w0
ffffff80094a3518:      	cbz	w0, 0xffffff80094a3454 <kernel_init+0xd4>
ffffff80094a351c:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a3520:      	adrp	x1, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a3524:      	add	x0, x0, #0xf22
ffffff80094a3528:      	add	x1, x1, #0xe12
ffffff80094a352c:      	bl	0xffffff800814dca8 <printk>
ffffff80094a3530:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a3534:      	add	x0, x0, #0xe1c
ffffff80094a3538:      	str	x0, [x19]
ffffff80094a353c:      	bl	0xffffff80082b8898 <getname_kernel>
ffffff80094a3540:      	adrp	x2, 0xffffff800a81e000 <inet6_offloads+0x2a0>
ffffff80094a3544:      	mov	x1, x19
ffffff80094a3548:      	add	x2, x2, #0x908
ffffff80094a354c:      	bl	0xffffff80082b59d8 <do_execve>
ffffff80094a3550:      	cbz	w0, 0xffffff80094a3454 <kernel_init+0xd4>
ffffff80094a3554:      	mov	w2, w0
ffffff80094a3558:      	cmn	w0, #0x2
ffffff80094a355c:      	b.eq	0xffffff80094a3574 <kernel_init+0x1f4>
ffffff80094a3560:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a3564:      	adrp	x1, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a3568:      	add	x0, x0, #0xf22
ffffff80094a356c:      	add	x1, x1, #0xe1c
ffffff80094a3570:      	bl	0xffffff800814dca8 <printk>
ffffff80094a3574:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a3578:      	add	x0, x0, #0xe24
ffffff80094a357c:      	bl	0xffffff80080bd118 <panic>
ffffff80094a3580:      	mov	w2, w0
ffffff80094a3584:      	ldr	x1, [x20, #0xb0]
ffffff80094a3588:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff80094a358c:      	add	x0, x0, #0xdd8
ffffff80094a3590:      	bl	0xffffff80080bd118 <panic>
ffffff80094a3594:      	udf	#0x0

ffffff80094b91f0 <__enable_mmu>:
ffffff80094b91f0:      	mrs	x2, ID_AA64MMFR0_EL1
ffffff80094b91f4:      	ubfx	x2, x2, #28, #4
ffffff80094b91f8:      	cmp	x2, #0x0
ffffff80094b91fc:      	b.ne	0xffffff80094b924c <__no_granule_support>
ffffff80094b9200:      	mov	x3, #0x0        // =0
ffffff80094b9204:      	adrp	x2, 0xffffff800aab8000 <__mmuoff_data_start>
ffffff80094b9208:      	add	x2, x2, #0x8
ffffff80094b920c:      	str	x3, [x2]
ffffff80094b9210:      	dmb	sy
ffffff80094b9214:      	dc	ivac, x2
ffffff80094b9218:      	adrp	x2, 0xffffff800a18a000 <__stop_notes+0x618>
ffffff80094b921c:      	mov	x1, x1
ffffff80094b9220:      	mov	x2, x2
ffffff80094b9224:      	msr	TTBR0_EL1, x2
ffffff80094b9228:      	msr	TTBR1_EL1, x1
ffffff80094b922c:      	isb
ffffff80094b9230:      	msr	SCTLR_EL1, x0
ffffff80094b9234:      	isb
ffffff80094b9238:      	ic	iallu
ffffff80094b923c:      	dsb	nsh
ffffff80094b9240:      	isb
ffffff80094b9244:      	ret

ffffff80094b92b8 <__primary_switch>:
ffffff80094b92b8:      	mov	x19, x0
ffffff80094b92bc:      	mrs	x20, SCTLR_EL1
ffffff80094b92c0:      	adrp	x1, 0xffffff800b5ed000 <__bss_rtic_start>
ffffff80094b92c4:      	bl	0xffffff80094b91f0 <__enable_mmu>
ffffff80094b92c8:      	bl	0xffffff80094b9270 <__relocate_kernel>
ffffff80094b92cc:      	ldr	x8, 0xffffff80094b9328 <__primary_switch+0x70>
ffffff80094b92d0:      	adrp	x0, 0xffffff8008000000
ffffff80094b92d4:      	blr	x8
ffffff80094b92d8:      	isb
ffffff80094b92dc:      	msr	SCTLR_EL1, x20
ffffff80094b92e0:      	isb
ffffff80094b92e4:      	bl	0xffffff800a200040 <__create_page_tables>
ffffff80094b92e8:      	tlbi	vmalle1
ffffff80094b92ec:      	dsb	nsh
ffffff80094b92f0:      	msr	SCTLR_EL1, x19
ffffff80094b92f4:      	isb
ffffff80094b92f8:      	ic	iallu
ffffff80094b92fc:      	dsb	nsh
ffffff80094b9300:      	isb
ffffff80094b9304:      	bl	0xffffff80094b9270 <__relocate_kernel>
ffffff80094b9308:      	ldr	x8, 0xffffff80094b9328 <__primary_switch+0x70>
ffffff80094b930c:      	adrp	x0, 0xffffff8008000000
ffffff80094b9310:      	br	x8
ffffff80094b9314:      	<unknown>
ffffff80094b9318:      	<unknown>
		...

ffffff80094b9330 <cpu_resume>:
ffffff80094b9330:      	bl	0xffffff80094b9008 <el2_setup>
ffffff80094b9334:      	bl	0xffffff80094b956c <__cpu_setup>
ffffff80094b9338:      	adrp	x1, 0xffffff800a18f000 <__stop_notes+0x5618>
ffffff80094b933c:      	bl	0xffffff80094b91f0 <__enable_mmu>
ffffff80094b9340:      	ldr	x8, 0xffffff80094b9348 <cpu_resume+0x18>
ffffff80094b9344:      	br	x8
		...

ffffff800a200000 <stext>:
ffffff800a200000:      	bl	0xffffff800a200020 <preserve_boot_args>
ffffff800a200004:      	bl	0xffffff80094b9008 <el2_setup>
ffffff800a200008:      	adrp	x23, 0xffffff8008000000
ffffff800a20000c:      	and	x23, x23, #0x1fffff
ffffff800a200010:      	bl	0xffffff80094b913c <set_cpu_boot_mode_flag>
ffffff800a200014:      	bl	0xffffff800a200040 <__create_page_tables>
ffffff800a200018:      	bl	0xffffff80094b956c <__cpu_setup>
ffffff800a20001c:      	b	0xffffff80094b92b8 <__primary_switch>

ffffff800a200040 <__create_page_tables>:
ffffff800a200040:      	mov	x28, x30
ffffff800a200044:      	adrp	x0, 0xffffff800b5ed000 <__bss_rtic_start>
ffffff800a200048:      	adrp	x1, 0xffffff800b5f0000 <__bss_rtic_start+0x3000>
ffffff800a20004c:      	sub	x1, x1, x0
ffffff800a200050:      	bl	0xffffff80080a7fb4 <__pi___inval_dcache_area>
ffffff800a200054:      	adrp	x0, 0xffffff800b5ed000 <__bss_rtic_start>
ffffff800a200058:      	adrp	x1, 0xffffff800b5f0000 <__bss_rtic_start+0x3000>
ffffff800a20005c:      	sub	x1, x1, x0
ffffff800a200060:      	stp	xzr, xzr, [x0], #0x10
ffffff800a200064:      	stp	xzr, xzr, [x0], #0x10
ffffff800a200068:      	stp	xzr, xzr, [x0], #0x10
ffffff800a20006c:      	stp	xzr, xzr, [x0], #0x10
ffffff800a200070:      	subs	x1, x1, #0x40
ffffff800a200074:      	b.ne	0xffffff800a200060 <__create_page_tables+0x20>
ffffff800a200078:      	mov	x7, #0x711      // =1809
ffffff800a20007c:      	adrp	x0, 0xffffff800a18a000 <__stop_notes+0x618>
ffffff800a200080:      	adrp	x3, 0xffffff80094b9000 <kimage_vaddr>
ffffff800a200084:      	adrp	x5, 0xffffff80094b9000 <kimage_vaddr>
ffffff800a200088:      	clz	x5, x5
ffffff800a20008c:      	cmp	x5, #0x19
ffffff800a200090:      	b.ge	0xffffff800a2000c0 <__create_page_tables+0x80>
ffffff800a200094:      	adrp	x6, 0xffffff800a825000 <armv8_event_attr_stall_frontend>
ffffff800a200098:      	add	x6, x6, #0xa30
ffffff800a20009c:      	str	x5, [x6]
ffffff800a2000a0:      	dmb	sy
ffffff800a2000a4:      	dc	ivac, x6
ffffff800a2000a8:      	lsr	x5, x3, #39
ffffff800a2000ac:      	and	x5, x5, #0x1ff
ffffff800a2000b0:      	add	x6, x0, #0x1, lsl #12 // =0x1000
ffffff800a2000b4:      	orr	x6, x6, #0x3
ffffff800a2000b8:      	str	x6, [x0, x5, lsl #3]
ffffff800a2000bc:      	add	x0, x0, #0x1, lsl #12 // =0x1000
ffffff800a2000c0:      	lsr	x5, x3, #30
ffffff800a2000c4:      	and	x5, x5, #0x1ff
ffffff800a2000c8:      	add	x6, x0, #0x1, lsl #12 // =0x1000
ffffff800a2000cc:      	orr	x6, x6, #0x3
ffffff800a2000d0:      	str	x6, [x0, x5, lsl #3]
ffffff800a2000d4:      	add	x0, x0, #0x1, lsl #12 // =0x1000
ffffff800a2000d8:      	mov	x5, x3
ffffff800a2000dc:      	adrp	x6, 0xffffff80094b9000 <kimage_vaddr>
ffffff800a2000e0:      	add	x6, x6, #0x5f0
ffffff800a2000e4:      	lsr	x3, x3, #21
ffffff800a2000e8:      	lsr	x5, x5, #21
ffffff800a2000ec:      	and	x5, x5, #0x1ff
ffffff800a2000f0:      	orr	x3, x7, x3, lsl #21
ffffff800a2000f4:      	lsr	x6, x6, #21
ffffff800a2000f8:      	and	x6, x6, #0x1ff
ffffff800a2000fc:      	str	x3, [x0, x5, lsl #3]
ffffff800a200100:      	add	x5, x5, #0x1
ffffff800a200104:      	add	x3, x3, #0x200, lsl #12 // =0x200000
ffffff800a200108:      	cmp	x5, x6
ffffff800a20010c:      	b.ls	0xffffff800a2000fc <__create_page_tables+0xbc>
ffffff800a200110:      	adrp	x0, 0xffffff800b5ed000 <__bss_rtic_start>
ffffff800a200114:      	mov	x5, #-0x7f00000001 // =-545460846593
ffffff800a200118:      	movk	x5, #0x808, lsl #16
ffffff800a20011c:      	movk	x5, #0x0
ffffff800a200120:      	add	x5, x5, x23
ffffff800a200124:      	lsr	x3, x5, #30
ffffff800a200128:      	and	x3, x3, #0x1ff
ffffff800a20012c:      	add	x6, x0, #0x1, lsl #12 // =0x1000
ffffff800a200130:      	orr	x6, x6, #0x3
ffffff800a200134:      	str	x6, [x0, x3, lsl #3]
ffffff800a200138:      	add	x0, x0, #0x1, lsl #12 // =0x1000
ffffff800a20013c:      	adrp	x6, 0xffffff800b5f0000 <__bss_rtic_start+0x3000>
ffffff800a200140:      	adrp	x3, 0xffffff8008080000 <_text>
ffffff800a200144:      	sub	x6, x6, x3
ffffff800a200148:      	add	x6, x6, x5
ffffff800a20014c:      	lsr	x3, x3, #21
ffffff800a200150:      	lsr	x5, x5, #21
ffffff800a200154:      	and	x5, x5, #0x1ff
ffffff800a200158:      	orr	x3, x7, x3, lsl #21
ffffff800a20015c:      	lsr	x6, x6, #21
ffffff800a200160:      	and	x6, x6, #0x1ff
ffffff800a200164:      	str	x3, [x0, x5, lsl #3]
ffffff800a200168:      	add	x5, x5, #0x1
ffffff800a20016c:      	add	x3, x3, #0x200, lsl #12 // =0x200000
ffffff800a200170:      	cmp	x5, x6
ffffff800a200174:      	b.ls	0xffffff800a200164 <__create_page_tables+0x124>
ffffff800a200178:      	adrp	x0, 0xffffff800a18a000 <__stop_notes+0x618>
ffffff800a20017c:      	adrp	x1, 0xffffff800b5f0000 <__bss_rtic_start+0x3000>
ffffff800a200180:      	sub	x1, x1, x0
ffffff800a200184:      	dmb	sy
ffffff800a200188:      	bl	0xffffff80080a7fb4 <__pi___inval_dcache_area>
ffffff800a20018c:      	ret	x28

ffffff800a200190 <__primary_switched>:
ffffff800a200190:      	adrp	x4, 0xffffff800a800000 <init_thread_union>
ffffff800a200194:      	add	sp, x4, #0x4, lsl #12 // =0x4000
ffffff800a200198:      	adrp	x5, 0xffffff800a81f000 <init_signals+0x280>
ffffff800a20019c:      	add	x5, x5, #0xa00
ffffff800a2001a0:      	msr	SP_EL0, x5
ffffff800a2001a4:      	adrp	x8, 0xffffff8008082000 <vectors>
ffffff800a2001a8:      	add	x8, x8, #0x0
ffffff800a2001ac:      	msr	VBAR_EL1, x8
ffffff800a2001b0:      	isb
ffffff800a2001b4:      	stp	xzr, x30, [sp, #-0x10]!
ffffff800a2001b8:      	mov	x29, sp
ffffff800a2001bc:      	adrp	x5, 0xffffff800a2d3000 <boot_command_line+0xfff>
ffffff800a2001c0:      	str	x21, [x5, #0x398]
ffffff800a2001c4:      	adrp	x4, 0xffffff80094b9000 <kimage_vaddr>
ffffff800a2001c8:      	ldr	x4, [x4]
ffffff800a2001cc:      	sub	x4, x4, x0
ffffff800a2001d0:      	adrp	x5, 0xffffff800a0f8000 <iw_priv_type_size+0x7a7>
ffffff800a2001d4:      	str	x4, [x5, #0xb80]
ffffff800a2001d8:      	adrp	x0, 0xffffff800aab8000 <__mmuoff_data_start>
ffffff800a2001dc:      	add	x0, x0, #0x800
ffffff800a2001e0:      	mov	x1, xzr
ffffff800a2001e4:      	adrp	x2, 0xffffff800b5ed000 <__bss_rtic_start>
ffffff800a2001e8:      	add	x2, x2, #0x0
ffffff800a2001ec:      	sub	x2, x2, x0
ffffff800a2001f0:      	bl	0xffffff800948d800 <memset>
ffffff800a2001f4:      	dsb	ishst
ffffff800a2001f8:      	tst	x23, #0xffffffffffe00000
ffffff800a2001fc:      	b.ne	0xffffff800a200218 <__primary_switched+0x88>
ffffff800a200200:      	mov	x0, x21
ffffff800a200204:      	bl	0xffffff800a2079a8 <kaslr_early_init>
ffffff800a200208:      	cbz	x0, 0xffffff800a200218 <__primary_switched+0x88>
ffffff800a20020c:      	orr	x23, x23, x0
ffffff800a200210:      	ldp	x29, x30, [sp], #0x10
ffffff800a200214:      	ret
ffffff800a200218:      	add	sp, sp, #0x10
ffffff800a20021c:      	mov	x29, #0x0       // =0
ffffff800a200220:      	mov	x30, #0x0       // =0
ffffff800a200224:      	b	0xffffff800a200558 <start_kernel>

ffffff800a200558 <start_kernel>:
ffffff800a200558:      	sub	sp, sp, #0x80
ffffff800a20055c:      	stp	x29, x30, [sp, #0x20]
ffffff800a200560:      	add	x29, sp, #0x20
ffffff800a200564:      	str	x27, [sp, #0x30]
ffffff800a200568:      	stp	x26, x25, [sp, #0x40]
ffffff800a20056c:      	stp	x24, x23, [sp, #0x50]
ffffff800a200570:      	stp	x22, x21, [sp, #0x60]
ffffff800a200574:      	stp	x20, x19, [sp, #0x70]
ffffff800a200578:      	adrp	x8, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff800a20057c:      	adrp	x0, 0xffffff800a81f000 <init_signals+0x280>
ffffff800a200580:      	add	x0, x0, #0xa00
ffffff800a200584:      	mov	x21, x30
ffffff800a200588:      	ldr	x8, [x8, #0xf88]
ffffff800a20058c:      	stur	x8, [x29, #-0x8]
ffffff800a200590:      	bl	0xffffff80080b8e68 <set_task_stack_end_magic>
ffffff800a200594:      	bl	0xffffff800a204df8 <smp_setup_processor_id>
ffffff800a200598:      	bl	0xffffff800a219310 <cgroup_init_early>
ffffff800a20059c:      	adrp	x24, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff800a2005a0:      	mov	w8, #0x1        // =1
ffffff800a2005a4:      	msr	DAIFSet, #0x2
ffffff800a2005a8:      	strb	w8, [x24, #0xf85]
ffffff800a2005ac:      	bl	0xffffff800a20bd00 <boot_cpu_init>
ffffff800a2005b0:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a2005b4:      	adrp	x1, 0xffffff8009600000 <__start_rodata>
ffffff800a2005b8:      	add	x0, x0, #0x92c
ffffff800a2005bc:      	add	x1, x1, #0x95
ffffff800a2005c0:      	bl	0xffffff800814dca8 <printk>
ffffff800a2005c4:      	add	x0, sp, #0x8
ffffff800a2005c8:      	bl	0xffffff800a204fe0 <setup_arch>
ffffff800a2005cc:      	ldr	x0, [sp, #0x8]
ffffff800a2005d0:      	bl	0xffffff800a200bd8 <is_at_boot>
ffffff800a2005d4:      	ldr	x19, [sp, #0x8]
ffffff800a2005d8:      	mov	x0, x19
ffffff800a2005dc:      	bl	0xffffff800948db40 <strlen>
ffffff800a2005e0:      	mov	x1, x0
ffffff800a2005e4:      	mov	x0, x19
ffffff800a2005e8:      	bl	0xffffff80086d4180 <add_device_randomness>
ffffff800a2005ec:      	add	x0, sp, #0x10
ffffff800a2005f0:      	mov	w1, #0x8        // =8
ffffff800a2005f4:      	bl	0xffffff80086d5098 <get_random_bytes>
ffffff800a2005f8:      	ldp	x22, x8, [sp, #0x8]
ffffff800a2005fc:      	mov	w9, #0xe00      // =3584
ffffff800a200600:      	adrp	x23, 0xffffff800a2d2000 <parse_early_param.tmp_cmdline+0xfff>
ffffff800a200604:      	movk	w9, #0x4, lsl #16
ffffff800a200608:      	add	x23, x23, #0x1
ffffff800a20060c:      	adrp	x10, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff800a200610:      	mov	x0, x23
ffffff800a200614:      	and	x8, x8, #0xffffffffffffff00
ffffff800a200618:      	mrs	x25, SP_EL0
ffffff800a20061c:      	eor	x8, x8, x9
ffffff800a200620:      	adrp	x9, 0xffffff800a89b000 <event_spf_pte_lock+0x18>
ffffff800a200624:      	add	x9, x9, #0x470
ffffff800a200628:      	str	x8, [x25, #0x658]
ffffff800a20062c:      	str	x8, [x10, #0xf88]
ffffff800a200630:      	str	xzr, [x9, #0x2f0]
ffffff800a200634:      	bl	0xffffff800948db40 <strlen>
ffffff800a200638:      	mov	x20, x0
ffffff800a20063c:      	mov	x0, x22
ffffff800a200640:      	bl	0xffffff800948db40 <strlen>
ffffff800a200644:      	mov	x19, x0
ffffff800a200648:      	mov	x0, x23
ffffff800a20064c:      	bl	0xffffff800948db40 <strlen>
ffffff800a200650:      	adrp	x27, 0xffffff800aca2000 <global_wb_domain+0x20>
ffffff800a200654:      	add	x23, x0, #0x41
ffffff800a200658:      	ldr	w8, [x27, #0x540]
ffffff800a20065c:      	cbz	w8, 0xffffff800a200680 <start_kernel+0x128>
ffffff800a200660:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a200664:      	adrp	x1, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a200668:      	add	x0, x0, #0xcb8
ffffff800a20066c:      	add	x1, x1, #0xcdb
ffffff800a200670:      	mov	x2, x23
ffffff800a200674:      	mov	x3, xzr
ffffff800a200678:      	mov	x4, x21
ffffff800a20067c:      	bl	0xffffff800814dca8 <printk>
ffffff800a200680:      	mov	w4, #-0x1       // =-1
ffffff800a200684:      	mov	x0, x23
ffffff800a200688:      	mov	x1, xzr
ffffff800a20068c:      	mov	x2, xzr
ffffff800a200690:      	mov	x3, xzr
ffffff800a200694:      	bl	0xffffff800a226a68 <memblock_virt_alloc_try_nid>
ffffff800a200698:      	adrp	x26, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20069c:      	str	x0, [x26, #0x88]
ffffff800a2006a0:      	adrp	x0, 0xffffff800a2d2000 <parse_early_param.tmp_cmdline+0xfff>
ffffff800a2006a4:      	add	x0, x0, #0x1
ffffff800a2006a8:      	bl	0xffffff800948db40 <strlen>
ffffff800a2006ac:      	ldr	w8, [x27, #0x540]
ffffff800a2006b0:      	add	x23, x0, #0x41
ffffff800a2006b4:      	cbz	w8, 0xffffff800a2006d8 <start_kernel+0x180>
ffffff800a2006b8:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a2006bc:      	adrp	x1, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a2006c0:      	add	x0, x0, #0xcb8
ffffff800a2006c4:      	add	x1, x1, #0xcdb
ffffff800a2006c8:      	mov	x2, x23
ffffff800a2006cc:      	mov	x3, xzr
ffffff800a2006d0:      	mov	x4, x21
ffffff800a2006d4:      	bl	0xffffff800814dca8 <printk>
ffffff800a2006d8:      	mov	w4, #-0x1       // =-1
ffffff800a2006dc:      	mov	x0, x23
ffffff800a2006e0:      	mov	x1, xzr
ffffff800a2006e4:      	mov	x2, xzr
ffffff800a2006e8:      	mov	x3, xzr
ffffff800a2006ec:      	bl	0xffffff800a226a68 <memblock_virt_alloc_try_nid>
ffffff800a2006f0:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a2006f4:      	str	x0, [x8, #0xc0]
ffffff800a2006f8:      	mov	x0, x22
ffffff800a2006fc:      	bl	0xffffff800948db40 <strlen>
ffffff800a200700:      	ldr	w8, [x27, #0x540]
ffffff800a200704:      	add	x23, x0, #0x41
ffffff800a200708:      	cbz	w8, 0xffffff800a20072c <start_kernel+0x1d4>
ffffff800a20070c:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a200710:      	adrp	x1, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a200714:      	add	x0, x0, #0xcb8
ffffff800a200718:      	add	x1, x1, #0xcdb
ffffff800a20071c:      	mov	x2, x23
ffffff800a200720:      	mov	x3, xzr
ffffff800a200724:      	mov	x4, x21
ffffff800a200728:      	bl	0xffffff800814dca8 <printk>
ffffff800a20072c:      	mov	w4, #-0x1       // =-1
ffffff800a200730:      	mov	x0, x23
ffffff800a200734:      	mov	x1, xzr
ffffff800a200738:      	mov	x2, xzr
ffffff800a20073c:      	mov	x3, xzr
ffffff800a200740:      	bl	0xffffff800a226a68 <memblock_virt_alloc_try_nid>
ffffff800a200744:      	ldr	x8, [x26, #0x88]
ffffff800a200748:      	adrp	x23, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20074c:      	adrp	x1, 0xffffff800a2d2000 <parse_early_param.tmp_cmdline+0xfff>
ffffff800a200750:      	add	x1, x1, #0x1
ffffff800a200754:      	str	x0, [x23, #0x98]
ffffff800a200758:      	mov	x0, x8
ffffff800a20075c:      	bl	0xffffff800949d728 <strcpy>
ffffff800a200760:      	ldr	x0, [x23, #0x98]
ffffff800a200764:      	mov	x1, x22
ffffff800a200768:      	bl	0xffffff800949d728 <strcpy>
ffffff800a20076c:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a200770:      	ldr	w8, [x8, #0x90]
ffffff800a200774:      	cmp	w8, #0x5
ffffff800a200778:      	b.hi	0xffffff800a2007a8 <start_kernel+0x250>
ffffff800a20077c:      	adrp	x9, 0xffffff8009600000 <__start_rodata>
ffffff800a200780:      	adrp	x21, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a200784:      	add	x9, x9, #0x0
ffffff800a200788:      	add	x21, x21, #0xc3b
ffffff800a20078c:      	adr	x10, 0xffffff800a20079c <start_kernel+0x244>
ffffff800a200790:      	ldrb	w11, [x9, x8]
ffffff800a200794:      	add	x10, x10, x11, lsl #2
ffffff800a200798:      	br	x10
ffffff800a20079c:      	adrp	x21, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a2007a0:      	add	x21, x21, #0xc9b
ffffff800a2007a4:      	b	0xffffff800a2007dc <start_kernel+0x284>
ffffff800a2007a8:      	cmp	w8, #0xff
ffffff800a2007ac:      	b.ne	0xffffff800a200804 <start_kernel+0x2ac>
ffffff800a2007b0:      	adrp	x21, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a2007b4:      	add	x21, x21, #0xca9
ffffff800a2007b8:      	b	0xffffff800a2007dc <start_kernel+0x284>
ffffff800a2007bc:      	adrp	x21, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a2007c0:      	add	x21, x21, #0xc53
ffffff800a2007c4:      	b	0xffffff800a2007dc <start_kernel+0x284>
ffffff800a2007c8:      	adrp	x21, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a2007cc:      	add	x21, x21, #0xc83
ffffff800a2007d0:      	b	0xffffff800a2007dc <start_kernel+0x284>
ffffff800a2007d4:      	adrp	x21, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a2007d8:      	add	x21, x21, #0xc6b
ffffff800a2007dc:      	ldr	x0, [x26, #0x88]
ffffff800a2007e0:      	add	w8, w20, #0x40
ffffff800a2007e4:      	mov	x1, x21
ffffff800a2007e8:      	sxtw	x2, w8
ffffff800a2007ec:      	bl	0xffffff800949d920 <strlcat>
ffffff800a2007f0:      	ldr	x0, [x23, #0x98]
ffffff800a2007f4:      	add	w8, w19, #0x40
ffffff800a2007f8:      	mov	x1, x21
ffffff800a2007fc:      	sxtw	x2, w8
ffffff800a200800:      	bl	0xffffff800949d920 <strlcat>
ffffff800a200804:      	ldr	x0, [sp, #0x8]
ffffff800a200808:      	bl	0xffffff800a200bd8 <is_at_boot>
ffffff800a20080c:      	bl	0xffffff800a218ce0 <setup_nr_cpu_ids>
ffffff800a200810:      	bl	0xffffff800a223690 <setup_per_cpu_areas>
ffffff800a200814:      	bl	0xffffff800a206808 <smp_prepare_boot_cpu>
ffffff800a200818:      	bl	0xffffff800a20bd70 <boot_cpu_hotplug_init>
ffffff800a20081c:      	mov	x0, xzr
ffffff800a200820:      	bl	0xffffff80094a4800 <build_all_zonelists>
ffffff800a200824:      	bl	0xffffff800a2204c0 <page_alloc_init>
ffffff800a200828:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a20082c:      	adrp	x1, 0xffffff800a2d2000 <parse_early_param.tmp_cmdline+0xfff>
ffffff800a200830:      	add	x0, x0, #0x931
ffffff800a200834:      	add	x1, x1, #0x1
ffffff800a200838:      	bl	0xffffff800814dca8 <printk>
ffffff800a20083c:      	adrp	x20, 0xffffff800a2d1000 <parse_early_param.done>
ffffff800a200840:      	adrp	x9, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff800a200844:      	mov	w21, #0x1       // =1
ffffff800a200848:      	ldrb	w8, [x20]
ffffff800a20084c:      	strb	w21, [x9, #0xf84]
ffffff800a200850:      	tbnz	w8, #0x0, 0xffffff800a2008a0 <start_kernel+0x348>
ffffff800a200854:      	adrp	x19, 0xffffff800a2d1000 <parse_early_param.done>
ffffff800a200858:      	adrp	x1, 0xffffff800a2d2000 <parse_early_param.tmp_cmdline+0xfff>
ffffff800a20085c:      	add	x19, x19, #0x1
ffffff800a200860:      	add	x1, x1, #0x1
ffffff800a200864:      	mov	x0, x19
ffffff800a200868:      	mov	w2, #0x1000     // =4096
ffffff800a20086c:      	bl	0xffffff800949d768 <strlcpy>
ffffff800a200870:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a200874:      	adrp	x7, 0xffffff800a200000 <stext>
ffffff800a200878:      	add	x0, x0, #0x91e
ffffff800a20087c:      	add	x7, x7, #0x3c8
ffffff800a200880:      	mov	x1, x19
ffffff800a200884:      	mov	x2, xzr
ffffff800a200888:      	mov	w3, wzr
ffffff800a20088c:      	mov	w4, wzr
ffffff800a200890:      	mov	w5, wzr
ffffff800a200894:      	mov	x6, xzr
ffffff800a200898:      	bl	0xffffff80080e9140 <parse_args>
ffffff800a20089c:      	strb	w21, [x20]
ffffff800a2008a0:      	adrp	x2, 0xffffff800a17f000 <__kstrtab_strcasecmp+0x2>
ffffff800a2008a4:      	adrp	x8, 0xffffff800a184000 <__param_acct>
ffffff800a2008a8:      	add	x2, x2, #0x208
ffffff800a2008ac:      	add	x8, x8, #0x690
ffffff800a2008b0:      	mov	x9, #0x6666666666666666 // =7378697629483820646
ffffff800a2008b4:      	sub	x8, x8, x2
ffffff800a2008b8:      	movk	x9, #0x6667
ffffff800a2008bc:      	ldr	x1, [x23, #0x98]
ffffff800a2008c0:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a2008c4:      	adrp	x7, 0xffffff800a200000 <stext>
ffffff800a2008c8:      	smulh	x8, x8, x9
ffffff800a2008cc:      	add	x0, x0, #0x94c
ffffff800a2008d0:      	add	x7, x7, #0xfa8
ffffff800a2008d4:      	mov	w4, #0xffff     // =65535
ffffff800a2008d8:      	lsr	x9, x8, #63
ffffff800a2008dc:      	lsr	x8, x8, #4
ffffff800a2008e0:      	add	w3, w8, w9
ffffff800a2008e4:      	mov	w5, #0xffff     // =65535
ffffff800a2008e8:      	mov	x6, xzr
ffffff800a2008ec:      	bl	0xffffff80080e9140 <parse_args>
ffffff800a2008f0:      	cbz	x0, 0xffffff800a200928 <start_kernel+0x3d0>
ffffff800a2008f4:      	mov	x1, x0
ffffff800a2008f8:      	cmn	x0, #0x1, lsl #12 // =0x1000
ffffff800a2008fc:      	b.hi	0xffffff800a200928 <start_kernel+0x3d0>
ffffff800a200900:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a200904:      	adrp	x7, 0xffffff800a201000 <unknown_bootoption+0x58>
ffffff800a200908:      	add	x0, x0, #0x95b
ffffff800a20090c:      	add	x7, x7, #0x1f0
ffffff800a200910:      	mov	x2, xzr
ffffff800a200914:      	mov	w3, wzr
ffffff800a200918:      	mov	w4, #0xffff     // =65535
ffffff800a20091c:      	mov	w5, #0xffff     // =65535
ffffff800a200920:      	mov	x6, xzr
ffffff800a200924:      	bl	0xffffff80080e9140 <parse_args>
ffffff800a200928:      	mov	w0, wzr
ffffff800a20092c:      	bl	0xffffff800a213ec8 <setup_log_buf>
ffffff800a200930:      	bl	0xffffff800a20d3a0 <pidhash_init>
ffffff800a200934:      	bl	0xffffff800a22a7e0 <vfs_caches_init_early>
ffffff800a200938:      	bl	0xffffff800a20d500 <sort_main_extable>
ffffff800a20093c:      	bl	0xffffff800a205708 <trap_init>
ffffff800a200940:      	adrp	x8, 0xffffff800aca1000 <ftrace_dump.iter+0x19f0>
ffffff800a200944:      	ldr	w8, [x8, #0xf68]
ffffff800a200948:      	cmp	w8, #0x1
ffffff800a20094c:      	b.ge	0xffffff800a200b4c <start_kernel+0x5f4>
ffffff800a200950:      	adrp	x19, 0xffffff800a07c000 <snd_usbmidi_cin_length+0x28034>
ffffff800a200954:      	add	x19, x19, #0xe23
ffffff800a200958:      	adrp	x21, 0xffffff800aca1000 <ftrace_dump.iter+0x19f0>
ffffff800a20095c:      	adrp	x20, 0xffffff800a07c000 <snd_usbmidi_cin_length+0x28034>
ffffff800a200960:      	add	x20, x20, #0xe23
ffffff800a200964:      	ldr	w8, [x21, #0xf6c]
ffffff800a200968:      	cmp	w8, #0x1
ffffff800a20096c:      	b.ge	0xffffff800a200b60 <start_kernel+0x608>
ffffff800a200970:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a200974:      	adrp	x1, 0xffffff800a07c000 <snd_usbmidi_cin_length+0x28034>
ffffff800a200978:      	add	x0, x0, #0xd18
ffffff800a20097c:      	add	x1, x1, #0xe23
ffffff800a200980:      	mov	x2, x19
ffffff800a200984:      	mov	x3, x20
ffffff800a200988:      	bl	0xffffff800814dca8 <printk>
ffffff800a20098c:      	ldr	w8, [x21, #0xf6c]
ffffff800a200990:      	cmp	w8, #0x1
ffffff800a200994:      	b.ge	0xffffff800a200b78 <start_kernel+0x620>
ffffff800a200998:      	bl	0xffffff800a2095c8 <mem_init>
ffffff800a20099c:      	bl	0xffffff800a228030 <kmem_cache_init>
ffffff800a2009a0:      	bl	0xffffff800a209b28 <pgd_cache_init>
ffffff800a2009a4:      	bl	0xffffff800a225718 <vmalloc_init>
ffffff800a2009a8:      	bl	0xffffff800a286bc0 <ioremap_huge_init>
ffffff800a2009ac:      	bl	0xffffff800a21acf0 <early_trace_init>
ffffff800a2009b0:      	bl	0xffffff800a212818 <sched_init>
ffffff800a2009b4:      	ldr	w8, [x25, #0x50]
ffffff800a2009b8:      	add	w8, w8, #0x1
ffffff800a2009bc:      	str	w8, [x25, #0x50]
ffffff800a2009c0:      	mrs	x8, DAIF
ffffff800a2009c4:      	sxtb	w8, w8
ffffff800a2009c8:      	tbz	w8, #0x1f, 0xffffff800a200b90 <start_kernel+0x638>
ffffff800a2009cc:      	bl	0xffffff800a286c28 <radix_tree_init>
ffffff800a2009d0:      	bl	0xffffff800a20cd88 <workqueue_init_early>
ffffff800a2009d4:      	bl	0xffffff800a214bf8 <rcu_init>
ffffff800a2009d8:      	bl	0xffffff800a21b0a8 <trace_init>
ffffff800a2009dc:      	bl	0xffffff800a214710 <early_irq_init>
ffffff800a2009e0:      	bl	0xffffff800a204ad0 <init_IRQ>
ffffff800a2009e4:      	bl	0xffffff800a2185a8 <tick_init>
ffffff800a2009e8:      	bl	0xffffff800a2153e0 <rcu_init_nohz>
ffffff800a2009ec:      	bl	0xffffff800a217b28 <init_timers>
ffffff800a2009f0:      	bl	0xffffff800a217c30 <hrtimers_init>
ffffff800a2009f4:      	bl	0xffffff800a20bff0 <softirq_init>
ffffff800a2009f8:      	bl	0xffffff800a217c98 <timekeeping_init>
ffffff800a2009fc:      	bl	0xffffff800a205630 <time_init>
ffffff800a200a00:      	bl	0xffffff800a218820 <sched_clock_postinit>
ffffff800a200a04:      	bl	0xffffff800a214498 <printk_safe_init>
ffffff800a200a08:      	bl	0xffffff800a21ee10 <perf_event_init>
ffffff800a200a0c:      	bl	0xffffff80094a4658 <profile_init>
ffffff800a200a10:      	bl	0xffffff800a218ae8 <call_function_init>
ffffff800a200a14:      	mrs	x8, DAIF
ffffff800a200a18:      	sxtb	w8, w8
ffffff800a200a1c:      	tbz	w8, #0x1f, 0xffffff800a200ba8 <start_kernel+0x650>
ffffff800a200a20:      	strb	wzr, [x24, #0xf85]
ffffff800a200a24:      	msr	DAIFClr, #0x2
ffffff800a200a28:      	bl	0xffffff800a228310 <kmem_cache_init_late>
ffffff800a200a2c:      	bl	0xffffff800a214230 <console_init>
ffffff800a200a30:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a200a34:      	ldr	x1, [x8, #0xa0]
ffffff800a200a38:      	cbnz	x1, 0xffffff800a200bc0 <start_kernel+0x668>
ffffff800a200a3c:      	bl	0xffffff800a200538 <mem_encrypt_init>
ffffff800a200a40:      	adrp	x19, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a200a44:      	ldr	x8, [x19, #0xe8]
ffffff800a200a48:      	cbz	x8, 0xffffff800a200aa8 <start_kernel+0x550>
ffffff800a200a4c:      	adrp	x9, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a200a50:      	ldr	w9, [x9, #0xf8]
ffffff800a200a54:      	cbnz	w9, 0xffffff800a200aa8 <start_kernel+0x550>
ffffff800a200a58:      	adrp	x9, 0xffffff800a0f8000 <iw_priv_type_size+0x7a7>
ffffff800a200a5c:      	adrp	x10, 0xffffff800aca2000 <global_wb_domain+0x20>
ffffff800a200a60:      	lsr	x8, x8, #6
ffffff800a200a64:      	mov	x11, #0xffbf00000000 // =281195803836416
ffffff800a200a68:      	and	x8, x8, #0xffffffc0
ffffff800a200a6c:      	movk	x11, #0xffff, lsl #48
ffffff800a200a70:      	ldr	x9, [x9, #0xb70]
ffffff800a200a74:      	orr	x8, x8, x11
ffffff800a200a78:      	ldr	x2, [x10, #0x528]
ffffff800a200a7c:      	asr	x9, x9, #12
ffffff800a200a80:      	lsl	x9, x9, #6
ffffff800a200a84:      	sub	x9, x9, x11
ffffff800a200a88:      	add	x8, x8, x9
ffffff800a200a8c:      	asr	x1, x8, #6
ffffff800a200a90:      	cmp	x1, x2
ffffff800a200a94:      	b.hs	0xffffff800a200aa8 <start_kernel+0x550>
ffffff800a200a98:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a200a9c:      	add	x0, x0, #0x9db
ffffff800a200aa0:      	bl	0xffffff800814dca8 <printk>
ffffff800a200aa4:      	str	xzr, [x19, #0xe8]
ffffff800a200aa8:      	bl	0xffffff800a228a28 <kmemleak_init>
ffffff800a200aac:      	bl	0xffffff800a2202a0 <setup_per_cpu_pageset>
ffffff800a200ab0:      	adrp	x8, 0xffffff800a2d3000 <boot_command_line+0xfff>
ffffff800a200ab4:      	ldr	x8, [x8, #0x8]
ffffff800a200ab8:      	cbz	x8, 0xffffff800a200ac0 <start_kernel+0x568>
ffffff800a200abc:      	blr	x8
ffffff800a200ac0:      	bl	0xffffff8008084480 <calibrate_delay>
ffffff800a200ac4:      	bl	0xffffff800a20d3f8 <pidmap_init>
ffffff800a200ac8:      	bl	0xffffff800a2254e0 <anon_vma_init>
ffffff800a200acc:      	bl	0xffffff800a200530 <thread_stack_cache_init>
ffffff800a200ad0:      	bl	0xffffff800a20d948 <cred_init>
ffffff800a200ad4:      	bl	0xffffff800a20b3b8 <fork_init>
ffffff800a200ad8:      	bl	0xffffff800a20b4e8 <proc_caches_init>
ffffff800a200adc:      	bl	0xffffff800a22bff0 <buffer_init>
ffffff800a200ae0:      	bl	0xffffff800a23a1c0 <key_init>
ffffff800a200ae4:      	bl	0xffffff800a23a3c8 <security_init>
ffffff800a200ae8:      	bl	0xffffff800a22a858 <vfs_caches_init>
ffffff800a200aec:      	bl	0xffffff800a21f848 <pagecache_init>
ffffff800a200af0:      	bl	0xffffff800a20cb78 <signals_init>
ffffff800a200af4:      	bl	0xffffff800a22d6e8 <proc_root_init>
ffffff800a200af8:      	bl	0xffffff800a22bfa0 <nsfs_init>
ffffff800a200afc:      	bl	0xffffff800a219e58 <cpuset_init>
ffffff800a200b00:      	bl	0xffffff800a219678 <cgroup_init>
ffffff800a200b04:      	bl	0xffffff800a21a670 <taskstats_init_early>
ffffff800a200b08:      	bl	0xffffff80081c7ca0 <delayacct_init>
ffffff800a200b0c:      	bl	0xffffff800a200520 <arch_post_acpi_subsys_init>
ffffff800a200b10:      	bl	0xffffff80094a3288 <rest_init>
ffffff800a200b14:      	adrp	x9, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff800a200b18:      	dsb	sy
ffffff800a200b1c:      	ldur	x8, [x29, #-0x8]
ffffff800a200b20:      	ldr	x9, [x9, #0xf88]
ffffff800a200b24:      	cmp	x9, x8
ffffff800a200b28:      	b.ne	0xffffff800a200bbc <start_kernel+0x664>
ffffff800a200b2c:      	ldp	x20, x19, [sp, #0x70]
ffffff800a200b30:      	ldr	x27, [sp, #0x30]
ffffff800a200b34:      	ldp	x22, x21, [sp, #0x60]
ffffff800a200b38:      	ldp	x24, x23, [sp, #0x50]
ffffff800a200b3c:      	ldp	x26, x25, [sp, #0x40]
ffffff800a200b40:      	ldp	x29, x30, [sp, #0x20]
ffffff800a200b44:      	add	sp, sp, #0x80
ffffff800a200b48:      	ret
ffffff800a200b4c:      	bl	0xffffff800828b690 <page_poisoning_enabled>
ffffff800a200b50:      	tbnz	w0, #0x0, 0xffffff800a200950 <start_kernel+0x3f8>
ffffff800a200b54:      	adrp	x19, 0xffffff800a079000 <snd_usbmidi_cin_length+0x25034>
ffffff800a200b58:      	add	x19, x19, #0x6e3
ffffff800a200b5c:      	b	0xffffff800a200958 <start_kernel+0x400>
ffffff800a200b60:      	bl	0xffffff800828b690 <page_poisoning_enabled>
ffffff800a200b64:      	adrp	x8, 0xffffff800a079000 <snd_usbmidi_cin_length+0x25034>
ffffff800a200b68:      	tst	w0, #0x1
ffffff800a200b6c:      	add	x8, x8, #0x6e3
ffffff800a200b70:      	csel	x20, x20, x8, ne
ffffff800a200b74:      	b	0xffffff800a200970 <start_kernel+0x418>
ffffff800a200b78:      	bl	0xffffff800828b690 <page_poisoning_enabled>
ffffff800a200b7c:      	tbnz	w0, #0x0, 0xffffff800a200998 <start_kernel+0x440>
ffffff800a200b80:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a200b84:      	add	x0, x0, #0xd50
ffffff800a200b88:      	bl	0xffffff800814dca8 <printk>
ffffff800a200b8c:      	b	0xffffff800a200998 <start_kernel+0x440>
ffffff800a200b90:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a200b94:      	add	x0, x0, #0x96d
ffffff800a200b98:      	bl	0xffffff800814dca8 <printk>
ffffff800a200b9c:      	brk	#0x800
ffffff800a200ba0:      	msr	DAIFSet, #0x2
ffffff800a200ba4:      	b	0xffffff800a2009cc <start_kernel+0x474>
ffffff800a200ba8:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a200bac:      	add	x0, x0, #0x99e
ffffff800a200bb0:      	bl	0xffffff800814dca8 <printk>
ffffff800a200bb4:      	brk	#0x800
ffffff800a200bb8:      	b	0xffffff800a200a20 <start_kernel+0x4c8>
ffffff800a200bbc:      	bl	0xffffff80080bd9f8 <__stack_chk_fail>
ffffff800a200bc0:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a200bc4:      	adrp	x0, 0xffffff8009e13000 <rtic_mp+0x213000>
ffffff800a200bc8:      	add	x0, x0, #0x9bd
ffffff800a200bcc:      	ldr	x2, [x8, #0xa8]
ffffff800a200bd0:      	bl	0xffffff80080bd118 <panic>
ffffff800a200bd4:      	nop

ffffff800a204fe0 <setup_arch>:
ffffff800a204fe0:      	sub	sp, sp, #0x80
ffffff800a204fe4:      	stp	x29, x30, [sp, #0x20]
ffffff800a204fe8:      	add	x29, sp, #0x20
ffffff800a204fec:      	stp	x28, x27, [sp, #0x30]
ffffff800a204ff0:      	stp	x26, x25, [sp, #0x40]
ffffff800a204ff4:      	stp	x24, x23, [sp, #0x50]
ffffff800a204ff8:      	stp	x22, x21, [sp, #0x60]
ffffff800a204ffc:      	stp	x20, x19, [sp, #0x70]
ffffff800a205000:      	adrp	x8, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff800a205004:      	mov	x19, x0
ffffff800a205008:      	adrp	x0, 0xffffff8009e15000 <rtic_mp+0x215000>
ffffff800a20500c:      	add	x0, x0, #0xe84
ffffff800a205010:      	ldr	x8, [x8, #0xf88]
ffffff800a205014:      	stur	x8, [x29, #-0x8]
ffffff800a205018:      	mrs	x1, MIDR_EL1
ffffff800a20501c:      	bl	0xffffff800814dca8 <printk>
ffffff800a205020:      	adrp	x8, 0xffffff800a81e000 <inet6_offloads+0x2a0>
ffffff800a205024:      	adrp	x1, 0xffffff8009e15000 <rtic_mp+0x215000>
ffffff800a205028:      	add	x8, x8, #0xb48
ffffff800a20502c:      	add	x1, x1, #0xdd3
ffffff800a205030:      	add	x0, x8, #0x108
ffffff800a205034:      	bl	0xffffff800949fa78 <sprintf>
ffffff800a205038:      	adrp	x21, 0xffffff800a89b000 <event_spf_pte_lock+0x18>
ffffff800a20503c:      	adrp	x8, 0xffffff8008080000 <_text>
ffffff800a205040:      	adrp	x9, 0xffffff8009600000 <__start_rodata>
ffffff800a205044:      	add	x21, x21, #0x470
ffffff800a205048:      	add	x8, x8, #0x0
ffffff800a20504c:      	add	x9, x9, #0x0
ffffff800a205050:      	adrp	x20, 0xffffff800b5f0000 <__bss_rtic_start+0x3000>
ffffff800a205054:      	add	x20, x20, #0x0
ffffff800a205058:      	stp	x8, x9, [x21, #0x108]
ffffff800a20505c:      	adrp	x8, 0xffffff800aab8000 <__mmuoff_data_start>
ffffff800a205060:      	add	x8, x8, #0x800
ffffff800a205064:      	str	x20, [x21, #0x130]
ffffff800a205068:      	str	x8, [x21, #0x120]
ffffff800a20506c:      	adrp	x8, 0xffffff800a2d2000 <parse_early_param.tmp_cmdline+0xfff>
ffffff800a205070:      	add	x8, x8, #0x1
ffffff800a205074:      	str	x8, [x19]
ffffff800a205078:      	bl	0xffffff800a20a798 <early_fixmap_init>
ffffff800a20507c:      	bl	0xffffff800a209b10 <early_ioremap_init>
ffffff800a205080:      	adrp	x8, 0xffffff800a2d3000 <boot_command_line+0xfff>
ffffff800a205084:      	ldr	x0, [x8, #0x398]
ffffff800a205088:      	str	x0, [sp, #0x10]
ffffff800a20508c:      	bl	0xffffff800a20ab10 <fixmap_remap_fdt>
ffffff800a205090:      	mov	x19, x0
ffffff800a205094:      	cbz	x0, 0xffffff800a2051a4 <setup_arch+0x1c4>
ffffff800a205098:      	mov	x0, x19
ffffff800a20509c:      	bl	0xffffff800a2673e8 <early_init_dt_scan>
ffffff800a2050a0:      	tbz	w0, #0x0, 0xffffff800a2051a4 <setup_arch+0x1c4>
ffffff800a2050a4:      	bl	0xffffff800a244f68 <arch_read_machine_name>
ffffff800a2050a8:      	cbz	x0, 0xffffff800a2050d0 <setup_arch+0xf0>
ffffff800a2050ac:      	mov	x19, x0
ffffff800a2050b0:      	adrp	x0, 0xffffff8009e15000 <rtic_mp+0x215000>
ffffff800a2050b4:      	add	x0, x0, #0xff2
ffffff800a2050b8:      	mov	x1, x19
ffffff800a2050bc:      	bl	0xffffff800814dca8 <printk>
ffffff800a2050c0:      	adrp	x0, 0xffffff8009e16000 <rtic_mp+0x216000>
ffffff800a2050c4:      	mov	x1, x19
ffffff800a2050c8:      	add	x0, x0, #0x1
ffffff800a2050cc:      	bl	0xffffff800a214380 <dump_stack_set_arch_desc>
ffffff800a2050d0:      	adrp	x8, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff800a2050d4:      	mov	w9, #0x1        // =1
ffffff800a2050d8:      	strb	w9, [x8, #0xf84]
ffffff800a2050dc:      	bl	0xffffff800a2004a8 <parse_early_param>
ffffff800a2050e0:      	adrp	x22, 0xffffff800a0f8000 <iw_priv_type_size+0x7a7>
ffffff800a2050e4:      	msr	DAIFClr, #0x4
ffffff800a2050e8:      	adrp	x19, 0xffffff800aab9000 <empty_zero_page>
ffffff800a2050ec:      	mrs	x9, SP_EL0
ffffff800a2050f0:      	add	x19, x19, #0x0
ffffff800a2050f4:      	ldr	x1, [x9, #0x5a8]
ffffff800a2050f8:      	ldr	x8, [x22, #0xb80]
ffffff800a2050fc:      	sub	x8, x19, x8
ffffff800a205100:      	msr	TTBR0_EL1, x8
ffffff800a205104:      	isb
ffffff800a205108:      	adrp	x8, 0xffffff800a825000 <armv8_event_attr_stall_frontend>
ffffff800a20510c:      	dsb	nshst
ffffff800a205110:      	tlbi	vmalle1
ffffff800a205114:      	nop
ffffff800a205118:      	nop
ffffff800a20511c:      	dsb	nsh
ffffff800a205120:      	isb
ffffff800a205124:      	ldr	x8, [x8, #0xa30]
ffffff800a205128:      	cmp	x8, #0x19
ffffff800a20512c:      	b.eq	0xffffff800a205144 <setup_arch+0x164>
ffffff800a205130:      	mov	x8, #0x19       // =25
ffffff800a205134:      	mrs	x9, TCR_EL1
ffffff800a205138:      	bfxil	x9, x8, #0, #6
ffffff800a20513c:      	msr	TCR_EL1, x9
ffffff800a205140:      	isb
ffffff800a205144:      	cmp	x1, x21
ffffff800a205148:      	b.eq	0xffffff800a2051d4 <setup_arch+0x1f4>
ffffff800a20514c:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a205150:      	ldr	w8, [x8, #0x620]
ffffff800a205154:      	cmp	w8, #0x1
ffffff800a205158:      	b.lt	0xffffff800a20554c <setup_arch+0x56c>
ffffff800a20515c:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a205160:      	add	x8, x8, #0x5a8
ffffff800a205164:      	ldr	w8, [x8, #0x10]
ffffff800a205168:      	cmp	w8, #0x0
ffffff800a20516c:      	b.le	0xffffff800a2051d4 <setup_arch+0x1f4>
ffffff800a205170:      	ldr	x8, [x1, #0x48]
ffffff800a205174:      	adrp	x9, 0xffffff800a18f000 <__stop_notes+0x5618>
ffffff800a205178:      	add	x9, x9, #0x0
ffffff800a20517c:      	cmp	x8, x9
ffffff800a205180:      	b.eq	0xffffff800a20555c <setup_arch+0x57c>
ffffff800a205184:      	ldr	x9, [x22, #0xb80]
ffffff800a205188:      	sub	x9, x19, x9
ffffff800a20518c:      	msr	TTBR0_EL1, x9
ffffff800a205190:      	isb
ffffff800a205194:      	tbnz	x8, #0x26, 0xffffff800a2051c0 <setup_arch+0x1e0>
ffffff800a205198:      	ldr	x9, [x22, #0xb80]
ffffff800a20519c:      	sub	x0, x8, x9
ffffff800a2051a0:      	b	0xffffff800a2051d0 <setup_arch+0x1f0>
ffffff800a2051a4:      	adrp	x0, 0xffffff8009e15000 <rtic_mp+0x215000>
ffffff800a2051a8:      	add	x1, sp, #0x10
ffffff800a2051ac:      	add	x0, x0, #0xf41
ffffff800a2051b0:      	mov	x2, x19
ffffff800a2051b4:      	bl	0xffffff800814dca8 <printk>
ffffff800a2051b8:      	yield
ffffff800a2051bc:      	b	0xffffff800a2051b8 <setup_arch+0x1d8>
ffffff800a2051c0:      	adrp	x9, 0xffffff800a0f8000 <iw_priv_type_size+0x7a7>
ffffff800a2051c4:      	and	x8, x8, #0x3fffffffff
ffffff800a2051c8:      	ldr	x9, [x9, #0xb70]
ffffff800a2051cc:      	add	x0, x9, x8
ffffff800a2051d0:      	bl	0xffffff80080aa488 <cpu_do_switch_mm>
ffffff800a2051d4:      	str	x19, [sp, #0x8]
ffffff800a2051d8:      	bl	0xffffff800a209150 <arm64_memblock_init>
ffffff800a2051dc:      	bl	0xffffff800a209e50 <paging_init>
ffffff800a2051e0:      	bl	0xffffff800a267478 <unflatten_device_tree>
ffffff800a2051e4:      	bl	0xffffff800a209408 <bootmem_init>
ffffff800a2051e8:      	adrp	x24, 0xffffff800a89b000 <event_spf_pte_lock+0x18>
ffffff800a2051ec:      	ldr	x9, [x22, #0xb80]
ffffff800a2051f0:      	add	x24, x24, #0x7e8
ffffff800a2051f4:      	adrp	x10, 0xffffff800a200000 <stext>
ffffff800a2051f8:      	adrp	x8, 0xffffff8008080000 <_text>
ffffff800a2051fc:      	add	x10, x10, #0x0
ffffff800a205200:      	adrp	x11, 0xffffff800a800000 <init_thread_union>
ffffff800a205204:      	add	x8, x8, #0x0
ffffff800a205208:      	sub	x10, x10, #0x1
ffffff800a20520c:      	add	x11, x11, #0x0
ffffff800a205210:      	sub	x12, x20, #0x1
ffffff800a205214:      	ldr	x25, [x24, #0x28]
ffffff800a205218:      	ldr	x13, [x24, #0x10]
ffffff800a20521c:      	sub	x8, x8, x9
ffffff800a205220:      	sub	x10, x10, x9
ffffff800a205224:      	sub	x11, x11, x9
ffffff800a205228:      	sub	x9, x12, x9
ffffff800a20522c:      	mov	w12, #0x18      // =24
ffffff800a205230:      	adrp	x19, 0xffffff800a823000 <sysent_64_1+0xa50>
ffffff800a205234:      	add	x19, x19, #0xbb0
ffffff800a205238:      	madd	x12, x13, x12, x25
ffffff800a20523c:      	cmp	x25, x12
ffffff800a205240:      	stp	x8, x10, [x19]
ffffff800a205244:      	stp	x11, x9, [x19, #0x40]
ffffff800a205248:      	b.hs	0xffffff800a205348 <setup_arch+0x368>
ffffff800a20524c:      	mov	w27, #0x200     // =512
ffffff800a205250:      	adrp	x26, 0xffffff8009e46000 <ext4_type_by_mode+0x7c6>
ffffff800a205254:      	adrp	x20, 0xffffff800a82f000 <event_tasklet_exit+0x70>
ffffff800a205258:      	movk	w27, #0x8100, lsl #16
ffffff800a20525c:      	mov	w28, #0x200     // =512
ffffff800a205260:      	adrp	x23, 0xffffff800a823000 <sysent_64_1+0xa50>
ffffff800a205264:      	mov	w22, #0x18      // =24
ffffff800a205268:      	add	x26, x26, #0x106
ffffff800a20526c:      	add	x20, x20, #0x1e8
ffffff800a205270:      	b	0xffffff800a20528c <setup_arch+0x2ac>
ffffff800a205274:      	ldr	x8, [x24, #0x28]
ffffff800a205278:      	add	x25, x25, #0x18
ffffff800a20527c:      	ldr	x9, [x24, #0x10]
ffffff800a205280:      	madd	x8, x9, x22, x8
ffffff800a205284:      	cmp	x25, x8
ffffff800a205288:      	b.hs	0xffffff800a205348 <setup_arch+0x368>
ffffff800a20528c:      	mov	w0, #0x40       // =64
ffffff800a205290:      	mov	w1, #0x80       // =128
ffffff800a205294:      	mov	x2, xzr
ffffff800a205298:      	bl	0xffffff800a225f90 <__alloc_bootmem_low>
ffffff800a20529c:      	ldr	x8, [x25, #0x10]
ffffff800a2052a0:      	mov	x21, x0
ffffff800a2052a4:      	mov	x1, x21
ffffff800a2052a8:      	tst	x8, #0x4
ffffff800a2052ac:      	adrp	x8, 0xffffff8009e16000 <rtic_mp+0x216000>
ffffff800a2052b0:      	add	x8, x8, #0x9
ffffff800a2052b4:      	csel	x9, x28, x27, ne
ffffff800a2052b8:      	csel	x8, x26, x8, ne
ffffff800a2052bc:      	stp	x8, x9, [x0, #0x10]
ffffff800a2052c0:      	ldr	x8, [x25]
ffffff800a2052c4:      	add	x8, x8, #0xfff
ffffff800a2052c8:      	and	x8, x8, #0xfffffffffffff000
ffffff800a2052cc:      	str	x8, [x0]
ffffff800a2052d0:      	ldp	x8, x9, [x25]
ffffff800a2052d4:      	add	x8, x9, x8
ffffff800a2052d8:      	and	x8, x8, #0xfffffffffffff000
ffffff800a2052dc:      	sub	x8, x8, #0x1
ffffff800a2052e0:      	str	x8, [x0, #0x8]
ffffff800a2052e4:      	mov	x0, x20
ffffff800a2052e8:      	bl	0xffffff80080c70d8 <request_resource>
ffffff800a2052ec:      	ldr	x9, [x23, #0xbb0]
ffffff800a2052f0:      	ldr	x8, [x21]
ffffff800a2052f4:      	cmp	x9, x8
ffffff800a2052f8:      	b.lo	0xffffff800a20531c <setup_arch+0x33c>
ffffff800a2052fc:      	ldr	x9, [x19, #0x8]
ffffff800a205300:      	ldr	x10, [x21, #0x8]
ffffff800a205304:      	cmp	x9, x10
ffffff800a205308:      	b.hi	0xffffff800a20531c <setup_arch+0x33c>
ffffff800a20530c:      	mov	x0, x21
ffffff800a205310:      	mov	x1, x19
ffffff800a205314:      	bl	0xffffff80080c70d8 <request_resource>
ffffff800a205318:      	ldr	x8, [x21]
ffffff800a20531c:      	ldr	x9, [x19, #0x40]
ffffff800a205320:      	cmp	x9, x8
ffffff800a205324:      	b.lo	0xffffff800a205274 <setup_arch+0x294>
ffffff800a205328:      	ldr	x8, [x19, #0x48]
ffffff800a20532c:      	ldr	x9, [x21, #0x8]
ffffff800a205330:      	cmp	x8, x9
ffffff800a205334:      	b.hi	0xffffff800a205274 <setup_arch+0x294>
ffffff800a205338:      	add	x1, x19, #0x40
ffffff800a20533c:      	mov	x0, x21
ffffff800a205340:      	bl	0xffffff80080c70d8 <request_resource>
ffffff800a205344:      	b	0xffffff800a205274 <setup_arch+0x294>
ffffff800a205348:      	bl	0xffffff800a229120 <early_ioremap_reset>
ffffff800a20534c:      	bl	0xffffff800a264340 <psci_dt_init>
ffffff800a205350:      	adrp	x8, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff800a205354:      	ldr	w0, [x8, #0xf90]
ffffff800a205358:      	bl	0xffffff800a205998 <cpu_read_ops>
ffffff800a20535c:      	bl	0xffffff800a206840 <smp_init_cpus>
ffffff800a205360:      	adrp	x1, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff800a205364:      	mov	w0, #-0x1       // =-1
ffffff800a205368:      	add	x1, x1, #0xfd0
ffffff800a20536c:      	bl	0xffffff800948ebc0 <cpumask_next>
ffffff800a205370:      	adrp	x21, 0xffffff800a80e000 <system_long_wq>
ffffff800a205374:      	ldr	w8, [x21, #0x258]
ffffff800a205378:      	cmp	w0, w8
ffffff800a20537c:      	b.hs	0xffffff800a2053c4 <setup_arch+0x3e4>
ffffff800a205380:      	adrp	x22, 0xffffff800a823000 <sysent_64_1+0xa50>
ffffff800a205384:      	adrp	x19, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff800a205388:      	ldr	x23, [sp, #0x8]
ffffff800a20538c:      	mov	x20, xzr
ffffff800a205390:      	add	x22, x22, #0xb70
ffffff800a205394:      	add	x19, x19, #0xfd0
ffffff800a205398:      	adrp	x24, 0xffffff800a0f8000 <iw_priv_type_size+0x7a7>
ffffff800a20539c:      	ldr	x8, [x22, w0, uxtw #3]
ffffff800a2053a0:      	mov	x1, x19
ffffff800a2053a4:      	ldr	x9, [x22]
ffffff800a2053a8:      	eor	x8, x9, x8
ffffff800a2053ac:      	orr	x20, x8, x20
ffffff800a2053b0:      	bl	0xffffff800948ebc0 <cpumask_next>
ffffff800a2053b4:      	ldr	w8, [x21, #0x258]
ffffff800a2053b8:      	cmp	w0, w8
ffffff800a2053bc:      	b.lo	0xffffff800a20539c <setup_arch+0x3bc>
ffffff800a2053c0:      	b	0xffffff800a2053d0 <setup_arch+0x3f0>
ffffff800a2053c4:      	ldr	x23, [sp, #0x8]
ffffff800a2053c8:      	mov	x20, xzr
ffffff800a2053cc:      	adrp	x24, 0xffffff800a0f8000 <iw_priv_type_size+0x7a7>
ffffff800a2053d0:      	and	w8, w20, #0xff
ffffff800a2053d4:      	mov	w9, #0x20       // =32
ffffff800a2053d8:      	clz	w10, w8
ffffff800a2053dc:      	rbit	w8, w8
ffffff800a2053e0:      	ubfx	w11, w20, #8, #8
ffffff800a2053e4:      	tst	w20, #0xff
ffffff800a2053e8:      	sub	w10, w9, w10
ffffff800a2053ec:      	clz	w8, w8
ffffff800a2053f0:      	clz	w12, w11
ffffff800a2053f4:      	mov	w13, #0xff      // =255
ffffff800a2053f8:      	rbit	w11, w11
ffffff800a2053fc:      	csel	w10, wzr, w10, eq
ffffff800a205400:      	csel	w8, wzr, w8, eq
ffffff800a205404:      	sub	w12, w9, w12
ffffff800a205408:      	tst	w13, w20, lsr #8
ffffff800a20540c:      	clz	w11, w11
ffffff800a205410:      	ubfx	w14, w20, #16, #8
ffffff800a205414:      	clz	w15, w14
ffffff800a205418:      	csel	w12, wzr, w12, eq
ffffff800a20541c:      	csel	w11, wzr, w11, eq
ffffff800a205420:      	sub	w15, w9, w15
ffffff800a205424:      	rbit	w14, w14
ffffff800a205428:      	tst	w13, w20, lsr #16
ffffff800a20542c:      	sub	w10, w10, w8
ffffff800a205430:      	clz	w13, w14
ffffff800a205434:      	csel	w14, wzr, w15, eq
ffffff800a205438:      	lsr	x15, x20, #32
ffffff800a20543c:      	ubfx	x16, x20, #32, #8
ffffff800a205440:      	sub	w12, w12, w11
ffffff800a205444:      	csel	w13, wzr, w13, eq
ffffff800a205448:      	clz	w17, w16
ffffff800a20544c:      	tst	w15, #0xff
ffffff800a205450:      	rbit	w15, w16
ffffff800a205454:      	sub	w11, w11, w10
ffffff800a205458:      	adrp	x16, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20545c:      	add	w11, w11, #0x8
ffffff800a205460:      	add	x16, x16, #0x158
ffffff800a205464:      	clz	w15, w15
ffffff800a205468:      	sub	w14, w14, w13
ffffff800a20546c:      	csel	w15, wzr, w15, eq
ffffff800a205470:      	sub	w9, w9, w17
ffffff800a205474:      	stp	w8, w11, [x16, #0x8]
ffffff800a205478:      	sub	w8, w13, w10
ffffff800a20547c:      	adrp	x13, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff800a205480:      	orr	w11, w15, #0x20
ffffff800a205484:      	csel	w9, wzr, w9, eq
ffffff800a205488:      	sub	w11, w11, w10
ffffff800a20548c:      	add	w10, w12, w10
ffffff800a205490:      	sub	w9, w9, w15
ffffff800a205494:      	sub	w8, w8, w12
ffffff800a205498:      	sub	w11, w11, w12
ffffff800a20549c:      	add	w10, w10, w14
ffffff800a2054a0:      	ldrb	w0, [x13, #0xfd0]
ffffff800a2054a4:      	add	w8, w8, #0x10
ffffff800a2054a8:      	sub	w11, w11, w14
ffffff800a2054ac:      	add	w19, w10, w9
ffffff800a2054b0:      	str	x20, [x16]
ffffff800a2054b4:      	stp	w8, w11, [x16, #0x10]
ffffff800a2054b8:      	str	w19, [x16, #0x18]
ffffff800a2054bc:      	bl	0xffffff80085418e8 <__sw_hweight64>
ffffff800a2054c0:      	lsl	w8, w0, #2
ffffff800a2054c4:      	lsr	w8, w8, w19
ffffff800a2054c8:      	cbnz	w8, 0xffffff800a2054d8 <setup_arch+0x4f8>
ffffff800a2054cc:      	adrp	x0, 0xffffff8009e16000 <rtic_mp+0x216000>
ffffff800a2054d0:      	add	x0, x0, #0x2c
ffffff800a2054d4:      	bl	0xffffff800814dca8 <printk>
ffffff800a2054d8:      	adrp	x9, 0xffffff800a805000 <boot_args>
ffffff800a2054dc:      	ldr	x8, [x24, #0xb80]
ffffff800a2054e0:      	add	x9, x9, #0x0
ffffff800a2054e4:      	adrp	x10, 0xffffff800a81f000 <init_signals+0x280>
ffffff800a2054e8:      	add	x10, x10, #0xa00
ffffff800a2054ec:      	ldp	x1, x2, [x9, #0x8]
ffffff800a2054f0:      	ldr	x3, [x9, #0x18]
ffffff800a2054f4:      	sub	x8, x23, x8
ffffff800a2054f8:      	orr	x9, x2, x1
ffffff800a2054fc:      	orr	x9, x9, x3
ffffff800a205500:      	str	x8, [x10, #0x48]
ffffff800a205504:      	cbz	x9, 0xffffff800a205514 <setup_arch+0x534>
ffffff800a205508:      	adrp	x0, 0xffffff8009e15000 <rtic_mp+0x215000>
ffffff800a20550c:      	add	x0, x0, #0xeaa
ffffff800a205510:      	bl	0xffffff800814dca8 <printk>
ffffff800a205514:      	bl	0xffffff800a244e78 <init_random_pool>
ffffff800a205518:      	adrp	x9, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff800a20551c:      	ldur	x8, [x29, #-0x8]
ffffff800a205520:      	ldr	x9, [x9, #0xf88]
ffffff800a205524:      	cmp	x9, x8
ffffff800a205528:      	b.ne	0xffffff800a205564 <setup_arch+0x584>
ffffff800a20552c:      	ldp	x20, x19, [sp, #0x70]
ffffff800a205530:      	ldp	x22, x21, [sp, #0x60]
ffffff800a205534:      	ldp	x24, x23, [sp, #0x50]
ffffff800a205538:      	ldp	x26, x25, [sp, #0x40]
ffffff800a20553c:      	ldp	x28, x27, [sp, #0x30]
ffffff800a205540:      	ldp	x29, x30, [sp, #0x20]
ffffff800a205544:      	add	sp, sp, #0x80
ffffff800a205548:      	ret
ffffff800a20554c:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a205550:      	ldr	x8, [x8, #0x5a0]
ffffff800a205554:      	tbnz	w8, #0x4, 0xffffff800a205170 <setup_arch+0x190>
ffffff800a205558:      	b	0xffffff800a2051d4 <setup_arch+0x1f4>
ffffff800a20555c:      	brk	#0x800
ffffff800a205560:      	b	0xffffff800a205560 <setup_arch+0x580>
ffffff800a205564:      	bl	0xffffff80080bd9f8 <__stack_chk_fail>

ffffff800a2079a8 <kaslr_early_init>:
ffffff800a2079a8:      	sub	sp, sp, #0x40
ffffff800a2079ac:      	stp	x29, x30, [sp, #0x10]
ffffff800a2079b0:      	add	x29, sp, #0x10
ffffff800a2079b4:      	stp	x22, x21, [sp, #0x20]
ffffff800a2079b8:      	stp	x20, x19, [sp, #0x30]
ffffff800a2079bc:      	adrp	x8, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff800a2079c0:      	adrp	x9, 0xffffff8009600000 <__start_rodata>
ffffff800a2079c4:      	adrp	x19, 0xffffff800a0f8000 <iw_priv_type_size+0x7a7>
ffffff800a2079c8:      	add	x9, x9, #0x0
ffffff800a2079cc:      	mov	x10, #-0x8000000 // =-134217728
ffffff800a2079d0:      	add	x19, x19, #0xb50
ffffff800a2079d4:      	ldr	x8, [x8, #0xf88]
ffffff800a2079d8:      	mov	x20, x0
ffffff800a2079dc:      	add	x9, x9, x10
ffffff800a2079e0:      	mov	x0, x19
ffffff800a2079e4:      	mov	w1, #0x8        // =8
ffffff800a2079e8:      	str	x8, [sp, #0x8]
ffffff800a2079ec:      	str	x9, [x19]
ffffff800a2079f0:      	bl	0xffffff80080a7f44 <__pi___flush_dcache_area>
ffffff800a2079f4:      	bl	0xffffff800a20a798 <early_fixmap_init>
ffffff800a2079f8:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a2079fc:      	ldr	w8, [x8, #0x620]
ffffff800a207a00:      	cmp	w8, #0x1
ffffff800a207a04:      	b.lt	0xffffff800a207ba4 <kaslr_early_init+0x1fc>
ffffff800a207a08:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a207a0c:      	add	x8, x8, #0x5a8
ffffff800a207a10:      	ldr	w8, [x8, #0x5c]
ffffff800a207a14:      	cmp	w8, #0x0
ffffff800a207a18:      	cset	w8, gt
ffffff800a207a1c:      	mov	x9, #0x713      // =1811
ffffff800a207a20:      	cmp	w8, #0x0
ffffff800a207a24:      	movk	x9, #0x68, lsl #48
ffffff800a207a28:      	mov	x1, sp
ffffff800a207a2c:      	orr	x10, x9, #0x800
ffffff800a207a30:      	mov	x0, x20
ffffff800a207a34:      	csel	x2, x10, x9, ne
ffffff800a207a38:      	bl	0xffffff800a20aa10 <__fixmap_remap_fdt>
ffffff800a207a3c:      	mov	x20, x0
ffffff800a207a40:      	cbz	x0, 0xffffff800a207af4 <kaslr_early_init+0x14c>
ffffff800a207a44:      	adrp	x1, 0xffffff8009e18000 <rtic_mp+0x218000>
ffffff800a207a48:      	mov	x0, x20
ffffff800a207a4c:      	add	x1, x1, #0xfe8
ffffff800a207a50:      	bl	0xffffff8009490128 <fdt_path_offset>
ffffff800a207a54:      	tbnz	w0, #0x1f, 0xffffff800a207af0 <kaslr_early_init+0x148>
ffffff800a207a58:      	adrp	x2, 0xffffff8009e18000 <rtic_mp+0x218000>
ffffff800a207a5c:      	mov	w1, w0
ffffff800a207a60:      	add	x2, x2, #0xff0
ffffff800a207a64:      	add	x3, sp, #0x4
ffffff800a207a68:      	mov	x0, x20
ffffff800a207a6c:      	bl	0xffffff8009490720 <fdt_getprop>
ffffff800a207a70:      	cbz	x0, 0xffffff800a207af0 <kaslr_early_init+0x148>
ffffff800a207a74:      	ldr	w8, [sp, #0x4]
ffffff800a207a78:      	cmp	w8, #0x8
ffffff800a207a7c:      	b.ne	0xffffff800a207af0 <kaslr_early_init+0x148>
ffffff800a207a80:      	ldr	x22, [x0]
ffffff800a207a84:      	str	xzr, [x0]
ffffff800a207a88:      	cbz	x22, 0xffffff800a207af0 <kaslr_early_init+0x148>
ffffff800a207a8c:      	adrp	x1, 0xffffff8009e18000 <rtic_mp+0x218000>
ffffff800a207a90:      	mov	x0, x20
ffffff800a207a94:      	add	x1, x1, #0xfe8
ffffff800a207a98:      	bl	0xffffff8009490128 <fdt_path_offset>
ffffff800a207a9c:      	adrp	x21, 0xffffff800a54a000 <__TRACE_SYSTEM_V4L2_BUF_TYPE_SDR_OUTPUT>
ffffff800a207aa0:      	add	x21, x21, #0x97f
ffffff800a207aa4:      	tbnz	w0, #0x1f, 0xffffff800a207ac8 <kaslr_early_init+0x120>
ffffff800a207aa8:      	adrp	x2, 0xffffff800a0df000 <snd_usbmidi_cin_length+0x8b034>
ffffff800a207aac:      	mov	w1, w0
ffffff800a207ab0:      	add	x2, x2, #0xadb
ffffff800a207ab4:      	mov	x0, x20
ffffff800a207ab8:      	mov	x3, xzr
ffffff800a207abc:      	bl	0xffffff8009490720 <fdt_getprop>
ffffff800a207ac0:      	cmp	x0, #0x0
ffffff800a207ac4:      	csel	x21, x21, x0, eq
ffffff800a207ac8:      	adrp	x1, 0xffffff8009e18000 <rtic_mp+0x218000>
ffffff800a207acc:      	mov	x0, x21
ffffff800a207ad0:      	add	x1, x1, #0xfe0
ffffff800a207ad4:      	bl	0xffffff800949de70 <strstr>
ffffff800a207ad8:      	cmp	x0, x21
ffffff800a207adc:      	b.eq	0xffffff800a207af0 <kaslr_early_init+0x148>
ffffff800a207ae0:      	b.ls	0xffffff800a207b20 <kaslr_early_init+0x178>
ffffff800a207ae4:      	ldurb	w8, [x0, #-0x1]
ffffff800a207ae8:      	cmp	w8, #0x20
ffffff800a207aec:      	b.ne	0xffffff800a207b20 <kaslr_early_init+0x178>
ffffff800a207af0:      	mov	x20, xzr
ffffff800a207af4:      	adrp	x9, 0xffffff800a80d000 <nf_conntrack_locks+0x500>
ffffff800a207af8:      	ldr	x8, [sp, #0x8]
ffffff800a207afc:      	ldr	x9, [x9, #0xf88]
ffffff800a207b00:      	cmp	x9, x8
ffffff800a207b04:      	b.ne	0xffffff800a207bb4 <kaslr_early_init+0x20c>
ffffff800a207b08:      	mov	x0, x20
ffffff800a207b0c:      	ldp	x20, x19, [sp, #0x30]
ffffff800a207b10:      	ldp	x22, x21, [sp, #0x20]
ffffff800a207b14:      	ldp	x29, x30, [sp, #0x10]
ffffff800a207b18:      	add	sp, sp, #0x40
ffffff800a207b1c:      	ret
ffffff800a207b20:      	rev	x8, x22
ffffff800a207b24:      	adrp	x9, 0xffffff8008080000 <_text>
ffffff800a207b28:      	adrp	x11, 0xffffff800b5f0000 <__bss_rtic_start+0x3000>
ffffff800a207b2c:      	add	x9, x9, #0x0
ffffff800a207b30:      	and	x10, x8, #0x1fffe00000
ffffff800a207b34:      	add	x11, x11, #0x0
ffffff800a207b38:      	mov	x13, #0xafff0000 // =2952724480
ffffff800a207b3c:      	and	x12, x8, #0x1fffff
ffffff800a207b40:      	movk	x13, #0x3e, lsl #32
ffffff800a207b44:      	add	x9, x10, x9
ffffff800a207b48:      	add	x11, x10, x11
ffffff800a207b4c:      	adrp	x21, 0xffffff800a2d3000 <boot_command_line+0xfff>
ffffff800a207b50:      	eor	x9, x9, x11
ffffff800a207b54:      	mul	x11, x12, x13
ffffff800a207b58:      	lsr	x9, x9, #30
ffffff800a207b5c:      	cmp	x9, #0x0
ffffff800a207b60:      	mov	x9, #-0x8000000000 // =-549755813888
ffffff800a207b64:      	add	x21, x21, #0x3ac
ffffff800a207b68:      	movk	x9, #0x800, lsl #16
ffffff800a207b6c:      	mov	x0, x19
ffffff800a207b70:      	add	x9, x9, x11, lsr #21
ffffff800a207b74:      	mov	w1, #0x8        // =8
ffffff800a207b78:      	and	x9, x9, #0xfffffffffffff000
ffffff800a207b7c:      	lsr	x12, x8, #48
ffffff800a207b80:      	and	x8, x8, #0x1fc0000000
ffffff800a207b84:      	csel	x20, x8, x10, ne
ffffff800a207b88:      	strh	w12, [x21]
ffffff800a207b8c:      	str	x9, [x19]
ffffff800a207b90:      	bl	0xffffff80080a7f44 <__pi___flush_dcache_area>
ffffff800a207b94:      	mov	x0, x21
ffffff800a207b98:      	mov	w1, #0x2        // =2
ffffff800a207b9c:      	bl	0xffffff80080a7f44 <__pi___flush_dcache_area>
ffffff800a207ba0:      	b	0xffffff800a207af4 <kaslr_early_init+0x14c>
ffffff800a207ba4:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a207ba8:      	ldr	x8, [x8, #0x5a0]
ffffff800a207bac:      	ubfx	x8, x8, #23, #1
ffffff800a207bb0:      	b	0xffffff800a207a1c <kaslr_early_init+0x74>
ffffff800a207bb4:      	bl	0xffffff80080bd9f8 <__stack_chk_fail>

ffffff800a209e50 <paging_init>:
ffffff800a209e50:      	sub	sp, sp, #0x70
ffffff800a209e54:      	stp	x29, x30, [sp, #0x10]
ffffff800a209e58:      	add	x29, sp, #0x10
ffffff800a209e5c:      	stp	x28, x27, [sp, #0x20]
ffffff800a209e60:      	stp	x26, x25, [sp, #0x30]
ffffff800a209e64:      	stp	x24, x23, [sp, #0x40]
ffffff800a209e68:      	stp	x22, x21, [sp, #0x50]
ffffff800a209e6c:      	stp	x20, x19, [sp, #0x60]
ffffff800a209e70:      	adrp	x25, 0xffffff800a0f8000 <iw_priv_type_size+0x7a7>
ffffff800a209e74:      	adrp	x9, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a209e78:      	adrp	x26, 0xffffff800a18f000 <__stop_notes+0x5618>
ffffff800a209e7c:      	adrp	x11, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a209e80:      	add	x26, x26, #0x0
ffffff800a209e84:      	mov	x20, x30
ffffff800a209e88:      	ldr	x8, [x25, #0xb80]
ffffff800a209e8c:      	ldr	w9, [x9, #0x620]
ffffff800a209e90:      	add	x11, x11, #0x5a8
ffffff800a209e94:      	sub	x8, x26, x8
ffffff800a209e98:      	cmp	w9, #0x1
ffffff800a209e9c:      	b.lt	0xffffff800a20a69c <paging_init+0x84c>
ffffff800a209ea0:      	ldr	w9, [x11, #0x5c]
ffffff800a209ea4:      	cmp	w9, #0x0
ffffff800a209ea8:      	cset	w9, gt
ffffff800a209eac:      	mov	x27, #0x713     // =1811
ffffff800a209eb0:      	mov	x10, #-0x1000   // =-4096
ffffff800a209eb4:      	movk	x27, #0x68, lsl #48
ffffff800a209eb8:      	movk	x10, #0xff97, lsl #48
ffffff800a209ebc:      	cmp	w9, #0x0
ffffff800a209ec0:      	orr	x9, x27, #0x800
ffffff800a209ec4:      	and	x8, x8, x10
ffffff800a209ec8:      	csel	x9, x9, x27, ne
ffffff800a209ecc:      	orr	x8, x9, x8
ffffff800a209ed0:      	adrp	x9, 0xffffff800aabb000 <bm_pte>
ffffff800a209ed4:      	add	x9, x9, #0x0
ffffff800a209ed8:      	adrp	x10, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a209edc:      	str	x8, [x9, #0x1c0]
ffffff800a209ee0:      	adrp	x9, 0xffffff800a0f8000 <iw_priv_type_size+0x7a7>
ffffff800a209ee4:      	dsb	ishst
ffffff800a209ee8:      	isb
ffffff800a209eec:      	ldr	x8, [x25, #0xb80]
ffffff800a209ef0:      	ldrb	w9, [x9, #0xab5]
ffffff800a209ef4:      	ldr	w10, [x10, #0x620]
ffffff800a209ef8:      	cmp	w10, #0x1
ffffff800a209efc:      	b.lt	0xffffff800a20a6ac <paging_init+0x85c>
ffffff800a209f00:      	ldr	w10, [x11, #0x5c]
ffffff800a209f04:      	cmp	w10, #0x0
ffffff800a209f08:      	cset	w10, gt
ffffff800a209f0c:      	add	x11, x27, #0x800
ffffff800a209f10:      	cmp	w10, #0x0
ffffff800a209f14:      	mov	x10, #0xf13     // =3859
ffffff800a209f18:      	csel	x11, x11, x27, ne
ffffff800a209f1c:      	movk	x10, #0x40, lsl #48
ffffff800a209f20:      	mov	x12, #0xf13     // =3859
ffffff800a209f24:      	movk	x12, #0x48, lsl #48
ffffff800a209f28:      	and	x10, x11, x10
ffffff800a209f2c:      	adrp	x28, 0xffffff8008080000 <_text>
ffffff800a209f30:      	and	x11, x11, x12
ffffff800a209f34:      	orr	x10, x10, #0x80
ffffff800a209f38:      	add	x28, x28, #0x0
ffffff800a209f3c:      	cmp	w9, #0x0
ffffff800a209f40:      	csel	x21, x11, x10, eq
ffffff800a209f44:      	sub	x22, x28, x8
ffffff800a209f48:      	tst	x22, #0xfff
ffffff800a209f4c:      	b.ne	0xffffff800a20a6bc <paging_init+0x86c>
ffffff800a209f50:      	adrp	x23, 0xffffff8008080000 <_text>
ffffff800a209f54:      	adrp	x9, 0xffffff8009600000 <__start_rodata>
ffffff800a209f58:      	add	x23, x23, #0x0
ffffff800a209f5c:      	add	x9, x9, #0x0
ffffff800a209f60:      	sub	w10, w9, w23
ffffff800a209f64:      	tst	x10, #0xfff
ffffff800a209f68:      	b.ne	0xffffff800a20a6c4 <paging_init+0x874>
ffffff800a209f6c:      	mov	x19, #-0x8000   // =-32768
ffffff800a209f70:      	sub	w8, w26, w8
ffffff800a209f74:      	movk	x19, #0xfe63, lsl #16
ffffff800a209f78:      	sub	x24, x9, x23
ffffff800a209f7c:      	movk	x19, #0xffbe, lsl #32
ffffff800a209f80:      	adrp	x5, 0xffffff800a20a000 <paging_init+0x1b0>
ffffff800a209f84:      	bfxil	x19, x8, #0, #12
ffffff800a209f88:      	add	x5, x5, #0xc88
ffffff800a209f8c:      	mov	x0, x19
ffffff800a209f90:      	mov	x1, x22
ffffff800a209f94:      	mov	x2, x23
ffffff800a209f98:      	mov	x3, x24
ffffff800a209f9c:      	mov	x4, x21
ffffff800a209fa0:      	mov	w6, wzr
ffffff800a209fa4:      	bl	0xffffff80080a8978 <__create_pgd_mapping>
ffffff800a209fa8:      	adrp	x0, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a209fac:      	mov	w8, #0x44       // =68
ffffff800a209fb0:      	add	x0, x0, #0x868
ffffff800a209fb4:      	stp	x23, x24, [x0, #0x8]
ffffff800a209fb8:      	str	x8, [x0, #0x18]
ffffff800a209fbc:      	stp	x22, x20, [x0, #0x30]
ffffff800a209fc0:      	bl	0xffffff800a2255b0 <vm_area_add_early>
ffffff800a209fc4:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a209fc8:      	ldr	w8, [x8, #0x620]
ffffff800a209fcc:      	cmp	w8, #0x1
ffffff800a209fd0:      	b.lt	0xffffff800a20a6cc <paging_init+0x87c>
ffffff800a209fd4:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a209fd8:      	add	x8, x8, #0x5a8
ffffff800a209fdc:      	ldr	w8, [x8, #0x5c]
ffffff800a209fe0:      	cmp	w8, #0x0
ffffff800a209fe4:      	cset	w8, gt
ffffff800a209fe8:      	ldr	x9, [x25, #0xb80]
ffffff800a209fec:      	adrp	x11, 0xffffff8009600000 <__start_rodata>
ffffff800a209ff0:      	add	x10, x27, #0x800
ffffff800a209ff4:      	add	x11, x11, #0x0
ffffff800a209ff8:      	cmp	w8, #0x0
ffffff800a209ffc:      	csel	x4, x10, x27, ne
ffffff800a20a000:      	sub	x22, x11, x9
ffffff800a20a004:      	tst	x22, #0xfff
ffffff800a20a008:      	b.ne	0xffffff800a20a6dc <paging_init+0x88c>
ffffff800a20a00c:      	str	x26, [sp, #0x8]
ffffff800a20a010:      	adrp	x23, 0xffffff8009600000 <__start_rodata>
ffffff800a20a014:      	adrp	x26, 0xffffff800a200000 <stext>
ffffff800a20a018:      	add	x23, x23, #0x0
ffffff800a20a01c:      	add	x26, x26, #0x0
ffffff800a20a020:      	sub	w8, w26, w23
ffffff800a20a024:      	tst	x8, #0xfff
ffffff800a20a028:      	b.ne	0xffffff800a20a6e4 <paging_init+0x894>
ffffff800a20a02c:      	sub	x24, x26, x23
ffffff800a20a030:      	adrp	x5, 0xffffff800a20a000 <paging_init+0x1b0>
ffffff800a20a034:      	add	x5, x5, #0xc88
ffffff800a20a038:      	mov	x0, x19
ffffff800a20a03c:      	mov	x1, x22
ffffff800a20a040:      	mov	x2, x23
ffffff800a20a044:      	mov	x3, x24
ffffff800a20a048:      	mov	w6, #0x2        // =2
ffffff800a20a04c:      	bl	0xffffff80080a8978 <__create_pgd_mapping>
ffffff800a20a050:      	adrp	x0, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a054:      	mov	w8, #0x44       // =68
ffffff800a20a058:      	add	x0, x0, #0x8a8
ffffff800a20a05c:      	stp	x23, x24, [x0, #0x8]
ffffff800a20a060:      	str	x8, [x0, #0x18]
ffffff800a20a064:      	stp	x22, x20, [x0, #0x30]
ffffff800a20a068:      	bl	0xffffff800a2255b0 <vm_area_add_early>
ffffff800a20a06c:      	ldr	x8, [x25, #0xb80]
ffffff800a20a070:      	sub	x22, x26, x8
ffffff800a20a074:      	tst	x22, #0xfff
ffffff800a20a078:      	b.ne	0xffffff800a20a6ec <paging_init+0x89c>
ffffff800a20a07c:      	adrp	x23, 0xffffff800a200000 <stext>
ffffff800a20a080:      	adrp	x8, 0xffffff800a2d1000 <parse_early_param.done>
ffffff800a20a084:      	add	x23, x23, #0x0
ffffff800a20a088:      	add	x8, x8, #0x0
ffffff800a20a08c:      	sub	w9, w8, w23
ffffff800a20a090:      	tst	x9, #0xfff
ffffff800a20a094:      	b.ne	0xffffff800a20a6f4 <paging_init+0x8a4>
ffffff800a20a098:      	sub	x24, x8, x23
ffffff800a20a09c:      	adrp	x5, 0xffffff800a20a000 <paging_init+0x1b0>
ffffff800a20a0a0:      	add	x5, x5, #0xc88
ffffff800a20a0a4:      	mov	x0, x19
ffffff800a20a0a8:      	mov	x1, x22
ffffff800a20a0ac:      	mov	x2, x23
ffffff800a20a0b0:      	mov	x3, x24
ffffff800a20a0b4:      	mov	x4, x21
ffffff800a20a0b8:      	mov	w6, wzr
ffffff800a20a0bc:      	bl	0xffffff80080a8978 <__create_pgd_mapping>
ffffff800a20a0c0:      	adrp	x0, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a0c4:      	mov	w8, #0x44       // =68
ffffff800a20a0c8:      	add	x0, x0, #0x8e8
ffffff800a20a0cc:      	stp	x23, x24, [x0, #0x8]
ffffff800a20a0d0:      	str	x8, [x0, #0x18]
ffffff800a20a0d4:      	stp	x22, x20, [x0, #0x30]
ffffff800a20a0d8:      	bl	0xffffff800a2255b0 <vm_area_add_early>
ffffff800a20a0dc:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a0e0:      	ldr	w8, [x8, #0x620]
ffffff800a20a0e4:      	cmp	w8, #0x1
ffffff800a20a0e8:      	b.lt	0xffffff800a20a6fc <paging_init+0x8ac>
ffffff800a20a0ec:      	adrp	x24, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a0f0:      	adrp	x26, 0xffffff800a18f000 <__stop_notes+0x5618>
ffffff800a20a0f4:      	add	x24, x24, #0x5a8
ffffff800a20a0f8:      	add	x26, x26, #0x0
ffffff800a20a0fc:      	ldr	w8, [x24, #0x5c]
ffffff800a20a100:      	cmp	w8, #0x0
ffffff800a20a104:      	cset	w8, gt
ffffff800a20a108:      	ldr	x9, [x25, #0xb80]
ffffff800a20a10c:      	adrp	x11, 0xffffff800a2d1000 <parse_early_param.done>
ffffff800a20a110:      	add	x10, x27, #0x800
ffffff800a20a114:      	add	x11, x11, #0x0
ffffff800a20a118:      	cmp	w8, #0x0
ffffff800a20a11c:      	csel	x4, x10, x27, ne
ffffff800a20a120:      	sub	x21, x11, x9
ffffff800a20a124:      	tst	x21, #0xfff
ffffff800a20a128:      	b.ne	0xffffff800a20a71c <paging_init+0x8cc>
ffffff800a20a12c:      	adrp	x22, 0xffffff800a2d1000 <parse_early_param.done>
ffffff800a20a130:      	adrp	x8, 0xffffff800a800000 <init_thread_union>
ffffff800a20a134:      	add	x22, x22, #0x0
ffffff800a20a138:      	add	x8, x8, #0x0
ffffff800a20a13c:      	sub	w9, w8, w22
ffffff800a20a140:      	tst	x9, #0xfff
ffffff800a20a144:      	b.ne	0xffffff800a20a724 <paging_init+0x8d4>
ffffff800a20a148:      	sub	x23, x8, x22
ffffff800a20a14c:      	adrp	x5, 0xffffff800a20a000 <paging_init+0x1b0>
ffffff800a20a150:      	add	x5, x5, #0xc88
ffffff800a20a154:      	mov	x0, x19
ffffff800a20a158:      	mov	x1, x21
ffffff800a20a15c:      	mov	x2, x22
ffffff800a20a160:      	mov	x3, x23
ffffff800a20a164:      	mov	w6, wzr
ffffff800a20a168:      	bl	0xffffff80080a8978 <__create_pgd_mapping>
ffffff800a20a16c:      	adrp	x0, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a170:      	mov	w8, #0x44       // =68
ffffff800a20a174:      	add	x0, x0, #0x928
ffffff800a20a178:      	stp	x22, x23, [x0, #0x8]
ffffff800a20a17c:      	str	x8, [x0, #0x18]
ffffff800a20a180:      	stp	x21, x20, [x0, #0x30]
ffffff800a20a184:      	bl	0xffffff800a2255b0 <vm_area_add_early>
ffffff800a20a188:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a18c:      	ldr	w8, [x8, #0x620]
ffffff800a20a190:      	cmp	w8, #0x1
ffffff800a20a194:      	b.lt	0xffffff800a20a72c <paging_init+0x8dc>
ffffff800a20a198:      	ldr	w8, [x24, #0x5c]
ffffff800a20a19c:      	cmp	w8, #0x0
ffffff800a20a1a0:      	cset	w8, gt
ffffff800a20a1a4:      	ldr	x9, [x25, #0xb80]
ffffff800a20a1a8:      	adrp	x11, 0xffffff800a800000 <init_thread_union>
ffffff800a20a1ac:      	add	x10, x27, #0x800
ffffff800a20a1b0:      	add	x11, x11, #0x0
ffffff800a20a1b4:      	cmp	w8, #0x0
ffffff800a20a1b8:      	csel	x4, x10, x27, ne
ffffff800a20a1bc:      	sub	x21, x11, x9
ffffff800a20a1c0:      	tst	x21, #0xfff
ffffff800a20a1c4:      	b.ne	0xffffff800a20a73c <paging_init+0x8ec>
ffffff800a20a1c8:      	adrp	x22, 0xffffff800a800000 <init_thread_union>
ffffff800a20a1cc:      	adrp	x8, 0xffffff800b5f0000 <__bss_rtic_start+0x3000>
ffffff800a20a1d0:      	add	x22, x22, #0x0
ffffff800a20a1d4:      	add	x8, x8, #0x0
ffffff800a20a1d8:      	sub	w9, w8, w22
ffffff800a20a1dc:      	tst	x9, #0xfff
ffffff800a20a1e0:      	b.ne	0xffffff800a20a744 <paging_init+0x8f4>
ffffff800a20a1e4:      	sub	x23, x8, x22
ffffff800a20a1e8:      	adrp	x5, 0xffffff800a20a000 <paging_init+0x1b0>
ffffff800a20a1ec:      	add	x5, x5, #0xc88
ffffff800a20a1f0:      	mov	x0, x19
ffffff800a20a1f4:      	mov	x1, x21
ffffff800a20a1f8:      	mov	x2, x22
ffffff800a20a1fc:      	mov	x3, x23
ffffff800a20a200:      	mov	w6, wzr
ffffff800a20a204:      	bl	0xffffff80080a8978 <__create_pgd_mapping>
ffffff800a20a208:      	adrp	x0, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a20c:      	add	x8, x23, #0x1, lsl #12 // =0x1000
ffffff800a20a210:      	add	x0, x0, #0x968
ffffff800a20a214:      	mov	w9, #0x4        // =4
ffffff800a20a218:      	stp	x22, x8, [x0, #0x8]
ffffff800a20a21c:      	str	x9, [x0, #0x18]
ffffff800a20a220:      	stp	x21, x20, [x0, #0x30]
ffffff800a20a224:      	bl	0xffffff800a2255b0 <vm_area_add_early>
ffffff800a20a228:      	ldr	x8, [x19, #0x7d8]
ffffff800a20a22c:      	cbz	x8, 0xffffff800a20a238 <paging_init+0x3e8>
ffffff800a20a230:      	brk	#0x800
ffffff800a20a234:      	b	0xffffff800a20a234 <paging_init+0x3e4>
ffffff800a20a238:      	adrp	x8, 0xffffff800a89b000 <event_spf_pte_lock+0x18>
ffffff800a20a23c:      	add	x21, x19, #0x7d8
ffffff800a20a240:      	add	x8, x8, #0x470
ffffff800a20a244:      	ldr	x8, [x8, #0x48]
ffffff800a20a248:      	ldr	x20, [x8, #0x7d8]
ffffff800a20a24c:      	eor	x8, x21, x26
ffffff800a20a250:      	adrp	x26, 0xffffff800a0f8000 <iw_priv_type_size+0x7a7>
ffffff800a20a254:      	cmp	x8, #0xfff
ffffff800a20a258:      	b.hi	0xffffff800a20a27c <paging_init+0x42c>
ffffff800a20a25c:      	adrp	x0, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a260:      	add	x0, x0, #0x860
ffffff800a20a264:      	bl	0xffffff80094b7250 <_raw_spin_lock>
ffffff800a20a268:      	tbz	x21, #0x26, 0xffffff800a20a28c <paging_init+0x43c>
ffffff800a20a26c:      	ldr	x8, [x26, #0xb70]
ffffff800a20a270:      	and	x9, x21, #0x3fffffffff
ffffff800a20a274:      	add	x8, x8, x9
ffffff800a20a278:      	b	0xffffff800a20a294 <paging_init+0x444>
ffffff800a20a27c:      	str	x20, [x21]
ffffff800a20a280:      	dsb	ishst
ffffff800a20a284:      	isb
ffffff800a20a288:      	b	0xffffff800a20a348 <paging_init+0x4f8>
ffffff800a20a28c:      	ldr	x8, [x25, #0xb80]
ffffff800a20a290:      	sub	x8, x21, x8
ffffff800a20a294:      	adrp	x9, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a298:      	adrp	x11, 0xffffff800aabb000 <bm_pte>
ffffff800a20a29c:      	mov	x12, #-0x1000   // =-4096
ffffff800a20a2a0:      	add	x11, x11, #0x0
ffffff800a20a2a4:      	movk	x12, #0xff97, lsl #48
ffffff800a20a2a8:      	ldr	w9, [x9, #0x620]
ffffff800a20a2ac:      	cmp	w9, #0x1
ffffff800a20a2b0:      	b.lt	0xffffff800a20a77c <paging_init+0x92c>
ffffff800a20a2b4:      	ldr	w9, [x24, #0x5c]
ffffff800a20a2b8:      	cmp	w9, #0x0
ffffff800a20a2bc:      	cset	w9, gt
ffffff800a20a2c0:      	add	x10, x27, #0x800
ffffff800a20a2c4:      	cmp	w9, #0x0
ffffff800a20a2c8:      	csel	x9, x10, x27, ne
ffffff800a20a2cc:      	and	x8, x8, x12
ffffff800a20a2d0:      	orr	x8, x9, x8
ffffff800a20a2d4:      	str	x8, [x11, #0x1c0]
ffffff800a20a2d8:      	dsb	ishst
ffffff800a20a2dc:      	isb
ffffff800a20a2e0:      	tbz	x21, #0x26, 0xffffff800a20a2f4 <paging_init+0x4a4>
ffffff800a20a2e4:      	ldr	x8, [x26, #0xb70]
ffffff800a20a2e8:      	and	x9, x21, #0x3fffffffff
ffffff800a20a2ec:      	add	x8, x8, x9
ffffff800a20a2f0:      	b	0xffffff800a20a2fc <paging_init+0x4ac>
ffffff800a20a2f4:      	ldr	x8, [x25, #0xb80]
ffffff800a20a2f8:      	sub	x8, x21, x8
ffffff800a20a2fc:      	mov	x9, #-0x8000    // =-32768
ffffff800a20a300:      	and	x8, x8, #0xfff
ffffff800a20a304:      	movk	x9, #0xfe63, lsl #16
ffffff800a20a308:      	adrp	x0, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a30c:      	movk	x9, #0xffbe, lsl #32
ffffff800a20a310:      	add	x0, x0, #0x860
ffffff800a20a314:      	orr	x8, x8, x9
ffffff800a20a318:      	mov	x9, #0xe638     // =58936
ffffff800a20a31c:      	movk	x9, #0xfbef, lsl #16
ffffff800a20a320:      	movk	x9, #0xfff, lsl #32
ffffff800a20a324:      	str	x20, [x8]
ffffff800a20a328:      	str	xzr, [x11, #0x1c0]
ffffff800a20a32c:      	dsb	ishst
ffffff800a20a330:      	tlbi	vaae1is, x9
ffffff800a20a334:      	nop
ffffff800a20a338:      	nop
ffffff800a20a33c:      	dsb	ish
ffffff800a20a340:      	isb
ffffff800a20a344:      	bl	0xffffff80094b7380 <_raw_spin_unlock>
ffffff800a20a348:      	ldr	x8, [x25, #0xb80]
ffffff800a20a34c:      	adrp	x9, 0xffffff800a200000 <stext>
ffffff800a20a350:      	add	x9, x9, #0x0
ffffff800a20a354:      	sub	x20, x28, x8
ffffff800a20a358:      	sub	x8, x9, x8
ffffff800a20a35c:      	sub	x21, x8, x20
ffffff800a20a360:      	mov	x0, x20
ffffff800a20a364:      	mov	x1, x21
ffffff800a20a368:      	bl	0xffffff8008282948 <memblock_mark_nomap>
ffffff800a20a36c:      	adrp	x24, 0xffffff800a89b000 <event_spf_pte_lock+0x18>
ffffff800a20a370:      	mov	w10, #0x18      // =24
ffffff800a20a374:      	add	x24, x24, #0x7e8
ffffff800a20a378:      	ldr	x8, [x24, #0x28]
ffffff800a20a37c:      	ldr	x9, [x24, #0x10]
ffffff800a20a380:      	madd	x10, x9, x10, x8
ffffff800a20a384:      	cmp	x8, x10
ffffff800a20a388:      	b.hs	0xffffff800a20a42c <paging_init+0x5dc>
ffffff800a20a38c:      	adrp	x22, 0xffffff800a20a000 <paging_init+0x1b0>
ffffff800a20a390:      	mov	w28, #0x18      // =24
ffffff800a20a394:      	mov	x23, x8
ffffff800a20a398:      	add	x22, x22, #0xc88
ffffff800a20a39c:      	b	0xffffff800a20a3f4 <paging_init+0x5a4>
ffffff800a20a3a0:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a3a4:      	add	x8, x8, #0x5a8
ffffff800a20a3a8:      	ldr	w8, [x8, #0x5c]
ffffff800a20a3ac:      	cmp	w8, #0x0
ffffff800a20a3b0:      	cset	w8, gt
ffffff800a20a3b4:      	ldr	x9, [x26, #0xb70]
ffffff800a20a3b8:      	add	x10, x27, #0x800
ffffff800a20a3bc:      	cmp	w8, #0x0
ffffff800a20a3c0:      	mov	x0, x19
ffffff800a20a3c4:      	csel	x4, x10, x27, ne
ffffff800a20a3c8:      	mov	x5, x22
ffffff800a20a3cc:      	mov	w6, wzr
ffffff800a20a3d0:      	sub	x8, x1, x9
ffffff800a20a3d4:      	orr	x2, x8, #0xffffffc000000000
ffffff800a20a3d8:      	bl	0xffffff80080a8978 <__create_pgd_mapping>
ffffff800a20a3dc:      	ldr	x8, [x24, #0x28]
ffffff800a20a3e0:      	ldr	x9, [x24, #0x10]
ffffff800a20a3e4:      	madd	x10, x9, x28, x8
ffffff800a20a3e8:      	add	x23, x23, #0x18
ffffff800a20a3ec:      	cmp	x23, x10
ffffff800a20a3f0:      	b.hs	0xffffff800a20a42c <paging_init+0x5dc>
ffffff800a20a3f4:      	ldp	x1, x3, [x23]
ffffff800a20a3f8:      	add	x10, x3, x1
ffffff800a20a3fc:      	cmp	x1, x10
ffffff800a20a400:      	b.hs	0xffffff800a20a42c <paging_init+0x5dc>
ffffff800a20a404:      	ldrb	w10, [x23, #0x10]
ffffff800a20a408:      	tbnz	w10, #0x2, 0xffffff800a20a3e4 <paging_init+0x594>
ffffff800a20a40c:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a410:      	ldr	w8, [x8, #0x620]
ffffff800a20a414:      	cmp	w8, #0x1
ffffff800a20a418:      	b.ge	0xffffff800a20a3a0 <paging_init+0x550>
ffffff800a20a41c:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a420:      	ldr	x8, [x8, #0x5a0]
ffffff800a20a424:      	ubfx	x8, x8, #23, #1
ffffff800a20a428:      	b	0xffffff800a20a3b4 <paging_init+0x564>
ffffff800a20a42c:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a430:      	ldr	w8, [x8, #0x620]
ffffff800a20a434:      	cmp	w8, #0x1
ffffff800a20a438:      	b.lt	0xffffff800a20a74c <paging_init+0x8fc>
ffffff800a20a43c:      	adrp	x24, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a440:      	add	x24, x24, #0x5a8
ffffff800a20a444:      	ldr	w8, [x24, #0x5c]
ffffff800a20a448:      	cmp	w8, #0x0
ffffff800a20a44c:      	cset	w8, gt
ffffff800a20a450:      	ldr	x9, [x26, #0xb70]
ffffff800a20a454:      	add	x10, x27, #0x800
ffffff800a20a458:      	cmp	w8, #0x0
ffffff800a20a45c:      	adrp	x5, 0xffffff800a20a000 <paging_init+0x1b0>
ffffff800a20a460:      	csel	x4, x10, x27, ne
ffffff800a20a464:      	add	x5, x5, #0xc88
ffffff800a20a468:      	mov	x0, x19
ffffff800a20a46c:      	mov	x1, x20
ffffff800a20a470:      	sub	x8, x20, x9
ffffff800a20a474:      	mov	x3, x21
ffffff800a20a478:      	orr	x2, x8, #0xffffffc000000000
ffffff800a20a47c:      	mov	w6, #0x2        // =2
ffffff800a20a480:      	bl	0xffffff80080a8978 <__create_pgd_mapping>
ffffff800a20a484:      	mov	x0, x20
ffffff800a20a488:      	mov	x1, x21
ffffff800a20a48c:      	bl	0xffffff8008282968 <memblock_clear_nomap>
ffffff800a20a490:      	adrp	x9, 0xffffff800aabb000 <bm_pte>
ffffff800a20a494:      	mov	x8, #0xe638     // =58936
ffffff800a20a498:      	add	x9, x9, #0x0
ffffff800a20a49c:      	movk	x8, #0xfbef, lsl #16
ffffff800a20a4a0:      	movk	x8, #0xfff, lsl #32
ffffff800a20a4a4:      	adrp	x21, 0xffffff800aab9000 <empty_zero_page>
ffffff800a20a4a8:      	add	x21, x21, #0x0
ffffff800a20a4ac:      	adrp	x22, 0xffffff800a825000 <armv8_event_attr_stall_frontend>
ffffff800a20a4b0:      	str	xzr, [x9, #0x1c0]
ffffff800a20a4b4:      	dsb	ishst
ffffff800a20a4b8:      	tlbi	vaae1is, x8
ffffff800a20a4bc:      	nop
ffffff800a20a4c0:      	nop
ffffff800a20a4c4:      	dsb	ish
ffffff800a20a4c8:      	isb
ffffff800a20a4cc:      	ldr	x8, [x25, #0xb80]
ffffff800a20a4d0:      	ldr	x9, [x26, #0xb70]
ffffff800a20a4d4:      	sub	x10, x21, x8
ffffff800a20a4d8:      	msr	TTBR0_EL1, x10
ffffff800a20a4dc:      	isb
ffffff800a20a4e0:      	dsb	nshst
ffffff800a20a4e4:      	tlbi	vmalle1
ffffff800a20a4e8:      	nop
ffffff800a20a4ec:      	nop
ffffff800a20a4f0:      	dsb	nsh
ffffff800a20a4f4:      	isb
ffffff800a20a4f8:      	ldr	x10, [x22, #0xa30]
ffffff800a20a4fc:      	cmp	x10, #0x19
ffffff800a20a500:      	b.eq	0xffffff800a20a518 <paging_init+0x6c8>
ffffff800a20a504:      	mrs	x11, TCR_EL1
ffffff800a20a508:      	and	x11, x11, #0xffffffffffffffc0
ffffff800a20a50c:      	orr	x10, x11, x10
ffffff800a20a510:      	msr	TCR_EL1, x10
ffffff800a20a514:      	isb
ffffff800a20a518:      	ldr	x11, [x25, #0xb80]
ffffff800a20a51c:      	adrp	x12, 0xffffff800a18a000 <__stop_notes+0x618>
ffffff800a20a520:      	ldr	x10, [x26, #0xb70]
ffffff800a20a524:      	add	x12, x12, #0x0
ffffff800a20a528:      	adrp	x13, 0xffffff800a18f000 <__stop_notes+0x5618>
ffffff800a20a52c:      	add	x13, x13, #0x0
ffffff800a20a530:      	sub	x12, x12, x11
ffffff800a20a534:      	sub	x10, x12, x10
ffffff800a20a538:      	orr	x12, x10, #0xffffffc000000000
ffffff800a20a53c:      	cmp	x12, x13
ffffff800a20a540:      	b.eq	0xffffff800a20a764 <paging_init+0x914>
ffffff800a20a544:      	ldr	x12, [sp, #0x8]
ffffff800a20a548:      	sub	x11, x21, x11
ffffff800a20a54c:      	msr	TTBR0_EL1, x11
ffffff800a20a550:      	isb
ffffff800a20a554:      	adrp	x19, 0xffffff800a89b000 <event_spf_pte_lock+0x18>
ffffff800a20a558:      	adrp	x13, 0xffffff80094b9000 <kimage_vaddr>
ffffff800a20a55c:      	add	x13, x13, #0x3cc
ffffff800a20a560:      	add	x19, x19, #0x470
ffffff800a20a564:      	sub	x12, x12, x8
ffffff800a20a568:      	mov	x1, x19
ffffff800a20a56c:      	sub	x11, x12, x9
ffffff800a20a570:      	ldr	x12, [x26, #0xb70]
ffffff800a20a574:      	and	x11, x11, #0x3fffffffff
ffffff800a20a578:      	sub	x23, x13, x8
ffffff800a20a57c:      	add	x20, x11, x9
ffffff800a20a580:      	and	x9, x10, #0x3fffffffff
ffffff800a20a584:      	add	x0, x12, x9
ffffff800a20a588:      	bl	0xffffff80080aa488 <cpu_do_switch_mm>
ffffff800a20a58c:      	mov	x0, x20
ffffff800a20a590:      	blr	x23
ffffff800a20a594:      	ldr	x8, [x25, #0xb80]
ffffff800a20a598:      	mrs	x9, SP_EL0
ffffff800a20a59c:      	ldr	x1, [x9, #0x5a8]
ffffff800a20a5a0:      	sub	x8, x21, x8
ffffff800a20a5a4:      	msr	TTBR0_EL1, x8
ffffff800a20a5a8:      	isb
ffffff800a20a5ac:      	dsb	nshst
ffffff800a20a5b0:      	tlbi	vmalle1
ffffff800a20a5b4:      	nop
ffffff800a20a5b8:      	nop
ffffff800a20a5bc:      	dsb	nsh
ffffff800a20a5c0:      	isb
ffffff800a20a5c4:      	ldr	x8, [x22, #0xa30]
ffffff800a20a5c8:      	cmp	x8, #0x19
ffffff800a20a5cc:      	b.eq	0xffffff800a20a5e4 <paging_init+0x794>
ffffff800a20a5d0:      	mov	x8, #0x19       // =25
ffffff800a20a5d4:      	mrs	x9, TCR_EL1
ffffff800a20a5d8:      	bfxil	x9, x8, #0, #6
ffffff800a20a5dc:      	msr	TCR_EL1, x9
ffffff800a20a5e0:      	isb
ffffff800a20a5e4:      	cmp	x1, x19
ffffff800a20a5e8:      	b.eq	0xffffff800a20a64c <paging_init+0x7fc>
ffffff800a20a5ec:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a5f0:      	ldr	w8, [x8, #0x620]
ffffff800a20a5f4:      	cmp	w8, #0x1
ffffff800a20a5f8:      	b.lt	0xffffff800a20a76c <paging_init+0x91c>
ffffff800a20a5fc:      	ldr	w8, [x24, #0x10]
ffffff800a20a600:      	cmp	w8, #0x0
ffffff800a20a604:      	b.le	0xffffff800a20a64c <paging_init+0x7fc>
ffffff800a20a608:      	ldr	x8, [x1, #0x48]
ffffff800a20a60c:      	adrp	x9, 0xffffff800a18f000 <__stop_notes+0x5618>
ffffff800a20a610:      	add	x9, x9, #0x0
ffffff800a20a614:      	cmp	x8, x9
ffffff800a20a618:      	b.eq	0xffffff800a20a78c <paging_init+0x93c>
ffffff800a20a61c:      	ldr	x9, [x25, #0xb80]
ffffff800a20a620:      	sub	x9, x21, x9
ffffff800a20a624:      	msr	TTBR0_EL1, x9
ffffff800a20a628:      	isb
ffffff800a20a62c:      	tbnz	x8, #0x26, 0xffffff800a20a63c <paging_init+0x7ec>
ffffff800a20a630:      	ldr	x9, [x25, #0xb80]
ffffff800a20a634:      	sub	x0, x8, x9
ffffff800a20a638:      	b	0xffffff800a20a648 <paging_init+0x7f8>
ffffff800a20a63c:      	ldr	x9, [x26, #0xb70]
ffffff800a20a640:      	and	x8, x8, #0x3fffffffff
ffffff800a20a644:      	add	x0, x9, x8
ffffff800a20a648:      	bl	0xffffff80080aa488 <cpu_do_switch_mm>
ffffff800a20a64c:      	ldr	x8, [x25, #0xb80]
ffffff800a20a650:      	adrp	x9, 0xffffff800b5ed000 <__bss_rtic_start>
ffffff800a20a654:      	adrp	x10, 0xffffff800b5f0000 <__bss_rtic_start+0x3000>
ffffff800a20a658:      	add	x9, x9, #0x0
ffffff800a20a65c:      	add	x10, x10, #0x0
ffffff800a20a660:      	sub	x0, x9, x8
ffffff800a20a664:      	sub	x8, x10, x8
ffffff800a20a668:      	sub	x1, x8, x0
ffffff800a20a66c:      	adrp	x8, 0xffffff800a18f000 <__stop_notes+0x5618>
ffffff800a20a670:      	add	x8, x8, #0x0
ffffff800a20a674:      	str	x8, [x19, #0x48]
ffffff800a20a678:      	bl	0xffffff8008282500 <memblock_free>
ffffff800a20a67c:      	ldp	x20, x19, [sp, #0x60]
ffffff800a20a680:      	ldp	x22, x21, [sp, #0x50]
ffffff800a20a684:      	ldp	x24, x23, [sp, #0x40]
ffffff800a20a688:      	ldp	x26, x25, [sp, #0x30]
ffffff800a20a68c:      	ldp	x28, x27, [sp, #0x20]
ffffff800a20a690:      	ldp	x29, x30, [sp, #0x10]
ffffff800a20a694:      	add	sp, sp, #0x70
ffffff800a20a698:      	ret
ffffff800a20a69c:      	adrp	x9, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a6a0:      	ldr	x9, [x9, #0x5a0]
ffffff800a20a6a4:      	ubfx	x9, x9, #23, #1
ffffff800a20a6a8:      	b	0xffffff800a209eac <paging_init+0x5c>
ffffff800a20a6ac:      	adrp	x10, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a6b0:      	ldr	x10, [x10, #0x5a0]
ffffff800a20a6b4:      	ubfx	x10, x10, #23, #1
ffffff800a20a6b8:      	b	0xffffff800a209f0c <paging_init+0xbc>
ffffff800a20a6bc:      	brk	#0x800
ffffff800a20a6c0:      	b	0xffffff800a20a6c0 <paging_init+0x870>
ffffff800a20a6c4:      	brk	#0x800
ffffff800a20a6c8:      	b	0xffffff800a20a6c8 <paging_init+0x878>
ffffff800a20a6cc:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a6d0:      	ldr	x8, [x8, #0x5a0]
ffffff800a20a6d4:      	ubfx	x8, x8, #23, #1
ffffff800a20a6d8:      	b	0xffffff800a209fe8 <paging_init+0x198>
ffffff800a20a6dc:      	brk	#0x800
ffffff800a20a6e0:      	b	0xffffff800a20a6e0 <paging_init+0x890>
ffffff800a20a6e4:      	brk	#0x800
ffffff800a20a6e8:      	b	0xffffff800a20a6e8 <paging_init+0x898>
ffffff800a20a6ec:      	brk	#0x800
ffffff800a20a6f0:      	b	0xffffff800a20a6f0 <paging_init+0x8a0>
ffffff800a20a6f4:      	brk	#0x800
ffffff800a20a6f8:      	b	0xffffff800a20a6f8 <paging_init+0x8a8>
ffffff800a20a6fc:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a700:      	adrp	x26, 0xffffff800a18f000 <__stop_notes+0x5618>
ffffff800a20a704:      	adrp	x24, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a708:      	add	x26, x26, #0x0
ffffff800a20a70c:      	add	x24, x24, #0x5a8
ffffff800a20a710:      	ldr	x8, [x8, #0x5a0]
ffffff800a20a714:      	ubfx	x8, x8, #23, #1
ffffff800a20a718:      	b	0xffffff800a20a108 <paging_init+0x2b8>
ffffff800a20a71c:      	brk	#0x800
ffffff800a20a720:      	b	0xffffff800a20a720 <paging_init+0x8d0>
ffffff800a20a724:      	brk	#0x800
ffffff800a20a728:      	b	0xffffff800a20a728 <paging_init+0x8d8>
ffffff800a20a72c:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a730:      	ldr	x8, [x8, #0x5a0]
ffffff800a20a734:      	ubfx	x8, x8, #23, #1
ffffff800a20a738:      	b	0xffffff800a20a1a4 <paging_init+0x354>
ffffff800a20a73c:      	brk	#0x800
ffffff800a20a740:      	b	0xffffff800a20a740 <paging_init+0x8f0>
ffffff800a20a744:      	brk	#0x800
ffffff800a20a748:      	b	0xffffff800a20a748 <paging_init+0x8f8>
ffffff800a20a74c:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a750:      	adrp	x24, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a754:      	add	x24, x24, #0x5a8
ffffff800a20a758:      	ldr	x8, [x8, #0x5a0]
ffffff800a20a75c:      	ubfx	x8, x8, #23, #1
ffffff800a20a760:      	b	0xffffff800a20a450 <paging_init+0x600>
ffffff800a20a764:      	brk	#0x800
ffffff800a20a768:      	b	0xffffff800a20a768 <paging_init+0x918>
ffffff800a20a76c:      	adrp	x8, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a770:      	ldr	x8, [x8, #0x5a0]
ffffff800a20a774:      	tbnz	w8, #0x4, 0xffffff800a20a608 <paging_init+0x7b8>
ffffff800a20a778:      	b	0xffffff800a20a64c <paging_init+0x7fc>
ffffff800a20a77c:      	adrp	x9, 0xffffff800aabc000 <bsp_test_mode>
ffffff800a20a780:      	ldr	x9, [x9, #0x5a0]
ffffff800a20a784:      	ubfx	x9, x9, #23, #1
ffffff800a20a788:      	b	0xffffff800a20a2c0 <paging_init+0x470>
ffffff800a20a78c:      	brk	#0x800
ffffff800a20a790:      	b	0xffffff800a20a790 <paging_init+0x940>
ffffff800a20a794:      	nop

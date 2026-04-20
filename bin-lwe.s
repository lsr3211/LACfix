	.arch armv8-a
	.file	"bin-lwe.c"
	.text
	.align	2
	.global	gen_a
	.type	gen_a, %function
gen_a:
.LFB0:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, 64]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 64
	str	x0, [sp, 8]
	str	x1, [sp]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 56]
	mov	x1, 0
	ldr	x0, [sp, 8]
	cmp	x0, 0
	beq	.L2
	ldr	x0, [sp]
	cmp	x0, 0
	bne	.L3
.L2:
	mov	w0, 1
	b	.L10
.L3:
	ldr	x2, [sp]
	mov	w1, 512
	ldr	x0, [sp, 8]
	bl	pseudo_random_bytes
	add	x0, sp, 24
	mov	x2, x0
	mov	w1, 32
	ldr	x0, [sp]
	bl	hash
	str	wzr, [sp, 20]
	str	wzr, [sp, 16]
	b	.L5
.L8:
	ldrsw	x0, [sp, 16]
	ldr	x1, [sp, 8]
	add	x1, x1, x0
	ldr	w0, [sp, 20]
	add	w2, w0, 1
	str	w2, [sp, 20]
	sxtw	x0, w0
	add	x2, sp, 24
	add	x0, x2, x0
	ldrb	w0, [x0]
	strb	w0, [x1]
	ldr	w0, [sp, 20]
	cmp	w0, 31
	ble	.L7
	add	x1, sp, 24
	add	x0, sp, 24
	mov	x2, x1
	mov	w1, 32
	bl	hash
	str	wzr, [sp, 20]
.L7:
	ldrsw	x0, [sp, 16]
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldrb	w0, [x0]
	cmp	w0, 250
	bhi	.L8
	ldr	w0, [sp, 16]
	add	w0, w0, 1
	str	w0, [sp, 16]
.L5:
	ldr	w0, [sp, 16]
	cmp	w0, 511
	ble	.L7
	mov	w0, 0
.L10:
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 56]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L11
	bl	__stack_chk_fail
.L11:
	mov	w0, w1
	ldp	x29, x30, [sp, 64]
	add	sp, sp, 80
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	gen_a, .-gen_a
	.align	2
	.global	gen_psi_fix_ham
	.type	gen_psi_fix_ham, %function
gen_psi_fix_ham:
.LFB1:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	.cfi_def_cfa_register 29
	str	x19, [sp, 16]
	sub	sp, sp, #144
	.cfi_offset 19, -16
	str	x0, [x29, -104]
	str	w1, [x29, -108]
	str	x2, [x29, -120]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [x29, -8]
	mov	x1, 0
	mov	x0, sp
	mov	x19, x0
	ldr	x0, [x29, -104]
	cmp	x0, 0
	bne	.L13
	mov	w0, 1
	b	.L14
.L13:
	ldr	w0, [x29, -108]
	uxtw	x1, w0
	sub	x1, x1, #1
	str	x1, [x29, -64]
	uxtw	x1, w0
	mov	x10, x1
	mov	x11, 0
	lsr	x1, x10, 61
	lsl	x7, x11, 3
	orr	x7, x1, x7
	lsl	x6, x10, 3
	uxtw	x1, w0
	mov	x8, x1
	mov	x9, 0
	lsr	x1, x8, 61
	lsl	x5, x9, 3
	orr	x5, x1, x5
	lsl	x4, x8, 3
	uxtw	x0, w0
	add	x0, x0, 15
	lsr	x0, x0, 4
	lsl	x0, x0, 4
	and	x1, x0, -65536
	sub	x1, sp, x1
.L15:
	cmp	sp, x1
	beq	.L16
	sub	sp, sp, #65536
	str	xzr, [sp, 1024]
	b	.L15
.L16:
	and	x1, x0, 65535
	sub	sp, sp, x1
	str	xzr, [sp]
	and	x0, x0, 65535
	cmp	x0, 1024
	bcc	.L17
	str	xzr, [sp, 1024]
.L17:
	add	x0, sp, 16
	add	x0, x0, 0
	str	x0, [x29, -56]
	ldr	x2, [x29, -120]
	ldr	w1, [x29, -108]
	ldr	x0, [x29, -56]
	bl	pseudo_random_bytes
	ldr	w0, [x29, -108]
	lsr	w0, w0, 2
	str	w0, [x29, -72]
	ldr	w0, [x29, -108]
	lsr	w0, w0, 1
	str	w0, [x29, -68]
	ldr	w0, [x29, -108]
	mov	x2, x0
	mov	w1, 0
	ldr	x0, [x29, -104]
	bl	memset
	mov	w0, 511
	strh	w0, [x29, -82]
	sub	x0, x29, #40
	mov	x2, x0
	mov	w1, 32
	ldr	x0, [x29, -120]
	bl	hash
	ldr	x0, [x29, -56]
	str	x0, [x29, -48]
	str	wzr, [x29, -76]
	str	wzr, [x29, -80]
	b	.L18
.L21:
	ldrsw	x0, [x29, -80]
	lsl	x0, x0, 1
	ldr	x1, [x29, -48]
	add	x0, x1, x0
	ldrsw	x1, [x29, -76]
	sub	x2, x29, #40
	add	x1, x2, x1
	ldrh	w1, [x1]
	strh	w1, [x0]
	ldr	w0, [x29, -76]
	add	w0, w0, 2
	str	w0, [x29, -76]
	ldr	w0, [x29, -76]
	cmp	w0, 31
	ble	.L20
	sub	x1, x29, #40
	sub	x0, x29, #40
	mov	x2, x1
	mov	w1, 32
	bl	hash
	str	wzr, [x29, -76]
.L20:
	ldrsw	x0, [x29, -80]
	lsl	x0, x0, 1
	ldr	x1, [x29, -48]
	add	x0, x1, x0
	ldrh	w1, [x0]
	ldrh	w0, [x29, -82]
	and	w0, w1, w0
	and	w0, w0, 65535
	and	x0, x0, 65535
	ldr	x1, [x29, -104]
	add	x0, x1, x0
	ldrb	w0, [x0]
	cmp	w0, 0
	bne	.L21
	ldrsw	x0, [x29, -80]
	lsl	x0, x0, 1
	ldr	x1, [x29, -48]
	add	x0, x1, x0
	ldrh	w1, [x0]
	ldrh	w0, [x29, -82]
	and	w0, w1, w0
	and	w0, w0, 65535
	and	x0, x0, 65535
	ldr	x1, [x29, -104]
	add	x0, x1, x0
	mov	w1, 1
	strb	w1, [x0]
	ldr	w0, [x29, -80]
	add	w0, w0, 1
	str	w0, [x29, -80]
.L18:
	ldr	w1, [x29, -80]
	ldr	w0, [x29, -72]
	cmp	w1, w0
	blt	.L20
	ldr	w0, [x29, -72]
	str	w0, [x29, -80]
	b	.L23
.L26:
	ldrsw	x0, [x29, -80]
	lsl	x0, x0, 1
	ldr	x1, [x29, -48]
	add	x0, x1, x0
	ldrsw	x1, [x29, -76]
	sub	x2, x29, #40
	add	x1, x2, x1
	ldrh	w1, [x1]
	strh	w1, [x0]
	ldr	w0, [x29, -76]
	add	w0, w0, 2
	str	w0, [x29, -76]
	ldr	w0, [x29, -76]
	cmp	w0, 31
	ble	.L25
	sub	x1, x29, #40
	sub	x0, x29, #40
	mov	x2, x1
	mov	w1, 32
	bl	hash
	str	wzr, [x29, -76]
.L25:
	ldrsw	x0, [x29, -80]
	lsl	x0, x0, 1
	ldr	x1, [x29, -48]
	add	x0, x1, x0
	ldrh	w1, [x0]
	ldrh	w0, [x29, -82]
	and	w0, w1, w0
	and	w0, w0, 65535
	and	x0, x0, 65535
	ldr	x1, [x29, -104]
	add	x0, x1, x0
	ldrb	w0, [x0]
	cmp	w0, 0
	bne	.L26
	ldrsw	x0, [x29, -80]
	lsl	x0, x0, 1
	ldr	x1, [x29, -48]
	add	x0, x1, x0
	ldrh	w1, [x0]
	ldrh	w0, [x29, -82]
	and	w0, w1, w0
	and	w0, w0, 65535
	and	x0, x0, 65535
	ldr	x1, [x29, -104]
	add	x0, x1, x0
	mov	w1, -1
	strb	w1, [x0]
	ldr	w0, [x29, -80]
	add	w0, w0, 1
	str	w0, [x29, -80]
.L23:
	ldr	w1, [x29, -80]
	ldr	w0, [x29, -68]
	cmp	w1, w0
	blt	.L25
	mov	w0, 0
.L14:
	mov	sp, x19
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [x29, -8]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L29
	bl	__stack_chk_fail
.L29:
	mov	w0, w1
	mov	sp, x29
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE1:
	.size	gen_psi_fix_ham, .-gen_psi_fix_ham
	.align	2
	.global	gen_psi_std
	.type	gen_psi_std, %function
gen_psi_std:
.LFB2:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	.cfi_def_cfa_register 29
	str	x19, [sp, 16]
	sub	sp, sp, #96
	.cfi_offset 19, -16
	str	x0, [x29, -56]
	str	w1, [x29, -60]
	str	x2, [x29, -72]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [x29, -8]
	mov	x1, 0
	mov	x0, sp
	mov	x19, x0
	ldr	x0, [x29, -56]
	cmp	x0, 0
	bne	.L31
	mov	w0, 1
	b	.L32
.L31:
	ldr	w0, [x29, -60]
	lsr	w0, w0, 2
	uxtw	x1, w0
	sub	x1, x1, #1
	str	x1, [x29, -32]
	uxtw	x1, w0
	mov	x10, x1
	mov	x11, 0
	lsr	x1, x10, 61
	lsl	x7, x11, 3
	orr	x7, x1, x7
	lsl	x6, x10, 3
	uxtw	x1, w0
	mov	x8, x1
	mov	x9, 0
	lsr	x1, x8, 61
	lsl	x5, x9, 3
	orr	x5, x1, x5
	lsl	x4, x8, 3
	uxtw	x0, w0
	add	x0, x0, 15
	lsr	x0, x0, 4
	lsl	x0, x0, 4
	and	x1, x0, -65536
	sub	x1, sp, x1
.L33:
	cmp	sp, x1
	beq	.L34
	sub	sp, sp, #65536
	str	xzr, [sp, 1024]
	b	.L33
.L34:
	and	x1, x0, 65535
	sub	sp, sp, x1
	str	xzr, [sp]
	and	x0, x0, 65535
	cmp	x0, 1024
	bcc	.L35
	str	xzr, [sp, 1024]
.L35:
	add	x0, sp, 16
	add	x0, x0, 0
	str	x0, [x29, -24]
	ldr	w0, [x29, -60]
	lsr	w0, w0, 2
	ldr	x2, [x29, -72]
	mov	w1, w0
	ldr	x0, [x29, -24]
	bl	pseudo_random_bytes
	ldr	w0, [x29, -60]
	lsr	w0, w0, 3
	uxtw	x0, w0
	ldr	x1, [x29, -24]
	add	x0, x1, x0
	str	x0, [x29, -16]
	str	wzr, [x29, -36]
	b	.L36
.L37:
	ldr	w0, [x29, -36]
	add	w1, w0, 7
	cmp	w0, 0
	csel	w0, w1, w0, lt
	asr	w0, w0, 3
	ldr	x1, [x29, -24]
	sxtw	x0, w0
	ldrb	w0, [x1, x0]
	mov	w1, w0
	ldr	w0, [x29, -36]
	and	w0, w0, 7
	asr	w0, w1, w0
	and	w0, w0, 255
	and	w0, w0, 1
	and	w2, w0, 255
	ldr	w0, [x29, -36]
	add	w1, w0, 7
	cmp	w0, 0
	csel	w0, w1, w0, lt
	asr	w0, w0, 3
	sxtw	x0, w0
	ldr	x1, [x29, -16]
	add	x0, x1, x0
	ldrb	w0, [x0]
	mov	w1, w0
	ldr	w0, [x29, -36]
	and	w0, w0, 7
	asr	w0, w1, w0
	and	w0, w0, 255
	and	w0, w0, 1
	and	w1, w0, 255
	ldrsw	x0, [x29, -36]
	ldr	x3, [x29, -56]
	add	x0, x3, x0
	sub	w1, w2, w1
	and	w1, w1, 255
	strb	w1, [x0]
	ldr	w0, [x29, -36]
	add	w0, w0, 1
	str	w0, [x29, -36]
.L36:
	ldr	w0, [x29, -36]
	ldr	w1, [x29, -60]
	cmp	w1, w0
	bhi	.L37
	mov	w0, 0
.L32:
	mov	sp, x19
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [x29, -8]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L39
	bl	__stack_chk_fail
.L39:
	mov	w0, w1
	mov	sp, x29
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE2:
	.size	gen_psi_std, .-gen_psi_std
	.align	2
	.global	poly_mul
	.type	poly_mul, %function
poly_mul:
.LFB3:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	mov	x13, 4192
	sub	sp, sp, x13
	.cfi_def_cfa_offset 4208
	str	xzr, [sp, 1024]
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	x2, [sp, 8]
	str	w3, [sp, 4]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 4184]
	mov	x1, 0
	add	x0, sp, 88
	mov	x2, 1024
	mov	w1, 0
	bl	memset
	add	x0, sp, 1112
	mov	x2, 1024
	mov	w1, 0
	bl	memset
	str	wzr, [sp, 32]
	b	.L41
.L43:
	mov	w1, 511
	ldr	w0, [sp, 32]
	sub	w0, w1, w0
	sxtw	x0, w0
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldrb	w0, [x0]
	sxth	w2, w0
	ldrsw	x0, [sp, 32]
	lsl	x0, x0, 1
	add	x1, sp, 2136
	strh	w2, [x1, x0]
	ldrsw	x0, [sp, 32]
	lsl	x0, x0, 1
	add	x1, sp, 2136
	ldrsh	w0, [x1, x0]
	and	w0, w0, 65535
	mov	w1, 251
	sub	w0, w1, w0
	and	w1, w0, 65535
	ldr	w0, [sp, 32]
	add	w0, w0, 512
	sxth	w2, w1
	sxtw	x0, w0
	lsl	x0, x0, 1
	add	x1, sp, 2136
	strh	w2, [x1, x0]
	ldrsw	x0, [sp, 32]
	ldr	x1, [sp, 16]
	add	x0, x1, x0
	ldrb	w0, [x0]
	cmp	w0, 1
	bne	.L42
	ldrsw	x0, [sp, 32]
	lsl	x0, x0, 1
	add	x1, sp, 1112
	mov	w2, -1
	strh	w2, [x1, x0]
.L42:
	ldr	w0, [sp, 32]
	add	w0, w0, 1
	str	w0, [sp, 32]
.L41:
	ldr	w0, [sp, 32]
	cmp	w0, 511
	ble	.L43
	str	wzr, [sp, 32]
	b	.L44
.L47:
	ldrsw	x0, [sp, 32]
	mov	x1, 512
	sub	x0, x1, x0
	lsl	x0, x0, 1
	sub	x0, x0, #2
	add	x1, sp, 2136
	add	x0, x1, x0
	str	x0, [sp, 48]
	add	x0, sp, 88
	str	x0, [sp, 56]
	add	x0, sp, 1112
	str	x0, [sp, 64]
	str	xzr, [sp, 72]
	str	xzr, [sp, 80]
	str	wzr, [sp, 36]
	b	.L45
.L46:
	ldr	x0, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 56]
	add	x2, x0, 8
	str	x2, [sp, 56]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 72]
	add	x0, x1, x0
	str	x0, [sp, 72]
	ldr	x0, [sp, 48]
	add	x1, x0, 8
	str	x1, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 64]
	add	x2, x0, 8
	str	x2, [sp, 64]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 80]
	add	x0, x1, x0
	str	x0, [sp, 80]
	ldr	x0, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 56]
	add	x2, x0, 8
	str	x2, [sp, 56]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 72]
	add	x0, x1, x0
	str	x0, [sp, 72]
	ldr	x0, [sp, 48]
	add	x1, x0, 8
	str	x1, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 64]
	add	x2, x0, 8
	str	x2, [sp, 64]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 80]
	add	x0, x1, x0
	str	x0, [sp, 80]
	ldr	x0, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 56]
	add	x2, x0, 8
	str	x2, [sp, 56]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 72]
	add	x0, x1, x0
	str	x0, [sp, 72]
	ldr	x0, [sp, 48]
	add	x1, x0, 8
	str	x1, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 64]
	add	x2, x0, 8
	str	x2, [sp, 64]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 80]
	add	x0, x1, x0
	str	x0, [sp, 80]
	ldr	x0, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 56]
	add	x2, x0, 8
	str	x2, [sp, 56]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 72]
	add	x0, x1, x0
	str	x0, [sp, 72]
	ldr	x0, [sp, 48]
	add	x1, x0, 8
	str	x1, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 64]
	add	x2, x0, 8
	str	x2, [sp, 64]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 80]
	add	x0, x1, x0
	str	x0, [sp, 80]
	ldr	x0, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 56]
	add	x2, x0, 8
	str	x2, [sp, 56]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 72]
	add	x0, x1, x0
	str	x0, [sp, 72]
	ldr	x0, [sp, 48]
	add	x1, x0, 8
	str	x1, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 64]
	add	x2, x0, 8
	str	x2, [sp, 64]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 80]
	add	x0, x1, x0
	str	x0, [sp, 80]
	ldr	x0, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 56]
	add	x2, x0, 8
	str	x2, [sp, 56]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 72]
	add	x0, x1, x0
	str	x0, [sp, 72]
	ldr	x0, [sp, 48]
	add	x1, x0, 8
	str	x1, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 64]
	add	x2, x0, 8
	str	x2, [sp, 64]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 80]
	add	x0, x1, x0
	str	x0, [sp, 80]
	ldr	x0, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 56]
	add	x2, x0, 8
	str	x2, [sp, 56]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 72]
	add	x0, x1, x0
	str	x0, [sp, 72]
	ldr	x0, [sp, 48]
	add	x1, x0, 8
	str	x1, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 64]
	add	x2, x0, 8
	str	x2, [sp, 64]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 80]
	add	x0, x1, x0
	str	x0, [sp, 80]
	ldr	x0, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 56]
	add	x2, x0, 8
	str	x2, [sp, 56]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 72]
	add	x0, x1, x0
	str	x0, [sp, 72]
	ldr	x0, [sp, 48]
	add	x1, x0, 8
	str	x1, [sp, 48]
	ldr	x1, [x0]
	ldr	x0, [sp, 64]
	add	x2, x0, 8
	str	x2, [sp, 64]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 80]
	add	x0, x1, x0
	str	x0, [sp, 80]
	ldr	w0, [sp, 36]
	add	w0, w0, 32
	str	w0, [sp, 36]
.L45:
	ldr	w0, [sp, 36]
	cmp	w0, 511
	ble	.L46
	ldr	x0, [sp, 72]
	and	w1, w0, 65535
	ldr	x0, [sp, 72]
	asr	x0, x0, 16
	and	w0, w0, 65535
	add	w1, w1, w0
	ldr	x0, [sp, 72]
	asr	x0, x0, 32
	and	w0, w0, 65535
	add	w0, w1, w0
	ldr	x1, [sp, 72]
	lsr	x1, x1, 48
	add	w0, w0, w1
	str	w0, [sp, 40]
	ldr	x0, [sp, 80]
	and	w1, w0, 65535
	ldr	x0, [sp, 80]
	asr	x0, x0, 16
	and	w0, w0, 65535
	add	w1, w1, w0
	ldr	x0, [sp, 80]
	asr	x0, x0, 32
	and	w0, w0, 65535
	add	w0, w1, w0
	ldr	x1, [sp, 80]
	lsr	x1, x1, 48
	add	w0, w0, w1
	str	w0, [sp, 44]
	ldr	w1, [sp, 44]
	ldr	w0, [sp, 40]
	sub	w1, w1, w0
	mov	w0, 60416
	movk	w0, 0x3, lsl 16
	add	w0, w1, w0
	mov	w1, 49087
	movk	w1, 0x828c, lsl 16
	smull	x1, w0, w1
	lsr	x1, x1, 32
	add	w1, w0, w1
	asr	w2, w1, 7
	asr	w1, w0, 31
	sub	w1, w2, w1
	mov	w2, 251
	mul	w1, w1, w2
	sub	w1, w0, w1
	ldrsw	x0, [sp, 32]
	ldr	x2, [sp, 8]
	add	x0, x2, x0
	and	w1, w1, 255
	strb	w1, [x0]
	ldr	w0, [sp, 32]
	add	w0, w0, 1
	str	w0, [sp, 32]
.L44:
	ldr	w0, [sp, 32]
	ldr	w1, [sp, 4]
	cmp	w1, w0
	bhi	.L47
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 4184]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L49
	bl	__stack_chk_fail
.L49:
	mov	w0, w1
	mov	x13, 4192
	add	sp, sp, x13
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE3:
	.size	poly_mul, .-poly_mul
	.align	2
	.global	poly_aff
	.type	poly_aff, %function
poly_aff:
.LFB4:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	mov	x13, 4208
	sub	sp, sp, x13
	.cfi_def_cfa_offset 4224
	str	xzr, [sp, 1024]
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	str	x2, [sp, 24]
	str	x3, [sp, 16]
	str	w4, [sp, 12]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 4200]
	mov	x1, 0
	add	x0, sp, 104
	mov	x2, 1024
	mov	w1, 0
	bl	memset
	add	x0, sp, 1128
	mov	x2, 1024
	mov	w1, 0
	bl	memset
	str	wzr, [sp, 48]
	b	.L51
.L53:
	mov	w1, 511
	ldr	w0, [sp, 48]
	sub	w0, w1, w0
	sxtw	x0, w0
	ldr	x1, [sp, 40]
	add	x0, x1, x0
	ldrb	w0, [x0]
	sxth	w2, w0
	ldrsw	x0, [sp, 48]
	lsl	x0, x0, 1
	add	x1, sp, 2152
	strh	w2, [x1, x0]
	ldrsw	x0, [sp, 48]
	lsl	x0, x0, 1
	add	x1, sp, 2152
	ldrsh	w0, [x1, x0]
	and	w0, w0, 65535
	mov	w1, 251
	sub	w0, w1, w0
	and	w1, w0, 65535
	ldr	w0, [sp, 48]
	add	w0, w0, 512
	sxth	w2, w1
	sxtw	x0, w0
	lsl	x0, x0, 1
	add	x1, sp, 2152
	strh	w2, [x1, x0]
	ldrsw	x0, [sp, 48]
	ldr	x1, [sp, 32]
	add	x0, x1, x0
	ldrb	w0, [x0]
	cmp	w0, 1
	bne	.L52
	ldrsw	x0, [sp, 48]
	lsl	x0, x0, 1
	add	x1, sp, 1128
	mov	w2, -1
	strh	w2, [x1, x0]
.L52:
	ldr	w0, [sp, 48]
	add	w0, w0, 1
	str	w0, [sp, 48]
.L51:
	ldr	w0, [sp, 48]
	cmp	w0, 511
	ble	.L53
	str	wzr, [sp, 48]
	b	.L54
.L57:
	ldrsw	x0, [sp, 48]
	mov	x1, 512
	sub	x0, x1, x0
	lsl	x0, x0, 1
	sub	x0, x0, #2
	add	x1, sp, 2152
	add	x0, x1, x0
	str	x0, [sp, 64]
	add	x0, sp, 104
	str	x0, [sp, 72]
	add	x0, sp, 1128
	str	x0, [sp, 80]
	str	xzr, [sp, 88]
	str	xzr, [sp, 96]
	str	wzr, [sp, 52]
	b	.L55
.L56:
	ldr	x0, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 72]
	add	x2, x0, 8
	str	x2, [sp, 72]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 88]
	add	x0, x1, x0
	str	x0, [sp, 88]
	ldr	x0, [sp, 64]
	add	x1, x0, 8
	str	x1, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 80]
	add	x2, x0, 8
	str	x2, [sp, 80]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 96]
	add	x0, x1, x0
	str	x0, [sp, 96]
	ldr	x0, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 72]
	add	x2, x0, 8
	str	x2, [sp, 72]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 88]
	add	x0, x1, x0
	str	x0, [sp, 88]
	ldr	x0, [sp, 64]
	add	x1, x0, 8
	str	x1, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 80]
	add	x2, x0, 8
	str	x2, [sp, 80]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 96]
	add	x0, x1, x0
	str	x0, [sp, 96]
	ldr	x0, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 72]
	add	x2, x0, 8
	str	x2, [sp, 72]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 88]
	add	x0, x1, x0
	str	x0, [sp, 88]
	ldr	x0, [sp, 64]
	add	x1, x0, 8
	str	x1, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 80]
	add	x2, x0, 8
	str	x2, [sp, 80]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 96]
	add	x0, x1, x0
	str	x0, [sp, 96]
	ldr	x0, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 72]
	add	x2, x0, 8
	str	x2, [sp, 72]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 88]
	add	x0, x1, x0
	str	x0, [sp, 88]
	ldr	x0, [sp, 64]
	add	x1, x0, 8
	str	x1, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 80]
	add	x2, x0, 8
	str	x2, [sp, 80]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 96]
	add	x0, x1, x0
	str	x0, [sp, 96]
	ldr	x0, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 72]
	add	x2, x0, 8
	str	x2, [sp, 72]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 88]
	add	x0, x1, x0
	str	x0, [sp, 88]
	ldr	x0, [sp, 64]
	add	x1, x0, 8
	str	x1, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 80]
	add	x2, x0, 8
	str	x2, [sp, 80]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 96]
	add	x0, x1, x0
	str	x0, [sp, 96]
	ldr	x0, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 72]
	add	x2, x0, 8
	str	x2, [sp, 72]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 88]
	add	x0, x1, x0
	str	x0, [sp, 88]
	ldr	x0, [sp, 64]
	add	x1, x0, 8
	str	x1, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 80]
	add	x2, x0, 8
	str	x2, [sp, 80]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 96]
	add	x0, x1, x0
	str	x0, [sp, 96]
	ldr	x0, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 72]
	add	x2, x0, 8
	str	x2, [sp, 72]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 88]
	add	x0, x1, x0
	str	x0, [sp, 88]
	ldr	x0, [sp, 64]
	add	x1, x0, 8
	str	x1, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 80]
	add	x2, x0, 8
	str	x2, [sp, 80]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 96]
	add	x0, x1, x0
	str	x0, [sp, 96]
	ldr	x0, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 72]
	add	x2, x0, 8
	str	x2, [sp, 72]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 88]
	add	x0, x1, x0
	str	x0, [sp, 88]
	ldr	x0, [sp, 64]
	add	x1, x0, 8
	str	x1, [sp, 64]
	ldr	x1, [x0]
	ldr	x0, [sp, 80]
	add	x2, x0, 8
	str	x2, [sp, 80]
	ldr	x0, [x0]
	and	x0, x1, x0
	ldr	x1, [sp, 96]
	add	x0, x1, x0
	str	x0, [sp, 96]
	ldr	w0, [sp, 52]
	add	w0, w0, 32
	str	w0, [sp, 52]
.L55:
	ldr	w0, [sp, 52]
	cmp	w0, 511
	ble	.L56
	ldr	x0, [sp, 88]
	and	w1, w0, 65535
	ldr	x0, [sp, 88]
	asr	x0, x0, 16
	and	w0, w0, 65535
	add	w1, w1, w0
	ldr	x0, [sp, 88]
	asr	x0, x0, 32
	and	w0, w0, 65535
	add	w0, w1, w0
	ldr	x1, [sp, 88]
	lsr	x1, x1, 48
	add	w0, w0, w1
	str	w0, [sp, 56]
	ldr	x0, [sp, 96]
	and	w1, w0, 65535
	ldr	x0, [sp, 96]
	asr	x0, x0, 16
	and	w0, w0, 65535
	add	w1, w1, w0
	ldr	x0, [sp, 96]
	asr	x0, x0, 32
	and	w0, w0, 65535
	add	w0, w1, w0
	ldr	x1, [sp, 96]
	lsr	x1, x1, 48
	add	w0, w0, w1
	str	w0, [sp, 60]
	ldr	w1, [sp, 60]
	ldr	w0, [sp, 56]
	sub	w0, w1, w0
	ldrsw	x1, [sp, 48]
	ldr	x2, [sp, 24]
	add	x1, x2, x1
	ldrb	w1, [x1]
	add	w1, w0, w1
	mov	w0, 60416
	movk	w0, 0x3, lsl 16
	add	w0, w1, w0
	mov	w1, 49087
	movk	w1, 0x828c, lsl 16
	smull	x1, w0, w1
	lsr	x1, x1, 32
	add	w1, w0, w1
	asr	w2, w1, 7
	asr	w1, w0, 31
	sub	w1, w2, w1
	mov	w2, 251
	mul	w1, w1, w2
	sub	w1, w0, w1
	ldrsw	x0, [sp, 48]
	ldr	x2, [sp, 16]
	add	x0, x2, x0
	and	w1, w1, 255
	strb	w1, [x0]
	ldr	w0, [sp, 48]
	add	w0, w0, 1
	str	w0, [sp, 48]
.L54:
	ldr	w0, [sp, 48]
	ldr	w1, [sp, 12]
	cmp	w1, w0
	bhi	.L57
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 4200]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L59
	bl	__stack_chk_fail
.L59:
	mov	w0, w1
	mov	x13, 4208
	add	sp, sp, x13
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE4:
	.size	poly_aff, .-poly_aff
	.align	2
	.global	poly_compress
	.type	poly_compress, %function
poly_compress:
.LFB5:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	w2, [sp, 12]
	ldr	w0, [sp, 12]
	lsr	w0, w0, 1
	str	w0, [sp, 44]
	str	wzr, [sp, 40]
	b	.L61
.L62:
	ldr	w0, [sp, 40]
	lsl	w0, w0, 1
	sxtw	x0, w0
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldrb	w0, [x0]
	add	w0, w0, 8
	asr	w2, w0, 4
	ldrsw	x0, [sp, 40]
	ldr	x1, [sp, 16]
	add	x0, x1, x0
	and	w1, w2, 255
	strb	w1, [x0]
	ldrsw	x0, [sp, 40]
	ldr	x1, [sp, 16]
	add	x0, x1, x0
	ldrb	w0, [x0]
	sxtb	w1, w0
	ldr	w0, [sp, 40]
	lsl	w0, w0, 1
	sxtw	x0, w0
	add	x0, x0, 1
	ldr	x2, [sp, 24]
	add	x0, x2, x0
	ldrb	w0, [x0]
	add	w0, w0, 8
	and	w0, w0, 255
	sxtb	w0, w0
	and	w0, w0, -16
	sxtb	w0, w0
	eor	w0, w1, w0
	sxtb	w2, w0
	ldrsw	x0, [sp, 40]
	ldr	x1, [sp, 16]
	add	x0, x1, x0
	and	w1, w2, 255
	strb	w1, [x0]
	ldr	w0, [sp, 40]
	add	w0, w0, 1
	str	w0, [sp, 40]
.L61:
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 44]
	cmp	w1, w0
	blt	.L62
	mov	w0, 0
	add	sp, sp, 48
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE5:
	.size	poly_compress, .-poly_compress
	.align	2
	.global	poly_decompress
	.type	poly_decompress, %function
poly_decompress:
.LFB6:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	w2, [sp, 12]
	ldr	w0, [sp, 12]
	lsr	w0, w0, 1
	str	w0, [sp, 44]
	str	wzr, [sp, 40]
	b	.L65
.L66:
	ldrsw	x0, [sp, 40]
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldrb	w1, [x0]
	ldr	w0, [sp, 40]
	lsl	w0, w0, 1
	sxtw	x0, w0
	ldr	x2, [sp, 16]
	add	x0, x2, x0
	ubfiz	w1, w1, 4, 4
	and	w1, w1, 255
	strb	w1, [x0]
	ldrsw	x0, [sp, 40]
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldrb	w1, [x0]
	ldr	w0, [sp, 40]
	lsl	w0, w0, 1
	sxtw	x0, w0
	add	x0, x0, 1
	ldr	x2, [sp, 16]
	add	x0, x2, x0
	and	w1, w1, -16
	and	w1, w1, 255
	strb	w1, [x0]
	ldr	w0, [sp, 40]
	add	w0, w0, 1
	str	w0, [sp, 40]
.L65:
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 44]
	cmp	w1, w0
	blt	.L66
	mov	w0, 0
	add	sp, sp, 48
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	poly_decompress, .-poly_decompress
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits

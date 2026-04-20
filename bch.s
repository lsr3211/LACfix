	.arch armv8-a
	.file	"bch.c"
	.text
	.align	2
	.global	cpu_to_be32
	.type	cpu_to_be32, %function
cpu_to_be32:
.LFB6:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	lsl	w1, w0, 24
	ldr	w0, [sp, 12]
	lsl	w0, w0, 8
	and	w0, w0, 16711680
	orr	w1, w1, w0
	ldr	w0, [sp, 12]
	asr	w0, w0, 8
	and	w0, w0, 65280
	orr	w0, w1, w0
	ldr	w1, [sp, 12]
	lsr	w1, w1, 24
	orr	w0, w0, w1
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	cpu_to_be32, .-cpu_to_be32
	.align	2
	.type	encode_bch_unaligned, %function
encode_bch_unaligned:
.LFB7:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	w2, [sp, 12]
	str	x3, [sp]
	ldr	x0, [sp, 24]
	ldr	w1, [x0]
	ldr	x0, [sp, 24]
	ldr	w0, [x0, 8]
	mul	w0, w1, w0
	add	w0, w0, 31
	lsr	w0, w0, 5
	sub	w0, w0, #1
	str	w0, [sp, 36]
	b	.L4
.L7:
	ldr	x0, [sp, 24]
	ldr	x1, [x0, 40]
	ldr	w0, [sp, 36]
	add	w0, w0, 1
	mov	w4, w0
	ldr	x0, [sp]
	ldr	w0, [x0]
	lsr	w2, w0, 24
	ldr	x0, [sp, 16]
	add	x3, x0, 1
	str	x3, [sp, 16]
	ldrb	w0, [x0]
	eor	w0, w2, w0
	and	w0, w0, 255
	mul	w0, w4, w0
	uxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x1, x0
	str	x0, [sp, 40]
	str	wzr, [sp, 32]
	b	.L5
.L6:
	ldrsw	x0, [sp, 32]
	lsl	x0, x0, 2
	ldr	x1, [sp]
	add	x0, x1, x0
	ldr	w0, [x0]
	lsl	w1, w0, 8
	ldrsw	x0, [sp, 32]
	add	x0, x0, 1
	lsl	x0, x0, 2
	ldr	x2, [sp]
	add	x0, x2, x0
	ldr	w0, [x0]
	lsr	w0, w0, 24
	orr	w2, w1, w0
	ldr	x0, [sp, 40]
	add	x1, x0, 4
	str	x1, [sp, 40]
	ldr	w1, [x0]
	ldrsw	x0, [sp, 32]
	lsl	x0, x0, 2
	ldr	x3, [sp]
	add	x0, x3, x0
	eor	w1, w2, w1
	str	w1, [x0]
	ldr	w0, [sp, 32]
	add	w0, w0, 1
	str	w0, [sp, 32]
.L5:
	ldr	w1, [sp, 32]
	ldr	w0, [sp, 36]
	cmp	w1, w0
	blt	.L6
	ldrsw	x0, [sp, 36]
	lsl	x0, x0, 2
	ldr	x1, [sp]
	add	x0, x1, x0
	ldr	w0, [x0]
	lsl	w2, w0, 8
	ldr	x0, [sp, 40]
	ldr	w1, [x0]
	ldrsw	x0, [sp, 36]
	lsl	x0, x0, 2
	ldr	x3, [sp]
	add	x0, x3, x0
	eor	w1, w2, w1
	str	w1, [x0]
.L4:
	ldr	w0, [sp, 12]
	sub	w1, w0, #1
	str	w1, [sp, 12]
	cmp	w0, 0
	bne	.L7
	nop
	nop
	add	sp, sp, 48
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE7:
	.size	encode_bch_unaligned, .-encode_bch_unaligned
	.align	2
	.type	load_ecc8, %function
load_ecc8:
.LFB8:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, 64]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 64
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	x2, [sp, 8]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 56]
	mov	x1, 0
	str	wzr, [sp, 48]
	ldr	x0, [sp, 24]
	ldr	w1, [x0]
	ldr	x0, [sp, 24]
	ldr	w0, [x0, 8]
	mul	w0, w1, w0
	add	w0, w0, 31
	lsr	w0, w0, 5
	sub	w0, w0, #1
	str	w0, [sp, 44]
	str	wzr, [sp, 40]
	b	.L9
.L10:
	ldr	x0, [sp, 8]
	ldrb	w0, [x0]
	lsl	w1, w0, 24
	ldr	x0, [sp, 8]
	add	x0, x0, 1
	ldrb	w0, [x0]
	lsl	w0, w0, 16
	orr	w1, w1, w0
	ldr	x0, [sp, 8]
	add	x0, x0, 2
	ldrb	w0, [x0]
	lsl	w0, w0, 8
	orr	w0, w1, w0
	ldr	x1, [sp, 8]
	add	x1, x1, 3
	ldrb	w1, [x1]
	orr	w2, w0, w1
	ldr	w0, [sp, 40]
	lsl	x0, x0, 2
	ldr	x1, [sp, 16]
	add	x0, x1, x0
	mov	w1, w2
	str	w1, [x0]
	ldr	w0, [sp, 40]
	add	w0, w0, 1
	str	w0, [sp, 40]
	ldr	x0, [sp, 8]
	add	x0, x0, 4
	str	x0, [sp, 8]
.L9:
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 44]
	cmp	w1, w0
	bcc	.L10
	ldr	x0, [sp, 24]
	ldr	w1, [x0]
	ldr	x0, [sp, 24]
	ldr	w0, [x0, 8]
	mul	w0, w1, w0
	add	w0, w0, 7
	lsr	w1, w0, 3
	ldr	w0, [sp, 44]
	lsl	w0, w0, 2
	sub	w0, w1, w0
	uxtw	x1, w0
	add	x0, sp, 48
	mov	x2, x1
	ldr	x1, [sp, 8]
	bl	memcpy
	ldrb	w0, [sp, 48]
	lsl	w1, w0, 24
	ldrb	w0, [sp, 49]
	lsl	w0, w0, 16
	orr	w1, w1, w0
	ldrb	w0, [sp, 50]
	lsl	w0, w0, 8
	orr	w0, w1, w0
	ldrb	w1, [sp, 51]
	orr	w2, w0, w1
	ldr	w0, [sp, 44]
	lsl	x0, x0, 2
	ldr	x1, [sp, 16]
	add	x0, x1, x0
	mov	w1, w2
	str	w1, [x0]
	nop
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x2, [sp, 56]
	ldr	x1, [x0]
	subs	x2, x2, x1
	mov	x1, 0
	beq	.L11
	bl	__stack_chk_fail
.L11:
	ldp	x29, x30, [sp, 64]
	add	sp, sp, 80
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE8:
	.size	load_ecc8, .-load_ecc8
	.align	2
	.type	store_ecc8, %function
store_ecc8:
.LFB9:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, 64]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 64
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	x2, [sp, 8]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 56]
	mov	x1, 0
	ldr	x0, [sp, 24]
	ldr	w1, [x0]
	ldr	x0, [sp, 24]
	ldr	w0, [x0, 8]
	mul	w0, w1, w0
	add	w0, w0, 31
	lsr	w0, w0, 5
	sub	w0, w0, #1
	str	w0, [sp, 44]
	str	wzr, [sp, 40]
	b	.L13
.L14:
	ldr	w0, [sp, 40]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w0, [x0]
	lsr	w2, w0, 24
	ldr	x0, [sp, 16]
	add	x1, x0, 1
	str	x1, [sp, 16]
	and	w1, w2, 255
	strb	w1, [x0]
	ldr	w0, [sp, 40]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w0, [x0]
	lsr	w2, w0, 16
	ldr	x0, [sp, 16]
	add	x1, x0, 1
	str	x1, [sp, 16]
	and	w1, w2, 255
	strb	w1, [x0]
	ldr	w0, [sp, 40]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w0, [x0]
	lsr	w2, w0, 8
	ldr	x0, [sp, 16]
	add	x1, x0, 1
	str	x1, [sp, 16]
	and	w1, w2, 255
	strb	w1, [x0]
	ldr	w0, [sp, 40]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w2, [x0]
	ldr	x0, [sp, 16]
	add	x1, x0, 1
	str	x1, [sp, 16]
	and	w1, w2, 255
	strb	w1, [x0]
	ldr	w0, [sp, 40]
	add	w0, w0, 1
	str	w0, [sp, 40]
.L13:
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 44]
	cmp	w1, w0
	bcc	.L14
	ldr	w0, [sp, 44]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w0, [x0]
	lsr	w0, w0, 24
	and	w0, w0, 255
	strb	w0, [sp, 48]
	ldr	w0, [sp, 44]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w0, [x0]
	lsr	w0, w0, 16
	and	w0, w0, 255
	strb	w0, [sp, 49]
	ldr	w0, [sp, 44]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w0, [x0]
	lsr	w0, w0, 8
	and	w0, w0, 255
	strb	w0, [sp, 50]
	ldr	w0, [sp, 44]
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldr	w0, [x0]
	and	w0, w0, 255
	strb	w0, [sp, 51]
	ldr	x0, [sp, 24]
	ldr	w1, [x0]
	ldr	x0, [sp, 24]
	ldr	w0, [x0, 8]
	mul	w0, w1, w0
	add	w0, w0, 7
	lsr	w1, w0, 3
	ldr	w0, [sp, 44]
	lsl	w0, w0, 2
	sub	w0, w1, w0
	uxtw	x1, w0
	add	x0, sp, 48
	mov	x2, x1
	mov	x1, x0
	ldr	x0, [sp, 16]
	bl	memcpy
	nop
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x2, [sp, 56]
	ldr	x1, [x0]
	subs	x2, x2, x1
	mov	x1, 0
	beq	.L15
	bl	__stack_chk_fail
.L15:
	ldp	x29, x30, [sp, 64]
	add	sp, sp, 80
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE9:
	.size	store_ecc8, .-store_ecc8
	.align	2
	.global	encode_bch
	.type	encode_bch, %function
encode_bch:
.LFB10:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	.cfi_def_cfa_register 29
	stp	x19, x20, [sp, 16]
	sub	sp, sp, #176
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	str	x0, [x29, -136]
	str	x1, [x29, -144]
	str	w2, [x29, -148]
	str	x3, [x29, -160]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [x29, -8]
	mov	x1, 0
	mov	x0, sp
	mov	x20, x0
	ldr	x0, [x29, -136]
	ldr	w1, [x0]
	ldr	x0, [x29, -136]
	ldr	w0, [x0, 8]
	mul	w0, w1, w0
	add	w0, w0, 31
	lsr	w0, w0, 5
	sub	w0, w0, #1
	str	w0, [x29, -112]
	ldr	w0, [x29, -112]
	add	w0, w0, 1
	uxtw	x0, w0
	sub	x0, x0, #1
	str	x0, [x29, -96]
	ldr	w0, [x29, -112]
	add	w0, w0, 1
	uxtw	x0, w0
	mov	x10, x0
	mov	x11, 0
	lsr	x0, x10, 59
	lsl	x7, x11, 5
	orr	x7, x0, x7
	lsl	x6, x10, 5
	ldr	w0, [x29, -112]
	add	w0, w0, 1
	uxtw	x0, w0
	mov	x8, x0
	mov	x9, 0
	lsr	x0, x8, 59
	lsl	x5, x9, 5
	orr	x5, x0, x5
	lsl	x4, x8, 5
	ldr	w0, [x29, -112]
	add	w0, w0, 1
	uxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x0, 15
	lsr	x0, x0, 4
	lsl	x0, x0, 4
	and	x1, x0, -65536
	sub	x1, sp, x1
.L17:
	cmp	sp, x1
	beq	.L18
	sub	sp, sp, #65536
	str	xzr, [sp, 1024]
	b	.L17
.L18:
	and	x1, x0, 65535
	sub	sp, sp, x1
	str	xzr, [sp]
	and	x0, x0, 65535
	cmp	x0, 1024
	bcc	.L19
	str	xzr, [sp, 1024]
.L19:
	add	x0, sp, 16
	add	x0, x0, 3
	lsr	x0, x0, 2
	lsl	x0, x0, 2
	str	x0, [x29, -88]
	ldr	x0, [x29, -136]
	ldr	x0, [x0, 40]
	str	x0, [x29, -80]
	ldr	w0, [x29, -112]
	add	w0, w0, 1
	lsl	w0, w0, 8
	uxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [x29, -80]
	add	x0, x1, x0
	str	x0, [x29, -72]
	ldr	w0, [x29, -112]
	add	w0, w0, 1
	lsl	w0, w0, 8
	uxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [x29, -72]
	add	x0, x1, x0
	str	x0, [x29, -64]
	ldr	w0, [x29, -112]
	add	w0, w0, 1
	lsl	w0, w0, 8
	uxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [x29, -64]
	add	x0, x1, x0
	str	x0, [x29, -56]
	ldr	x0, [x29, -160]
	cmp	x0, 0
	beq	.L20
	ldr	x0, [x29, -136]
	ldr	x0, [x0, 48]
	ldr	x2, [x29, -160]
	mov	x1, x0
	ldr	x0, [x29, -136]
	bl	load_ecc8
	b	.L21
.L20:
	ldr	x0, [x29, -136]
	ldr	x3, [x0, 48]
	ldr	w0, [x29, -112]
	add	w0, w0, 1
	uxtw	x0, w0
	lsl	x0, x0, 2
	mov	x2, x0
	mov	w1, 0
	mov	x0, x3
	bl	memset
.L21:
	ldr	x0, [x29, -144]
	and	x0, x0, 3
	str	x0, [x29, -48]
	ldr	x0, [x29, -48]
	cmp	x0, 0
	beq	.L22
	mov	x1, 4
	ldr	x0, [x29, -48]
	sub	x1, x1, x0
	ldr	w0, [x29, -148]
	cmp	x1, x0
	csel	x0, x1, x0, ls
	str	w0, [x29, -116]
	ldr	x0, [x29, -136]
	ldr	x0, [x0, 48]
	mov	x3, x0
	ldr	w2, [x29, -116]
	ldr	x1, [x29, -144]
	ldr	x0, [x29, -136]
	bl	encode_bch_unaligned
	ldr	w0, [x29, -116]
	ldr	x1, [x29, -144]
	add	x0, x1, x0
	str	x0, [x29, -144]
	ldr	w1, [x29, -148]
	ldr	w0, [x29, -116]
	sub	w0, w1, w0
	str	w0, [x29, -148]
.L22:
	ldr	x0, [x29, -144]
	str	x0, [x29, -104]
	ldr	w0, [x29, -148]
	lsr	w0, w0, 2
	str	w0, [x29, -116]
	ldr	w0, [x29, -116]
	lsl	w0, w0, 2
	uxtw	x0, w0
	ldr	x1, [x29, -144]
	add	x0, x1, x0
	str	x0, [x29, -144]
	ldr	w0, [x29, -116]
	lsl	w0, w0, 2
	ldr	w1, [x29, -148]
	sub	w0, w1, w0
	str	w0, [x29, -148]
	ldr	x0, [x29, -136]
	ldr	x1, [x0, 48]
	ldr	w0, [x29, -112]
	add	w0, w0, 1
	uxtw	x0, w0
	lsl	x0, x0, 2
	mov	x2, x0
	ldr	x0, [x29, -88]
	bl	memcpy
	b	.L23
.L26:
	ldr	x0, [x29, -88]
	ldr	w19, [x0]
	ldr	x0, [x29, -104]
	add	x1, x0, 4
	str	x1, [x29, -104]
	ldr	w0, [x0]
	bl	cpu_to_be32
	eor	w0, w19, w0
	str	w0, [x29, -108]
	ldr	w0, [x29, -112]
	add	w1, w0, 1
	ldr	w0, [x29, -108]
	and	w0, w0, 255
	mul	w0, w1, w0
	uxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [x29, -80]
	add	x0, x1, x0
	str	x0, [x29, -40]
	ldr	w0, [x29, -112]
	add	w1, w0, 1
	ldr	w0, [x29, -108]
	lsr	w0, w0, 8
	and	w0, w0, 255
	mul	w0, w1, w0
	uxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [x29, -72]
	add	x0, x1, x0
	str	x0, [x29, -32]
	ldr	w0, [x29, -112]
	add	w1, w0, 1
	ldr	w0, [x29, -108]
	lsr	w0, w0, 16
	and	w0, w0, 255
	mul	w0, w1, w0
	uxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [x29, -64]
	add	x0, x1, x0
	str	x0, [x29, -24]
	ldr	w0, [x29, -112]
	add	w1, w0, 1
	ldr	w0, [x29, -108]
	lsr	w0, w0, 24
	mul	w0, w1, w0
	uxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [x29, -56]
	add	x0, x1, x0
	str	x0, [x29, -16]
	str	wzr, [x29, -120]
	b	.L24
.L25:
	ldr	w0, [x29, -120]
	add	w1, w0, 1
	ldr	x0, [x29, -88]
	uxtw	x1, w1
	ldr	w1, [x0, x1, lsl 2]
	ldr	w0, [x29, -120]
	lsl	x0, x0, 2
	ldr	x2, [x29, -40]
	add	x0, x2, x0
	ldr	w0, [x0]
	eor	w1, w1, w0
	ldr	w0, [x29, -120]
	lsl	x0, x0, 2
	ldr	x2, [x29, -32]
	add	x0, x2, x0
	ldr	w0, [x0]
	eor	w1, w1, w0
	ldr	w0, [x29, -120]
	lsl	x0, x0, 2
	ldr	x2, [x29, -24]
	add	x0, x2, x0
	ldr	w0, [x0]
	eor	w1, w1, w0
	ldr	w0, [x29, -120]
	lsl	x0, x0, 2
	ldr	x2, [x29, -16]
	add	x0, x2, x0
	ldr	w0, [x0]
	eor	w2, w1, w0
	ldr	x0, [x29, -88]
	ldr	w1, [x29, -120]
	str	w2, [x0, x1, lsl 2]
	ldr	w0, [x29, -120]
	add	w0, w0, 1
	str	w0, [x29, -120]
.L24:
	ldr	w1, [x29, -120]
	ldr	w0, [x29, -112]
	cmp	w1, w0
	bcc	.L25
	ldr	w0, [x29, -112]
	lsl	x0, x0, 2
	ldr	x1, [x29, -40]
	add	x0, x1, x0
	ldr	w1, [x0]
	ldr	w0, [x29, -112]
	lsl	x0, x0, 2
	ldr	x2, [x29, -32]
	add	x0, x2, x0
	ldr	w0, [x0]
	eor	w1, w1, w0
	ldr	w0, [x29, -112]
	lsl	x0, x0, 2
	ldr	x2, [x29, -24]
	add	x0, x2, x0
	ldr	w0, [x0]
	eor	w1, w1, w0
	ldr	w0, [x29, -112]
	lsl	x0, x0, 2
	ldr	x2, [x29, -16]
	add	x0, x2, x0
	ldr	w0, [x0]
	eor	w2, w1, w0
	ldr	x0, [x29, -88]
	ldr	w1, [x29, -112]
	str	w2, [x0, x1, lsl 2]
.L23:
	ldr	w0, [x29, -116]
	sub	w1, w0, #1
	str	w1, [x29, -116]
	cmp	w0, 0
	bne	.L26
	ldr	x0, [x29, -136]
	ldr	x3, [x0, 48]
	ldr	w0, [x29, -112]
	add	w0, w0, 1
	uxtw	x0, w0
	lsl	x0, x0, 2
	mov	x2, x0
	ldr	x1, [x29, -88]
	mov	x0, x3
	bl	memcpy
	ldr	w0, [x29, -148]
	cmp	w0, 0
	beq	.L27
	ldr	x0, [x29, -136]
	ldr	x0, [x0, 48]
	mov	x3, x0
	ldr	w2, [x29, -148]
	ldr	x1, [x29, -144]
	ldr	x0, [x29, -136]
	bl	encode_bch_unaligned
.L27:
	ldr	x0, [x29, -160]
	cmp	x0, 0
	beq	.L28
	ldr	x0, [x29, -136]
	ldr	x0, [x0, 48]
	mov	x2, x0
	ldr	x1, [x29, -160]
	ldr	x0, [x29, -136]
	bl	store_ecc8
.L28:
	mov	sp, x20
	nop
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x2, [x29, -8]
	ldr	x1, [x0]
	subs	x2, x2, x1
	mov	x1, 0
	beq	.L29
	bl	__stack_chk_fail
.L29:
	mov	sp, x29
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa 31, 0
	ret
	.cfi_endproc
.LFE10:
	.size	encode_bch, .-encode_bch
	.align	2
	.type	modulo, %function
modulo:
.LFB11:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	x0, [sp, 8]
	str	w1, [sp, 4]
	ldr	x0, [sp, 8]
	ldr	w0, [x0, 4]
	str	w0, [sp, 28]
	b	.L31
.L32:
	ldr	w1, [sp, 4]
	ldr	w0, [sp, 28]
	sub	w0, w1, w0
	str	w0, [sp, 4]
	ldr	w1, [sp, 4]
	ldr	w0, [sp, 28]
	and	w1, w1, w0
	ldr	x0, [sp, 8]
	ldr	w0, [x0]
	ldr	w2, [sp, 4]
	lsr	w0, w2, w0
	add	w0, w1, w0
	str	w0, [sp, 4]
.L31:
	ldr	w1, [sp, 4]
	ldr	w0, [sp, 28]
	cmp	w1, w0
	bcs	.L32
	ldr	w0, [sp, 4]
	add	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE11:
	.size	modulo, .-modulo
	.align	2
	.type	mod_s, %function
mod_s:
.LFB12:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	x0, [sp, 8]
	str	w1, [sp, 4]
	ldr	x0, [sp, 8]
	ldr	w0, [x0, 4]
	str	w0, [sp, 28]
	ldr	w1, [sp, 4]
	ldr	w0, [sp, 28]
	cmp	w1, w0
	bcc	.L35
	ldr	w1, [sp, 4]
	ldr	w0, [sp, 28]
	sub	w0, w1, w0
	b	.L37
.L35:
	ldr	w0, [sp, 4]
.L37:
	add	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE12:
	.size	mod_s, .-mod_s
	.align	2
	.type	deg, %function
deg:
.LFB13:
	.cfi_startproc
	sub	sp, sp, #32
	.cfi_def_cfa_offset 32
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	str	w0, [sp, 24]
	str	wzr, [sp, 28]
	b	.L39
.L40:
	ldr	w0, [sp, 28]
	add	w0, w0, 1
	str	w0, [sp, 28]
.L39:
	ldr	w0, [sp, 24]
	lsr	w0, w0, 1
	str	w0, [sp, 24]
	ldr	w0, [sp, 24]
	cmp	w0, 0
	bne	.L40
	ldr	w0, [sp, 28]
	add	w0, w0, 1
	sub	w0, w0, #1
	add	sp, sp, 32
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE13:
	.size	deg, .-deg
	.align	2
	.type	gf_mul, %function
gf_mul:
.LFB14:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -32
	str	x0, [sp, 40]
	str	w1, [sp, 36]
	str	w2, [sp, 32]
	ldr	w0, [sp, 36]
	cmp	w0, 0
	beq	.L43
	ldr	w0, [sp, 32]
	cmp	w0, 0
	beq	.L43
	ldr	x0, [sp, 40]
	ldr	x19, [x0, 24]
	ldr	x0, [sp, 40]
	ldr	x1, [x0, 32]
	ldr	w0, [sp, 36]
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w0, [x0]
	mov	w2, w0
	ldr	x0, [sp, 40]
	ldr	x1, [x0, 32]
	ldr	w0, [sp, 32]
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w0, [x0]
	add	w0, w2, w0
	mov	w1, w0
	ldr	x0, [sp, 40]
	bl	mod_s
	sxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x19, x0
	ldrh	w0, [x0]
	b	.L45
.L43:
	mov	w0, 0
.L45:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE14:
	.size	gf_mul, .-gf_mul
	.align	2
	.type	gf_sqr, %function
gf_sqr:
.LFB15:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -32
	str	x0, [sp, 40]
	str	w1, [sp, 36]
	ldr	w0, [sp, 36]
	cmp	w0, 0
	beq	.L47
	ldr	x0, [sp, 40]
	ldr	x19, [x0, 24]
	ldr	x0, [sp, 40]
	ldr	x1, [x0, 32]
	ldr	w0, [sp, 36]
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w0, [x0]
	lsl	w0, w0, 1
	mov	w1, w0
	ldr	x0, [sp, 40]
	bl	mod_s
	sxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x19, x0
	ldrh	w0, [x0]
	b	.L49
.L47:
	mov	w0, 0
.L49:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE15:
	.size	gf_sqr, .-gf_sqr
	.align	2
	.type	gf_div, %function
gf_div:
.LFB16:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -32
	str	x0, [sp, 40]
	str	w1, [sp, 36]
	str	w2, [sp, 32]
	ldr	w0, [sp, 36]
	cmp	w0, 0
	beq	.L51
	ldr	x0, [sp, 40]
	ldr	x19, [x0, 24]
	ldr	x0, [sp, 40]
	ldr	x1, [x0, 32]
	ldr	w0, [sp, 36]
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w0, [x0]
	mov	w1, w0
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 4]
	add	w0, w1, w0
	ldr	x1, [sp, 40]
	ldr	x2, [x1, 32]
	ldr	w1, [sp, 32]
	lsl	x1, x1, 1
	add	x1, x2, x1
	ldrh	w1, [x1]
	sub	w0, w0, w1
	mov	w1, w0
	ldr	x0, [sp, 40]
	bl	mod_s
	sxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x19, x0
	ldrh	w0, [x0]
	b	.L53
.L51:
	mov	w0, 0
.L53:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE16:
	.size	gf_div, .-gf_div
	.align	2
	.type	gf_inv, %function
gf_inv:
.LFB17:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, 8]
	str	w1, [sp, 4]
	ldr	x0, [sp, 8]
	ldr	x1, [x0, 24]
	ldr	x0, [sp, 8]
	ldr	w0, [x0, 4]
	ldr	x2, [sp, 8]
	ldr	x3, [x2, 32]
	ldr	w2, [sp, 4]
	lsl	x2, x2, 1
	add	x2, x3, x2
	ldrh	w2, [x2]
	sub	w0, w0, w2
	uxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w0, [x0]
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE17:
	.size	gf_inv, .-gf_inv
	.align	2
	.type	a_pow, %function
a_pow:
.LFB18:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -32
	str	x0, [sp, 40]
	str	w1, [sp, 36]
	ldr	x0, [sp, 40]
	ldr	x19, [x0, 24]
	ldr	w0, [sp, 36]
	mov	w1, w0
	ldr	x0, [sp, 40]
	bl	modulo
	sxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x19, x0
	ldrh	w0, [x0]
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE18:
	.size	a_pow, .-a_pow
	.align	2
	.type	a_log, %function
a_log:
.LFB19:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	x0, [sp, 8]
	str	w1, [sp, 4]
	ldr	x0, [sp, 8]
	ldr	x1, [x0, 32]
	ldr	w0, [sp, 4]
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w0, [x0]
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE19:
	.size	a_log, .-a_log
	.align	2
	.type	a_ilog, %function
a_ilog:
.LFB20:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	ldr	x0, [sp, 24]
	ldr	w0, [x0, 4]
	ldr	x1, [sp, 24]
	ldr	x2, [x1, 32]
	ldr	w1, [sp, 20]
	lsl	x1, x1, 1
	add	x1, x2, x1
	ldrh	w1, [x1]
	sub	w0, w0, w1
	mov	w1, w0
	ldr	x0, [sp, 24]
	bl	mod_s
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE20:
	.size	a_ilog, .-a_ilog
	.align	2
	.type	parity, %function
parity:
.LFB21:
	.cfi_startproc
	sub	sp, sp, #16
	.cfi_def_cfa_offset 16
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	lsr	w0, w0, 1
	ldr	w1, [sp, 12]
	eor	w0, w1, w0
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	lsr	w0, w0, 2
	ldr	w1, [sp, 12]
	eor	w0, w1, w0
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	and	w1, w0, 286331153
	mov	w0, 286331153
	mul	w0, w1, w0
	str	w0, [sp, 12]
	ldr	w0, [sp, 12]
	lsr	w0, w0, 28
	and	w0, w0, 1
	add	sp, sp, 16
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE21:
	.size	parity, .-parity
	.align	2
	.type	compute_syndromes, %function
compute_syndromes:
.LFB22:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -80
	str	x0, [sp, 56]
	str	x1, [sp, 48]
	str	x2, [sp, 40]
	ldr	x0, [sp, 56]
	ldr	w0, [x0, 8]
	str	w0, [sp, 84]
	ldr	x0, [sp, 56]
	ldr	w0, [x0, 12]
	str	w0, [sp, 76]
	ldr	w0, [sp, 76]
	and	w0, w0, 31
	str	w0, [sp, 88]
	ldr	w0, [sp, 88]
	cmp	w0, 0
	beq	.L65
	ldr	w0, [sp, 76]
	add	w1, w0, 31
	cmp	w0, 0
	csel	w0, w1, w0, lt
	asr	w0, w0, 5
	mov	w3, w0
	sxtw	x0, w3
	lsl	x0, x0, 2
	ldr	x1, [sp, 48]
	add	x0, x1, x0
	ldr	w2, [x0]
	mov	w1, 32
	ldr	w0, [sp, 88]
	sub	w0, w1, w0
	mov	w1, 1
	lsl	w0, w1, w0
	neg	w1, w0
	sxtw	x0, w3
	lsl	x0, x0, 2
	ldr	x3, [sp, 48]
	add	x0, x3, x0
	and	w1, w2, w1
	str	w1, [x0]
.L65:
	ldr	w0, [sp, 84]
	lsl	w0, w0, 1
	sxtw	x0, w0
	lsl	x0, x0, 2
	mov	x2, x0
	mov	w1, 0
	ldr	x0, [sp, 40]
	bl	memset
.L70:
	ldr	x0, [sp, 48]
	add	x1, x0, 4
	str	x1, [sp, 48]
	ldr	w0, [x0]
	str	w0, [sp, 80]
	ldr	w0, [sp, 76]
	sub	w0, w0, #32
	str	w0, [sp, 76]
	b	.L66
.L69:
	ldr	w0, [sp, 80]
	bl	deg
	str	w0, [sp, 92]
	str	wzr, [sp, 72]
	b	.L67
.L68:
	ldr	w0, [sp, 72]
	add	w1, w0, 1
	ldr	w2, [sp, 92]
	ldr	w0, [sp, 76]
	add	w0, w2, w0
	mul	w0, w1, w0
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	a_pow
	mov	w3, w0
	ldrsw	x0, [sp, 72]
	lsl	x0, x0, 2
	ldr	x1, [sp, 40]
	add	x0, x1, x0
	ldr	w1, [x0]
	ldrsw	x0, [sp, 72]
	lsl	x0, x0, 2
	ldr	x2, [sp, 40]
	add	x0, x2, x0
	eor	w1, w3, w1
	str	w1, [x0]
	ldr	w0, [sp, 72]
	add	w0, w0, 2
	str	w0, [sp, 72]
.L67:
	ldr	w0, [sp, 84]
	lsl	w0, w0, 1
	ldr	w1, [sp, 72]
	cmp	w1, w0
	blt	.L68
	ldr	w0, [sp, 92]
	mov	w1, 1
	lsl	w0, w1, w0
	mov	w1, w0
	ldr	w0, [sp, 80]
	eor	w0, w0, w1
	str	w0, [sp, 80]
.L66:
	ldr	w0, [sp, 80]
	cmp	w0, 0
	bne	.L69
	ldr	w0, [sp, 76]
	cmp	w0, 0
	bgt	.L70
	str	wzr, [sp, 72]
	b	.L71
.L72:
	ldrsw	x0, [sp, 72]
	lsl	x0, x0, 2
	ldr	x1, [sp, 40]
	add	x0, x1, x0
	ldr	w2, [x0]
	ldr	w0, [sp, 72]
	lsl	w0, w0, 1
	sxtw	x0, w0
	add	x0, x0, 1
	lsl	x0, x0, 2
	ldr	x1, [sp, 40]
	add	x19, x1, x0
	mov	w1, w2
	ldr	x0, [sp, 56]
	bl	gf_sqr
	str	w0, [x19]
	ldr	w0, [sp, 72]
	add	w0, w0, 1
	str	w0, [sp, 72]
.L71:
	ldr	w1, [sp, 72]
	ldr	w0, [sp, 84]
	cmp	w1, w0
	blt	.L72
	nop
	nop
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 96
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE22:
	.size	compute_syndromes, .-compute_syndromes
	.align	2
	.type	gf_poly_copy, %function
gf_poly_copy:
.LFB23:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	ldr	x0, [sp, 16]
	ldr	w0, [x0]
	add	w0, w0, 1
	uxtw	x0, w0
	add	x0, x0, 1
	lsl	x0, x0, 2
	mov	x2, x0
	ldr	x1, [sp, 16]
	ldr	x0, [sp, 24]
	bl	memcpy
	nop
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE23:
	.size	gf_poly_copy, .-gf_poly_copy
	.align	2
	.type	compute_error_locator_polynomial, %function
compute_error_locator_polynomial:
.LFB24:
	.cfi_startproc
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -96
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 8]
	str	w0, [sp, 68]
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 4]
	str	w0, [sp, 72]
	mov	w0, 1
	str	w0, [sp, 56]
	ldr	x0, [sp, 32]
	ldr	w0, [x0]
	str	w0, [sp, 60]
	ldr	x0, [sp, 40]
	ldr	x0, [x0, 88]
	str	x0, [sp, 88]
	ldr	x0, [sp, 40]
	ldr	x0, [x0, 96]
	str	x0, [sp, 96]
	ldr	x0, [sp, 40]
	ldr	x0, [x0, 104]
	str	x0, [sp, 104]
	mov	w0, -1
	str	w0, [sp, 64]
	ldr	w0, [sp, 68]
	lsl	w0, w0, 1
	add	w0, w0, 1
	uxtw	x0, w0
	add	x0, x0, 1
	lsl	x0, x0, 2
	mov	x2, x0
	mov	w1, 0
	ldr	x0, [sp, 96]
	bl	memset
	ldr	w0, [sp, 68]
	lsl	w0, w0, 1
	add	w0, w0, 1
	uxtw	x0, w0
	add	x0, x0, 1
	lsl	x0, x0, 2
	mov	x2, x0
	mov	w1, 0
	ldr	x0, [sp, 88]
	bl	memset
	ldr	x0, [sp, 96]
	str	wzr, [x0]
	ldr	x0, [sp, 96]
	mov	w1, 1
	str	w1, [x0, 4]
	ldr	x0, [sp, 88]
	str	wzr, [x0]
	ldr	x0, [sp, 88]
	mov	w1, 1
	str	w1, [x0, 4]
	str	wzr, [sp, 48]
	b	.L75
.L84:
	ldr	w0, [sp, 60]
	cmp	w0, 0
	beq	.L76
	ldr	w0, [sp, 48]
	lsl	w1, w0, 1
	ldr	w0, [sp, 64]
	sub	w0, w1, w0
	str	w0, [sp, 76]
	ldr	x1, [sp, 88]
	ldr	x0, [sp, 104]
	bl	gf_poly_copy
	ldr	w1, [sp, 60]
	ldr	x0, [sp, 40]
	bl	a_log
	mov	w1, w0
	ldr	w0, [sp, 72]
	add	w19, w1, w0
	ldr	w1, [sp, 56]
	ldr	x0, [sp, 40]
	bl	a_log
	sub	w0, w19, w0
	str	w0, [sp, 80]
	str	wzr, [sp, 52]
	b	.L77
.L79:
	ldr	x1, [sp, 96]
	ldr	w0, [sp, 52]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	cmp	w0, 0
	beq	.L78
	ldr	x1, [sp, 96]
	ldr	w0, [sp, 52]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	mov	w1, w0
	ldr	x0, [sp, 40]
	bl	a_log
	str	w0, [sp, 84]
	ldr	w1, [sp, 80]
	ldr	w0, [sp, 84]
	add	w0, w1, w0
	mov	w1, w0
	ldr	x0, [sp, 40]
	bl	a_pow
	mov	w3, w0
	ldr	w1, [sp, 76]
	ldr	w0, [sp, 52]
	add	w0, w1, w0
	ldr	x1, [sp, 88]
	uxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	ldr	w2, [sp, 76]
	ldr	w1, [sp, 52]
	add	w4, w2, w1
	eor	w1, w3, w0
	ldr	x2, [sp, 88]
	uxtw	x0, w4
	lsl	x0, x0, 2
	add	x0, x2, x0
	str	w1, [x0, 4]
.L78:
	ldr	w0, [sp, 52]
	add	w0, w0, 1
	str	w0, [sp, 52]
.L77:
	ldr	x0, [sp, 96]
	ldr	w0, [x0]
	ldr	w1, [sp, 52]
	cmp	w1, w0
	bls	.L79
	ldr	x0, [sp, 96]
	ldr	w1, [x0]
	ldr	w0, [sp, 76]
	add	w0, w1, w0
	str	w0, [sp, 80]
	ldr	x0, [sp, 88]
	ldr	w0, [x0]
	ldr	w1, [sp, 80]
	cmp	w1, w0
	bls	.L76
	ldr	x0, [sp, 88]
	ldr	w1, [sp, 80]
	str	w1, [x0]
	ldr	x1, [sp, 104]
	ldr	x0, [sp, 96]
	bl	gf_poly_copy
	ldr	w0, [sp, 60]
	str	w0, [sp, 56]
	ldr	w0, [sp, 48]
	lsl	w0, w0, 1
	str	w0, [sp, 64]
.L76:
	ldr	w0, [sp, 68]
	sub	w0, w0, #1
	ldr	w1, [sp, 48]
	cmp	w1, w0
	bcs	.L80
	ldr	w0, [sp, 48]
	add	w0, w0, 1
	lsl	w0, w0, 1
	uxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [sp, 32]
	add	x0, x1, x0
	ldr	w0, [x0]
	str	w0, [sp, 60]
	mov	w0, 1
	str	w0, [sp, 52]
	b	.L81
.L82:
	ldr	x1, [sp, 88]
	ldr	w0, [sp, 52]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w3, [x0, 4]
	ldr	w0, [sp, 48]
	add	w0, w0, 1
	lsl	w1, w0, 1
	ldr	w0, [sp, 52]
	sub	w0, w1, w0
	uxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [sp, 32]
	add	x0, x1, x0
	ldr	w0, [x0]
	mov	w2, w0
	mov	w1, w3
	ldr	x0, [sp, 40]
	bl	gf_mul
	mov	w1, w0
	ldr	w0, [sp, 60]
	eor	w0, w0, w1
	str	w0, [sp, 60]
	ldr	w0, [sp, 52]
	add	w0, w0, 1
	str	w0, [sp, 52]
.L81:
	ldr	x0, [sp, 88]
	ldr	w0, [x0]
	ldr	w1, [sp, 52]
	cmp	w1, w0
	bls	.L82
.L80:
	ldr	w0, [sp, 48]
	add	w0, w0, 1
	str	w0, [sp, 48]
.L75:
	ldr	w1, [sp, 48]
	ldr	w0, [sp, 68]
	cmp	w1, w0
	bcs	.L83
	ldr	x0, [sp, 88]
	ldr	w0, [x0]
	ldr	w1, [sp, 68]
	cmp	w1, w0
	bcs	.L84
.L83:
	ldr	x0, [sp, 88]
	ldr	w0, [x0]
	ldr	w1, [sp, 68]
	cmp	w1, w0
	bcc	.L85
	ldr	x0, [sp, 88]
	ldr	w0, [x0]
	b	.L87
.L85:
	mov	w0, -1
.L87:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 112
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE24:
	.size	compute_error_locator_polynomial, .-compute_error_locator_polynomial
	.align	2
	.type	solve_linear_system, %function
solve_linear_system:
.LFB25:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	.cfi_def_cfa_register 29
	str	x19, [sp, 16]
	sub	sp, sp, #112
	.cfi_offset 19, -16
	str	x0, [x29, -72]
	str	x1, [x29, -80]
	str	x2, [x29, -88]
	str	w3, [x29, -92]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [x29, -8]
	mov	x1, 0
	mov	x0, sp
	mov	x19, x0
	ldr	x0, [x29, -72]
	ldr	w0, [x0]
	str	w0, [x29, -28]
	ldrsw	x0, [x29, -28]
	sub	x0, x0, #1
	str	x0, [x29, -24]
	ldrsw	x0, [x29, -28]
	mov	x10, x0
	mov	x11, 0
	lsr	x0, x10, 59
	lsl	x7, x11, 5
	orr	x7, x0, x7
	lsl	x6, x10, 5
	ldrsw	x0, [x29, -28]
	mov	x8, x0
	mov	x9, 0
	lsr	x0, x8, 59
	lsl	x5, x9, 5
	orr	x5, x0, x5
	lsl	x4, x8, 5
	ldrsw	x0, [x29, -28]
	lsl	x0, x0, 2
	add	x0, x0, 15
	lsr	x0, x0, 4
	lsl	x0, x0, 4
	and	x1, x0, -65536
	sub	x1, sp, x1
.L89:
	cmp	sp, x1
	beq	.L90
	sub	sp, sp, #65536
	str	xzr, [sp, 1024]
	b	.L89
.L90:
	and	x1, x0, 65535
	sub	sp, sp, x1
	str	xzr, [sp]
	and	x0, x0, 65535
	cmp	x0, 1024
	bcc	.L91
	str	xzr, [sp, 1024]
.L91:
	add	x0, sp, 16
	add	x0, x0, 3
	lsr	x0, x0, 2
	lsl	x0, x0, 2
	str	x0, [x29, -16]
	str	wzr, [x29, -32]
	ldr	w0, [x29, -28]
	mov	w1, 1
	lsl	w0, w1, w0
	str	w0, [x29, -52]
	str	wzr, [x29, -44]
	b	.L92
.L103:
	str	wzr, [x29, -48]
	ldr	w1, [x29, -44]
	ldr	w0, [x29, -32]
	sub	w0, w1, w0
	str	w0, [x29, -36]
	ldr	w0, [x29, -36]
	str	w0, [x29, -40]
	b	.L93
.L97:
	ldrsw	x0, [x29, -40]
	lsl	x0, x0, 2
	ldr	x1, [x29, -80]
	add	x0, x1, x0
	ldr	w1, [x0]
	ldr	w0, [x29, -52]
	and	w0, w1, w0
	cmp	w0, 0
	beq	.L94
	ldr	w1, [x29, -40]
	ldr	w0, [x29, -36]
	cmp	w1, w0
	beq	.L95
	ldrsw	x0, [x29, -40]
	lsl	x0, x0, 2
	ldr	x1, [x29, -80]
	add	x0, x1, x0
	ldr	w0, [x0]
	str	w0, [x29, -56]
	ldrsw	x0, [x29, -36]
	lsl	x0, x0, 2
	ldr	x1, [x29, -80]
	add	x1, x1, x0
	ldrsw	x0, [x29, -40]
	lsl	x0, x0, 2
	ldr	x2, [x29, -80]
	add	x0, x2, x0
	ldr	w1, [x1]
	str	w1, [x0]
	ldrsw	x0, [x29, -36]
	lsl	x0, x0, 2
	ldr	x1, [x29, -80]
	add	x0, x1, x0
	ldr	w1, [x29, -56]
	str	w1, [x0]
.L95:
	ldr	w0, [x29, -40]
	add	w0, w0, 1
	str	w0, [x29, -48]
	b	.L96
.L94:
	ldr	w0, [x29, -40]
	add	w0, w0, 1
	str	w0, [x29, -40]
.L93:
	ldr	w1, [x29, -40]
	ldr	w0, [x29, -28]
	cmp	w1, w0
	blt	.L97
.L96:
	ldr	w0, [x29, -48]
	cmp	w0, 0
	beq	.L98
	ldrsw	x0, [x29, -36]
	lsl	x0, x0, 2
	ldr	x1, [x29, -80]
	add	x0, x1, x0
	ldr	w0, [x0]
	str	w0, [x29, -56]
	ldr	w0, [x29, -48]
	str	w0, [x29, -40]
	b	.L99
.L101:
	ldrsw	x0, [x29, -40]
	lsl	x0, x0, 2
	ldr	x1, [x29, -80]
	add	x0, x1, x0
	ldr	w1, [x0]
	ldr	w0, [x29, -52]
	and	w0, w1, w0
	cmp	w0, 0
	beq	.L100
	ldrsw	x0, [x29, -40]
	lsl	x0, x0, 2
	ldr	x1, [x29, -80]
	add	x0, x1, x0
	ldr	w2, [x0]
	ldrsw	x0, [x29, -40]
	lsl	x0, x0, 2
	ldr	x1, [x29, -80]
	add	x0, x1, x0
	ldr	w1, [x29, -56]
	eor	w1, w2, w1
	str	w1, [x0]
.L100:
	ldr	w0, [x29, -40]
	add	w0, w0, 1
	str	w0, [x29, -40]
.L99:
	ldr	w1, [x29, -40]
	ldr	w0, [x29, -28]
	cmp	w1, w0
	blt	.L101
	b	.L102
.L98:
	ldr	w0, [x29, -32]
	add	w1, w0, 1
	str	w1, [x29, -32]
	ldr	x1, [x29, -16]
	sxtw	x0, w0
	ldr	w2, [x29, -44]
	str	w2, [x1, x0, lsl 2]
.L102:
	ldr	w0, [x29, -52]
	lsr	w0, w0, 1
	str	w0, [x29, -52]
	ldr	w0, [x29, -44]
	add	w0, w0, 1
	str	w0, [x29, -44]
.L92:
	ldr	w1, [x29, -44]
	ldr	w0, [x29, -28]
	cmp	w1, w0
	blt	.L103
	ldr	w0, [x29, -32]
	cmp	w0, 0
	ble	.L104
	ldr	w0, [x29, -32]
	str	w0, [x29, -36]
	ldr	w0, [x29, -28]
	sub	w0, w0, #1
	str	w0, [x29, -40]
	b	.L105
.L110:
	ldr	w0, [x29, -28]
	sub	w1, w0, #1
	ldr	w0, [x29, -32]
	sub	w0, w1, w0
	ldr	w1, [x29, -40]
	cmp	w1, w0
	ble	.L106
	ldrsw	x0, [x29, -40]
	lsl	x0, x0, 2
	ldr	x1, [x29, -80]
	add	x0, x1, x0
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.L106
	mov	w0, 0
	b	.L107
.L106:
	ldr	w0, [x29, -36]
	cmp	w0, 0
	beq	.L108
	ldr	w0, [x29, -36]
	sub	w1, w0, #1
	ldr	x0, [x29, -16]
	sxtw	x1, w1
	ldr	w0, [x0, x1, lsl 2]
	ldr	w1, [x29, -40]
	cmp	w1, w0
	bne	.L108
	ldr	w0, [x29, -36]
	sub	w0, w0, #1
	str	w0, [x29, -36]
	ldr	w1, [x29, -28]
	ldr	w0, [x29, -40]
	sub	w0, w1, w0
	mov	w1, 1
	lsl	w0, w1, w0
	b	.L109
.L108:
	ldr	w1, [x29, -40]
	ldr	w0, [x29, -36]
	sub	w0, w1, w0
	sxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [x29, -80]
	add	x0, x1, x0
	ldr	w0, [x0]
.L109:
	ldrsw	x1, [x29, -40]
	lsl	x1, x1, 2
	ldr	x2, [x29, -80]
	add	x1, x2, x1
	str	w0, [x1]
	ldr	w0, [x29, -40]
	sub	w0, w0, #1
	str	w0, [x29, -40]
.L105:
	ldr	w0, [x29, -40]
	cmp	w0, 0
	bge	.L110
.L104:
	ldr	w0, [x29, -32]
	mov	w1, 1
	lsl	w0, w1, w0
	ldr	w1, [x29, -92]
	cmp	w1, w0
	beq	.L111
	mov	w0, 0
	b	.L107
.L111:
	str	wzr, [x29, -36]
	b	.L112
.L117:
	str	wzr, [x29, -44]
	b	.L113
.L114:
	ldr	x0, [x29, -16]
	ldrsw	x1, [x29, -44]
	ldr	w0, [x0, x1, lsl 2]
	sxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [x29, -80]
	add	x0, x1, x0
	ldr	w0, [x0]
	and	w2, w0, -2
	ldr	w0, [x29, -44]
	ldr	w1, [x29, -36]
	asr	w0, w1, w0
	and	w1, w0, 1
	ldr	x0, [x29, -16]
	ldrsw	x3, [x29, -44]
	ldr	w0, [x0, x3, lsl 2]
	sxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x3, [x29, -80]
	add	x0, x3, x0
	orr	w1, w2, w1
	str	w1, [x0]
	ldr	w0, [x29, -44]
	add	w0, w0, 1
	str	w0, [x29, -44]
.L113:
	ldr	w1, [x29, -44]
	ldr	w0, [x29, -32]
	cmp	w1, w0
	blt	.L114
	str	wzr, [x29, -56]
	ldr	w0, [x29, -28]
	sub	w0, w0, #1
	str	w0, [x29, -40]
	b	.L115
.L116:
	ldrsw	x0, [x29, -40]
	lsl	x0, x0, 2
	ldr	x1, [x29, -80]
	add	x0, x1, x0
	ldr	w1, [x0]
	ldr	w0, [x29, -56]
	orr	w0, w0, 1
	and	w0, w1, w0
	str	w0, [x29, -52]
	ldr	w0, [x29, -52]
	bl	parity
	mov	w2, w0
	ldr	w1, [x29, -28]
	ldr	w0, [x29, -40]
	sub	w0, w1, w0
	lsl	w0, w2, w0
	mov	w1, w0
	ldr	w0, [x29, -56]
	orr	w0, w0, w1
	str	w0, [x29, -56]
	ldr	w0, [x29, -40]
	sub	w0, w0, #1
	str	w0, [x29, -40]
.L115:
	ldr	w0, [x29, -40]
	cmp	w0, 0
	bge	.L116
	ldrsw	x0, [x29, -36]
	lsl	x0, x0, 2
	ldr	x1, [x29, -88]
	add	x0, x1, x0
	ldr	w1, [x29, -56]
	lsr	w1, w1, 1
	str	w1, [x0]
	ldr	w0, [x29, -36]
	add	w0, w0, 1
	str	w0, [x29, -36]
.L112:
	ldr	w1, [x29, -36]
	ldr	w0, [x29, -92]
	cmp	w1, w0
	blt	.L117
	ldr	w0, [x29, -92]
.L107:
	mov	sp, x19
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [x29, -8]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L119
	bl	__stack_chk_fail
.L119:
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
.LFE25:
	.size	solve_linear_system, .-solve_linear_system
	.align	2
	.type	find_affine4_roots, %function
find_affine4_roots:
.LFB26:
	.cfi_startproc
	sub	sp, sp, #160
	.cfi_def_cfa_offset 160
	stp	x29, x30, [sp, 128]
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	add	x29, sp, 128
	stp	x19, x20, [sp, 144]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	str	w2, [sp, 16]
	str	w3, [sp, 12]
	str	x4, [sp]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 120]
	mov	x1, 0
	ldr	x0, [sp, 24]
	ldr	w0, [x0]
	str	w0, [sp, 48]
	mov	w0, 255
	str	w0, [sp, 44]
	add	x0, sp, 56
	movi	v0.4s, 0
	stp	q0, q0, [x0]
	stp	q0, q0, [x0, 32]
	ldr	w1, [sp, 16]
	ldr	x0, [sp, 24]
	bl	a_log
	str	w0, [sp, 36]
	ldr	w1, [sp, 20]
	ldr	x0, [sp, 24]
	bl	a_log
	str	w0, [sp, 40]
	ldr	w0, [sp, 12]
	str	w0, [sp, 56]
	str	wzr, [sp, 32]
	b	.L121
.L126:
	ldr	x0, [sp, 24]
	ldr	x1, [x0, 24]
	ldr	w0, [sp, 32]
	lsl	w0, w0, 2
	sxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w0, [x0]
	mov	w20, w0
	ldr	w0, [sp, 20]
	cmp	w0, 0
	beq	.L122
	ldr	x0, [sp, 24]
	ldr	x19, [x0, 24]
	ldr	w0, [sp, 40]
	mov	w1, w0
	ldr	x0, [sp, 24]
	bl	mod_s
	sxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x19, x0
	ldrh	w0, [x0]
	b	.L123
.L122:
	mov	w0, 0
.L123:
	eor	w19, w0, w20
	ldr	w0, [sp, 16]
	cmp	w0, 0
	beq	.L124
	ldr	x0, [sp, 24]
	ldr	x20, [x0, 24]
	ldr	w0, [sp, 36]
	mov	w1, w0
	ldr	x0, [sp, 24]
	bl	mod_s
	sxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x20, x0
	ldrh	w0, [x0]
	b	.L125
.L124:
	mov	w0, 0
.L125:
	eor	w1, w0, w19
	ldr	w0, [sp, 32]
	add	w0, w0, 1
	mov	w2, w1
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x1, sp, 56
	str	w2, [x1, x0]
	ldr	w0, [sp, 36]
	add	w0, w0, 1
	str	w0, [sp, 36]
	ldr	w0, [sp, 40]
	add	w0, w0, 2
	str	w0, [sp, 40]
	ldr	w0, [sp, 32]
	add	w0, w0, 1
	str	w0, [sp, 32]
.L121:
	ldr	w1, [sp, 32]
	ldr	w0, [sp, 48]
	cmp	w1, w0
	blt	.L126
	mov	w0, 8
	str	w0, [sp, 36]
	b	.L127
.L130:
	str	wzr, [sp, 40]
	b	.L128
.L129:
	ldrsw	x0, [sp, 40]
	lsl	x0, x0, 2
	add	x1, sp, 56
	ldr	w1, [x1, x0]
	ldr	w0, [sp, 36]
	lsr	w1, w1, w0
	ldr	w2, [sp, 40]
	ldr	w0, [sp, 36]
	add	w0, w2, w0
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x2, sp, 56
	ldr	w0, [x2, x0]
	eor	w0, w1, w0
	ldr	w1, [sp, 44]
	and	w0, w1, w0
	str	w0, [sp, 52]
	ldrsw	x0, [sp, 40]
	lsl	x0, x0, 2
	add	x1, sp, 56
	ldr	w1, [x1, x0]
	ldr	w0, [sp, 36]
	ldr	w2, [sp, 52]
	lsl	w0, w2, w0
	eor	w2, w1, w0
	ldrsw	x0, [sp, 40]
	lsl	x0, x0, 2
	add	x1, sp, 56
	str	w2, [x1, x0]
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 36]
	add	w0, w1, w0
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x1, sp, 56
	ldr	w1, [x1, x0]
	ldr	w2, [sp, 40]
	ldr	w0, [sp, 36]
	add	w3, w2, w0
	ldr	w0, [sp, 52]
	eor	w2, w1, w0
	sxtw	x0, w3
	lsl	x0, x0, 2
	add	x1, sp, 56
	str	w2, [x1, x0]
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 36]
	add	w0, w1, w0
	add	w1, w0, 1
	ldr	w0, [sp, 36]
	mvn	w0, w0
	and	w0, w1, w0
	str	w0, [sp, 40]
.L128:
	ldr	w0, [sp, 40]
	cmp	w0, 15
	ble	.L129
	ldr	w0, [sp, 36]
	asr	w0, w0, 1
	str	w0, [sp, 36]
	ldr	w0, [sp, 36]
	ldr	w1, [sp, 44]
	lsl	w0, w1, w0
	ldr	w1, [sp, 44]
	eor	w0, w1, w0
	str	w0, [sp, 44]
.L127:
	ldr	w0, [sp, 36]
	cmp	w0, 0
	bne	.L130
	add	x0, sp, 56
	mov	w3, 4
	ldr	x2, [sp]
	mov	x1, x0
	ldr	x0, [sp, 24]
	bl	solve_linear_system
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 120]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L132
	bl	__stack_chk_fail
.L132:
	mov	w0, w1
	ldp	x19, x20, [sp, 144]
	ldp	x29, x30, [sp, 128]
	add	sp, sp, 160
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE26:
	.size	find_affine4_roots, .-find_affine4_roots
	.align	2
	.type	find_poly_deg1_roots, %function
find_poly_deg1_roots:
.LFB27:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	str	x2, [sp, 24]
	str	wzr, [sp, 60]
	ldr	x0, [sp, 32]
	ldr	w0, [x0, 4]
	cmp	w0, 0
	beq	.L134
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 4]
	ldr	x1, [sp, 40]
	ldr	x2, [x1, 32]
	ldr	x1, [sp, 32]
	ldr	w1, [x1, 4]
	uxtw	x1, w1
	lsl	x1, x1, 1
	add	x1, x2, x1
	ldrh	w1, [x1]
	sub	w0, w0, w1
	ldr	x1, [sp, 40]
	ldr	x2, [x1, 32]
	ldr	x1, [sp, 32]
	ldr	w1, [x1, 8]
	uxtw	x1, w1
	lsl	x1, x1, 1
	add	x1, x2, x1
	ldrh	w1, [x1]
	add	w0, w0, w1
	mov	w1, w0
	ldr	x0, [sp, 40]
	bl	mod_s
	mov	w2, w0
	ldr	w0, [sp, 60]
	add	w1, w0, 1
	str	w1, [sp, 60]
	sxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	mov	w1, w2
	str	w1, [x0]
.L134:
	ldr	w0, [sp, 60]
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE27:
	.size	find_poly_deg1_roots, .-find_poly_deg1_roots
	.align	2
	.type	find_poly_deg2_roots, %function
find_poly_deg2_roots:
.LFB28:
	.cfi_startproc
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	str	x2, [sp, 24]
	str	wzr, [sp, 48]
	ldr	x0, [sp, 32]
	ldr	w0, [x0, 4]
	cmp	w0, 0
	beq	.L137
	ldr	x0, [sp, 32]
	ldr	w0, [x0, 8]
	cmp	w0, 0
	beq	.L137
	ldr	x0, [sp, 40]
	ldr	x1, [x0, 32]
	ldr	x0, [sp, 32]
	ldr	w0, [x0, 4]
	uxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w0, [x0]
	str	w0, [sp, 60]
	ldr	x0, [sp, 40]
	ldr	x1, [x0, 32]
	ldr	x0, [sp, 32]
	ldr	w0, [x0, 8]
	uxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w0, [x0]
	str	w0, [sp, 64]
	ldr	x0, [sp, 40]
	ldr	x1, [x0, 32]
	ldr	x0, [sp, 32]
	ldr	w0, [x0, 12]
	uxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w0, [x0]
	str	w0, [sp, 68]
	ldr	w1, [sp, 60]
	ldr	w0, [sp, 68]
	add	w0, w1, w0
	mov	w2, w0
	ldr	x0, [sp, 40]
	ldr	w1, [x0, 4]
	ldr	w0, [sp, 64]
	sub	w0, w1, w0
	lsl	w0, w0, 1
	add	w0, w2, w0
	mov	w1, w0
	ldr	x0, [sp, 40]
	bl	a_pow
	str	w0, [sp, 72]
	str	wzr, [sp, 56]
	ldr	w0, [sp, 72]
	str	w0, [sp, 52]
	b	.L138
.L139:
	ldr	w0, [sp, 52]
	bl	deg
	str	w0, [sp, 76]
	ldr	x0, [sp, 40]
	ldr	x1, [x0, 64]
	ldrsw	x0, [sp, 76]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0]
	ldr	w1, [sp, 56]
	eor	w0, w1, w0
	str	w0, [sp, 56]
	ldr	w0, [sp, 76]
	mov	w1, 1
	lsl	w0, w1, w0
	mov	w1, w0
	ldr	w0, [sp, 52]
	eor	w0, w0, w1
	str	w0, [sp, 52]
.L138:
	ldr	w0, [sp, 52]
	cmp	w0, 0
	bne	.L139
	ldr	w1, [sp, 56]
	ldr	x0, [sp, 40]
	bl	gf_sqr
	mov	w1, w0
	ldr	w0, [sp, 56]
	eor	w0, w1, w0
	ldr	w1, [sp, 72]
	cmp	w1, w0
	bne	.L137
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 4]
	lsl	w1, w0, 1
	ldr	w0, [sp, 64]
	sub	w0, w1, w0
	ldr	x1, [sp, 40]
	ldr	x2, [x1, 32]
	ldr	w1, [sp, 56]
	lsl	x1, x1, 1
	add	x1, x2, x1
	ldrh	w1, [x1]
	sub	w1, w0, w1
	ldr	w0, [sp, 68]
	add	w0, w1, w0
	mov	w1, w0
	ldr	x0, [sp, 40]
	bl	modulo
	mov	w2, w0
	ldr	w0, [sp, 48]
	add	w1, w0, 1
	str	w1, [sp, 48]
	sxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	mov	w1, w2
	str	w1, [x0]
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 4]
	lsl	w1, w0, 1
	ldr	w0, [sp, 64]
	sub	w0, w1, w0
	ldr	x1, [sp, 40]
	ldr	x2, [x1, 32]
	ldr	w1, [sp, 56]
	eor	w1, w1, 1
	uxtw	x1, w1
	lsl	x1, x1, 1
	add	x1, x2, x1
	ldrh	w1, [x1]
	sub	w1, w0, w1
	ldr	w0, [sp, 68]
	add	w0, w1, w0
	mov	w1, w0
	ldr	x0, [sp, 40]
	bl	modulo
	mov	w2, w0
	ldr	w0, [sp, 48]
	add	w1, w0, 1
	str	w1, [sp, 48]
	sxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	mov	w1, w2
	str	w1, [x0]
.L137:
	ldr	w0, [sp, 48]
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE28:
	.size	find_poly_deg2_roots, .-find_poly_deg2_roots
	.align	2
	.type	find_poly_deg3_roots, %function
find_poly_deg3_roots:
.LFB29:
	.cfi_startproc
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
	stp	x29, x30, [sp, 96]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 96
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	x2, [sp, 8]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 88]
	mov	x1, 0
	str	wzr, [sp, 40]
	ldr	x0, [sp, 16]
	ldr	w0, [x0, 4]
	cmp	w0, 0
	beq	.L142
	ldr	x0, [sp, 16]
	ldr	w0, [x0, 16]
	str	w0, [sp, 44]
	ldr	x0, [sp, 16]
	ldr	w0, [x0, 4]
	ldr	w2, [sp, 44]
	mov	w1, w0
	ldr	x0, [sp, 24]
	bl	gf_div
	str	w0, [sp, 48]
	ldr	x0, [sp, 16]
	ldr	w0, [x0, 8]
	ldr	w2, [sp, 44]
	mov	w1, w0
	ldr	x0, [sp, 24]
	bl	gf_div
	str	w0, [sp, 52]
	ldr	x0, [sp, 16]
	ldr	w0, [x0, 12]
	ldr	w2, [sp, 44]
	mov	w1, w0
	ldr	x0, [sp, 24]
	bl	gf_div
	str	w0, [sp, 56]
	ldr	w2, [sp, 48]
	ldr	w1, [sp, 56]
	ldr	x0, [sp, 24]
	bl	gf_mul
	str	w0, [sp, 60]
	ldr	w2, [sp, 52]
	ldr	w1, [sp, 56]
	ldr	x0, [sp, 24]
	bl	gf_mul
	mov	w1, w0
	ldr	w0, [sp, 48]
	eor	w0, w0, w1
	str	w0, [sp, 64]
	ldr	w1, [sp, 56]
	ldr	x0, [sp, 24]
	bl	gf_sqr
	mov	w1, w0
	ldr	w0, [sp, 52]
	eor	w0, w0, w1
	str	w0, [sp, 68]
	add	x0, sp, 72
	mov	x4, x0
	ldr	w3, [sp, 60]
	ldr	w2, [sp, 64]
	ldr	w1, [sp, 68]
	ldr	x0, [sp, 24]
	bl	find_affine4_roots
	cmp	w0, 4
	bne	.L142
	str	wzr, [sp, 36]
	b	.L143
.L145:
	ldrsw	x0, [sp, 36]
	lsl	x0, x0, 2
	add	x1, sp, 72
	ldr	w0, [x1, x0]
	ldr	w1, [sp, 56]
	cmp	w1, w0
	beq	.L144
	ldrsw	x0, [sp, 36]
	lsl	x0, x0, 2
	add	x1, sp, 72
	ldr	w0, [x1, x0]
	mov	w1, w0
	ldr	x0, [sp, 24]
	bl	a_ilog
	mov	w2, w0
	ldr	w0, [sp, 40]
	add	w1, w0, 1
	str	w1, [sp, 40]
	sxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	mov	w1, w2
	str	w1, [x0]
.L144:
	ldr	w0, [sp, 36]
	add	w0, w0, 1
	str	w0, [sp, 36]
.L143:
	ldr	w0, [sp, 36]
	cmp	w0, 3
	ble	.L145
.L142:
	ldr	w0, [sp, 40]
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 88]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L147
	bl	__stack_chk_fail
.L147:
	mov	w0, w1
	ldp	x29, x30, [sp, 96]
	add	sp, sp, 112
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE29:
	.size	find_poly_deg3_roots, .-find_poly_deg3_roots
	.align	2
	.type	find_poly_deg4_roots, %function
find_poly_deg4_roots:
.LFB30:
	.cfi_startproc
	stp	x29, x30, [sp, -128]!
	.cfi_def_cfa_offset 128
	.cfi_offset 29, -128
	.cfi_offset 30, -120
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -112
	str	x0, [sp, 56]
	str	x1, [sp, 48]
	str	x2, [sp, 40]
	str	wzr, [sp, 80]
	str	wzr, [sp, 92]
	ldr	x0, [sp, 48]
	ldr	w0, [x0, 4]
	cmp	w0, 0
	bne	.L149
	mov	w0, 0
	b	.L150
.L149:
	ldr	x0, [sp, 48]
	ldr	w0, [x0, 20]
	str	w0, [sp, 108]
	ldr	x0, [sp, 48]
	ldr	w0, [x0, 4]
	ldr	w2, [sp, 108]
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	gf_div
	str	w0, [sp, 88]
	ldr	x0, [sp, 48]
	ldr	w0, [x0, 8]
	ldr	w2, [sp, 108]
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	gf_div
	str	w0, [sp, 112]
	ldr	x0, [sp, 48]
	ldr	w0, [x0, 12]
	ldr	w2, [sp, 108]
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	gf_div
	str	w0, [sp, 84]
	ldr	x0, [sp, 48]
	ldr	w0, [x0, 16]
	ldr	w2, [sp, 108]
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	gf_div
	str	w0, [sp, 116]
	ldr	w0, [sp, 116]
	cmp	w0, 0
	beq	.L151
	ldr	w0, [sp, 112]
	cmp	w0, 0
	beq	.L152
	ldr	w2, [sp, 116]
	ldr	w1, [sp, 112]
	ldr	x0, [sp, 56]
	bl	gf_div
	str	w0, [sp, 120]
	ldr	w1, [sp, 120]
	ldr	x0, [sp, 56]
	bl	a_log
	str	w0, [sp, 124]
	ldr	w0, [sp, 124]
	and	w0, w0, 1
	cmp	w0, 0
	beq	.L153
	ldr	x0, [sp, 56]
	ldr	w0, [x0, 4]
	b	.L154
.L153:
	mov	w0, 0
.L154:
	ldr	w1, [sp, 124]
	add	w0, w0, w1
	str	w0, [sp, 124]
	ldr	w0, [sp, 124]
	lsr	w1, w0, 31
	add	w0, w1, w0
	asr	w0, w0, 1
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	a_pow
	str	w0, [sp, 92]
	ldr	w0, [sp, 124]
	lsl	w0, w0, 1
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	a_pow
	mov	w19, w0
	ldr	w2, [sp, 120]
	ldr	w1, [sp, 84]
	ldr	x0, [sp, 56]
	bl	gf_mul
	eor	w0, w19, w0
	ldr	w1, [sp, 88]
	eor	w0, w1, w0
	str	w0, [sp, 88]
	ldr	w2, [sp, 92]
	ldr	w1, [sp, 116]
	ldr	x0, [sp, 56]
	bl	gf_mul
	mov	w1, w0
	ldr	w0, [sp, 84]
	eor	w0, w0, w1
	str	w0, [sp, 84]
.L152:
	ldr	w0, [sp, 88]
	cmp	w0, 0
	bne	.L155
	mov	w0, 0
	b	.L150
.L155:
	ldr	w1, [sp, 88]
	ldr	x0, [sp, 56]
	bl	gf_inv
	str	w0, [sp, 104]
	ldr	w2, [sp, 88]
	ldr	w1, [sp, 116]
	ldr	x0, [sp, 56]
	bl	gf_div
	str	w0, [sp, 100]
	ldr	w2, [sp, 88]
	ldr	w1, [sp, 84]
	ldr	x0, [sp, 56]
	bl	gf_div
	str	w0, [sp, 96]
	b	.L156
.L151:
	ldr	w0, [sp, 88]
	str	w0, [sp, 104]
	ldr	w0, [sp, 112]
	str	w0, [sp, 100]
	ldr	w0, [sp, 84]
	str	w0, [sp, 96]
.L156:
	ldr	x4, [sp, 40]
	ldr	w3, [sp, 104]
	ldr	w2, [sp, 100]
	ldr	w1, [sp, 96]
	ldr	x0, [sp, 56]
	bl	find_affine4_roots
	cmp	w0, 4
	bne	.L157
	str	wzr, [sp, 76]
	b	.L158
.L161:
	ldr	w0, [sp, 116]
	cmp	w0, 0
	beq	.L159
	ldrsw	x0, [sp, 76]
	lsl	x0, x0, 2
	ldr	x1, [sp, 40]
	add	x0, x1, x0
	ldr	w0, [x0]
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	gf_inv
	b	.L160
.L159:
	ldrsw	x0, [sp, 76]
	lsl	x0, x0, 2
	ldr	x1, [sp, 40]
	add	x0, x1, x0
	ldr	w0, [x0]
.L160:
	str	w0, [sp, 120]
	ldr	w1, [sp, 120]
	ldr	w0, [sp, 92]
	eor	w0, w1, w0
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	a_ilog
	mov	w2, w0
	ldrsw	x0, [sp, 76]
	lsl	x0, x0, 2
	ldr	x1, [sp, 40]
	add	x0, x1, x0
	mov	w1, w2
	str	w1, [x0]
	ldr	w0, [sp, 76]
	add	w0, w0, 1
	str	w0, [sp, 76]
.L158:
	ldr	w0, [sp, 76]
	cmp	w0, 3
	ble	.L161
	mov	w0, 4
	str	w0, [sp, 80]
.L157:
	ldr	w0, [sp, 80]
.L150:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 128
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE30:
	.size	find_poly_deg4_roots, .-find_poly_deg4_roots
	.align	2
	.type	gf_poly_logrep, %function
gf_poly_logrep:
.LFB31:
	.cfi_startproc
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -64
	str	x0, [sp, 56]
	str	x1, [sp, 48]
	str	x2, [sp, 40]
	ldr	x0, [sp, 48]
	ldr	w0, [x0]
	str	w0, [sp, 72]
	ldr	x0, [sp, 56]
	ldr	w19, [x0, 4]
	ldr	x0, [sp, 48]
	ldr	w0, [x0]
	ldr	x1, [sp, 48]
	uxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	a_log
	sub	w0, w19, w0
	str	w0, [sp, 76]
	str	wzr, [sp, 68]
	b	.L163
.L166:
	ldr	x1, [sp, 48]
	ldrsw	x0, [sp, 68]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	cmp	w0, 0
	beq	.L164
	ldr	x1, [sp, 48]
	ldrsw	x0, [sp, 68]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	a_log
	mov	w1, w0
	ldr	w0, [sp, 76]
	add	w0, w1, w0
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	mod_s
	b	.L165
.L164:
	mov	w0, -1
.L165:
	ldrsw	x1, [sp, 68]
	lsl	x1, x1, 2
	ldr	x2, [sp, 40]
	add	x1, x2, x1
	str	w0, [x1]
	ldr	w0, [sp, 68]
	add	w0, w0, 1
	str	w0, [sp, 68]
.L163:
	ldr	w1, [sp, 68]
	ldr	w0, [sp, 72]
	cmp	w1, w0
	blt	.L166
	nop
	nop
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE31:
	.size	gf_poly_logrep, .-gf_poly_logrep
	.align	2
	.type	gf_poly_mod, %function
gf_poly_mod:
.LFB32:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -80
	str	x0, [sp, 56]
	str	x1, [sp, 48]
	str	x2, [sp, 40]
	str	x3, [sp, 32]
	ldr	x0, [sp, 48]
	add	x0, x0, 4
	str	x0, [sp, 88]
	ldr	x0, [sp, 40]
	ldr	w0, [x0]
	str	w0, [sp, 76]
	ldr	x0, [sp, 48]
	ldr	w0, [x0]
	ldr	w1, [sp, 76]
	cmp	w1, w0
	bhi	.L179
	ldr	x0, [sp, 32]
	cmp	x0, 0
	bne	.L170
	ldr	x0, [sp, 56]
	ldr	x0, [x0, 80]
	str	x0, [sp, 32]
	ldr	x2, [sp, 32]
	ldr	x1, [sp, 40]
	ldr	x0, [sp, 56]
	bl	gf_poly_logrep
.L170:
	ldr	x0, [sp, 48]
	ldr	w0, [x0]
	str	w0, [sp, 72]
	b	.L171
.L176:
	ldr	w0, [sp, 72]
	lsl	x0, x0, 2
	ldr	x1, [sp, 88]
	add	x0, x1, x0
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.L172
	ldr	w0, [sp, 72]
	lsl	x0, x0, 2
	ldr	x1, [sp, 88]
	add	x0, x1, x0
	ldr	w0, [x0]
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	a_log
	str	w0, [sp, 80]
	ldr	w1, [sp, 72]
	ldr	w0, [sp, 76]
	sub	w0, w1, w0
	str	w0, [sp, 64]
	str	wzr, [sp, 68]
	b	.L173
.L175:
	ldr	w0, [sp, 68]
	lsl	x0, x0, 2
	ldr	x1, [sp, 32]
	add	x0, x1, x0
	ldr	w0, [x0]
	str	w0, [sp, 84]
	ldr	w0, [sp, 84]
	cmp	w0, 0
	blt	.L174
	ldr	x0, [sp, 56]
	ldr	x19, [x0, 24]
	ldr	w1, [sp, 84]
	ldr	w0, [sp, 80]
	add	w0, w1, w0
	mov	w1, w0
	ldr	x0, [sp, 56]
	bl	mod_s
	sxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x19, x0
	ldrh	w2, [x0]
	ldrsw	x0, [sp, 64]
	lsl	x0, x0, 2
	ldr	x1, [sp, 88]
	add	x0, x1, x0
	ldr	w1, [x0]
	mov	w3, w2
	ldrsw	x0, [sp, 64]
	lsl	x0, x0, 2
	ldr	x2, [sp, 88]
	add	x0, x2, x0
	eor	w1, w1, w3
	str	w1, [x0]
.L174:
	ldr	w0, [sp, 68]
	add	w0, w0, 1
	str	w0, [sp, 68]
	ldr	w0, [sp, 64]
	add	w0, w0, 1
	str	w0, [sp, 64]
.L173:
	ldr	w1, [sp, 68]
	ldr	w0, [sp, 76]
	cmp	w1, w0
	bcc	.L175
.L172:
	ldr	w0, [sp, 72]
	sub	w0, w0, #1
	str	w0, [sp, 72]
.L171:
	ldr	w1, [sp, 72]
	ldr	w0, [sp, 76]
	cmp	w1, w0
	bcs	.L176
	ldr	w0, [sp, 76]
	sub	w1, w0, #1
	ldr	x0, [sp, 48]
	str	w1, [x0]
	b	.L177
.L178:
	ldr	x0, [sp, 48]
	ldr	w0, [x0]
	sub	w1, w0, #1
	ldr	x0, [sp, 48]
	str	w1, [x0]
.L177:
	ldr	x0, [sp, 48]
	ldr	w0, [x0]
	uxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [sp, 88]
	add	x0, x1, x0
	ldr	w0, [x0]
	cmp	w0, 0
	bne	.L167
	ldr	x0, [sp, 48]
	ldr	w0, [x0]
	cmp	w0, 0
	bne	.L178
	b	.L167
.L179:
	nop
.L167:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 96
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE32:
	.size	gf_poly_mod, .-gf_poly_mod
	.align	2
	.type	gf_poly_div, %function
gf_poly_div:
.LFB33:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	str	x2, [sp, 24]
	str	x3, [sp, 16]
	ldr	x0, [sp, 32]
	ldr	w1, [x0]
	ldr	x0, [sp, 24]
	ldr	w0, [x0]
	cmp	w1, w0
	bcc	.L181
	ldr	x0, [sp, 32]
	ldr	w1, [x0]
	ldr	x0, [sp, 24]
	ldr	w0, [x0]
	sub	w1, w1, w0
	ldr	x0, [sp, 16]
	str	w1, [x0]
	mov	x3, 0
	ldr	x2, [sp, 24]
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 40]
	bl	gf_poly_mod
	ldr	x0, [sp, 16]
	add	x3, x0, 4
	ldr	x0, [sp, 24]
	ldr	w0, [x0]
	uxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [sp, 32]
	add	x0, x1, x0
	add	x1, x0, 4
	ldr	x0, [sp, 16]
	ldr	w0, [x0]
	add	w0, w0, 1
	uxtw	x0, w0
	lsl	x0, x0, 2
	mov	x2, x0
	mov	x0, x3
	bl	memcpy
	b	.L183
.L181:
	ldr	x0, [sp, 16]
	str	wzr, [x0]
	ldr	x0, [sp, 16]
	str	wzr, [x0, 4]
.L183:
	nop
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE33:
	.size	gf_poly_div, .-gf_poly_div
	.align	2
	.type	gf_poly_gcd, %function
gf_poly_gcd:
.LFB34:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	str	x2, [sp, 24]
	ldr	x0, [sp, 32]
	ldr	w1, [x0]
	ldr	x0, [sp, 24]
	ldr	w0, [x0]
	cmp	w1, w0
	bcs	.L186
	ldr	x0, [sp, 24]
	str	x0, [sp, 56]
	ldr	x0, [sp, 32]
	str	x0, [sp, 24]
	ldr	x0, [sp, 56]
	str	x0, [sp, 32]
	b	.L186
.L187:
	mov	x3, 0
	ldr	x2, [sp, 24]
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 40]
	bl	gf_poly_mod
	ldr	x0, [sp, 24]
	str	x0, [sp, 56]
	ldr	x0, [sp, 32]
	str	x0, [sp, 24]
	ldr	x0, [sp, 56]
	str	x0, [sp, 32]
.L186:
	ldr	x0, [sp, 24]
	ldr	w0, [x0]
	cmp	w0, 0
	bne	.L187
	ldr	x0, [sp, 32]
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE34:
	.size	gf_poly_gcd, .-gf_poly_gcd
	.align	2
	.type	compute_trace_bk_mod, %function
compute_trace_bk_mod:
.LFB35:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -80
	str	x0, [sp, 72]
	str	w1, [sp, 68]
	str	x2, [sp, 56]
	str	x3, [sp, 48]
	str	x4, [sp, 40]
	ldr	x0, [sp, 72]
	ldr	w0, [x0]
	str	w0, [sp, 92]
	ldr	x0, [sp, 48]
	mov	w1, 1
	str	w1, [x0]
	ldr	x0, [sp, 48]
	str	wzr, [x0, 4]
	ldr	x0, [sp, 72]
	ldr	x1, [x0, 24]
	ldrsw	x0, [sp, 68]
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w0, [x0]
	mov	w1, w0
	ldr	x0, [sp, 48]
	str	w1, [x0, 8]
	ldr	x0, [sp, 40]
	str	wzr, [x0]
	ldr	x0, [sp, 56]
	ldr	w0, [x0]
	add	w0, w0, 1
	uxtw	x0, w0
	add	x0, x0, 1
	lsl	x0, x0, 2
	mov	x2, x0
	mov	w1, 0
	ldr	x0, [sp, 40]
	bl	memset
	ldr	x0, [sp, 72]
	ldr	x0, [x0, 80]
	mov	x2, x0
	ldr	x1, [sp, 56]
	ldr	x0, [sp, 72]
	bl	gf_poly_logrep
	str	wzr, [sp, 84]
	b	.L190
.L195:
	ldr	x0, [sp, 48]
	ldr	w0, [x0]
	str	w0, [sp, 88]
	b	.L191
.L192:
	ldr	x1, [sp, 40]
	ldrsw	x0, [sp, 88]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w1, [x0, 4]
	ldr	x2, [sp, 48]
	ldrsw	x0, [sp, 88]
	lsl	x0, x0, 2
	add	x0, x2, x0
	ldr	w0, [x0, 4]
	eor	w1, w1, w0
	ldr	x2, [sp, 40]
	ldrsw	x0, [sp, 88]
	lsl	x0, x0, 2
	add	x0, x2, x0
	str	w1, [x0, 4]
	ldr	x1, [sp, 48]
	ldrsw	x0, [sp, 88]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w1, [x0, 4]
	ldr	w0, [sp, 88]
	lsl	w19, w0, 1
	ldr	x0, [sp, 72]
	bl	gf_sqr
	mov	w2, w0
	ldr	x1, [sp, 48]
	sxtw	x0, w19
	lsl	x0, x0, 2
	add	x0, x1, x0
	str	w2, [x0, 4]
	ldr	w0, [sp, 88]
	lsl	w0, w0, 1
	add	w0, w0, 1
	ldr	x1, [sp, 48]
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x1, x0
	str	wzr, [x0, 4]
	ldr	w0, [sp, 88]
	sub	w0, w0, #1
	str	w0, [sp, 88]
.L191:
	ldr	w0, [sp, 88]
	cmp	w0, 0
	bge	.L192
	ldr	x0, [sp, 48]
	ldr	w1, [x0]
	ldr	x0, [sp, 40]
	ldr	w0, [x0]
	cmp	w1, w0
	bls	.L193
	ldr	x0, [sp, 48]
	ldr	w1, [x0]
	ldr	x0, [sp, 40]
	str	w1, [x0]
.L193:
	ldr	w0, [sp, 92]
	sub	w0, w0, #1
	ldr	w1, [sp, 84]
	cmp	w1, w0
	bge	.L194
	ldr	x0, [sp, 48]
	ldr	w0, [x0]
	lsl	w1, w0, 1
	ldr	x0, [sp, 48]
	str	w1, [x0]
	ldr	x0, [sp, 72]
	ldr	x0, [x0, 80]
	mov	x3, x0
	ldr	x2, [sp, 56]
	ldr	x1, [sp, 48]
	ldr	x0, [sp, 72]
	bl	gf_poly_mod
.L194:
	ldr	w0, [sp, 84]
	add	w0, w0, 1
	str	w0, [sp, 84]
.L190:
	ldr	w1, [sp, 84]
	ldr	w0, [sp, 92]
	cmp	w1, w0
	blt	.L195
	b	.L196
.L198:
	ldr	x0, [sp, 40]
	ldr	w0, [x0]
	sub	w1, w0, #1
	ldr	x0, [sp, 40]
	str	w1, [x0]
.L196:
	ldr	x0, [sp, 40]
	ldr	w0, [x0]
	ldr	x1, [sp, 40]
	uxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	cmp	w0, 0
	bne	.L199
	ldr	x0, [sp, 40]
	ldr	w0, [x0]
	cmp	w0, 0
	bne	.L198
.L199:
	nop
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 96
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE35:
	.size	compute_trace_bk_mod, .-compute_trace_bk_mod
	.align	2
	.type	factor_polynomial, %function
factor_polynomial:
.LFB36:
	.cfi_startproc
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	mov	x29, sp
	str	x0, [sp, 56]
	str	w1, [sp, 52]
	str	x2, [sp, 40]
	str	x3, [sp, 32]
	str	x4, [sp, 24]
	ldr	x0, [sp, 56]
	ldr	x0, [x0, 96]
	str	x0, [sp, 72]
	ldr	x0, [sp, 56]
	ldr	x0, [x0, 104]
	str	x0, [sp, 80]
	ldr	x0, [sp, 56]
	ldr	x0, [x0, 112]
	str	x0, [sp, 88]
	ldr	x0, [sp, 56]
	ldr	x0, [x0, 120]
	str	x0, [sp, 96]
	ldr	x0, [sp, 32]
	ldr	x1, [sp, 40]
	str	x1, [x0]
	ldr	x0, [sp, 24]
	str	xzr, [x0]
	ldr	x4, [sp, 88]
	ldr	x3, [sp, 96]
	ldr	x2, [sp, 40]
	ldr	w1, [sp, 52]
	ldr	x0, [sp, 56]
	bl	compute_trace_bk_mod
	ldr	x0, [sp, 88]
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.L202
	ldr	x1, [sp, 40]
	ldr	x0, [sp, 72]
	bl	gf_poly_copy
	ldr	x2, [sp, 88]
	ldr	x1, [sp, 72]
	ldr	x0, [sp, 56]
	bl	gf_poly_gcd
	str	x0, [sp, 104]
	ldr	x0, [sp, 104]
	ldr	w1, [x0]
	ldr	x0, [sp, 40]
	ldr	w0, [x0]
	cmp	w1, w0
	bcs	.L202
	ldr	x3, [sp, 80]
	ldr	x2, [sp, 104]
	ldr	x1, [sp, 40]
	ldr	x0, [sp, 56]
	bl	gf_poly_div
	ldr	x0, [sp, 104]
	ldr	w0, [x0]
	uxtw	x1, w0
	mov	x0, x1
	lsl	x0, x0, 1
	add	x0, x0, x1
	lsl	x0, x0, 2
	mov	x1, x0
	ldr	x0, [sp, 40]
	add	x0, x0, x1
	mov	x1, x0
	ldr	x0, [sp, 24]
	str	x1, [x0]
	ldr	x0, [sp, 32]
	ldr	x0, [x0]
	ldr	x1, [sp, 104]
	bl	gf_poly_copy
	ldr	x0, [sp, 24]
	ldr	x0, [x0]
	ldr	x1, [sp, 80]
	bl	gf_poly_copy
.L202:
	nop
	ldp	x29, x30, [sp], 112
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE36:
	.size	factor_polynomial, .-factor_polynomial
	.align	2
	.type	find_poly_roots, %function
find_poly_roots:
.LFB37:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, 64]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 64
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	str	x2, [sp, 8]
	str	x3, [sp]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 56]
	mov	x1, 0
	ldr	x0, [sp, 8]
	ldr	w0, [x0]
	cmp	w0, 4
	beq	.L204
	cmp	w0, 4
	bhi	.L205
	cmp	w0, 3
	beq	.L206
	cmp	w0, 3
	bhi	.L205
	cmp	w0, 1
	beq	.L207
	cmp	w0, 2
	beq	.L208
	b	.L205
.L207:
	ldr	x2, [sp]
	ldr	x1, [sp, 8]
	ldr	x0, [sp, 24]
	bl	find_poly_deg1_roots
	str	w0, [sp, 36]
	b	.L209
.L208:
	ldr	x2, [sp]
	ldr	x1, [sp, 8]
	ldr	x0, [sp, 24]
	bl	find_poly_deg2_roots
	str	w0, [sp, 36]
	b	.L209
.L206:
	ldr	x2, [sp]
	ldr	x1, [sp, 8]
	ldr	x0, [sp, 24]
	bl	find_poly_deg3_roots
	str	w0, [sp, 36]
	b	.L209
.L204:
	ldr	x2, [sp]
	ldr	x1, [sp, 8]
	ldr	x0, [sp, 24]
	bl	find_poly_deg4_roots
	str	w0, [sp, 36]
	b	.L209
.L205:
	str	wzr, [sp, 36]
	ldr	x0, [sp, 8]
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.L214
	ldr	x0, [sp, 24]
	ldr	w0, [x0]
	ldr	w1, [sp, 20]
	cmp	w1, w0
	bhi	.L214
	ldr	w0, [sp, 20]
	add	x2, sp, 48
	add	x1, sp, 40
	mov	x4, x2
	mov	x3, x1
	ldr	x2, [sp, 8]
	mov	w1, w0
	ldr	x0, [sp, 24]
	bl	factor_polynomial
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L211
	ldr	w0, [sp, 20]
	add	w0, w0, 1
	ldr	x1, [sp, 40]
	ldr	x3, [sp]
	mov	x2, x1
	mov	w1, w0
	ldr	x0, [sp, 24]
	bl	find_poly_roots
	mov	w1, w0
	ldr	w0, [sp, 36]
	add	w0, w0, w1
	str	w0, [sp, 36]
.L211:
	ldr	x0, [sp, 48]
	cmp	x0, 0
	beq	.L214
	ldr	w0, [sp, 20]
	add	w4, w0, 1
	ldr	x2, [sp, 48]
	ldrsw	x0, [sp, 36]
	lsl	x0, x0, 2
	ldr	x1, [sp]
	add	x0, x1, x0
	mov	x3, x0
	mov	w1, w4
	ldr	x0, [sp, 24]
	bl	find_poly_roots
	mov	w1, w0
	ldr	w0, [sp, 36]
	add	w0, w0, w1
	str	w0, [sp, 36]
.L214:
	nop
.L209:
	ldr	w0, [sp, 36]
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 56]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L213
	bl	__stack_chk_fail
.L213:
	mov	w0, w1
	ldp	x29, x30, [sp, 64]
	add	sp, sp, 80
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE37:
	.size	find_poly_roots, .-find_poly_roots
	.align	2
	.global	decode_bch
	.type	decode_bch, %function
decode_bch:
.LFB38:
	.cfi_startproc
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	mov	x29, sp
	str	x0, [sp, 72]
	str	x1, [sp, 64]
	str	w2, [sp, 60]
	str	x3, [sp, 48]
	str	x4, [sp, 40]
	str	x5, [sp, 32]
	str	x6, [sp, 24]
	ldr	x0, [sp, 72]
	ldr	w1, [x0]
	ldr	x0, [sp, 72]
	ldr	w0, [x0, 8]
	mul	w0, w1, w0
	add	w0, w0, 31
	lsr	w0, w0, 5
	str	w0, [sp, 100]
	ldr	w0, [sp, 60]
	lsl	w1, w0, 3
	ldr	x0, [sp, 72]
	ldr	w2, [x0, 4]
	ldr	x0, [sp, 72]
	ldr	w0, [x0, 12]
	sub	w0, w2, w0
	cmp	w1, w0
	bls	.L216
	mov	w0, 75
	b	.L217
.L216:
	ldr	x0, [sp, 32]
	cmp	x0, 0
	bne	.L218
	ldr	x0, [sp, 40]
	cmp	x0, 0
	bne	.L219
	ldr	x0, [sp, 64]
	cmp	x0, 0
	beq	.L220
	ldr	x0, [sp, 48]
	cmp	x0, 0
	bne	.L221
.L220:
	mov	w0, 75
	b	.L217
.L221:
	mov	x3, 0
	ldr	w2, [sp, 60]
	ldr	x1, [sp, 64]
	ldr	x0, [sp, 72]
	bl	encode_bch
	b	.L222
.L219:
	ldr	x0, [sp, 72]
	ldr	x0, [x0, 48]
	ldr	x2, [sp, 40]
	mov	x1, x0
	ldr	x0, [sp, 72]
	bl	load_ecc8
.L222:
	ldr	x0, [sp, 48]
	cmp	x0, 0
	beq	.L223
	ldr	x0, [sp, 72]
	ldr	x0, [x0, 56]
	ldr	x2, [sp, 48]
	mov	x1, x0
	ldr	x0, [sp, 72]
	bl	load_ecc8
	str	wzr, [sp, 88]
	str	wzr, [sp, 96]
	b	.L224
.L225:
	ldr	x0, [sp, 72]
	ldr	x1, [x0, 48]
	ldrsw	x0, [sp, 88]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w2, [x0]
	ldr	x0, [sp, 72]
	ldr	x1, [x0, 56]
	ldrsw	x0, [sp, 88]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w1, [x0]
	ldr	x0, [sp, 72]
	ldr	x3, [x0, 48]
	ldrsw	x0, [sp, 88]
	lsl	x0, x0, 2
	add	x0, x3, x0
	eor	w1, w2, w1
	str	w1, [x0]
	ldr	x0, [sp, 72]
	ldr	x1, [x0, 48]
	ldrsw	x0, [sp, 88]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0]
	ldr	w1, [sp, 96]
	orr	w0, w1, w0
	str	w0, [sp, 96]
	ldr	w0, [sp, 88]
	add	w0, w0, 1
	str	w0, [sp, 88]
.L224:
	ldr	w0, [sp, 100]
	ldr	w1, [sp, 88]
	cmp	w1, w0
	blt	.L225
	ldr	w0, [sp, 96]
	cmp	w0, 0
	bne	.L223
	mov	w0, 0
	b	.L217
.L223:
	ldr	x0, [sp, 72]
	ldr	x1, [x0, 48]
	ldr	x0, [sp, 72]
	ldr	x0, [x0, 72]
	mov	x2, x0
	ldr	x0, [sp, 72]
	bl	compute_syndromes
	ldr	x0, [sp, 72]
	ldr	x0, [x0, 72]
	str	x0, [sp, 32]
.L218:
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 72]
	bl	compute_error_locator_polynomial
	str	w0, [sp, 92]
	ldr	w0, [sp, 92]
	cmp	w0, 0
	ble	.L226
	ldr	x0, [sp, 72]
	ldr	x0, [x0, 88]
	ldr	x3, [sp, 24]
	mov	x2, x0
	mov	w1, 1
	ldr	x0, [sp, 72]
	bl	find_poly_roots
	str	w0, [sp, 104]
	ldr	w1, [sp, 92]
	ldr	w0, [sp, 104]
	cmp	w1, w0
	beq	.L226
	mov	w0, -1
	str	w0, [sp, 92]
.L226:
	ldr	w0, [sp, 92]
	cmp	w0, 0
	ble	.L227
	ldr	w0, [sp, 60]
	lsl	w1, w0, 3
	ldr	x0, [sp, 72]
	ldr	w0, [x0, 12]
	add	w0, w1, w0
	str	w0, [sp, 108]
	str	wzr, [sp, 88]
	b	.L228
.L230:
	ldrsw	x0, [sp, 88]
	lsl	x0, x0, 2
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldr	w0, [x0]
	ldr	w1, [sp, 108]
	cmp	w1, w0
	bhi	.L229
	mov	w0, -1
	str	w0, [sp, 92]
	b	.L227
.L229:
	ldrsw	x0, [sp, 88]
	lsl	x0, x0, 2
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldr	w0, [x0]
	ldr	w1, [sp, 108]
	sub	w1, w1, w0
	ldrsw	x0, [sp, 88]
	lsl	x0, x0, 2
	ldr	x2, [sp, 24]
	add	x0, x2, x0
	sub	w1, w1, #1
	str	w1, [x0]
	ldrsw	x0, [sp, 88]
	lsl	x0, x0, 2
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldr	w1, [x0]
	ldrsw	x0, [sp, 88]
	lsl	x0, x0, 2
	ldr	x2, [sp, 24]
	add	x0, x2, x0
	eor	w1, w1, 7
	str	w1, [x0]
	ldr	w0, [sp, 88]
	add	w0, w0, 1
	str	w0, [sp, 88]
.L228:
	ldr	w1, [sp, 88]
	ldr	w0, [sp, 92]
	cmp	w1, w0
	blt	.L230
.L227:
	ldr	w0, [sp, 92]
	cmp	w0, 0
	blt	.L231
	ldr	w0, [sp, 92]
	b	.L217
.L231:
	mov	w0, 76
.L217:
	ldp	x29, x30, [sp], 112
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE38:
	.size	decode_bch, .-decode_bch
	.align	2
	.type	build_gf_tables, %function
build_gf_tables:
.LFB39:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	mov	w0, 1
	str	w0, [sp, 40]
	ldr	w0, [sp, 20]
	bl	deg
	mov	w1, w0
	mov	w0, 1
	lsl	w0, w0, w1
	str	w0, [sp, 44]
	ldr	x0, [sp, 24]
	ldr	w0, [x0]
	mov	w1, 1
	lsl	w0, w1, w0
	ldr	w1, [sp, 44]
	cmp	w1, w0
	beq	.L234
	mov	w0, -1
	b	.L235
.L234:
	str	wzr, [sp, 36]
	b	.L236
.L239:
	ldr	x0, [sp, 24]
	ldr	x1, [x0, 24]
	ldr	w0, [sp, 36]
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldr	w1, [sp, 40]
	and	w1, w1, 65535
	strh	w1, [x0]
	ldr	x0, [sp, 24]
	ldr	x1, [x0, 32]
	ldr	w0, [sp, 40]
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldr	w1, [sp, 36]
	and	w1, w1, 65535
	strh	w1, [x0]
	ldr	w0, [sp, 36]
	cmp	w0, 0
	beq	.L237
	ldr	w0, [sp, 40]
	cmp	w0, 1
	bne	.L237
	mov	w0, -1
	b	.L235
.L237:
	ldr	w0, [sp, 40]
	lsl	w0, w0, 1
	str	w0, [sp, 40]
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 44]
	and	w0, w1, w0
	cmp	w0, 0
	beq	.L238
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 20]
	eor	w0, w1, w0
	str	w0, [sp, 40]
.L238:
	ldr	w0, [sp, 36]
	add	w0, w0, 1
	str	w0, [sp, 36]
.L236:
	ldr	x0, [sp, 24]
	ldr	w0, [x0, 4]
	ldr	w1, [sp, 36]
	cmp	w1, w0
	bcc	.L239
	ldr	x0, [sp, 24]
	ldr	x1, [x0, 24]
	ldr	x0, [sp, 24]
	ldr	w0, [x0, 4]
	uxtw	x0, w0
	lsl	x0, x0, 1
	add	x0, x1, x0
	mov	w1, 1
	strh	w1, [x0]
	ldr	x0, [sp, 24]
	ldr	x0, [x0, 32]
	strh	wzr, [x0]
	mov	w0, 0
.L235:
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE39:
	.size	build_gf_tables, .-build_gf_tables
	.align	2
	.type	build_mod8_tables, %function
build_mod8_tables:
.LFB40:
	.cfi_startproc
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	ldr	x0, [sp, 24]
	ldr	w1, [x0]
	ldr	x0, [sp, 24]
	ldr	w0, [x0, 8]
	mul	w0, w1, w0
	add	w0, w0, 31
	lsr	w0, w0, 5
	str	w0, [sp, 48]
	ldr	x0, [sp, 24]
	ldr	w0, [x0, 12]
	add	w0, w0, 32
	lsr	w0, w0, 5
	str	w0, [sp, 52]
	ldr	x0, [sp, 24]
	ldr	w0, [x0, 12]
	add	w0, w0, 31
	lsr	w0, w0, 5
	str	w0, [sp, 56]
	ldr	x0, [sp, 24]
	ldr	x3, [x0, 40]
	ldr	w0, [sp, 48]
	lsl	w0, w0, 10
	sxtw	x0, w0
	lsl	x0, x0, 2
	mov	x2, x0
	mov	w1, 0
	mov	x0, x3
	bl	memset
	str	wzr, [sp, 32]
	b	.L241
.L252:
	str	wzr, [sp, 40]
	b	.L242
.L251:
	ldr	x0, [sp, 24]
	ldr	x1, [x0, 40]
	ldr	w0, [sp, 40]
	lsl	w2, w0, 8
	ldr	w0, [sp, 32]
	add	w2, w2, w0
	ldr	w0, [sp, 48]
	mul	w0, w2, w0
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x1, x0
	str	x0, [sp, 72]
	ldr	w0, [sp, 40]
	lsl	w0, w0, 3
	ldr	w1, [sp, 32]
	lsl	w0, w1, w0
	str	w0, [sp, 44]
	b	.L243
.L250:
	ldr	w0, [sp, 44]
	bl	deg
	str	w0, [sp, 60]
	ldr	x0, [sp, 16]
	ldr	w1, [x0]
	mov	w2, 31
	ldr	w0, [sp, 60]
	sub	w0, w2, w0
	lsr	w0, w1, w0
	ldr	w1, [sp, 44]
	eor	w0, w1, w0
	str	w0, [sp, 44]
	str	wzr, [sp, 36]
	b	.L244
.L249:
	ldr	w0, [sp, 60]
	cmp	w0, 30
	bgt	.L245
	ldrsw	x0, [sp, 36]
	lsl	x0, x0, 2
	ldr	x1, [sp, 16]
	add	x0, x1, x0
	ldr	w1, [x0]
	ldr	w0, [sp, 60]
	add	w0, w0, 1
	lsl	w0, w1, w0
	b	.L246
.L245:
	mov	w0, 0
.L246:
	str	w0, [sp, 64]
	ldr	w0, [sp, 36]
	add	w0, w0, 1
	ldr	w1, [sp, 52]
	cmp	w1, w0
	ble	.L247
	ldrsw	x0, [sp, 36]
	add	x0, x0, 1
	lsl	x0, x0, 2
	ldr	x1, [sp, 16]
	add	x0, x1, x0
	ldr	w1, [x0]
	mov	w2, 31
	ldr	w0, [sp, 60]
	sub	w0, w2, w0
	lsr	w0, w1, w0
	b	.L248
.L247:
	mov	w0, 0
.L248:
	str	w0, [sp, 68]
	ldrsw	x0, [sp, 36]
	lsl	x0, x0, 2
	ldr	x1, [sp, 72]
	add	x0, x1, x0
	ldr	w2, [x0]
	ldr	w1, [sp, 64]
	ldr	w0, [sp, 68]
	orr	w1, w1, w0
	ldrsw	x0, [sp, 36]
	lsl	x0, x0, 2
	ldr	x3, [sp, 72]
	add	x0, x3, x0
	eor	w1, w2, w1
	str	w1, [x0]
	ldr	w0, [sp, 36]
	add	w0, w0, 1
	str	w0, [sp, 36]
.L244:
	ldr	w1, [sp, 36]
	ldr	w0, [sp, 56]
	cmp	w1, w0
	blt	.L249
.L243:
	ldr	w0, [sp, 44]
	cmp	w0, 0
	bne	.L250
	ldr	w0, [sp, 40]
	add	w0, w0, 1
	str	w0, [sp, 40]
.L242:
	ldr	w0, [sp, 40]
	cmp	w0, 3
	ble	.L251
	ldr	w0, [sp, 32]
	add	w0, w0, 1
	str	w0, [sp, 32]
.L241:
	ldr	w0, [sp, 32]
	cmp	w0, 255
	ble	.L252
	nop
	nop
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE40:
	.size	build_mod8_tables, .-build_mod8_tables
	.align	2
	.type	build_deg2_base, %function
build_deg2_base:
.LFB41:
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
	str	x0, [x29, -72]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [x29, -8]
	mov	x1, 0
	mov	x0, sp
	mov	x19, x0
	ldr	x0, [x29, -72]
	ldr	w0, [x0]
	str	w0, [x29, -32]
	str	wzr, [x29, -36]
	ldrsw	x0, [x29, -32]
	sub	x0, x0, #1
	str	x0, [x29, -24]
	ldrsw	x0, [x29, -32]
	mov	x8, x0
	mov	x9, 0
	lsr	x0, x8, 59
	lsl	x5, x9, 5
	orr	x5, x0, x5
	lsl	x4, x8, 5
	ldrsw	x0, [x29, -32]
	mov	x6, x0
	mov	x7, 0
	lsr	x0, x6, 59
	lsl	x3, x7, 5
	orr	x3, x0, x3
	lsl	x2, x6, 5
	ldrsw	x0, [x29, -32]
	lsl	x0, x0, 2
	add	x0, x0, 15
	lsr	x0, x0, 4
	lsl	x0, x0, 4
	and	x1, x0, -65536
	sub	x1, sp, x1
.L254:
	cmp	sp, x1
	beq	.L255
	sub	sp, sp, #65536
	str	xzr, [sp, 1024]
	b	.L254
.L255:
	and	x1, x0, 65535
	sub	sp, sp, x1
	str	xzr, [sp]
	and	x0, x0, 65535
	cmp	x0, 1024
	bcc	.L256
	str	xzr, [sp, 1024]
.L256:
	add	x0, sp, 16
	add	x0, x0, 3
	lsr	x0, x0, 2
	lsl	x0, x0, 2
	str	x0, [x29, -16]
	str	wzr, [x29, -60]
	b	.L257
.L262:
	str	wzr, [x29, -56]
	str	wzr, [x29, -52]
	b	.L258
.L259:
	ldr	w0, [x29, -56]
	ldr	w1, [x29, -60]
	lsl	w0, w1, w0
	mov	w1, w0
	ldr	x0, [x29, -72]
	bl	a_pow
	mov	w1, w0
	ldr	w0, [x29, -52]
	eor	w0, w0, w1
	str	w0, [x29, -52]
	ldr	w0, [x29, -56]
	add	w0, w0, 1
	str	w0, [x29, -56]
.L258:
	ldr	w1, [x29, -56]
	ldr	w0, [x29, -32]
	cmp	w1, w0
	blt	.L259
	ldr	w0, [x29, -52]
	cmp	w0, 0
	beq	.L260
	ldr	x0, [x29, -72]
	ldr	x1, [x0, 24]
	ldrsw	x0, [x29, -60]
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w0, [x0]
	str	w0, [x29, -36]
	b	.L261
.L260:
	ldr	w0, [x29, -60]
	add	w0, w0, 1
	str	w0, [x29, -60]
.L257:
	ldr	w1, [x29, -60]
	ldr	w0, [x29, -32]
	cmp	w1, w0
	blt	.L262
.L261:
	ldr	w0, [x29, -32]
	str	w0, [x29, -40]
	ldrsw	x0, [x29, -32]
	lsl	x0, x0, 2
	mov	x2, x0
	mov	w1, 0
	ldr	x0, [x29, -16]
	bl	memset
	str	wzr, [x29, -48]
	b	.L263
.L269:
	ldr	w1, [x29, -48]
	ldr	x0, [x29, -72]
	bl	gf_sqr
	mov	w1, w0
	ldr	w0, [x29, -48]
	eor	w0, w0, w1
	str	w0, [x29, -44]
	str	wzr, [x29, -60]
	b	.L264
.L267:
	ldr	w1, [x29, -44]
	ldr	x0, [x29, -72]
	bl	a_log
	str	w0, [x29, -28]
	ldr	w0, [x29, -44]
	cmp	w0, 0
	beq	.L265
	ldr	w1, [x29, -28]
	ldr	w0, [x29, -32]
	cmp	w1, w0
	bge	.L265
	ldr	x0, [x29, -16]
	ldrsw	x1, [x29, -28]
	ldr	w0, [x0, x1, lsl 2]
	cmp	w0, 0
	bne	.L265
	ldr	x0, [x29, -72]
	ldr	x1, [x0, 64]
	ldrsw	x0, [x29, -28]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w1, [x29, -48]
	str	w1, [x0]
	ldr	x0, [x29, -16]
	ldrsw	x1, [x29, -28]
	mov	w2, 1
	str	w2, [x0, x1, lsl 2]
	ldr	w0, [x29, -40]
	sub	w0, w0, #1
	str	w0, [x29, -40]
	b	.L266
.L265:
	ldr	w1, [x29, -44]
	ldr	w0, [x29, -36]
	eor	w0, w1, w0
	str	w0, [x29, -44]
	ldr	w0, [x29, -60]
	add	w0, w0, 1
	str	w0, [x29, -60]
.L264:
	ldr	w0, [x29, -60]
	cmp	w0, 1
	ble	.L267
.L266:
	ldr	w0, [x29, -48]
	add	w0, w0, 1
	str	w0, [x29, -48]
.L263:
	ldr	x0, [x29, -72]
	ldr	w0, [x0, 4]
	ldr	w1, [x29, -48]
	cmp	w1, w0
	bhi	.L268
	ldr	w0, [x29, -40]
	cmp	w0, 0
	bne	.L269
.L268:
	ldr	w0, [x29, -40]
	cmp	w0, 0
	beq	.L270
	mov	w0, -1
	b	.L274
.L270:
	mov	w0, 0
.L274:
	mov	sp, x19
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [x29, -8]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L273
	bl	__stack_chk_fail
.L273:
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
.LFE41:
	.size	build_deg2_base, .-build_deg2_base
	.align	2
	.type	bch_alloc, %function
bch_alloc:
.LFB42:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	ldr	x0, [sp, 24]
	bl	malloc
	str	x0, [sp, 40]
	ldr	x0, [sp, 40]
	cmp	x0, 0
	bne	.L276
	ldr	x0, [sp, 16]
	mov	w1, 1
	str	w1, [x0]
.L276:
	ldr	x0, [sp, 40]
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE42:
	.size	bch_alloc, .-bch_alloc
	.align	2
	.type	compute_generator_polynomial, %function
compute_generator_polynomial:
.LFB43:
	.cfi_startproc
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
	stp	x29, x30, [sp, 96]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 96
	str	x0, [sp, 8]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 88]
	mov	x1, 0
	ldr	x0, [sp, 8]
	ldr	w0, [x0]
	str	w0, [sp, 52]
	ldr	x0, [sp, 8]
	ldr	w0, [x0, 8]
	str	w0, [sp, 56]
	str	wzr, [sp, 28]
	ldr	w1, [sp, 52]
	ldr	w0, [sp, 56]
	mul	w0, w1, w0
	add	w0, w0, 1
	uxtw	x0, w0
	add	x0, x0, 1
	lsl	x0, x0, 2
	add	x1, sp, 28
	bl	bch_alloc
	str	x0, [sp, 72]
	ldr	x0, [sp, 8]
	ldr	w0, [x0, 4]
	add	w0, w0, 1
	uxtw	x0, w0
	lsl	x0, x0, 2
	add	x1, sp, 28
	bl	bch_alloc
	str	x0, [sp, 80]
	ldr	w1, [sp, 52]
	ldr	w0, [sp, 56]
	mul	w0, w1, w0
	add	w0, w0, 32
	lsr	w0, w0, 5
	uxtw	x0, w0
	lsl	x0, x0, 2
	add	x1, sp, 28
	bl	bch_alloc
	str	x0, [sp, 64]
	ldr	w0, [sp, 28]
	cmp	w0, 0
	beq	.L279
	ldr	x0, [sp, 64]
	bl	free
	str	xzr, [sp, 64]
	b	.L280
.L279:
	ldr	x0, [sp, 8]
	ldr	w0, [x0, 4]
	add	w0, w0, 1
	uxtw	x0, w0
	lsl	x0, x0, 2
	mov	x2, x0
	mov	w1, 0
	ldr	x0, [sp, 80]
	bl	memset
	str	wzr, [sp, 36]
	b	.L281
.L284:
	str	wzr, [sp, 40]
	ldr	w0, [sp, 36]
	lsl	w0, w0, 1
	add	w0, w0, 1
	str	w0, [sp, 44]
	b	.L282
.L283:
	ldr	w0, [sp, 44]
	lsl	x0, x0, 2
	ldr	x1, [sp, 80]
	add	x0, x1, x0
	mov	w1, 1
	str	w1, [x0]
	ldr	w0, [sp, 44]
	lsl	w0, w0, 1
	mov	w1, w0
	ldr	x0, [sp, 8]
	bl	mod_s
	str	w0, [sp, 44]
	ldr	w0, [sp, 40]
	add	w0, w0, 1
	str	w0, [sp, 40]
.L282:
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 52]
	cmp	w1, w0
	bcc	.L283
	ldr	w0, [sp, 36]
	add	w0, w0, 1
	str	w0, [sp, 36]
.L281:
	ldr	w1, [sp, 36]
	ldr	w0, [sp, 56]
	cmp	w1, w0
	bcc	.L284
	ldr	x0, [sp, 72]
	str	wzr, [x0]
	ldr	x0, [sp, 72]
	mov	w1, 1
	str	w1, [x0, 4]
	str	wzr, [sp, 36]
	b	.L285
.L289:
	ldr	w0, [sp, 36]
	lsl	x0, x0, 2
	ldr	x1, [sp, 80]
	add	x0, x1, x0
	ldr	w0, [x0]
	cmp	w0, 0
	beq	.L286
	ldr	x0, [sp, 8]
	ldr	x1, [x0, 24]
	ldr	w0, [sp, 36]
	lsl	x0, x0, 1
	add	x0, x1, x0
	ldrh	w0, [x0]
	str	w0, [sp, 44]
	ldr	x0, [sp, 72]
	ldr	w0, [x0]
	add	w0, w0, 1
	ldr	x1, [sp, 72]
	uxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x1, x0
	mov	w1, 1
	str	w1, [x0, 4]
	ldr	x0, [sp, 72]
	ldr	w0, [x0]
	str	w0, [sp, 40]
	b	.L287
.L288:
	ldr	x1, [sp, 72]
	ldr	w0, [sp, 40]
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	ldr	w2, [sp, 44]
	mov	w1, w0
	ldr	x0, [sp, 8]
	bl	gf_mul
	mov	w2, w0
	ldr	w0, [sp, 40]
	sub	w0, w0, #1
	ldr	x1, [sp, 72]
	uxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	eor	w1, w2, w0
	ldr	x2, [sp, 72]
	ldr	w0, [sp, 40]
	lsl	x0, x0, 2
	add	x0, x2, x0
	str	w1, [x0, 4]
	ldr	w0, [sp, 40]
	sub	w0, w0, #1
	str	w0, [sp, 40]
.L287:
	ldr	w0, [sp, 40]
	cmp	w0, 0
	bne	.L288
	ldr	x0, [sp, 72]
	ldr	w0, [x0, 4]
	ldr	w2, [sp, 44]
	mov	w1, w0
	ldr	x0, [sp, 8]
	bl	gf_mul
	mov	w1, w0
	ldr	x0, [sp, 72]
	str	w1, [x0, 4]
	ldr	x0, [sp, 72]
	ldr	w0, [x0]
	add	w1, w0, 1
	ldr	x0, [sp, 72]
	str	w1, [x0]
.L286:
	ldr	w0, [sp, 36]
	add	w0, w0, 1
	str	w0, [sp, 36]
.L285:
	ldr	x0, [sp, 8]
	ldr	w0, [x0, 4]
	ldr	w1, [sp, 36]
	cmp	w1, w0
	bcc	.L289
	ldr	x0, [sp, 72]
	ldr	w0, [x0]
	add	w0, w0, 1
	str	w0, [sp, 32]
	str	wzr, [sp, 36]
	b	.L290
.L294:
	ldr	w2, [sp, 32]
	ldr	w1, [sp, 32]
	mov	w0, 32
	cmp	w2, 32
	csel	w0, w1, w0, le
	str	w0, [sp, 60]
	str	wzr, [sp, 40]
	str	wzr, [sp, 48]
	b	.L291
.L293:
	ldr	w1, [sp, 32]
	ldr	w0, [sp, 40]
	sub	w0, w1, w0
	sub	w0, w0, #1
	ldr	x1, [sp, 72]
	uxtw	x0, w0
	lsl	x0, x0, 2
	add	x0, x1, x0
	ldr	w0, [x0, 4]
	cmp	w0, 0
	beq	.L292
	ldr	w0, [sp, 40]
	mov	w1, -2147483648
	lsr	w0, w1, w0
	ldr	w1, [sp, 48]
	orr	w0, w1, w0
	str	w0, [sp, 48]
.L292:
	ldr	w0, [sp, 40]
	add	w0, w0, 1
	str	w0, [sp, 40]
.L291:
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 60]
	cmp	w1, w0
	bcc	.L293
	ldr	w0, [sp, 36]
	add	w1, w0, 1
	str	w1, [sp, 36]
	uxtw	x0, w0
	lsl	x0, x0, 2
	ldr	x1, [sp, 64]
	add	x0, x1, x0
	ldr	w1, [sp, 48]
	str	w1, [x0]
	ldr	w1, [sp, 32]
	ldr	w0, [sp, 60]
	sub	w0, w1, w0
	str	w0, [sp, 32]
.L290:
	ldr	w0, [sp, 32]
	cmp	w0, 0
	bgt	.L294
	ldr	x0, [sp, 72]
	ldr	w1, [x0]
	ldr	x0, [sp, 8]
	str	w1, [x0, 12]
.L280:
	ldr	x0, [sp, 72]
	bl	free
	ldr	x0, [sp, 80]
	bl	free
	ldr	x0, [sp, 64]
	mov	x1, x0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 88]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L296
	bl	__stack_chk_fail
.L296:
	mov	x0, x1
	ldp	x29, x30, [sp, 96]
	add	sp, sp, 112
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE43:
	.size	compute_generator_polynomial, .-compute_generator_polynomial
	.align	2
	.global	init_bch
	.type	init_bch, %function
init_bch:
.LFB44:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, 64]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 64
	str	w0, [sp, 12]
	str	w1, [sp, 8]
	str	w2, [sp, 4]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 56]
	mov	x1, 0
	str	wzr, [sp, 20]
	str	xzr, [sp, 40]
	mov	w0, 5
	str	w0, [sp, 28]
	mov	w0, 15
	str	w0, [sp, 32]
	ldr	w1, [sp, 12]
	ldr	w0, [sp, 28]
	cmp	w1, w0
	blt	.L314
	ldr	w1, [sp, 12]
	ldr	w0, [sp, 32]
	cmp	w1, w0
	bgt	.L314
	ldr	w0, [sp, 8]
	cmp	w0, 0
	ble	.L315
	ldr	w1, [sp, 12]
	ldr	w0, [sp, 8]
	mul	w1, w1, w0
	ldr	w0, [sp, 12]
	mov	w2, 1
	lsl	w0, w2, w0
	sub	w0, w0, #1
	cmp	w1, w0
	bge	.L315
	ldr	w0, [sp, 4]
	cmp	w0, 0
	bne	.L303
	ldr	w1, [sp, 12]
	ldr	w0, [sp, 28]
	sub	w1, w1, w0
	adrp	x0, prim_poly_tab.0
	add	x0, x0, :lo12:prim_poly_tab.0
	sxtw	x1, w1
	ldr	w0, [x0, x1, lsl 2]
	str	w0, [sp, 4]
.L303:
	mov	x0, 128
	bl	malloc
	mov	x2, 128
	mov	w1, 0
	bl	memset
	str	x0, [sp, 40]
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L316
	ldr	w1, [sp, 12]
	ldr	x0, [sp, 40]
	str	w1, [x0]
	ldr	w1, [sp, 8]
	ldr	x0, [sp, 40]
	str	w1, [x0, 8]
	ldr	w0, [sp, 12]
	mov	w1, 1
	lsl	w0, w1, w0
	sub	w0, w0, #1
	mov	w1, w0
	ldr	x0, [sp, 40]
	str	w1, [x0, 4]
	ldr	w1, [sp, 12]
	ldr	w0, [sp, 8]
	mul	w0, w1, w0
	add	w0, w0, 31
	add	w1, w0, 31
	cmp	w0, 0
	csel	w0, w1, w0, lt
	asr	w0, w0, 5
	str	w0, [sp, 36]
	ldr	w1, [sp, 12]
	ldr	w0, [sp, 8]
	mul	w0, w1, w0
	add	w0, w0, 7
	add	w1, w0, 7
	cmp	w0, 0
	csel	w0, w1, w0, lt
	asr	w0, w0, 3
	mov	w1, w0
	ldr	x0, [sp, 40]
	str	w1, [x0, 16]
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 4]
	add	w0, w0, 1
	uxtw	x0, w0
	lsl	x0, x0, 1
	add	x1, sp, 20
	bl	bch_alloc
	mov	x1, x0
	ldr	x0, [sp, 40]
	str	x1, [x0, 24]
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 4]
	add	w0, w0, 1
	uxtw	x0, w0
	lsl	x0, x0, 1
	add	x1, sp, 20
	bl	bch_alloc
	mov	x1, x0
	ldr	x0, [sp, 40]
	str	x1, [x0, 32]
	ldr	w0, [sp, 36]
	lsl	w0, w0, 10
	uxtw	x0, w0
	lsl	x0, x0, 2
	add	x1, sp, 20
	bl	bch_alloc
	mov	x1, x0
	ldr	x0, [sp, 40]
	str	x1, [x0, 40]
	ldr	w0, [sp, 36]
	lsl	x0, x0, 2
	add	x1, sp, 20
	bl	bch_alloc
	mov	x1, x0
	ldr	x0, [sp, 40]
	str	x1, [x0, 48]
	ldr	w0, [sp, 36]
	lsl	x0, x0, 2
	add	x1, sp, 20
	bl	bch_alloc
	mov	x1, x0
	ldr	x0, [sp, 40]
	str	x1, [x0, 56]
	ldrsw	x0, [sp, 12]
	lsl	x0, x0, 2
	add	x1, sp, 20
	bl	bch_alloc
	mov	x1, x0
	ldr	x0, [sp, 40]
	str	x1, [x0, 64]
	ldr	w0, [sp, 8]
	lsl	w0, w0, 1
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x1, sp, 20
	bl	bch_alloc
	mov	x1, x0
	ldr	x0, [sp, 40]
	str	x1, [x0, 72]
	ldr	w0, [sp, 8]
	lsl	w0, w0, 1
	sxtw	x0, w0
	lsl	x0, x0, 2
	add	x1, sp, 20
	bl	bch_alloc
	mov	x1, x0
	ldr	x0, [sp, 40]
	str	x1, [x0, 80]
	ldr	w0, [sp, 8]
	add	w0, w0, 1
	sxtw	x1, w0
	mov	x0, x1
	lsl	x0, x0, 1
	add	x0, x0, x1
	lsl	x0, x0, 2
	mov	x2, x0
	add	x0, sp, 20
	mov	x1, x0
	mov	x0, x2
	bl	bch_alloc
	mov	x1, x0
	ldr	x0, [sp, 40]
	str	x1, [x0, 88]
	str	wzr, [sp, 24]
	b	.L305
.L306:
	ldr	w0, [sp, 8]
	lsl	w0, w0, 1
	add	w0, w0, 1
	sxtw	x0, w0
	add	x0, x0, 1
	lsl	x0, x0, 2
	add	x1, sp, 20
	bl	bch_alloc
	mov	x2, x0
	ldr	x0, [sp, 40]
	ldr	w1, [sp, 24]
	add	x1, x1, 12
	str	x2, [x0, x1, lsl 3]
	ldr	w0, [sp, 24]
	add	w0, w0, 1
	str	w0, [sp, 24]
.L305:
	ldr	w0, [sp, 24]
	cmp	w0, 3
	bls	.L306
	ldr	w0, [sp, 20]
	cmp	w0, 0
	bne	.L317
	ldr	w1, [sp, 4]
	ldr	x0, [sp, 40]
	bl	build_gf_tables
	str	w0, [sp, 20]
	ldr	w0, [sp, 20]
	cmp	w0, 0
	bne	.L318
	ldr	x0, [sp, 40]
	bl	compute_generator_polynomial
	str	x0, [sp, 48]
	ldr	x0, [sp, 48]
	cmp	x0, 0
	beq	.L319
	ldr	x1, [sp, 48]
	ldr	x0, [sp, 40]
	bl	build_mod8_tables
	ldr	x0, [sp, 48]
	bl	free
	ldr	x0, [sp, 40]
	bl	build_deg2_base
	str	w0, [sp, 20]
	ldr	w0, [sp, 20]
	cmp	w0, 0
	bne	.L320
	ldr	x0, [sp, 40]
	b	.L312
.L314:
	nop
	b	.L300
.L315:
	nop
	b	.L300
.L316:
	nop
	b	.L300
.L317:
	nop
	b	.L300
.L318:
	nop
	b	.L300
.L319:
	nop
	b	.L300
.L320:
	nop
.L300:
	ldr	x0, [sp, 40]
	bl	free_bch
	mov	x0, 0
.L312:
	mov	x1, x0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 56]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L313
	bl	__stack_chk_fail
.L313:
	mov	x0, x1
	ldp	x29, x30, [sp, 64]
	add	sp, sp, 80
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE44:
	.size	init_bch, .-init_bch
	.align	2
	.global	free_bch
	.type	free_bch, %function
free_bch:
.LFB45:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x0, [sp, 24]
	ldr	x0, [sp, 24]
	cmp	x0, 0
	beq	.L325
	ldr	x0, [sp, 24]
	ldr	x0, [x0, 24]
	bl	free
	ldr	x0, [sp, 24]
	ldr	x0, [x0, 32]
	bl	free
	ldr	x0, [sp, 24]
	ldr	x0, [x0, 40]
	bl	free
	ldr	x0, [sp, 24]
	ldr	x0, [x0, 48]
	bl	free
	ldr	x0, [sp, 24]
	ldr	x0, [x0, 56]
	bl	free
	ldr	x0, [sp, 24]
	ldr	x0, [x0, 64]
	bl	free
	ldr	x0, [sp, 24]
	ldr	x0, [x0, 72]
	bl	free
	ldr	x0, [sp, 24]
	ldr	x0, [x0, 80]
	bl	free
	ldr	x0, [sp, 24]
	ldr	x0, [x0, 88]
	bl	free
	str	wzr, [sp, 44]
	b	.L323
.L324:
	ldr	x0, [sp, 24]
	ldr	w1, [sp, 44]
	add	x1, x1, 12
	ldr	x0, [x0, x1, lsl 3]
	bl	free
	ldr	w0, [sp, 44]
	add	w0, w0, 1
	str	w0, [sp, 44]
.L323:
	ldr	w0, [sp, 44]
	cmp	w0, 3
	bls	.L324
	ldr	x0, [sp, 24]
	bl	free
.L325:
	nop
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE45:
	.size	free_bch, .-free_bch
	.section	.rodata
	.align	3
	.type	prim_poly_tab.0, %object
	.size	prim_poly_tab.0, 44
prim_poly_tab.0:
	.word	37
	.word	67
	.word	131
	.word	285
	.word	529
	.word	1033
	.word	2053
	.word	4179
	.word	8219
	.word	16427
	.word	32771
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits

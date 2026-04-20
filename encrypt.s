	.arch armv8-a
	.file	"encrypt.c"
	.text
	.align	2
	.global	crypto_encrypt_keypair
	.type	crypto_encrypt_keypair, %function
crypto_encrypt_keypair:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	ldr	x0, [sp, 24]
	cmp	x0, 0
	beq	.L2
	ldr	x0, [sp, 16]
	cmp	x0, 0
	bne	.L3
.L2:
	mov	w0, -1
	b	.L4
.L3:
	ldr	x1, [sp, 16]
	ldr	x0, [sp, 24]
	bl	kg
	mov	w0, 0
.L4:
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	crypto_encrypt_keypair, .-crypto_encrypt_keypair
	.align	2
	.global	crypto_encrypt
	.type	crypto_encrypt, %function
crypto_encrypt:
.LFB1:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	str	x0, [sp, 56]
	str	x1, [sp, 48]
	str	x2, [sp, 40]
	str	x3, [sp, 32]
	str	x4, [sp, 24]
	ldr	x0, [sp, 56]
	cmp	x0, 0
	beq	.L6
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L6
	ldr	x0, [sp, 24]
	cmp	x0, 0
	bne	.L7
.L6:
	mov	w0, -1
	b	.L8
.L7:
	ldr	x0, [sp, 32]
	cmp	x0, 32
	bls	.L9
	mov	w0, -1
	b	.L8
.L9:
	ldr	x4, [sp, 48]
	ldr	x3, [sp, 56]
	ldr	x2, [sp, 32]
	ldr	x1, [sp, 40]
	ldr	x0, [sp, 24]
	bl	pke_enc
	mov	w0, 0
.L8:
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE1:
	.size	crypto_encrypt, .-crypto_encrypt
	.align	2
	.global	crypto_encrypt_open
	.type	crypto_encrypt_open, %function
crypto_encrypt_open:
.LFB2:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	str	x0, [sp, 56]
	str	x1, [sp, 48]
	str	x2, [sp, 40]
	str	x3, [sp, 32]
	str	x4, [sp, 24]
	ldr	x0, [sp, 24]
	cmp	x0, 0
	beq	.L11
	ldr	x0, [sp, 56]
	cmp	x0, 0
	beq	.L11
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L11
	ldr	x0, [sp, 48]
	cmp	x0, 0
	bne	.L12
.L11:
	mov	w0, -1
	b	.L13
.L12:
	ldr	x4, [sp, 48]
	ldr	x3, [sp, 56]
	ldr	x2, [sp, 32]
	ldr	x1, [sp, 40]
	ldr	x0, [sp, 24]
	bl	pke_dec
	mov	w0, 0
.L13:
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE2:
	.size	crypto_encrypt_open, .-crypto_encrypt_open
	.align	2
	.global	kg_seed
	.type	kg_seed, %function
kg_seed:
.LFB3:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #1168
	.cfi_def_cfa_offset 1184
	str	xzr, [sp, 1024]
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	x2, [sp, 8]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 1160]
	mov	x1, 0
	ldr	x0, [sp, 24]
	cmp	x0, 0
	beq	.L15
	ldr	x0, [sp, 16]
	cmp	x0, 0
	bne	.L16
.L15:
	mov	w0, -1
	b	.L18
.L16:
	add	x0, sp, 40
	ldr	x2, [sp, 8]
	mov	w1, 96
	bl	pseudo_random_bytes
	add	x0, sp, 40
	mov	x2, 32
	mov	x1, x0
	ldr	x0, [sp, 24]
	bl	memcpy
	add	x0, sp, 136
	ldr	x1, [sp, 24]
	bl	gen_a
	add	x0, sp, 40
	add	x0, x0, 32
	mov	x2, x0
	mov	w1, 512
	ldr	x0, [sp, 16]
	bl	gen_psi_fix_ham
	add	x0, sp, 40
	add	x0, x0, 64
	add	x3, sp, 648
	mov	x2, x0
	mov	w1, 512
	mov	x0, x3
	bl	gen_psi_fix_ham
	ldr	x0, [sp, 24]
	add	x2, x0, 32
	add	x1, sp, 648
	add	x0, sp, 136
	mov	w4, 512
	mov	x3, x2
	mov	x2, x1
	ldr	x1, [sp, 16]
	bl	poly_aff
	ldr	x0, [sp, 16]
	add	x0, x0, 512
	mov	x2, 544
	ldr	x1, [sp, 24]
	bl	memcpy
	mov	w0, 0
.L18:
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 1160]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L19
	bl	__stack_chk_fail
.L19:
	mov	w0, w1
	add	sp, sp, 1168
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE3:
	.size	kg_seed, .-kg_seed
	.align	2
	.global	kg
	.type	kg, %function
kg:
.LFB4:
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
	add	x0, sp, 24
	mov	w1, 32
	bl	random_bytes
	add	x0, sp, 24
	mov	x2, x0
	ldr	x1, [sp]
	ldr	x0, [sp, 8]
	bl	kg_seed
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 56]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L22
	bl	__stack_chk_fail
.L22:
	mov	w0, w1
	ldp	x29, x30, [sp, 64]
	add	sp, sp, 80
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE4:
	.size	kg, .-kg
	.align	2
	.global	pke_enc
	.type	pke_enc, %function
pke_enc:
.LFB5:
	.cfi_startproc
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
	stp	x29, x30, [sp, 96]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 96
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	str	x2, [sp, 24]
	str	x3, [sp, 16]
	str	x4, [sp, 8]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 88]
	mov	x1, 0
	add	x0, sp, 56
	mov	w1, 32
	bl	random_bytes
	add	x0, sp, 56
	mov	x5, x0
	ldr	x4, [sp, 8]
	ldr	x3, [sp, 16]
	ldr	x2, [sp, 24]
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 40]
	bl	pke_enc_seed
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 88]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L25
	bl	__stack_chk_fail
.L25:
	mov	w0, w1
	ldp	x29, x30, [sp, 96]
	add	sp, sp, 112
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE5:
	.size	pke_enc, .-pke_enc
	.align	2
	.global	pke_dec
	.type	pke_dec, %function
pke_dec:
.LFB6:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #1104
	.cfi_def_cfa_offset 1120
	str	xzr, [sp, 1024]
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	str	x2, [sp, 24]
	str	x3, [sp, 16]
	str	x4, [sp, 8]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 1096]
	mov	x1, 0
	ldr	x0, [sp, 24]
	sub	x0, x0, #512
	lsl	w0, w0, 1
	str	w0, [sp, 64]
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L27
	ldr	x0, [sp, 16]
	cmp	x0, 0
	beq	.L27
	ldr	x0, [sp, 32]
	cmp	x0, 0
	bne	.L28
.L27:
	mov	w0, -1
	b	.L33
.L28:
	mov	w0, 62
	str	w0, [sp, 68]
	mov	w0, 188
	str	w0, [sp, 72]
	ldr	x0, [sp, 32]
	add	x0, x0, 512
	ldr	w2, [sp, 64]
	add	x1, sp, 184
	bl	poly_decompress
	add	x0, sp, 584
	mov	w3, 512
	mov	x2, x0
	ldr	x1, [sp, 40]
	ldr	x0, [sp, 32]
	bl	poly_mul
	ldr	w0, [sp, 64]
	add	w1, w0, 7
	cmp	w0, 0
	csel	w0, w1, w0, lt
	asr	w0, w0, 3
	sub	w0, w0, #18
	sxtw	x1, w0
	ldr	x0, [sp, 8]
	str	x1, [x0]
	add	x0, sp, 120
	mov	x2, 64
	mov	w1, 0
	bl	memset
	ldr	x0, [sp, 8]
	ldr	x0, [x0]
	mov	x1, 32
	sub	x0, x1, x0
	add	x1, sp, 120
	add	x0, x1, x0
	str	x0, [sp, 80]
	str	wzr, [sp, 60]
	b	.L30
.L32:
	ldrsw	x0, [sp, 60]
	add	x1, sp, 184
	ldrb	w0, [x1, x0]
	mov	w2, w0
	ldrsw	x0, [sp, 60]
	add	x1, sp, 584
	ldrb	w0, [x1, x0]
	sub	w0, w2, w0
	add	w0, w0, 251
	mov	w1, 49087
	movk	w1, 0x828c, lsl 16
	smull	x1, w0, w1
	lsr	x1, x1, 32
	add	w1, w0, w1
	asr	w2, w1, 7
	asr	w1, w0, 31
	sub	w2, w2, w1
	mov	w1, 251
	mul	w1, w2, w1
	sub	w0, w0, w1
	str	w0, [sp, 76]
	ldr	w1, [sp, 76]
	ldr	w0, [sp, 68]
	cmp	w1, w0
	blt	.L31
	ldr	w1, [sp, 76]
	ldr	w0, [sp, 72]
	cmp	w1, w0
	bge	.L31
	ldr	w0, [sp, 60]
	add	w1, w0, 7
	cmp	w0, 0
	csel	w0, w1, w0, lt
	asr	w0, w0, 3
	sxtw	x0, w0
	ldr	x1, [sp, 80]
	add	x0, x1, x0
	ldrb	w0, [x0]
	sxtb	w1, w0
	ldr	w0, [sp, 60]
	and	w0, w0, 7
	mov	w2, 1
	lsl	w0, w2, w0
	sxtb	w0, w0
	eor	w0, w1, w0
	sxtb	w2, w0
	ldr	w0, [sp, 60]
	add	w1, w0, 7
	cmp	w0, 0
	csel	w0, w1, w0, lt
	asr	w0, w0, 3
	sxtw	x0, w0
	ldr	x1, [sp, 80]
	add	x0, x1, x0
	and	w1, w2, 255
	strb	w1, [x0]
.L31:
	ldr	w0, [sp, 60]
	add	w0, w0, 1
	str	w0, [sp, 60]
.L30:
	ldr	w1, [sp, 60]
	ldr	w0, [sp, 64]
	cmp	w1, w0
	blt	.L32
	add	x1, sp, 120
	add	x0, sp, 88
	bl	ecc_dec
	ldr	x0, [sp, 8]
	ldr	x0, [x0]
	mov	x1, 32
	sub	x0, x1, x0
	add	x1, sp, 88
	add	x1, x1, x0
	ldr	x0, [sp, 8]
	ldr	x0, [x0]
	mov	x2, x0
	ldr	x0, [sp, 16]
	bl	memcpy
	mov	w0, 0
.L33:
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 1096]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L34
	bl	__stack_chk_fail
.L34:
	mov	w0, w1
	add	sp, sp, 1104
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	pke_dec, .-pke_dec
	.align	2
	.global	pke_enc_seed
	.type	pke_enc_seed, %function
pke_enc_seed:
.LFB7:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #2608
	.cfi_def_cfa_offset 2624
	str	xzr, [sp, 1024]
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	str	x2, [sp, 24]
	str	x3, [sp, 16]
	str	x4, [sp, 8]
	str	x5, [sp]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 2600]
	mov	x1, 0
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L36
	ldr	x0, [sp, 32]
	cmp	x0, 0
	beq	.L36
	ldr	x0, [sp, 16]
	cmp	x0, 0
	bne	.L37
.L36:
	mov	w0, -1
	b	.L42
.L37:
	ldr	x0, [sp, 24]
	cmp	x0, 32
	bls	.L39
	mov	w0, -1
	b	.L42
.L39:
	add	x0, sp, 2088
	ldr	x1, [sp, 40]
	bl	gen_a
	add	x0, sp, 72
	mov	x2, 32
	mov	w1, 0
	bl	memset
	mov	x1, 32
	ldr	x0, [sp, 24]
	sub	x0, x1, x0
	add	x1, sp, 72
	add	x0, x1, x0
	ldr	x2, [sp, 24]
	ldr	x1, [sp, 32]
	bl	memcpy
	add	x1, sp, 104
	add	x0, sp, 72
	bl	ecc_enc
	mov	x1, 32
	ldr	x0, [sp, 24]
	sub	x0, x1, x0
	add	x1, sp, 104
	add	x0, x1, x0
	str	x0, [sp, 64]
	add	x0, sp, 168
	ldr	x2, [sp]
	mov	w1, 96
	bl	pseudo_random_bytes
	add	x1, sp, 168
	add	x0, sp, 1064
	mov	x2, x1
	mov	w1, 512
	bl	gen_psi_fix_ham
	add	x0, sp, 168
	add	x0, x0, 32
	add	x3, sp, 1576
	mov	x2, x0
	mov	w1, 512
	mov	x0, x3
	bl	gen_psi_fix_ham
	add	x2, sp, 1576
	add	x1, sp, 1064
	add	x0, sp, 2088
	mov	w4, 512
	ldr	x3, [sp, 16]
	bl	poly_aff
	ldr	x0, [sp, 24]
	add	x0, x0, 18
	lsl	w0, w0, 3
	str	w0, [sp, 60]
	ldr	w1, [sp, 60]
	add	x0, sp, 168
	add	x0, x0, 64
	add	x3, sp, 264
	mov	x2, x0
	mov	x0, x3
	bl	gen_psi_std
	str	wzr, [sp, 56]
	b	.L40
.L41:
	ldrsw	x0, [sp, 56]
	add	x1, sp, 264
	ldrb	w1, [x1, x0]
	ldr	w0, [sp, 56]
	add	w2, w0, 7
	cmp	w0, 0
	csel	w0, w2, w0, lt
	asr	w0, w0, 3
	sxtw	x0, w0
	ldr	x2, [sp, 64]
	add	x0, x2, x0
	ldrb	w0, [x0]
	mov	w2, w0
	ldr	w0, [sp, 56]
	and	w0, w0, 7
	asr	w0, w2, w0
	and	w0, w0, 255
	and	w0, w0, 1
	and	w2, w0, 255
	mov	w0, 125
	mul	w0, w2, w0
	and	w0, w0, 255
	add	w0, w1, w0
	and	w2, w0, 255
	ldrsw	x0, [sp, 56]
	add	x1, sp, 264
	strb	w2, [x1, x0]
	ldr	w0, [sp, 56]
	add	w0, w0, 1
	str	w0, [sp, 56]
.L40:
	ldr	w1, [sp, 56]
	ldr	w0, [sp, 60]
	cmp	w1, w0
	blt	.L41
	ldr	x0, [sp, 40]
	add	x0, x0, 32
	ldr	w4, [sp, 60]
	add	x3, sp, 664
	add	x2, sp, 264
	add	x1, sp, 1064
	bl	poly_aff
	ldr	x0, [sp, 16]
	add	x1, x0, 512
	ldr	w2, [sp, 60]
	add	x0, sp, 664
	bl	poly_compress
	ldr	w0, [sp, 60]
	lsr	w1, w0, 31
	add	w0, w1, w0
	asr	w0, w0, 1
	add	w0, w0, 512
	sxtw	x1, w0
	ldr	x0, [sp, 8]
	str	x1, [x0]
	mov	w0, 0
.L42:
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 2600]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L43
	bl	__stack_chk_fail
.L43:
	mov	w0, w1
	add	sp, sp, 2608
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE7:
	.size	pke_enc_seed, .-pke_enc_seed
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits

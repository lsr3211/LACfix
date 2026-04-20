	.arch armv8-a
	.file	"kem.c"
	.text
	.align	2
	.global	crypto_kem_keypair
	.type	crypto_kem_keypair, %function
crypto_kem_keypair:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	ldr	x1, [sp, 16]
	ldr	x0, [sp, 24]
	bl	crypto_encrypt_keypair
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	crypto_kem_keypair, .-crypto_kem_keypair
	.align	2
	.global	crypto_kem_enc
	.type	crypto_kem_enc, %function
crypto_kem_enc:
.LFB1:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	str	x2, [sp, 24]
	ldr	x2, [sp, 40]
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 24]
	bl	kem_enc_fo
	mov	w0, 0
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE1:
	.size	crypto_kem_enc, .-crypto_kem_enc
	.align	2
	.global	crypto_kem_dec
	.type	crypto_kem_dec, %function
crypto_kem_dec:
.LFB2:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	str	x0, [sp, 40]
	str	x1, [sp, 32]
	str	x2, [sp, 24]
	ldr	x0, [sp, 24]
	add	x0, x0, 512
	str	x0, [sp, 56]
	ldr	x3, [sp, 40]
	ldr	x2, [sp, 32]
	ldr	x1, [sp, 24]
	ldr	x0, [sp, 56]
	bl	kem_dec_fo
	mov	w0, 0
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE2:
	.size	crypto_kem_dec, .-crypto_kem_dec
	.align	2
	.global	kem_enc_fo
	.type	kem_enc_fo, %function
kem_enc_fo:
.LFB3:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #832
	.cfi_def_cfa_offset 848
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	x2, [sp, 8]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 824]
	mov	x1, 0
	ldr	x0, [sp, 24]
	cmp	x0, 0
	beq	.L8
	ldr	x0, [sp, 16]
	cmp	x0, 0
	beq	.L8
	ldr	x0, [sp, 8]
	cmp	x0, 0
	bne	.L9
.L8:
	mov	w0, -1
	b	.L11
.L9:
	add	x0, sp, 80
	mov	w1, 32
	bl	random_bytes
	add	x1, sp, 48
	add	x0, sp, 80
	mov	x2, x1
	mov	w1, 32
	bl	gen_seed
	add	x2, sp, 48
	add	x1, sp, 40
	add	x0, sp, 80
	mov	x5, x2
	mov	x4, x1
	ldr	x3, [sp, 8]
	mov	x2, 32
	mov	x1, x0
	ldr	x0, [sp, 24]
	bl	pke_enc_seed
	add	x0, sp, 80
	add	x0, x0, 32
	mov	x2, 712
	ldr	x1, [sp, 8]
	bl	memcpy
	add	x0, sp, 80
	ldr	x2, [sp, 16]
	mov	w1, 744
	bl	hash
	mov	w0, 0
.L11:
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 824]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L12
	bl	__stack_chk_fail
.L12:
	mov	w0, w1
	add	sp, sp, 832
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE3:
	.size	kem_enc_fo, .-kem_enc_fo
	.align	2
	.global	kem_enc_fo_seed
	.type	kem_enc_fo_seed, %function
kem_enc_fo_seed:
.LFB4:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #832
	.cfi_def_cfa_offset 848
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	x2, [sp, 8]
	str	x3, [sp]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 824]
	mov	x1, 0
	ldr	x0, [sp, 24]
	cmp	x0, 0
	beq	.L14
	ldr	x0, [sp, 16]
	cmp	x0, 0
	beq	.L14
	ldr	x0, [sp, 8]
	cmp	x0, 0
	bne	.L15
.L14:
	mov	w0, -1
	b	.L17
.L15:
	add	x0, sp, 80
	ldr	x2, [sp]
	mov	w1, 32
	bl	pseudo_random_bytes
	add	x1, sp, 48
	add	x0, sp, 80
	mov	x2, x1
	mov	w1, 32
	bl	gen_seed
	add	x2, sp, 48
	add	x1, sp, 40
	add	x0, sp, 80
	mov	x5, x2
	mov	x4, x1
	ldr	x3, [sp, 8]
	mov	x2, 32
	mov	x1, x0
	ldr	x0, [sp, 24]
	bl	pke_enc_seed
	add	x0, sp, 80
	add	x0, x0, 32
	mov	x2, 712
	ldr	x1, [sp, 8]
	bl	memcpy
	add	x0, sp, 80
	ldr	x2, [sp, 16]
	mov	w1, 744
	bl	hash
	mov	w0, 0
.L17:
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 824]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L18
	bl	__stack_chk_fail
.L18:
	mov	w0, w1
	add	sp, sp, 832
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE4:
	.size	kem_enc_fo_seed, .-kem_enc_fo_seed
	.align	2
	.global	kem_dec_fo
	.type	kem_dec_fo, %function
kem_dec_fo:
.LFB5:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #1552
	.cfi_def_cfa_offset 1568
	str	xzr, [sp, 1024]
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	x2, [sp, 8]
	str	x3, [sp]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 1544]
	mov	x1, 0
	ldr	x0, [sp, 24]
	cmp	x0, 0
	beq	.L20
	ldr	x0, [sp, 16]
	cmp	x0, 0
	beq	.L20
	ldr	x0, [sp]
	cmp	x0, 0
	beq	.L20
	ldr	x0, [sp, 8]
	cmp	x0, 0
	bne	.L21
.L20:
	mov	w0, -1
	b	.L24
.L21:
	add	x1, sp, 40
	add	x0, sp, 800
	mov	x4, x1
	mov	x3, x0
	mov	x2, 712
	ldr	x1, [sp, 8]
	ldr	x0, [sp, 16]
	bl	pke_dec
	add	x0, sp, 800
	add	x0, x0, 32
	mov	x2, 712
	ldr	x1, [sp, 8]
	bl	memcpy
	add	x0, sp, 800
	ldr	x2, [sp]
	mov	w1, 744
	bl	hash
	add	x1, sp, 56
	add	x0, sp, 800
	mov	x2, x1
	mov	w1, 32
	bl	gen_seed
	add	x3, sp, 56
	add	x2, sp, 48
	add	x1, sp, 88
	add	x0, sp, 800
	mov	x5, x3
	mov	x4, x2
	mov	x3, x1
	mov	x2, 32
	mov	x1, x0
	ldr	x0, [sp, 24]
	bl	pke_enc_seed
	add	x0, sp, 88
	mov	x2, 712
	mov	x1, x0
	ldr	x0, [sp, 8]
	bl	memcmp
	cmp	w0, 0
	beq	.L23
	add	x0, sp, 800
	mov	x2, x0
	mov	w1, 512
	ldr	x0, [sp, 16]
	bl	hash
	add	x0, sp, 800
	ldr	x2, [sp]
	mov	w1, 744
	bl	hash
.L23:
	mov	w0, 0
.L24:
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 1544]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L25
	bl	__stack_chk_fail
.L25:
	mov	w0, w1
	add	sp, sp, 1552
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE5:
	.size	kem_dec_fo, .-kem_dec_fo
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits

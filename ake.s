	.arch armv8-a
	.file	"ake.c"
	.text
	.align	2
	.global	crypto_ake_alice_send
	.type	crypto_ake_alice_send, %function
crypto_ake_alice_send:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #1184
	.cfi_def_cfa_offset 1200
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
	str	x1, [sp, 1176]
	mov	x1, 0
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L2
	ldr	x0, [sp, 32]
	cmp	x0, 0
	beq	.L2
	ldr	x0, [sp, 24]
	cmp	x0, 0
	beq	.L2
	ldr	x0, [sp]
	cmp	x0, 0
	bne	.L3
.L2:
	mov	w0, -1
	b	.L5
.L3:
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 40]
	bl	kg
	add	x0, sp, 88
	mov	w1, 32
	bl	random_bytes
	add	x0, sp, 88
	add	x0, x0, 32
	mov	x2, 1056
	ldr	x1, [sp, 16]
	bl	memcpy
	add	x1, sp, 56
	add	x0, sp, 88
	mov	x2, x1
	mov	w1, 1088
	bl	gen_seed
	add	x0, sp, 56
	mov	x3, x0
	ldr	x2, [sp, 8]
	ldr	x1, [sp]
	ldr	x0, [sp, 24]
	bl	kem_enc_fo_seed
	mov	w0, 0
.L5:
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 1176]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L6
	bl	__stack_chk_fail
.L6:
	mov	w0, w1
	add	sp, sp, 1184
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	crypto_ake_alice_send, .-crypto_ake_alice_send
	.align	2
	.global	crypto_ake_bob_receive
	.type	crypto_ake_bob_receive, %function
crypto_ake_bob_receive:
.LFB1:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #3744
	.cfi_def_cfa_offset 3760
	str	xzr, [sp, 1024]
	str	x0, [sp, 56]
	str	x1, [sp, 48]
	str	x2, [sp, 40]
	str	x3, [sp, 32]
	str	x4, [sp, 24]
	str	x5, [sp, 16]
	str	x6, [sp, 8]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 3736]
	mov	x1, 0
	ldr	x0, [sp, 56]
	cmp	x0, 0
	beq	.L8
	ldr	x0, [sp, 48]
	cmp	x0, 0
	beq	.L8
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L8
	ldr	x0, [sp, 32]
	cmp	x0, 0
	beq	.L8
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
	add	x0, sp, 208
	mov	w1, 32
	bl	random_bytes
	add	x0, sp, 208
	add	x0, x0, 32
	mov	x2, 1056
	ldr	x1, [sp, 48]
	bl	memcpy
	add	x1, sp, 176
	add	x0, sp, 208
	mov	x2, x1
	mov	w1, 1088
	bl	gen_seed
	add	x1, sp, 176
	add	x0, sp, 112
	mov	x3, x1
	ldr	x2, [sp, 16]
	mov	x1, x0
	ldr	x0, [sp, 40]
	bl	kem_enc_fo_seed
	add	x0, sp, 144
	mov	w1, 32
	bl	random_bytes
	ldr	x0, [sp, 16]
	add	x1, x0, 712
	add	x2, sp, 72
	add	x0, sp, 144
	mov	x4, x2
	mov	x3, x1
	mov	x2, 32
	mov	x1, x0
	ldr	x0, [sp, 32]
	bl	pke_enc
	add	x0, sp, 80
	mov	x3, x0
	ldr	x2, [sp, 24]
	ldr	x1, [sp, 48]
	ldr	x0, [sp, 56]
	bl	kem_dec_fo
	add	x0, sp, 1296
	mov	x2, 544
	ldr	x1, [sp, 40]
	bl	memcpy
	add	x0, sp, 1296
	add	x0, x0, 544
	mov	x2, 544
	ldr	x1, [sp, 56]
	bl	memcpy
	add	x0, sp, 1296
	add	x0, x0, 1088
	mov	x2, 544
	ldr	x1, [sp, 32]
	bl	memcpy
	add	x0, sp, 1296
	add	x0, x0, 1632
	ldr	x1, [sp, 16]
	add	x1, x1, 712
	mov	x2, 712
	bl	memcpy
	add	x0, sp, 1296
	add	x0, x0, 2344
	mov	x1, x0
	add	x0, sp, 80
	ldp	q0, q1, [x0]
	stp	q0, q1, [x1]
	add	x0, sp, 1296
	add	x0, x0, 2376
	mov	x1, x0
	add	x0, sp, 112
	ldp	q0, q1, [x0]
	stp	q0, q1, [x1]
	add	x0, sp, 1296
	add	x0, x0, 2408
	mov	x1, x0
	add	x0, sp, 144
	ldp	q0, q1, [x0]
	stp	q0, q1, [x1]
	add	x0, sp, 1296
	ldr	x2, [sp, 8]
	mov	w1, 2440
	bl	hash
	mov	w0, 0
.L11:
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 3736]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L12
	bl	__stack_chk_fail
.L12:
	mov	w0, w1
	add	sp, sp, 3744
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE1:
	.size	crypto_ake_bob_receive, .-crypto_ake_bob_receive
	.align	2
	.global	crypto_ake_alice_receive
	.type	crypto_ake_alice_receive, %function
crypto_ake_alice_receive:
.LFB2:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #2608
	.cfi_def_cfa_offset 2624
	str	xzr, [sp, 1024]
	str	x0, [sp, 72]
	str	x1, [sp, 64]
	str	x2, [sp, 56]
	str	x3, [sp, 48]
	str	x4, [sp, 40]
	str	x5, [sp, 32]
	str	x6, [sp, 24]
	str	x7, [sp, 16]
	ldr	x0, [sp, 2624]
	str	x0, [sp, 8]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 2600]
	mov	x1, 0
	ldr	x0, [sp, 72]
	cmp	x0, 0
	beq	.L14
	ldr	x0, [sp, 64]
	cmp	x0, 0
	beq	.L14
	ldr	x0, [sp, 48]
	cmp	x0, 0
	beq	.L14
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L14
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
	add	x0, sp, 96
	mov	x3, x0
	ldr	x2, [sp, 24]
	ldr	x1, [sp, 64]
	ldr	x0, [sp, 72]
	bl	kem_dec_fo
	ldr	x0, [sp, 24]
	add	x0, x0, 712
	add	x2, sp, 88
	add	x1, sp, 128
	mov	x4, x2
	mov	x3, x1
	mov	x2, 712
	mov	x1, x0
	ldr	x0, [sp, 40]
	bl	pke_dec
	add	x0, sp, 160
	mov	x2, 544
	ldr	x1, [sp, 72]
	bl	memcpy
	add	x0, sp, 160
	add	x0, x0, 544
	mov	x2, 544
	ldr	x1, [sp, 56]
	bl	memcpy
	add	x0, sp, 160
	add	x0, x0, 1088
	mov	x2, 544
	ldr	x1, [sp, 48]
	bl	memcpy
	add	x0, sp, 160
	add	x0, x0, 1632
	ldr	x1, [sp, 24]
	add	x1, x1, 712
	mov	x2, 712
	bl	memcpy
	add	x0, sp, 160
	add	x0, x0, 2344
	mov	x2, 32
	ldr	x1, [sp, 16]
	bl	memcpy
	add	x0, sp, 160
	add	x0, x0, 2376
	mov	x1, x0
	add	x0, sp, 96
	ldp	q0, q1, [x0]
	stp	q0, q1, [x1]
	add	x0, sp, 160
	add	x0, x0, 2408
	mov	x1, x0
	add	x0, sp, 128
	ldp	q0, q1, [x0]
	stp	q0, q1, [x1]
	add	x0, sp, 160
	ldr	x2, [sp, 8]
	mov	w1, 2440
	bl	hash
	mov	w0, 0
.L17:
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 2600]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L18
	bl	__stack_chk_fail
.L18:
	mov	w0, w1
	add	sp, sp, 2608
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE2:
	.size	crypto_ake_alice_receive, .-crypto_ake_alice_receive
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits

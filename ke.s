	.arch armv8-a
	.file	"ke.c"
	.text
	.align	2
	.global	crypto_ke_alice_send
	.type	crypto_ke_alice_send, %function
crypto_ke_alice_send:
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
	.size	crypto_ke_alice_send, .-crypto_ke_alice_send
	.align	2
	.global	crypto_ke_bob_receive
	.type	crypto_ke_bob_receive, %function
crypto_ke_bob_receive:
.LFB1:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #656
	.cfi_def_cfa_offset 672
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	x2, [sp, 8]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 648]
	mov	x1, 0
	ldr	x0, [sp, 24]
	cmp	x0, 0
	beq	.L6
	ldr	x0, [sp, 16]
	cmp	x0, 0
	beq	.L6
	ldr	x0, [sp, 8]
	cmp	x0, 0
	bne	.L7
.L6:
	mov	w0, -1
	b	.L9
.L7:
	add	x0, sp, 40
	mov	w1, 32
	bl	random_bytes
	add	x1, sp, 32
	add	x0, sp, 40
	mov	x4, x1
	ldr	x3, [sp, 16]
	mov	x2, 32
	mov	x1, x0
	ldr	x0, [sp, 24]
	bl	pke_enc
	add	x0, sp, 72
	mov	x2, 544
	ldr	x1, [sp, 24]
	bl	memcpy
	add	x0, sp, 72
	add	x0, x0, 512
	mov	x1, x0
	add	x0, sp, 40
	ldp	q0, q1, [x0]
	stp	q0, q1, [x1]
	add	x0, sp, 72
	ldr	x2, [sp, 8]
	mov	w1, 544
	bl	hash
	mov	w0, 0
.L9:
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 648]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L10
	bl	__stack_chk_fail
.L10:
	mov	w0, w1
	add	sp, sp, 656
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE1:
	.size	crypto_ke_bob_receive, .-crypto_ke_bob_receive
	.align	2
	.global	crypto_ke_alice_receive
	.type	crypto_ke_alice_receive, %function
crypto_ke_alice_receive:
.LFB2:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #656
	.cfi_def_cfa_offset 672
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	x2, [sp, 8]
	str	x3, [sp]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 648]
	mov	x1, 0
	ldr	x0, [sp, 24]
	cmp	x0, 0
	beq	.L12
	ldr	x0, [sp, 16]
	cmp	x0, 0
	beq	.L12
	ldr	x0, [sp, 8]
	cmp	x0, 0
	beq	.L12
	ldr	x0, [sp]
	cmp	x0, 0
	bne	.L13
.L12:
	mov	w0, -1
	b	.L15
.L13:
	add	x1, sp, 32
	add	x0, sp, 40
	mov	x4, x1
	mov	x3, x0
	mov	x2, 712
	ldr	x1, [sp, 8]
	ldr	x0, [sp, 16]
	bl	pke_dec
	add	x0, sp, 72
	mov	x2, 544
	ldr	x1, [sp, 24]
	bl	memcpy
	add	x0, sp, 72
	add	x0, x0, 512
	mov	x1, x0
	add	x0, sp, 40
	ldp	q0, q1, [x0]
	stp	q0, q1, [x1]
	add	x0, sp, 72
	ldr	x2, [sp]
	mov	w1, 544
	bl	hash
	mov	w0, 0
.L15:
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 648]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L16
	bl	__stack_chk_fail
.L16:
	mov	w0, w1
	add	sp, sp, 656
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE2:
	.size	crypto_ke_alice_receive, .-crypto_ke_alice_receive
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits

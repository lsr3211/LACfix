	.arch armv8-a
	.file	"rand.c"
	.text
	.align	2
	.global	random_bytes
	.type	random_bytes, %function
random_bytes:
.LFB309:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	ldr	x0, [sp, 24]
	cmp	x0, 0
	bne	.L2
	mov	w0, 1
	b	.L3
.L2:
	ldr	w0, [sp, 20]
	mov	x1, x0
	ldr	x0, [sp, 24]
	bl	randombytes
	mov	w0, 0
.L3:
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE309:
	.size	random_bytes, .-random_bytes
	.align	2
	.global	pseudo_random_bytes
	.type	pseudo_random_bytes, %function
pseudo_random_bytes:
.LFB310:
	.cfi_startproc
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
	stp	x29, x30, [sp, 96]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 96
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	str	x2, [sp, 8]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 88]
	mov	x1, 0
	ldr	w0, [sp, 20]
	lsr	w0, w0, 4
	str	w0, [sp, 44]
	ldr	x0, [sp, 24]
	cmp	x0, 0
	beq	.L5
	ldr	x0, [sp, 8]
	cmp	x0, 0
	bne	.L6
.L5:
	mov	w0, 1
	b	.L11
.L6:
	ldr	w0, [sp, 20]
	mov	x2, x0
	mov	w1, 0
	ldr	x0, [sp, 24]
	bl	memset
	bl	EVP_CIPHER_CTX_new
	str	x0, [sp, 48]
	bl	EVP_aes_256_ctr
	mov	x4, 0
	ldr	x3, [sp, 8]
	mov	x2, 0
	mov	x1, x0
	ldr	x0, [sp, 48]
	bl	EVP_EncryptInit_ex
	add	x0, sp, 56
	mov	x2, 16
	mov	w1, 0
	bl	memset
	str	wzr, [sp, 40]
	b	.L8
.L9:
	ldr	w0, [sp, 40]
	lsl	w0, w0, 4
	sxtw	x0, w0
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	add	x2, sp, 56
	add	x1, sp, 36
	mov	w4, 16
	mov	x3, x2
	mov	x2, x1
	mov	x1, x0
	ldr	x0, [sp, 48]
	bl	EVP_EncryptUpdate
	ldr	w0, [sp, 40]
	add	w0, w0, 1
	str	w0, [sp, 40]
.L8:
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 44]
	cmp	w1, w0
	blt	.L9
	ldr	w0, [sp, 20]
	and	w0, w0, 15
	cmp	w0, 0
	beq	.L10
	add	x2, sp, 56
	add	x1, sp, 36
	add	x0, sp, 72
	mov	w4, 16
	mov	x3, x2
	mov	x2, x1
	mov	x1, x0
	ldr	x0, [sp, 48]
	bl	EVP_EncryptUpdate
.L10:
	ldrsw	x0, [sp, 44]
	sub	x0, x0, #1
	ldr	x1, [sp, 24]
	add	x3, x1, x0
	ldr	w0, [sp, 20]
	and	x1, x0, 15
	add	x0, sp, 72
	mov	x2, x1
	mov	x1, x0
	mov	x0, x3
	bl	memcpy
	ldr	x0, [sp, 48]
	bl	EVP_CIPHER_CTX_free
	mov	w0, 0
.L11:
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 88]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L12
	bl	__stack_chk_fail
.L12:
	mov	w0, w1
	ldp	x29, x30, [sp, 96]
	add	sp, sp, 112
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE310:
	.size	pseudo_random_bytes, .-pseudo_random_bytes
	.align	2
	.global	hash
	.type	hash, %function
hash:
.LFB311:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x0, [sp, 40]
	str	w1, [sp, 36]
	str	x2, [sp, 24]
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L14
	ldr	x0, [sp, 24]
	cmp	x0, 0
	bne	.L15
.L14:
	mov	w0, 1
	b	.L16
.L15:
	ldr	w0, [sp, 36]
	ldr	x2, [sp, 24]
	mov	x1, x0
	ldr	x0, [sp, 40]
	bl	SHA256
	mov	w0, 0
.L16:
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE311:
	.size	hash, .-hash
	.align	2
	.global	gen_seed
	.type	gen_seed, %function
gen_seed:
.LFB312:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x0, [sp, 40]
	str	w1, [sp, 36]
	str	x2, [sp, 24]
	ldr	x0, [sp, 40]
	cmp	x0, 0
	beq	.L18
	ldr	x0, [sp, 24]
	cmp	x0, 0
	bne	.L19
.L18:
	mov	w0, 1
	b	.L20
.L19:
	ldr	w0, [sp, 36]
	ldr	x2, [sp, 24]
	mov	x1, x0
	ldr	x0, [sp, 40]
	bl	SHA256
	mov	w0, 0
.L20:
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE312:
	.size	gen_seed, .-gen_seed
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits

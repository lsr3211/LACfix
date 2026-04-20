	.arch armv8-a
	.file	"rng.c"
	.text
	.global	DRBG_ctx
	.bss
	.align	3
	.type	DRBG_ctx, %object
	.size	DRBG_ctx, 52
DRBG_ctx:
	.zero	52
	.text
	.align	2
	.global	seedexpander_init
	.type	seedexpander_init, %function
seedexpander_init:
.LFB348:
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
	ldr	x1, [sp, 16]
	mov	x0, 4294967295
	cmp	x1, x0
	bls	.L2
	mov	w0, -1
	b	.L3
.L2:
	ldr	x0, [sp, 40]
	ldr	x1, [sp, 16]
	str	x1, [x0, 24]
	ldr	x0, [sp, 40]
	add	x0, x0, 32
	mov	x2, 32
	ldr	x1, [sp, 32]
	bl	memcpy
	ldr	x0, [sp, 40]
	add	x0, x0, 64
	ldr	x1, [sp, 24]
	ldr	x1, [x1]
	str	x1, [x0]
	ldr	x0, [sp, 16]
	and	w1, w0, 255
	ldr	x0, [sp, 40]
	strb	w1, [x0, 75]
	ldr	x0, [sp, 16]
	lsr	x0, x0, 8
	str	x0, [sp, 16]
	ldr	x0, [sp, 16]
	and	w1, w0, 255
	ldr	x0, [sp, 40]
	strb	w1, [x0, 74]
	ldr	x0, [sp, 16]
	lsr	x0, x0, 8
	str	x0, [sp, 16]
	ldr	x0, [sp, 16]
	and	w1, w0, 255
	ldr	x0, [sp, 40]
	strb	w1, [x0, 73]
	ldr	x0, [sp, 16]
	lsr	x0, x0, 8
	str	x0, [sp, 16]
	ldr	x0, [sp, 16]
	and	w1, w0, 255
	ldr	x0, [sp, 40]
	strb	w1, [x0, 72]
	ldr	x0, [sp, 40]
	add	x0, x0, 64
	add	x0, x0, 12
	mov	x2, 4
	mov	w1, 0
	bl	memset
	ldr	x0, [sp, 40]
	mov	w1, 16
	str	w1, [x0, 16]
	ldr	x0, [sp, 40]
	mov	x2, 16
	mov	w1, 0
	bl	memset
	mov	w0, 0
.L3:
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE348:
	.size	seedexpander_init, .-seedexpander_init
	.align	2
	.global	seedexpander
	.type	seedexpander, %function
seedexpander:
.LFB349:
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
	cmp	x0, 0
	bne	.L5
	mov	w0, -2
	b	.L6
.L5:
	ldr	x0, [sp, 40]
	ldr	x0, [x0, 24]
	ldr	x1, [sp, 24]
	cmp	x1, x0
	bcc	.L7
	mov	w0, -3
	b	.L6
.L7:
	ldr	x0, [sp, 40]
	ldr	x1, [x0, 24]
	ldr	x0, [sp, 24]
	sub	x1, x1, x0
	ldr	x0, [sp, 40]
	str	x1, [x0, 24]
	str	xzr, [sp, 56]
	b	.L8
.L15:
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 16]
	mov	w1, 16
	sub	w0, w1, w0
	sxtw	x0, w0
	ldr	x1, [sp, 24]
	cmp	x1, x0
	bhi	.L9
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 56]
	add	x3, x1, x0
	ldr	x1, [sp, 40]
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 16]
	sxtw	x0, w0
	add	x0, x1, x0
	ldr	x2, [sp, 24]
	mov	x1, x0
	mov	x0, x3
	bl	memcpy
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 16]
	mov	w1, w0
	ldr	x0, [sp, 24]
	add	w0, w1, w0
	mov	w1, w0
	ldr	x0, [sp, 40]
	str	w1, [x0, 16]
	mov	w0, 0
	b	.L6
.L9:
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 56]
	add	x3, x1, x0
	ldr	x1, [sp, 40]
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 16]
	sxtw	x0, w0
	add	x4, x1, x0
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 16]
	mov	w1, 16
	sub	w0, w1, w0
	sxtw	x0, w0
	mov	x2, x0
	mov	x1, x4
	mov	x0, x3
	bl	memcpy
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 16]
	mov	w1, 16
	sub	w0, w1, w0
	sxtw	x0, w0
	ldr	x1, [sp, 24]
	sub	x0, x1, x0
	str	x0, [sp, 24]
	ldr	x0, [sp, 40]
	ldr	w0, [x0, 16]
	mov	w1, 16
	sub	w0, w1, w0
	sxtw	x0, w0
	ldr	x1, [sp, 56]
	add	x0, x1, x0
	str	x0, [sp, 56]
	ldr	x0, [sp, 40]
	add	x3, x0, 32
	ldr	x0, [sp, 40]
	add	x0, x0, 64
	ldr	x1, [sp, 40]
	mov	x2, x1
	mov	x1, x0
	mov	x0, x3
	bl	AES256_ECB
	ldr	x0, [sp, 40]
	str	wzr, [x0, 16]
	mov	w0, 15
	str	w0, [sp, 52]
	b	.L10
.L14:
	ldr	x1, [sp, 40]
	ldrsw	x0, [sp, 52]
	add	x0, x1, x0
	ldrb	w0, [x0, 64]
	cmp	w0, 255
	bne	.L11
	ldr	x1, [sp, 40]
	ldrsw	x0, [sp, 52]
	add	x0, x1, x0
	strb	wzr, [x0, 64]
	b	.L16
.L11:
	ldr	x1, [sp, 40]
	ldrsw	x0, [sp, 52]
	add	x0, x1, x0
	ldrb	w0, [x0, 64]
	add	w0, w0, 1
	and	w2, w0, 255
	ldr	x1, [sp, 40]
	ldrsw	x0, [sp, 52]
	add	x0, x1, x0
	mov	w1, w2
	strb	w1, [x0, 64]
	b	.L8
.L16:
	ldr	w0, [sp, 52]
	sub	w0, w0, #1
	str	w0, [sp, 52]
.L10:
	ldr	w0, [sp, 52]
	cmp	w0, 11
	bgt	.L14
.L8:
	ldr	x0, [sp, 24]
	cmp	x0, 0
	bne	.L15
	mov	w0, 0
.L6:
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE349:
	.size	seedexpander, .-seedexpander
	.align	2
	.global	handleErrors
	.type	handleErrors, %function
handleErrors:
.LFB350:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	adrp	x0, :got:stderr
	ldr	x0, [x0, :got_lo12:stderr]
	ldr	x0, [x0]
	bl	ERR_print_errors_fp
	bl	abort
	.cfi_endproc
.LFE350:
	.size	handleErrors, .-handleErrors
	.align	2
	.global	AES256_ECB
	.type	AES256_ECB, %function
AES256_ECB:
.LFB351:
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
	bl	EVP_CIPHER_CTX_new
	str	x0, [sp, 48]
	ldr	x0, [sp, 48]
	cmp	x0, 0
	bne	.L19
	bl	handleErrors
.L19:
	bl	EVP_aes_256_ecb
	mov	x4, 0
	ldr	x3, [sp, 24]
	mov	x2, 0
	mov	x1, x0
	ldr	x0, [sp, 48]
	bl	EVP_EncryptInit_ex
	cmp	w0, 1
	beq	.L20
	bl	handleErrors
.L20:
	add	x0, sp, 44
	mov	w4, 16
	ldr	x3, [sp, 16]
	mov	x2, x0
	ldr	x1, [sp, 8]
	ldr	x0, [sp, 48]
	bl	EVP_EncryptUpdate
	cmp	w0, 1
	beq	.L21
	bl	handleErrors
.L21:
	ldr	x0, [sp, 48]
	bl	EVP_CIPHER_CTX_free
	nop
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x2, [sp, 56]
	ldr	x1, [x0]
	subs	x2, x2, x1
	mov	x1, 0
	beq	.L22
	bl	__stack_chk_fail
.L22:
	ldp	x29, x30, [sp, 64]
	add	sp, sp, 80
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE351:
	.size	AES256_ECB, .-AES256_ECB
	.align	2
	.global	randombytes_init
	.type	randombytes_init, %function
randombytes_init:
.LFB352:
	.cfi_startproc
	sub	sp, sp, #112
	.cfi_def_cfa_offset 112
	stp	x29, x30, [sp, 96]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 96
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	w2, [sp, 12]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 88]
	mov	x1, 0
	ldr	x1, [sp, 24]
	add	x0, sp, 40
	ldp	q0, q1, [x1]
	stp	q0, q1, [x0]
	ldr	q0, [x1, 32]
	str	q0, [x0, 32]
	ldr	x0, [sp, 16]
	cmp	x0, 0
	beq	.L24
	str	wzr, [sp, 36]
	b	.L25
.L26:
	ldrsw	x0, [sp, 36]
	add	x1, sp, 40
	ldrb	w1, [x1, x0]
	ldrsw	x0, [sp, 36]
	ldr	x2, [sp, 16]
	add	x0, x2, x0
	ldrb	w0, [x0]
	eor	w0, w1, w0
	and	w2, w0, 255
	ldrsw	x0, [sp, 36]
	add	x1, sp, 40
	strb	w2, [x1, x0]
	ldr	w0, [sp, 36]
	add	w0, w0, 1
	str	w0, [sp, 36]
.L25:
	ldr	w0, [sp, 36]
	cmp	w0, 47
	ble	.L26
.L24:
	mov	x2, 32
	mov	w1, 0
	adrp	x0, DRBG_ctx
	add	x0, x0, :lo12:DRBG_ctx
	bl	memset
	mov	x2, 16
	mov	w1, 0
	adrp	x0, DRBG_ctx+32
	add	x0, x0, :lo12:DRBG_ctx+32
	bl	memset
	add	x3, sp, 40
	adrp	x0, DRBG_ctx+32
	add	x2, x0, :lo12:DRBG_ctx+32
	adrp	x0, DRBG_ctx
	add	x1, x0, :lo12:DRBG_ctx
	mov	x0, x3
	bl	AES256_CTR_DRBG_Update
	adrp	x0, DRBG_ctx
	add	x0, x0, :lo12:DRBG_ctx
	mov	w1, 1
	str	w1, [x0, 48]
	nop
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x2, [sp, 88]
	ldr	x1, [x0]
	subs	x2, x2, x1
	mov	x1, 0
	beq	.L27
	bl	__stack_chk_fail
.L27:
	ldp	x29, x30, [sp, 96]
	add	sp, sp, 112
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE352:
	.size	randombytes_init, .-randombytes_init
	.align	2
	.global	randombytes
	.type	randombytes, %function
randombytes:
.LFB353:
	.cfi_startproc
	sub	sp, sp, #64
	.cfi_def_cfa_offset 64
	stp	x29, x30, [sp, 48]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 48
	str	x0, [sp, 8]
	str	x1, [sp]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 40]
	mov	x1, 0
	str	wzr, [sp, 16]
	b	.L29
.L37:
	mov	w0, 15
	str	w0, [sp, 20]
	b	.L30
.L34:
	adrp	x0, DRBG_ctx
	add	x1, x0, :lo12:DRBG_ctx
	ldrsw	x0, [sp, 20]
	add	x0, x1, x0
	ldrb	w0, [x0, 32]
	cmp	w0, 255
	bne	.L31
	adrp	x0, DRBG_ctx
	add	x1, x0, :lo12:DRBG_ctx
	ldrsw	x0, [sp, 20]
	add	x0, x1, x0
	strb	wzr, [x0, 32]
	b	.L40
.L31:
	adrp	x0, DRBG_ctx
	add	x1, x0, :lo12:DRBG_ctx
	ldrsw	x0, [sp, 20]
	add	x0, x1, x0
	ldrb	w0, [x0, 32]
	add	w0, w0, 1
	and	w2, w0, 255
	adrp	x0, DRBG_ctx
	add	x1, x0, :lo12:DRBG_ctx
	ldrsw	x0, [sp, 20]
	add	x0, x1, x0
	mov	w1, w2
	strb	w1, [x0, 32]
	b	.L33
.L40:
	ldr	w0, [sp, 20]
	sub	w0, w0, #1
	str	w0, [sp, 20]
.L30:
	ldr	w0, [sp, 20]
	cmp	w0, 0
	bge	.L34
.L33:
	add	x0, sp, 24
	mov	x2, x0
	adrp	x0, DRBG_ctx+32
	add	x1, x0, :lo12:DRBG_ctx+32
	adrp	x0, DRBG_ctx
	add	x0, x0, :lo12:DRBG_ctx
	bl	AES256_ECB
	ldr	x0, [sp]
	cmp	x0, 15
	bls	.L35
	ldrsw	x0, [sp, 16]
	ldr	x1, [sp, 8]
	add	x2, x1, x0
	ldp	x0, x1, [sp, 24]
	stp	x0, x1, [x2]
	ldr	w0, [sp, 16]
	add	w0, w0, 16
	str	w0, [sp, 16]
	ldr	x0, [sp]
	sub	x0, x0, #16
	str	x0, [sp]
	b	.L29
.L35:
	ldrsw	x0, [sp, 16]
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	add	x1, sp, 24
	ldr	x2, [sp]
	bl	memcpy
	str	xzr, [sp]
.L29:
	ldr	x0, [sp]
	cmp	x0, 0
	bne	.L37
	adrp	x0, DRBG_ctx+32
	add	x2, x0, :lo12:DRBG_ctx+32
	adrp	x0, DRBG_ctx
	add	x1, x0, :lo12:DRBG_ctx
	mov	x0, 0
	bl	AES256_CTR_DRBG_Update
	adrp	x0, DRBG_ctx
	add	x0, x0, :lo12:DRBG_ctx
	ldr	w0, [x0, 48]
	add	w1, w0, 1
	adrp	x0, DRBG_ctx
	add	x0, x0, :lo12:DRBG_ctx
	str	w1, [x0, 48]
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 40]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L39
	bl	__stack_chk_fail
.L39:
	mov	w0, w1
	ldp	x29, x30, [sp, 48]
	add	sp, sp, 64
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE353:
	.size	randombytes, .-randombytes
	.align	2
	.global	AES256_CTR_DRBG_Update
	.type	AES256_CTR_DRBG_Update, %function
AES256_CTR_DRBG_Update:
.LFB354:
	.cfi_startproc
	sub	sp, sp, #128
	.cfi_def_cfa_offset 128
	stp	x29, x30, [sp, 112]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 112
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	x2, [sp, 8]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 104]
	mov	x1, 0
	str	wzr, [sp, 44]
	b	.L42
.L48:
	mov	w0, 15
	str	w0, [sp, 48]
	b	.L43
.L47:
	ldrsw	x0, [sp, 48]
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldrb	w0, [x0]
	cmp	w0, 255
	bne	.L44
	ldrsw	x0, [sp, 48]
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	strb	wzr, [x0]
	b	.L53
.L44:
	ldrsw	x0, [sp, 48]
	ldr	x1, [sp, 8]
	add	x0, x1, x0
	ldrb	w1, [x0]
	add	w1, w1, 1
	and	w1, w1, 255
	strb	w1, [x0]
	b	.L46
.L53:
	ldr	w0, [sp, 48]
	sub	w0, w0, #1
	str	w0, [sp, 48]
.L43:
	ldr	w0, [sp, 48]
	cmp	w0, 0
	bge	.L47
.L46:
	ldr	w0, [sp, 44]
	lsl	w0, w0, 4
	sxtw	x0, w0
	add	x1, sp, 56
	add	x0, x1, x0
	mov	x2, x0
	ldr	x1, [sp, 8]
	ldr	x0, [sp, 16]
	bl	AES256_ECB
	ldr	w0, [sp, 44]
	add	w0, w0, 1
	str	w0, [sp, 44]
.L42:
	ldr	w0, [sp, 44]
	cmp	w0, 2
	ble	.L48
	ldr	x0, [sp, 24]
	cmp	x0, 0
	beq	.L49
	str	wzr, [sp, 52]
	b	.L50
.L51:
	ldrsw	x0, [sp, 52]
	add	x1, sp, 56
	ldrb	w1, [x1, x0]
	ldrsw	x0, [sp, 52]
	ldr	x2, [sp, 24]
	add	x0, x2, x0
	ldrb	w0, [x0]
	eor	w0, w1, w0
	and	w2, w0, 255
	ldrsw	x0, [sp, 52]
	add	x1, sp, 56
	strb	w2, [x1, x0]
	ldr	w0, [sp, 52]
	add	w0, w0, 1
	str	w0, [sp, 52]
.L50:
	ldr	w0, [sp, 52]
	cmp	w0, 47
	ble	.L51
.L49:
	add	x0, sp, 56
	mov	x2, 32
	mov	x1, x0
	ldr	x0, [sp, 16]
	bl	memcpy
	add	x0, sp, 56
	add	x0, x0, 32
	ldp	x0, x1, [x0]
	ldr	x2, [sp, 8]
	stp	x0, x1, [x2]
	nop
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x2, [sp, 104]
	ldr	x1, [x0]
	subs	x2, x2, x1
	mov	x1, 0
	beq	.L52
	bl	__stack_chk_fail
.L52:
	ldp	x29, x30, [sp, 112]
	add	sp, sp, 128
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE354:
	.size	AES256_CTR_DRBG_Update, .-AES256_CTR_DRBG_Update
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits

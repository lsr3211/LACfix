	.arch armv8-a
	.file	"test_speed.c"
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"poly_mul time    :%f us\n"
	.text
	.align	2
	.global	test_poly_mul_speed
	.type	test_poly_mul_speed, %function
test_poly_mul_speed:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #1616
	.cfi_def_cfa_offset 1632
	str	xzr, [sp, 1024]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 1608]
	mov	x1, 0
	add	x0, sp, 72
	mov	w1, 512
	bl	random_bytes
	add	x0, sp, 40
	mov	w1, 32
	bl	random_bytes
	add	x1, sp, 40
	add	x0, sp, 1096
	mov	x2, x1
	mov	w1, 512
	bl	gen_psi_fix_ham
	bl	clock
	str	x0, [sp, 16]
	str	wzr, [sp, 12]
	b	.L2
.L3:
	add	x2, sp, 584
	add	x1, sp, 1096
	add	x0, sp, 72
	mov	w3, 512
	bl	poly_mul
	ldr	w0, [sp, 12]
	add	w0, w0, 1
	str	w0, [sp, 12]
.L2:
	ldr	w1, [sp, 12]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L3
	bl	clock
	str	x0, [sp, 24]
	ldr	x1, [sp, 24]
	ldr	x0, [sp, 16]
	sub	x0, x1, x0
	fmov	d0, x0
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 32]
	ldr	d0, [sp, 32]
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fmul	d0, d0, d1
	mov	x0, 149533581377536
	movk	x0, 0x40c3, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 1608]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L5
	bl	__stack_chk_fail
.L5:
	mov	w0, w1
	add	sp, sp, 1616
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	test_poly_mul_speed, .-test_poly_mul_speed
	.section	.rodata
	.align	3
.LC1:
	.string	"key generate time:%f us\n"
	.align	3
.LC2:
	.string	"encryption time  :%f us\n"
	.align	3
.LC3:
	.string	"decryption time  :%f us\n"
	.text
	.align	2
	.global	test_pke_speed
	.type	test_pke_speed, %function
test_pke_speed:
.LFB1:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #2432
	.cfi_def_cfa_offset 2448
	str	xzr, [sp, 1024]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 2424]
	mov	x1, 0
	mov	x0, 32
	str	x0, [sp, 8]
	mov	x0, 712
	str	x0, [sp, 16]
	bl	clock
	str	x0, [sp, 24]
	str	wzr, [sp, 4]
	b	.L7
.L8:
	add	x1, sp, 1368
	add	x0, sp, 112
	bl	crypto_encrypt_keypair
	ldr	w0, [sp, 4]
	add	w0, w0, 1
	str	w0, [sp, 4]
.L7:
	ldr	w1, [sp, 4]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L8
	bl	clock
	str	x0, [sp, 32]
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 24]
	sub	x0, x1, x0
	fmov	d0, x0
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 40]
	ldr	d0, [sp, 40]
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fmul	d0, d0, d1
	mov	x0, 149533581377536
	movk	x0, 0x40c3, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printf
	add	x1, sp, 1368
	add	x0, sp, 112
	bl	crypto_encrypt_keypair
	add	x0, sp, 48
	mov	w1, 32
	bl	random_bytes
	bl	clock
	str	x0, [sp, 24]
	str	wzr, [sp, 4]
	b	.L9
.L10:
	ldr	x3, [sp, 8]
	add	x4, sp, 112
	add	x2, sp, 48
	add	x1, sp, 16
	add	x0, sp, 656
	bl	crypto_encrypt
	ldr	w0, [sp, 4]
	add	w0, w0, 1
	str	w0, [sp, 4]
.L9:
	ldr	w1, [sp, 4]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L10
	bl	clock
	str	x0, [sp, 32]
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 24]
	sub	x0, x1, x0
	fmov	d0, x0
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 40]
	ldr	d0, [sp, 40]
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fmul	d0, d0, d1
	mov	x0, 149533581377536
	movk	x0, 0x40c3, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf
	add	x1, sp, 1368
	add	x0, sp, 112
	bl	crypto_encrypt_keypair
	add	x0, sp, 48
	mov	w1, 32
	bl	random_bytes
	ldr	x3, [sp, 8]
	add	x4, sp, 112
	add	x2, sp, 48
	add	x1, sp, 16
	add	x0, sp, 656
	bl	crypto_encrypt
	bl	clock
	str	x0, [sp, 24]
	str	wzr, [sp, 4]
	b	.L11
.L12:
	ldr	x3, [sp, 16]
	add	x4, sp, 1368
	add	x2, sp, 656
	add	x1, sp, 8
	add	x0, sp, 80
	bl	crypto_encrypt_open
	ldr	w0, [sp, 4]
	add	w0, w0, 1
	str	w0, [sp, 4]
.L11:
	ldr	w1, [sp, 4]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L12
	bl	clock
	str	x0, [sp, 32]
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 24]
	sub	x0, x1, x0
	fmov	d0, x0
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 40]
	ldr	d0, [sp, 40]
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fmul	d0, d0, d1
	mov	x0, 149533581377536
	movk	x0, 0x40c3, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printf
	mov	w0, 10
	bl	putchar
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 2424]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L14
	bl	__stack_chk_fail
.L14:
	mov	w0, w1
	add	sp, sp, 2432
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE1:
	.size	test_pke_speed, .-test_pke_speed
	.section	.rodata
	.align	3
.LC4:
	.string	"kem_fo_enc time  :%f us\n"
	.align	3
.LC5:
	.string	"kem_fo_dec time  :%f us\n"
	.text
	.align	2
	.global	test_kem_fo_speed
	.type	test_kem_fo_speed, %function
test_kem_fo_speed:
.LFB2:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #2416
	.cfi_def_cfa_offset 2432
	str	xzr, [sp, 1024]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 2408]
	mov	x1, 0
	bl	clock
	str	x0, [sp, 8]
	str	wzr, [sp, 4]
	b	.L16
.L17:
	add	x1, sp, 1352
	add	x0, sp, 96
	bl	crypto_kem_keypair
	ldr	w0, [sp, 4]
	add	w0, w0, 1
	str	w0, [sp, 4]
.L16:
	ldr	w1, [sp, 4]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L17
	bl	clock
	str	x0, [sp, 16]
	ldr	x1, [sp, 16]
	ldr	x0, [sp, 8]
	sub	x0, x1, x0
	fmov	d0, x0
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 24]
	ldr	d0, [sp, 24]
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fmul	d0, d0, d1
	mov	x0, 149533581377536
	movk	x0, 0x40c3, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printf
	add	x1, sp, 1352
	add	x0, sp, 96
	bl	crypto_kem_keypair
	bl	clock
	str	x0, [sp, 8]
	str	wzr, [sp, 4]
	b	.L18
.L19:
	add	x2, sp, 96
	add	x1, sp, 32
	add	x0, sp, 640
	bl	crypto_kem_enc
	ldr	w0, [sp, 4]
	add	w0, w0, 1
	str	w0, [sp, 4]
.L18:
	ldr	w1, [sp, 4]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L19
	bl	clock
	str	x0, [sp, 16]
	ldr	x1, [sp, 16]
	ldr	x0, [sp, 8]
	sub	x0, x1, x0
	fmov	d0, x0
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 24]
	ldr	d0, [sp, 24]
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fmul	d0, d0, d1
	mov	x0, 149533581377536
	movk	x0, 0x40c3, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	add	x1, sp, 1352
	add	x0, sp, 96
	bl	crypto_kem_keypair
	add	x2, sp, 96
	add	x1, sp, 32
	add	x0, sp, 640
	bl	crypto_kem_enc
	bl	clock
	str	x0, [sp, 8]
	str	wzr, [sp, 4]
	b	.L20
.L21:
	add	x2, sp, 1352
	add	x1, sp, 640
	add	x0, sp, 64
	bl	crypto_kem_dec
	ldr	w0, [sp, 4]
	add	w0, w0, 1
	str	w0, [sp, 4]
.L20:
	ldr	w1, [sp, 4]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L21
	bl	clock
	str	x0, [sp, 16]
	ldr	x1, [sp, 16]
	ldr	x0, [sp, 8]
	sub	x0, x1, x0
	fmov	d0, x0
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 24]
	ldr	d0, [sp, 24]
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fmul	d0, d0, d1
	mov	x0, 149533581377536
	movk	x0, 0x40c3, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	mov	w0, 10
	bl	putchar
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 2408]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L23
	bl	__stack_chk_fail
.L23:
	mov	w0, w1
	add	sp, sp, 2416
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE2:
	.size	test_kem_fo_speed, .-test_kem_fo_speed
	.section	.rodata
	.align	3
.LC6:
	.string	"ke alice0 time   :%f us\n"
	.align	3
.LC7:
	.string	"ke bob time      :%f us\n"
	.align	3
.LC8:
	.string	"ke alice1 time   :%f us\n"
	.text
	.align	2
	.global	test_ke_speed
	.type	test_ke_speed, %function
test_ke_speed:
.LFB3:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #2416
	.cfi_def_cfa_offset 2432
	str	xzr, [sp, 1024]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 2408]
	mov	x1, 0
	bl	clock
	str	x0, [sp, 8]
	str	wzr, [sp, 4]
	b	.L25
.L26:
	add	x1, sp, 1352
	add	x0, sp, 96
	bl	crypto_ke_alice_send
	ldr	w0, [sp, 4]
	add	w0, w0, 1
	str	w0, [sp, 4]
.L25:
	ldr	w1, [sp, 4]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L26
	bl	clock
	str	x0, [sp, 16]
	ldr	x1, [sp, 16]
	ldr	x0, [sp, 8]
	sub	x0, x1, x0
	fmov	d0, x0
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 24]
	ldr	d0, [sp, 24]
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fmul	d0, d0, d1
	mov	x0, 149533581377536
	movk	x0, 0x40c3, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printf
	bl	clock
	str	x0, [sp, 8]
	str	wzr, [sp, 4]
	b	.L27
.L28:
	add	x2, sp, 32
	add	x1, sp, 640
	add	x0, sp, 96
	bl	crypto_ke_bob_receive
	ldr	w0, [sp, 4]
	add	w0, w0, 1
	str	w0, [sp, 4]
.L27:
	ldr	w1, [sp, 4]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L28
	bl	clock
	str	x0, [sp, 16]
	ldr	x1, [sp, 16]
	ldr	x0, [sp, 8]
	sub	x0, x1, x0
	fmov	d0, x0
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 24]
	ldr	d0, [sp, 24]
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fmul	d0, d0, d1
	mov	x0, 149533581377536
	movk	x0, 0x40c3, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf
	bl	clock
	str	x0, [sp, 8]
	str	wzr, [sp, 4]
	b	.L29
.L30:
	add	x3, sp, 64
	add	x2, sp, 640
	add	x1, sp, 1352
	add	x0, sp, 96
	bl	crypto_ke_alice_receive
	ldr	w0, [sp, 4]
	add	w0, w0, 1
	str	w0, [sp, 4]
.L29:
	ldr	w1, [sp, 4]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L30
	bl	clock
	str	x0, [sp, 16]
	ldr	x1, [sp, 16]
	ldr	x0, [sp, 8]
	sub	x0, x1, x0
	fmov	d0, x0
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 24]
	ldr	d0, [sp, 24]
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fmul	d0, d0, d1
	mov	x0, 149533581377536
	movk	x0, 0x40c3, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printf
	mov	w0, 10
	bl	putchar
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 2408]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L32
	bl	__stack_chk_fail
.L32:
	mov	w0, w1
	add	sp, sp, 2416
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE3:
	.size	test_ke_speed, .-test_ke_speed
	.section	.rodata
	.align	3
.LC9:
	.string	"ake alice0 time  :%f us\n"
	.align	3
.LC10:
	.string	"ake bob time     :%f us\n"
	.align	3
.LC11:
	.string	"ake alice1 time  :%f us\n"
	.text
	.align	2
	.global	test_ake_speed
	.type	test_ake_speed, %function
test_ake_speed:
.LFB4:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	mov	x13, 7088
	sub	sp, sp, x13
	.cfi_def_cfa_offset 7104
	str	xzr, [sp, 1024]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 7080]
	mov	x1, 0
	add	x1, sp, 3544
	add	x0, sp, 144
	bl	crypto_encrypt_keypair
	add	x1, sp, 4096
	add	x1, x1, 504
	add	x0, sp, 688
	bl	crypto_encrypt_keypair
	bl	clock
	str	x0, [sp, 24]
	str	wzr, [sp, 20]
	b	.L34
.L35:
	add	x5, sp, 112
	add	x4, sp, 1776
	add	x3, sp, 3544
	add	x2, sp, 688
	add	x1, sp, 2488
	add	x0, sp, 1232
	bl	crypto_ake_alice_send
	ldr	w0, [sp, 20]
	add	w0, w0, 1
	str	w0, [sp, 20]
.L34:
	ldr	w1, [sp, 20]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L35
	bl	clock
	str	x0, [sp, 32]
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 24]
	sub	x0, x1, x0
	fmov	d0, x0
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 40]
	ldr	d0, [sp, 40]
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fmul	d0, d0, d1
	mov	x0, 149533581377536
	movk	x0, 0x40c3, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printf
	bl	clock
	str	x0, [sp, 24]
	str	wzr, [sp, 20]
	b	.L36
.L37:
	add	x6, sp, 80
	add	x5, sp, 4096
	add	x5, x5, 1560
	add	x4, sp, 1776
	add	x3, sp, 1232
	add	x2, sp, 144
	add	x1, sp, 4096
	add	x1, x1, 504
	add	x0, sp, 688
	bl	crypto_ake_bob_receive
	ldr	w0, [sp, 20]
	add	w0, w0, 1
	str	w0, [sp, 20]
.L36:
	ldr	w1, [sp, 20]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L37
	bl	clock
	str	x0, [sp, 32]
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 24]
	sub	x0, x1, x0
	fmov	d0, x0
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 40]
	ldr	d0, [sp, 40]
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fmul	d0, d0, d1
	mov	x0, 149533581377536
	movk	x0, 0x40c3, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	printf
	bl	clock
	str	x0, [sp, 24]
	str	wzr, [sp, 20]
	b	.L38
.L39:
	add	x7, sp, 112
	add	x6, sp, 4096
	add	x6, x6, 1560
	add	x5, sp, 1776
	add	x4, sp, 2488
	add	x3, sp, 1232
	add	x2, sp, 688
	add	x1, sp, 3544
	add	x8, sp, 144
	add	x0, sp, 48
	str	x0, [sp]
	mov	x0, x8
	bl	crypto_ake_alice_receive
	ldr	w0, [sp, 20]
	add	w0, w0, 1
	str	w0, [sp, 20]
.L38:
	ldr	w1, [sp, 20]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L39
	bl	clock
	str	x0, [sp, 32]
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 24]
	sub	x0, x1, x0
	fmov	d0, x0
	scvtf	d0, d0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	str	d0, [sp, 40]
	ldr	d0, [sp, 40]
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d1, x0
	fmul	d0, d0, d1
	mov	x0, 149533581377536
	movk	x0, 0x40c3, lsl 48
	fmov	d1, x0
	fdiv	d0, d0, d1
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	printf
	mov	w0, 10
	bl	putchar
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 7080]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L41
	bl	__stack_chk_fail
.L41:
	mov	w0, w1
	mov	x13, 7088
	add	sp, sp, x13
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE4:
	.size	test_ake_speed, .-test_ake_speed
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits

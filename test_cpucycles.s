	.arch armv8-a
	.file	"test_cpucycles.c"
	.text
	.align	2
	.type	cpucycles, %function
cpucycles:
.LFB0:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	stp	x29, x30, [sp, 32]
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	add	x29, sp, 32
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 24]
	mov	x1, 0
	add	x0, sp, 8
	mov	x1, x0
	mov	w0, 1
	bl	clock_gettime
	ldr	x0, [sp, 8]
	mov	x1, x0
	mov	x0, 51712
	movk	x0, 0x3b9a, lsl 16
	mul	x0, x1, x0
	ldr	x1, [sp, 16]
	add	x0, x0, x1
	mov	x1, x0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 24]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L3
	bl	__stack_chk_fail
.L3:
	mov	x0, x1
	ldp	x29, x30, [sp, 32]
	add	sp, sp, 48
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	cpucycles, .-cpucycles
	.global	sum
	.bss
	.align	3
	.type	sum, %object
	.size	sum, 8
sum:
	.zero	8
	.global	average
	.align	3
	.type	average, %object
	.size	average, 8
average:
	.zero	8
	.section	.rodata
	.align	3
.LC0:
	.string	"%d"
	.text
	.align	2
	.type	print_uint64, %function
print_uint64:
.LFB1:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x0, [sp, 24]
	ldr	x0, [sp, 24]
	cmp	x0, 9
	bls	.L5
	ldr	x1, [sp, 24]
	mov	x0, -3689348814741910324
	movk	x0, 0xcccd, lsl 0
	umulh	x0, x1, x0
	lsr	x0, x0, 3
	bl	print_uint64
.L5:
	ldr	x2, [sp, 24]
	mov	x0, -3689348814741910324
	movk	x0, 0xcccd, lsl 0
	umulh	x0, x2, x0
	lsr	x1, x0, 3
	mov	x0, x1
	lsl	x0, x0, 2
	add	x0, x0, x1
	lsl	x0, x0, 1
	sub	x1, x2, x0
	mov	w0, w1
	mov	w1, w0
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	printf
	nop
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE1:
	.size	print_uint64, .-print_uint64
	.section	.rodata
	.align	3
.LC1:
	.string	": "
	.align	3
.LC2:
	.string	" cpucycles"
	.text
	.align	2
	.global	print_cpucycles
	.type	print_cpucycles, %function
print_cpucycles:
.LFB2:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x0, [sp, 24]
	adrp	x0, sum
	add	x0, x0, :lo12:sum
	str	xzr, [x0]
	str	wzr, [sp, 44]
	b	.L7
.L8:
	ldrsw	x0, [sp, 44]
	add	x0, x0, 1
	lsl	x0, x0, 3
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldr	x2, [x0]
	ldrsw	x0, [sp, 44]
	lsl	x0, x0, 3
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldr	x1, [x0]
	ldrsw	x0, [sp, 44]
	lsl	x0, x0, 3
	ldr	x3, [sp, 24]
	add	x0, x3, x0
	sub	x1, x2, x1
	str	x1, [x0]
	ldrsw	x0, [sp, 44]
	lsl	x0, x0, 3
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldr	x1, [x0]
	adrp	x0, sum
	add	x0, x0, :lo12:sum
	ldr	x0, [x0]
	add	x1, x1, x0
	adrp	x0, sum
	add	x0, x0, :lo12:sum
	str	x1, [x0]
	ldr	w0, [sp, 44]
	add	w0, w0, 1
	str	w0, [sp, 44]
.L7:
	ldr	w1, [sp, 44]
	mov	w0, 9998
	cmp	w1, w0
	ble	.L8
	adrp	x0, sum
	add	x0, x0, :lo12:sum
	ldr	x1, [x0]
	mov	x0, 19493
	movk	x0, 0x957e, lsl 16
	movk	x0, 0xebbf, lsl 32
	movk	x0, 0xa378, lsl 48
	umulh	x0, x1, x0
	sub	x1, x1, x0
	lsr	x1, x1, 1
	add	x0, x0, x1
	lsr	x1, x0, 13
	adrp	x0, average
	add	x0, x0, :lo12:average
	str	x1, [x0]
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	printf
	adrp	x0, average
	add	x0, x0, :lo12:average
	ldr	x0, [x0]
	bl	print_uint64
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	puts
	mov	w0, 0
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE2:
	.size	print_cpucycles, .-print_cpucycles
	.section	.rodata
	.align	3
.LC3:
	.string	"pke kg     "
	.align	3
.LC4:
	.string	"encryption "
	.align	3
.LC5:
	.string	"decryption "
	.text
	.align	2
	.global	test_pke_cpucycles
	.type	test_pke_cpucycles, %function
test_pke_cpucycles:
.LFB3:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #65536
	.cfi_def_cfa_offset 65552
	str	xzr, [sp, 1024]
	mov	x13, 16880
	sub	sp, sp, x13
	.cfi_def_cfa_offset 82432
	str	xzr, [sp, 1024]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	add	x1, sp, 81920
	ldr	x2, [x0]
	str	x2, [x1, 488]
	mov	x2, 0
	mov	x0, 32
	str	x0, [sp, 16]
	mov	x0, 712
	str	x0, [sp, 24]
	str	wzr, [sp, 12]
	b	.L11
.L12:
	bl	cpucycles
	mov	x2, x0
	ldrsw	x0, [sp, 12]
	lsl	x0, x0, 3
	add	x1, sp, 32
	str	x2, [x1, x0]
	add	x1, sp, 77824
	add	x1, x1, 3528
	add	x0, sp, 77824
	add	x0, x0, 2272
	bl	crypto_encrypt_keypair
	ldr	w0, [sp, 12]
	add	w0, w0, 1
	str	w0, [sp, 12]
.L11:
	ldr	w1, [sp, 12]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L12
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printf
	add	x0, sp, 32
	bl	print_cpucycles
	add	x1, sp, 77824
	add	x1, x1, 3528
	add	x0, sp, 77824
	add	x0, x0, 2272
	bl	crypto_encrypt_keypair
	add	x0, sp, 77824
	add	x0, x0, 2208
	mov	w1, 32
	bl	random_bytes
	str	wzr, [sp, 12]
	b	.L13
.L14:
	bl	cpucycles
	mov	x2, x0
	ldrsw	x0, [sp, 12]
	lsl	x0, x0, 3
	add	x1, sp, 32
	str	x2, [x1, x0]
	ldr	x3, [sp, 16]
	add	x4, sp, 77824
	add	x4, x4, 2272
	add	x2, sp, 77824
	add	x2, x2, 2208
	add	x1, sp, 24
	add	x0, sp, 77824
	add	x0, x0, 2816
	bl	crypto_encrypt
	ldr	w0, [sp, 12]
	add	w0, w0, 1
	str	w0, [sp, 12]
.L13:
	ldr	w1, [sp, 12]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L14
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	add	x0, sp, 32
	bl	print_cpucycles
	add	x1, sp, 77824
	add	x1, x1, 3528
	add	x0, sp, 77824
	add	x0, x0, 2272
	bl	crypto_encrypt_keypair
	add	x0, sp, 77824
	add	x0, x0, 2208
	mov	w1, 32
	bl	random_bytes
	ldr	x3, [sp, 16]
	add	x4, sp, 77824
	add	x4, x4, 2272
	add	x2, sp, 77824
	add	x2, x2, 2208
	add	x1, sp, 24
	add	x0, sp, 77824
	add	x0, x0, 2816
	bl	crypto_encrypt
	str	wzr, [sp, 12]
	b	.L15
.L16:
	bl	cpucycles
	mov	x2, x0
	ldrsw	x0, [sp, 12]
	lsl	x0, x0, 3
	add	x1, sp, 32
	str	x2, [x1, x0]
	ldr	x3, [sp, 24]
	add	x4, sp, 77824
	add	x4, x4, 3528
	add	x2, sp, 77824
	add	x2, x2, 2816
	add	x1, sp, 16
	add	x0, sp, 77824
	add	x0, x0, 2240
	bl	crypto_encrypt_open
	ldr	w0, [sp, 12]
	add	w0, w0, 1
	str	w0, [sp, 12]
.L15:
	ldr	w1, [sp, 12]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L16
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	add	x0, sp, 32
	bl	print_cpucycles
	mov	w0, 10
	bl	putchar
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	add	x3, sp, 81920
	ldr	x4, [x3, 488]
	ldr	x2, [x0]
	subs	x4, x4, x2
	mov	x2, 0
	beq	.L18
	bl	__stack_chk_fail
.L18:
	mov	w0, w1
	add	sp, sp, 496
	.cfi_def_cfa_offset 81936
	add	sp, sp, 81920
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE3:
	.size	test_pke_cpucycles, .-test_pke_cpucycles
	.section	.rodata
	.align	3
.LC6:
	.string	"kem_fo kg  "
	.text
	.align	2
	.global	test_kem_fo_cpucycles
	.type	test_kem_fo_cpucycles, %function
test_kem_fo_cpucycles:
.LFB4:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #65536
	.cfi_def_cfa_offset 65552
	str	xzr, [sp, 1024]
	mov	x13, 16864
	sub	sp, sp, x13
	.cfi_def_cfa_offset 82416
	str	xzr, [sp, 1024]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	add	x1, sp, 81920
	ldr	x2, [x0]
	str	x2, [x1, 472]
	mov	x2, 0
	str	wzr, [sp, 12]
	b	.L20
.L21:
	bl	cpucycles
	mov	x2, x0
	ldrsw	x0, [sp, 12]
	lsl	x0, x0, 3
	add	x1, sp, 16
	str	x2, [x1, x0]
	add	x1, sp, 77824
	add	x1, x1, 3512
	add	x0, sp, 77824
	add	x0, x0, 2256
	bl	crypto_kem_keypair
	ldr	w0, [sp, 12]
	add	w0, w0, 1
	str	w0, [sp, 12]
.L20:
	ldr	w1, [sp, 12]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L21
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printf
	add	x0, sp, 16
	bl	print_cpucycles
	add	x1, sp, 77824
	add	x1, x1, 3512
	add	x0, sp, 77824
	add	x0, x0, 2256
	bl	crypto_kem_keypair
	add	x0, sp, 77824
	add	x0, x0, 2192
	mov	w1, 32
	bl	random_bytes
	str	wzr, [sp, 12]
	b	.L22
.L23:
	bl	cpucycles
	mov	x2, x0
	ldrsw	x0, [sp, 12]
	lsl	x0, x0, 3
	add	x1, sp, 16
	str	x2, [x1, x0]
	add	x2, sp, 77824
	add	x2, x2, 2256
	add	x1, sp, 77824
	add	x1, x1, 2192
	add	x0, sp, 77824
	add	x0, x0, 2800
	bl	crypto_kem_enc
	ldr	w0, [sp, 12]
	add	w0, w0, 1
	str	w0, [sp, 12]
.L22:
	ldr	w1, [sp, 12]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L23
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	printf
	add	x0, sp, 16
	bl	print_cpucycles
	add	x1, sp, 77824
	add	x1, x1, 3512
	add	x0, sp, 77824
	add	x0, x0, 2256
	bl	crypto_kem_keypair
	add	x2, sp, 77824
	add	x2, x2, 2256
	add	x1, sp, 77824
	add	x1, x1, 2192
	add	x0, sp, 77824
	add	x0, x0, 2800
	bl	crypto_kem_enc
	str	wzr, [sp, 12]
	b	.L24
.L25:
	bl	cpucycles
	mov	x2, x0
	ldrsw	x0, [sp, 12]
	lsl	x0, x0, 3
	add	x1, sp, 16
	str	x2, [x1, x0]
	add	x2, sp, 77824
	add	x2, x2, 3512
	add	x1, sp, 77824
	add	x1, x1, 2800
	add	x0, sp, 77824
	add	x0, x0, 2224
	bl	crypto_kem_dec
	ldr	w0, [sp, 12]
	add	w0, w0, 1
	str	w0, [sp, 12]
.L24:
	ldr	w1, [sp, 12]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L25
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	add	x0, sp, 16
	bl	print_cpucycles
	mov	w0, 10
	bl	putchar
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	add	x3, sp, 81920
	ldr	x4, [x3, 472]
	ldr	x2, [x0]
	subs	x4, x4, x2
	mov	x2, 0
	beq	.L27
	bl	__stack_chk_fail
.L27:
	mov	w0, w1
	add	sp, sp, 480
	.cfi_def_cfa_offset 81936
	add	sp, sp, 81920
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE4:
	.size	test_kem_fo_cpucycles, .-test_kem_fo_cpucycles
	.section	.rodata
	.align	3
.LC7:
	.string	"ke alice0  "
	.align	3
.LC8:
	.string	"ke bob     "
	.align	3
.LC9:
	.string	"ke alice1  "
	.text
	.align	2
	.global	test_ke_cpucycles
	.type	test_ke_cpucycles, %function
test_ke_cpucycles:
.LFB5:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #65536
	.cfi_def_cfa_offset 65552
	str	xzr, [sp, 1024]
	mov	x13, 16864
	sub	sp, sp, x13
	.cfi_def_cfa_offset 82416
	str	xzr, [sp, 1024]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	add	x1, sp, 81920
	ldr	x2, [x0]
	str	x2, [x1, 472]
	mov	x2, 0
	str	wzr, [sp, 12]
	b	.L29
.L30:
	bl	cpucycles
	mov	x2, x0
	ldrsw	x0, [sp, 12]
	lsl	x0, x0, 3
	add	x1, sp, 16
	str	x2, [x1, x0]
	add	x1, sp, 77824
	add	x1, x1, 3512
	add	x0, sp, 77824
	add	x0, x0, 2256
	bl	crypto_ke_alice_send
	ldr	w0, [sp, 12]
	add	w0, w0, 1
	str	w0, [sp, 12]
.L29:
	ldr	w1, [sp, 12]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L30
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf
	add	x0, sp, 16
	bl	print_cpucycles
	str	wzr, [sp, 12]
	b	.L31
.L32:
	bl	cpucycles
	mov	x2, x0
	ldrsw	x0, [sp, 12]
	lsl	x0, x0, 3
	add	x1, sp, 16
	str	x2, [x1, x0]
	add	x2, sp, 77824
	add	x2, x2, 2192
	add	x1, sp, 77824
	add	x1, x1, 2800
	add	x0, sp, 77824
	add	x0, x0, 2256
	bl	crypto_ke_bob_receive
	ldr	w0, [sp, 12]
	add	w0, w0, 1
	str	w0, [sp, 12]
.L31:
	ldr	w1, [sp, 12]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L32
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printf
	add	x0, sp, 16
	bl	print_cpucycles
	str	wzr, [sp, 12]
	b	.L33
.L34:
	bl	cpucycles
	mov	x2, x0
	ldrsw	x0, [sp, 12]
	lsl	x0, x0, 3
	add	x1, sp, 16
	str	x2, [x1, x0]
	add	x3, sp, 77824
	add	x3, x3, 2224
	add	x2, sp, 77824
	add	x2, x2, 2800
	add	x1, sp, 77824
	add	x1, x1, 3512
	add	x0, sp, 77824
	add	x0, x0, 2256
	bl	crypto_ke_alice_receive
	ldr	w0, [sp, 12]
	add	w0, w0, 1
	str	w0, [sp, 12]
.L33:
	ldr	w1, [sp, 12]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L34
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	printf
	add	x0, sp, 16
	bl	print_cpucycles
	mov	w0, 10
	bl	putchar
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	add	x3, sp, 81920
	ldr	x4, [x3, 472]
	ldr	x2, [x0]
	subs	x4, x4, x2
	mov	x2, 0
	beq	.L36
	bl	__stack_chk_fail
.L36:
	mov	w0, w1
	add	sp, sp, 480
	.cfi_def_cfa_offset 81936
	add	sp, sp, 81920
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE5:
	.size	test_ke_cpucycles, .-test_ke_cpucycles
	.section	.rodata
	.align	3
.LC10:
	.string	"ake alice0 "
	.align	3
.LC11:
	.string	"ake bob    "
	.align	3
.LC12:
	.string	"ake alice1 "
	.text
	.align	2
	.global	test_ake_cpucycles
	.type	test_ake_cpucycles, %function
test_ake_cpucycles:
.LFB6:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #65536
	.cfi_def_cfa_offset 65552
	str	xzr, [sp, 1024]
	mov	x13, 21536
	sub	sp, sp, x13
	.cfi_def_cfa_offset 87088
	str	xzr, [sp, 1024]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	add	x1, sp, 81920
	ldr	x2, [x0]
	str	x2, [x1, 5144]
	mov	x2, 0
	add	x1, sp, 81920
	add	x1, x1, 1608
	add	x0, sp, 77824
	add	x0, x0, 2304
	bl	crypto_encrypt_keypair
	add	x1, sp, 81920
	add	x1, x1, 2664
	add	x0, sp, 77824
	add	x0, x0, 2848
	bl	crypto_encrypt_keypair
	str	wzr, [sp, 28]
	b	.L38
.L39:
	bl	cpucycles
	mov	x2, x0
	ldrsw	x0, [sp, 28]
	lsl	x0, x0, 3
	add	x1, sp, 32
	str	x2, [x1, x0]
	add	x5, sp, 77824
	add	x5, x5, 2272
	add	x4, sp, 77824
	add	x4, x4, 3936
	add	x3, sp, 81920
	add	x3, x3, 1608
	add	x2, sp, 77824
	add	x2, x2, 2848
	add	x1, sp, 81920
	add	x1, x1, 552
	add	x0, sp, 77824
	add	x0, x0, 3392
	bl	crypto_ake_alice_send
	ldr	w0, [sp, 28]
	add	w0, w0, 1
	str	w0, [sp, 28]
.L38:
	ldr	w1, [sp, 28]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L39
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	printf
	add	x0, sp, 32
	bl	print_cpucycles
	str	wzr, [sp, 28]
	b	.L40
.L41:
	bl	cpucycles
	mov	x2, x0
	ldrsw	x0, [sp, 28]
	lsl	x0, x0, 3
	add	x1, sp, 32
	str	x2, [x1, x0]
	add	x6, sp, 77824
	add	x6, x6, 2240
	add	x5, sp, 81920
	add	x5, x5, 3720
	add	x4, sp, 77824
	add	x4, x4, 3936
	add	x3, sp, 77824
	add	x3, x3, 3392
	add	x2, sp, 77824
	add	x2, x2, 2304
	add	x1, sp, 81920
	add	x1, x1, 2664
	add	x0, sp, 77824
	add	x0, x0, 2848
	bl	crypto_ake_bob_receive
	ldr	w0, [sp, 28]
	add	w0, w0, 1
	str	w0, [sp, 28]
.L40:
	ldr	w1, [sp, 28]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L41
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	printf
	add	x0, sp, 32
	bl	print_cpucycles
	str	wzr, [sp, 28]
	b	.L42
.L43:
	bl	cpucycles
	mov	x2, x0
	ldrsw	x0, [sp, 28]
	lsl	x0, x0, 3
	add	x1, sp, 32
	str	x2, [x1, x0]
	add	x7, sp, 77824
	add	x7, x7, 2272
	add	x6, sp, 81920
	add	x6, x6, 3720
	add	x5, sp, 77824
	add	x5, x5, 3936
	add	x4, sp, 81920
	add	x4, x4, 552
	add	x3, sp, 77824
	add	x3, x3, 3392
	add	x2, sp, 77824
	add	x2, x2, 2848
	add	x1, sp, 81920
	add	x1, x1, 1608
	add	x8, sp, 77824
	add	x8, x8, 2304
	add	x0, sp, 77824
	add	x0, x0, 2208
	str	x0, [sp]
	mov	x0, x8
	bl	crypto_ake_alice_receive
	ldr	w0, [sp, 28]
	add	w0, w0, 1
	str	w0, [sp, 28]
.L42:
	ldr	w1, [sp, 28]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L43
	adrp	x0, .LC12
	add	x0, x0, :lo12:.LC12
	bl	printf
	add	x0, sp, 32
	bl	print_cpucycles
	mov	w0, 10
	bl	putchar
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	add	x3, sp, 81920
	ldr	x4, [x3, 5144]
	ldr	x2, [x0]
	subs	x4, x4, x2
	mov	x2, 0
	beq	.L45
	bl	__stack_chk_fail
.L45:
	mov	w0, w1
	add	sp, sp, 1056
	.cfi_def_cfa_offset 86032
	add	sp, sp, 86016
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	test_ake_cpucycles, .-test_ake_cpucycles
	.section	.rodata
	.align	3
.LC13:
	.string	"test hash speed:"
	.align	3
.LC14:
	.string	"cpucycles: %f \n"
	.align	3
.LC15:
	.string	"CPB: %f \n"
	.text
	.align	2
	.global	test_hash_cpucycles
	.type	test_hash_cpucycles, %function
test_hash_cpucycles:
.LFB7:
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
	adrp	x8, :got:__stack_chk_guard
	ldr	x8, [x8, :got_lo12:__stack_chk_guard]
	ldr	x9, [x8]
	str	x9, [x29, -8]
	mov	x9, 0
	mov	x8, sp
	mov	x19, x8
	mov	w8, 1024
	str	w8, [x29, -112]
	mov	w8, 34464
	movk	w8, 0x1, lsl 16
	str	w8, [x29, -108]
	ldr	w8, [x29, -112]
	sxtw	x9, w8
	sub	x9, x9, #1
	str	x9, [x29, -104]
	sxtw	x9, w8
	mov	x6, x9
	mov	x7, 0
	lsr	x9, x6, 61
	lsl	x3, x7, 3
	orr	x3, x9, x3
	lsl	x2, x6, 3
	sxtw	x2, w8
	mov	x4, x2
	mov	x5, 0
	lsr	x2, x4, 61
	lsl	x1, x5, 3
	orr	x1, x2, x1
	lsl	x0, x4, 3
	sxtw	x0, w8
	add	x0, x0, 15
	lsr	x0, x0, 4
	lsl	x0, x0, 4
	and	x1, x0, -65536
	sub	x1, sp, x1
.L47:
	cmp	sp, x1
	beq	.L48
	sub	sp, sp, #65536
	str	xzr, [sp, 1024]
	b	.L47
.L48:
	and	x1, x0, 65535
	sub	sp, sp, x1
	str	xzr, [sp]
	and	x0, x0, 65535
	cmp	x0, 1024
	bcc	.L49
	str	xzr, [sp, 1024]
.L49:
	add	x0, sp, 16
	add	x0, x0, 0
	str	x0, [x29, -96]
	sub	x0, x29, #72
	mov	w1, 32
	bl	random_bytes
	ldr	w0, [x29, -112]
	sub	x1, x29, #72
	mov	x2, x1
	mov	w1, w0
	ldr	x0, [x29, -96]
	bl	pseudo_random_bytes
	bl	cpucycles
	str	x0, [x29, -88]
	str	wzr, [x29, -116]
	b	.L50
.L51:
	ldr	w0, [x29, -112]
	sub	x1, x29, #40
	mov	x2, x1
	mov	w1, w0
	ldr	x0, [x29, -96]
	bl	hash
	ldr	w0, [x29, -116]
	add	w0, w0, 1
	str	w0, [x29, -116]
.L50:
	ldr	w1, [x29, -116]
	ldr	w0, [x29, -108]
	cmp	w1, w0
	blt	.L51
	bl	cpucycles
	str	x0, [x29, -80]
	adrp	x0, .LC13
	add	x0, x0, :lo12:.LC13
	bl	puts
	ldr	x1, [x29, -80]
	ldr	x0, [x29, -88]
	sub	x0, x1, x0
	fmov	d0, x0
	ucvtf	d1, d0
	ldr	w0, [x29, -108]
	scvtf	d0, w0
	fdiv	d0, d1, d0
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	printf
	ldr	x1, [x29, -80]
	ldr	x0, [x29, -88]
	sub	x0, x1, x0
	fmov	d0, x0
	ucvtf	d1, d0
	ldr	w0, [x29, -108]
	scvtf	d2, w0
	ldr	w0, [x29, -112]
	scvtf	d0, w0
	fmul	d0, d2, d0
	fdiv	d0, d1, d0
	adrp	x0, .LC15
	add	x0, x0, :lo12:.LC15
	bl	printf
	mov	w0, 10
	bl	putchar
	mov	w0, 0
	mov	sp, x19
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [x29, -8]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L53
	bl	__stack_chk_fail
.L53:
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
.LFE7:
	.size	test_hash_cpucycles, .-test_hash_cpucycles
	.section	.rodata
	.align	3
.LC16:
	.string	"test aes speed:"
	.text
	.align	2
	.global	test_aes_cpucycles
	.type	test_aes_cpucycles, %function
test_aes_cpucycles:
.LFB8:
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
	adrp	x8, :got:__stack_chk_guard
	ldr	x8, [x8, :got_lo12:__stack_chk_guard]
	ldr	x9, [x8]
	str	x9, [x29, -8]
	mov	x9, 0
	mov	x8, sp
	mov	x19, x8
	mov	w8, 512
	str	w8, [x29, -80]
	mov	w8, 34464
	movk	w8, 0x1, lsl 16
	str	w8, [x29, -76]
	ldr	w8, [x29, -80]
	sxtw	x9, w8
	sub	x9, x9, #1
	str	x9, [x29, -72]
	sxtw	x9, w8
	mov	x6, x9
	mov	x7, 0
	lsr	x9, x6, 61
	lsl	x3, x7, 3
	orr	x3, x9, x3
	lsl	x2, x6, 3
	sxtw	x2, w8
	mov	x4, x2
	mov	x5, 0
	lsr	x2, x4, 61
	lsl	x1, x5, 3
	orr	x1, x2, x1
	lsl	x0, x4, 3
	sxtw	x0, w8
	add	x0, x0, 15
	lsr	x0, x0, 4
	lsl	x0, x0, 4
	and	x1, x0, -65536
	sub	x1, sp, x1
.L55:
	cmp	sp, x1
	beq	.L56
	sub	sp, sp, #65536
	str	xzr, [sp, 1024]
	b	.L55
.L56:
	and	x1, x0, 65535
	sub	sp, sp, x1
	str	xzr, [sp]
	and	x0, x0, 65535
	cmp	x0, 1024
	bcc	.L57
	str	xzr, [sp, 1024]
.L57:
	add	x0, sp, 16
	add	x0, x0, 0
	str	x0, [x29, -64]
	sub	x0, x29, #40
	mov	w1, 32
	bl	random_bytes
	bl	cpucycles
	str	x0, [x29, -56]
	str	wzr, [x29, -84]
	b	.L58
.L59:
	ldr	w0, [x29, -80]
	sub	x1, x29, #40
	mov	x2, x1
	mov	w1, w0
	ldr	x0, [x29, -64]
	bl	pseudo_random_bytes
	ldr	w0, [x29, -84]
	add	w0, w0, 1
	str	w0, [x29, -84]
.L58:
	ldr	w1, [x29, -84]
	ldr	w0, [x29, -76]
	cmp	w1, w0
	blt	.L59
	bl	cpucycles
	str	x0, [x29, -48]
	adrp	x0, .LC16
	add	x0, x0, :lo12:.LC16
	bl	puts
	ldr	x1, [x29, -48]
	ldr	x0, [x29, -56]
	sub	x0, x1, x0
	fmov	d0, x0
	ucvtf	d1, d0
	ldr	w0, [x29, -76]
	scvtf	d0, w0
	fdiv	d0, d1, d0
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	printf
	ldr	x1, [x29, -48]
	ldr	x0, [x29, -56]
	sub	x0, x1, x0
	fmov	d0, x0
	ucvtf	d1, d0
	ldr	w0, [x29, -76]
	scvtf	d2, w0
	ldr	w0, [x29, -80]
	scvtf	d0, w0
	fmul	d0, d2, d0
	fdiv	d0, d1, d0
	adrp	x0, .LC15
	add	x0, x0, :lo12:.LC15
	bl	printf
	mov	w0, 10
	bl	putchar
	mov	w0, 0
	mov	sp, x19
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [x29, -8]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L61
	bl	__stack_chk_fail
.L61:
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
.LFE8:
	.size	test_aes_cpucycles, .-test_aes_cpucycles
	.section	.rodata
	.align	3
.LC17:
	.string	"test gen_psi speed:"
	.text
	.align	2
	.global	test_gen_psi_cpucycles
	.type	test_gen_psi_cpucycles, %function
test_gen_psi_cpucycles:
.LFB9:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #576
	.cfi_def_cfa_offset 592
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 568]
	mov	x1, 0
	mov	w0, 34464
	movk	w0, 0x1, lsl 16
	str	w0, [sp, 4]
	add	x0, sp, 24
	mov	w1, 32
	bl	random_bytes
	bl	cpucycles
	str	x0, [sp, 8]
	str	wzr, [sp]
	b	.L63
.L64:
	add	x1, sp, 24
	add	x0, sp, 56
	mov	x2, x1
	mov	w1, 512
	bl	gen_psi_fix_ham
	ldr	w0, [sp]
	add	w0, w0, 1
	str	w0, [sp]
.L63:
	ldr	w1, [sp]
	ldr	w0, [sp, 4]
	cmp	w1, w0
	blt	.L64
	bl	cpucycles
	str	x0, [sp, 16]
	adrp	x0, .LC17
	add	x0, x0, :lo12:.LC17
	bl	puts
	ldr	x1, [sp, 16]
	ldr	x0, [sp, 8]
	sub	x0, x1, x0
	fmov	d0, x0
	ucvtf	d1, d0
	ldr	w0, [sp, 4]
	scvtf	d0, w0
	fdiv	d0, d1, d0
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	printf
	mov	w0, 10
	bl	putchar
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 568]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L66
	bl	__stack_chk_fail
.L66:
	mov	w0, w1
	add	sp, sp, 576
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE9:
	.size	test_gen_psi_cpucycles, .-test_gen_psi_cpucycles
	.section	.rodata
	.align	3
.LC18:
	.string	"test gen_a speed:"
	.text
	.align	2
	.global	test_gen_a_cpucycles
	.type	test_gen_a_cpucycles, %function
test_gen_a_cpucycles:
.LFB10:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #592
	.cfi_def_cfa_offset 608
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 584]
	mov	x1, 0
	mov	w0, 34464
	movk	w0, 0x1, lsl 16
	str	w0, [sp, 12]
	add	x0, sp, 40
	mov	w1, 32
	bl	random_bytes
	str	xzr, [sp, 16]
	str	wzr, [sp, 8]
	b	.L68
.L69:
	bl	cpucycles
	str	x0, [sp, 24]
	add	x1, sp, 40
	add	x0, sp, 72
	bl	gen_a
	bl	cpucycles
	str	x0, [sp, 32]
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 24]
	sub	x0, x1, x0
	ldr	x1, [sp, 16]
	add	x0, x1, x0
	str	x0, [sp, 16]
	ldr	w0, [sp, 8]
	add	w0, w0, 1
	str	w0, [sp, 8]
.L68:
	ldr	w1, [sp, 8]
	ldr	w0, [sp, 12]
	cmp	w1, w0
	blt	.L69
	adrp	x0, .LC18
	add	x0, x0, :lo12:.LC18
	bl	puts
	ldr	d0, [sp, 16]
	ucvtf	d1, d0
	ldr	w0, [sp, 12]
	scvtf	d0, w0
	fdiv	d0, d1, d0
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	printf
	mov	w0, 10
	bl	putchar
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 584]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L71
	bl	__stack_chk_fail
.L71:
	mov	w0, w1
	add	sp, sp, 592
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE10:
	.size	test_gen_a_cpucycles, .-test_gen_a_cpucycles
	.section	.rodata
	.align	3
.LC19:
	.string	"test poly_nul speed:"
	.text
	.align	2
	.global	test_poly_mul_cpucycles
	.type	test_poly_mul_cpucycles, %function
test_poly_mul_cpucycles:
.LFB11:
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
	mov	w0, 34464
	movk	w0, 0x1, lsl 16
	str	w0, [sp, 12]
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
	str	xzr, [sp, 16]
	str	wzr, [sp, 8]
	b	.L73
.L74:
	bl	cpucycles
	str	x0, [sp, 24]
	add	x2, sp, 584
	add	x1, sp, 1096
	add	x0, sp, 72
	mov	w3, 512
	bl	poly_mul
	bl	cpucycles
	str	x0, [sp, 32]
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 24]
	sub	x0, x1, x0
	ldr	x1, [sp, 16]
	add	x0, x1, x0
	str	x0, [sp, 16]
	ldr	w0, [sp, 8]
	add	w0, w0, 1
	str	w0, [sp, 8]
.L73:
	ldr	w1, [sp, 8]
	ldr	w0, [sp, 12]
	cmp	w1, w0
	blt	.L74
	adrp	x0, .LC19
	add	x0, x0, :lo12:.LC19
	bl	puts
	ldr	d0, [sp, 16]
	ucvtf	d1, d0
	ldr	w0, [sp, 12]
	scvtf	d0, w0
	fdiv	d0, d1, d0
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	printf
	mov	w0, 10
	bl	putchar
	mov	w0, 0
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 1608]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L76
	bl	__stack_chk_fail
.L76:
	mov	w0, w1
	add	sp, sp, 1616
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE11:
	.size	test_poly_mul_cpucycles, .-test_poly_mul_cpucycles
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits

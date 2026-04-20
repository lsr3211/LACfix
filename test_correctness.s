	.arch armv8-a
	.file	"test_correctness.c"
	.text
	.global	loop
	.data
	.align	3
	.type	loop, %object
	.size	loop, 8
loop:
	.xword	1
	.section	.rodata
	.align	3
.LC0:
	.string	"%u"
	.text
	.align	2
	.type	print_uint64, %function
print_uint64:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x0, [sp, 24]
	ldr	x0, [sp, 24]
	cmp	x0, 9
	bls	.L2
	ldr	x1, [sp, 24]
	mov	x0, -3689348814741910324
	movk	x0, 0xcccd, lsl 0
	umulh	x0, x1, x0
	lsr	x0, x0, 3
	bl	print_uint64
.L2:
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
.LFE0:
	.size	print_uint64, .-print_uint64
	.align	2
	.global	error_bit_num
	.type	error_bit_num, %function
error_bit_num:
.LFB1:
	.cfi_startproc
	sub	sp, sp, #48
	.cfi_def_cfa_offset 48
	str	x0, [sp, 24]
	str	x1, [sp, 16]
	str	w2, [sp, 12]
	str	wzr, [sp, 44]
	str	wzr, [sp, 40]
	b	.L4
.L6:
	ldrsw	x0, [sp, 40]
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldrb	w1, [x0]
	ldrsw	x0, [sp, 40]
	ldr	x2, [sp, 16]
	add	x0, x2, x0
	ldrb	w0, [x0]
	eor	w0, w1, w0
	strb	w0, [sp, 39]
	ldrb	w0, [sp, 39]
	cmp	w0, 0
	beq	.L5
	ldrb	w0, [sp, 39]
	and	w0, w0, 1
	ldr	w1, [sp, 44]
	add	w0, w1, w0
	str	w0, [sp, 44]
	ldrb	w0, [sp, 39]
	lsr	w0, w0, 1
	and	w0, w0, 255
	and	w0, w0, 1
	ldr	w1, [sp, 44]
	add	w0, w1, w0
	str	w0, [sp, 44]
	ldrb	w0, [sp, 39]
	lsr	w0, w0, 2
	and	w0, w0, 255
	and	w0, w0, 1
	ldr	w1, [sp, 44]
	add	w0, w1, w0
	str	w0, [sp, 44]
	ldrb	w0, [sp, 39]
	lsr	w0, w0, 3
	and	w0, w0, 255
	and	w0, w0, 1
	ldr	w1, [sp, 44]
	add	w0, w1, w0
	str	w0, [sp, 44]
	ldrb	w0, [sp, 39]
	lsr	w0, w0, 4
	and	w0, w0, 255
	and	w0, w0, 1
	ldr	w1, [sp, 44]
	add	w0, w1, w0
	str	w0, [sp, 44]
	ldrb	w0, [sp, 39]
	lsr	w0, w0, 5
	and	w0, w0, 255
	and	w0, w0, 1
	ldr	w1, [sp, 44]
	add	w0, w1, w0
	str	w0, [sp, 44]
	ldrb	w0, [sp, 39]
	lsr	w0, w0, 6
	and	w0, w0, 255
	and	w0, w0, 1
	ldr	w1, [sp, 44]
	add	w0, w1, w0
	str	w0, [sp, 44]
	ldrb	w0, [sp, 39]
	lsr	w0, w0, 7
	and	w0, w0, 255
	and	w0, w0, 1
	ldr	w1, [sp, 44]
	add	w0, w1, w0
	str	w0, [sp, 44]
.L5:
	ldr	w0, [sp, 40]
	add	w0, w0, 1
	str	w0, [sp, 40]
.L4:
	ldr	w1, [sp, 40]
	ldr	w0, [sp, 12]
	cmp	w1, w0
	blt	.L6
	ldr	w0, [sp, 44]
	add	sp, sp, 48
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE1:
	.size	error_bit_num, .-error_bit_num
	.section	.rodata
	.align	3
.LC1:
	.string	"\nerror bit:"
	.align	3
.LC2:
	.string	"%d%d%d%d%d%d%d%d"
	.text
	.align	2
	.global	print_error_bit
	.type	print_error_bit, %function
print_error_bit:
.LFB2:
	.cfi_startproc
	sub	sp, sp, #80
	.cfi_def_cfa_offset 80
	stp	x29, x30, [sp, 16]
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	add	x29, sp, 16
	str	x0, [sp, 56]
	str	x1, [sp, 48]
	str	w2, [sp, 44]
	str	wzr, [sp, 76]
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	puts
	str	wzr, [sp, 72]
	b	.L9
.L10:
	ldrsw	x0, [sp, 72]
	ldr	x1, [sp, 56]
	add	x0, x1, x0
	ldrb	w1, [x0]
	ldrsw	x0, [sp, 72]
	ldr	x2, [sp, 48]
	add	x0, x2, x0
	ldrb	w0, [x0]
	eor	w0, w1, w0
	strb	w0, [sp, 71]
	ldrb	w0, [sp, 71]
	and	w1, w0, 1
	ldrb	w0, [sp, 71]
	lsr	w0, w0, 1
	and	w0, w0, 255
	and	w2, w0, 1
	ldrb	w0, [sp, 71]
	lsr	w0, w0, 2
	and	w0, w0, 255
	and	w3, w0, 1
	ldrb	w0, [sp, 71]
	lsr	w0, w0, 3
	and	w0, w0, 255
	and	w4, w0, 1
	ldrb	w0, [sp, 71]
	lsr	w0, w0, 4
	and	w0, w0, 255
	and	w5, w0, 1
	ldrb	w0, [sp, 71]
	lsr	w0, w0, 5
	and	w0, w0, 255
	and	w6, w0, 1
	ldrb	w0, [sp, 71]
	lsr	w0, w0, 6
	and	w0, w0, 255
	and	w7, w0, 1
	ldrb	w0, [sp, 71]
	lsr	w0, w0, 7
	and	w0, w0, 255
	and	w0, w0, 1
	str	w0, [sp]
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	printf
	ldr	w0, [sp, 72]
	add	w0, w0, 1
	str	w0, [sp, 72]
.L9:
	ldr	w1, [sp, 72]
	ldr	w0, [sp, 44]
	cmp	w1, w0
	blt	.L10
	mov	w0, 10
	bl	putchar
	ldr	w0, [sp, 76]
	ldp	x29, x30, [sp, 16]
	add	sp, sp, 80
	.cfi_restore 29
	.cfi_restore 30
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE2:
	.size	print_error_bit, .-print_error_bit
	.section	.rodata
	.align	3
.LC3:
	.string	"%d "
	.text
	.align	2
	.global	print_bytes
	.type	print_bytes, %function
print_bytes:
.LFB3:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	str	x0, [sp, 24]
	str	w1, [sp, 20]
	str	wzr, [sp, 44]
	b	.L13
.L14:
	ldrsw	x0, [sp, 44]
	ldr	x1, [sp, 24]
	add	x0, x1, x0
	ldrb	w0, [x0]
	mov	w1, w0
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	printf
	ldr	w0, [sp, 44]
	add	w0, w0, 1
	str	w0, [sp, 44]
.L13:
	ldr	w1, [sp, 44]
	ldr	w0, [sp, 20]
	cmp	w1, w0
	blt	.L14
	mov	w0, 10
	bl	putchar
	mov	w0, 0
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE3:
	.size	print_bytes, .-print_bytes
	.section	.rodata
	.align	3
.LC4:
	.string	"correctness test of pke:"
	.align	3
.LC5:
	.string	"error bit num:"
	.align	3
.LC6:
	.string	"test %d error block:"
	.align	3
.LC7:
	.string	" error bit:"
	.align	3
.LC8:
	.string	"total error bit:"
	.align	3
.LC9:
	.string	"\n"
	.text
	.align	2
	.global	test_pke_correctness
	.type	test_pke_correctness, %function
test_pke_correctness:
.LFB4:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #2448
	.cfi_def_cfa_offset 2464
	str	xzr, [sp, 1024]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 2440]
	mov	x1, 0
	str	xzr, [sp, 32]
	str	xzr, [sp, 40]
	mov	x0, 32
	str	x0, [sp, 16]
	mov	x0, 712
	str	x0, [sp, 24]
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	puts
	str	wzr, [sp, 12]
	b	.L17
.L21:
	add	x1, sp, 1384
	add	x0, sp, 128
	bl	crypto_encrypt_keypair
	add	x0, sp, 64
	mov	w1, 32
	bl	random_bytes
	str	wzr, [sp, 8]
	b	.L18
.L20:
	ldr	x3, [sp, 16]
	add	x4, sp, 128
	add	x2, sp, 64
	add	x1, sp, 24
	add	x0, sp, 672
	bl	crypto_encrypt
	ldr	x3, [sp, 24]
	add	x4, sp, 1384
	add	x2, sp, 672
	add	x1, sp, 16
	add	x0, sp, 96
	bl	crypto_encrypt_open
	add	x1, sp, 96
	add	x0, sp, 64
	mov	x2, 32
	bl	memcmp
	cmp	w0, 0
	beq	.L19
	ldr	x0, [sp, 40]
	add	x0, x0, 1
	str	x0, [sp, 40]
	add	x1, sp, 96
	add	x0, sp, 64
	mov	w2, 32
	bl	error_bit_num
	sxtw	x0, w0
	str	x0, [sp, 56]
	ldr	x1, [sp, 32]
	ldr	x0, [sp, 56]
	add	x0, x1, x0
	str	x0, [sp, 32]
	ldr	x0, [sp, 56]
	cmp	x0, 0
	ble	.L19
	adrp	x0, .LC5
	add	x0, x0, :lo12:.LC5
	bl	printf
	ldr	x0, [sp, 56]
	bl	print_uint64
	mov	w0, 10
	bl	putchar
	add	x1, sp, 96
	add	x0, sp, 64
	mov	w2, 32
	bl	print_error_bit
.L19:
	ldr	w0, [sp, 8]
	add	w0, w0, 1
	str	w0, [sp, 8]
.L18:
	ldr	w1, [sp, 8]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L20
	ldr	w0, [sp, 12]
	add	w0, w0, 1
	mov	w1, w0
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printf
	ldr	x0, [sp, 40]
	bl	print_uint64
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
	bl	printf
	ldr	x0, [sp, 32]
	bl	print_uint64
	mov	w0, 10
	bl	putchar
	ldr	w0, [sp, 12]
	add	w0, w0, 1
	str	w0, [sp, 12]
.L17:
	ldrsw	x1, [sp, 12]
	adrp	x0, loop
	add	x0, x0, :lo12:loop
	ldr	x0, [x0]
	cmp	x1, x0
	bcc	.L21
	adrp	x0, loop
	add	x0, x0, :lo12:loop
	ldr	x1, [x0]
	mov	x0, 4096
	movk	x0, 0x27, lsl 16
	mul	x0, x1, x0
	str	x0, [sp, 48]
	adrp	x0, .LC8
	add	x0, x0, :lo12:.LC8
	bl	printf
	ldr	x0, [sp, 32]
	bl	print_uint64
	mov	w0, 47
	bl	putchar
	ldr	x0, [sp, 48]
	bl	print_uint64
	adrp	x0, .LC9
	add	x0, x0, :lo12:.LC9
	bl	puts
	ldr	x0, [sp, 40]
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 2440]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L23
	bl	__stack_chk_fail
.L23:
	mov	w0, w1
	add	sp, sp, 2448
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE4:
	.size	test_pke_correctness, .-test_pke_correctness
	.section	.rodata
	.align	3
.LC10:
	.string	"correctness test of kem_fo:"
	.text
	.align	2
	.global	test_kem_fo_correctness
	.type	test_kem_fo_correctness, %function
test_kem_fo_correctness:
.LFB5:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #2400
	.cfi_def_cfa_offset 2416
	str	xzr, [sp, 1024]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 2392]
	mov	x1, 0
	str	xzr, [sp, 8]
	adrp	x0, .LC10
	add	x0, x0, :lo12:.LC10
	bl	puts
	str	wzr, [sp, 4]
	b	.L25
.L29:
	add	x1, sp, 1336
	add	x0, sp, 80
	bl	crypto_kem_keypair
	add	x0, sp, 16
	mov	w1, 32
	bl	random_bytes
	str	wzr, [sp]
	b	.L26
.L28:
	add	x2, sp, 80
	add	x1, sp, 16
	add	x0, sp, 624
	bl	crypto_kem_enc
	add	x2, sp, 1336
	add	x1, sp, 624
	add	x0, sp, 48
	bl	crypto_kem_dec
	add	x1, sp, 48
	add	x0, sp, 16
	mov	x2, 32
	bl	memcmp
	cmp	w0, 0
	beq	.L27
	ldr	x0, [sp, 8]
	add	x0, x0, 1
	str	x0, [sp, 8]
.L27:
	ldr	w0, [sp]
	add	w0, w0, 1
	str	w0, [sp]
.L26:
	ldr	w1, [sp]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L28
	ldr	w0, [sp, 4]
	add	w0, w0, 1
	mov	w1, w0
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printf
	ldr	x0, [sp, 8]
	bl	print_uint64
	mov	w0, 10
	bl	putchar
	ldr	w0, [sp, 4]
	add	w0, w0, 1
	str	w0, [sp, 4]
.L25:
	ldrsw	x1, [sp, 4]
	adrp	x0, loop
	add	x0, x0, :lo12:loop
	ldr	x0, [x0]
	cmp	x1, x0
	bcc	.L29
	mov	w0, 10
	bl	putchar
	ldr	x0, [sp, 8]
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 2392]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L31
	bl	__stack_chk_fail
.L31:
	mov	w0, w1
	add	sp, sp, 2400
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE5:
	.size	test_kem_fo_correctness, .-test_kem_fo_correctness
	.section	.rodata
	.align	3
.LC11:
	.string	"correctness test of ke:"
	.text
	.align	2
	.global	test_ke_correctness
	.type	test_ke_correctness, %function
test_ke_correctness:
.LFB6:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	sub	sp, sp, #2400
	.cfi_def_cfa_offset 2416
	str	xzr, [sp, 1024]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 2392]
	mov	x1, 0
	str	xzr, [sp, 8]
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	puts
	str	wzr, [sp, 4]
	b	.L33
.L37:
	str	wzr, [sp]
	b	.L34
.L36:
	add	x1, sp, 1336
	add	x0, sp, 80
	bl	crypto_ke_alice_send
	add	x2, sp, 16
	add	x1, sp, 624
	add	x0, sp, 80
	bl	crypto_ke_bob_receive
	add	x3, sp, 48
	add	x2, sp, 624
	add	x1, sp, 1336
	add	x0, sp, 80
	bl	crypto_ke_alice_receive
	add	x1, sp, 48
	add	x0, sp, 16
	mov	x2, 32
	bl	memcmp
	cmp	w0, 0
	beq	.L35
	ldr	x0, [sp, 8]
	add	x0, x0, 1
	str	x0, [sp, 8]
.L35:
	ldr	w0, [sp]
	add	w0, w0, 1
	str	w0, [sp]
.L34:
	ldr	w1, [sp]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L36
	ldr	w0, [sp, 4]
	add	w0, w0, 1
	mov	w1, w0
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printf
	ldr	x0, [sp, 8]
	bl	print_uint64
	mov	w0, 10
	bl	putchar
	ldr	w0, [sp, 4]
	add	w0, w0, 1
	str	w0, [sp, 4]
.L33:
	ldrsw	x1, [sp, 4]
	adrp	x0, loop
	add	x0, x0, :lo12:loop
	ldr	x0, [x0]
	cmp	x1, x0
	bcc	.L37
	mov	w0, 10
	bl	putchar
	ldr	x0, [sp, 8]
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 2392]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L39
	bl	__stack_chk_fail
.L39:
	mov	w0, w1
	add	sp, sp, 2400
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE6:
	.size	test_ke_correctness, .-test_ke_correctness
	.section	.rodata
	.align	3
.LC12:
	.string	"correctness test of ake:"
	.text
	.align	2
	.global	test_ake_correctness
	.type	test_ake_correctness, %function
test_ake_correctness:
.LFB7:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x29, sp
	mov	x13, 7072
	sub	sp, sp, x13
	.cfi_def_cfa_offset 7088
	str	xzr, [sp, 1024]
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x1, [x0]
	str	x1, [sp, 7064]
	mov	x1, 0
	str	xzr, [sp, 24]
	add	x1, sp, 3528
	add	x0, sp, 128
	bl	crypto_encrypt_keypair
	add	x1, sp, 4096
	add	x1, x1, 488
	add	x0, sp, 672
	bl	crypto_encrypt_keypair
	adrp	x0, .LC12
	add	x0, x0, :lo12:.LC12
	bl	puts
	str	wzr, [sp, 20]
	b	.L41
.L45:
	str	wzr, [sp, 16]
	b	.L42
.L44:
	add	x5, sp, 96
	add	x4, sp, 1760
	add	x3, sp, 3528
	add	x2, sp, 672
	add	x1, sp, 2472
	add	x0, sp, 1216
	bl	crypto_ake_alice_send
	add	x6, sp, 64
	add	x5, sp, 4096
	add	x5, x5, 1544
	add	x4, sp, 1760
	add	x3, sp, 1216
	add	x2, sp, 128
	add	x1, sp, 4096
	add	x1, x1, 488
	add	x0, sp, 672
	bl	crypto_ake_bob_receive
	add	x7, sp, 96
	add	x6, sp, 4096
	add	x6, x6, 1544
	add	x5, sp, 1760
	add	x4, sp, 2472
	add	x3, sp, 1216
	add	x2, sp, 672
	add	x1, sp, 3528
	add	x8, sp, 128
	add	x0, sp, 32
	str	x0, [sp]
	mov	x0, x8
	bl	crypto_ake_alice_receive
	add	x1, sp, 32
	add	x0, sp, 64
	mov	x2, 32
	bl	memcmp
	cmp	w0, 0
	beq	.L43
	ldr	x0, [sp, 24]
	add	x0, x0, 1
	str	x0, [sp, 24]
.L43:
	ldr	w0, [sp, 16]
	add	w0, w0, 1
	str	w0, [sp, 16]
.L42:
	ldr	w1, [sp, 16]
	mov	w0, 9999
	cmp	w1, w0
	ble	.L44
	ldr	w0, [sp, 20]
	add	w0, w0, 1
	mov	w1, w0
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printf
	ldr	x0, [sp, 24]
	bl	print_uint64
	mov	w0, 10
	bl	putchar
	ldr	w0, [sp, 20]
	add	w0, w0, 1
	str	w0, [sp, 20]
.L41:
	ldrsw	x1, [sp, 20]
	adrp	x0, loop
	add	x0, x0, :lo12:loop
	ldr	x0, [x0]
	cmp	x1, x0
	bcc	.L45
	mov	w0, 10
	bl	putchar
	ldr	x0, [sp, 24]
	mov	w1, w0
	adrp	x0, :got:__stack_chk_guard
	ldr	x0, [x0, :got_lo12:__stack_chk_guard]
	ldr	x3, [sp, 7064]
	ldr	x2, [x0]
	subs	x3, x3, x2
	mov	x2, 0
	beq	.L47
	bl	__stack_chk_fail
.L47:
	mov	w0, w1
	mov	x13, 7072
	add	sp, sp, x13
	.cfi_def_cfa_offset 16
	ldp	x29, x30, [sp], 16
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE7:
	.size	test_ake_correctness, .-test_ake_correctness
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits

	.arch armv8-a
	.file	"main.c"
	.text
	.section	.rodata
	.align	3
.LC0:
	.string	"command format:"
	.align	3
.LC1:
	.string	"lac speed : test the speed of lac"
	.align	3
.LC2:
	.string	"lac cpucycles: test the cpucycles of lac"
	.align	3
.LC3:
	.string	"lac correctness: test the correctness of lac"
	.align	3
.LC4:
	.string	"lac basicblock: test the speed of basic blocks used in lac"
	.align	3
.LC5:
	.string	"LAC128"
	.align	3
.LC6:
	.string	"============== test %s ==============\n\n"
	.align	3
.LC7:
	.string	"speed"
	.align	3
.LC8:
	.string	"cpucycles"
	.align	3
.LC9:
	.string	"correctness"
	.align	3
.LC10:
	.string	"basicblock"
	.align	3
.LC11:
	.string	"============================================"
	.text
	.align	2
	.global	main
	.type	main, %function
main:
.LFB0:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	w0, [sp, 28]
	str	x1, [sp, 16]
	ldr	w0, [sp, 28]
	cmp	w0, 2
	beq	.L2
	adrp	x0, .LC0
	add	x0, x0, :lo12:.LC0
	bl	puts
	adrp	x0, .LC1
	add	x0, x0, :lo12:.LC1
	bl	puts
	adrp	x0, .LC2
	add	x0, x0, :lo12:.LC2
	bl	puts
	adrp	x0, .LC3
	add	x0, x0, :lo12:.LC3
	bl	puts
	adrp	x0, .LC4
	add	x0, x0, :lo12:.LC4
	bl	puts
	b	.L3
.L2:
	adrp	x0, .LC5
	add	x1, x0, :lo12:.LC5
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	bl	printf
	ldr	x0, [sp, 16]
	add	x0, x0, 8
	ldr	x2, [x0]
	adrp	x0, .LC7
	add	x1, x0, :lo12:.LC7
	mov	x0, x2
	bl	strcmp
	cmp	w0, 0
	bne	.L4
	bl	test_pke_speed
	bl	test_kem_fo_speed
	bl	test_ke_speed
	bl	test_ake_speed
.L4:
	ldr	x0, [sp, 16]
	add	x0, x0, 8
	ldr	x2, [x0]
	adrp	x0, .LC8
	add	x1, x0, :lo12:.LC8
	mov	x0, x2
	bl	strcmp
	cmp	w0, 0
	bne	.L5
	bl	test_pke_cpucycles
	bl	test_kem_fo_cpucycles
	bl	test_ke_cpucycles
	bl	test_ake_cpucycles
.L5:
	ldr	x0, [sp, 16]
	add	x0, x0, 8
	ldr	x2, [x0]
	adrp	x0, .LC9
	add	x1, x0, :lo12:.LC9
	mov	x0, x2
	bl	strcmp
	cmp	w0, 0
	bne	.L6
	bl	test_pke_correctness
	bl	test_kem_fo_correctness
	bl	test_ke_correctness
	bl	test_ake_correctness
.L6:
	ldr	x0, [sp, 16]
	add	x0, x0, 8
	ldr	x2, [x0]
	adrp	x0, .LC10
	add	x1, x0, :lo12:.LC10
	mov	x0, x2
	bl	strcmp
	cmp	w0, 0
	bne	.L7
	bl	test_gen_psi_cpucycles
	bl	test_gen_a_cpucycles
	bl	test_poly_mul_cpucycles
	bl	test_poly_mul_speed
.L7:
	adrp	x0, .LC11
	add	x0, x0, :lo12:.LC11
	bl	puts
.L3:
	mov	w0, 0
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0"
	.section	.note.GNU-stack,"",@progbits

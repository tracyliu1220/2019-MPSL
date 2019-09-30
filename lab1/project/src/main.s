.data
	arr1: .byte 0x19, 0x34, 0x14, 0x32, 0x52, 0x23, 0x61, 0x29
	arr2: .byte 0x18, 0x17, 0x33, 0x16, 0xFA, 0x20, 0x55, 0xAC
	Zero: .word 0
.text
	.global main

swap:
	cmp R4, R5
	blt ret
	movs R7, R4
	movs R4, R5
	movs R5, R7
	b ret

// i: R1, j: R2
do_sort:
//TODO
	movs R1, R6
	loopI:
		movs R2, R6
		loopJ:
			add R3, R2, #1
			ldrb R4, [R0, R2]
			ldrb R5, [R0, R3]

			b swap

			ret:

			strb R4, [R0, R2]
			strb R5, [R0, R3]

			add R2, #1
			cmp R2, #7
			// cmp R2, #3
			blt loopJ
		add R1, #1
		cmp R1, #8
		// cmp R1, #3
		blt loopI
	bx lr

print:
	ldrb R2, [R0, R1]
	add R1, #1
	ldrb R3, [R0, R1]
	add R1, #1
	ldrb R4, [R0, R1]
	add R1, #1
	ldrb R5, [R0, R1]
	add R1, #1
	ldrb R2, [R0, R1]
	add R1, #1
	ldrb R3, [R0, R1]
	add R1, #1
	ldrb R4, [R0, R1]
	add R1, #1
	ldrb R5, [R0, R1]
	add R1, #1
	bx lr

main:
	ldr R0, =Zero
	ldr R6, [R0]
	ldr R0, =arr1
	bl do_sort
	movs R1, R6
	bl print
	ldr R0, =arr2
	bl do_sort
	movs R1, R6
	bl print

L:
	b L

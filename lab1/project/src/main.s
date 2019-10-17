	.syntax unified
	.cpu cortex-m4
	.thumb

.data
	result: .byte 0
	X: .word 0x00000011
	Y: .word 0x00000022
	One: .word 0x0001

.text
	.global main
	.equ A, 0x12345678

hamm:
	movs R2, R1
	and R2, R3
	add R4, R2
	lsr R1, R1, #1
	// cbnz R1, hamm
	cmp R1, #0
 	bne hamm
	bx lr

main:
	movs R7, #0xFFFFFFFF
	ldr R0, =X
	ldr R1, [R0] // R1 = X
	ldr R0, =Y
	ldr R2, [R0] // R2 = Y
	ldr R0, =One
	ldr R3, [R0]
	eor R1, R1, R2

	ldr R0, =result
	ldrb R4, [R0]
	ldr R5, =A

	bl hamm

	strb R4, [R0]

L:
	nop
	b L

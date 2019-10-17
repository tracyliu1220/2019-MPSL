/*

	.syntax unified
	.cpu cortex-m4
	.thumb

.text
	.global main
	.equ RCC_AHB2ENR, 0x4002104C
	.equ GPIOA_MODER, 0x48000000
	.equ GPIOB_MODER, 0x48000400
	.equ GPIOA_ODR, 0x48000014
	.equ GPIOB_ODR, 0x48000414

main:
	ldr R0, =RCC_AHB2ENR
	mov R1, #0x2
	str R1, [R0]

	ldr R0, =GPIOB_MODER
	movs R1, #0x400
	ldr R2, [R0]
	and R2, #0xFFFFF3FF
	orrs R2, R2, R1
	str R2, [R0]

	ldr R0, =GPIOB_ODR

L:
	movs R1, #(1<<5)
	strh R1, [R0]

	movs R1, #0
	strh R1, [R0]

	B L

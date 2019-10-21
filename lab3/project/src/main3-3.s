/*
	.syntax unified
	.cpu cortex-m4
	.thumb

.data

.text
	.global main
	.equ RCC_AHB2ENR, 0x4002104C
	.equ GPIOB_MODER, 0x48000400
	.equ GPIOC_MODER, 0x48000800
	.equ GPIOA_ODR, 0x48000014
	.equ GPIOB_ODR, 0x48000414
	.equ GPIOB_IDR, 0x48000410
	.equ GPIOC_IDR, 0x48000810
	.equ password, 0xC

main:
	bl	GPIO_init

	Start:
	mov 	R7, #0
	bl	Read_Button
	bl	Check_Password
	//ldr	R0, =GPIOB_IDR
	//LL:
	//	ldr	R1, [R0]
	//	b	LL


GPIO_init:
	ldr	R0, =RCC_AHB2ENR
	mov	R1, #0x6
	str	R1, [R0]

	ldr	R0, =GPIOB_MODER
	movs	R1, #0x400
	ldr	R2, [R0]
	// 0xFFFFF3C0
	//and	R2, #0xFFFFF3FF // 0xF3FFFC00
	//and	R2, #0xFFFFFFC0
	mov	R2, #0
	orrs	R2, R2, R1
	str	R2, [R0]

	ldr	R0, =GPIOC_MODER
	ldr	R2, [R0]
	and	R2, #0xF3FFFFFF
	str	R2, [R0]

	mov	R7, #0
	ldr	R5, =GPIOC_IDR

	bx	LR

Read_Button:
	ldr	R6, [R5]
	asr	R6, #13
	and	R6, #1
	cmp	R6, #0
	beq	Zero

	One:
	cmp	R7, #(1<<13)
	mov	R7, #0
	bgt	Trigger
	b	Read_Button

	Zero:
	add	R7, #1
	b	Read_Button

	Trigger:
	bx	LR

Check_Password:
	ldr	R0, =GPIOB_IDR
	ldr	R6, [R0]

	mov	R7, #0

	// 1, 2
	mov	R8, R6
	and	R8, #6
	asr	R8, #1
	eor	R7, R8

	// 11, 12
	mov	R8, R6
	and	R8, #6144
	asr	R8, #9
	eor	R7, R8

	eor 	R7, #password
	cmp	R7, #15
	bne	Wrong
	bl	light
	bl	light
	Wrong:
	bl	light
	b 	Start

light:
	ldr	R0, =GPIOB_ODR
	// turn on
	ldr	R2, [R0]
	orr	R2, #(1<<5)
	strh	R2, [R0]
	mov	R7, #(1<<18)
	LoopOn:
	sub	R7, #1
	cmp	R7, #0
	bne	LoopOn
	// turn off
	ldr	R2, [R0]
	and	R2, #0xFFFFFFDF
	strh	R2, [R0]
	mov	R7, #(1<<18)
	LoopOff:
	sub	R7, #1
	cmp	R7, #0
	bne	LoopOff
	bx 	LR

L:
	b	L

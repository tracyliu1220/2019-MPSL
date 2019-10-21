/*
	.syntax unified
	.cpu cortex-m4
	.thumb

.data
	leds: .byte 0

.text
	.global main
	.equ RCC_AHB2ENR, 0x4002104C
	.equ GPIOA_MODER, 0x48000000
	.equ GPIOB_MODER, 0x48000400
	.equ GPIOC_MODER, 0x48000800
	.equ GPIOA_ODR, 0x48000014
	.equ GPIOB_ODR, 0x48000414
	.equ GPIOC_IDR, 0x48000810

main:
	bl	GPIO_init
	ldr	R4, =leds

	movs	R3, #1

Loop:
	bl	DisplayLED
	bl	Delay
	b	Loop

GPIO_init:
	ldr	R0, =RCC_AHB2ENR
	mov	R1, #0x6
	str	R1, [R0]

	ldr	R0, =GPIOB_MODER
	movs	R1, #0x1540
	ldr	R2, [R0]
	and	R2, #0xFFFFC03F
	orrs	R2, R2, R1
	str	R2, [R0]

	ldr	R0, =GPIOC_MODER
	//movs	R1, #0x4000000
	ldr	R2, [R0]
	and	R2, #0xF3FFFFFF
	//orrs	R2, R2, R1
	str	R2, [R0]

	ldr	R0, =GPIOB_ODR
	ldr	R5, =GPIOC_IDR

	mov	R7, #0
	mov	R8, #1

	//ldr	R0, =GPIOB_ODR
	//movs	R1, #0x78
	//strh	R1, [R0]

	bx	LR

// R3: state
// R1 ldrb ??

DisplayLED:
	mov	R2, #0x3
	ldrb	R1, [R4]  // R1 = leds
	lsl	R2, R1
	lsr	R2, #1
	lsl	R2, #3
	mvn	R2, R2
	strh	R2, [R0]
	cmp	R3, #1

	ite	eq
	addeq	R1, #1
	subne	R1, #1
	strb	R1, [R4]

	cmp	R1, #0
	it	eq
	moveq	R3, #1
	cmp	R1, #4
	it	eq
	moveq	R3, #2

	bx	LR

// R5: idr_address
// R6: input data
// R7: count
// R8: state
// R9: -1
Delay:
	mov	R2, #(1<<18)
	L:

	ldr	R6, [R5]
	asr	R6, #13
	and 	R6, #1
	cmp	R6, #0
	beq	Zero

	One:
		cmp	R7, #(1<<13)
		mov	R7, #0
		bgt	Trigger
		blt	NotChange

	Zero:
		add	R7, #1
		b	NotChange

	Trigger:
		eor	R8, #1
		b	NotChange

	NotChange:
		cmp 	R8, #0
		it	ne
		subne	R2, #1
		cmp	R2, #0
		bne	L

	bx	LR

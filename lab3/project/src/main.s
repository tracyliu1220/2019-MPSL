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
	.equ GPIOA_ODR, 0x48000014
	.equ GPIOB_ODR, 0x48000414

main:
	bl		GPIO_init
	movs	R1, #1
	ldr		R4, =leds
	str		R1, [R4]

	movs	R3, #1

Loop:
	bl		DisplayLED
	bl		Delay
	b		Loop

GPIO_init:
	ldr		R0, =RCC_AHB2ENR
	mov		R1, #0x2
	str		R1, [R0]

	ldr		R0, =GPIOB_MODER
	movs	R1, #0x1540
	ldr		R2, [R0]
	and		R2, #0xFFFFC03F
	orrs	R2, R2, R1
	str		R2, [R0]

	ldr		R0, =GPIOB_ODR

	//ldr		R0, =GPIOB_ODR
	//movs	R1, #0x78
	//strh	R1, [R0]

	bx		LR

// R3: state
// R1 ldrb ??

DisplayLED:
	mov		R2, #0x3
	ldr		R1, [R4]  // R1 = leds
	lsl		R2, R1
	lsr		R2, #1
	lsl		R2, #3
	strh	R2, [R0]
	cmp		R3, #1

	ite		eq
	addeq	R1, #1
	subne	R1, #1
	str		R1, [R4]

	cmp		R1, #0
	it		eq
	moveq	R3, #1
	cmp		R1, #4
	it		eq
	moveq	R3, #2

	bx		LR

Delay:
	mov		R2, #(1<<20)
	L:
		cmp		R2, #0
		sub		R2, #1
		bne		L
	bx		LR

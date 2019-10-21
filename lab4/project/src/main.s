	.syntax unified
	.cpu cortex-m4
	.thumb

.data
	arr: .byte 0x7E, 0x30, 0x6D, 0x79, 0x33, 0x5B, 0x5F, 0x70,
	           0x7F, 0x7B, 0x77, 0x1F, 0x4E, 0x3D, 0x4F, 0x47

.text
	.global main
	.equ RCC_AHB2ENR, 0x4002104C
	.equ GPIOB_MODER, 0x48000400
	.equ GPIOB_ODR, 0x48000414
	.equ MAX7219_Digit0 0x1
	.equ MAX7219_DecodeMode 0x9
	.equ MAX7219_ScanLimit 0xB

// PB3: CLK
// PB4: DIN
// PB5: CS

main:
	bl	GPIO_init
	bl	MAX7219_init
	ldr	R0, =MAX7219_Digit0
	ldr R3, =arr
	mov	R2, #0

display_loop:
	// R0: digit0
	// R1: display pattern
	// R2: display number
	// R3: pattern address
	ldrb	R1, [R3, R2]
	bl		pass_data

	add		R2, #1
	cmp		R2, #16
	it		eq
	moveq	R2, #0
	b		display_loop

MAX7219_init:
	mov	R0, #MAX7219_ScanLimit
	mov R1, #0
	bl	pass_data
	mov	R0, #MAX7219_DecodeMode
	mov R1, #0
	bl	pass_data

pass_data:
	// R0: address
	// R1: data
	lsl		R0, #8
	add		R0, R1
	// R2: counter
	// R3: GPIOB_ODR address
	// R4: GPIOB_ODR data
	// R5: mask
	push	{R0, R2, R3, R4, R5, LR}
	mov		R2, #16
	ldr		R3, =GPIOB_ODR
	pass_data_loop:
		// data
		mov		R5, #1
		sub		R2, #1
		lsl		R5, R2
		tst		R0, R5
		ldrh	R4, [R3]
		ite		eq
		orreq	R4, #0x10
		addne	R4, #0xFFFFFEFF
		strh	R4, [R3]

		// clock down and up
		eor		R4, #(1<<3)
		strh	R4, [R3]
		eor		R4, #(1<<3)
		strh	R4, [R3]

		cmp		R2, #0
		bne		pass_data_loop

	eor		R4, #(1<<5)
	strh	R4, [R3]
	eor		R4, #(1<<5)
	strh	R4, [R3]

	pop		{R0, R2, R3, R4, R5, LR}



GPIO_init:
	push	{R0, R1, R2, LR}

	ldr		R0, =RCC_AHB2ENR
	mov		R1, #0x6
	str		R1, [R0]

	ldr		R0, =GPIOB_MODER
	movs	R1, #0x540
	ldr		R2, [R0]
	and		R2, #0xFFFFF03F
	orrs	R2, R2, R1
	str		R2, [R0]

	ldr		R0, =GPIOB_ODR
	movs	R1, #0
	strh	R1, [R0]

	pop		{R0, R1, R2, PC}

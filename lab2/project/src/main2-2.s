/*
	.syntax unified
	.cpu cortex-m4
	.thumb

.data
	result: .word 0
	max_size: .word 0

.text
	m: .word 0x5E	// 94
	n: .word 0x60	// 96

.global main

// R0: address
// R1: a
// R2: b
// R3: modified a
// R4: modified b
// R5: a % 2
// R6: b % 2
// R7: return value
// R8: SP

GCD:
	// push
	push	{LR}
	mov		R8,	SP

	// return case
	cmp		R1, #0
	itt		eq
	moveq	R7, R2
	popeq	{PC}
	cmp		R2, #0
	itt		eq
	moveq	R7, R1
	popeq	{PC}

	// compare
	and		R5, R1, #1
	and		R6, R2, #1
	orr		R3, R5, R6
	cmp		R3, #0
	asr		R3, R1, #1
	asr		R4, R2, #1

case1:
	it		ne
	bne		case2
	mov		R1, R3
	mov		R2, R4
	bl		GCD
	lsl		R7, #1
	pop		{PC}

case2:
	cmp		R5, #0
	it		ne
	bne		case3
	mov		R1, R3
	bl		GCD
	pop		{PC}

case3:
	cmp		R6, #0
	it		ne
	bne		case4
	mov		R2, R4
	bl		GCD
	pop		{PC}

case4:
	cmp		R1, R2
	ittee	ge
	subge	R3, R1, R2
	movge	R4, R2
	sublt	R3, R2, R1
	movlt	R4, R1

	mov		R1, R3
	mov		R2, R4
	bl		GCD
	pop		{PC}

main:
	ldr		R0, =m
	ldr		R1, [R0]
	ldr		R0, =n
	ldr		R2, [R0]
	bl		GCD

	ldr		R0, =result
	str		R7, [R0]

	sub		R8, SP, R8
	ldr		R0, =max_size
	str		R8, [R0]

	nop
	nop

L:
	b		L


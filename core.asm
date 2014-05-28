gvar GCOUNT, CODEBASE, CODE, STACK, TOKEN, CALL, CUTMODE

NEXT equ INTSIZE * 0
PREV equ INTSIZE * 1
DATA equ INTSIZE * 2
FUNC equ INTSIZE * 3
STRING equ  INTSIZE * 4

CODE_SIZE equ STRING + INTSIZE

R0 equ A
R1 equ D
R2 equ C
R3 equ SI
R0b equ al
REXE equ B
RSTACK equ DI
RBASE equ BP

BASE_N equ 0
STACK_N equ 1
EXE_N equ 2

BASE_OFF equ INTSIZE * BASE_N
STACK_OFF equ INTSIZE * STACK_N
EXE_OFF equ INTSIZE * EXE_N

macro pushvm { irp R, REXE, RSTACK, RBASE \{ push R \} }
macro popvm { irp R, RBASE, RSTACK, REXE \{ pop R \} }

macro STEP {
	mov REXE, [REXE]
	jmp INTTYPE [REXE + FUNC]
}

func initmem
	alloc 1000
	gset CODE
	gset CODEBASE

	alloc 1000
	add A, 1000 * INTSIZE
	gset STACK

	alloc 1000
	gset TOKEN
	alloc 1000
	gset CALL
exi


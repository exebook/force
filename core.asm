gvar GCOUNT, CODEBASE, CODE, STACK, TOKEN, RETSTACK, CUTMODE, CURTOK, STACK_BASE, RETSTACK_BASE


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

macro rpop reg {
	mov reg, [memory + RETSTACK]
	mov reg, [reg]
	add [memory + RETSTACK], INTSIZE
}

macro rpush reg {
	if reg eq A
		push B
		sub [memory + RETSTACK], INTSIZE
		mov B, [memory + RETSTACK]
		mov [B], reg
		pop B
	else
		push A
		sub [memory + RETSTACK], INTSIZE
		mov A, [memory + RETSTACK]
		mov [A], reg
		pop A
	end if
}
macro rpeek reg {
	mov reg, [memory + RETSTACK]
	mov reg, [reg]
}
;macro rpush X { push X }
;macro rpop X { pop X }
;macro rpeek X { mov X, [SP] }

macro STEP {
	mov REXE, [REXE]
	jmp INTTYPE [REXE + FUNC]
}

macro need N {
	push REXE
	push RSTACK ; use RSTACK as count
	mov RSTACK, N
	local .l
	.l:
		mov REXE, [REXE]
		act act_txtcut
		dec RSTACK
		cmp RSTACK, 0
		jg .l
	pop RSTACK
	pop REXE
}

macro vmpop reg {
	mov reg, [RSTACK]
	add RSTACK, INTSIZE
}

macro vmpush reg {
	sub RSTACK, INTSIZE
	mov [RSTACK], reg
}

func initmem
	alloc 10000
	gset CODE
	gset CODEBASE

	alloc 10000
	add A, 10000 * INTSIZE
	gset STACK_BASE
	gset STACK

	alloc 10000
	gset TOKEN
	
	alloc 10000
	add A, 10000 * INTSIZE
	gset RETSTACK_BASE
	gset RETSTACK
exi


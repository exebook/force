include 'core.asm'
include 'table.asm'
include 'corefu.asm'
include 'lex.asm'
include 'fu.asm'
include 'devonly.asm'

func process
	global CODEBASE
	mov REXE, A
	global STACK
	mov RSTACK, A
	jmp INTTYPE [REXE + FUNC]
exi

func main
	exe initmem
	exe tokens
	global CODE
	show_code 'code base'

	var s, t, n
	chars '1234 10 + .',0
	set s

	global CODE
	mov D, A
	mov [D + NEXT], INTTYPE 0
	mov [D + PREV], INTTYPE 0
	mov [D + DATA], INTTYPE 0
	mov [D + FUNC], INTTYPE func_boot
	get s
	mov [D + STRING], A
	add D, CODE_SIZE
	gset CODE, D
	
	exe process
	puts 10
exi

macro token_ins name, fu, dat {
	chars name
	exe token_add, A, fu, dat
}

func tokens
	exe token_init
	token_ins '555', func_555, 0
	token_ins '777', func_777, 0
	token_ins '.', func_prn, 0
	token_ins '+', func_add, 0
	token_ins '-', func_sub, 0
	token_ins 'swap', func_swap, 0
	token_ins 'dup', func_dup, 0
	token_ins 'over', func_over, 0
	token_ins 'drop', func_drop, 0
	token_ins 'quit', func_quit, 0
	exe token_list
exi


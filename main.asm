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
	chars '123 543 . .'
	;'6 lex scan end 123 . end 555 .'
	;'12 lex 3 label swap dup . cr >> 555 . ret 1 2 3 4 5 6 . . . . . . .'
	;'2 lex token + find sput'
;	'4 balloc dup  65 over setb ',\
;	' 1 + 66 over setb',\
;	' 1 + 67 over setb',\
;	' 1 + 32 over setb',\
;	' drop 4 sput'
	;'111 . 3 lex token qwe sput 555 .'
	
	;'2 nscan find . . .'; 2 >> . find get . 0 1 - 1 + dup sysvar get . 1 + dup sysvar get . 1 + dup sysvar get . 1 + dup sysvar get . 1 + dup sysvar get .',0
	set s

	global CODE ; root code
	mov D, A
	mov [D + NEXT], INTTYPE 0
	mov [D + PREV], INTTYPE 0
	mov [D + DATA], INTTYPE 0
	mov [D + FUNC], INTTYPE func_boot
	get s
	mov [D + STRING], A
	add D, CODE_SIZE
	gset CODE, D
	
	gset GCOUNT, _gcount
	gset CUTMODE, func_token_dispatch
	exe process
	puts 10
exi

macro token_ins name, fu, dat {
	chars name
	push A
	call _str_len
	pop B
	exe token_add, B, A, fu, dat
}

include 'codefu.asm'
include 'fu2.asm'
include 'control.asm'
func_cr:
	puts 10
	STEP
func tokens
	exe token_init
	token_ins '.', func_prn, 0
	token_ins '+', func_add, 0
	token_ins '-', func_sub, 0
	token_ins '*', func_mul, 0
	token_ins '/', func_div, 0
	token_ins 'swap', func_swap, 0
	token_ins 'dup', func_dup, 0
	token_ins 'over', func_over, 0
	token_ins 'drop', func_drop, 0
	token_ins 'quit', func_quit, 0
	token_ins 'lex', func_lex, 0
	token_ins 'label', func_label, 0
	token_ins '==', func_cmp, 0
	token_ins 'intsize', func_intsize, 0
	token_ins 'alloc', func_alloc, 0
	token_ins 'balloc', func_balloc, 0
	token_ins 'set', func_set, 0
	token_ins 'get', func_get, 0
	token_ins 'setb', func_setb, 0
	token_ins 'getb', func_getb, 0
	token_ins 'sysvar', func_sysvar, 0
	token_ins 'token', func_token, 0
	token_ins 'find', func_find, 0
	token_ins 'sput', func_sput, 0
	token_ins 'call', func_call, 0
	token_ins 'ret', func_ret, 0
	token_ins 'cr', func_cr, 0
	token_ins 'scan', func_token_scan, 0
;	token_ins '', func_, 0
	exe token_list
	exe codefu
exi


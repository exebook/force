include 'core.asm'
include 'table.asm'
include 'corefu.asm'
include 'tabfu.asm'
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

func_test:
	puts 'test', 10
	STEP

func main
	exe initmem
	exe tokens
	global CODE
	show_code 'code base'

	var s, t, n
;	chars '555 .'
	chars \
	' token dcall find 12 + get',\
	' token five create 12 + set ',\
	' scan ret  555 .   ret',\
	' token five find 8 + set',\
	' five five five'
;	' token five find dup 0 + get . dup 4 + get . dup 8 + get . dup 12 + get . ',\
;	chars '9999  token const find 12 + get  token five create 12 + set  555 token five find 8 + set  five .' ; example

;	chars 'scan ret 333 22 - . ret dup call cr call cr'  ; sample

;	chars 'token + find 12 +    token - find 12 + get swap set 10 1 + .' ; sample
;	chars '555   token + find 12 + get    token plus create 12 + set    2 2 plus .' ; example
;	chars '9999  token const find 12 + get  token five create 12 + set  555 token five find 8 + set  five .' ; example

;	token five 
;	proc five 555 . ret five
;	chars '0 sysvar get 4 / .'    ; sample
	;'6 lex scan end 123 . end 555 .'
	;'12 lex 3 label swap dup . cr >> 555 . ret 1 2 3 4 5 6 . . . . . . .'

;	chars 'token dup 1 + sput'    ; sample 'dup\0'
;	chars '4 balloc dup  65 over setb ',\
;	' 1 + 66 over setb',\
;	' 1 + 67 over setb',\
;	' 1 + 32 over setb',\
;	' drop 4 sput'                          ; sample ABC

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
	token_ins 'const', func_const, 0
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
	token_ins 'dcall', func_dcall, 0
	token_ins 'ret', func_ret, 0
	token_ins 'cr', func_cr, 0
	token_ins 'scan', func_token_scan, 0
	token_ins 'if', func_if_make, 0
	token_ins 'ifelse', func_if_else_make, 0
	token_ins 'create', func_create, 0
	token_ins 'test', func_test, 0
;	token_ins '', func_, 0
	exe token_list
	exe codefu
exi


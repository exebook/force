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
	act token_list
	STEP

func_show:
	act act_show
	STEP

func main
	puts '_____________________________________________', 10
	exe initmem
	exe tokens
	global CODE
;	show_code 'code base'

	var s, t, n
	; rcut (caller) -- (name end)
	;chars 
	jmp .boot_e_end
	.boot_e:
	file 'boot.e'
	db 0
	.boot_e_end:
	mov A, .boot_e

;chars\ ; sample 
;' token dcall find 12 + get',\
;' token five create 12 + set ',\
;' scan jump  555 .   R> jump',\
;' token five find 8 + set',\
;' five five five'

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
include 'scan.asm'
include 'fu2.asm'
include 'control.asm'

func_cr:
	puts 10
	STEP
	
func_neg:
	mov R0, 0
	cmp INTTYPE [RSTACK], 0
	jne @f
	mov R0, 1
	@@:
	mov [RSTACK], R0
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
	token_ins 'rot', func_rot, 0
	token_ins 'neg', func_neg, 0

	token_ins 'quit', func_quit, 0
	token_ins 'lex', func_lex, 0
	token_ins 'label', func_label, 0
	token_ins '==', func_cmp, 0
	token_ins 'intsize', func_intsize, 0
	token_ins 'alloc', func_alloc, 0
	token_ins 'balloc', func_balloc, 0
	token_ins 'set', func_set, 0
	token_ins 'get', func_get, 0
	token_ins '!', func_set, 0
	token_ins '@', func_get, 0
	token_ins 'setb', func_setb, 0
	token_ins 'getb', func_getb, 0
	token_ins 'sysvar', func_sysvar, 0
	token_ins '``', func_ttoken, 0
	token_ins '`', func_token, 0
	token_ins 'find', func_find, 0
	token_ins 'sput', func_sput, 0
	token_ins 'call', func_call, 0
	token_ins 'dcall', func_dcall, 0
	token_ins 'ret', func_ret, 0
	token_ins 'dataif', func_dataif, 0
	token_ins 'cr', func_cr, 0
	token_ins 'scan', func_token_scan, 0
	token_ins 'cut', func_tokens_cut, 0
	token_ins '?', func_if, 0
	token_ins '??', func_if_else_make, 0
	token_ins 'create', func_create, 0
	token_ins 'test', func_test, 0
	token_ins '>R', func_rpush, 0
	token_ins 'R>', func_rpop, 0
	token_ins '@R', func_rpeek, 0
	token_ins 'jump', func_jump, 0
	token_ins 'jz', func_jz, 0
	token_ins 'jnz', func_jnz, 0
	token_ins 'show', func_show, 0
	token_ins 'end', func_nop, 0
	token_ins 'scmp', func_scmp, 0
	token_ins 'pick', func_pick, 0
	token_ins 'depth', func_depth, 0
	token_ins 'rdepth', func_rdepth, 0
;	token_ins '', func_, 0
;	exe token_list
	exe codefu
exi


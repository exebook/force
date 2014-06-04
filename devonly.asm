func show_codef
	use a
	get a, B
	global CODEBASE
	xchg A, B
	sub A, B
	call _prn_int
	puts 10
exi

macro show_code msg {
	pushall
	puts msg, ': '
	exe show_codef, A
	popall
}

func act_show
	use info
	var c,s,t,n

	get info, D
	mov A, [D + STACK_OFF]
	add [D + STACK_OFF], INTTYPE 4
	mov A, [A]
	set c

	get c ; SET S
		mov A, [A + STRING]
		set s
	pet s ; TOKENIZE
		exe tokenize
		
	puts '<'
	pair n, t
	call _prn_str
	puts ':'
	get n
	call _prn_int
	puts 8,'>'
	get c
	mov A, [A + FUNC]
	exe token_find_by_func, A
exi


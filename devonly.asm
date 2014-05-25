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


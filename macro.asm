macro log str { puts str, 10 }
macro pushall { irp R, BP, D, C, B, A, SI, DI \{ push R \} }
macro popall { irp R, DI, SI, A, B, C, D, BP \{ pop R \} }

macro draw [arg] {
	forward
	get arg
	call _str_len
	push A
	get arg, B
	pop A
	call _prn_str
	puts ' '
}

macro show [arg] {
	forward
	get arg
	call _prn_int
}

macro change name, value {
	get name
	add A, value
	set name
}

macro check name, value, jumpto {
	get name
	cmp A, value
	jne jumpto
}

macro cycle name, value, jumpto {
	change name, 1
	cmp A, value
	jne .loop_#jumpto
}

macro lab l { .loop_#l: }


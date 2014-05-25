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
	pair name, value
	cmp A, B
	jne .loop_#jumpto
}

macro lab l { .loop_#l: }

macro alloc numbers { cinvoke malloc, numbers * INTSIZE }

_gcount equ 0
macro gvar [name] {
	forward
	name equ _gcount
	_gcount equ _gcount + INTSIZE
}

macro global x { mov A, [memory + x] }
macro gset id, [value] {
	if ~ value eq
		mov A, value
	end if
	mov [memory + id], A
}

macro ref name, index {
	get name
	if index eq
		mov A, [A]
	else
		mov A, [A - INTSIZE * index]
	end if
}

macro setref name, index_or_value, value {
	if value eq
		mov C, INTTYPE index_or_value
	else
		mov C, INTTYPE value
	end if
	get name
	if value eq
		mov [A], C
	else
		mov [A - INTSIZE * index_or_value], C
	end if
}


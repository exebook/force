
format ELF executable 3
entry start

include 'sys32/import32.inc'
include 'sys32/proc32.inc'
include '32.asm'
include 'lang.asm'
include 'macro.asm'
include 'char.asm'

interpreter '/lib/ld-linux.so.2'
needed 'libc.so.6'
import printf,exit,putchar

segment readable executable

macro Bye {
	cinvoke exit
}

macro var [_arg] {
	common
		_count equ 0
	forward
		_arg equ _count
		_count equ _count + 1
	common
}

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

func five
	mov A, 5005
	call _prn_int
exi

func summ
	var a, b
	pair a, b
	add A, B
exi

func fu
	var a, b, c, s, t, i
	chars 'hello', 33
	set t
	draw t
	set i, 0
.loop:
	show i
	puts 'hey', 10
	get i
	inc A
	set i
	cmp A, 10
	jnz .loop
exi

start:
	exe fu
	Bye

segment readable writeable

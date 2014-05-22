format ELF executable 3
entry start

success = 0
include 'sys32/import32.inc'
include 'sys32/proc32.inc'
include '32.asm'
include 'lang.asm'
include 'macro.asm'
include 'sys.asm'
include 'char.asm'
macro alloc numbers { cinvoke malloc, numbers * INTSIZE }

_gcount equ 0
macro gvar [name] {
	forward
	name equ _gcount
	_gcount equ _gcount + INTSIZE
}
gvar CODEBASE, CODE, STACK, TOKEN, CALL

macro global x { mov A, [memory + x] }

include 'token.asm'

interpreter '/lib/ld-linux.so.2'
needed 'libc.so.6'
import printf,exit,putchar,malloc

segment readable executable

include 'main.asm'

macro gset id, [value] {
	if ~ value eq
		mov A, value
	end if
	mov [memory + id], A
}

start:
	alloc 1000
	gset CODE
	gset CODEBASE
	alloc 1000
	gset STACK
	alloc 1000
	gset TOKEN
	alloc 1000
	gset CALL
	
	global CODE
	global CALL
	if success = 0
		exe main
	end if
	Bye

segment readable writable
memory rd 1024 * 4

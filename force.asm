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

NEXT equ INTSIZE * 0
PREV equ INTSIZE * 1
DATA equ INTSIZE * 2
FUNC equ INTSIZE * 3
STRING equ  INTSIZE * 4

CODE_SIZE equ STRING + INTSIZE

macro global x { mov A, [memory + x] }
macro gset id, [value] {
	if ~ value eq
		mov A, value
	end if
	mov [memory + id], A
}


include 'token.asm'

interpreter '/lib/ld-linux.so.2'
needed 'libc.so.6'
import printf,exit,putchar,malloc

segment readable executable

include 'main.asm'

start:
	if success = 0
		exe main
	end if
	Bye

segment readable writable
memory rd 1024 * 4

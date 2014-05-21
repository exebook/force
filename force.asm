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

interpreter '/lib/ld-linux.so.2'
needed 'libc.so.6'
import printf,exit,putchar

segment readable executable

func main
exi

start:
	if success = 0
		exe main
	end if
	Bye


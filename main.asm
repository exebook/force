R0 equ A
R1 equ C
R2 equ D
R3 equ SI
REXE equ B
RSTACK equ DI
RBASE equ BP
RBASE_OFF equ INTSIZE * 0
RSTACK_OFF equ INTSIZE * 1
REXE_OFF equ INTSIZE * 2

macro STEP {
	mov REXE, [REXE]
	jmp dword [REXE + 12]
}

macro act fu, a, b, c {
	push REXE
	push RSTACK
	push RBASE
	mov A, SP
	push A
	exe fu, A
	pop A
	mov RBASE, [A + RBASE_OFF]
	mov RSTACK, [A + RSTACK_OFF]
	mov REXE, [A + REXE_OFF]
}

func act_prn
	use info
	get info
	mov B, [A + RSTACK_OFF]
	add [A + RSTACK_OFF], INTTYPE INTSIZE
	mov A, [B]
	call _prn_int
	exi
	
func act_prns
	use info, s
	get info
	mov B, [A + RSTACK_OFF]
	add [A + RSTACK_OFF], INTTYPE INTSIZE
	mov A, [B]
	set s
	draw s
	puts ' '
	exi

func_num:
	sub RSTACK, INTSIZE
	mov R0, [REXE + DATA]
	mov [RSTACK], R0
	STEP

func_add:
	mov R0, [RSTACK]
	add RSTACK, INTSIZE
	add [RSTACK], R0
	STEP
	
func_prn:
	act act_prn, R0
	STEP

func_prns:
	act act_prns, R0
	STEP

func_555:
	puts '555 '
	STEP
	
func_777:
	puts '777 '
	STEP
	
func_quit:
	puts 'quit',10
	Bye

func ontxt
exi

func_ontxt:
	act ontxt
	STEP

macro addc fu, dat {
	mov [B + NEXT], A
	mov [A + PREV], B
	mov C, 0
	if ~ dat eq
		mov C, dat
	end if
	mov [A + DATA], C
	mov [A + FUNC], INTTYPE fu
	mov [A + STRING], INTTYPE 0
	mov B, A
	add A, CODE_SIZE
}

func adder
	chars 'hello!'
	mov D, A
	global CODE
	mov B, A
	addc func_num, 100
	addc func_num, 200
	addc func_num, 345
	addc func_num, 123
	addc func_add
	addc func_prn
	addc func_prn
	addc func_num, D
	addc func_prns
	
	addc func_prn
	addc func_quit
	gset CODE
exi

func initmem
	alloc 1000
	gset CODE
	gset CODEBASE

	alloc 1000
	add A, 100
	gset STACK

	alloc 1000
	gset TOKEN
	alloc 1000
	gset CALL
exi

func process
	global CODEBASE
	mov REXE, A
	global STACK
	mov RSTACK, A
	jmp INTTYPE [REXE + 12]
exi

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

;void tokenize(int *txt, int **token, int *count) {
;  while (*txt <= ' ' && *txt > 0) txt++;
;  if (*txt == 0) { *count = 0; return; }
;  if (txt[0] == '\'') {
;     *token = txt; txt++; *count = 2;
;     while (*txt != '\'') txt++, (*count)++;
;     return;
;  }
;  *token = txt; *count = 0; *token = txt;
;  while (*txt++ > ' ') (*count)++;
;}

func tokenize
	use a
	var s, t
	
	ref a
	.l1:
		cmp [A], byte 0
		je .return_zero
		cmp [A], byte 32
		jg .skip1
		inc A
	jmp .l1
	
.return_zero:
	exi 0

.skip1:
	setref a, 1, A
	ref a, 1
	
	.l2:
		cmp [A], byte 32
		jle .tokend
		inc A
	jmp .l2
	
.tokend:
	set t
	get t, D
	ref a, 1
	sub D, A
	mov A, D
	setref a, 2, A
exi 1

func test_tokenizer
	use s
	var t, n
.l1:
	pet s
	exe tokenize
	cmp A, 0
	je .b1
	pair n, t
	call _prn_str
	puts ' '
	show n
	puts 10
	
	pair t, n
	add A, B
	set s
	
	jmp .l1	
.b1:
	log 'enough'
exi

func main
	var s, t, n
	chars '   abc  12345  xyz'
	set s
	exe test_tokenizer
	
;	draw t
;	puts 'start',10
;	exe initmem
;	exe adder
;	exe process
	puts 10
exi

macro token_ins name, fu, dat {
	chars name
	exe token_add, A, fu, dat
}

func tokens
	exe token_init
	token_ins 'hello', 100, 111
	token_ins 'world', 200, 222
	token_ins 'of', 300, 333
	token_ins 'force', 400, 444
	exe token_list
	
	chars 'world'
	exe token_find, A
	call _prn_int
	chars 'hello'
	exe token_find, A
	call _prn_int
	chars 'world'
	exe token_find, A
	call _prn_int
	chars 'force'
	exe token_find, A
	call _prn_int
;	exe token_list
	exi


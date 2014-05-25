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

func test_lexer
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


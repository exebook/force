main: ent
	exe token_init
	chars 'hello'
	exe token_add, rax, 100, 111
	chars 'world'
	exe token_add, rax, 200, 222
	chars 'of'
	exe token_add, rax, 300, 333
	chars 'force'
	exe token_add, rax, 400, 444
	
	chars 'world'
	exe token_find, rax
	call _prn_int
	exi



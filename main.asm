func main
	exe tokens
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


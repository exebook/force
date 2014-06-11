1000001
`` dcall find 12 + @
`` proc create 12 + !

scan procend
	@R cut end
	swap dup	dup 16 + @ swap 8 + @ create
	dup 12 +	` dcall find 12 + @	swap !
	8 +
	swap @ swap !
	dup	` ret find 12 + @ swap 12 + !
	>R ret
procend

`` proc find 8 + !

proc loop_sample
	5 label @R >R dup . 1 - dup . cr dup ? ret drop R> drop cr
	R> drop
end

proc show_both
	over over sput ` <---> sput >R >R over over sput R> R> cr
end

proc block_step
	>R >R >R @ R> R> R>
end

proc block
	R> @ dup >R
	dup 16 + @ swap 8 + @
	label
		2 pick
		dup 16 + @ swap 8 + @
		scmp neg
		dup ? block_step
	@R >R ? ret
	drop drop
	R> R> drop drop
end

proc then end
proc if
	@R @
	block then @
	@R 8 + !
	` dataif find 12 + @
	@R 12 + !
	R>
	jump
end

proc (
	@R @
	block ) @
	@R 8 + !
	` djump find 12 + @
	@R 12 + !
	R>
	jump
end

proc f 
	555 777 1 if swap then . drop cr
	( now we have a comment )
	555 777 0 if swap then . drop cr
end

f


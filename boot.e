1000001
`` ^call find 12 + @
: create 12 + !

scan word;
	R> cut ;
	swap dup	dup 16 + @ swap 8 + @ create
	dup 12 +	` ^call find 12 + @	swap !
	8 +
	swap @ swap !
	dup	` ret find 12 + @ swap 12 + !
	>R ret
word;

`` : find 8 + !


: Call R> swap >R >R ;
: twice: R> R> dup Call Call >R ;
: quad twice: dup + ;
: fives @R >R 555 . cr 554 . cr ;

fives
50 quad

: @FUNC 12 + @ ;
: !FUNC 12 + ! ;
: @DATA 8 + @ ;
: !DATA 8 + ! ;
: @STRING 16 + @ ;
: !STRING 16 + ! ;

: loop_sample
	5 label @R >R dup . 1 - dup . cr dup ? ret drop R> drop cr
	R> drop
;

: show_both
	over over sput ` <---> sput >R >R over over sput R> R> cr
;

: block_step
	>R >R >R @ R> R> R>
;

: block
	R> @ dup >R
	dup @STRING swap @DATA
	label
		2 pick
		dup @STRING swap @DATA
		scmp neg
		dup ? block_step
	@R >R ? ret
	drop drop
	R> R> drop drop
;

: then ;
: if
	@R @
	block then @
	@R !DATA
	` ^if find @FUNC
	@R !FUNC
	R>
	jump
;

: (
	@R @
	block ) @
	@R !DATA
	` ^jump find @FUNC
	@R !FUNC
	R>
	jump
;

: f 
	555 777 1 if swap then . drop cr
	( now we have a comment )
	555 777 1 if swap then . drop cr
;

f

.

depth . rdepth . 


"hello world" sput sput

( todo: add flip )

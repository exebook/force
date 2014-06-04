token dcall find 12 + get
token proc create 12 + set
scan jump
	dscan end swap dup	dup 16 + get swap 8 + get create
	dup 12 +	token dcall find 12 + get	swap set
	8 +
	swap get swap set
	dup	token ret find 12 + get swap 12 + set
jump
token proc find 8 + set

proc five 555 . end proc six 600 . end
five five six five

proc print . end
777 print

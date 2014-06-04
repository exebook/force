token dcall find 12 + get
token proc create 12 + set

scan procend
	dscan end swap dup	dup 16 + get swap 8 + get create
	dup 12 +	token dcall find 12 + get	swap set
	8 +
	swap get swap set
	dup	token ret find 12 + get swap 12 + set
	>R ret
procend

token proc find 8 + set

proc five 555 . end proc six 600 . end

proc then end
proc if
	dscan then R> drop get
	swap rot ? swap drop jump
end
0 if 5550 . then
1 if 5551 . then
333 .

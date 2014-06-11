10000001
` asd ` qwe scmp . cr
` asd scmp . cr
drop drop

quit
4000 ` why1? sput cr
proc five
	555 . loop_sample
end
3000 ` why2? sput cr
proc six
	600 . five
end
five quit

1111 .

proc loop_sample
	5 label @R >R dup . 1 - dup . cr dup ? ret R> cr ` finished sput
	ret
end

` why? sput cr

proc five
	555 . loop_sample ` after_loop sput cr
	ret
end
` why2? sput cr
proc six
	600 . five
	ret
end
` why3? sput cr
six 6666666 . six 7777777 . 888888888 . quit

proc token
	R> get dup >R dup 16 + get swap 8 + get sput cr
end

proc _if
	@R cut then R> drop get
	swap rot ? swap drop jump
end



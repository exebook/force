;	chars\ ; sample 
;	' token dcall find 12 + get',\
;	' token proc create 12 + set ',\
;	' scan jump ',\
;	' 	dscan end swap dup	dup 16 + get swap 8 + get create',\ ; (end name new)
;	' 	dup 12 +	token dcall find 12 + get	swap set',\ ; (end name new)
;	' 	8 +',\ ; (end name newdataptr)
;	'	swap get swap set',\ ; (end name newd)
;	' dup	token ret find 12 + get swap 12 + set	jump',\
;	' 111 . cr token proc find 8 + set ',\
;	' proc five 555 . end proc six 600 . end',\
;	' 999 1 - . cr five five six five ',\
;	' proc print . end 777 print'

chars\ ; sample 
	' token dcall find 12 + get',\
	' token proc create 12 + set ',\
	' scan jump ',\
	' 	dscan end swap dup	dup 16 + get swap 8 + get create',\ ; (end name new)
	' 	dup 12 +	token dcall find 12 + get	swap set',\ ; (end name new)
	' 	8 +',\ ; (end name newdataptr)
	'	swap get swap set',\ ; (end name newd)
	' dup show jump',\
	' 111 . cr token proc find 8 + set ',\
	' proc five 555 . ret end',\
	' 999 1 - . cr five five five '


chars '555 .'
chars\ ; sample 
' token dcall find 12 + get',\
' token five create 12 + set ',\
' scan ret  555 .   ret',\
' token five find 8 + set',\
' five five five'

' token five find dup 0 + get . dup 4 + get . dup 8 + get . dup 12 + get . ',\
chars '9999  token const find 12 + get  token five create 12 + set  555 token five find 8 + set  five .' ; example

chars 'scan ret 333 22 - . ret dup call cr call cr'  ; sample

chars 'token + find 12 +    token - find 12 + get swap set 10 1 + .' ; sample
chars '555   token + find 12 + get    token plus create 12 + set    2 2 plus .' ; example
chars '9999  token const find 12 + get  token five create 12 + set  555 token five find 8 + set  five .' ; example

token five 
proc five 555 . ret five
chars '0 sysvar get 4 / .'    ; sample
;'6 lex scan end 123 . end 555 .'
;'12 lex 3 label swap dup . cr >> 555 . ret 1 2 3 4 5 6 . . . . . . .'

chars 'token dup 1 + sput'    ; sample 'dup\0'
chars '4 balloc dup  65 over setb ',\
' 1 + 66 over setb',\
' 1 + 67 over setb',\
' 1 + 32 over setb',\
' drop 4 sput'                          ; sample ABC

;'2 nscan find . . .'; 2 >> . find get . 0 1 - 1 + dup sysvar get . 1 + dup sysvar get . 1 + dup sysvar get . 1 + dup sysvar get . 1 + dup sysvar get .',0

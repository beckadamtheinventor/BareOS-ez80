include '../include/ez80.inc'
include '../include/ti84pceg.inc'
include '../include/opence.inc'

macro paduntil? addr
	assert $ <= addr
	if $ < addr
		db addr-$ dup $FF
	end if
end macro

org $020000

paduntil $020100
	db $5A,$A5,$FF,$FF

include 'table.asm'
include 'code.asm'
include 'expressions.asm'
include 'data.asm'

endOfOS:

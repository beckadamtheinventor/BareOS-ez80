
interruptHandler:
	pop iy
	pop ix
	exx
	ex af,af'
	retn
rst10Handler:
rst18Handler:
rst20Handler:
rst28Handler:
rst30Handler:
bootOS:
	call testIsOpenCE
	jq z,bootOpenCEOS
	jp ti.MarkOSInvalid
testIsOpenCE:
	ld bc,oce.identifier_location
	push bc
	ld bc,string_OpenCE_bootcode
	push bc
	call ti._strcmp
	pop bc,bc
	ret
bootOpenCEOS:
	call fs_build_VAT
OSMain:
	ld bc,$FF
	ld (oce.textColors),bc
	call clearScreenHomeUpStatusBar
	ld hl,string_welcome
	call oce.putSAndNewLine
	call oce.blitBuffer
.keys:
	call oce.waitKeyCycle
	cp a,9
	jq z,.getuserinput
	cp a,15
	jr nz,.keys
	call clearScreenHomeUpStatusBar
	ld hl,string_return_to_OpenCE
	call oce.putSAndNewLine
	call oce.putSAndNewLine
	call oce.blitBuffer
	call oce.waitKeyCycle
	cp a,9
	jr nz,OSMain
	rst 0
.getuserinput:
	ld bc,64
	push bc
	ld bc,tempMem
	push bc
	call get_user_input
	pop bc,bc
	jq OSMain

ErrorHandler:
	ld bc,$80FF
	ld (oce.textColors),bc
	lea hl,iy
	call oce.putSAndNewLine
	call oce.blitBuffer
	jp oce.waitKeyCycle


clearScreenHomeUpStatusBar:
	ld a,$FF
	call oce.setBuffer
	call oce.homeUp
	jp oce.drawStatusBar


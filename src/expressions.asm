

get_user_input:
	ld hl,-4
	call ti._frameset
	xor a,a
	sbc hl,hl
	ld (ix-3),hl
	ld (ix-4),a
	ld hl,(ix+6)
	ld (hl),a
	push hl
	pop de
	inc de
	ld bc,(ix+9)
	ldir
.draw:
	call clearScreenHomeUpStatusBar
	ld a,$FF
	ld (oce.textColors),a
	ld hl,(ix+6)
	call oce.putS
	ld a,7
	ld (oce.textColors),a
	ld bc,0
	ld hl,_overtypes
	ld c,(ix-4)
	add hl,bc
	ld a,(hl)
	call oce.putC
	call oce.blitBuffer
.keys:
	call oce.waitKeyCycle
	cp a,56
	jq z,.delete
	cp a,15
	jq z,.exit
	cp a,54
	jq z,.nextmap
	cp a,9
	jq z,.enter
	jq c,.keys
	cp a,48
	jq z,.prevmap
	jq nc,.keys
	ld bc,0
	ld c,(ix-4)
	ld hl,_keymaps
	add hl,bc
	add hl,bc
	add hl,bc
	ld hl,(hl)
	sub a,10
	ld c,a
	add hl,bc
	ex hl,de
	ld hl,(ix-3)
	ld bc,(ix+9)
	or a,a
	inc hl
	sbc hl,bc
	jq nc,.keys
	add hl,bc
	ld (ix-3),hl
	dec hl
	ld a,(de)
	ld bc,(ix+6)
	add hl,bc
	ld (hl),a
	inc hl
	ld (hl),0
	jq .draw
.delete:
	ld hl,(ix+6)
	ld bc,(ix-3)
	dec bc
	ld a,(ix-1)
	or a,b
	or a,c
	jq z,.draw
	add hl,bc
	ld (hl),0
	ld (ix-3),bc
	jq .draw
.enter:
	or a,a
	jr .return
.exit:
	xor a,a
.return:
	ld sp,ix
	pop ix
	ret
.prevmap:
	ld a,(ix-4)
	or a,a
	jr nz,.decmap
	ld a,3
.decmap:
	dec a
.setmap:
	ld (ix-4),a
	jq .draw
.nextmap:
	ld a,(ix-4)
	inc a
	cp a,3
	jr nz,.setmap
	xor a,a
	jr .setmap


process_expression:
	ld hl,-9
	call ti._frameset
	or a,a
	sbc hl,hl
	ld (ix-3),hl
	ld (ix-6),hl
.main_loop:
	ld hl,(ix+6)
	ld bc,(ix-3)
	add hl,bc
.dont_reload_ptr:
	ld a,(hl)
	inc hl
	or a,a
	jq z,.exit
	cp a,'.'
	jq c,.decimal
	cp a,$30
	jq c,.dont_reload_ptr
	cp a,$3A
	jq nc,.number
	
	jq .dont_reload_ptr
.decimal:
	inc bc
	inc bc
	ld (ix-3),bc
	ld a,(hl)
	call .numberentry
	ld a,(ix-7)
	
	jq .main_loop
.number:
	inc bc
	ld (ix-3),bc
.numberentry:
	sub a,$30
	ld a,(ix-9)
	ld bc,(ix-6)
	ld e,$43
	ld hl,$A80000
	ld (ix-9),a
	ld (ix-6),bc
	jq .main_loop
.exit:
	ld sp,ix
	pop ix
	ret


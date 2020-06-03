
; file VAT flags
fs_exists_bit      := 1 shl 0 ;reset this to mark a file for deletion
fs_new_file_bit    := 1 shl 1 ;indicates file must be created upon writing

; file data flags. If the flag byte is equal to $FF, then assume there are no remaining files
;fs_exists_bit      := 1 shl 0 ;reset this to mark a file for deletion (same as VAT flag)
fs_executable_bit  := 1 shl 1
fs_system_bit      := 1 shl 2
fs_read_only_bit   := 1 shl 3

fs_temp_name_ptr   := $D00101 ;store temp name pointer. temp names are file that have not yet been written to.
fs_VAT_start       := $D01000 ;$2000 bytes = 2048x4 byte entries
fs_VAT_ptr         := $D00104 ;points to current end of VAT pointer
fs_flash_ptr       := $D00107 ;first sector of user flash memory
fs_end_flash_ptr   := $D00108 ;points to end of user flash memory

fs_build_VAT:
	push ix
	ld ix,fs_VAT_start
	ld hl,system_files
	call .loop
	or a,a
	sbc hl,hl
	ld (ScrapMem),hl
	ld a,(fs_flash_ptr)
	ld (ScrapMem+2),a
	ld hl,(ScrapMem)
	call .loop
	ld (fs_VAT_ptr),ix
	pop ix
	ret
.loop:
	ld a,(hl)
	cp a,$FF
	ret z    ;if flag byte = $FF, there are no more user files to account for
	bit fs_exists_bit,a
	jr z,.dont_count
	ld a,fs_exists_bit
	ld (ix),a
	ld (ix+1),hl
	lea ix,ix+4
.dont_count:
	inc hl ;bypass flags
	ld de,(hl)
	ld bc,0
	inc hl
	inc hl
	inc hl ;bypass length
	xor a,a
	cpir   ;bypass name
	inc hl ;bypass null byte
	add hl,de ;bypass file
	ld a,(hl)
	inc a
	jr nz,.loop
	ret


fs_find_sym:
	push ix
	ld hl,3
	add hl,sp
	ld de,(hl)
	ld ix,fs_VAT_start
.loop:
	push de
	ld hl,(ix+1)
	push hl
	call ti._strcmp
	pop bc
	pop de
	jr z,.found
	lea ix,ix+4
	ld bc,(fs_VAT_ptr)
	or a,a
	lea hl,ix
	sbc hl,bc
	add hl,bc
	jr c,.loop
	scf
	jr .exit
.found:
	lea hl,ix
	xor a,a
.exit:
	pop ix
	ret


fs_execute_file:
	call fs_find_sym
	ret c
	ld de,(hl)
	ld a,(de)
	bit fs_exists_bit,a
	jr z,.failed
	bit fs_executable_bit,a
	jr nz,.failed
	ex hl,de
	inc hl
	inc hl
	inc hl
	inc hl ;bypass flag byte and length bytes
	ld bc,0
	xor a,a
	cpir ;bypass name
	inc hl ;bypass null byte
	ld de,(hl)
	ex hl,de
	db $01,'XZE' ;EZX
	or a,a
	sbc hl,bc
	jr z,.exec_EZX
	add hl,bc
	ex hl,de
	ld a,(hl)
	cp a,$EF
	jq z,.maybe_EF7B
	jq .invalid_exe
.exec_EZX:
	ex hl,de
	inc hl
	inc hl
	inc hl
.test_data:
	ld a,(hl)
	cp a,$C7
	jr z,.bypass_icon
	cp a,$CF
	jr z,.bypass_description
	jp (hl)
.bypass_icon:
	ld b,(hl)
	inc hl
	ld c,(hl)
	inc hl
	mlt bc
	add hl,bc
	jr .test_data
.bypass_description:
	ld bc,0
	xor a,a
	cpir
	inc hl
	jr .test_data
.maybe_EF7B:
	inc hl
	ld a,(hl)
	cp a,$7B
	jr nc,.invalid_exe
	inc hl
	jp (hl)
.invalid_exe:
	ld iy,string_invalid_executable
	jp ErrorHandler
.failed:
	scf
	ret

fs_create_file:
	ld hl,3
	add hl,sp
	ld hl,(hl)
	ld de,(fs_temp_name_ptr)
	push hl
	push de
	call ti._strcpy
	pop bc
	pop hl
	ld hl,(fs_VAT_ptr) ;end of VAT pointer
	ld (hl),fs_new_file_bit+fs_exists_bit
	inc hl
	ld (hl),bc      ;store pointer to file name
	inc hl
	inc hl
	inc hl
	ld (fs_VAT_ptr),hl ;advance VAT
	push bc
	pop hl
	xor a,a
	ld bc,0
	cpir
	ld (fs_temp_name_ptr),hl ;advance temp name pointer
	ret


fs_delete_file:
	call fs_find_sym
	ret c
	res fs_exists_bit,(ix)
	bit fs_new_file_bit,(ix)
	call z,.mark_flash_data
	xor a,a
	ret
.mark_flash_data:
	ld hl,(ix+1)
	ld a,(hl)
	res fs_exists_bit,a
	ex hl,de
	jp ti.WriteFlashByte



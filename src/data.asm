
execMem             :=  $D1A881
tempMem             :=  $D03000
ScrapMem            :=  $D0017C
sys_exec_arguments  :=  $D00800


_keymaps:
	dl _keymap_A,_keymap_a,_keymap_1,0
_keymap_A:
	db "#WRMH  ?!VQLG  :ZUPKFC  YTOJEB  XSNIDA"
_keymap_a:
	db "#wrmh  ?!vqlg  :zupkfc  ytojeb  xsnida"
_keymap_1:
	db "+-*/^  ;369)$@ .258(&~ 0147,][  ",$1A,"<=>}{"
_overtypes:
	db "Aa1"
string_welcome:
	db "Welcome to BareOS!",0
string_return_to_OpenCE:
	db "Return to bootloader?",0
string_press_enter_confirm:
	db "Press enter to confirm.",0
string_OpenCE_bootcode:
	db "OpenCE bootcode",0
string_invalid_executable:
	db "Invalid executable format",0

system_files:
sys_file_1:
	db fs_system_bit+fs_executable_bit+fs_exists_bit
	dl .len
	db "RMF",0
.data:
	db $EF,$7B
	ld hl,sys_exec_arguments
	push hl
.loop:
	call ti._strlen
	push hl
	pop bc
	pop hl
	jr z,.exit
	push hl
	ld a,' '
	cpir
	xor a,a
	ld (hl),a
	ex (sp),hl
	push hl
	call fs_delete_file
	pop hl
	jr .loop
.exit:
	xor a,a
	ret
.len:=$-.data

sys_file_2:
	db fs_system_bit+fs_executable_bit+fs_exists_bit
	dl .len
	db "MKF",0
.data:
	db $EF,$7B
	ld hl,sys_exec_arguments
	push hl
.loop:
	call ti._strlen
	push hl
	pop bc
	pop hl
	jr z,.exit
	push hl
	ld a,' '
	cpir
	xor a,a
	ld (hl),a
	ex (sp),hl
	push hl
	call fs_create_file
	pop hl
	jr .loop
.exit:
	xor a,a
	ret
.len:=$-.data
	db $FF

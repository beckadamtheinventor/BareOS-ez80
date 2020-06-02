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

execMem:=$D1A881
tempMem:=$D031F6

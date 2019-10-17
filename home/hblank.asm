HBlank::
	push af
	push bc
	push de
	push hl
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, BANK(_HBlank)
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	call _HBlank
	pop af
	ld [H_LOADEDROMBANK], a
	ld [MBC1RomBank], a
	pop hl
	pop de
	pop bc
	pop af
	reti

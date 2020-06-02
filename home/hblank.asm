HBlank::
	push af
	push bc
	push de
	push hl
	ld a, [rSVBK]
	ld [hSVBKBackup], a
	ld a, [H_LOADEDROMBANK]
	push af
	ld a, BANK(_HBlank)
	rst BankswitchCommon
	call _HBlank
	pop af
	rst BankswitchCommon
	ld a, [hSVBKBackup]
	ld [rSVBK], a
	pop hl
	pop de
	pop bc
	pop af
	reti

LoadFrontPicFromSet::
; get pointer to correct picset from option selected
	ld a, [PICSET_ADDRESS]
	and PICSET_MASK
	dec a
	add a
	ld c, a
	ld b, 0
	ld hl, PicSets
	add hl, bc
	rst UnHL
; get pointer to the mon we want within the picset
	ld a, [wd11e]
	dec a
	ld c, a
	ld b, 0
	add hl, bc
	add hl, bc
	add hl, bc
; write it over the current frontpic pointer and dimensions
	ld a, [hli]
	ld [wMonHFrontSprite], a
	ld a, [hli]
	ld [wMonHFrontSprite + 1], a
	ld a, [hl]
	ld [wMonHSpriteDim], a
	ret

INCLUDE "data/pic_sets.asm"

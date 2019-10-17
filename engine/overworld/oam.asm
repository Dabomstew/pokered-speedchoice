PrepareOAMData: ; 499b (1:499b)
; Determine OAM data for currently visible
; sprites and write it to wOAMBuffer.
; Yellow code has been changed to use registers more efficiently
; as well as tweaking the code to show gbc palettes
 
    ld a, [wUpdateSpritesEnabled]
    dec a
    jr z, .updateEnabled
 
    cp $ff
    ret nz
    ld [wUpdateSpritesEnabled], a
    jp HideSprites
 
.updateEnabled
    xor a
    ld [hOAMBufferOffset], a
 
.spriteLoop
    ld [hSpriteOffset2], a
   
    ld e, a
    ld d, wSpriteStateData1 / $100
   
    ld a, [de] ; c1x0
    and a
    jp z, .nextSprite
 
    inc e
    inc e
    ld a, [de] ; c1x2 (facing/anim)
    ld [wd5cd], a
    cp $ff ; off-screen (don't draw)
    jr nz, .visible
 
    call GetSpriteScreenXY
    jr .nextSprite
 
.visible
    cp $a0 ; is the sprite unchanging like an item ball or boulder?
    jr c, .usefacing
 
; unchanging
    xor a
    jr .next
 
.usefacing
    and $f
 
.next
; read the entry from the table
    add a
    ld c, a
    ld b, 0
    ld hl, SpriteFacingAndAnimationTable
    add hl, bc
    ld a, [hli]
    ld h, [hl]
    ld l, a
; get sprite priority
    ld b, d
    ld c, e
   
    inc b
    ld a, c
    add $5
    ld c, a
    ld a, [bc] ; c2x7
    and $80
    ld [hSpritePriority], a ; temp store sprite priority
   
    call GetSpriteScreenXY
   
    ld a, [wd5cd]            ; temp copy of c1x2
    swap a                   ; high nybble determines sprite used (0 is always player sprite, next are some npcs)
    and $f
 
    ; Sprites $a and $b have one face (and therefore 4 tiles instead of 12).
    ; As a result, sprite $b's tile offset is less than normal.
    cp $b
    jr nz, .notFourTileSprite
    ld a, $a * 12 + 4 ; $7c
    jr .startTileLoop
 
.notFourTileSprite
    ; a *= 12
    add a
    add a
    ld c, a
    add a
    add c
.startTileLoop
    ld b, a
   
    ld a, [hOAMBufferOffset]
    ld e, a
    ld d, wOAMBuffer / $100
   
    ld c, $4
.loop
    ld a, [hSpriteScreenY]   ; temp for sprite Y position
    add $10                  ; Y=16 is top of screen (Y=0 is invisible)
    add [hl]                 ; add Y offset from table
    ld [de], a               ; write new sprite OAM Y position
    inc hl
    inc e
    ld a, [hSpriteScreenX]   ; temp for sprite X position
    add $8                   ; X=8 is left of screen (X=0 is invisible)
    add [hl]                 ; add X offset from table
    ld [de], a
    inc hl
    inc e
    ld a, [hli]
    add b
    ld [de], a ; tile id
    inc e
    ld a, [hl]
    bit 1, a ; is the tile allowed to set the sprite priority bit?
    jr z, .skipPriority
    ld a, [hSpritePriority]
    or [hl]
.skipPriority
; uncomment the following range for pal conversion
	and $f0
	bit 4, a ; OBP0 or OBP1
	jr z, .spriteusesOBP0
	or %001 ; palette 1 is OBP1
.spriteusesOBP0
    ld [de], a
    inc hl
    inc e
    dec c
    jr nz, .loop
 
    ld a, e
    ld [hOAMBufferOffset], a
.nextSprite
    ld a, [hSpriteOffset2]
    add $10
    jp nz, .spriteLoop
 
    ; Clear unused OAM.
    ld a, [wd736]
    bit 6, a ; jumping down ledge or fishing animation?
    ld c, $a0
    jr z, .clear
 
; Don't clear the last 4 entries because they are used for the shadow in the
; jumping down ledge animation and the rod in the fishing animation.
    ld c, $90
 
.clear
    ld a, [hOAMBufferOffset]
    cp c
    ret nc
    ld l, a
    ld h, wOAMBuffer / $100
 
    ld de, $4 ; entry size
    ld b, $a0
	ld a, c
.clearLoop
    ld [hl], b
    add hl, de
    cp l
    jr nz, .clearLoop
    ret
 
GetSpriteScreenXY: ; 4a5f (1:4a5f)
    inc e
    inc e
    ld a, [de] ; c1x4
    ld [hSpriteScreenY], a
    inc e
    inc e
    ld a, [de] ; c1x6
    ld [hSpriteScreenX], a
    ld a, 4
    add e
    ld e, a
    ld a, [hSpriteScreenY]
    add 4
    and $f0
    ld [de], a ; c1xa (y)
    inc e
    ld a, [hSpriteScreenX]
    and $f0
    ld [de], a  ; c1xb (x)
    ret
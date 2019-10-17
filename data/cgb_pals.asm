DefaultPalette::
IF DEF(_RED)
	dw $7fff, $1bef, $0200, $0000 ; obp0
	dw $7fff, $421f, $1cf2, $0000 ; obp1
	dw $7fff, $421f, $1cf2, $0000 ; bgp
ENDC
IF DEF(_BLUE)
	dw $7fff, $421f, $1cf2, $0000 ; obp0
	dw $7fff, $7e8c, $7c00, $0000 ; obp1
	dw $7fff, $7e8c, $7c00, $0000 ; bgp
ENDC

BrownPalette::
	dw $7fff, $32bf, $00d0, $0000 ; obp0
	dw $7fff, $32bf, $00d0, $0000 ; obp1
	dw $7fff, $32bf, $00d0, $0000 ; bgp

RedPalette::
	dw $7fff, $1bef, $0200, $0000 ; obp0
	dw $7fff, $7e8c, $7c00, $0000 ; obp1
	dw $7fff, $421f, $1cf2, $0000 ; bgp

DarkBrownPalette::
	dw $7fff, $32bf, $00d0, $0000 ; obp0
	dw $7fff, $32bf, $00d0, $0000 ; obp1
	dw $639f, $4279, $15b0, $04cb ; bgp

PastelPalette::
	dw $53ff, $4a5f, $7e52, $0000 ; obp0
	dw $53ff, $4a5f, $7e52, $0000 ; obp1
	dw $53ff, $4a5f, $7e52, $0000 ; bgp

OrangePalette::
	dw $7fff, $03ff, $001f, $0000 ; obp0
	dw $7fff, $03ff, $001f, $0000 ; obp1
	dw $7fff, $03ff, $001f, $0000 ; bgp

YellowPalette::
	dw $7fff, $7e8c, $7c00, $0000 ; obp0
	dw $7fff, $1bef, $0200, $0000 ; obp1
	dw $7fff, $03ff, $012f, $0000 ; bgp

BluePalette::
	dw $7fff, $421f, $1cf2, $0000 ; obp0
	dw $7fff, $1bef, $0200, $0000 ; obp1
	dw $7fff, $7e8c, $7c00, $0000 ; bgp

DarkBluePalette::
	dw $7fff, $421f, $1cf2, $0000 ; obp0
	dw $7fff, $32bf, $00d0, $0000 ; obp1
	dw $7fff, $6e31, $454a, $0000 ; bgp

GrayPalette::
	dw $7fff, $5294, $294a, $0000 ; obp0
	dw $7fff, $5294, $294a, $0000 ; obp1
	dw $7fff, $5294, $294a, $0000 ; bgp

GreenPalette::
	dw $7fff, $03ea, $011f, $0000 ; obp0
	dw $7fff, $03ea, $011f, $0000 ; obp1
	dw $7fff, $03ea, $011f, $0000 ; bgp

DarkGreenPalette::
	dw $7fff, $421f, $1cf2, $0000 ; obp0
	dw $7fff, $421f, $1cf2, $0000 ; obp1
	dw $7fff, $1bef, $6180, $0000 ; bgp

InvertedPalette::
	dw $0000, $4200, $037f, $7fff ; obp0
	dw $0000, $4200, $037f, $7fff ; obp1
	dw $0000, $4200, $037f, $7fff ; bgp
	
OtherVersionPalette::
IF DEF(_RED)
	dw $7fff, $421f, $1cf2, $0000 ; obp0
	dw $7fff, $7e8c, $7c00, $0000 ; obp1
	dw $7fff, $7e8c, $7c00, $0000 ; bgp
ENDC
IF DEF(_BLUE)
	dw $7fff, $1bef, $0200, $0000 ; obp0
	dw $7fff, $421f, $1cf2, $0000 ; obp1
	dw $7fff, $421f, $1cf2, $0000 ; bgp
ENDC
	
TrueInvertedPalette::
IF DEF(_RED)
	dw $0000, $6410, $7dff, $7fff ; obp0
	dw $0000, $3de0, $630d, $7fff ; obp1
	dw $0000, $3de0, $630d, $7fff ; bgp
ENDC
IF DEF(_BLUE)
	dw $0000, $3de0, $630d, $7fff ; obp0
	dw $0000, $0173, $03ff, $7fff ; obp1
	dw $0000, $0173, $03ff, $7fff ; bgp
ENDC

CheaterPastelPalette::
	dw $53ff, $4a5f, $7e52, $0000 ; obp0
	dw $53ff, $4a5f, $7e52, $0000 ; obp1
	dw $53ff, $4a5f, $7e52, $3c0c ; bgp

HotPinkPalette::
	dw $7fe0, $03ff, $03e0, $741f ; obp0
	dw $7fe0, $03ff, $03e0, $741f ; obp1
	dw $0000, $03ff, $03e0, $741f ; bgp
	
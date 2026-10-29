; /// NAME ENTRY SCREEN ///
; Initial name and nick copy
; Don't halve byte length for char count (each char is 1 byte now)
; Name
.org 0xd1cdd8
nop

; Nick
.org 0xd1cde8
nop

; Make max name len 8 chars instead of 4
.org 0xd1cdf0
slti	v1,0x8

; Pad name with 0xa0 instead of 0x8140
.org 0xd1ce00
li		a2,0xa0

; Don't duplicate char count for padding offset calc
.org 0xd1ce14
sra		v1,0x10

; Make max name len 8 chars instead of 4
.org 0xd1ce34
slti	a0,0x8
nop

; Make max nick len 16 chars instead of 8
.org 0xd1ce58
slti	v0,0x10

; Pad nick with 0xa0 instead of 0x8140
.org 0xd1ce64
li		a3,0xa0

; Don't duplicate char count for padding offset calc
.org 0xd1ce78
sra		v1,0x10

; Make max nick len 16 chars instead of 8
.org 0xd1ce98
slti	a0,0x10
nop

; Make max name len 8 chars instead of 4
.org 0xd1ceb8
slti	v0,0x8

; When reaching 8, overwrite with 7 instead of 3
.org 0xd1cec4
li		v0,0x7

; Cursor on-screen
; Name
; Add 6 chars instead of 3 ("NAME: " vs orig jap)
.org 0xd1ccd0
addiu	v0,0x6

; Each char is 6px wide instead of 12
.org 0xd1ccdc
sll		a1,0x1

; Nick
; Add 8 chars instead of 4 ("NICK:   " vs orig jap)
.org 0xd1ccf0
addiu	v0,0x8

; Each char is 6px wide instead of 12
.org 0xd1ccfc
sll		a1,0x1

; Char selection cursor movement
; We don't need the kana/hira/kanji menus
; Easiest way to get them out of the way is skip them with the cursor
; Make cursor land on first row of chars
; upon cycling downwards from last row
.org 0xd1d76c
j		0x800a2f8c
addiu	v0,a0,-0x28

; Make cursor land on last row of chars
; upon cycling upwards from first row
.org 0xd1d6dc
slti	v0,0x0

; Char name writing
; When writing a char make max len 8 instead of 4
.org 0xd1d4c0
slti	v0,a0,0x8

.org 0xd1d4cc
li		v0,0x7

; Don't duplicate next char pos
.org 0xd1d2e8
nop

; Only write one char
.org 0xd1d3a0
nop

; Fix char deletion with X button
; Make max name char length 7 instead of 4
.org 0xd1d548
li		a0,0x7

; Don't duplicate name length (1 char = 1 byte)
.org 0xd1d56c
move	v0,v1

; Delete using just one 0xa0 (blank space)
.org 0xd1d578
li		a2,0xa0

.org 0xd1d584
j		0x800a2db0
lui		v0,0x800d

.org 0xd1d598
j		0x800a2df8
nop

.org 0xd1d5d0
li		v1,0xa0
nop

.org 0xd1d5f4
nop

; Fix char deletion with DEL option
; Make max name char length 7 instead of 4
.org 0xd1db80
slti	v0,t1,0x7

.org 0xd1dbc4
slti	v0,t1,0x7

; Don't duplicate name length (1 char = 1 byte)
.org 0xd1db8c
move	a1,t1

.org 0xd1db98
move	v1,t1

.org 0xd1dbcc
move	a1,t1

.org 0xd1dbe8
move	v0,t1

; Delete using just one 0xa0 (blank space)
.org 0xd1dbf0
li		v1,0xa0

.org 0xd1dc08
nop

; Make max name len 8 on cursor move
; using FWD and BACK options
.org 0xd1daf0
slti	v0,a0,0x8

.org 0xd1dafc
li		v0,0x7

; Fix blank space input using SP option
; Make blank space be 0xa0
.org 0xd1dcf4
li		v1,0xa0

; Don't duplicate name length (1 char = 1 byte)
.org 0xd1dd00
nop

; Store just one char
.org 0xd1dd20
nop

.org 0xd1dd4c
slti	v0,0x8

.org 0xd1dd54
li		v0,0x7

; NICKNAME
; Don't duplicate len
.org 0xd1d3cc
nop

; Write only one char
.org 0xd1d484
nop

; Fix DEL
.org 0xd1dc24
slti	v0,t1,0xf

.org 0xd1dc30
move	a1,t1

.org 0xd1dc3c
move	v1,t1

.org 0xd1dc68
slti	v0,t1,0xf

.org 0xd1dc70
move	a1,t1

.org 0xd1d4f8
slti	v0,0x10

.org 0xd1d500
li		v0,0xf

.org 0xd1dc8c
move	v0,t1

.org 0xd1dc94
li		v1,0xa0

.org 0xd1dcac
nop

; Fix FWD
.org 0xd1db28
slti	v0,0x10

.org 0xd1db30
li		v0,0xf

; Fix SP
.org 0xd1dd68
li		v1,0xa0

.org 0xd1dd74
nop

.org 0xd1dd88
nop

.org 0xd1dd94
nop

.org 0xd1ddc0
slti	v0,0x10

.org 0xd1ddc8
li		v0,0xf

; rstrip function
; Change SJIS 0x8140 space for 0xa0
.org 0xd1e1cc
li		a3,0xa0
li		a2,0xa0

.org 0xd1e214
li		t1,0xa0
li		t0,0xa0

.org 0x18a00
.string "A B C D E F G H I a b c d e f g h i "
.string "J K L M N O P Q R j k l m n o p q r "
.string "S T U V W X Y Z   s t u v w x y z   "
.string "0 1 2 3 4 + - * / ! ? \" # $ % & ; : "
.string "5 6 7 8 9 @ ~ | < > = , . ' ( ) [ ] "

.org 0xccfc88
.string "(none)"

.org 0xccfe38
.string " %"

.org 0xcd4250
.string "Hero"

.org 0xcd4258
.string "Heroine "

.org 0xcd427c
.string "Name"

.org 0xcd4288
.string "Left"

.org 0xcd472c
.string "none"

.org 0xcd4734
.string "Level Up"

.org 0xcd475c
.string "    "

.org 0xcd4764
.string "    "

.org 0xcd476c
.string "    "

.org 0xcd4774
.string "    "

.org 0xcd477c
.string "OK  "

.org 0xcd4784
.string "SP  "

.org 0xcd478c
.string "DEL "

.org 0xcd4794
.string "BACK"

.org 0xcd479c
.string "FWD"

.org 0xcd47a4
.string "_ "

.org 0xcd47a8
.string "NAME: "

; For "Nickname" see DATA.BIN_extra_text.asm

.org 0xcd47bc
.string "Enter your name (up to 8 characters)"

.org 0xcd47f8
.string "Is this name OK?"

.org 0xcd481c
.string "Is this nickname OK?"

.org 0xcd4840
.string "Enter your nickname (up to 16 characters) "

; Hard-coded pointer to previous message
.org 0xd1e0f8
la		v0,0x8005a040

.org 0xcd486c
.string "Kei-chan"

.org 0xcd4878
.string "Mizuki"

.org 0xcd4880
.string "Keisuke "

; ///LONGER WORDAGE IN MENUS///
; Equipment classes
; (e.g. "Armour" and "Trinket")
; 0x8008bea8
.org 0xd066a8
sll		s1,v0,0x3
li		s2,0x4
sw		s2,0x18(sp)

; 0x8008bee4
.org 0xd066e4
sw		v0,0x14(sp)
sll		a2,0x10
sra		a2,0x10
jal		0x800178f4
sw		t0,0x10(sp)
move	a0,s1
sll		s0,0x10
sra		a1,s0,0x10
jal		0x80018fb8
move	a2,s2
li		s2,0x3

; 0x8008c79c
.org 0xd06f9c
addiu	s2,v0,-0x15a8

; Locomotion name
; (e.g. "Walking")
; 0x8008c7d0
.org 0xd06fd0
li		v0,0x5

.org 0xd06ff4
li		a2,0x5

; 0x8008c868
.org 0xd07068
addiu	s1,s2,0xa

; Skill
; New max length 20 chars
; 0x8008c898
.org 0xd07098
li		v0,0xa

; 0x8008c8bc
.org 0xd070bc
li		a2,0xa

; Push start of weapon name to 800cea76
; 0x8008c8cc
.org 0xd070cc
addiu	s0,s2,0x1e

; Push start of armour name to 800cea86
; 0x8008c954
.org 0xd07154
addiu	s0,v0,-0x157a

; Push start of trinket name to 800cea96
; 0x8008c9ec
.org 0xd071ec
addiu	s0,v0,-0x156a

; Odd hard-coded start of locomotion,
; skill, weapon, armour, trinket
; 0x8008cac8
.org 0xd072c8
la		s0,0x800cea58

; Extend max length of status menu names
; "Attack Techniques"
.org 0xd07480
li		v0,0x9

; 0x8008cc90
.org 0xd07490
li		a2,0x9
.org 0xd074e0
sh		v0,0x12(s1)
lh		a0,0x12(s1)
.org 0xd07508
addiu	s7,s1,0x14

; Fix menu line
; 0x8008ccd4
.org 0xd074d4
li		a1,0xcb

; "Special Skills"
.org 0xd0760c
addiu	v0,0x55df
.org 0xd07614
li		v0,0x7
.org 0xd07624
li		a2,0x7

; 0x8008ce74
.org 0xd07674
sh		v0,0xe(s1)
lh		a0,0xe(s1)
.org 0xd0769c
addiu	s7,s1,0x10

; Fix menu line
; 0x8008ce68
.org 0xd07668
li		a1,0xcb

; Status ailments
; Delete all of the equipment classes
; 0x8008ca88
.org 0xd07288
addiu	s0,s2,-0x20
move	a0,s0
jal		0x80018d0c
li		a1,0x10
j		0x8008cac8
nop

.org 0xd072c8
la		s0,0x800cea5c

.org 0xd07310
addiu	s5,s0,-0x7c

; Move status ailments 12px to the left
; (make room for more chars)
; 0x8008cb8c
.org 0xd0738c
addiu	a1,0x17

; Make each status ailment
; 8 chars long
; 0x8008cb1c
.org 0xd0731c
move	s2,s3
sll		s4,s3,0x3
la		s1,0x800cea96
addu	s1,s4,s1
sll		s4,s3,0x2

.org 0xd07350
li		v0,0x4

.org 0xd073c8
li		a2,0x4

.org 0xd07358
li		v1,0x0

; Delete last new glyphs
; Skill and items
; 0x8008d64c
.org 0xd07e4c
li		a1,0x72

; 0x8008bd9c
.org 0xd0659c
li		a1,0x72

; Special skill/Technique names
; 0x8008bdb8
.org 0xd065b8
li		a1,0x46

; 0x8008d65c
.org 0xd07e5c
li		a1,0x46

; Account for longer status
; ailments when turning on/off
; glyphs for inactive conditions
; 0x8008cbe4
.org 0xd073e4
sll		s1,s4,0x1

.org 0xd0741c
slti	v0,v0,0x4

; 0x8008cac8
.org 0xd072c8
la		s0,0x800cea60

.org 0xd072d8
li		a1,0x7
addiu	a0,s0,0x16

.org 0xd072e8
addiu	a0,s0,0x26

.org 0xd072f4
addiu	a0,s0,0x36

.org 0xd07310
addiu	s5,s0,-0x80

; Terrain type
; Move "%" 5px to the right to make space
; 0x8008f128
.org 0xd09928
li		a1,0x125

; Move terrain name 5px to the left
; 0x8008f004
.org 0xd09804
li		a1,0xe7

; Move digits to the right
; 0x8008f08c
.org 0xd0988c
li		a1,0x109

.org 0xd098c8
li		a0,0x11a

.org 0xd098f8
li		a0,0x122

; Make terrain name 2 chars longer
; 0x8008f02c
.org 0xd0982c
li		s2,0x4

; Move terrain name
; 0x8008effc
.org 0xd097fc
addiu	s4,v0,-0xf50

.org 0xd09840
addiu	s3,s4,-0x30

.org 0xd09888
addiu	a0,s4,-0x18

; Delete new chars
; 0x8008fb20
.org 0xd0a320
li		a1,0x1c

; Fix terrain percentage digits
; 0x8008f07c
.org 0xd0987c
sw		s2,0x14(sp)

.org 0xd098ac
li		s2,0x3

; Equip Weapon/Armour/Trinket submenu
; Make text longer by 4 chars
; 0x8008fbfc
.org 0xd0a3fc
addiu	s1,s0,0x80

; Erase longer item descriptions
; 0x8008fcfc
.org 0xd0a4fc
li		a1,0x3f

; 0x8008fc30
.org 0xd0a430
li		v0,0x7

.org 0xd0a44c
li		a2,0x7

; Move text start to the left
.org 0xd0a404
li		a1,0xe

; Erasing the 4 extra chars
; 0x8008ea98
.org 0xd09298
la		a0,0x800cee90

.org 0xd092a4
li		a1,0x7

; Move description graphical elements
; in memory to make room for longer
; menu title
; 0x8008d210
.org 0xd07a10
lh		v0,0x34e(v1)

.org 0xd07a38
addiu	v0,v1,0x34e

; 0x8008d2e8
.org 0xd07ae8
la		a0,0x800ceeb0

.org 0xd07bbc
la		a0,0x800ceee0

; 0x8008eeb4
.org 0xd096b4
la		s0,0x800cee9e

.org 0xd096c8
addiu	s0,-0x34e

; Delete extra chars
; 0x8008ebb8
.org 0xd093b8
li		a1,0x87

; Attack menu
; Make values longer ("Power", "Range")
; 0x80095a58
.org 0xd10258
addiu	s1,0x158

.org 0xd1026c
addiu	s1,0x6

.org 0xd10288
li		v0,0x3

; "Effect", "Range"
; 0x80096148
.org 0xd10948
addiu	s1,0x158

.org 0xd1095c
addiu	s1,0x6

.org 0xd10978
li		v0,0x3

; Effect name
; Move 6px to the right
; 0x800961f0
.org 0xd109f0
li		a1,0xf2

; Make name longer
.org 0xd10a40
li		v0,0x4

; Delete new location
; 0x800976ec
.org 0xd11eec
li		a1,0x92

; Attack name window
; Store sprite offsets in new position
; 0x800901e4
.org 0xd0a9e4
lh		v1,-0xf40(v0)

.org 0xd0a9f8
addiu	s1,v0,-0xf40

; Delete new position
; 0x800904e0
; la		a0,0x800cf0c0

; 0x8009043c
.org 0xd0ac3c
addiu	s1,v0,-0xf40

; 0x800904e0
.org 0xd0ace0
la		a0,0x800cf0c0

; Special skill name window
; Store sprite offsets in new position
; 0x8009029c
.org 0xd0aa9c
lh		v1,-0xf40(v0)

.org 0xd0aab0
addiu	s1,v0,-0xf40

; Victory conditions window
; Move lines to the left
; 0x800a0830
.org 0xd1b030
li		a1,0x3c

.org 0xd1b1ac
li		a1,0x3c

; Extend lines to 34 half-width chars
; 0x800a0828
.org 0xd1b028
sll		a0,a2,0x6

.org 0xd1b054
li		v0,0x11

.org 0xd1b1c8
li		v0,0x11

; 0x800a09a4
.org 0xd1b1a4
la		a0,0x800d2d5e

; Delete new extra chars
; 0x800a0a34
.org 0xd1b234
li		a1,0x50

; Use Item menu
; The name of the right column ("残")
; was processed and displayed by calling
; function 800177a8. This function only
; deals with a single glyph, and we need
; two for the translation ("Le" and "ft")
; Hence, this code snippet removes that
; call and invokes function 800178f4
; instead, with appropriate parameters,
; which allows to process and display
; multi-glyph strings (and is used in
; several other places in the game)
; 0x80097904
.org 0xd12104
la		a0,0x80059a88
sw		a0,0x10(sp)
la		a0,0x800d2bf6
li		a1,0xfa
li		a2,0x38
jal		0x800178f4
li		a3,0x7
j		0x8009793c
nop

; Fix length of separator line
; 0x800978b0
.org 0xd120b0
li		a1,0x91

; Fix box display for item use in battle
; 0x8009035c
.org 0xd0ab5c
lh		v1,-0xf40(v0)

.org 0xd0ab70
addiu	s1,v0,-0xf40

; Attack Techniques submenu
; delete longer descriptions
; 0x8008d704
.org 0xd07f04
li 		a1,0x40

; /// Fix double whitespace at end of character names ///
; In dialogues
; Check flag and update glyph
; X coordinate
; 0x80087a30
.org 0xd02230
;~ j		0x8001c96c
j		0x8001c9b4
sll		v1,0x2

; in ENDING overlay
; 0x800563f4
.org 0x14e9bf4
;~ j		0x8001cb44
j		0x8001c9e4

; Check character name last letter
; and set flag
; (during dialogues)
; 0x80087dd8
.org 0xd025d8
j		0x8001c940
lw		ra,0x14(sp)

; (during dialogues in ENDING overlay)
; 0x80056724
.org 0x14e9f24
;~ j		0x8001cb00
j		0x8001c96c

; (during dialogues, after pressing X
; to make the text go fast)
; 0x8008815c
.org 0xd0295c
;~ j		0x8001cae4
j		0x8001c998

; In victory/defeat conditions screen
; Victory
; 0x800a07f0
.org 0xd1aff0
j		0x8001ca14

.org 0xd1b00c
j		0x8001ca14

.org 0xd1b01c
j		0x8001ca30

; Defeat
; 0x800a0970
.org 0xd1b170
j		0x8001ca58

.org 0xd1b18c
j		0x8001ca58

.org 0xd1b19c
j		0x8001ca74

; Same hack for the item menu as in line
; 703, but this time for when the menu
; shows between scenarios and it displays
; "Left" and "All"
; 0x8007e728
.org 0xcf8f28
addiu	a0,s1,0x394
li		a1,0xe0
li		a2,0x20
li		a3,0x8
la		v0,0x800546eb
jal		0x800178f4
sw		v0,0x10(sp)
addiu	a0,s1,0x398
li		a1,0x101
li		a2,0x20
li		a3,0x8
la		v0,0x80054390
jal		0x800178f4
sw		v0,0x10(sp)

; Fix separator line length
; 0x8007e6e8
.org 0xcf8ee8
li		a1,0xb4

; Party formation screen
; Move "limit" and "current" to the left
; 0x8007fd08
.org 0xcfa508
li		a1,0x10

.org 0xcfa534
li		a1,0x10

; Move scenario number to the right
; 0x8007fd5c
.org 0xcfa55c
li		a1,0x50

; Make room for "Target size"
; 0x8007fd04
.org 0xcfa504
addiu	a0,s0,0x54

.org 0xcfa51c
li		s2,0x6

.org 0xcfa530
addiu	a0,s0,0x46

.org 0xcfa5ec
addiu	a0,s0,0x2

.org 0xcfb3a0
addiu	a0,s0,0x2

; Move target and current numbers to the right
; 0x8007fd90
.org 0xcfa590
li		a1,0x56

.org 0xcfa5f0
li		a1,0x56

; 0x80080ba4
.org 0xcfb3a4
li		a1,0x56

; /// MOVE VALUES IN STATUS MENU ///
; Attack
; base value
; 0x8008bfec
.org 0xd067ec
addiu   a1,0x18

; extra value
; 0x8008c0b0
.org 0xd068b0
addiu   a1,0x3f

; Defense
; base value
; 0x8008c1b0
.org 0xd069b0
addiu   a1,0x1f

; extra value
; 0x8008c274
.org 0xd06a74
addiu   a1,0x46

; Tech
; base value
; 0x8008c374
.org 0xd06b74
addiu   a1,0x18

; extra value
; 0x8008c438
.org 0xd06c38
addiu   a1,0x3f

; Speed
; base value
; 0x8008c538
.org 0xd06d38
addiu   a1,0x1f

; extra value
; 0x8008c5fc
.org 0xd06dfc
addiu   a1,0x46

; Move
; 0x8008c668
.org 0xd06e68
li      a1,0x34

; /// MOVE VALUES IN EQUIP MENU ///
; Make box wider to fit new graphics
; 0x8008e034
.org 0xd08834
li      a3,0x78

; X pos Attack, Defense, etc.
; 0x8008e060
.org 0xd08860
li      a0,0x4

; 0x8008e110
.org 0xd08910
li      a0,0x4

; Y pos Attack, Defense, etc.
; 0x8008e078
.org 0xd08878
addiu   a1,s0,0x5

; Attack
; base value
; 0x8008e150
.org 0xd08950
li      a1,0x2a

; extra value
; 0x8008e2ac
.org 0xd08aac
li      a1,0x52

; Defense
; base value
; 0x8008e1e0
.org 0xd089e0
li      a1,0x2a

; extra value
; 0x8008e320
.org 0xd08b20
li      a1,0x52

; Tech
; base value
; 0x8008e224
.org 0xd08a24
li      a1,0x2a

; extra value
; 0x8008e374
.org 0xd08b74
li      a1,0x52

; Speed
; base value
; 0x8008e268
.org 0xd08a68
li      a1,0x2a

; extra value
; 0x8008e3c8
.org 0xd08bc8
li      a1,0x52

; Slashes
; 0x8008e0b8
.org 0xd088b8
li      a0,0x4a
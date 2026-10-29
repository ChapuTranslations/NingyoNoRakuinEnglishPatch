; /// TEXT ROUTINE HACK ///
.org 0x8001cd00
lw		s1,0x90(gp)
j		0x8001cd38
move	a1,v1

; // Get texture base for ASCII char
.org 0x8001cd40
move	s0,v0
j		0x8001cd60
nop

; // fetch and merge ASCII textures
.org 0x8001c8b0
andi	a0,a1,0x7f00
srl		a0,0x8
andi	a1,a1,0x7f
addiu	a0,a0,-0x11
addiu	a1,a1,-0x11
li		v0,0xb
mult	a0,v0
mflo	a0
mult	a1,v0
mflo	a1
addu	a0,a0,s1
addu	a1,a1,s1
la		v1,merge_area

loop:
lbu		a2,0x0(a0)
addiu	a0,0x1
lbu		a3,0x0(a1)
addiu	a1,0x1
sll		a3,0x2
sb		a3,0x1(v1)
srl		a3,0x8
or		a2,a3
sb		a2,0x0(v1)
addiu	v0,-0x1
bne		v0,r0,loop
addiu	v1,0x2

la		v0,merge_area
jr		ra
nop

merge_area:
.dw 0x0,0x0,0x0,0x0,0x0,0x0

; Extend max length of right-side values
; in option menu from 8 to 10 chars
; (to fit "Very Fast")
.org 0x8001f5f8
addiu	s7,v0,-0x6618
li		s6,0x5

.org 0x8001f600
sll		s2,s4,0x4
addu	v0,s2,s5
lw		v0,0x0(v0)
sll		v1,s4,0x3
subu	v1,s4
sll		v1,0x1
li		s0,0xa
mult	s4,s0
mflo	s0

.org 0x8001f644
addu	v0,s4

.org 0x8001f674
move	s1,s4

; Extend max length of Status menu names
; to fit "Attack Techniques" and
; "Special Skills" 
.org 0x8001f6b4
addiu	a1,0xca

; Flag value writing to signal
; custom character names ending in
; space (a0)
; (during dialogues)
.org 0x8001c940
lw		v0,0x158(a0)
addiu	v1,-0x1
addu	v0,v1
lbu		v0,0x0(v0)
li		v1,0xa0
bne		v0,v1,return_flag_write
li		v0,0x1
sb		v0,0x160(a0)

return_flag_write:
li		v0,0x2
j		0x80087de0
sb		v0,0x13c(a0)

; (during dialogues in ENDING overlay)
.org 0x8001c96c
;~ .org 0x8001cb00
lw		v0,0x148(a0)
addiu	v1,-0x1
addu	v0,v1
lbu		v0,0x0(v0)
li		v1,0xa0
bne		v0,v1,return_flag_write_ending
li		v0,0x1
sb		v0,0x150(a0)

return_flag_write_ending:
li		v0,0x2
j		0x8005672c
sb		v0,0x12c(a0)

; (during dialogues, after pressing X
; to make the text go fast)
.org 0x8001c998
lbu		v0,-0x1(a0)
li		v1,0xa0
bne		v0,v1,return_flag_write_x_press
li		v0,0x1
sb		v0,0x160(a1)

return_flag_write_x_press:
j		0x80088288
nop

; Flag value reading
; If the custom character name ends
; in a space, write next chars
; 6px to the left
.org 0x8001c9b4
lbu		v0,0x160(a2)
mult	a1,a0
bne		v0,r0,flag_is_set
nop
j		0x80087a38
nop

flag_is_set:
; if current X coordinate is 0,
; we encountered a line break and
; the value should NOT be updated
bne		v1,r0,return_update_x_coord
nop
j		0x80087a38
sb		r0,0x160(a2)

return_update_x_coord:
j		0x80087a38
addiu	v1,-0x6

; for dialogues in ENDING overlay
.org 0x8001c9e4
lbu		v0,0x150(a2)
sll		v1,0x2
bne		v0,r0,flag_is_set_ending
nop
j		0x800563fc
nop

flag_is_set_ending:
; if current X coordinate is 0,
; we encountered a line break and
; the value should NOT be updated
bne		v1,r0,return_update_x_coord_ending
nop
j		0x800563fc
sb		r0,0x150(a2)

return_update_x_coord_ending:
j		0x800563fc
addiu	v1,-0x6

; Remove possible double space after
; strcatting user input names in victory 
; conditions screen
.org 0x8001ca14
lbu		s0,-0x2(a0)
li		v0, 0xa0
bne		s0,v0,victory_condition_name_no_space
nop
sb		r0,-0x2(a0)

victory_condition_name_no_space:
j		0x800a0798
nop

; Remove possible double space after
; strncatting text between names in
; victory conditions screen
.org 0x8001ca30
ulhu	s0,-0x2(a0)
li		v0, 0xa0a0
bne		s0,v0,victory_condition_text_no_space
nop
sb		r0,-0x1(a0)

victory_condition_text_no_space:
j		0x800a0798
nop

; Same shite but for defeat condition...
.org 0x8001ca58
lbu		s0,-0x2(a0)
li		v0, 0xa0
bne		s0,v0,defeat_condition_name_no_space
nop
sb		r0,-0x2(a0)

defeat_condition_name_no_space:
j		0x800a0918
nop

.org 0x8001ca74
ulhu	s0,-0x2(a0)
li		v0, 0xa0a0
bne		s0,v0,defeat_condition_text_no_space
nop
sb		r0,-0x1(a0)

defeat_condition_text_no_space:
j		0x800a0918
nop

; Halve space between two digits
.org 0x80017d4c
addiu	a0,s6,0x6

.org 0x80017d94
addiu	a0,s6,-0x6

; /// SAVE FILE NAME MODIFICATION ///
; New text
.org 0x8003b2c0
.sjisn "ＯＧＡＥＲＩＴＯ　ＸＸ　ＬＶ　ＸＸ　ＳＣＥＮＡＲＩＯ　ＸＸ"

.org 0x8001a200
nop
nop
nop

.org 0x8001a264
sb		v0,0x23(s1)

.org 0x8001a2a0
sb		a0,0x25(s1)

.org 0x8001a2e4
sb		v0,0x3b(s1)

.org 0x8001a324
sb		a0,0x3d(s1)

.org 0x8001a354
sb		v0,0x3b(s1)

.org 0x8001a38c
sb		v1,0x3d(s1)

; /// LOAD/SAVE SCREEN REFORMATTING ///
; Move file number to the left
.org 0x80020158
li		a1,0x36

; Move character name to the left
.org 0x800201e4
li		a1,0x57

; Move "scenario" to the end
; of the first line
.org 0x80020298
li		a1,0xe2

.org 0x800202bc
addiu	a2,s0,-0xe

; Move scenario number to the
; end of the first line
.org 0x800202fc
li		a1,0x119
addiu	a2,s0,-0xe		

.org 0x800203c0
li		a1,0x119
addiu	a2,s0,-0xe

; Make scenario name MUCH longer
; Lots of manual address changes
; to pack everything together
; and make room for scenario names

; Messages like "Load?" etc are now a maximum
; of 30 chars/15 glyphs long
.org 0x8001fc3c
li		s1,0x10

.org 0x8001fc50
addiu	a0,s2,0x30

.org 0x8001fc74
addiu	a0,s2,0x50

; Delete all pop up window messages
; in one go
.org 0x80021a2c
li		a1,0x38
j		0x80021a54
nop

.org 0x80021b58
li		a1,0x38
j		0x80021b80
nop

; Save file text block start
.org 0x80020028
addiu	s7,v0,-0x6218

; Section base 0x80049a90
.org 0x80020030
addiu	s1,s7,-0x358

; ?? 0x49e20 (used for "New save")
.org 0x80020038
addiu	s5,s1,0x390

; ?? "Scenario" pos (0x2c(sp))
.org 0x80020044
addiu	t1,s1,0x384

; Delete longer save file text block
.org 0x80020088
li		a1,0x32

; Should point to section base
.org 0x800200c4
lw		v0,-0x358(s7)

.org 0x80020150
addiu	a0,s7,0x16

.org 0x800201dc
addiu	a0,s7,0x1a

; Character name pos 0x80049ac0
.org 0x800201f0
addiu	v0,s7,-0x328

.org 0x8002020c
addiu	a0,s7,0x22

.org 0x80020228
li		t1,0x3

.org 0x8002023c
addiu	a0,s7,0x28

.org 0x800202f4
addiu	a0,s1,0x38c

.org 0x80020440
li		v0,0x15

.org 0x80020470
li		v0,0x15

.org 0x80020480
addiu	s5,0x64

.org 0x8002049c
addiu	t1,0x64

; extra EXTRA long name
.org 0x800204a8
addiu	fp,0x64

.org 0x800204b8
addiu	s2,0x64

.org 0x800204e4
lh		a0,0x352(s0)

.org 0x800204f0
lh		a0,0x354(s0)

.org 0x800204f8
sh		s1,0x352(s0)

.org 0x8002050c
sh		s1,0x354(s0)

.org 0x800205ac
sh		v0,0x354(s0)

.org 0x80020a98
li		a1,0x36
j		0x80020ac0
nop

.org 0x80020b18
nop
nop
lh		a0,0x350(s0)

.org 0x80020b38
sh		v0,0x350(s0)

; Delete longer save file text block
.org 0x80021df4
addiu	s0,v0,-0x6218

.org 0x80021e04
li		a1,0x32

.org 0x80021e14
addiu	s0,0x64

; Bloody pointers or smth
.org 0x800205f4
lh		v0,0x356(s0)

.org 0x80020630
sh		v0,0x356(s0)

.org 0x80020678
lh		a0,0x356(s0)

.org 0x800206c0
lh		a0,0x356(s0)

.org 0x80021884
lh		a0,0x356(s0)

.org 0x80021894
sh		v0,0x356(s0)

.org 0x80021e18
la		s0,0x80049de2

.org 0x80020ac0
lh		a0,0x350(s0)

.org 0x80020ad4
sh		v0,0x350(s0)

.org 0x80021a58
lh		a0,0x350(s1)

.org 0x80021a6c
sh		v0,0x350(s1)

.org 0x80020ed4
lh		a0,0x350(s0)

.org 0x80020eec
sh		v1,0x350(s0)

.org 0x80020ef8
lh		v0,0x350(s0)

.org 0x80020f34
sh		v0,0x350(s0)

.org 0x80020f40
lh		a0,0x350(s0)

.org 0x80020568
sh		v0,0x352(s0)

.org 0x80021b84
lh		a0,0x350(s0)

.org 0x80021b94
sh		v0,0x350(s0)

; Shitty hack to center the
; scenario name
.org 0x8002047c
j		center_scenario_name

.org 0x8001ca9c
center_scenario_name:
; Left text limit on box px 0x18
; Right text limit on box px 0x128
; Total space for name px 0x110

; Call strlen to get name length
jal		0x80038f50
lw		a0,0x10(sp)

; Check if last byte is blank 0xa0
lw		v1,0x10(sp)
nop
addu	v1,v0
sb		r0,0x1(v1)
lbu		v1,-0x1(v1)
li		a1,0xa0
bne		v1,a1,not_space
nop

; If it is, subtract 1 char/byte
addiu	v0,-0x1
not_space:

; Mult name length in chars by
; 6px per char
sll		v1,v0,0x1
addu	v1,v0
sll		v1,v1,0x1

; Total space for name in px
li		v0,0x110

; Get final X pos for name,
; call proper func and return
sub		v0,v0,v1
srl		v0,0x1
addiu	a0,s5,-0x64
li		a3,0x5
jal		0x800178f4
addiu	a1,v0,0x18
j		0x80020484
nop

; Space for strcating scenario
; name and "end"
.org 0x8001caf8
cat_buffer:
.dw 0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0

; 0x8001cb2c to 0x8001cb54
; is reserved for a couple of
; lines of translated text
; (see msgs 7273 in SLPS_028.54_text.asm)

; When saving after finishing a
; battle, the game appends "end"
; at the end of the scenario name
; when displaying the save.
; Originally this was shown at a
; fixed position. We want that
; to be strcated to the name so
; everything is centered.
; strcpy scenario name to buffer
.org 0x80020400
la		a0,cat_buffer

.org 0x80020438
lw		a1,0x0(v0)
jal		0x80038f40
sw		a0,0x10(sp)
sw		s4,0x14(sp)
li		v0,0x15
j		0x8002047c
sw		v0,0x18(sp)

.org 0x80020338
la		a0,cat_buffer

.org 0x80020370
lw		a1,0x0(v0)
jal		0x80038f40
sw		a0,0x10(sp)

; check if last char is space 0xa0
; strlen copied name
jal		0x80038f50
move	a0,v0

lw		a0,0x10(sp)
li		v1,0xa0
addu	v0,a0,v0
lbu		a3,-0x1(v0)
li		t7,0x16
bne		a3,v1,strcat_end
sw		s4,0x14(sp)

; delete space with 0
sb		r0,-0x1(v0)

; strcat "end" at end of buffer
strcat_end:
la		a1,0x80044f4c
jal		0x80038f00
move	a2,s0

; store params for call to func
; func 800178f4 and continue
j		0x8002047c
sw		t7,0x18(sp)
; 941
.org 0xcce800
.string "Do you wish to restore HP?"

; 942
.org 0xcd53e0
la		a3,0x80054025
.org 0xcce825
.string "Do you wish to restore MP?"

; 943
.org 0xcd5f40
la		a3,0x80054048
.org 0xd12730
lui		a3,0x8005
.org 0xd1273c
addiu	a3,0x4048
.org 0xcce848
.string "Do you wish to restart this scenario? "

; 944
.org 0xccea14
.string "Is this location correct? "

; 945
.org 0xccea98
.string "Do you wish to attack?"

; 946
.org 0xcceb00
.string "Do you wish to use this special skill?"

; 947
.org 0xcceb70
.string "Do you wish to use this item? "

; 948
.org 0xcceea0
.string "Are you ready to depart?"

; 949
.org 0xcceee0
.string "Name"

; 950
.org 0xcceeeb
.string "Left"

; 951
.org 0xcceb90
.string "All "

; 952
.org 0xccef18
.string "Do you wish to discard this item? "

; 953
.org 0xcf95fc
addiu	s3,0x473b
.org 0xccef3b
.string "Do you wish to use this item? "

; 954
.org 0xccef88
.string "Scenario"

; 955
.org 0xcfa514
la		v0,0x8005475a
.org 0xccef5a
.string "Target size:"

; 956
.org 0xcfa540
la		v0,0x80059b48
.org 0xcd4348
.string "Current:"

; 957
.org 0xcfadc4
addiu	s3,v0,0x47a0
.org 0xccefa0
.string "This person can't be removed"

; 958
.org 0xcfabd8
la		s1,0x800547bd
.org 0xccefbd
.string "There are too many people in the group"

; 959
.org 0xcfafb8
la		s1,0x800547e4
.org 0xccefe4
.string "There are not enough members"

; 960
.org 0xcfb040
la		a3,0x80054801
.org 0xccf001
.string "Do you wish to depart?"

; 961
.org 0xd0b370
la		a1,0x800548f4
.org 0xccf0f4
.stringn "Found "
.db 0x25,0x73,0x00

; 962
.org 0xccf104
.stringn " Used "
.db 0x25,0x73,0x00

; 963
.org 0xccf468
.string "Messages will not be displayed. Is that alright?"

; 964
.org 0xccfdcc
.string "Attack Techniques "

; 965
.org 0xccfddf
.string "Special Skills"

; 966
.org 0xd07a7c
addiu	a1,0x55fc
.org 0xd07b4c
la		a1,0x800555fc
.org 0xccfdfc
.string "Main character"

; 967
.org 0xd07aa8
la		a1,0x8005560b
.org 0xd07b7c
la		a1,0x8005560b
.org 0xccfe0b
.string "Heroine "

; 968
.org 0xd08448
addiu	v0,0x5614
.org 0xccfe14
.string "No change "

; 969
.org 0xd08460
la		v0,0x80055658
.org 0xccfe58
.string "Remove Equipment"

; 970
.org 0xd0b34c
lui		a1,0x800d
.org 0xd0b354
addiu	a1,0xdd20
.org 0x7520
.string "There was nothing inside"

; 971
.org 0xcd42fc
.string "Do you wish to end this battle? "

; 972
.org 0xd12864
addiu	a3,-0x64e3
.org 0xcd431d
.string "Do you wish to save your progress so far? "

; 973
.org 0x1000
.string "Scenario"

; 974
.org 0x100c
.string "->"

; 975
.org 0x14e781c
.string "Save your progress so far?"

; Surrogate glyphs for "Paralysed" + EOL
; (DATA.BIN_text msg 88)
.org 0xccfb58
.db 0xd0,0xe1,0x9b,0x9c,0x9d,0x9e,0xe5,0xe4,0x00

; Surrogate glyphs for "Terrified" + space + EOL
; (DATA.BIN_text msg 89)
.org 0xccfb61
.db 0xd4,0xe5,0x98,0x99,0x9a,0xe5,0xe4,0xa0,0x00

; Surrogate glyphs for "Nickname:" + space + EOL
.org 0xcd47b0
.db 0x91,0x92,0x93,0x94,0x95,0x96,0x97,0xa0,0x00

; Not on my watch
.org 0xcd41e0
.dh 0x0
boss_move:
{
    ; TODO: should probably double check that we don't need to preserve registers (A,X)...

	JSL $09C114         ; Restore the dungeon_resetsprites
	LDA $A0             ; load room index (low byte)
	LDX $A1             ; 				  (high byte)

	CMP #7   : BNE +    ; Is is Hera Tower Boss Room
	CPX #$00 : BNE +
		BRL .move_to_middle
	+

	CMP #200 : BNE +    ; Is is Eastern Palace Boss Room
        JSL $09C44E     ; reset sprites twice in that room for some reasons (fix bug with kholdstare)
        JSL $09C114     ; Restore the dungeon_resetsprites
        BRL .move_to_bottom_right
	+

	CMP #41 : BNE +     ; Is is Skull Woods Boss Room
        ; Add moving floor sprite
        BRL .move_to_bottom_right
	+

	CMP #51 : BNE +     ; Is is Desert Palace Boss Room 
        JSL $09C44E     ; reset sprites twice in that room for some reasons (fix bug with kholdstare)
        JSL $09C114     ; Restore the dungeon_resetsprites
        BRL .move_to_bottom_left
	+

	CMP #90 : BNE +     ; Is is Palace of darkness Boss Room
        JSL $09C44E     ; reset sprites twice in that room for some reasons (fix bug with kholdstare)
        JSL $09C114     ; Restore the dungeon_resetsprites
        BRL .move_to_bottom_right
	+

	CMP #144 : BNE +    ; Is is Misery Mire Boss Room
        JSL $09C44E     ; reset sprites twice in that room for some reasons (fix bug with kholdstare)
        JSL $09C114     ; Restore the dungeon_resetsprites
        BRL .move_to_bottom_left
	+

	CMP #172 : BNE +    ; Is is Thieve Town Boss Room
                        ; IF MAIDEN IS NOT RESCUED -> DO NOTHING
                        ; IF MAIDEN IS ALREADY RESCUED -> spawn sprites normally
        JSL $09C44E     ; removes sprites in thieve town boss room
        JSL $09C114     ; Restore the dungeon_resetsprites
        ;Close the door if $408001 flag == 1
        LDA !BLIND_DOOR_FLAG : BEQ .no_blind_door
        INC $0468
        STZ $068E
        STZ $0690
        INC $7E0CF3 
         ; ;That must be called after the room load NotLikeThis !
        .no_blind_door
        BRL .move_to_bottom_right
	+

	CMP #6   : BNE +    ; Is is Swamp Palace Boss Room
	CPX #$00 : BNE +
        JSL $09C44E     ; reset sprites twice in that room for some reasons (fix bug with kholdstare)
        JSL $09C114     ; Restore the dungeon_resetsprites
        BRL .move_to_bottom_left
	+

	CMP #222 : BNE +    ; Is is Ice Palace Boss Room
    	BRL .move_to_top_right
	+

	CMP #164 : BNE +    ; Is is Turtle Rock Boss Room
    	BRL .move_to_bottom_left
	+

	CMP #28 : BNE +     ; Is is Gtower (Armos2) Boss Room
	CPX #$00 : BNE +
    	BRL .move_to_bottom_right
	+

	CMP #108 : BNE +    ; Is is Gtower (Lanmo2) Boss Room
        JSL $09C44E     ; reset sprites twice in that room for some reasons (fix bug with kholdstare)
        JSL $09C114     ; Restore the dungeon_resetsprites
        BRL .move_to_bottom_left
	+

	CMP #77 : BNE +     ; Is is Gtower (Moldorm2) Boss Room
        JSL $09C44E     ; reset sprites twice in that room for some reasons (fix bug with kholdstare)
        JSL $09C114     ; Restore the dungeon_resetsprites
        BRL .move_to_middle
	+

	BRL .return


	.move_to_middle
    ;load all sprite of that room and overlord
    LDX #$00
    .loop_middle
    LDA $0D10, X : !ADD #$68 : STA $0D10, X
    LDA $0D00, X : !ADD #$68 : STA $0D00, X
    INX : CPX #$10 : BNE .loop_middle
    LDX #$00
    .loop_middle2
    LDA $0B08, X : !ADD #$68 : STA $0B08, X
    LDA $0B18, X : !ADD #$68 : STA $0B18, X
    INX : CPX #$08 : BNE .loop_middle2
    BRL .return


	.move_to_top_right
    LDX #$00
    .loop_top_right
    LDA $0D20, X : !ADD #$00 : STA $0D20, X
    LDA $0D30, X : !ADD #$01 : STA $0D30, X
    INX : CPX #$10 : BNE .loop_top_right
    LDX #$00
    .loop_top_right2
    LDA $0B10, X : !ADD #$01 : STA $0B10, X
    LDA $0B20, X : !ADD #$00 : STA $0B20, X
    INX : CPX #$08 : BNE .loop_top_right2
    BRL .return


	.move_to_bottom_right
    LDX #$00
    .loop_bottom_right
    LDA $0D20, X : !ADD #$01 : STA $0D20, X
    LDA $0D30, X : !ADD #$01 : STA $0D30, X
    INX : CPX #$10 : BNE .loop_bottom_right
    LDX #$00
    .loop_bottom_right2
    LDA $0B10, X : !ADD #$01 : STA $0B10, X
    LDA $0B20, X : !ADD #$01 : STA $0B20, X
    INX : CPX #$08 : BNE .loop_bottom_right2
    BRL .return


	.move_to_bottom_left
    LDX #$00
    .loop_bottom_left
    LDA $0D20, X : !ADD #$01 : STA $0D20, X
    LDA $0D30, X : !ADD #$00 : STA $0D30, X
    INX : CPX #$10 : BNE .loop_bottom_left
    LDX #$00
    .loop_bottom_left2
    LDA $0B10, X : !ADD #$00 : STA $0B10, X
    LDA $0B20, X : !ADD #$01 : STA $0B20, X
    INX : CPX #$08 : BNE .loop_bottom_left2
    BRL .return


	.return
	RTL
}

gibdo_drop_key:
{
    LDA $A0 : CMP #$39 : BNE .no_key_drop       ; Check if the room id is skullwoods before boss
    LDA $0DD0, X : CMP #$09 : BNE .no_key_drop  ; Check if the sprite is alive
    LDA #$01 : STA $0CBA, X;set key
    .no_key_drop
    JSL $06DC5C ;Restore draw shadow
    RTL
}

WriteGfxBlock:
{
    ;DMA_VRAM(VRAM_HIGH,VRAM_LOW,SRC_BANK,SRC_HIGH,SRC_LOW,LENGTH_HIGH,LENGTH_LOW)
;    %DMA_VRAM(#$34,#$00,#$24,#$B0,#$00,#$10,#$00)
    RTL
}

new_kholdstare_code:
{
;    LDA $0CBA : BNE .already_iced
;    LDA #$01 : STA $0CBA
;    JSL WriteGfxBlock;
;    .already_iced
;    JSL $0DD97F
    RTL
}

new_trinexx_code:
{
;    LDA.b #$03 : STA $0DC0, X
;    JSL WriteGfxBlock;
    RTL
}

new_sprites_damage:
{
	LDA $7EF35B : STA $00 ; set armor value in $00
	LDA $0CD2, X : AND.b #$7F ;load damage the sprite is doing
	CPY $00 : BEQ .no_mail
	.have_mail
		LSR : DEY ;decrease A by half 
	CPY $00 : BNE .have_mail ;while $00 > 0 then loop back and decrease damage by half
		.no_mail
	TAY
	STA $00 : STA $0373
	RTL
}

.segment "A2MON"
.include "apple2rom.s"
.segment "A2MORE"
.include "a2basicrom.s"
.segment "A2DISK"
.include "apple2disk.s"
.segment "BANKROM"
.include "picodriveterm.s"

.segment "OS"


;Keyboard
KEYRAM         = $C000

;ACIA C0
A_RXD          = $C100
A_TXD          = $C100
A_STS          = $C101
A_RES          = $C101
A_CMD          = $C102
A_CTL          = $C103

; devices
;VIA D1
PORTB          = $C200
PORTA          = $C201
DDRB           = $C202
DDRA           = $C203
T1CL           = $C204
T1CH           = $C205
T1LL           = $C206
T1LH           = $C207
T2L            = $C208
T2H            = $C209
SHCTL          = $C20A
ACR            = $C20B     ; auxiliary control register
PCR            = $C20C     ; peripheral control register
IFR            = $C20D 
IER            = $C20E     ; interrupt enable register


;General purpose ZP VARIABLES

SOURCE_LOW     = $B0
SOURCE_HIGH    = $B1
RD_BYTES_LOW   = $B2
RD_BYTES_HIGH  = $B3
MSG_ADDR_LOW   = $B4
MSG_ADDR_HIGH  = $B5


;VIA config flags 
ICLR           = %01111111  ; clear all VIA interrupts

; PORTA
;PS2 Keyboard 
PS2_KB_DATA    = %10000000 
PS2_KB_CLK     = %01000000 

;SD card pins
SD_CS          = %00010000
SD_SCK         = %00001000
SD_MOSI        = %00000100
SD_MISO        = %00000010

PORTA_OUTPUTPINS = SD_CS | SD_SCK | SD_MOSI

; PORT_B
; GAMEPAD pins
GC_CLOCK       = %10000000
GC_LATCH       = %01000000
GC_DATA1       = %00100000
GC_DATA2       = %00010000

PS2_MOUSE_CLK  = %00000010
PS2_MOUSE_DATA = %00000001

PORTB_OUTPUTPINS = GC_CLOCK | GC_LATCH

; PS/2 keyboard memory locations
KBSTATE        = $CE00
KBTEMP         = $CE01
KBCURR         = $CE02 

KBEXTEND       = $CE03
KBKEYUP        = $CE04
KBDBG          = $CE05
KBDBG2         = $CE06
KEYTEMP        = $CE07
KEYLAST        = $CE08
MUTE_OUTPUT    = $CE09
MOUSE_SEND     = $CE0A
MOUSE_FLAGS    = $CE0B
MOUSE_X_POS    = $CE0C
MOUSE_Y_POS    = $CE0D
MOUSE_BYTE     = $CE0E
MOUSE_REPORT   = $CE0F
MOUSE_STATE    = $CE10
MOUSE_T1_L     = $CE11
MOUSE_T1_H     = $CE12
MOUSE_T2_L     = $CE13
MOUSE_T2_H     = $CE14
JOYSTICK_MODE  = $CE15
KBD_BYTE       = $CE16
KBD_SEND       = $CE17
KBD_LEDS       = $CE18
KBD_NONPRINT   = $CE19
MOUSE_X_SIGN   = $CE20
MOUSE_Y_SIGN   = $CE21

; Joystick modes
JOY_MODE_PADS  = 0
JOY_MODE_MOUSE = 1

; keyboard processing states
PS2_START      = $00
PS2_KEYS       = $01
PS2_PARITY     = $02
PS2_STOP       = $03

; mouse processing states
PS2_M_START    = $00
PS2_M_BITS     = $01
PS2_M_PARITY   = $02
PS2_M_STOP     = $03

; scancode definitions

SC_F1  = $05
SC_F2  = $06
SC_F3  = $04
SC_F4  = $0C
SC_F5  = $03
SC_F6  = $0B
SC_F7  = $83
SC_F8  = $0A
SC_F9  = $01
SC_F10 = $09
SC_F11 = $78
SC_F12 = $07

SC_CAPS = $58
SC_SCROLL = $7E
SC_NUMLOCK = $77
SC_LEFTSHIFT = $12
SC_RIGHTSHIFT = $59
SC_ALT = $11
SC_CTRL = $14

; extended
SC_RIGHTWIN = $27
SC_LEFTWIN  = $1F

; Mouse states
MOUSE_REPORT_A  = 0
MOUSE_REPORT_X  = 1
MOUSE_REPORT_Y  = 2

; starting of 512 byte buffer used by fat32
fat32_workspace = $C800  ; $C800 - $C9FF

KBBUF           = $0200 ; $CA00
KEYSTATE        = $CB00
fat32_variables = $CC00
GAMEPAD1        = $CEE0
GAMEPAD2        = $CEF0

; BANKING VARIABLE
BANKING_MODE    = $CAFE

;GAMEPAD INDICES

GAMEPAD_B       = $0
GAMEPAD_Y       = $1
GAMEPAD_SELECT  = $2
GAMEPAD_START   = $3
GAMEPAD_UP      = $4
GAMEPAD_DOWN    = $5
GAMEPAD_LEFT    = $6
GAMEPAD_RIGHT   = $7
GAMEPAD_A       = $8
GAMEPAD_X       = $9
GAMEPAD_L       = $A
GAMEPAD_R       = $B

; DOS
dos_command    = $CD00  ; command line
dos_params     = dos_command + $7F
dos_param_3    = dos_command + $7E  ; the command
dos_param_2    = dos_command + $7D
dos_param_1    = dos_command + $7C
dos_param_0    = dos_command + $7B
dos_file_param = dos_command + $70  ; 11 bytes
dos_addr_temp  = dos_command + $6E  ; 2 bytes
dos_cout_mode  = dos_command + $6D  ; 1 byte
dos_cursor     = dos_command + $6C  ; 1 byte
dos_addr_p2    = dos_command + $6D  ; 2 bytes
dos_addr_p3    = dos_command + $6F  ; 2 bytes

; SOFT SWITCHES

SS_BASROM_ON   = $C006
SS_BASROM_OFF  = $C007

SS_GRAPHICS    = $C050 ; Display Graphics
SS_TEXT        = $C051 ; Display Text
SS_FULLSCREEN  = $C052 ; Display Full Screen
SS_SPLITSCREEN = $C053 ; Display Split Screen
SS_DISPLAY_1   = $C054 ; Display Page 1
SS_DISPLAY_2   = $C055 ; Display Page 2
SS_LORES       = $C056 ; Display LoRes Graphics
SS_HIRES       = $C057 ; Display HiRes Graphics

SS_R_BANK2     = $C080 ; Read RAM bank 2; no write also $C084 
SS_W_BANK2     = $C081 ; Read ROM, write RAM bank 2 also $C085

SS_R_ROM2      = $C082 ; Read ROM; no write also $C086
SS_RW_BANK2    = $C083 ; Read/write RAM bank 2 also $C087

SS_R_BANK1     = $C088 ; Read RAM bank 1; no write also $C08C
SS_W_BANK1     = $C089 ; Read ROM; write RAM bank 1 also $C08D
SS_R_ROM1      = $C08A ; Read ROM; no write also $C08E
SS_RW_BANK1    = $C08B ; Read/write RAM bank 1 also $C08F


; =================================================================================

via_init:
    lda #PORTA_OUTPUTPINS   ; Set various pins on port A to output
    sta DDRA

    lda #PORTB_OUTPUTPINS
    sta DDRB

    lda #%00100010  ; configure CA1 and CA2 for negative active edge for PS/2 clocks
    sta PCR        ; configure CA2 for negative edge independent interrupt, for PS/2, CB2 for negative interrupt for keyboard strobe

    lda #$0
    sta ACR

    lda #$7F
    sta IFR

    lda #%11111011 
    sta IER        ; enable interrupts for CA2, CA1, CB1, CB2 and Timer1, Timer2

    rts

kbclear:
    ldx #$0
    lda #$0
@clrbufx:
    sta KEYSTATE, x
    sta KBBUF, x
    sta dos_command, x
    sta IN, x
    inx
    bne @clrbufx
    rts

;CODE
init:
    sei
    cld

    lda SS_BASROM_OFF

; init PS/2 kb stuff
    lda #$00
    sta KBSTATE
    sta KBTEMP
    sta KBCURR
    sta KBEXTEND
    sta KBKEYUP
    sta KEYTEMP
    sta KEYLAST
    sta KEYRAM
    sta BANKING_MODE
    
    ; init joystick
    sta $C064
    sta $C065
    sta $C066
    sta $C067

    sta MUTE_OUTPUT
    sta MOUSE_STATE
    sta MOUSE_REPORT

    ldx #$00           ; clear the key state and input buffers
@clrbufx:
    sta KEYSTATE, x
    sta KBBUF, x
    sta dos_command, x
    sta fat32_workspace, x 
    sta fat32_workspace+1, x
    sta fat32_variables, x
    sta IN, x
    sta $CE00,x         ; special variables
    inx
    bne @clrbufx

    ; mouse to center
    lda #$80
    sta MOUSE_X_POS
    sta MOUSE_Y_POS
    
    ldx #STACK_TOP
    txs

    ; put machine into text mode with default font 
    bit SS_TEXT
    bit SS_DISPLAY_1
    bit SS_FULLSCREEN
    bit SS_HIRES
    bit SS_R_ROM2

    stz INPUTBUFFER

; initialize the ACIA
    stz A_RES      ; soft reset (value not important)

                   ; set specific modes and functions
                   ; no parity, no echo, no Tx interrupt, Rx interrupt, enable Tx/Rx
    lda #%00001001
    sta A_CMD      ; store to the command register

    ;lda #$00      ; 1 stop bits, 8 bit word length, external clock, 16x baud rate
    lda #$1F       ; 1 stop bits, 8 bit word length, internal clock, 19.2k baud rate
    sta A_CTL      ; program the ctl register

    jsr via_init
    
    cli

    lda #$9B
@loop:
    jsr     SETNORM         ;  set screen mode
    jsr     A2INIT          ;  and init kbd/screen
    jsr     SETVID          ;  as I/O dev's
    jsr     SETKBD
    jsr     hook_buffer

    ; initialize the mouse
    
    jmp dos
    jsr MON
    jmp @loop

hires1:
    bit SS_GRAPHICS
    bit SS_DISPLAY_1
    bit SS_HIRES
    rts

hires2:
    bit SS_GRAPHICS
    bit SS_DISPLAY_2
    bit SS_HIRES
    rts

textmode:
    bit SS_TEXT
    bit SS_DISPLAY_1
    bit SS_FULLSCREEN
    rts
    

.segment "OS"
.include "libfat32.s"

.segment "OS"
.include "dos.s"


MSG_FILENOTFOUND:
    .byte "NOFOUND"
    .byte $8D,0

MSG_FILE_ERROR:
    .byte "ERR"
    .byte $8D,0

.segment "CODE"
; load and save for eb6502
eb_load:
    ; go get the filename from $200
    ; start of basic program is at $28,$29 little endian
    ; end of basic program is at $2E,$2f

    jsr fat32_start
    jsr parse_basic_filename
    
    jsr fat32_finddirent
    bcs @file_not_found

    jsr fat32_opendirent
    jsr fat32_basic_load
    bra @success

@file_not_found:
    lda     #<MSG_FILENOTFOUND
    ldy     #>MSG_FILENOTFOUND
    jsr     STROUT
    bra     @exit

@success:
    jsr     display_ok

@exit:
    jmp     FIX_LINKS

eb_save:
    pha

    ; go get filename from $200
    jsr fat32_start

    sec
    lda $2E ; end of program low byte
    sbc $28 ; start of program low byte
    sta fat32_bytesremaining
    pha
    lda $2f ; end of program high byte
    sbc $29 ; end of program low byte
    sta fat32_bytesremaining+1
    pha
    lda #$00
    sta fat32_bytesremaining+2
    sta fat32_bytesremaining+3

    jsr parse_basic_filename

    jsr fat32_allocatefile

    pla 
    sta fat32_bytesremaining + 1
    pla
    sta fat32_bytesremaining

    jsr fat32_open_cd

    ;jsr fat32_dump_diskstats
    
    jsr fat32_writedirent
    bcs @error

    lda $28
    sta fat32_address
    ;jsr print_hex

    lda $29
    sta fat32_address+1
    ;jsr print_hex

    jsr fat32_file_write
    bcc @success

@error:
    jsr display_error
    bra     @exit

@success:
    jsr display_ok

@exit:
    pla
    jmp     FIX_LINKS


; parse basic filename
parse_basic_filename:
    pha
    phx
    phy 

    lda #$00
    sta SOURCE_LOW
    lda #$02
    sta SOURCE_HIGH
    
    ldy #$00
    ldx #$00
    stx dos_param_0

@find_open_quote:
    lda (SOURCE_LOW),y
    iny
    cmp #'"'
    bne @find_open_quote

@copy_file_name:
    lda (SOURCE_LOW),y
    iny
    cmp #'"'
    beq @end_of_string
    sta dos_command,x
    inx
    cpx #$0b
    bne @copy_file_name

@end_of_string:
    inx
    lda #$00
    sta dos_command, x

    ldy #<dos_command
    sty fat32_filenamepointer
    ldy #>dos_command
    sty fat32_filenamepointer+1    

    ldx #$00
    jsr fat32_prep_fileparam

    lda #<dos_file_param
    sta fat32_filenamepointer
    lda #>dos_file_param
    sta fat32_filenamepointer+1

    ply
    plx
    pla
    rts
   
; load and save routines for the pico implementation
eb_load_pico:
    pha
    sta     $C0F1    ; load
    lda     $C0FF    ; get status value
    beq     @success

    cmp     #2
    bne     @foundfile

    lda     #<MSG_FILENOTFOUND
    ldy     #>MSG_FILENOTFOUND
    jsr     STROUT

@foundfile:
    lda     #<MSG_FILE_ERROR
    ldy     #>MSG_FILE_ERROR
    jsr     STROUT
    bra     @exit

@success:
    jsr     display_ok

@exit:
    pla
    jmp     FIX_LINKS

eb_save_pico:
    pha
    sta     $C0F0   ; save 
    lda     $C0FF   ; get status value
    
    beq     @success

    jsr     display_error
    bra     @exit

@success:
    jsr     display_ok

@exit:
    pla
    jmp     FIX_LINKS

.segment "OS"

wdc_pause:
    phx
    ldx #$B0

@wdc_pause_loop1:
    inx
    cpx #$00
    bne @wdc_pause_loop1

    ldx #$B0
@wdc_pause_loop2:
    inx
    cpx #$00
    bne @wdc_pause_loop2

    plx
    rts

tx_char_sync:
    pha
@wait:
    lda A_STS              ; get status byte
    and #$10               ; mask transmit buffer status flag
    beq @wait              ; loop if tx buffer full
    pla

    pha
    and #$7F
    sta A_TXD
    pla
    
    ; workaround for WDC chip
    ; skip pause for now since rendering text is so expensive
    jsr wdc_pause

    rts



;==========================================================================
; Keyboard
;==========================================================================

read_char_async_apple:
    lda KBCURR
    cmp #$00
    beq @exit
    jsr read_char_upper
@exit:
    rts

read_char_upper:
   jsr read_char
   bit KEYTEMP
   bvc @exit
   and #$DF
   sta KEYTEMP
@exit:
   ora #$80
   rts

read_char_async:
    lda KBCURR
    cmp #$00
    beq @exit
    jsr read_char
@exit:
    rts

;read_char_upper_echo:
;    jsr read_char_upper
;    and #$7F
;    jsr display_char
;    rts

read_char:
    phx
@readloop:
    lda KBCURR
    cmp #$00
    beq @readloop  ; loop waiting for keyboard input
 
    sei
    lda KBBUF      ; this is our keyboard input
    sta KEYTEMP

    ldx #$00
@moveloop:
    inx
    lda KBBUF,x
    dex
    sta KBBUF,x
    inx
    cpx KBCURR
    bne @moveloop

    dec KBCURR

    lda KEYTEMP
    clc
    cli

    plx
    rts

; DISPLAY 

display_apple_char:
    pha
    bit dos_cout_mode
    bmi @collect_dos
    cmp #$84 ; ctrl+d means dos command
    beq @start_collect_dos

    jsr display_char
    
    pla
    rts

@start_collect_dos:
    lda #$ff
    sta dos_cout_mode
    lda #$0
    sta dos_command
    sta dos_cursor
    pla
    rts

@collect_dos:
    cmp #$8D ; carraige return means execute
    beq @execute_dos    
    phx
    ldx dos_cursor
    jsr tx_char_sync
    and #$7F
    sta dos_command,x
    inc dos_cursor
    plx
    pla
    rts

@execute_dos:
    phx
    jsr tx_char_sync
    ldx dos_cursor
    lda #$00
    sta dos_cout_mode
    sta dos_cursor
    phy
    jsr parse_command
    ply
    plx
    pla
    rts

print_char:
display_char:
    pha
    phx
    jsr tx_char_sync
    ldx MUTE_OUTPUT
    bne @done
    ora #$80    
    jsr COUT1
@done: 
    plx
    pla
    rts

display_message:
    pla
    sta	MSG_ADDR_LOW
    pla
    sta	MSG_ADDR_HIGH          ; get return address off the stack
    bne	@increturn

@nextchar:
    lda	(MSG_ADDR_LOW)		    ; next message character
    beq	@pushreturnaddr		    ; done?	yes, exit
    jsr	display_char

@increturn:					    ; next address
    inc	MSG_ADDR_LOW
    bne	@nextchar
    inc	MSG_ADDR_HIGH	   	    ; fix MSB of next address
    bne	@nextchar

@pushreturnaddr:
    lda	MSG_ADDR_HIGH
    pha
    lda	MSG_ADDR_LOW
    pha				; adjust return	address
    rts

print_crlf:
    pha
    lda #$8D
    jsr print_char
    pla
    rts

print_space:
    pha
    lda #$A0
    jsr print_char
    pla
    rts

    ; address stored in zp_sd_temp
print_hex_word:
    pha
    phy
    ldy #1
    lda (zp_sd_temp),y
    jsr print_hex
    dey
    lda (zp_sd_temp),y
    jsr print_hex

    ply
    pla
    rts

    ; address stored in zp_sd_temp
print_hex_dword:
    pha
    phy
    ldy #3
@loopdword:
    lda (zp_sd_temp),y
    jsr print_hex
    dey
    bpl @loopdword
    ply
    pla
    rts

print_hex:
    phx
    phy
    pha
    ror
    ror
    ror
    ror
    jsr print_nybble
    pla
    pha
    jsr print_nybble
    pla
    ply
    plx
    rts

print_nybble:
    and #15
    cmp #10
    bmi @skipletter
    adc #6
@skipletter:
    adc #48
    ora #$80
    jsr print_char
    rts


cls:
_cls:
    jmp HOME

.segment "CODE"

; some test routines

keytest:
    lda KEYRAM
    jsr print_hex
    jsr print_space
    lda KBTEMP
    jsr print_hex
    jsr print_crlf
    jmp keytest

mousetest:
    jsr _cls
@loop:
    lda     WNDTOP
    sta     CV
    ldy     #$00
    sty     CH
    
    jsr display_message
    .byte $8D,"X     =",0
    lda MOUSE_X_POS
    jsr print_hex
    jsr display_message
    .byte $8D,"Y     =",0
    lda MOUSE_Y_POS
    jsr print_hex

    jsr display_message
    .byte $8D,"BUTTON=", 0
    lda MOUSE_FLAGS
    and #$7
    jsr print_nybble

    jsr display_message
    .byte $8D,"FLAGS =",0
    lda MOUSE_FLAGS
    jsr print_hex

    jsr display_message
    .byte $8D,"STATE =",0
    lda MOUSE_STATE
    jsr print_hex

    jsr display_message
    .byte $8D,"REPORT=",0
    lda MOUSE_REPORT
    jsr print_hex

    jsr display_message
    .byte $8D,"BYTE  =",0
    lda MOUSE_BYTE
    jsr print_hex

    jmp @loop

    
joytest:
    jsr _cls
@loop:
    ; move cursor to top right of screen
    lda     WNDTOP
    sta     CV
    ldy     #$00
    sty     CH

    jsr display_message
    .byte "X=",0

    ldx #$0
    jsr PREAD
    tya
    jsr print_hex

    jsr display_message
    .byte "Y=",0

    ldx #$1
    jsr PREAD
    tya
    jsr print_hex

    lda $C061
    jsr print_space
    jsr print_hex
    
    jsr print_space
    lda $C062
    jsr print_hex

    jsr print_space
    lda $C063
    jsr print_hex

    jsr print_crlf

    jsr display_message
    .byte "G1: ",0

    ldx #$0
@dump_gamepad_1:
    lda GAMEPAD1,x
    bne @actuated1
    lda #'0'
    bra @notactuated1
@actuated1:
    lda #'1'
@notactuated1:
    jsr print_char
    inx
    cpx #$10
    bne @dump_gamepad_1  

    jsr print_crlf

    jsr display_message
    .byte "G2: ",0

    ldx #$0
@dump_gamepad_2:
    lda GAMEPAD2,x
    bne @actuated2
    lda #'0'
    bra @notactuated2
@actuated2:
    lda #'1'
@notactuated2:
    jsr print_char
    inx
    cpx #$10
    bne @dump_gamepad_2

    jsr print_crlf

    jmp @loop


.segment "NMIPROXY"
; ============================================================================================
; interrupts
; ============================================================================================

;irq_default:
;    rti
    
nmi:
    bit SS_BASROM_ON
    pha
    phx
    phy
    jmp nmi_banked

nmi_unbank:
    lda BANKING_MODE
    bne @leaveon
    bit SS_BASROM_OFF
@leaveon:
    ply
    plx
    pla
    rti

.segment "NMI"
nmi_banked:

@check_acia_interrupts:
    ; check the ACIA status register to see if we've received data
    ; reading the status register clears the irq bit
    lda A_STS
    and #%00001000   ; check receive bit
    beq @check_via_interrupts

@irq_receive:
    ; we now have the byte, we need to add it to the keyboard buffer
    lda A_RXD
    ldx KBCURR
    ;sta KBBUF, x
    ora #$80
    sta KEYRAM
    inc KBCURR

@kbstrobe:
    lda KEYRAM     ; strip off the high bit
    and #$7F
    sta KEYRAM
    
    lda #$10
    sta IFR  ; clear interrupt 
@shift:
@final_exit_long:
    jmp nmi_unbank

@ps2_mouse_decode:          ; decode 11 bits from the PS/2 mouse
    lda KEYSTATE + SC_SCROLL
    bne @decode

    ; if scroll lock is not set, don't decode mouse
    stz MOUSE_STATE
    lda #$2
    sta IFR
    jmp nmi_unbank
@decode:
    jmp @nmi_mouse_decode

@joystick_long:
    lda #$8
    sta IFR
    jmp @joystick

@check_via_interrupts:
    ; check the IFR to see if it's the VIA - aka the keyboard
    lda IFR
    bpl @final_exit_long
    ror
    bcs @ps2_keyboard_decode        ; bit 0
    ror
    bcs @ps2_mouse_decode           ; bit 1
    ror
    bcs @shift                      ; bit 2
    ror
    bcs @joystick_long              ; bit 3
    ror
    bcs @kbstrobe                   ; bit 4
    ror
    bcs @T2                         ; bit 5
    ror
    bcs @T1                         ; bit 6

    jmp nmi_unbank

; JOYSTICK
;OPNAPPLE = $C061 ;open apple (command) key data (read)
;CLSAPPLE = $C062 ;closed apple (option) key data (read)
;These are actually the first two game Pushbutton inputs (PB0
;and PB1) which are borrowed by the Open Apple and Closed Apple
;keys. Bit 7 is set (=1) in these locations if the game switch or
;corresponding key is pressed.

;PB2 =      $C063 ;game Pushbutton 2 (read)
;This input has an option to be connected to the shift key on
;the keyboard. (See info on the 'shift key mod'.)

;PADDLE0 =  $C064 ;bit 7 = status of pdl-0 timer (read)
;PADDLE1 =  $C065 ;bit 7 = status of pdl-1 timer (read)
;PADDLE2 =  $C066 ;bit 7 = status of pdl-2 timer (read)
;PADDLE3 =  $C067 ;bit 7 = status of pdl-3 timer (read)
;PDLTRIG =  $C070 ;trigger paddles
;Read this to start paddle countdown, then time the period until
;$C064-$C067 bit 7 becomes set to determine the paddle position.
;This takes up to three milliseconds if the paddle is at its maximum
;extreme (reading of 255 via the standard firmware routine).

@T2:
    lda #$20
    sta IFR

    ;lda T2L          ; clear the interrupt

    lda KEYSTATE + SC_SCROLL 
    beq @t2_gamepads

    stz MOUSE_STATE
    lda #$7F
    sta $C065         ; for mouse mode, terminate Y axis here
    jmp @check_via_interrupts

@t2_gamepads:
    ; if neither left or right are down, we're at midpoint, discharge virtual capacitor now
    ; cap is discharged by setting to 0
    ; gamepad 1
    lda GAMEPAD1 + GAMEPAD_RIGHT
    bne @trydown
    ora #$7F
    sta $C064

@trydown:
    ; same for up/down
    lda GAMEPAD1 + GAMEPAD_DOWN
    bne @gamepad2
    ora #$7F
    sta $C065

@gamepad2:
    ; gamepad 2
    lda GAMEPAD2 + GAMEPAD_RIGHT
    bne @trydown2
    ora #$7F
    sta $C066

@trydown2:
    ; same for up/down
    lda GAMEPAD2 + GAMEPAD_DOWN
    bne @t2exit
    ora #$7F
    sta $C067

@t2exit:
    jmp @check_via_interrupts

; ================
; TIMER 1 handler
; ================

@T1:
    lda #$40
    sta IFR   ; clear interrupt

    ;lda T1CL ; clear the interrupt flag

    lda KEYSTATE + SC_SCROLL
    beq @t1_gamepads

    lda #$7F
    stz MOUSE_STATE
    sta $C064  ; for mouse mode, terminate x axis here
    jmp @check_via_interrupts

@t1_gamepads:
    ; clear bit 7 on both, we're done - our virtual capacitors have discharged
    lda #$7F
    sta $C064
    sta $C065
    sta $C066
    sta $C067
    jmp @check_via_interrupts

; =========================================
;  KEYBOARD decoding
; =========================================

@ps2_keyboard_decode:
    ldx KBSTATE

    ; cpx #PS2_START  ; PS2_START is 0, cmp is not necessary
    beq @start 

    cpx #PS2_KEYS
    beq @keys
      
    cpx #PS2_PARITY
    beq @parity

    cpx #PS2_STOP
    beq @stop

    ; should never get here
    lda #$1
    sta IFR
    jmp nmi_unbank


@start:
    ; should be zero - maybe check later
    inc KBSTATE     ; start->keys
    lda #$80
    sta KBTEMP      ; flip bit 7 so when we ror we're done when carry is set
    lda #$1
    sta IFR
    jmp nmi_unbank

@keys:
    lda PORTA
    rol             ; load PS2_KB_DATA into carry flag
    ror KBTEMP
    bcs @toparity
    lda #$1
    sta IFR
    jmp nmi_unbank

@toparity:
    inc KBSTATE  ; keys->parity
    lda #$1
    sta IFR
    jmp nmi_unbank

@parity:
    ; should probably check the parity bit - all 1 data bits + parity bit should be odd #
    inc KBSTATE   ; parity->stop    

    ldx KBTEMP
    cpx #SC_LEFTSHIFT
    beq @setnonprint
    cpx #SC_RIGHTSHIFT
    beq @setnonprint
    cpx #SC_CTRL
    beq @setnonprint
    lda #$1
    sta IFR
    jmp nmi_unbank

@setnonprint:
    stx KBD_NONPRINT
    lda #$1
    sta IFR
    jmp nmi_unbank

@setextended:
    stx KBEXTEND
    lda #$1
    sta IFR
    jmp nmi_unbank

@stop:
    stz KBSTATE  ; stop->start

@process_key:
    ldx KBTEMP
    cpx #$E0
    beq @setextended
    cpx #$F0
    bne @notupflag
    
    stx KBKEYUP
; special handling on key up flag
; last key event has most processing room
; if it's a key up flag, check for special function keys
; but only if numlock is on
    
    lda KBD_LEDS
    bne @togglekey

    lda KEYSTATE + SC_NUMLOCK
    beq @skipfncheck

    lda KEYSTATE + SC_F12
    bne @handlef12
    lda KEYSTATE + SC_F11
    bne @handlef11
    lda KEYSTATE + SC_F10
    bne @handlef10
    lda KEYSTATE + SC_F9
    bne @handlef9
    lda KEYSTATE + SC_F8
    bne @handlef8
    lda KEYSTATE + SC_F7
    bne @handlef7
@skipfncheck:
    bra @ps2_keyboard_exit


@notupflag:
    lda KBKEYUP
    beq @setkeystate
    ; fall through

@clearkeystate:                  ; this is the key up path TODO: need to update key state to use ascii code instead of scan code
    ; clear flags
    stz KBEXTEND
    stz KBKEYUP
    stz KBD_NONPRINT
    ldx KBTEMP

@clear:
    lda KBD_LEDS
    beq @skipleds
    stz KBD_LEDS
    jmp @setleds

@handlef12:
    bit SS_GRAPHICS
    bit SS_HIRES
    bit SS_DISPLAY_2
    bra @ps2_keyboard_exit

@handlef11:
    bit SS_GRAPHICS
    bit SS_HIRES
    bit SS_DISPLAY_1
    bra @ps2_keyboard_exit

@handlef10:
    bit SS_GRAPHICS
    bit SS_LORES
    bit SS_DISPLAY_2
    bra @ps2_keyboard_exit

@handlef9:
    bit SS_GRAPHICS
    bit SS_LORES
    bit SS_DISPLAY_1
    bra @ps2_keyboard_exit

@handlef8:
    bit SS_TEXT
    bit SS_DISPLAY_2
    bra @ps2_keyboard_exit

@handlef7:
    bit SS_TEXT
    bit SS_DISPLAY_1
    bra @ps2_keyboard_exit

@togglekey:
    ;stx KBD_LEDS
    ldx KBD_LEDS
    lda KEYSTATE,X
    bne @turnoff
    lda #$81
    sta KEYSTATE,X
    bra @ps2_keyboard_exit
@turnoff:
    stz KEYSTATE,x
@ps2_keyboard_exit:
    lda #$1
    sta IFR
    jmp nmi_unbank

@setkeytoggle:
    stx KBD_LEDS
    bra @ps2_keyboard_exit

@skipleds:
    stz KEYSTATE,x
    lda #$1
    sta IFR
    jmp nmi_unbank

@setkeystate:          ; set the key state - this is key down path
    ;ldx KBTEMP

    cpx #SC_CAPS
    beq @setkeytoggle
    cpx #SC_SCROLL
    beq @setkeytoggle
    cpx #SC_NUMLOCK
    beq @setkeytoggle
    
    lda #$01
    ora KBEXTEND
    sta KEYSTATE, X
    stx KEYLAST

    lda KBD_NONPRINT
    bne @nonprint
    
    ; check for shift state
    lda KEYSTATE + SC_LEFTSHIFT
    ora KEYSTATE + SC_RIGHTSHIFT
    bne @shifted
    
    ; check for control state
    lda KEYSTATE + SC_CTRL
    bne @control

    ;ldx KBTEMP
    lda ps2_ascii, x

; check for caps lock, strip off the high bit
;    ldx KEYSTATE + SC_CAPS
;    beq @caps
;    and #$7F
;@caps:
    sta KEYRAM
    inc KBCURR
@nonprint:
    stz KBD_NONPRINT
    lda #$1
    sta IFR
    jmp nmi_unbank

@setleds:
    jsr set_kbd_leds
   
    stz MOUSE_STATE
    stz MOUSE_REPORT
@exit_long_6:
    lda #$1
    sta IFR
    jmp nmi_unbank

@shifted:
    lda ps2_ascii_shifted, x    
    ora #$80
    sta KEYRAM
    inc KBCURR
    lda #$1
    sta IFR
    jmp nmi_unbank

@control:
    lda ps2_ascii_control, x
    sta KEYRAM
    inc KBCURR
    lda #$1
    sta IFR
    jmp nmi_unbank

; ============================
; JOYSTICK charge
; ============================

@joystick:

    stz T1CL
    stz T1CH
    stz T2L
    stz T2H

    lda #$FF                      ; charge the capacitors
    sta $C064
    sta $C065
    sta $C066
    sta $C067

    ; lda PORTB
    lda KEYSTATE + SC_SCROLL      ; if scroll is on, it's mouse mode
    bne @joystick_mouse
    jmp @joystick_gamepads

@joystick_mouse:
    stz MOUSE_T1_H
    stz MOUSE_T2_H

    lda MOUSE_X_POS
    sta MOUSE_T1_L
    bne @set_x_timer

    stz $C064                     ; trigger x-axis immediately
    bra @joystick_mouse_y

@set_x_timer:
    ; calculate time for X axis given MOUSE_X_POS
    ; value of MOUSE_X_POS * 11
    ; left shift 3 times for * 8 and add $200 as a fast approximation
    
    ldx #$3
@x_shift_8:
    clc
    rol MOUSE_T1_L
    rol MOUSE_T1_H
    dex 
    bne @x_shift_8

    clc
    ldx #3
@x_times_11:
    clc
    lda MOUSE_T1_L
    adc MOUSE_X_POS
    sta MOUSE_T1_L
    lda MOUSE_T1_H
    adc #$0
    sta MOUSE_T1_H
    dex
    bne @x_times_11

@joystick_mouse_y:
    lda MOUSE_Y_POS
    sta MOUSE_T2_L
    bne @set_y_timer
    stz $C065            ; trigger y-axis immediately
    bra @set_timers
@set_y_timer:
    ; calculate time for Y axis given MOUSE_Y_POS

    ldx #$3
@y_shift_8:
    clc
    rol MOUSE_T2_L
    rol MOUSE_T2_H
    dex 
    bne @y_shift_8

    ldx #$3
@y_times_11:
    clc
    lda MOUSE_T2_L
    adc MOUSE_Y_POS
    sta MOUSE_T2_L
    lda MOUSE_T2_H
    adc #$0
    sta MOUSE_T2_H
    dex
    bne @y_times_11

@set_timers:
    clc
    lda MOUSE_T2_L
    sta T2L
    lda MOUSE_T2_H
    sta T2H
    
    clc
    lda MOUSE_T1_L
    sta T1CL
    lda MOUSE_T1_H
    sta T1CH 

    jmp @check_via_interrupts


@joystick_gamepads:
    ; read inputs from gamepads
    ; first, latch the input
    stz PORTB
    lda #GC_LATCH
    sta PORTB

    ldx #$00
@read_controllers:    
    lda #$00          ; first time through, this drops the latch pulse
    sta PORTB
    sta GAMEPAD1,x
    sta GAMEPAD2,x

    lda PORTB
    eor #$FF
    and #GC_DATA1
    beq @check2
    lda #$1
    sta GAMEPAD1,x

@check2:
    lda PORTB
    eor #$FF
    and #GC_DATA2
    beq @next_clock
    lda #$1
    sta GAMEPAD2,x

@next_clock:
    lda #GC_CLOCK  ; clock rise
    sta PORTB
    inx
    cpx #$10
    bne @read_controllers
    
    ; we're done, bring the clock back down
    ; first time through, this drops the latch pulse
    stz PORTB         

    ; set the buttons
    ; button pressed
    lda GAMEPAD1 + GAMEPAD_X
    ora GAMEPAD1 + GAMEPAD_B
    ror
    ror
    sta $C061
     
    lda GAMEPAD1 + GAMEPAD_Y
    ora GAMEPAD1 + GAMEPAD_A
    ora GAMEPAD2 + GAMEPAD_Y
    ora GAMEPAD2 + GAMEPAD_B
    ror
    ror
    sta $C062

    lda GAMEPAD2 + GAMEPAD_X
    ora GAMEPAD2 + GAMEPAD_A
    ror
    ror
    sta $C063

    clc
    lda GAMEPAD1 + GAMEPAD_LEFT
    ror
    ror
    eor #$FF
    sta $C064

    clc
    lda GAMEPAD1 + GAMEPAD_UP
    ror
    ror
    eor #$FF
    sta $C065

    clc
    lda GAMEPAD2 + GAMEPAD_LEFT
    ror
    ror
    eor #$FF
    sta $C066

    clc
    lda GAMEPAD2 + GAMEPAD_UP
    ror
    ror
    eor #$FF
    sta $C067

    stz T2L
    lda #$6
    sta T2H  ; set T2 for half way

    lda #$90
    sta T1CL
    lda #$0B
    sta T1CH  ; Set T1 for end discharge check

    ;lda PORTB  ; clear the interrupt
    jmp @check_via_interrupts

@nmi_mouse_decode:
    ldx #$2
    stx IFR

    lda MOUSE_STATE    

    ;cmp #PS2_M_START   ; CMP not required since PS2_M_START is 0
    beq @m_start 

    cmp #PS2_M_BITS
    beq @m_bits
      
    cmp #PS2_M_PARITY
    beq @m_parity

    cmp #PS2_M_STOP
    beq @m_stop

    ; should never get here
    jmp @check_via_interrupts

@m_start:
    ; should be zero - maybe check later
    inc MOUSE_STATE  ; 0->1
    lda #$80
    sta MOUSE_BYTE
    jmp @check_via_interrupts

@m_bits:
    lda PORTB
    ror             ; move PS2_MOUSE_DATA into carry bit
    ror MOUSE_BYTE
    ; bit 0 of MOUSE_BYTE initialized to $80
    ; after 8 shifts right, carry will be set
    bcs @m_toparity
    jmp @check_via_interrupts

@m_toparity:
    inc MOUSE_STATE ; 1->2
    jmp @check_via_interrupts

@m_parity:
    ; should probably check the parity bit - all 1 data bits + parity bit should be odd #
    inc MOUSE_STATE ; 2->3
@exit_ps2_mouse:
    jmp @check_via_interrupts

@m_stop:
    stz MOUSE_STATE ; 3->0
        
@process_mouse_report:
    lda MOUSE_REPORT
    ;cmp #MOUSE_REPORT_A   ; compare not needed since MOUSE_REPORT_A is 0
    bne @report_x 
    lda MOUSE_BYTE
    and #$8                ; in the flag report, bit 3 is always 1
    beq @exit_ps2_mouse    ; zero flag enabled means bit not set
    lda MOUSE_BYTE
    sta MOUSE_FLAGS

    stz MOUSE_X_SIGN
    stz MOUSE_Y_SIGN

    ldx #$1
; set gamepad buttons - bit 0 is left button, bit 1 is right button
    ror
    ror               ; rotate left button to bit 7
    sta $C061
    ror               ; rotate right button into bit 7
    sta $C062
    ror
                      ; 3rd mouse button into bit 7
    ror
                      ; always 1 in bit 7
                      ; x sign in carry 
    rol MOUSE_X_SIGN  ; rol into bit 1 of mouse_x_sign
    ror               ; y sign in carry
    rol MOUSE_Y_SIGN  ; rol into bit 1 of mouse_y_sign

    lda KEYSTATE + SC_NUMLOCK
    beq @noflip
    lda MOUSE_Y_SIGN
    eor #$1
    sta MOUSE_Y_SIGN

@noflip:
    inc MOUSE_REPORT       ; #MOUSE_REPORT_X

    jmp @check_via_interrupts


@report_x:       
    cmp #MOUSE_REPORT_X
    bne @report_y
    inc MOUSE_REPORT       ; #MOUSE_REPORT_Y

    ; if sign bit is 1 (negative) and result of addition is > than previous value
    ; set to 0
    ; if sign bit is 0 (positive) and result of addition is < than previous value
    ; set to $FF
    lda MOUSE_X_SIGN
    beq @x_add
@x_sub:
    clc
    lda MOUSE_X_POS
    adc MOUSE_BYTE
    bcc @x_min
    sta MOUSE_X_POS
    jmp @check_via_interrupts

@x_add:
    clc 
    lda MOUSE_X_POS     ; current mouse x pos
    adc MOUSE_BYTE      ; add the delta
    bcs @x_max
    sta MOUSE_X_POS
    jmp @check_via_interrupts

@x_min:
    stz MOUSE_X_POS
    jmp @check_via_interrupts

@x_max:
    lda #$FF
    sta MOUSE_X_POS
    jmp @check_via_interrupts

@report_y:
    stz MOUSE_REPORT   ; last report, reset state 

    lda KEYSTATE + SC_NUMLOCK
    beq @noflip2
    lda MOUSE_BYTE     ; 2's complement
    eor #$FF
    inc
    sta MOUSE_BYTE
@noflip2:
    lda MOUSE_Y_SIGN
    beq @y_add
@y_sub:
    clc
    lda MOUSE_Y_POS
    adc MOUSE_BYTE
    bcc @y_min
    sta MOUSE_Y_POS
    jmp @check_via_interrupts
@y_add:
    clc 
    lda MOUSE_Y_POS     ; current mouse x pos
    adc MOUSE_BYTE      ; add the delta
    bcs @y_max
    sta MOUSE_Y_POS
    jmp @check_via_interrupts
@y_min:
    stz MOUSE_Y_POS
    jmp @check_via_interrupts
@y_max:
    lda #$FF
    sta MOUSE_Y_POS
@exit_ps2_mouse2:
    jmp @check_via_interrupts

; =================================================================================
;  PS/2 keyboard routines
; =================================================================================
set_kbd_leds:
    phx
    lda #$F0             ; scanode set
    sta KBD_SEND
    jsr ps2_kbd_message   
    jsr ps2_kbd_read_packet

    lda #$02
    sta KBD_SEND
    jsr ps2_kbd_message     ; scancode set #2
    jsr ps2_kbd_read_packet

    lda #$ED ; set LEDs
    sta KBD_SEND
    jsr ps2_kbd_message
    jsr ps2_kbd_read_packet

    stz KBD_SEND
    clc
    lda KEYSTATE + SC_CAPS
    ror
    rol KBD_SEND
    lda KEYSTATE + SC_NUMLOCK
    ror
    rol KBD_SEND
    lda KEYSTATE + SC_SCROLL
    ror
    rol KBD_SEND
    jsr ps2_kbd_message
    jsr ps2_kbd_read_packet

    lda #$F4
    sta KBD_SEND
    jsr ps2_kbd_message
    jsr ps2_kbd_read_packet

@wait_data_high:
    lda PORTA
    rol
    bcc @wait_data_high

@wait_clock_high:
    lda PORTA
    rol
    rol
    bcc @wait_clock_high
    plx
    jmp via_init ; turn interrupts back on and RTS

ps2_kbd_message:
    lda #%01111111 
    sta IER        ; disable VIA interrupts for now

    lda #PS2_KB_CLK
    sta DDRA       ; make clock output pin

    lda #$00
    sta PORTA      ; pull clock low
    
    ldy #$0
    ; wait for 100 microseconds+
    ldx #$30
@pause:
    dex
    bne @pause

    lda #PS2_KB_DATA | PS2_KB_CLK
    sta DDRA       ; take the data as output

    lda #$00
    sta PORTA      ; pull data low

    lda #PS2_KB_DATA  
    sta DDRA       ; release the clock line

    ldy #$07 ; 8 bits
    lda KBD_SEND ; ready device code

    clc
    jsr kbd_send_bit   ; start bit is a zero

    ldx #$1 ; odd parity
@sendbyte:
    ror                  ; bit 0 -> carry
    bcc @send
    inx                  ; increment x for parity, if carry is set, it's a 1
@send:
    jsr kbd_send_bit
    dey
    bpl @sendbyte

    txa ; parity stored in X
    ror ; move bit 0->Carry
    jsr kbd_send_bit

    sec ; set carry for stop bit
    jsr kbd_send_bit

    ; release the clock
    lda #$0
    sta DDRA

@wait_data_high:
    lda PORTA
    rol
    bcc @wait_data_high

@wait_clock_high:
    lda PORTA
    rol
    rol
    bcc @wait_clock_high

    rts

kbd_send_bit:
    pha
;set data
    ror                       ; PS2_KB_DATA
    sta PORTA

@waithigh:
    lda PORTA
    and #PS2_KB_CLK
    beq @waithigh

; wait for clock to drops
@waitlow:
    lda PORTA
    and #PS2_KB_CLK
    bne @waitlow

    pla
    rts

ps2_kbd_read_packet:
    lda #$80
    sta KBD_BYTE

    jsr ps2_kbd_readbit ; start bit
    
@loop:
    jsr ps2_kbd_readbit ; bit
    ror KBD_BYTE
    bcc @loop

    jsr ps2_kbd_readbit ; parity
    jmp ps2_kbd_readbit ; stop bit


; ps2_readbit waits on ps/2 clock
; populates carry flag with data bit
ps2_kbd_readbit:
    jsr ps2_kbd_waitlow
    lda PORTA          ; read a bit
    rol                ; populate the carry bit
    jmp ps2_kbd_waithigh

ps2_kbd_waitlow:
    ; wait for kbd clock to go low
    lda PORTA
    and #PS2_KB_CLK
    bne ps2_kbd_waitlow
    rts

ps2_kbd_waithigh:
    ; wait for kbd clock to go high
    lda PORTA
    and #PS2_KB_CLK
    beq ps2_kbd_waithigh
    rts

; ================================================================================
; Mouse deoding routing - in banked ROM because it won't fit
; ================================================================================
mouse_on:
    stz MOUSE_FLAGS
    stz MOUSE_X_POS
    stz MOUSE_Y_POS
    stz MOUSE_BYTE
    stz MOUSE_REPORT
    stz MOUSE_STATE

    lda #$F3
    sta MOUSE_SEND
    jsr mouse_message   ; set sampling rate
    jsr ps2_read_mouse_packet

    cmp #$FA
    beq @setreportrate
    jsr print_hex
    jsr print_crlf
    jsr display_message 
    .byte "MOUSE: SET SAMPLING RATE", $8D,0

@setreportrate:
    lda #$0A
    sta MOUSE_SEND
    jsr mouse_message  ; set sampling rate to 10 reports per second
    jsr ps2_read_mouse_packet

    cmp #$FA
    beq @setresolution
    jsr print_hex
    jsr print_crlf
    jsr display_message 
    .byte "MOUSE: SAMPLING RATE", $8D,0
    
@setresolution:
    lda #$E8 ; set resolution
    sta MOUSE_SEND
    jsr mouse_message
    jsr ps2_read_mouse_packet

    cmp #$FA
    beq @setresolutioncount
    jsr print_hex
    jsr print_crlf
    jsr display_message 
    .byte "MOUSE: SET RESOLUTION", $8D,0

@setresolutioncount:
    lda #$03 ; set resolution to 8 count/mm
    sta MOUSE_SEND
    jsr mouse_message
    jsr ps2_read_mouse_packet

    cmp #$FA
    beq @startreporting
    jsr print_hex
    jsr print_crlf
    jsr display_message 
    .byte "MOUSE: APPLY RESOLUTION", $8D,0

@startreporting:
    lda #$F4
    sta MOUSE_SEND
    jsr mouse_message
    jsr ps2_read_mouse_packet

    cmp #$FA
    beq @success
    jsr print_hex
    jsr print_crlf
    jsr display_message 
    .byte "MOUSE: START REPORTING", $8D,0
    bra @wait_data_high
@success:
    jsr display_message 
    .byte "MOUSE READY", $8D,0
  
@wait_data_high:
    lda PORTB
    ror
    bcc @wait_data_high

@wait_clock_high:
    lda PORTB
    ror
    ror
    bcc @wait_clock_high

    jmp via_init ; turn interrupts back on

mouse_off:
    lda #$F5
    sta MOUSE_SEND
    jsr mouse_message
    rts

mouse_message:
    lda #%01111111 
    sta IER        ; disable VIA interrupts for now

    lda #PS2_MOUSE_CLK
    sta DDRB       ; make clock output pin

    lda #$00
    sta PORTB      ; pull clock low
    
    ldy #$0
    ; wait for 100 microseconds+
    ldx #$30
@pause:
    dex
    bne @pause

    lda #PS2_MOUSE_DATA | PS2_MOUSE_CLK
    sta DDRB       ; take the data as output

    lda #$00
    sta PORTB      ; pull data low

    lda #PS2_MOUSE_DATA  
    sta DDRB       ; release the clock line

    ldy #$07 ; 8 bits
    lda MOUSE_SEND ; ready device code

    clc
    jsr mouse_send_bit   ; start bit is a zero

    ldx #$1 ; odd parity
@sendbyte:
    ror                  ; bit 0 -> carry
    bcc @send
    inx                  ; increment x for parity, if carry is set, it's a 1
@send:
    jsr mouse_send_bit
    dey
    bpl @sendbyte

    txa ; parity stored in X
    ror ; move bit 0->Carry
    jsr mouse_send_bit

    sec ; set carry for stop bit
    jsr mouse_send_bit

    ; release the clock
    lda #$0
    sta DDRB

@wait_data_high:
    lda PORTB
    ror
    bcc @wait_data_high

@wait_clock_high:
    lda PORTB
    ror
    ror
    bcc @wait_clock_high

    rts

mouse_send_bit:
    pha
;set data
    rol                       ; PS2_MOUSE_DATA
    sta PORTB

@waithigh:
    lda PORTB
    and #PS2_MOUSE_CLK
    beq @waithigh

; wait for clock to drops
@waitlow:
    lda PORTB
    and #PS2_MOUSE_CLK
    bne @waitlow

    pla
    rts

ps2_read_mouse_packet:
    lda #$80
    sta MOUSE_BYTE

    jsr ps2_mouse_readbit ; start bit
    
@loop:
    jsr ps2_mouse_readbit ; bit
    ror MOUSE_BYTE
    bcc @loop

    jsr ps2_mouse_readbit ; parity
    jsr ps2_mouse_readbit ; stop bit

    lda MOUSE_BYTE
    ;jsr print_hex
    ;jsr print_crlf

    rts

; ps2_readbit waits on ps/2 clock
; populates carry flag with data bit
ps2_mouse_readbit:
    jsr ps2_mouse_waitlow
    lda PORTB          ; read a bit
    ror                ; populate the carry bit
    jsr ps2_mouse_waithigh
    rts

ps2_mouse_waitlow:
    ; wait for mouse clock to go low
    lda PORTB
    and #PS2_MOUSE_CLK
    bne ps2_mouse_waitlow
    rts

ps2_mouse_waithigh:
    ; wait for mouse clock to go high
    lda PORTB
    and #PS2_MOUSE_CLK
    beq ps2_mouse_waithigh
    rts



.segment "DATASEG"
; ============================================================================================
; data
; ============================================================================================
ps2_ascii:
  ;      0   1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
  ;.byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "`", $00; 0
  ;.byte $00, $00, $00, $00, $00, "Q", "1", $00, $00, $00, "Z", "S", "A", "W", "2", $00; 1
  ;.byte $00, "C", "X", "D", "E", "4", "3", $00, $00, " ", "V", "F", "T", "R", "5", $00; 2
  ;.byte $00, "N", "B", "H", "G", "Y", "6", $00, $00, $00, "M", "J", "U", "7", "8", $00; 3
  ;.byte $00, ",", "K", "I", "O", "0", "9", $00, $00, ".", "/", "L", ";", "P", "-", $00; 4 
  ;.byte $00, $00, "'", $00, "[", "=", $00, $00, $00, $00, $0D, "]", $00, "\", $00, $00; 5
  ;.byte $00, $00, $00, $00, $00, $00, $08, $00, $00, $00, $00, $88, $00, $00, $00, $00; 6
  ;.byte $00, $00, $8A, $00, $95, $8B, $1B, $00, $00, $00, $00, $00, $00, $00, $00, $00; 7

  ;      0   1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
  .byte "~", $1B, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "~", $00; 0
  .byte $00, $00, $00, $00, $00, $D1, $B1, $00, $00, $00, $DA, $D3, $C1, $D7, $B2, $00; 1
  .byte $00, $C3, $D8, $C4, $C5, $B4, $B3, $00, $00, $A0, $D6, $C6, $D4, $D2, $B5, $00; 2
  .byte $00, $CE, $C2, $C8, $C7, $D9, $B6, $00, $00, $00, $CD, $CA, $D5, $B7, $B8, $00; 3
  .byte $00, $AC, $CB, $C9, $CF, $B0, $B9, $00, $00, $AE, $AF, $CC, $BB, $D0, $AD, $00; 4  
  .byte $00, $00, $22, $00, $D8, $BD, $00, $00, $00, $00, $8D, $DD, $00, $DC, $00, $00; 5
  .byte $00, $00, $00, $00, $00, $00, $08, $00, $00, $00, $00, $88, $00, $00, $00, $00; 6
  .byte $00, $00, $8A, $00, $95, $8B, $9B, $00, $00, $00, $00, $00, $00, $00, $00, $00; 7

ps2_ascii_shifted:
  ;      0   1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
  .byte "`", $9B, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "~", $00; 0
  .byte $00, $00, $00, $00, $00, $D1, $A1, $00, $00, $00, $DA, $D3, $C1, $D7, $C0, $00; 1
  .byte $00, $C3, $D8, $C4, $C5, $A4, $A3, $00, $00, $A0, $D6, $C6, $D4, $D2, $A5, $00; 2
  .byte $00, $CE, $C2, $C8, $C7, $D9, $DE, $00, $00, $00, $CE, $CA, $D5, $A6, $AA, $00; 3
  .byte $00, $BC, $CB, $C9, $CF, $A9, $A8, $00, $00, $BE, $BF, $CC, ":", $D0, $DF, $00; 4  
  .byte $00, $00, $22, $00, $D8, $BD, $00, $00, $00, $00, $8D, $DD, $00, "|", $00, $00; 5
  .byte $00, $00, $00, $00, $00, $00, $08, $00, $00, $00, $00, $88, $00, $00, $00, $00; 6
  .byte $00, $00, $8A, $00, $95, $8B, $9B, $00, $00, $00, $00, $00, $00, $00, $00, $00; 7
 

ps2_ascii_control:
  ;      0   1    2    3    4    5    6    7    8    9    A    B    C    D    E    F
  .byte "~", $9B, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, "~", $00; 0
  .byte $00, $00, $00, $00, $00, $91, "!", $00, $00, $00, $9A, $93, $81, $97, "@", $00; 1
  .byte $00, $83, $98, $84, $85, "$", "#", $00, $00, $A0, $96, $86, $94, $92, "%", $00; 2
  .byte $00, $8E, $82, $88, $87, $99, "^", $00, $00, $00, $8D, $0A, $95, "&", "*", $00; 3
  .byte $00, "<", $8B, $89, $8F, ")", "(", $00, $00, ">", "?", $8C, ":", $10, "_", $00; 4
  .byte $00, $00, $A2, $00, "{", "+", $00, $00, $00, $00, $8D, "}", $00, "|", $00, $00; 5
  .byte $00, $00, $00, $00, $00, $00, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00; 6
  .byte $00, $00, $00, $00, $00, $00, $1B, $00, $00, $00, $00, $00, $00, $00, $00, $00; 7




.segment "BOOTVECTORS"
    .word nmi
    .word init
    .word IRQ

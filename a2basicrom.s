HGR_SHAPE = $1a                 ;{addr/2}   ;(2b)
HGR_BITS  = $1c                 ;hi-res color mask
HGR_COUNT = $1d                 ;hi-res high-order byte of step for line

HBASL = $26                     ;base address for hi-res drawing (low)
HBASH = $27                     ;base address for hi-res drawing (high)

MON_A1L = $3c                   ;general purpose
MON_A1H = $3d                   ;general purpose
MON_A2L = $3e                   ;general purpose
MON_A2H = $3f                   ;general purpose
                   
MON_CH = $24                    ;cursor horizontal displacement

HMASK = $30                     ;hi-res graphics on-the-fly bit mask
MEMSIZE = $73                   ;{addr/2}   ;HIMEM (2b)

TOK_TO = $c1
TOK_AT = $c5

HGR_DX   = $d0                  ;{addr/2}   ;(2b)
HGR_DY   = $d2
HGR_QUAD = $d3
HGR_E    = $d4                  ;{addr/2}   ;(2b)

HGR_X = $e0                     ;{addr/2}   ;(2b)
HGR_Y = $e2
HGR_COLOR = $e4
HGR_HORIZ = $e5                 ;byte index from GBASH,L
HGR_PAGE = $e6                  ;hi-res page to draw on ($20 or $40)
HGR_SCALE = $e7                 ;hi-res graphics scale factor
HGR_SHAPE_PTR = $e8             ;{addr/2}   ;hi-res shape table pointer (2b)
HGR_ROTATION = $f9
HGR_COLLISIONS  = $ea           ;collision counter

MIXCLR = $c052
TXTPAGE2 = $c055
HIRES = $c057                   ;RW display hi-res graphics

MON_RD2BIT = $fcfa            ;cassette read
MON_READ = $fefd              ;read data from cassette
MON_READ2 = $ff02             ;read data from cassette


;********************************************************************************
;* HGR2 statement                                                               *
;********************************************************************************
HGR2:
    bit     TXTPAGE2          ;select page 2 ($4000-5FFF)
    bit     MIXCLR            ;default to full screen
    lda     #$40              ;set starting page for hi-res
    bne     SETHPG            ;...always

;********************************************************************************
;* HGR statement                                                                *
;********************************************************************************
HGR:
    lda     #$20              ;set starting page for hi-res
    bit     TXTPAGE1          ;select page 1 ($2000-3FFF)
    bit     MIXSET            ;default to mixed screen
SETHPG:    
    sta     HGR_PAGE          ;base page of hi-res buffer
    lda     HIRES             ;turn on hi-res
    lda     TXTCLR            ;turn on graphics
                   ; Clear screen.
    lda     #$00              ;set for black background
    sta     HGR_BITS
                   ; Fill screen with HGR_BITS.
BKGND:
    lda     HGR_PAGE          ;put buffer address in HGR_SHAPE
    sta     HGR_SHAPE+1
    ldy     #$00
    sty     HGR_SHAPE
LF3FE:
    lda     HGR_BITS          ;color byte
    sta     (HGR_SHAPE),y     ;clear hi-res to HGR_BITS
    jsr     COLOR_SHIFT       ;correct for color shift
    iny                       ;(slows clear by factor of 2)
    bne     LF3FE
    inc     HGR_SHAPE+1
    lda     HGR_SHAPE+1
    and     #$1f              ;done? ($40 or $60)
    bne     LF3FE             ;no
    rts                       ;yes, return

                   ; Set the hi-res cursor position.
                   ; 
                   ;   (Y,X) = horizontal coordinate (0-279)
                   ;   A-reg = vertical coordinate   (0-191)
HPOSN:
    sta     HGR_Y             ;save Y- and X-positions
    stx     HGR_X
    sty     HGR_X+1
    pha                       ;Y-pos also on stack
    and     #$c0              ;calculate base address for Y-pos
    sta     HBASL             ;for Y=ABCDEFGH
    lsr     A                 ;HBASL=ABAB0000
    lsr     A
    ora     HBASL
    sta     HBASL
    pla                       ;     A        HBASH     HBASL
    sta     HBASH             ;?-ABCDEFGH  ABCDEFGH  ABAB0000
    asl     A                 ;A-BCDEFGH0  ABCDEFGH  ABAB0000
    asl     A                 ;B-CDEFGH00  ABCDEFGH  ABAB0000
    asl     A                 ;C-DEFGH000  ABCDEFGH  ABAB0000
    rol     HBASH             ;A-DEFGH000  BCDEFGHC  ABAB0000
    asl     A                 ;D-EFGH0000  BCDEFGHC  ABAB0000
    rol     HBASH             ;B-EFGH0000  CDEFGHCD  ABAB0000
    asl     A                 ;E-FGH00000  CDEFGHCD  ABAB0000
    ror     HBASL             ;0-FGH00000  CDEFGHCD  EABAB000
    lda     HBASH             ;0-CDEFGHCD  CDEFGHCD  EABAB000
    and     #$1f              ;0-000FGHCD  CDEFGHCD  EABAB000
    ora     HGR_PAGE          ;0-PPPFGHCD  CDEFGHCD  EABAB000
    sta     HBASH             ;0-PPPFGHCD  PPPFGHCD  EABAB000
    txa                       ;divide X-pos by 7 for index from base
    cpy     #$00              ;is X-pos < 256?
    beq     LF442             ;yes
                   ; no: 256/7 = 36 rem 4
                   ; carry=1, so ADC #4 is too large; however, ADC #4 clears carry which makes SBC
                   ; #7 only -6, balancing it out.
    ldy     #35
    adc     #$04              ;following INY makes Y=36
 LF441:   
    iny
 LF442:   
    sbc     #$07
    bcs     LF441
    sty     HGR_HORIZ         ;horizontal index
    tax                       ;use remainder-7 to look up the
    lda     MSKTBL-249,x      ; bit mask (should be MSKTBL-$100+7,X)
    sta     HMASK
    tya                       ;quotient gives byte index
    lsr     A                 ;odd or even column?
    lda     HGR_COLOR         ;if on odd byte (carry set)
    sta     HGR_BITS          ; then rotate bits
    bcs     COLOR_SHIFT       ;odd column
    rts                       ;even column

                   ; Plot a dot
                   ; 
                   ;   (Y,X) = horizontal position
                   ;   A-reg = vertical position
HPLOT0:
    jsr     HPOSN
    lda     HGR_BITS          ;calculate bit posn in GBAS,
    eor     (HBASL),y         ; HGR_HORIZ, and HMASK from
    and     HMASK             ; Y-coord in A-reg,
    eor     (HBASL),y         ; X-coord in X,Y regs.
    sta     (HBASL),y         ;for any 1-bits, substitute
    rts                       ; corresponding bit of HGR_BITS

                   ; Move left or right one pixel.
                   ; 
                   ; If status is +, move right; if -, move left
                   ; If already at left or right edge, wrap around
                   ; 
                   ; Remember bits in hi-res byte are backwards order:
                   ;   byte N  byte N+1
                   ; S7654321  SEDCBA98
MOVE_LEFT_OR_RIGHT:
    bpl  MOVE_RIGHT        ;+ move right, - move left
    lda     HMASK             ;move left one pixel
    lsr     A                 ;shift mask right, moves dot left
    bcs     LR_2              ;...dot moved to next byte
    eor     #$c0              ;move sign bit back where it was
LR_1:            
    sta     HMASK             ;new mask value
    rts

LR_2:
    dey                       ;moved to next byte, so decr index
    bpl     LR_3              ;still not past edge
    ldy     #39               ;off left edge, so wrap around screen
LR_3:
    lda     #$c0              ;new HMASK, rightmost bit on screen
LR_4:
    sta     HMASK             ;new mask and index
    sty     HGR_HORIZ
    lda     HGR_BITS          ;also need to rotate color
                   ; 
COLOR_SHIFT:
    asl     A                 ;rotate low-order 7 bits
    cmp     #$c0              ; of HGR_BITS one bit posn
    bpl     LF489
    lda     HGR_BITS
    eor     #$7f
    sta     HGR_BITS
LF489:
    rts

                   ; Move right one pixel.
                   ; 
                   ; If already at right edge, wrap around.
MOVE_RIGHT:
    lda     HMASK
    asl     A                 ;shifting byte left moves pixel right
    eor     #$80
                   ; Original:  C0 A0 90 88 84 82 81
                   ; Shifted:   80 40 20 10 08 02 01
                   ; EOR #$80:  00 C0 A0 90 88 84 82
    bmi     LR_1              ;finished
    lda     #$81              ;new mask value
    iny                       ;move to next byte right
    cpy     #40               ;unless that is too far
    bcc     LR_4              ;not too far
    ldy     #$00              ;too far, so wrap around
    bcs     LR_4              ;...always

                   ; "XDRAW" one bit
LRUDX1:
    clc                       ;C=0 means no 90 degree rotation
LRUDX2:
    lda     HGR_DX+1          ;C=1 means rotate 90 degrees
    and     #$04              ;if bit2=0 then don't plot
    beq     LRUD4             ;yes, do not plot
    lda     #$7f              ;no, look at what is already there
    and     HMASK
    and     (HBASL),y         ;screen bit = 1?
    bne     LRUD3             ;yes, go clear it
    inc     HGR_COLLISIONS    ;no, count the collision
    lda     #$7f              ;and turn the bit on
    and     HMASK
    bpl     LRUD3             ;...always

                   ; "DRAW" one bit
LRUD1:
    clc                       ;C=0 means no 90 degree rotation
LRUD2:
    lda     HGR_DX+1          ;C=1 means rotate
    and     #$04              ;if bit2=0 then do not plot
    beq     LRUD4             ;do not plot
    lda     (HBASL),y
    eor     HGR_BITS          ;1's where any bits not in color
    and     HMASK             ;look at just this bit position
    bne     LRUD3             ;the bit was zero, so plot it
    inc     HGR_COLLISIONS    ;bit is already 1; count collsn
                   ; Toggle bit on screen with A-reg.
LRUD3:
    eor     (HBASL),y
    sta     (HBASL),y
                   ; Determine where next point will be, and move there.
                   ; 
                   ;   C=0 if no 90 degree rotation
                   ;   C=1 rotates 90 degrees
LRUD4:
    lda     HGR_DX+1          ;calculate the direction to move
    adc     HGR_QUAD
CON_03:
    and     #$03              ;wrap around the circle
                   ;   00 - up
                   ;   01 - down
                   ;   10 - right
                   ;   11 - left
    cmp     #$02              ;C=0 if 0 or 1, C=1 if 2 or 3
    ror     A                 ;put C into sign, odd/even into C
    bcs     MOVE_LEFT_OR_RIGHT
                   ; 
MOVE_UP_OR_DOWN:
    bmi     MOVE_DOWN         ;sign for up/down select
                   ; Move up one pixel
                   ; 
                   ; If already at top, go to bottom.
                   ; 
                   ; Remember:  Y-coord   HBASH     HBASL
                   ;           ABCDEFGH  PPPFGHCD  EABAB000
    clc                       ;move up
    lda     HBASH             ;calc base address of prev line
    bit     CON_1C            ;look at bits 000FGH00 in HBASH
    bne     LF4FF             ;simple , just FGH=FGH-1; GBASH=PPP000CD, GBASL=EABAB000
    asl     HBASL             ;what is "E"?
    bcs     LF4FB             ;E=1, then EFGH=EFGH-1
    bit     CON_03+1          ;look at 000000CD in HBASH
    beq     LF4EB             ;Y-pos is AB000000 form
    adc     #$1f              ;CD <> 0, so CDEFGH=CDEFGH-1
    sec
    bcs     LF4FD             ;...always

LF4EB:
    adc     #$23              ;enough to make HBASH=PPP11111 later
    pha                       ;save for later
    lda     HBASL             ;HBASL is now ABAB0000 (AB=00,01,10)
                   ;    0000+1011=1011 and carry clear
                   ; or 0101+1011=0000 and carry set
                   ; or 1010+1011=0101 and carry set
    adc     #$b0
    bcs     LF4F6             ;no wrap-around needed
    adc     #$f0              ;change 1011 to 1010 (wrap-around)
LF4F6: 
    sta     HBASL             ;form is now still ABAB0000
    pla                       ;partially modified HBASH
    bcs     LF4FD             ;...always

LF4FB:
    adc     #$1f
LF4FD:
    ror     HBASL             ;shift in E, to get EABAB000 form
LF4FF:
    adc     #$fc              ;finish HBASH mods
UD_1:
    sta     HBASH
    rts

.res 1

                   ; Move down one pixel
                   ; 
                   ; If already at bottom, go to top.
                   ; 
                   ; Remember:  Y-coord   HBASH     HBASL
                   ;           ABCDEFGH  PPPFGHCD  EABAB000
MOVE_DOWN:
    lda     HBASH             ;try it first, by FGH=FGH+1
CON_04:
    adc     #$04              ;HBASH = PPPFGHCD
    bit     CON_1C            ;is FGH field now zero?
    bne     UD_1              ;no so we are finished
    asl     HBASL             ;yes, ripple the carry as high as necessary; look at "E" bit
    bcc     LF52A             ;now zero; make it 1 and leave
    adc     #$e0              ;carry = 1, so adds $E1
    clc                       ;is "CD" not zero?
    bit     CON_04+1          ;tests bit 2 for carry out of "CD"
    beq     LF52C             ;no carry, finished
                   ; increment "AB" then
                   ; 0000 --> 0101
                   ; 0101 --> 1010
                   ; 1010 --> wrap around to line 0
    lda     HBASL             ;0000  0101  1010
    adc     #$50              ;0101  1010  1111
    eor     #$f0              ;1010  0101  0000
    beq     LF524
    eor     #$f0              ;0101  1010
LF524:
    sta     HBASL             ;new ABAB0000
    lda     HGR_PAGE          ;wrap around to line zero of group
    bcc     LF52C             ;...always
LF52A:
    adc     #$e0
LF52C:
    ror     HBASL
    bcc     UD_1              ;...always

                   ; HLINRL
                   ; (never called by Applesoft)
                   ; 
                   ; Enter with: (A,X) = DX from current point
                   ;             Y-reg = DY from current point
    pha                       ;save A-reg
    lda     #$00              ;clear current point so HGLIN will
    sta     HGR_X             ; act relatively
    sta     HGR_X+1
    sta     HGR_Y
    pla                       ;restore A-reg
                   ; Draw line from last plotted point to (A,X),Y
                   ; 
                   ; Enter with: (A,X) = X of target point
                   ;             Y-reg = Y of target point
HGLIN:
    pha                       ;compute DX = X - X0
    sec
    sbc     HGR_X
    pha
    txa
    sbc     HGR_X+1
    sta     HGR_QUAD          ;save DX sign (+ = right, - = left)
    bcs     LF550             ;now find abs(DX)
    pla                       ;forms 2's complement
    eor     #$ff
    adc     #$01
    pha
    lda     #$00
    sbc     HGR_QUAD
LF550:
    sta     HGR_DX+1
    sta     HGR_E+1           ;init HGR_E to abs(X-X0)
    pla
    sta     HGR_DX
    sta     HGR_E
    pla
    sta     HGR_X             ;target X point
    stx     HGR_X+1
    tya                       ;target Y point
    clc                       ;compute DY = Y - HGR_Y
    sbc     HGR_Y             ; and save -abs(Y - HGR_Y) - 1 in HGR_DY
    bcc     LF568             ;(so + means up, - means down)
    eor     #$ff              ;2's complement of DY
    adc     #$fe
LF568:
    sta     HGR_DY
    sty     HGR_Y             ;target Y point
    ror     HGR_QUAD          ;shift Y-direction into quadrant
    sec                       ;count = DX - (-DY) = # of dots needed
    sbc     HGR_DX
    tax                       ;countl is in X-reg
    lda     #$ff
    sbc     HGR_DX+1
    sta     HGR_COUNT
    ldy     HGR_HORIZ         ;horizontal index
    bcs     MOVEX2            ;...always

                   ; Move left or right one pixel.  A-reg bit 6 has direction.
MOVEX:
    asl     A                 ;put bit 6 into sign position
    jsr     MOVE_LEFT_OR_RIGHT
    sec
                   ; Draw line now.
MOVEX2:
    lda     HGR_E             ;carry is set
    adc     HGR_DY            ;E = E - deltaY
    sta     HGR_E             ;note: DY is (-delta Y)-1
    lda     HGR_E+1           ;carry clr if HGR_E goes negative
    sbc     #$00
LF58B:
    sta     HGR_E+1
    lda     (HBASL),y
    eor     HGR_BITS          ;plot a dot
    and     HMASK
    eor     (HBASL),y
    sta     (HBASL),y
    inx                       ;finished all the dots?
    bne     LF59E             ;no
    inc     HGR_COUNT         ;test rest of count
    beq     RTS_22            ;yes, finished
LF59E:
    lda     HGR_QUAD          ;test direction
    bcs     MOVEX             ;next move is in the X direction
    jsr     MOVE_UP_OR_DOWN   ;if clr, neg, move
    clc                       ;E = E + DX
    lda     HGR_E
    adc     HGR_DX
    sta     HGR_E
    lda     HGR_E+1
    adc     HGR_DX+1
    bvc     LF58B             ;...always

MSKTBL:
    .byte   $81,$82,$84,$88,$90,$a0,$c0
CON_1C:
    .byte    $1c               ;mask for "FGH" bits
                   ; Table of COS(90*x/16 degrees)*$100 - 1, with one-byte precision, X=0 to 16
COSINE_TABLE:
    .byte   $ff,$fe,$fa,$f4,$ec,$e1,$d4,$c5,$b4,$a1,$8d,$78,$61,$49,$31,$18,$ff

                   ; HFIND - calculates current position of hi-res cursor
                   ; (not called by any Applesoft routine)
                   ; 
                   ; Calculate Y-coord from HBASH,L
                   ;       and X-coord from HORIZ and HMASK
    lda     HBASL             ;HBASL = EABAB000
    asl     A                 ;E into carry
    lda     HBASH             ;HBASH = PPPFGHCD
    and     #$03              ;000000CD
    rol     A                 ;00000CDE
    ora     HBASL             ;EABABCDE
    asl     A                 ;ABABCDE0
    asl     A                 ;BABCDE00
    asl     A                 ;ABCDE000
    sta     HGR_Y             ;all but FGH
    lda     HBASH             ;PPPFGHCD
    lsr     A                 ;0PPPFGHC
    lsr     A                 ;00PPPFGH
    and     #$07              ;00000FGH
    ora     HGR_Y             ;ABCDEFGH
    sta     HGR_Y             ;that takes care of Y-coordinate
    lda     HGR_HORIZ         ;X = 7*HORIZ + bit pos in HMASK
    asl     A                 ;multiply by 7
    adc     HGR_HORIZ         ;3* so far
    asl     A                 ;6*
    tax                       ;since 7* might not fit in 1 byte,
    dex                       ; wait till later for last add
    lda     HMASK             ;now find bit position in HMASK
    and     #$7f              ;only look at low seven
LF5F0:
    inx                       ;count a shift
    lsr     A
    bne     LF5F0             ;still in there
    sta     HGR_X+1           ;zero to hi byte
    txa                       ;6*HORIZ + log2(HMASK)
    clc                       ;add HORIZ one more time
    adc     HGR_HORIZ         ;7*HORIZ + log2(HMASK)
    bcc     LF5FE             ;upper byte = 0
    inc     HGR_X+1           ;upper byte = 1
LF5FE:
    sta     HGR_X             ;store lower byte
RTS_22:
    rts

                   ; DRAW0
                   ; (not called by Applesoft)
    stx     HGR_SHAPE         ;save shape address
    sty     HGR_SHAPE+1
                   ; Draw a shape
                   ; 
                   ;   (Y,X) = shape starting address
                   ;   A-reg = rotation ($00-3F)
DRAW1:
    tax                       ;save rotation ($00-3F)
    lsr     A                 ;divide rotation by 16 to get
    lsr     A                 ; quadrant (0=up, 1=rt, 2=dwn, 3=lft)
    lsr     A
    lsr     A
    sta     HGR_QUAD
    txa                       ;use low 4 bits of rotation to index
    and     #$0f              ; the trig table
    tax
    ldy     COSINE_TABLE,x    ;save cosine in HGR_DX
    sty     HGR_DX
    eor     #$0f              ;and sine in DY
    tax
    ldy     COSINE_TABLE+1,x
    iny
    sty     HGR_DY
    ldy     HGR_HORIZ         ;index from HBASL,H to byte we're in
    ldx     #$00
    stx     HGR_COLLISIONS    ;clear collision counter
    lda     (HGR_SHAPE,x)     ;get first byte of shape defn
LF626:
    sta     HGR_DX+1          ;keep shape byte in HGR_DX+1
    ldx     #$80              ;initial values for fractional vectors
    stx     HGR_E             ;.5 in cosine component
    stx     HGR_E+1           ;.5 in sine component
    ldx     HGR_SCALE         ;scale factor
LF630:
    lda     HGR_E             ;add cosine value to X-value
    sec                       ;if >= 1, then draw
    adc     HGR_DX
    sta     HGR_E             ;only save fractional part
    bcc     LF63D             ;no integral part
    jsr     LRUD1             ;time to plot cosine component
    clc
LF63D:
    lda     HGR_E+1           ;add sine value to Y-value
    adc     HGR_DY            ;if >= 1, then draw
    sta     HGR_E+1           ;only save fractional part
    bcc     LF648             ;no integral part
    jsr     LRUD2             ;time to plot sine component
LF648:
    dex                       ;loop on scale factor
    bne     LF630             ;still on same shape item
    lda     HGR_DX+1          ;get next shape item
    lsr     A                 ;next 3-bit vector
    lsr     A
    lsr     A
    bne     LF626             ;more in this shape byte
    inc     HGR_SHAPE         ;go to next shape byte
    bne     LF658
    inc     HGR_SHAPE+1
LF658:
    lda     (HGR_SHAPE,x)     ;next byte of shape definition
    bne     LF626             ;process if not zero
    rts                       ;finished

                   ; XDRAW0
                   ; (not called by Applesoft)
    stx     HGR_SHAPE         ;save shape address
    sty     HGR_SHAPE+1
                   ; XDRAW a shape (same as DRAW, except toggles screen)
                   ; 
                   ;   (Y,X) = shape starting address
                   ;   A-reg = rotation ($00-3F)
XDRAW1:
    tax                       ;save rotation ($00-3F)
    lsr     A                 ;divide rotation by 16 to get
    lsr     A                 ; quadrant (0=up, 1=rt, 2=dwn, 3=lft)
    lsr     A
    lsr     A
    sta     HGR_QUAD
    txa                       ;use lwo 4 bits of rotation to index
    and     #$0f              ; the trig table
    tax
    ldy     COSINE_TABLE,x    ;save cosine in HGR_DX
    sty     HGR_DX
    eor     #$0f              ;and sine in DY
    tax
    ldy     COSINE_TABLE+1,x
    iny
    sty     HGR_DY
    ldy     HGR_HORIZ         ;index from HBASL,H to byte we're in
    ldx     #$00
    stx     HGR_COLLISIONS    ;clear collision counter
    lda     (HGR_SHAPE,x)     ;get first byte of shape defn
LF682:
    sta     HGR_DX+1          ;keep shape byte in HGR_DX+1
    ldx     #$80              ;initial values for fractional vectors
    stx     HGR_E             ;.5 in cosine component
    stx     HGR_E+1           ;.5 in sine component
    ldx     HGR_SCALE         ;scale factor
LF68C:
    lda     HGR_E             ;add cosine value to X-value
    sec                       ;if >= 1, then draw
    adc     HGR_DX
    sta     HGR_E             ;only save fractional part
    bcc     LF699             ;no integral part
    jsr     LRUDX1            ;time to plot cosine component
    clc
LF699:
    lda     HGR_E+1           ;add sine value to Y-value
    adc     HGR_DY            ;if >= 1, then draw
    sta     HGR_E+1           ;only save fractional part
    bcc     LF6A4             ;no integral part
    jsr     LRUDX2            ;time to plot sine component
LF6A4:
    dex                       ;loop on scale factor
    bne     LF68C             ;still on same shape item
    lda     HGR_DX+1          ;get next shape item
    lsr     A                 ;next 3-bit vector
    lsr     A
    lsr     A
    bne     LF682             ;more in this shape byte
    inc     HGR_SHAPE         ;go to next shape byte
    bne     LF6B4
    inc     HGR_SHAPE+1
LF6B4:
    lda     (HGR_SHAPE,x)     ;next byte of shape definition
    bne     LF682             ;process if not zero
    rts                       ;finished

                   ; Get hi-res plotting coordinates (0-279,0-191) from TXTPTR.  Leave registers
                   ; set up for HPOSN:
                   ; 
                   ;   (Y,X) = X-coord
                   ;   A-reg = Y-coord
HFNS:
    jsr     FRMNUM            ;evaluate expression, must be numeric
    jsr     GETADR            ;convert to 2-byte integer in LINNUM
    ldy     LINNUM+1          ;get horiz coord in X,Y
    ldx     LINNUM
    cpy     #$01              ;(should be #>280) make sure it is < 280
    bcc     LF6CD             ;in range
    bne     GGERR
    cpx     #24               ;(should be #<280)
    bcs     GGERR
LF6CD:
    txa                       ;save horiz coord on stack
    pha
    tya
    pha
    lda     #','              ;require a comma
    jsr     SYNCHR
    jsr     GETBYT            ;eval exp to single byte in X-reg
    cpx     #192              ;check for range
    bcs     GGERR             ;too big
    stx     FAC               ;save Y-coord
    pla                       ;retrieve horizontal coordinate
    tay
    pla
    tax
    lda     FAC               ;and vertical coordinate
    rts

GGERR:
    jmp     GOERR             ;illegal quantity error

; ********************************************************************************
; * HCOLOR= statement                                                            *
; ********************************************************************************
HCOLOR:
    jsr     GETBYT            ;eval exp to single byte in X
    cpx     #8                ;value must be 0-7
    bcs     GGERR             ;too big
    lda     COLORTBL,x        ;get color pattern
    sta     HGR_COLOR
RTS_23:
    rts

COLORTBL:
    .byte   $00,$2a,$55,$7f,$80,$aa,$d5,$ff

;********************************************************************************
;* HPLOT statement                                                              *
;*                                                                              *
;*   HPLOT X,Y                                                                  *
;*   HPLOT TO X,Y                                                               *
;*   HPLOT X1,Y1 to X2,Y2                                                       *
;********************************************************************************
;• Clear variables

DSCTMP = $9D

HPLOT:
    cmp     #TOK_TO           ;HPLOT TO form?
    beq     LF70F             ;yes, start from current location
    jsr     HFNS              ;no, get starting point of line
    jsr     HPLOT0            ;plot the point, and set up for drawing a line from that point
LF708:
    jsr     CHRGOT            ;character at end of expression
    cmp     #TOK_TO           ;is a line specified?
    bne     RTS_24            ;no, exit
LF70F:
    jsr     SYNCHR            ;yes, adv. TXTPTR (why not CHRGET)
    jsr     HFNS              ;get coordinates of line end
    sty     DSCTMP            ;set up for line
    tay
    txa
    ldx     DSCTMP
    jsr     HGLIN             ;plot line
    jmp     LF708             ;loop till no more "TO" phrases

;********************************************************************************
;* ROT= statement                                                               *
;********************************************************************************

ROT:
    jsr     GETBYT            ;eval exp to a byte in X-reg
    stx     HGR_ROTATION
RTS_24:
    rts

;********************************************************************************
;* SCALE= statement                                                             *
;********************************************************************************

SCALE:
    jsr     GETBYT            ;eval exp to a byte in X-reg
    stx     HGR_SCALE
    rts

                   ; Set up for DRAW and XDRAW.
DRWPNT:
    jsr     GETBYT            ;get shape number in X-reg
    lda     HGR_SHAPE_PTR     ;search for that shape
    sta     HGR_SHAPE         ;set up ptr to beginning of table
    lda     HGR_SHAPE_PTR+1
    sta     HGR_SHAPE+1
    txa
    ldx     #$00
    cmp     (HGR_SHAPE,x)     ;compare to # of shapes in table
    beq     LF741             ;last shape in table
    bcs     GOERR             ;shape # too large
LF741:
    asl     A                 ;double shape# to make an index
    bcc     LF747             ;add 256 if shape # > 127
    inc     HGR_SHAPE+1
    clc
LF747:
    tay                       ;use index to look up offset for shape
    lda     (HGR_SHAPE),y     ; in offset table
    adc     HGR_SHAPE
    tax
    iny
    lda     (HGR_SHAPE),y
    adc     HGR_SHAPE_PTR+1
    sta     HGR_SHAPE+1       ;save address of shape
    stx     HGR_SHAPE
    jsr     CHRGOT            ;is there any "AT" phrase?
    cmp     #TOK_AT
    bne     LF766             ;no, draw right where we are
    jsr     SYNCHR            ;scan over "AT"
    jsr     HFNS              ;get X- and Y-coords to start drawing it
    jsr     HPOSN             ;set up cursor there
LF766:
    lda     HGR_ROTATION      ;rotation value
    rts

;********************************************************************************
;* DRAW statement                                                               *
;********************************************************************************

DRAW:
    jsr     DRWPNT
    jmp     DRAW1

;********************************************************************************
;* XDRAW statement                                                              *
;********************************************************************************

XDRAW:
    jsr     DRWPNT
    jmp     XDRAW1

GOERR:
    rts

.res 113, $60

;********************************************************************************
;* SHLOAD statement                                                             *
;*                                                                              *
;* Reads a shape table from cassette tape to a position just below HIMEM.       *
;* HIMEM is then moved to just below the table.                                 *
;********************************************************************************

SHLOAD:
;    lda     #>LINNUM          ;set up to read two bytes
;    sta     MON_A1H           ; into LINNUM,LINNUM+1
;    sta     MON_A2H
;    ldy     #LINNUM
;    sty     MON_A1L
;    iny                       ;LINNUM+1
;    sty     MON_A2L
;    jsr     MON_READ          ;read tape
;    clc                       ;setup to read LINNUM bytes
;    lda     MEMSIZE           ;ending at HIMEM-1
;    tax
;    dex                       ;forming HIMEM-1
;    stx     MON_A2L
;    sbc     LINNUM            ;forming HIMEM-LINNUM
;    pha
;    lda     MEMSIZE+1
;    tay
;    inx                       ;see if HIMEM low byte was zero
;    bne     LF796             ;no
;    dey                       ;yes, have to decrement high byte
;LF796:
;    sty     MON_A2H
;    sbc     LINNUM+1
;    cmp     STREND+1          ;running into variables?
;    bcc     LF7A0             ;yes, out of memory
;    bne     LF7A3             ;no, still room
;LF7A0:
;    jmp     MEMERR            ;mem full err

LF7A3:
;    sta     MEMSIZE+1
;    sta     FRETOP+1          ;clear string space
;    sta     MON_A1H           ;(but names are still in VARTBL!)
;    sta     HGR_SHAPE_PTR+1
;    pla
;    sta     HGR_SHAPE_PTR
;    sta     MEMSIZE
;    sta     FRETOP
;    sta     MON_A1L
;    jsr     MON_RD2BIT        ;read to tape transitions
;    lda     #$03              ;short delay for intermediate header
;    jmp     MON_READ2         ;read shapes

                   ; Called from STORE and RECALL.
TAPEPNT:
;    clc
;    lda     LOWTR
;    adc     LINNUM
;    sta     MON_A2L
;    lda     LOWTR+1
;    adc     LINNUM+1
;    sta     MON_A2H
;    ldy     #$04
;    lda     (LOWTR),y
;    jsr     GETARY2
;    lda     HIGHDS
;    sta     MON_A1L
;    lda     HIGHDS+1
;    sta     MON_A1H
;    rts

                   ; Called from STORE and RECALL.
GETARYPT:
 ;   lda     #$40
 ;   sta     SUBFLG
 ;   jsr     PTRGET
 ;   lda     #$00
 ;   sta     SUBFLG
 ;   jmp     VARTIO

;********************************************************************************
;* HTAB statement                                                               *
;*                                                                              *
;* Note that if WNDLEFT is not 0, HTAB can print outside the screen (e.g. in    *
;* the program).                                                                *
;********************************************************************************

HTAB:
    jsr     GETBYT
    dex
    txa
LF7EC:
    cmp     #40
    bcc     LF7FA
    sbc     #40
    pha
    jsr     CRDO
    pla
    jmp     LF7EC

LF7FA:
    sta     MON_CH
    rts


PD              = $C700


picodriveterm:
    jsr cls

    LDA #$0
@output: 
    CMP #$3                  ; ctrl-c pressed?
    bne @doread
    jmp MON
@doread:
    ldx #$A0
@wait:
    inx
    bne @wait
    lda PD                   ; read a byte from the picodrive console
    beq @input               ; nothing to read? jump to output
    jsr display_apple_char   ; output to the console
    jmp @output              ; another?
@input:
    lda $C000
    bpl @output
    sta PD                   ; write the byte to the picodrive console
    jsr display_apple_char   ; echo to local console
    lda $C010                ; kbd strobe
    lda KEYSTATE + $5        ; SC_F1
    beq @input
    jmp $C600
    rts
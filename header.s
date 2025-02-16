.segment "HEADER"
.ifdef KBD
        jmp     LE68C
        .byte   $00,$13,$56
.endif
.ifdef AIM65
        jmp     COLD_START
        jmp     RESTART
        .word   AYINT,GIVAYF
.endif
.ifdef SYM1
        jmp     PR_WRITTEN_BY
.endif
.ifdef BADGER6502
        jmp     COLD_START                ;$E000
        jmp     mouse_on                  ;$E003
        jmp     _cls                      ;$E006
        jmp     _cls                      ;$E009
        jmp     read_char_async_apple     ;$E00C
        jmp     _cls                      ;$E00F
        jmp     dos                       ;$E012
        jmp     hires1                    ;$E015
        jmp     hires2                    ;$E018
        jmp     read_char_upper           ;$E01B
        jmp     read_char_async           ;$E01E
        jmp     picodriveterm             ;$E021
        jmp     display_char              ;$E024
        jmp     display_message           ;$E027
        jmp     print_hex                 ;$E02A
        jmp     print_hex_word            ;$E02D
        jmp     print_crlf                ;$E030
        jmp     joytest                   ;$E033
        jmp     keytest                   ;$E036
        jmp     mousetest                 ;$E039
;       jmp     mouse_on                  ;$E03C
.endif

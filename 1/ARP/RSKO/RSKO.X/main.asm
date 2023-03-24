    list    p=16F1508
    #include	"p16F1508.inc"
    
    #define SETBT   PORTA,4
    #define RESETBT PORTA,5
    #define LED	    PORTA,2
    #define LED2    PORTA,5
    #define LED3    PORTA,3
    
; CONFIG1
; __config 0x3FE4
    __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _BOREN_ON & _CLKOUTEN_OFF & _IESO_ON & _FCMEN_ON
; CONFIG2
; __config 0x3FFF
    __CONFIG _CONFIG2, _WRT_OFF & _STVREN_ON & _BORV_LO & _LPBOR_OFF & _LVP_ON
    
    ORG	0x00
    goto    Start
    
    ;Adresa na kterou to vzdy skace pri preruseni
    ORG	0x04
    nop
    retfie

;dvojtecka pro ztucneni, funguje i bez
Start:
    movlb   .1
    movlw   0b01101000
    movwf   OSCCON;4MHZ
    call    Config_IOs
    
    movlb   .0
Loop:
    btfss   SETBT
    goto    $+4
    bsf	    LED
    bsf	    LED2
    bsf	    LED3
    btfss   RESETBT
    goto    $+4
    bcf	    LED
    bcf	    LED2
    bcf	    LED3
    goto    Loop
    
    #include	"Config_IOs.inc"
    END
    
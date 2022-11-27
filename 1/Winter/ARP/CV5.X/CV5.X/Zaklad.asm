;Zaklad pro psani vlastnich programu
    list	p=16F1508
    #include    "p16f1508.inc"

#define	BT2	PORTA,5
#define LED2	PORTC,3

    
    __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _BOREN_OFF & _CLKOUTEN_OFF & _IESO_OFF & _FCMEN_OFF

    __CONFIG _CONFIG2, _WRT_OFF & _STVREN_ON & _BORV_LO & _LPBOR_OFF & _LVP_ON




;VARIABLE DEFINITIONS
;COMMON RAM 0x70 to 0x7F
    CBLOCK	0x70
	cnt1
	cnt2
	delay_nms
	tmp	;promene v common RAM
    ENDC
    
;**********************************************************************
	ORG     0x00
  	goto    Start
	
	ORG     0x04
	nop			;pripraveno pro obsluhu preruseni
  	retfie
	
	
	
Start	movlb	.1		;Bank1
	movlw	b'01101000'	;4MHz Medium
	movwf	OSCCON		;nastaveni hodin

	call	Config_IOs	;vola nastaveni pinu
	movlb	.0		;Bank0

Main	;hlavni smycka...
	movlw	.200
	btfsc	BT2
	movlw	.100
	call	Delay_ms
	bsf	LED2
	
	movlw	.200
	btfsc	BT2
	movlw	.100
	call	Delay_ms
	bcf	LED2
	
	goto	Main		;zacykleni
	
Delay_ms:   movwf   cnt2
OutLp:	    movlw   .249
	    movwf   cnt1
InLp:	    nop
	    decfsz  cnt1,F
	    goto    InLp
	    decfsz  cnt2,F
	    goto    OutLp
	    return
	
	
    #include	"Config_IOs.inc"	;zde "#include" funguje tak, ze proste jen vlozi svuj obsah tam kam ho napisete
		
	END






		
		
		
		
		



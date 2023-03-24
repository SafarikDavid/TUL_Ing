;blikani pomoci TMR2
    list	p=16F1508
    #include    "p16F1508.inc"
   
    __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _BOREN_OFF & _CLKOUTEN_OFF & _IESO_OFF & _FCMEN_OFF

    __CONFIG _CONFIG2, _WRT_OFF & _STVREN_ON & _BORV_LO & _LPBOR_OFF & _LVP_ON

;VARIABLE DEFINITIONS
;COMMON RAM 0x70 to 0x7F
    CBLOCK	0x70
	tmp
    ENDC
    
;**********************************************************************
	ORG     0x00
  	goto    Start
	
	ORG     0x04
	nop
  	retfie
	
	
Start	movlb	.1		;Banka1
	movlw	b'01101000'	;4MHz Medium
	movwf	OSCCON		;nastaveni hodin

	call	Config_IOs
	
	;config TMR2
	movlb	.0		;Banka0 s TMR2
	movlw	b'01111011'	;1:64 pre, 1:16 post
	movwf	T2CON
	clrf	TMR2		;vynulovat citac
	movlw	0xFF
	movwf	PR2		;nastavit na max. hodnotu
	bsf	T2CON,TMR2ON	;po nastaveni vseho zapnout TMR2
	
	bsf	PORTC,3		;rozsviceni LED2
	
	movlw	b'00101000'	;maska pro blikani LED1 a LED2
Loop	btfss	PIR1,TMR2IF	;ceka az dobehne TMR2
	goto	$-1
	bcf	PIR1,TMR2IF	;vynuluje jeho priznak
	xorwf	PORTC		;dle masky zmeni polaritu LED
	      	
        goto    Loop
	

	
    #include	"Config_IOs.inc"
		
	END

		
		
		



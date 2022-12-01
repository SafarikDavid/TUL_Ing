;blikani pomoci TMR2
    list	p=16F1508
    #include    "p16F1508.inc"
    
    #define	BT1	PORTA,4
    #define	BT2	PORTA,5
   
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
	clrf	T2CON		;1:1 pre, 1:1 post
	clrf	TMR2		;vynulovat citac
	movlw	0xFF		;(4000000/4)/256 = 3906.25 Hz
	movwf	PR2		;nastavit na max. hodnotu
	bsf	T2CON,TMR2ON	;po nastaveni vseho zapnout TMR2
	
	;config PWM1
	movlb	.12
	clrf	PWM1DCH
	clrf	PWM1DCL
	bsf	PWM1CON,PWM1OE	;povolit vystup signalu na pin
	bsf	PWM1CON,PWM1EN	;spustit PWM1
	
	movlw	0x06
	movwf	FSR0H		
	movlw	0x12
	movwf	FSR0L		;PWM1DCH pomoci nepr. addresovani
	
	movlb	.0		;Banka0 s PORT
	
Loop	clrw
	btfsc	BT2		;test BT2 
	addlw	.84		; -> +33%
	btfsc	BT1		;test BT1 
	addlw	.171		; -> +67%
	
	movwf	INDF0		;zapsat do PWM1DCH
	
        goto    Loop
	

	
    #include	"Config_IOs.inc"
		
	END

		
		
		



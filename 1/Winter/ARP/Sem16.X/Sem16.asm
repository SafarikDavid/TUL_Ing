;Zaklad pro psani vlastnich programu
    list	p=16F1508
    #include    "p16F1508.inc"

    #define	BT1	PORTA,4
    #define	BT2	PORTA,5
    
    __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _BOREN_OFF & _CLKOUTEN_OFF & _IESO_OFF & _FCMEN_OFF

    __CONFIG _CONFIG2, _WRT_OFF & _STVREN_ON & _BORV_LO & _LPBOR_OFF & _LVP_ON




;VARIABLE DEFINITIONS
;COMMON RAM 0x70 to 0x7F
    CBLOCK	0x70
	tmp	;promene v common RAM
	state
	cnt1
	cnt2
    ENDC
    
;**********************************************************************
	ORG     0x00
  	goto    Start
	
	ORG     0x04
	nop
	retfie
	
	
	
Start	movlb	.1		;Bank1
	movlw	b'01101000'	;4MHz Medium
	movwf	OSCCON		;nastaveni hodin

	call	Config_IOs	;vola nastaveni pinu
	movlb	.0		;Bank0
	
	;config TMR2
	movlb	.0		;Banka0 s TMR2
	clrf	T2CON		;1:1 pre, 1:1 post
	clrf	TMR2		;vynulovat citac
	movlw	0xFF		;(4000000/4)/256 = 3906.25 Hz
	movwf	PR2		;nastavit na max. hodnotu
	bsf	T2CON,TMR2ON	;po nastaveni vseho zapnout TMR2
	
	;config PWM4
	movlb	.12
	clrf	PWM4DCH
	clrf	PWM4DCL
	bsf	PWM4CON,PWM4OE	;povolit vystup signalu na pin
	bsf	PWM4CON,PWM4EN	;spustit PWM4
	
	movlw	0x06
	movwf	FSR0H
	;movlw	0x12		
	movlw	0x1B
	movwf	FSR0L		;PWM1DCH pomoci nepr. addresovani
	
	movlb	.0		;Banka0 s PORT
		
	clrf	state
	incf	state,F
	clrw
	addlw	.0
	movwf	INDF0

	;takhle menim duty cycle, potrebuju menit frekvenci, ktera je jinde
	
Main	btfss	BT1		;je to jedna?
	goto	BT2Int		;je to tedy BT2?
	movlb	.0		;Banka0 s PORT
	
	movlw	.1
	subwf	state,W
	btfss	STATUS,Z
	goto	$+4
	clrw
	addlw	.127
	movwf	INDF0
	
	movlw	.2
	subwf	state,W
	btfss	STATUS,Z
	goto	$+4
	clrw
	addlw	.190
	movwf	INDF0
	
	movlw	.3
	subwf	state,W
	btfss	STATUS,Z
	goto	$+4
	clrw
	addlw	.255
	movwf	INDF0
	
	movlw	.4
	subwf	state,W
	btfss	STATUS,Z
	incf	state,F
	call	Delay100
	
  	goto	Main
	
BT2Int	btfss	BT2		;je to dvojka?
	goto	Main
	movlb	.0		;Banka0 s PORT
	movlw	.4
	subwf	state,W
	btfss	STATUS,Z
	goto	$+4
	clrw
	addlw	.190
	movwf	INDF0
	
	movlw	.3
	subwf	state,W
	btfss	STATUS,Z
	goto	$+4
	clrw
	addlw	.127
	movwf	INDF0
	
	movlw	.2
	subwf	state,W
	btfss	STATUS,Z
	goto	$+4
	clrw
	addlw	.0
	movwf	INDF0
	
	movlw	.1
	subwf	state,W
	btfss	STATUS,Z
	decf	state,F
	call	Delay100
	
	goto	Main		;zacykleni
	
	
Delay100			;zpozdeni 100 ms
        movlw   .500
Delay_ms
        movwf	cnt2		
OutLp	movlw	.249		
	movwf	cnt1		
	nop			
	decfsz	cnt1,F
        goto	$-2		
	decfsz	cnt2,F
	goto	OutLp
	return	
	
    #include	"Config_IOs.inc"	;zde "#include" funguje tak, ze proste jen vlozi svuj obsah tam kam ho napisete
		
	END






		
		
		
		
		



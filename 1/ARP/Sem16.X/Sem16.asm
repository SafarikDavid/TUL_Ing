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
	movlb	.7		;Banka7 s IOC
	btfss	IOCAF,4		;preruseni od BT1(RA4)?
	goto	BT2Int		;je to tedy od BT2...
	bcf	IOCAF,4		;vynulovat priznak od BT1(RA4)
	goto	IncSt
	
BT2Int	bcf	IOCAF,5		;vynulovat priznak od BT2(RA5)
	goto	DecSt
	
IncSt	movlb	.0
	movlw	.4
	subwf	state,W
	btfsc	STATUS,Z
	retfie
	incf	state,F
	goto	FrChng
	
DecSt	movlb	.0
	movlw	.1
	subwf	state,W
	btfsc	STATUS,Z
	retfie
	decf	state,F
	goto	FrChng
	
FrChng	movlb	.0
	clrf	TMR2
	clrf	T2CON
	
	;244.14	 Hz
St1	movlb	.0		;Banka0 s TMR2
	movlw	.1
	subwf	state,W
	btfss	STATUS,Z
	goto	St2
	bcf	T2CON,T2CKPS0
	bsf	T2CON,T2CKPS1
	movlw	b'11111111'
	goto	MainEnd
	
	;318.88 Hz
St2	movlb	.0		;Banka0 s TMR2
	movlw	.2
	subwf	state,W
	btfss	STATUS,Z
	goto	St3
	bcf	T2CON,T2CKPS0
	bsf	T2CON,T2CKPS1
	movlw	b'11000011'
	goto	MainEnd
	;419.46 Hz
St3	movlb	.0		;Banka0 s TMR2
	movlw	.3
	subwf	state,W
	btfss	STATUS,Z
	goto	St4
	bcf	T2CON,T2CKPS0
	bsf	T2CON,T2CKPS1
	movlw	b'10010100'
	goto	MainEnd
	
	;988.14	Hz
St4	movlb	.0		;Banka0 s TMR2
	movlw	.4
	subwf	state,W
	btfss	STATUS,Z
	goto	MainEnd
	bsf	T2CON,T2CKPS0
	bcf	T2CON,T2CKPS1
	movlw	b'11111100'
	goto	MainEnd
	
MainEnd
	movwf	PR2
	bsf	T2CON,TMR2ON
	call	Delay100
	movlb	.7		;Banka7 s IOC
	clrf	IOCAF		;smazat priznak doted detekovanych hran
	movlb	.0		;Banka7 s IOC
	retfie
	
	
	
Start	movlb	.1		;Bank1
	movlw	b'01101000'	;4MHz Medium
	movwf	OSCCON		;nastaveni hodin

	call	Config_IOs	;vola nastaveni pinu
	movlb	.0		;Bank0
	
	;nastaveni preruseni
	movlb	.7		;Banka7 s IOC
	bsf	IOCAP,4		;BT1(RA4) nastavena detekce pozitivni hrany
	bsf	IOCAP,5		;BT2(RA5) nastavena detekce pozitivni hrany
	clrf	IOCAF		;smazat priznak doted detekovanych hran
	
	bsf	INTCON,IOCIE	;povolit preruseni od IOC
	bsf	INTCON,GIE	;povolit preruseni jako takove	
	
	;config TMR2
	movlb	.0		;Banka0 s TMR2
	clrf	T2CON		;1:1 pre, 1:1 post
	;preddelicka pr.: 01 - PS0 je 1, PS1 je 0
	;00 - 1, 01 - 4, 10 - 16, 11 / 64
	bcf	T2CON,T2CKPS0
	bsf	T2CON,T2CKPS1
	;postdelicka - na nulach
	;bcf	T2CON,T2OUTPS0
	;bcf	T2CON,T2OUTPS1
	;bcf	T2CON,T2OUTPS2
	;bcf	T2CON,T2OUTPS3
	clrf	TMR2		;vynulovat citac
	;freq je (4000000/4)/(PR2*preddelicka)
	movlw	b'11111111'	;(4000000/4)/256 = 3906.25 Hz
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
	movwf	FSR0L		;PWM4DCH pomoci nepr. addresovani
	
	movlb	.0		;Banka0 s PORT
		
	;duty cycle nastaven na 50% asi 
	clrw
	addlw	.127
	movwf	INDF0
	
	;nastaveni state na 1
	clrf	state
	incf	state,F

	
Main	movlb	.0		;Banka0 s PORT
	goto	Main
	
	
Delay100			;zpozdeni 100 ms
        movlw   .100
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






		
		
		
		
		



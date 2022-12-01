;Zaklad pro psani vlastnich programu
    list	p=16F1508
    #include    "p16F1508.inc"

#define	BT1	PORTA,4
    
    __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _BOREN_OFF & _CLKOUTEN_OFF & _IESO_OFF & _FCMEN_OFF

    __CONFIG _CONFIG2, _WRT_OFF & _STVREN_ON & _BORV_LO & _LPBOR_OFF & _LVP_ON




;VARIABLE DEFINITIONS
;COMMON RAM 0x70 to 0x7F
    CBLOCK	0x70
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
	
	;config UART
	movlb	.3		;Banka3 s UART
	bsf	TXSTA,TXEN	;povoleni odesilani dat
	bsf	TXSTA,BRGH	;jiny zpusob vypoctu baudrate
	bsf	RCSTA,CREN	;povoleni prijimani dat
	clrf	SPBRGH
	movlw	.25		;25 => 9615 bps s BRGH pri Fosc = 4MHz
	movwf	SPBRGL
	bsf	RCSTA,SPEN	;po nastaveni vseho zapnout UART
	
	clrf	FSR1H
	movlw	0x11
	movwf	FSR1L		;PIR1 pomoci nepr. addr. (pro RCIF)

	
	movlb	.3		;Banka3 s UART

Main	movlb	.3
	btfss	INDF1,RCIF	;prisel byte?
	goto	$-1
	movf	RCREG,W		;nacist ho do W
	movwf	tmp		;ulozit protoze RCREG to po 1. precteni nehlida
	
	movlb	.0
	
	clrw 
	movf	tmp, W		
	
	movwf	INDF0		;zapsat do PWM1DCH

	goto	Main		;zacykleni
	
	
    #include	"Config_IOs.inc"	;zde "#include" funguje tak, ze proste jen vlozi svuj obsah tam kam ho napisete
		
	END






		
		
		
		
		



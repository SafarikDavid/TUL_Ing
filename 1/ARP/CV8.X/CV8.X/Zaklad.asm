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
    ENDC
    
;**********************************************************************
	ORG     0x00
  	goto    Start
	
	ORG     0x04
	nop			;pripraveno pro obsluhu preruseni
  	retfie
	
	
	
Start	movlb	.1		;Banka1
	movlw	b'01101000'	;4MHz Medium
	movwf	OSCCON		;nastaveni hodin

	call	Config_IOs
	
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
	
	movlw	'?'
	subwf	tmp,W
	btfss	STATUS,Z
	goto	Main
	
	movlw	'B'
	call	SendChar
	movlw	'T'
	call	SendChar
	movlw	'1'
	call	SendChar
	movlw	':'
	call	SendChar
	movlb	.0
	movlw	'0'
	btfsc	BT1
	movlw	'1'
	call	SendChar

	movlw	'_'
	call	SendChar
	
	movlw	'B'
	call	SendChar
	movlw	'T'
	call	SendChar
	movlw	'2'
	call	SendChar
	movlw	':'
	call	SendChar
	movlb	.0
	movlw	'0'
	btfsc	BT2
	movlw	'1'
	call	SendChar
	nop			;pro jistotu
	btfss	TXSTA,TRMT	;ceka zde dokud se vse neodesle
	goto	$-1
	
	goto	Main		;zacykleni
	
SendChar
	movlb	.3
	nop			;pro jistotu
	btfss	INDF1,TXIF	;je TX buffer prazdny?
	goto	$-1
	movwf	TXREG		;zapsat do odesilaciho bufferu
	return
	
	
    #include	"Config_IOs.inc"	;zde "#include" funguje tak, ze proste jen vlozi svuj obsah tam kam ho napisete
		
	END






		
		
		
		
		



;prijme pismeno z PC, odesle zpatky male i velke
;9600, 8 b, 1 stop, bez parity a rizeni toku
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
Loop	btfss	INDF1,RCIF	;prisel byte?
	goto	$-1
	movf	RCREG,W		;nacist ho do W
	movwf	tmp		;ulozit protoze RCREG to po 1. precteni nehlida
	
	nop			;pro jistotu
	btfss	INDF1,TXIF	;je TX buffer prazdny?
	goto	$-1
	movwf	TXREG		;zapsat do odesilaciho bufferu
	
	movlw	0x20
	subwf	tmp,W		;z maleho pismena velke
	
	
	nop			;pro jistotu
	btfss	INDF1,TXIF	;je TX buffer prazdny?
	goto	$-1
	movwf	TXREG		;zapsat do odesilaciho bufferu
		
	nop			;pro jistotu
	btfss	TXSTA,TRMT	;ceka zde dokud se vse neodesle
	goto	$-1
       	
        goto    Loop

	
	
    #include	"Config_IOs.inc"
    		
	END

		
		
		



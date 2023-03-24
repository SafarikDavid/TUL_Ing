;blikani pomoci WDT s uspavanim
    list	p=16F1508
    #include    "p16F1508.inc"
    
    
   
    ;pozor zde je zmena - zapnut WDT!
    __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_ON & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _BOREN_OFF & _CLKOUTEN_OFF & _IESO_OFF & _FCMEN_OFF

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
	
	movlw	b'00010100'	;cca 512 ms WDT
	movwf	WDTCON

	call	Config_IOs
	
	movlb	.0
	bsf	PORTC,3		;rozsviceni LED2
	
	movlw	b'00101000'	;maska pro blikani LED1 a LED2
Loop	sleep			;rezim spanku
	xorwf	PORTC		;dle masky zmeni polaritu LED
	goto	Loop
	
	
	
    #include	"Config_IOs.inc"
		
	END

		
		
		



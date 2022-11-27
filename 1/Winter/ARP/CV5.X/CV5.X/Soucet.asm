;Secte POCET 8-bitovych cisel od adresy ZAC, vysledek bude ve W
    list	p=16F1508
    #include    "p16f1508.inc"

    
    __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _BOREN_OFF & _CLKOUTEN_OFF & _IESO_OFF & _FCMEN_OFF

    __CONFIG _CONFIG2, _WRT_OFF & _STVREN_ON & _BORV_LO & _LPBOR_OFF & _LVP_ON



;VARIABLE DEFINITIONS
;COMMON RAM 0x70 to 0x7F
    CBLOCK	0x70
	citac
	aku
    ENDC
    
POCET   EQU     .3 	        
ZAC     EQU     0x75
    
;**********************************************************************
	ORG     0x00
  	goto    Start
	
	ORG     0x04
	nop
  	retfie
	
	
	
Start	movlb	.1		;Bank1
	movlw	b'01101000'	;4MHz Medium
	movwf	OSCCON		;nastaveni hodin

	call	Config_IOs
	
	movlw   ZAC
        movwf   FSR0L           ;nastaveni indexregistru
	clrf	FSR0H
        movlw   POCET
        movwf   citac           ;nastavení citace
        clrf    aku             ;nulovani akumulatoru
Loop	movf    INDF0,W         ;neprimo adresovane cislo -> W
        addwf   aku,F           ;pricteni do akumulatoru
        incf    FSR0L,F         ;zvyseni adresy cisla
        decfsz  citac,F         ;dekrementace citace, preskok pri nule
        goto    Loop            ;opakovani cyklu
        movf    aku,W           ;vysledek -> W
	
	movf	WREG,W
	movwf	ZAC
	goto	$		;zacykleni
	
	
    #include	"Config_IOs.inc"
		
	END






		
		
		
		
		



;Po N stiscich BT1 spusti BT2 N pipnuti
    list	p=16F1508
    #include    "p16f1508.inc"


#define	INCR	PORTA,4	    ;tlacitko BT1 - zvys pocet pipnuti
#define	RUN	PORTA,5	    ;tlacitko BT2 - spust pipani
#define BUZZER  PORTC,1	    ;akusticky menic
    
    __CONFIG _CONFIG1, _FOSC_INTOSC & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _BOREN_OFF & _CLKOUTEN_OFF & _IESO_OFF & _FCMEN_OFF

    __CONFIG _CONFIG2, _WRT_OFF & _STVREN_ON & _BORV_LO & _LPBOR_OFF & _LVP_ON



;VARIABLE DEFINITIONS
;COMMON RAM 0x70 to 0x7F
    CBLOCK	0x70
	cnt1
        cnt2
        cnt3
        num 
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

	call	Config_IOs
	
	movlb	.0
	
Main	clrf    num

; Test stisku tlacitka INCR
BLoop	clrf    cnt1		;citac osetreni zakmitu tlacitek
BT2L	btfsc   RUN
        goto    RBeep		;skok na pipani
        btfss   INCR		;preskok pri stisku tlacitka (H)
        goto    BLoop		;pri urovni L test od zacatku
        decfsz  cnt1,F
        goto    BT2L
        incf    num,F		;zvyseni poctu pipnuti

; Test uvolneni tlacitka INCR
        clrf    cnt1
BT2H	btfsc   INCR
        goto    $-2
        decfsz  cnt1,F
        goto    BT2H
        goto    BLoop

; Pipani        
RBeep	movf    num,W
        btfsc   STATUS,Z	;test citace pipnuti na nulu
        goto    Main		;cely cyklus od zacatku
BeepLp	movlw   .120
        movwf   cnt1		;citac poctu pulperiod zvukoveho kmito?tu
HalfPer	movlw   b'00000010'
        xorwf   PORTC,F		;negace urovne pinu budiciho akust. m?nic
        clrf    cnt2
	nop			;zpozdeni pro p?lperiodu zvuku
        decfsz  cnt2,F
        goto    $-2
        decfsz  cnt1,F		;test konce pipnuti
        goto    HalfPer		;dalsi pulperioda

; Zpozdeni - pauza mezi pipnutimi - 3 vnorene smycky
        movlw   .3
        movwf   cnt3
Pause1	clrf    cnt2
Pause2	clrf    cnt1
        decfsz  cnt1,F
        goto    $-1
        decfsz  cnt2,F
        goto    Pause2
        decfsz  cnt3,F
        goto    Pause1
        decf    num,F 		;dekrementace citace pípnuti               
        goto    RBeep
	
	
	
	
	
    #include	"Config_IOs.inc"
		
	END






		
		
		
		
		



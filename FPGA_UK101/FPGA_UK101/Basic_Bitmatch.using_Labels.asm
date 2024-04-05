// Microsoft BASIC for 6502 (OSI VERSION)
//
// ==================================================================================
// MODIFIED FROM THE ORIGINAL FILES AT http://www.pagetable.com/?p=46
// MERGED INTO ONE FILE AND MACROS AND CONDITIONAL STATEMENTS REMOVED
// BY G. SEARLE 2013
//
// I/O and dummy load/saves added to the end of this code
//
// This then assembles to the OSI version with the following
// minor changes to the original BASIC code:
// 1. Control-C call changed
// 2. Load/save calls changed
// 3. RAM start set to $0200 instead of $0300
// 4. ROM start set to $C000
// 5. Second letter of error messages back to ASCII value (instead of $80+val)
// ==================================================================================
//
// Extract of original header comments follows:
//
// (first revision of this distribution, 20 Oct 2008, Michael Steil www.pagetable.com)
//
//
// Name                Release   MS Version    ROM   9digit  INPUTBUFFER   extensions   
//---------------------------------------------------------------------------------------------------
// OSI BASIC            1977     1.0 REV 3.2    Y      N          ZP           -        
//
// Credits:
// * main work by Michael Steil
// * function names and all uppercase comments taken from Bob Sander-Cederlof's excellent AppleSoft II disassembly:
//   http://www.txbobsc.com/scsc/scdocumentor/
// * Applesoft lite by Tom Greene http://cowgod* =/replica1/applesoft/ helped a lot, too.
// * Thanks to Joe Zbicak for help with Intellision Keyboard BASIC
// * This work is dedicated to the memory of my dear hacking pal Michael "acidity" Kollmann.
.cpu _6502
.label BASICROM =     $A000   // % TO $BFFF
.label SCREEN =       $D000   // % TO $D7FF
.label Keyboard =     $DC00   // % TO $DFFF
.label ACIA =         $F000   // % TO $F001
.label ACIAControl =  ACIA+0
.label ACIAStatus =   ACIA+0
.label ACIAData =     ACIA+1
.label IOROM =        $F002
.label MONITORROM =   $F800   // % TO $FFF9
.label SYSTEMVECTORS= $FFFA   // % TO $FFFF
.label LOAD         = $fff4
.label SAVE         = $FFF7


 // zero page
.const ZP_START1        = $00
.const ZP_START2        = $0D
.const ZP_START3        = $5B
.const ZP_START4        = $65

//extra ZP variables
.label USR            = $000A

// constants
.label STACK_TOP		   = $FC
.label SPACE_FOR_GOSUB = $33
.label NULL_MAX		     = $0A
.label WIDTH			     = 72
.label WIDTH2			     = 56

// memory layout
.label RAMSTART2		      = $0200
.label BYTES_FP		        = 4
.label BYTES_PER_ELEMENT  = BYTES_FP
.label BYTES_PER_VARIABLE = BYTES_FP+2
.label MANTISSA_BYTES	    = BYTES_FP-1
.label BYTES_PER_FRAME    = 2*BYTES_FP+8
.label FOR_STACK1		      = 2*BYTES_FP+5
.label FOR_STACK2		      = BYTES_FP+4
.label MAX_EXPON          = 10
.label STACK             = $0100

// .label INPUTBUFFERX = INPUTBUFFER & $FF00
.const CR                =13
.const LF                =10
.label CRLF_1            = CR
.label CRLF_2            = LF



* = ZP_START1 "ZP_START1"
GORESTART:
	        .fill 3, $00
GOSTROUT:
	        .fill 3, $00
GOAYINT:
	        .fill 2, $00
GOGIVEAYF:
	        .fill 2, $00

* = ZP_START2 "ZP_START2"
Z15:
	        .fill 1, $00
POSX:
	        .fill 1, $00
Z17:
	        .fill 1, $00
Z18:
	        .fill 1, $00
LINNUM:
TXPSV:
	        .fill 2, $00
INPUTBUFFER:

* = ZP_START3 "ZP_START3"
CHARAC:
	        .fill 1, $00
ENDCHR:
	        .fill 1, $00
EOLPNTR:
	        .fill 1, $00
DIMFLG:
	        .fill 1, $00
VALTYP:
	        .fill 1, $00
DATAFLG:
	        .fill 1, $00
SUBFLG:
	        .fill 1, $00
INPUTFLG:
	        .fill 1, $00
CPRMASK:
	        .fill 1, $00
Z14:
	        .fill 1, $00

* = ZP_START4 "ZP_START4"
TEMPPT:
	        .fill 1, $00
LASTPT:
	        .fill 2, $00
TEMPST:
	        .fill 9, 00
INDEX:
	        .fill 2, $00
DEST:
	        .fill 2, $00
RESULT:
	        .fill BYTES_FP, $00
.label RESULT_LAST = RESULT + BYTES_FP-1
TXTTAB:
	        .fill 2, $00
VARTAB:
	        .fill 2, $00
ARYTAB:
	        .fill 2, $00
STREND:
	        .fill 2, $00
FRETOP:
          .fill 2, $00
FRESPC:
	        .fill 2, $00
MEMSIZ:
	        .fill 2, $00
CURLIN:
	        .fill 2, $00
OLDLIN:
	        .fill 2, $00
OLDTEXT:
	        .fill 2, $00
Z8C:
	        .fill 2, $00
DATPTR:
	        .fill 2, $00
INPTR:
	        .fill 2, $00
VARNAM:
	        .fill 2, $00
VARPNT:
	        .fill 2, $00
FORPNT:
	        .fill 2, $00
LASTOP:
	        .fill 2, $00
CPRTYP:
	        .fill 1, $00
FNCNAM:
TEMP3:
	        .fill 2, $00
DSCPTR:
	        .fill 2, $00
DSCLEN:
	        .fill 2, $00
.label JMPADRS	= DSCLEN + 1

Z52:
	        .fill 1, $00
ARGEXTENSION:
TEMP1:
	        .fill 1, $00
HIGHDS:
	        .fill 2, $00
HIGHTR:
	        .fill 2, $00
INDX:
TMPEXP:
TEMP2:
	        .fill 1, $00
EXPON:
	        .fill 1, $00
LOWTR:
LOWTRX:
	        .fill 1, $00
EXPSGN:
	        .fill 1, $00
FAC:
	        .fill BYTES_FP, $00
.label FAC_LAST = FAC + BYTES_FP-1
FACSIGN:
	        .fill 1, $00
SERLEN:
	        .fill 1, $00
SHIFTSIGNEXT:
	        .fill 1, $00
ARG:
	        .fill BYTES_FP, $00
.label ARG_LAST = ARG + BYTES_FP-1
ARGSIGN:
	        .fill 1, $00
STRNG1:
	        .fill 2, $00
.label SGNCPR = STRNG1
.label FACEXTENSION = STRNG1+1
STRNG2:
	        .fill 2, $00
CHRGET:
.label TXTPTR = <(GENERIC_TXTPTR-GENERIC_CHRGET + CHRGET)
.label CHRGOT = <(GENERIC_CHRGOT-GENERIC_CHRGET + CHRGET)
.label CHRGOT2 = <(GENERIC_CHRGOT2-GENERIC_CHRGET + CHRGET)
.label RNDSEED = <(GENERIC_RNDSEED-GENERIC_CHRGET + CHRGET)
                                                                                  
* = BASICROM "CODE"
TOKEN_ADDRESS_TABLE:
		      .word END-1                   // a000
		      .word FOR-1                   // a002
		      .word NEXT-1                  // a004
		      .word DATA-1                  // a006
		      .word INPUT-1                 // a008
		      .word DIM-1                   // a00a
		      .word READ-1                  // a00c
		      .word LET-1                   // a00e
.label TOKEN_GOTO=$80+(*-TOKEN_ADDRESS_TABLE)/2
		      .word GOTO-1                  // a010
		      .word RUN-1                   // a012
		      .word IF-1                    // a014
		      .word RESTORE-1               // a016
.label TOKEN_GOSUB=$80+(*-TOKEN_ADDRESS_TABLE)/2
		      .word GOSUB-1
		      .word POP-1
.label TOKEN_REM=$80+(*-TOKEN_ADDRESS_TABLE)/2
		      .word REM-1
		      .word STOP-1
		      .word ON-1
		      .word NULL-1
		      .word WAIT-1
		      .word LOAD-1
		      .word SAVE-1
		      .word DEF-1
		      .word POKE-1
.label TOKEN_PRINT=$80+(*-TOKEN_ADDRESS_TABLE)/2
		      .word PRINT-1
		      .word CONT-1
		      .word LIST-1
		      .word CLEAR-1
		      .word NEW-1
.label TOKEN_TAB=$00+$80+(*-TOKEN_ADDRESS_TABLE)/2
.label TOKEN_TO=$01+$80+(*-TOKEN_ADDRESS_TABLE)/2
.label TOKEN_FN=$02+$80+(*-TOKEN_ADDRESS_TABLE)/2
.label TOKEN_SPC=$03+$80+(*-TOKEN_ADDRESS_TABLE)/2
.label TOKEN_THEN=$04+$80+(*-TOKEN_ADDRESS_TABLE)/2
.label TOKEN_NOT=$05+$80+(*-TOKEN_ADDRESS_TABLE)/2
.label TOKEN_STEP=$06+$80+(*-TOKEN_ADDRESS_TABLE)/2
.label TOKEN_PLUS=$07+$80+(*-TOKEN_ADDRESS_TABLE)/2
.label TOKEN_MINUS=$08+$80+(*-TOKEN_ADDRESS_TABLE)/2
.label TOKEN_GREATER=$0E+$80+(*-TOKEN_ADDRESS_TABLE)/2
.label TOKEN_EQUAL=$0F+$80+(*-TOKEN_ADDRESS_TABLE)/2
.label NUM_TOKENS=(*-TOKEN_ADDRESS_TABLE)/2

UNFNC:
.label TOKEN_SGN=$11+$80+(*-TOKEN_ADDRESS_TABLE)/2
		      .word SGN
		      .word INT
		      .word ABS
		      .word USR
		      .word FRE
		      .word POS
		      .word SQR
		      .word RND
		      .word LOG
		      .word EXP
		      .word COS
		      .word SIN
		      .word TAN
		      .word ATN
		      .word PEEK
		      .word LEN
		      .word STR
		      .word VAL
		      .word ASC
		      .word CHRSTR
.label TOKEN_LEFTSTR=$11+$80+(*-TOKEN_ADDRESS_TABLE)/2
          .word LEFTSTR
          .word RIGHTSTR
          .word MIDSTR

MATHTBL:
          .byte   $79
          .word   FADDT-1
          .byte   $79
          .word   FSUBT-1
          .byte   $7B
          .word   FMULTT-1
          .byte   $7B
          .word   FDIVT-1
          .byte   $7F
          .word   FPWRT-1
          .byte   $50
          .word   TAND-1
          .byte   $46
          .word   OR-1
          .byte   $7D
          .word   NEGOP-1
          .byte   $5A
          .word   EQUOP-1
          .byte   $64
          .word   RELOPS-1
		
TOKEN_NAME_TABLE:
		      .text "EN"
          .byte  $80+'D'
		      .text "FO"
          .byte  $80+'R'
		      .text "NEX"
          .byte  $80+'T'
		      .text "DAT"
          .byte  $80+'A'
		      .text "INPU"
          .byte  $80+'T'
		      .text "DI"
          .byte  $80+'M'
		      .text "REA"
          .byte  $80+'D'
		      .text "LE"
          .byte  $80+'T'
		      .text "GOT"
          .byte  $80+'O'
		      .text "RU"
          .byte  $80+'N'
		      .text "I"
          .byte  $80+'F'
		      .text "RESTOR"
          .byte  $80+'E'
		      .text "GOSU"
          .byte  $80+'B'
		      .text "RETUR"
          .byte  $80+'N'
		      .text "RE"
          .byte  $80+'M'
		      .text "STO"
          .byte  $80+'P'
		      .text "O"
          .byte  $80+'N'
		      .text "NUL"
          .byte  $80+'L'
		      .text "WAI"
          .byte  $80+'T'
		      .text "LOA"
          .byte  $80+'D'
		      .text "SAV"
          .byte  $80+'E'
		      .text "DE"
          .byte  $80+'F'
		      .text "POK"
          .byte  $80+'E'
		      .text "PRIN"
          .byte  $80+'T'
		      .text "CON"
          .byte  $80+'T'
		      .text "LIS"
          .byte  $80+'T'
		      .text "CLEA"
          .byte  $80+'R'
		      .text "NE"
          .byte  $80+'W'
		      .text "TAB"
          .byte  $80+'('
		      .text "T"
          .byte  $80+'O'
		      .text "F"
          .byte  $80+'N'
		      .text "SPC"
          .byte  $80+'('
		      .text "THE"
          .byte  $80+'N'
		      .text "NO"
          .byte  $80+'T'
		      .text "STE"
          .byte  $80+'P'
		      .text ""
          .byte  $80+'+'
		      .text ""
          .byte  $80+'-'
		      .text ""
          .byte  $80+'*'
		      .text ""
          .byte  $80+'/'
		      .text ""
          .byte  $80+'^'
		      .text "AN"
          .byte  $80+'D'
		      .text "O"
          .byte  $80+'R'
		      .text ""
          .byte  $80+'>'
		      .text ""
          .byte  $80+'='
		      .text ""
          .byte  $80+'<'
		      .text "SG"
          .byte  $80+'N'
		      .text "IN"
          .byte  $80+'T'
		      .text "AB"
          .byte  $80+'S'
		      .text "US"
          .byte  $80+'R'
		      .text "FR"
          .byte  $80+'E'
		      .text "PO"
          .byte  $80+'S'
		      .text "SQ"
          .byte  $80+'R'
		      .text "RN"
          .byte  $80+'D'
		      .text "LO"
          .byte  $80+'G'
		      .text "EX"
          .byte  $80+'P'
		      .text "CO"
          .byte  $80+'S'
		      .text "SI"
          .byte  $80+'N'
		      .text "TA"
          .byte  $80+'N'
		      .text "AT"
          .byte  $80+'N'
		      .text "PEE"
          .byte  $80+'K'
		      .text "LE"
          .byte  $80+'N'
		      .text "STR"
          .byte  $80+'$'
		      .text "VA"
          .byte  $80+'L'
		      .text "AS"
          .byte  $80+'C'
		      .text "CHR"
          .byte  $80+'$'
		      .text "LEFT"
          .byte  $80+'$'
		      .text "RIGHT"
          .byte  $80+'$'
		      .text "MID"
          .byte  $80+'$'
		      .byte   0
		
ERROR_MESSAGES:
.label ERR_NOFOR = <(*-ERROR_MESSAGES)
          .byte $4e, $c6 // nF
.label ERR_SYNTAX = <(*-ERROR_MESSAGES)
          .byte $53, $ce // sN
.label ERR_NOGOSUB = <(*-ERROR_MESSAGES)
          .byte $52, $c7 // rG
.label ERR_NODATA = <(*-ERROR_MESSAGES)
          .byte $4f, $c4 // oD
.label ERR_ILLQTY = <(*-ERROR_MESSAGES)
          .byte $46, $c3 // fC
.label ERR_OVERFLOW = <(*-ERROR_MESSAGES)
          .byte $4f, $d6 // oV
.label ERR_MEMFULL = <(*-ERROR_MESSAGES)
          .byte $4f, $cd // oM
.label ERR_UNDEFSTAT = <(*-ERROR_MESSAGES)
          .byte $55, $d3 // uS
.label ERR_BADSUBS = <(*-ERROR_MESSAGES)
          .byte $42, $d3 // bS
.label ERR_REDIMD = <(*-ERROR_MESSAGES)
          .byte $44, $c4 // dD
.label ERR_ZERODIV = <(*-ERROR_MESSAGES)
          .byte $2f, $b0 // /0
.label ERR_ILLDIR = <(*-ERROR_MESSAGES)
          .byte $49, $c4 // iD
.label ERR_BADTYPE = <(*-ERROR_MESSAGES)
          .byte $54, $cd // tM
.label ERR_STRLONG = <(*-ERROR_MESSAGES)
          .byte $4c, $d3 // lS
.label ERR_FRMCPX = <(*-ERROR_MESSAGES)
          .byte $53, $d4 // sT
.label ERR_CANTCONT = <(*-ERROR_MESSAGES)
          .byte $43, $ce // cN
.label ERR_UNDEFFN = <(*-ERROR_MESSAGES)
          .byte $55, $c6 // uF
		
// global messages: "error", "in", "ready", "break"
QT_ERROR:
          .text " ERROR"
          .byte   0
QT_IN:
          .text " IN "
          .byte   $00
QT_OK:
		      .byte   CR,LF,'O','K',CR,LF
		      .byte	0
QT_BREAK:
		      .byte CR,LF,'B','R','E','A','K'
          .byte   0 

// generic stack and memory management code
// this code is identical across all versions of
// BASIC
// ----------------------------------------------------------------------------
// CALLED BY "NEXT" AND "FOR" TO SCAN THROUGH
// THE STACK FOR A FRAME WITH THE SAME VARIABLE.
//
// (FORPNT) = ADDRESS OF VARIABLE IF "FOR" OR "NEXT"
// 	= $XXFF IF CALLED FROM "RETURN"
// 	<<< BUG: SHOULD BE $FFXX >>>
//
//	RETURNS .NE. IF VARIABLE NOT FOUND,
//	(X) = STACK PNTR AFTER SKIPPING ALL FRAMES
//
//	.EQ. IF FOUND
//	(X) = STACK PNTR OF FRAME FOUND
// ----------------------------------------------------------------------------
GTFORPNT:         //$ search stack for most recent GOSUB or FOR 
          tsx                               //&      a1a1   ba                                               
          inx                               //&      a1a2   e8                                               
          inx                               //&      a1a3   e8                                               
          inx                               //&      a1a4   e8                                               
          inx                               //&      a1a5   e8                                               
SearchFORLoop:  
          lda     STACK+1,x                 //&      a1a6   bd 01 01   LOAD XREG WITH STK PNTR                                              
          cmp     #$81                      //&      a1a9   c9 81      IS IT A "FOR" TOKEN?                                            
          bne     NoForLoopFound            //&      a1ab   d0 21      NO, NO "FOR" LOOPS WITH THIS PNTR.                                             
          lda     FORPNT+1                  //&      a1ad   a5 98      GET HIGH.                                          
          bne     !Skip+                    //&      a1af   d0 0a                                                  
          lda     STACK+2,x                 //&      a1b1   bd 02 01   PNTR IS ZERO, SO ASSUME THIS ONE.                                               
          sta     FORPNT                    //&      a1b4   85 97                                               
          lda     STACK+3,x                 //&      a1b6   bd 03 01                                                 
          sta     FORPNT+1                  //&      a1b9   85 98                                                
!Skip:
          cmp     STACK+3,x                 //&      a1bb   dd 03 01                                                 
          bne     NotFound                  //&      a1be   d0 07      NOT THIS ONE.                                            
          lda     FORPNT                    //&      a1c0   a5 97      GET DOWN.                                          
          cmp     STACK+2,x                 //&      a1c2   dd 02 01                                                 
          beq     FoundIt                   //&      a1c5   f0 07      WE GOT IT! WE GOT IT!                                            
NotFound:
          txa                               //&      a1c7   8a                                               
          clc                               //&      a1c8   18         ADD 16 TO X.                                      
          adc     #BYTES_PER_FRAME          //&      a1c9   69 10                                                  
          tax                               //&      a1cb   aa         RESULT BACK INTO X.                                      
          bne     SearchFORLoop             //&      a1cc   d0 d8                                                  
FoundIt:
NoForLoopFound:
          rts                               //&      a1ce   60         RETURN TO CALLER.                                      
// ----------------------------------------------------------------------------
// MOVE BLOCK OF MEMORY UP
//
// ON ENTRY:
//	(Y,A) = (HIGHDS) = DESTINATION END+1
//	(LOWTR) = LOWEST ADDRESS OF SOURCE
//	(HIGHTR) = HIGHEST SOURCE ADDRESS+1
// ----------------------------------------------------------------------------
BLTU:             //$ routine to open space in program for another line
          jsr     REASON                    //&      a1cf   20 1f a2      ASCERTAIN THAT STRING SPACE WON'T BE OVERRUN.                                        
          sta     STREND                    //&      a1d2   85 7f                                                
          sty     STREND+1                  //&      a1d4   84 80                                                
BLTU2:    
          sec                               //&      a1d6   38            PREPARE TO SUBTRACT.                                   
          lda     HIGHTR                    //&      a1d7   a5 a6                                                
          sbc     LOWTR                     //&      a1d9   e5 aa         COMPUTE NUMBER OF THINGS TO MOVE.                                       
          sta     INDEX                     //&      a1db   85 71         SAVE FOR LATER.                                       
          tay                               //&      a1dd   a8                                               
          lda     HIGHTR+1                  //&      a1de   a5 a7                                                
          sbc     LOWTR+1                   //&      a1e0   e5 ab                                                
          tax                               //&      a1e2   aa            PUT IT IN A COUNTER REGISTER.                                   
          inx                               //&      a1e3   e8            SO THAT COUNTER ALGORITHM WORKS.                                   
          tya                               //&      a1e4   98            SEE IF LOW PART OF COUNT IS ZERO.                                   
          beq     DECBLT                    //&      a1e5   f0 23         YES, GO START MOVING BLOCKS.                                         
          lda     HIGHTR                    //&      a1e7   a5 a6         NO, MUST MODIFY BASE ADDR.                                       
          sec                               //&      a1e9   38                                               
          sbc     INDEX                     //&      a1ea   e5 71         BORROW IS OFF SINCE [HIGHTR].GT.[LOWTR].                                       
          sta     HIGHTR                    //&      a1ec   85 a6         SAVE MODIFIED BASE ADDR.                                       
          bcs     BLT1                      //&      a1ee   b0 03         IF NO BORROW, GO SHOVE IT.                                         
          dec     HIGHTR+1                  //&      a1f0   c6 a7         BORROW IMPLIES SUB 1 FROM HIGH ORDER.                                       
          sec                               //&      a1f2   38                                               
BLT1:   
          lda     HIGHDS                    //&      a1f3   a5 a4         MOD BASE OF DEST ADDR.                                       
          sbc     INDEX                     //&      a1f5   e5 71                                                
          sta     HIGHDS                    //&      a1f7   85 a4                                                
          bcs     MOREN1                    //&      a1f9   b0 08         NO BORROW.                                         
          dec     HIGHDS+1                  //&      a1fb   c6 a5         DECREMENT HIGH ORDER BYTE.                                       
          bcc     MOREN1                    //&      a1fd   90 04         ALWAYS SKIP.                                         
BLTLP:    
          lda     (HIGHTR),y                //&      a1ff   b1 a6         FETCH BYTE TO MOVE                                          
          sta     (HIGHDS),y                //&      a201   91 a4         MOVE IT IN, MOVE IT OUT.                                          
MOREN1:   
          dey                               //&      a203   88                                               
          bne     BLTLP                     //&      a204   d0 f9                                                  
          lda     (HIGHTR),y                //&      a206   b1 a6         MOVE LAST OF THE BLOCK.                                          
          sta     (HIGHDS),y                //&      a208   91 a4                                                   
DECBLT:   
          dec     HIGHTR+1                  //&      a20a   c6 a7         START ON NEW BLOCKS.                                       
          dec     HIGHDS+1                  //&      a20c   c6 a5                                                
          dex                               //&      a20e   ca                                               
          bne     MOREN1                    //&      a20f   d0 f2                                                  
          rts                               //&      a211   60            RETURN TO CALLER.                                   
// ----------------------------------------------------------------------------
// CHECK IF ENOUGH ROOM LEFT ON STACK
// FOR "FOR", "GOSUB", OR EXPRESSION EVALUATION
// ----------------------------------------------------------------------------
CHKMEM:           //$ check stack size                                         // GETSTK:
          asl                               //&      a212   0a            MULT [A] BY 2. NB, CLEARS C BIT.                                     
          adc     #SPACE_FOR_GOSUB          //&      a213   69 33         MAKE SURE 2*NUMLEV+13 LOCS (13 BECAUSE OF FBUFFR)                                         
          bcs     MEMERR                    //&      a215   b0 35         WILL REMAIN IN STACK.                                         
          sta     INDEX                     //&      a217   85 71                                                
          tsx                               //&      a219   ba            GET STACKED.                                   
          cpx     INDEX                     //&      a21a   e4 71         COMPARE.                                       
          bcc     MEMERR                    //&      a21c   90 2e         IF STACK.LE.INDEX1, OM.                                         
          rts                               //&      a21e   60                                               
// ----------------------------------------------------------------------------
// CHECK IF ENOUGH ROOM BETWEEN ARRAYS AND STRINGS
// (Y,A) = ADDR ARRAYS NEED TO GROW TO
// ----------------------------------------------------------------------------
REASON:           //$ check free memory left 
          cpy     FRETOP+1                  //&      a21f   c4 82                                                
          bcc     REARTS                    //&      a221   90 28                                                  
          bne     TRYMOR                    //&      a223   d0 04            GO GARB COLLECT.                                      
          cmp     FRETOP                    //&      a225   c5 81                                                
          bcc     REARTS                    //&      a227   90 22                                                  
TRYMOR:   
          pha                               //&      a229   48                                               
          ldx     #FAC-TEMP1-1              //&      a22a   a2 08            IF TEMPF2 HAS ZERO IN BETWEEN.                                      
          tya                               //&      a22c   98                                               
REASAV:   
          pha                               //&      a22d   48                                               
          lda     TEMP1,x                   //&      a22e   b5 a3            SAVE HIGHDS ON STACK.                                      
          dex                               //&      a230   ca                                               
          bpl     REASAV                    //&      a231   10 fa            PUT 8 OF THEM ON STK.                                     
          jsr     GARBA2                    //&      a233   20 47 b1         GO GARB COLLECT.                                      
          ldx     #TEMP1-FAC+1              //&      a236   a2 f8                                                  
REASTO:
          pla                               //&      a238   68                                               
          sta     FAC,x                     //&      a239   95 ac            RESTORE AFTER GARB COLLECT.                                      
          inx                               //&      a23b   e8                                               
          bmi     REASTO                    //&      a23c   30 fa            .                                      
          pla                               //&      a23e   68                                             
          tay                               //&      a23f   a8               RESTORE A AND Y                                   
          pla                               //&      a240   68               COMPARE HIGHS                                  
          cpy     FRETOP+1                  //&      a241   c4 82                                            
          bcc     REARTS                    //&      a243   90 06            HIGHER IS BAD.                                      
          bne     MEMERR	                  //&      a245   d0 05            AND THE LOWS.                                      
          cmp     FRETOP                    //&      a247   c5 81                                                
          bcs     MEMERR                    //&      a249   b0 01                                                  
REARTS:   
          rts                               //&      a24b   60                                               
MEMERR:   
          ldx     #ERR_MEMFULL              //&      a24c   a2 0c                                                  
// ----------------------------------------------------------------------------
// HANDLE AN ERROR
//
// (X)=OFFSET IN ERROR MESSAGE TABLE
// (ERRFLG) > 128 IF "ON ERR" TURNED ON
// (CURLIN+1) = $FF IF IN DIRECT MODE
// ----------------------------------------------------------------------------
ERROR:            //$ message output
          lsr     Z14                       //&      a24e   46 64               FORCE OUTPUT.                                 
          jsr     CRDO                      //&      a250   20 6c a8                                               
          jsr     OUTQUES                   //&      a253   20 e3 a8                                               
          lda     ERROR_MESSAGES,x          //&      a256   bd 64 a1                                                 
          jsr     OUTDO                     //&      a259   20 e5 a8                                               
          lda     ERROR_MESSAGES+1,x        //&      a25c   bd 65 a1                                                 
          jsr     OUTDO                     //&      a25f   20 e5 a8                                               
          jsr     STKINI                    //&      a262   20 91 a4                                               
          lda     #<QT_ERROR                //&      a265   a9 86                                                  
          ldy     #>QT_ERROR                //&      a267   a0 a1                                                  
// ----------------------------------------------------------------------------
// PRINT STRING AT (Y,A)
// PRINT CURRENT LINE # UNLESS IN DIRECT MODE
// FALL INTO WARM RESTART
// ----------------------------------------------------------------------------
PRINT_ERROR_LINNUM:
          jsr     STROUT                    //&      a269   20 c3 a8                                               
          ldy     CURLIN+1                  //&      a26c   a4 88                                                
          iny                               //&      a26e   c8                                               
          beq     RESTART                   //&      a26f   f0 03                                                  
          jsr     INPRT                     //&      a271   20 53 b9                                               
// ----------------------------------------------------------------------------
// WARM RESTART ENTRY
// ----------------------------------------------------------------------------
RESTART:          //$ warm start    
          lsr     Z14                       //&      a274   46 64                                                
          lda     #<QT_OK                   //&      a276   a9 92                                                  
          ldy     #>QT_OK                   //&      a278   a0 a1                                                  
          jsr     GOSTROUT                  //&      a27a   20 03 00                                               
Loop1:  
          jsr     INLIN                     //&      a27d   20 57 a3                                               
          stx.zp  TXTPTR                    //&      a280   86 c3                                                
          sty.zp  TXTPTR+1                  //&      a282   84 c4                                                
          jsr     CHRGET                    //&      a284   20 bc 00                                               
// bug in pre-1.1: CHRGET sets Z on '\0'
// and ':' - a line starting with ':' in
// direct mode gets ignored
          beq     Loop1                     //&      a287   f0 f4                                                  
          ldx     #$FF                      //&      a289   a2 ff                                                  
          stx     CURLIN+1                  //&      a28b   86 88                                                
          bcc     NUMBERED_LINE             //&      a28d   90 06                                                  
          jsr     PARSE_INPUT_LINE          //&      a28f   20 a6 a3                                               
          jmp     NEWSTT2                   //&      a292   4c f6 a5                                               
// ----------------------------------------------------------------------------
// HANDLE NUMBERED LINE
// ----------------------------------------------------------------------------
NUMBERED_LINE:    //$ tokenize and store in BASIC
          jsr     LINGET                    //&      a295   20 7f a7                                               
          jsr     PARSE_INPUT_LINE          //&      a298   20 a6 a3                                               
          sty     EOLPNTR                   //&      a29b   84 5d                                                
          jsr     FNDLIN                    //&      a29d   20 32 a4                                               
          bcc     PUT_NEW_LINE              //&      a2a0   90 44                                                  
          ldy     #$01                      //&      a2a2   a0 01                                                  
          lda     (LOWTR),y                 //&      a2a4   b1 aa                                                   
          sta     INDEX+1                   //&      a2a6   85 72                                                
          lda     VARTAB                    //&      a2a8   a5 7b                                                
          sta     INDEX                     //&      a2aa   85 71                                                
          lda     LOWTR+1                   //&      a2ac   a5 ab                                                
          sta     DEST+1                    //&      a2ae   85 74                                                
          lda     LOWTR                     //&      a2b0   a5 aa                                                
          dey                               //&      a2b2   88                                               
          sbc     (LOWTR),y                 //&      a2b3   f1 aa                                                   
          clc                               //&      a2b5   18                                               
          adc     VARTAB                    //&      a2b6   65 7b                                                
          sta     VARTAB                    //&      a2b8   85 7b                                                
          sta     DEST                      //&      a2ba   85 73                                                
          lda     VARTAB+1                  //&      a2bc   a5 7c                                                
          adc     #$FF                      //&      a2be   69 ff                                                  
          sta     VARTAB+1                  //&      a2c0   85 7c                                                
          sbc     LOWTR+1                   //&      a2c2   e5 ab                                                
          tax                               //&      a2c4   aa                                               
          sec                               //&      a2c5   38                                               
          lda     LOWTR                     //&      a2c6   a5 aa                                                
          sbc     VARTAB                    //&      a2c8   e5 7b                                                
          tay                               //&      a2ca   a8                                               
          bcs     !Skip+                    //&      a2cb   b0 03                                                  
          inx                               //&      a2cd   e8                                               
          dec     DEST+1                    //&      a2ce   c6 74                                                
!Skip:    
          clc                               //&      a2d0   18                                               
          adc     INDEX                     //&      a2d1   65 71                                                
          bcc     SearchNum                 //&      a2d3   90 03                                                  
          dec     INDEX+1                   //&      a2d5   c6 72                                                
          clc                               //&      a2d7   18                                               
SearchNum:
          lda     (INDEX),y                 //&      a2d8   b1 71                                                   
          sta     (DEST),y                  //&      a2da   91 73                                                   
          iny                               //&      a2dc   c8                                               
          bne     SearchNum                 //&      a2dd   d0 f9                                                  
          inc     INDEX+1                   //&      a2df   e6 72                                                
          inc     DEST+1                    //&      a2e1   e6 74                                                
          dex                               //&      a2e3   ca                                               
          bne     SearchNum                 //&      a2e4   d0 f2                                                  
// ----------------------------------------------------------------------------
PUT_NEW_LINE:
          lda     INPUTBUFFER               //&      a2e6   a5 13                                                
          beq     FIX_LINKS                 //&      a2e8   f0 2f                                                  
          lda     MEMSIZ                    //&      a2ea   a5 85                                                
          ldy     MEMSIZ+1                  //&      a2ec   a4 86                                                
          sta     FRETOP                    //&      a2ee   85 81                                                
          sty     FRETOP+1                  //&      a2f0   84 82                                                
          lda     VARTAB                    //&      a2f2   a5 7b                                                
          sta     HIGHTR                    //&      a2f4   85 a6                                                
          adc     EOLPNTR                   //&      a2f6   65 5d                                                
          sta     HIGHDS                    //&      a2f8   85 a4                                                
          ldy     VARTAB+1                  //&      a2fa   a4 7c                                                
          sty     HIGHTR+1                  //&      a2fc   84 a7                                                
          bcc     Bypass                    //&      a2fe   90 01                                                  
          iny                               //&      a300   c8                                               
Bypass:    
          sty     HIGHDS+1                  //&      a301   84 a5                                                
          jsr     BLTU                      //&      a303   20 cf a1                                               
          lda     STREND                    //&      a306   a5 7f                                                
          ldy     STREND+1                  //&      a308   a4 80                                                
          sta     VARTAB                    //&      a30a   85 7b                                                
          sty     VARTAB+1                  //&      a30c   84 7c                                                
          ldy     EOLPNTR                   //&      a30e   a4 5d                                                
          dey                               //&      a310   88                                               
// ---COPY LINE INTO PROGRAM-------
Loop2:
          lda     INPUTBUFFER-4,y           //&      a311   b9 0f 00                                                 
          sta     (LOWTR),y                 //&      a314   91 aa                                                   
          dey                               //&      a316   88                                               
          bpl     Loop2                     //&      a317   10 f8                                                  
// ----------------------------------------------------------------------------
// CLEAR ALL VARIABLES
// RE-ESTABLISH ALL FORWARD LINKS
// ----------------------------------------------------------------------------
FIX_LINKS:
          jsr SETPTRS                       //&      a319   20 77 a4                                               
          lda TXTTAB                        //&      a31c   a5 79                                                
          ldy TXTTAB+1                      //&      a31e   a4 7a                                                
          sta INDEX                         //&      a320   85 71                                                
          sty INDEX+1                       //&      a322   84 72                                                
          clc                               //&      a324   18                                               
Loop3:
          ldy #$01                          //&      a325   a0 01                                                  
          lda (INDEX),y                     //&      a327   b1 71                                                   
          bne skip2                         //&      a329   d0 03                                                  
          jmp Loop1                         //&      a32b   4c 7d a2                                               
skip2:
          ldy #$04                          //&      a32e   a0 04                                                  
Loop4:
          iny                               //&      a330   c8                                               
          lda (INDEX),y                     //&      a331   b1 71                                                   
          bne Loop4                         //&      a333   d0 fb                                                  
          iny                               //&      a335   c8                                               
          tya                               //&      a336   98                                               
          adc INDEX                         //&      a337   65 71                                                
          tax                               //&      a339   aa                                               
          ldy #$00                          //&      a33a   a0 00                                                  
          sta (INDEX),y                     //&      a33c   91 71                                                   
          lda INDEX+1                       //&      a33e   a5 72                                                
          adc #$00                          //&      a340   69 00                                                  
          iny                               //&      a342   c8                                               
          sta (INDEX),y                     //&      a343   91 71                                                   
          stx INDEX                         //&      a345   86 71                                                
          sta INDEX+1                       //&      a347   85 72                                                
          bcc Loop3                         //&      a349   90 da                                                  
// ----------------------------------------------------------------------------

          jsr $a8e5                         //&      a34b   20 e5 a8                                               
          dex                               //&      a34e   ca                                               
          bpl $a359                         //&      a34f   10 08                                                  
la351:      
          jsr $a8e5                         //&      a351   20 e5 a8                                               
          jsr $a86c                         //&      a354   20 6c a8                                               
// ----------------------------------------------------------------------------
// READ A LINE, AND STRIP OFF SIGN BITS
// ----------------------------------------------------------------------------
INLIN:
          ldx #$00                     //&      a357   a2 00                                                  
INLIN2:
          jsr $a386                    //&      a359   20 86 a3                                               
          cmp #$07                     //&      a35c   c9 07                                                  
          beq $a374                    //&      a35e   f0 14                                                  
          cmp #$0d                     //&      a360   c9 0d                                                  
          beq $a383                    //&      a362   f0 1f                                                  
          cmp #$0b                     //&      a364   c9 0b                                                  
          bcc $a359                    //&      a366   90 f1                                                  
          cmp #$7f                     //&      a368   c9 7f                                                  
          bcs $a359                    //&      a36a   b0 ed                                                  
          cmp #$40                     //&      a36c   c9 40                                                  
          beq $a351                    //&      a36e   f0 e1                                                  
          jmp $fcd5                    //&      a370   4c d5 fc                                               
          .byte $d7                    //&      a373   d7         %11010111                                                     
la374:
          cpx #$47                     //&      a374   e0 47                                                  
          bcs $a37c                    //&      a376   b0 04                                                  
          sta $13,x                    //&      a378   95 13                                                  
          inx                          //&      a37a   e8                                               
          bit $07a9                    //&      a37b   2c a9 07                                               


          jsr $a8e5                    //&      a37e   20 e5 a8                                               
          bne $a359                    //&      a381   d0 d6                                                  
la383:
          jmp $a866                    //&      a383   4c 66 a8                                               
GETLN:
          jsr $ffeb                    //&      a386   20 eb ff                                               
          nop                          //&      a389   ea                                               
          nop                          //&      a38a   ea                                               
          nop                          //&      a38b   ea                                               
          nop                          //&      a38c   ea                                               
          nop                          //&      a38d   ea                                               
          nop                          //&      a38e   ea                                               
          nop                          //&      a38f   ea                                               
          nop                          //&      a390   ea                                               
          nop                          //&      a391   ea                                               
          nop                          //&      a392   ea                                               
          nop                          //&      a393   ea                                               
          nop                          //&      a394   ea                                               
          nop                          //&      a395   ea                                               
          nop                          //&      a396   ea                                               
          and #$7f                     //&      a397   29 7f                                                  
RDKEY:
          cmp #$0f                     //&      a399   c9 0f                                                  
          bne $a3a5                    //&      a39b   d0 08                                                  
          pha                          //&      a39d   48                                               
          lda $64                      //&      a39e   a5 64                                                
          eor #$ff                     //&      a3a0   49 ff                                                  
          sta $64                      //&      a3a2   85 64 
          pla                          //&      a3a4   68                                               
la3a5:
          rts                          //&      a3a5   60                                               
// ----------------------------------------------------------------------------
// TOKENIZE THE INPUT LINE
// ----------------------------------------------------------------------------
PARSE_INPUT_LINE:
          ldx.zp $c3                      //&      a3a6   a6 c3                                                
          ldy #$04                     //&      a3a8   a0 04                                                  
          sty $60                      //&      a3aa   84 60                                                
la3ac:
          lda.zp $00,x                    //&      a3ac   b5 00                                                  
          cmp #$20                     //&      a3ae   c9 20                                                  
          beq $a3ec                    //&      a3b0   f0 3a                                                  
          sta $5c                      //&      a3b2   85 5c                                                
          cmp #$22                     //&      a3b4   c9 22                                                  
          beq $a410                    //&      a3b6   f0 58                                                  
          bit $60                      //&      a3b8   24 60                                                
          bvs $a3ec                    //&      a3ba   70 30                                                  
          cmp #$3f                     //&      a3bc   c9 3f                                                  
          bne $a3c4                    //&      a3be   d0 04                                                  
          lda #$97                     //&      a3c0   a9 97                                                  
          bne $a3ec                    //&      a3c2   d0 28                                                  
la3c4:
          cmp #$30                     //&      a3c4   c9 30                                                  
          bcc $a3cc                    //&      a3c6   90 04                                                  
          cmp #$3c                     //&      a3c8   c9 3c                                                  
          bcc $a3ec                    //&      a3ca   90 20                                                  
// ----------------------------------------------------------------------------
// SEARCH TOKEN NAME TABLE FOR MATCH STARTING
// WITH CURRENT CHAR FROM INPUT LINE
// ----------------------------------------------------------------------------
la3cc:
          sty $ba                      //&      a3cc   84 ba                                                
          ldy #$00                     //&      a3ce   a0 00                                                  
          sty $5d                      //&      a3d0   84 5d                                                
          dey                          //&      a3d2   88                                               
          stx.zp $c3                      //&      a3d3   86 c3                                                
          dex                          //&      a3d5   ca                                               
la3d6:
          iny                          //&      a3d6   c8                                               
la3d7:
          inx                          //&      a3d7   e8                                               
la3d8:
          lda.zp $00,x                    //&      a3d8   b5 00                                                  
          cmp #$20                     //&      a3da   c9 20                                                  
          beq $a3d7                    //&      a3dc   f0 f9                                                  
          sec                          //&      a3de   38                                               
          sbc $a084,y                   //&      a3df   f9 84 a0                                                 
          beq $a3d6                    //&      a3e2   f0 f2                                                  
          cmp #$80                     //&      a3e4   c9 80                                                  
          bne $a417                    //&      a3e6   d0 2f                                                  
          ora $5d                      //&      a3e8   05 5d                                                
// ----------------------------------------------------------------------------
// STORE CHARACTER OR TOKEN IN OUTPUT LINE
// ----------------------------------------------------------------------------
la3ea:
          ldy $ba                      //&      a3ea   a4 ba                                                
la3ec:
          inx                          //&      a3ec   e8                                               
          iny                          //&      a3ed   c8                                               
          sta $000e,y                   //&      a3ee   99 0e 00                                                 
          lda $000e,y                   //&      a3f1   b9 0e 00                                                 
          beq $a42a                    //&      a3f4   f0 34                                                  
          sec                          //&      a3f6   38                                               
          sbc #$3a                     //&      a3f7   e9 3a                                                  
          beq $a3ff                    //&      a3f9   f0 04                                                  
          cmp #$49                     //&      a3fb   c9 49                                                  
          bne $a401                    //&      a3fd   d0 02                                                  
la3ff:
          sta $60                      //&      a3ff   85 60                                                
la401:
          sec                          //&      a401   38                                               
          sbc #$54                     //&      a402   e9 54                                                  
          bne $a3ac                    //&      a404   d0 a6                                                  
          sta $5c                      //&      a406   85 5c                                                
// ----------------------------------------------------------------------------
// HANDLE LITERAL (BETWEEN QUOTES) OR REMARK,
// BY COPYING CHARS UP TO ENDCHR.
// ----------------------------------------------------------------------------
la408:
          lda GORESTART,x                    //&      a408   b5 00                                                  
          beq $a3ec                    //&      a40a   f0 e0                                                  
          cmp $5c                      //&      a40c   c5 5c                                                
          beq $a3ec                    //&      a40e   f0 dc                                                  
la410:
          iny                          //&      a410   c8                                               
          sta $000e,y                   //&      a411   99 0e 00                                                 
          inx                          //&      a414   e8                                               
          bne $a408                    //&      a415   d0 f1                                                  
// ----------------------------------------------------------------------------
// ADVANCE POINTER TO NEXT TOKEN NAME
// ----------------------------------------------------------------------------
la417:
          ldx.zp $c3                      //&      a417   a6 c3                                                
          inc $5d                      //&      a419   e6 5d                                                
la41b:
          iny                          //&      a41b   c8                                               
          lda $a083,y                   //&      a41c   b9 83 a0                                                 
          bpl $a41b                    //&      a41f   10 fa                                                  
          lda $a084,y                   //&      a421   b9 84 a0                                                 
          bne $a3d8                    //&      a424   d0 b2                                                  
          lda GORESTART,x                    //&      a426   b5 00                                                  
          bpl $a3ea                    //&      a428   10 c0                                                  
// ---END OF LINE------------------
la42a:
          sta $0010,y                   //&      a42a   99 10 00                                                 
          lda #$12                     //&      a42d   a9 12                                                  
          sta.zp $c3                      //&      a42f   85 c3                                                
          rts                          //&      a431   60                                               
// ----------------------------------------------------------------------------
// SEARCH FOR LINE
//
// (LINNUM) = LINE # TO FIND
// IF NOT FOUND:  CARRY = 0
//	LOWTR POINTS AT NEXT LINE
// IF FOUND:      CARRY = 1
//	LOWTR POINTS AT LINE
// ----------------------------------------------------------------------------
FNDLIN:
          lda $79                      //&      a432   a5 79                                                
          ldx $7a                      //&      a434   a6 7a                                                
FL1:
          ldy #$01                     //&      a436   a0 01                                                  
          sta $aa                      //&      a438   85 aa                                                
          stx $ab                      //&      a43a   86 ab                                                
          lda ($aa),y                   //&      a43c   b1 aa                                                   
          beq $a45f                    //&      a43e   f0 1f                                                  
          iny                          //&      a440   c8                                               
          iny                          //&      a441   c8                                               
          lda $12                      //&      a442   a5 12                                                
          cmp ($aa),y                   //&      a444   d1 aa                                                   
          bcc $a460                    //&      a446   90 18                                                  
          beq $a44d                    //&      a448   f0 03                                                  
          dey                          //&      a44a   88                                               
          bne $a456                    //&      a44b   d0 09                                                  
la44d:
          lda $11                      //&      a44d   a5 11                                                
          dey                          //&      a44f   88                                               
          cmp ($aa),y                   //&      a450   d1 aa                                                   
          bcc $a460                    //&      a452   90 0c                                                  
          beq $a460                    //&      a454   f0 0a                                                  
la456:
          dey                          //&      a456   88                                               
          lda ($aa),y                   //&      a457   b1 aa                                                   
          tax                          //&      a459   aa                                               
          dey                          //&      a45a   88                                               
          lda ($aa),y                   //&      a45b   b1 aa                                                   
          bcs $a436                    //&      a45d   b0 d7                                                  
la45f:
          clc                          //&      a45f   18                                               
la460:
          rts                          //&      a460   60                                               
// ----------------------------------------------------------------------------
// "NEW" STATEMENT
// ----------------------------------------------------------------------------
NEW:
          bne $a460                    //&      a461   d0 fd                                                  
SCRTCH:
          lda #$00                     //&      a463   a9 00                                                  
          tay                          //&      a465   a8                                               
          sta ($79),y                   //&      a466   91 79                                                   
          iny                          //&      a468   c8                                               
          sta ($79),y                   //&      a469   91 79                                                   
          lda $79                      //&      a46b   a5 79                                                
          adc #$02                     //&      a46d   69 02                                                  
          sta $7b                      //&      a46f   85 7b                                                
          lda $7a                      //&      a471   a5 7a                                                
          adc #$00                     //&      a473   69 00                                                  
          sta $7c                      //&      a475   85 7c                                                
// ----------------------------------------------------------------------------
SETPTRS:
          jsr $a4a7                    //&      a477   20 a7 a4                                               
// ----------------------------------------------------------------------------
// "CLEAR" STATEMENT
// ----------------------------------------------------------------------------
CLEARC:
          lda $85                      //&      a47a   a5 85                                                
          ldy $86                      //&      a47c   a4 86                                                
          sta $81                      //&      a47e   85 81                                                
          sty $82                      //&      a480   84 82                                                
          lda $7b                      //&      a482   a5 7b                                                
          ldy $7c                      //&      a484   a4 7c                                                
          sta $7d                      //&      a486   85 7d                                                
          sty $7e                      //&      a488   84 7e                                                
          sta $7f                      //&      a48a   85 7f                                                
          sty $80                      //&      a48c   84 80                                                
          jsr $a61a                    //&      a48e   20 1a a6                                               
// ----------------------------------------------------------------------------
STKINI:
          ldx #$68                     //&      a491   a2 68                                                  
          stx $65                      //&      a493   86 65                                                
          pla                          //&      a495   68                                               
          sta $01fd                    //&      a496   8d fd 01                                               
          pla                          //&      a499   68                                               
          sta $01fe                    //&      a49a   8d fe 01                                               
          ldx #$fc                     //&      a49d   a2 fc                                                  
          txs                          //&      a49f   9a                                               
          lda #$00                     //&      a4a0   a9 00                                                  
          sta $8c                      //&      a4a2   85 8c                                                
          sta $61                      //&      a4a4   85 61                                                
la4a6:
   rts                          //&      a4a6   60                                               
// ----------------------------------------------------------------------------
// SET TXTPTR TO BEGINNING OF PROGRAM
// ----------------------------------------------------------------------------
STXTPT:
          clc                          //&      a4a7   18                                               
          lda $79                      //&      a4a8   a5 79                                                
          adc #$ff                     //&      a4aa   69 ff                                                  
          sta.zp $c3                      //&      a4ac   85 c3                                                
          lda $7a                      //&      a4ae   a5 7a                                                
          adc #$ff                     //&      a4b0   69 ff                                                  
          sta.zp $c4                      //&      a4b2   85 c4                                                
          rts                          //&      a4b4   60                                               
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// "LIST" STATEMENT
// ----------------------------------------------------------------------------
LIST:
          bcc $a4bd                    //&      a4b5   90 06                                                  
          beq $a4bd                    //&      a4b7   f0 04                                                  
          cmp #$a4                     //&      a4b9   c9 a4                                                  
          bne $a4a6                    //&      a4bb   d0 e9                                                  

          jsr $a77f                    //&      a4bd   20 7f a7                                               
          jsr $a432                    //&      a4c0   20 32 a4                                               
          jsr $00c2                    //&      a4c3   20 c2 00                                               
          beq $a4d4                    //&      a4c6   f0 0c                                                  
          cmp #$a4                     //&      a4c8   c9 a4                                                  
          bne $a460                    //&      a4ca   d0 94                                                  
          jsr $00bc                    //&      a4cc   20 bc 00                                               
          jsr $a77f                    //&      a4cf   20 7f a7                                               
          bne $a460                    //&      a4d2   d0 8c                                                  
la4d4:
          pla                          //&      a4d4   68                                               
          pla                          //&      a4d5   68                                               
          lda $11                      //&      a4d6   a5 11                                                
          ora $12                      //&      a4d8   05 12                                                
          bne $a4e2                    //&      a4da   d0 06                                                  
          lda #$ff                     //&      a4dc   a9 ff                                                  
          sta $11                      //&      a4de   85 11                                                
          sta $12                      //&      a4e0   85 12                                                
la4e2:
   ldy #$01                     //&      a4e2   a0 01                                                  
          sty $60                      //&      a4e4   84 60                                                
          lda ($aa),y                   //&      a4e6   b1 aa                                                   
          beq $a52b                    //&      a4e8   f0 41                                                  
          jsr $a629                    //&      a4ea   20 29 a6                                               
          jsr $a86c                    //&      a4ed   20 6c a8                                               
          iny                          //&      a4f0   c8                                               
          lda ($aa),y                   //&      a4f1   b1 aa                                                   
          tax                          //&      a4f3   aa                                               
          iny                          //&      a4f4   c8                                               
          lda ($aa),y                   //&      a4f5   b1 aa                                                   
          cmp $12                      //&      a4f7   c5 12                                                
          bne $a4ff                    //&      a4f9   d0 04                                                  
          cpx $11                      //&      a4fb   e4 11                                                
          beq $a501                    //&      a4fd   f0 02                                                  
la4ff:
          bcs $a52b                    //&      a4ff   b0 2a                                                  
// ---LIST ONE LINE----------------
la501:
          sty $97                      //&      a501   84 97                                                
          jsr $b95e                    //&      a503   20 5e b9                                               
          lda #$20                     //&      a506   a9 20                                                  
la508:
          ldy $97                      //&      a508   a4 97                                                
          and #$7f                     //&      a50a   29 7f                                                  
la50c:
          jsr $a8e5                    //&      a50c   20 e5 a8                                               
          cmp #$22                     //&      a50f   c9 22                                                  
          bne $a519                    //&      a511   d0 06                                                  
          lda $60                      //&      a513   a5 60                                                
          eor #$ff                     //&      a515   49 ff                                                  
          sta $60                      //&      a517   85 60                                                
la519:
          iny                          //&      a519   c8                                               
          lda ($aa),y                   //&      a51a   b1 aa                                                   
          bne $a52e                    //&      a51c   d0 10                                                  
          tay                          //&      a51e   a8                                               
          lda ($aa),y                   //&      a51f   b1 aa                                                   
          tax                          //&      a521   aa                                               
          iny                          //&      a522   c8                                               
          lda ($aa),y                   //&      a523   b1 aa                                                   
          stx $aa                      //&      a525   86 aa                                                
          sta $ab                      //&      a527   85 ab                                                
          bne $a4e2                    //&      a529   d0 b7                                                  
la52b:
          jmp $a274                    //&      a52b   4c 74 a2                                               
la52e:
          bpl $a50c                    //&      a52e   10 dc                                                  
          cmp #$ff                     //&      a530   c9 ff                                                  
          beq $a50c                    //&      a532   f0 d8                                                  
          bit $60                      //&      a534   24 60                                                
          bmi $a50c                    //&      a536   30 d4                                                  
          sec                          //&      a538   38                                               
          sbc #$7f                     //&      a539   e9 7f                                                  
          tax                          //&      a53b   aa                                               
          sty $97                      //&      a53c   84 97                                                
          ldy #$ff                     //&      a53e   a0 ff                                                  
la540:
          dex                          //&      a540   ca                                               
          beq $a54b                    //&      a541   f0 08                                                  
la543:
          iny                          //&      a543   c8                                               
          lda $a084,y                   //&      a544   b9 84 a0                                                 
          bpl $a543                    //&      a547   10 fa                                                  
          bmi $a540                    //&      a549   30 f5                                                  
la54b:
          iny                          //&      a54b   c8                                               
          lda $a084,y                   //&      a54c   b9 84 a0                                                 
          bmi $a508                    //&      a54f   30 b7                                                  
          jsr $a8e5                    //&      a551   20 e5 a8                                               
          bne $a54b                    //&      a554   d0 f5                                                  
// ----------------------------------------------------------------------------
// "FOR" STATEMENT
//
// FOR PUSHES 18 BYTES ON THE STACK:
// 2 -- TXTPTR
// 2 -- LINE NUMBER
// 5 -- INITIAL (CURRENT)  FOR VARIABLE VALUE
// 1 -- STEP SIGN
// 5 -- STEP VALUE
// 2 -- ADDRESS OF FOR VARIABLE IN VARTAB
// 1 -- FOR TOKEN ($81)
// ----------------------------------------------------------------------------
FOR:
          lda #$80                     //&      a556   a9 80                                                  
          sta $61                      //&      a558   85 61                                                
          jsr $a7b9                    //&      a55a   20 b9 a7                                               
          jsr $a1a1                    //&      a55d   20 a1 a1                                               
          bne $a567                    //&      a560   d0 05                                                  
          txa                          //&      a562   8a                                               
          adc #$0d                     //&      a563   69 0d                                                  
          tax                          //&      a565   aa                                               
          txs                          //&      a566   9a                                               
la567:
          pla                          //&      a567   68                                               
          pla                          //&      a568   68                                               
          lda #$08                     //&      a569   a9 08                                                  
          jsr $a212                    //&      a56b   20 12 a2                                               
          jsr $a71a                    //&      a56e   20 1a a7                                               
          clc                          //&      a571   18                                               
          tya                          //&      a572   98                                               
          adc.zp $c3                      //&      a573   65 c3                                                
          pha                          //&      a575   48                                               
          lda.zp $c4                      //&      a576   a5 c4                                                
          adc #$00                     //&      a578   69 00                                                  
          pha                          //&      a57a   48                                               
          lda $88                      //&      a57b   a5 88                                                
          pha                          //&      a57d   48                                               
          lda $87                      //&      a57e   a5 87                                                
          pha                          //&      a580   48                                               
          lda #$9d                     //&      a581   a9 9d                                                  
          jsr $ac03                    //&      a583   20 03 ac                                               
          jsr $aab0                    //&      a586   20 b0 aa                                               
          jsr $aaad                    //&      a589   20 ad aa                                               
          lda $b0                      //&      a58c   a5 b0                                                
          ora #$7f                     //&      a58e   09 7f                                                  
          and $ad                      //&      a590   25 ad                                                
          sta $ad                      //&      a592   85 ad                                                
          lda #$9f                     //&      a594   a9 9f                                                  
          ldy #$a5                     //&      a596   a0 a5                                                  
          sta $71                      //&      a598   85 71                                                
          sty $72                      //&      a59a   84 72                                                
          jmp $ab66                    //&      a59c   4c 66 ab                                               
// ----------------------------------------------------------------------------
// "STEP" PHRASE OF "FOR" STATEMENT
// ----------------------------------------------------------------------------
STEP:
          lda #$9c                     //&      a59f   a9 9c                                                  
          ldy #$b5                     //&      a5a1   a0 b5                                                  
          jsr $b74b                    //&      a5a3   20 4b b7                                               
          jsr $00c2                    //&      a5a6   20 c2 00                                               
          cmp #$a2                     //&      a5a9   c9 a2                                                  
          bne $a5b3                    //&      a5ab   d0 06                                                  
          jsr $00bc                    //&      a5ad   20 bc 00                                               
          jsr $aaad                    //&      a5b0   20 ad aa                                               
la5b3:
          jsr $b7ca                    //&      a5b3   20 ca b7                                               
          jsr $ab5b                    //&      a5b6   20 5b ab                                               
          lda $98                      //&      a5b9   a5 98                                                
          pha                          //&      a5bb   48                                               
          lda $97                      //&      a5bc   a5 97                                                
          pha                          //&      a5be   48                                               
          lda #$81                     //&      a5bf   a9 81                                                  
          pha                          //&      a5c1   48                                               
// ----------------------------------------------------------------------------
// PERFORM NEXT STATEMENT
// ----------------------------------------------------------------------------
NEWSTT:
          jsr $a629                    //&      a5c2   20 29 a6                                               
          lda.zp $c3                      //&      a5c5   a5 c3                                                
          ldy.zp $c4                      //&      a5c7   a4 c4                                                
          beq $a5d1                    //&      a5c9   f0 06                                                  
          sta $8b                      //&      a5cb   85 8b                                                
          sty $8c                      //&      a5cd   84 8c                                                
          ldy #$00                     //&      a5cf   a0 00                                                  
la5d1:
          lda ($c3),y                   //&      a5d1   b1 c3                                                   
          beq $a5dc                    //&      a5d3   f0 07                                                  
          cmp #$3a                     //&      a5d5   c9 3a                                                  
          beq $a5f6                    //&      a5d7   f0 1d                                                  
SYNERR1:
          jmp $ac0c                    //&      a5d9   4c 0c ac                                               
la5dc:
          ldy #$02                     //&      a5dc   a0 02                                                  
          lda ($c3),y                   //&      a5de   b1 c3                                                   
          clc                          //&      a5e0   18                                               
          beq $a651                    //&      a5e1   f0 6e                                                  
          iny                          //&      a5e3   c8                                               
          lda ($c3),y                   //&      a5e4   b1 c3                                                   
          sta $87                      //&      a5e6   85 87                                                
          iny                          //&      a5e8   c8                                               
          lda ($c3),y                   //&      a5e9   b1 c3                                                   
          sta $88                      //&      a5eb   85 88                                                
          tya                          //&      a5ed   98                                               
          adc.zp $c3                      //&      a5ee   65 c3                                                
          sta.zp $c3                      //&      a5f0   85 c3                                                
          bcc $a5f6                    //&      a5f2   90 02                                                  
          inc.zp $c4                      //&      a5f4   e6 c4                                                
NEWSTT2:
          jsr $00bc                    //&      a5f6   20 bc 00                                               
          jsr $a5ff                    //&      a5f9   20 ff a5                                               
          jmp $a5c2                    //&      a5fc   4c c2 a5                                               
// ----------------------------------------------------------------------------
// EXECUTE A STATEMENT
//
// (A) IS FIRST CHAR OF STATEMENT
// CARRY IS SET
// ----------------------------------------------------------------------------
EXECUTE_STATEMENT:
          beq !RTS++                    //&      a5ff   f0 79                                                  
          sec                           //&      a601   38                                               
EXECUTE_STATEMENT1:
          sbc #$80                      //&      a602   e9 80                                                  
          bcs !Skip+                    //&      a604   b0 03                                                  
          jmp $a7b9                    //&      a606   4c b9 a7                                               
!Skip:
          cmp #$1c                     //&      a609   c9 1c                                                  
          bcs $a5d9                    //&      a60b   b0 cc                                                  
          asl                          //&      a60d   0a                                                 
          tay                          //&      a60e   a8                                               
          lda $a001,y                   //&      a60f   b9 01 a0                                                 
          pha                          //&      a612   48                                               
          lda $a000,y                   //&      a613   b9 00 a0                                                 
          pha                          //&      a616   48                                               
          jmp $00bc                    //&      a617   4c bc 00                                               
// ----------------------------------------------------------------------------
// "RESTORE" STATEMENT
// ----------------------------------------------------------------------------
RESTORE:
          sec                          //&      a61a   38                                               
          lda $79                      //&      a61b   a5 79                                                
          sbc #$01                     //&      a61d   e9 01                                                  
          ldy $7a                      //&      a61f   a4 7a                                                
          bcs !Skip+                    //&      a621   b0 01                                                  
          dey                          //&      a623   88                                               
!Skip:
          sta $8f                      //&      a624   85 8f                                                
          sty $90                      //&      a626   84 90                                                
!RTS:
          rts                          //&      a628   60                                               
la629:
          jmp $fff1                    //&      a629   4c f1 ff                                               
          nop                          //&      a62c   ea                                               
          nop                          //&      a62d   ea                                               
          nop                          //&      a62e   ea                                               
          nop                          //&      a62f   ea                                               
          lsr                          //&      a630   4a                                                 
          bcc $a628                    //&      a631   90 f5                                                  
          jsr $a386                    //&      a633   20 86 a3                                               
          cmp #$03                     //&      a636   c9 03                                                  












STOP:
          bcs END2                     //&      a638   b0 01                                                  
//=======================================
// END 
//=======================================
END:
          clc                          //&      a63a   18                                               
END2: 
          bne !RTS+                     //&      a63b   d0 3d                                                  
          lda.zp $c3                      //&      a63d   a5 c3                                                
          ldy.zp $c4                      //&      a63f   a4 c4                                                
          beq !Skip+                    //&      a641   f0 0c                                                  
          sta $8b                      //&      a643   85 8b                                                
          sty $8c                      //&      a645   84 8c                                                
CTRL_C_Pressed:
          lda $87                      //&      a647   a5 87                                                
          ldy $88                      //&      a649   a4 88                                                
          sta $89                      //&      a64b   85 89                                                
          sty $8a                      //&      a64d   84 8a                                                
!Skip:
          pla                          //&      a64f   68                                               
          pla                          //&      a650   68                                               
la651:
          lda #$99                     //&      a651   a9 99                                                  
          ldy #$a1                     //&      a653   a0 a1                                                  
          ldx #$00                     //&      a655   a2 00                                                  
          stx $64                      //&      a657   86 64                                                
          bcc !Skip+                    //&      a659   90 03                                                  
          jmp PRINT_ERROR_LINNUM                    //&      a65b   4c 69 a2                                               
!Skip:
          jmp RESTART                    //&      a65e   4c 74 a2                                               
// ----------------------------------------------------------------------------
// "CONT" COMMAND
// ----------------------------------------------------------------------------
CONT:
          bne !RTS+                    //&      a661   d0 17                                                  
          ldx #$1e                     //&      a663   a2 1e                                                  
          ldy $8c                      //&      a665   a4 8c                                                
          bne !Skip+                    //&      a667   d0 03                                                  
          jmp ERROR                    //&      a669   4c 4e a2                                               
!Skip:
          lda $8b                      //&      a66c   a5 8b                                                
          sta.zp $c3                   //&      a66e   85 c3                                                
          sty.zp $c4                    //&      a670   84 c4                                                
          lda $89                      //&      a672   a5 89                                                
          ldy $8a                      //&      a674   a4 8a                                                
          sta $87                      //&      a676   85 87                                                
          sty $88                      //&      a678   84 88                                                
!RTS:
          rts                          //&      a67a   60
NULL:                                               
          jsr GETBYT                    //&      a67b   20 ae b3                                               
          bne !RTS-                    //&      a67e   d0 fa                                                  
          inx                          //&      a680   e8                                               
          cpx #$0a                     //&      a681   e0 0a                                                  
          bcs !Skip+                    //&      a683   b0 04                                                  
          dex                          //&      a685   ca                                               
          stx $0d                      //&      a686   86 0d                                                
          rts                          //&      a688   60                                               
!Skip:
          jmp IQERR                    //&      a689   4c 88 ae                                               
CLEAR:          
          bne !RTS-                     //&      a68c   d0 ec                                                  
          jmp CLEARC                    //&      a68e   4c 7a a4                                               
// ----------------------------------------------------------------------------
// "RUN" COMMAND
// ----------------------------------------------------------------------------
RUN:          
          bne !Skip+                    //&      a691   d0 03                                                  
          jmp SETPTRS                    //&      a693   4c 77 a4                                               
!Skip:
          jsr CLEARC                    //&      a696   20 7a a4                                               
          jmp $a6b0                    //&      a699   4c b0 a6                                               
// ----------------------------------------------------------------------------
// "GOSUB" STATEMENT
//
// LEAVES 7 BYTES ON STACK:
// 2 -- RETURN ADDRESS (NEWSTT)
// 2 -- TXTPTR
// 2 -- LINE #
// 1 -- GOSUB TOKEN
// ----------------------------------------------------------------------------
GOSUB:
          lda #$03                     //&      a69c   a9 03                                                  
          jsr CHKMEM                    //&      a69e   20 12 a2                                               
          lda.zp $c4                    //&      a6a1   a5 c4                                                
          pha                          //&      a6a3   48                                               
          lda.zp $c3                    //&      a6a4   a5 c3                                                
          pha                          //&      a6a6   48                                               
          lda $88                      //&      a6a7   a5 88                                                
          pha                          //&      a6a9   48                                               
          lda $87                      //&      a6aa   a5 87                                                
          pha                          //&      a6ac   48                                               
          lda #$8c                     //&      a6ad   a9 8c                                                  
          pha                          //&      a6af   48                                               
la6b0:
          jsr CHRGOT                    //&      a6b0   20 c2 00                                               
          jsr GOTO                     //&      a6b3   20 b9 a6                                               
          jmp NEWSTT                    //&      a6b6   4c c2 a5                                               
// ----------------------------------------------------------------------------
// "GOTO" STATEMENT
// ALSO USED BY "RUN" AND "GOSUB"
// ----------------------------------------------------------------------------
GOTO:
          jsr LINGET                    //&      a6b9   20 7f a7                                               
          jsr REMN                     //&      a6bc   20 1d a7                                               
          lda $88                      //&      a6bf   a5 88                                                
          cmp $12                      //&      a6c1   c5 12                                                
          bcs !Skip+                    //&      a6c3   b0 0b                                                  
          tya                          //&      a6c5   98                                               
          sec                          //&      a6c6   38                                               
          adc.zp $c3                    //&      a6c7   65 c3                                                
          ldx.zp $c4                    //&      a6c9   a6 c4                                                
          bcc !Skip++                   //&      a6cb   90 07                                                  
          inx                          //&      a6cd   e8                                               
          bcs !Skip++                   //&      a6ce   b0 04                                                  
!Skip:
          lda $79                      //&      a6d0   a5 79                                                
          ldx $7a                      //&      a6d2   a6 7a                                                
!Skip:
          jsr FL1                      //&      a6d4   20 36 a4                                               
          bcc UNDERR                    //&      a6d7   90 1e                                                  
          lda $aa                      //&      a6d9   a5 aa                                                
          sbc #$01                     //&      a6db   e9 01                                                  
          sta.zp $c3                    //&      a6dd   85 c3                                                
          lda $ab                      //&      a6df   a5 ab                                                
          sbc #$00                     //&      a6e1   e9 00                                                  
          sta.zp $c4                    //&      a6e3   85 c4                                                
la6e5:
!RTS:
          rts                          //&      a6e5   60   
// ----------------------------------------------------------------------------
// "POP" AND "RETURN" STATEMENTS
// ----------------------------------------------------------------------------
POP:                                                                      
          bne !RTS-                    //&      a6e6   d0 fd                                                  
          lda #$ff                     //&      a6e8   a9 ff                                                  
          sta $97                      //&      a6ea   85 97                                                
          jsr $a1a1                    //&      a6ec   20 a1 a1                                               
          txs                          //&      a6ef   9a                                               
          cmp #$8c                     //&      a6f0   c9 8c                                                  
          beq $a6ff                    //&      a6f2   f0 0b                                                  
          ldx #$04                     //&      a6f4   a2 04                                                  
          .byte $2c                    //&      a6f6   2c                                               
UNDERR:          
          ldx #$0e                     //&      a6f7   a2 0e 
          jmp ERROR                    //&      a6f9   4c 4e a2                                               
// ----------------------------------------------------------------------------
SYNERR2:
          jmp $ac0c                    //&      a6fc   4c 0c ac                                               
// ----------------------------------------------------------------------------
RETURN:
          pla                          //&      a6ff   68                                               
          pla                          //&      a700   68                                               
          sta $87                      //&      a701   85 87                                                
          pla                          //&      a703   68                                               
          sta $88                      //&      a704   85 88                                                
          pla                          //&      a706   68                                               
          sta.zp $c3                      //&      a707   85 c3                                                
          pla                          //&      a709   68                                               
          sta.zp $c4                      //&      a70a   85 c4                                                
// ----------------------------------------------------------------------------
// "DATA" STATEMENT
// EXECUTED BY SKIPPING TO NEXT COLON OR EOL
// ----------------------------------------------------------------------------
DATA:
          jsr $a71a                    //&      a70c   20 1a a7                                               
// ----------------------------------------------------------------------------
// ADD (Y) TO TXTPTR
// ----------------------------------------------------------------------------
ADDON:
          tya                          //&      a70f   98                                               
          clc                          //&      a710   18                                               
          adc.zp $c3                      //&      a711   65 c3                                                
          sta.zp $c3                      //&      a713   85 c3                                                
          bcc !RTS+                    //&      a715   90 02                                                  
          inc.zp $c4                      //&      a717   e6 c4                                                
!RTS:
          rts                          //&      a719   60                                               
// ----------------------------------------------------------------------------
// SCAN AHEAD TO NEXT ":" OR EOL
// ----------------------------------------------------------------------------
DATAN:
          ldx #$3a                     //&      a71a   a2 3a                                                  
          .byte $2c                    //&      a71b   2c
REMN:
          ldx #$00                     //&      a71c   a2 00                                               
          stx $5b                      //&      a71f   86 5b                                                
          ldy #$00                     //&      a721   a0 00                                                  
          sty $5c                      //&      a723   84 5c                                                
!Loop:
           lda $5c                      //&      a725   a5 5c                                                
           ldx $5b                      //&      a727   a6 5b                                                
           sta $5b                      //&      a729   85 5b                                                
           stx $5c                      //&      a72b   86 5c                                                
!Loop2:
           lda ($c3),y                   //&      a72d   b1 c3                                                   
           beq !RTS-                    //&      a72f   f0 e8                                                  
           cmp $5c                      //&      a731   c5 5c                                                
           beq !RTS-                    //&      a733   f0 e4                                                  
           iny                          //&      a735   c8                                               
           cmp #$22                     //&      a736   c9 22                                                  
           beq !Loop-                    //&      a738   f0 eb                                                  
           bne !Loop2-                   //&      a73a   d0 f1                                                  
// ----------------------------------------------------------------------------
// "IF" STATEMENT
// ----------------------------------------------------------------------------
IF:
          jsr $aac1                    //&      a73c   20 c1 aa                                               
          jsr $00c2                    //&      a73f   20 c2 00                                               
          cmp #$88                     //&      a742   c9 88                                                  
          beq !Skip+                    //&      a744   f0 05                                                  
          lda #$a0                     //&      a746   a9 a0                                                  
          jsr $ac03                    //&      a748   20 03 ac                                               
!Skip:
          lda $ac                              //&      a74b   a5 ac                                                
          bne !Skip+                    //&      a74d   d0 05                                                  
// ----------------------------------------------------------------------------
// "REM" STATEMENT, OR FALSE "IF" STATEMENT
// ----------------------------------------------------------------------------
REM: 
          jsr REMN                    //&      a74f   20 1d a7                                               
          beq ADDON                    //&      a752   f0 bb                                                  
!Skip:
          jsr $00c2                    //&      a754   20 c2 00                                               
          bcs !Skip+                   //&      a757   b0 03                                                  
          jmp GOTO                     //&      a759   4c b9 a6                                               
!Skip:
          jmp $a5ff                    //&      a75c   4c ff a5                                               
// ----------------------------------------------------------------------------
// "ON" STATEMENT
//
// ON <EXP> GOTO <LIST>
// ON <EXP> GOSUB <LIST>
// ----------------------------------------------------------------------------
ON:
          jsr $b3ae                    //&      a75f   20 ae b3                                               
          pha                          //&      a762   48                                               
          cmp #$8c                     //&      a763   c9 8c                                                  
          beq $a76b                    //&      a765   f0 04                                                  
la767:
          cmp #$88                     //&      a767   c9 88                                                  
          bne $a6fc                    //&      a769   d0 91                                                  
la76b:
          dec $af                      //&      a76b   c6 af                                                
          bne $a773                    //&      a76d   d0 04                                                  
          pla                          //&      a76f   68                                               
          jmp $a602                    //&      a770   4c 02 a6                                               
la773:
          jsr $00bc                    //&      a773   20 bc 00                                               
          jsr $a77f                    //&      a776   20 7f a7                                               
          cmp #$2c                     //&      a779   c9 2c                                                  
          beq $a76b                    //&      a77b   f0 ee                                                  
          pla                          //&      a77d   68                                               
la77e:
          rts                          //&      a77e   60                                               
// ----------------------------------------------------------------------------
// CONVERT LINE NUMBER
// ----------------------------------------------------------------------------
LINGET:
          ldx #$00                     //&      a77f   a2 00                                                  
          stx $11                      //&      a781   86 11                                                
          stx $12                      //&      a783   86 12                                                
la785:
          bcs $a77e                    //&      a785   b0 f7                                                  
          sbc #$2f                     //&      a787   e9 2f                                                  
          sta $5b                      //&      a789   85 5b                                                
          lda $12                      //&      a78b   a5 12                                                
          sta $71                      //&      a78d   85 71                                                
          cmp #$19                     //&      a78f   c9 19                                                  
          bcs $a767                    //&      a791   b0 d4                                                  
// <<<<<DANGEROUS CODE>>>>>
// NOTE THAT IF (A) = $AB ON THE LINE ABOVE,
// ON.1 WILL COMPARE = AND CAUSE A CATASTROPHIC
// JUMP TO $22D9 (FOR GOTO), OR OTHER LOCATIONS
// FOR OTHER CALLS TO LINGET.
//
// YOU CAN SEE THIS IS YOU FIRST PUT "BRK" IN $22D9,
// THEN TYPE "GO TO 437761".
//
// ANY VALUE FROM 437760 THROUGH 440319 WILL CAUSE
// THE PROBLEM.  ($AB00 - $ABFF)
// <<<<<DANGEROUS CODE>>>>>
          lda $11                      //&      a793   a5 11                                                
          asl                          //&      a795   0a                                                 
          rol $71                      //&      a796   26 71                                                
          asl                          //&      a798   0a                                                 
          rol $71                      //&      a799   26 71                                                
          adc $11                      //&      a79b   65 11                                                
          sta $11                      //&      a79d   85 11                                                
          lda $71                      //&      a79f   a5 71                                                
          adc $12                      //&      a7a1   65 12                                                
          sta $12                      //&      a7a3   85 12                                                
          asl $11                      //&      a7a5   06 11                                                
          rol $12                      //&      a7a7   26 12                                                
          lda $11                      //&      a7a9   a5 11                                                
          adc $5b                      //&      a7ab   65 5b                                                
          sta $11                      //&      a7ad   85 11                                                
          bcc $a7b3                    //&      a7af   90 02                                                  
          inc $12                      //&      a7b1   e6 12                                                
la7b3:
          jsr $00bc                    //&      a7b3   20 bc 00                                               
          jmp $a785                    //&      a7b6   4c 85 a7                                               
// ----------------------------------------------------------------------------
// "LET" STATEMENT
//
// LET <VAR> = <EXP>
// <VAR> = <EXP>
// ----------------------------------------------------------------------------
LET:
          jsr $ad0b                    //&      a7b9   20 0b ad                                               
          sta $97                      //&      a7bc   85 97                                                
          sty $98                      //&      a7be   84 98                                                
          lda #$ab                     //&      a7c0   a9 ab                                                  
          jsr $ac03                    //&      a7c2   20 03 ac                                               
          lda $5f                      //&      a7c5   a5 5f                                                
          pha                          //&      a7c7   48                                               
          jsr $aac1                    //&      a7c8   20 c1 aa                                               
          pla                          //&      a7cb   68                                               
          rol                          //&      a7cc   2a                                                 
          jsr $aab3                    //&      a7cd   20 b3 aa                                               
          bne $a7d5                    //&      a7d0   d0 03                                                  
// ----------------------------------------------------------------------------
// REAL VARIABLE = EXPRESSION
// ----------------------------------------------------------------------------
          jmp $b774                    //&      a7d2   4c 74 b7                                               
LETSTRING:
// ----------------------------------------------------------------------------
// INSTALL STRING, DESCRIPTOR ADDRESS IS AT FAC+3,4
// ----------------------------------------------------------------------------
           ldy #$02                     //&      a7d5   a0 02                                                  
          lda ($ae),y                   //&      a7d7   b1 ae                                                   
          cmp $82                      //&      a7d9   c5 82                                                
          bcc $a7f4                    //&      a7db   90 17                                                  
          bne $a7e6                    //&      a7dd   d0 07                                                  
          dey                          //&      a7df   88                                               
          lda ($ae),y                   //&      a7e0   b1 ae                                                   
          cmp $81                      //&      a7e2   c5 81                                                
          bcc $a7f4                    //&      a7e4   90 0e                                                  
la7e6:
          ldy $af                      //&      a7e6   a4 af                                                
          cpy $7c                      //&      a7e8   c4 7c                                                
          bcc $a7f4                    //&      a7ea   90 08                                                  
          bne $a7fb                    //&      a7ec   d0 0d                                                  
          lda $ae                      //&      a7ee   a5 ae                                                
          cmp $7b                      //&      a7f0   c5 7b                                                
          bcs $a7fb                    //&      a7f2   b0 07                                                  
la7f4:
          lda $ae                      //&      a7f4   a5 ae                                                
          ldy $af                      //&      a7f6   a4 af                                                
          jmp $a811                    //&      a7f8   4c 11 a8                                               
la7fb:
          ldy #$00                     //&      a7fb   a0 00                                                  
          lda ($ae),y                   //&      a7fd   b1 ae                                                   
          jsr $b09c                    //&      a7ff   20 9c b0                                               
          lda $9e                      //&      a802   a5 9e                                                
          ldy $9f                      //&      a804   a4 9f                                                
          sta $b8                      //&      a806   85 b8                                                
          sty $b9                      //&      a808   84 b9                                                
          jsr $b28a                    //&      a80a   20 8a b2                                               
          lda #$ac                     //&      a80d   a9 ac                                                  
          ldy #$00                     //&      a80f   a0 00                                                  
la811:
          sta $9e                      //&      a811   85 9e                                                
          sty $9f                      //&      a813   84 9f                                                
          jsr $b2eb                    //&      a815   20 eb b2                                               
          ldy #$00                     //&      a818   a0 00                                                  
          lda ($9e),y                   //&      a81a   b1 9e                                                   
          sta ($97),y                   //&      a81c   91 97                                                   
          iny                          //&      a81e   c8                                               
          lda ($9e),y                   //&      a81f   b1 9e                                                   
          sta ($97),y                   //&      a821   91 97                                                   
          iny                          //&      a823   c8                                               
          lda ($9e),y                   //&      a824   b1 9e                                                   
          sta ($97),y                   //&      a826   91 97                                                   
          rts                          //&      a828   60                                               
PRSTRING:
          jsr $a8c6                    //&      a829   20 c6 a8                                               
la82c:
          jsr $00c2                    //&      a82c   20 c2 00                                               
// ----------------------------------------------------------------------------
// "PRINT" STATEMENT
// ----------------------------------------------------------------------------
PRINT:
          beq $a86c                    //&      a82f   f0 3b                                                  
PRINT2:
          beq $a88a                    //&      a831   f0 57                                                  
          cmp #$9c                     //&      a833   c9 9c                                                  
          beq $a8a2                    //&      a835   f0 6b                                                  
          cmp #$9f                     //&      a837   c9 9f                                                  
          beq $a8a2                    //&      a839   f0 67                                                  
          cmp #$2c                     //&      a83b   c9 2c                                                  
          beq $a88b                    //&      a83d   f0 4c                                                  
          cmp #$3b                     //&      a83f   c9 3b                                                  
          beq $a8bd                    //&      a841   f0 7a                                                  
          jsr $aac1                    //&      a843   20 c1 aa                                               
          bit $5f                      //&      a846   24 5f                                                
          bmi $a829                    //&      a848   30 df                                                  
          jsr $b96e                    //&      a84a   20 6e b9                                               
          jsr $b0ae                    //&      a84d   20 ae b0                                               
          ldy #$00                     //&      a850   a0 00                                                  
          lda ($ae),y                   //&      a852   b1 ae                                                   
          clc                          //&      a854   18                                               
          adc $0e                      //&      a855   65 0e                                                
          cmp $0f                      //&      a857   c5 0f                                                
          bcc $a85e                    //&      a859   90 03                                                  
          jsr $a86c                    //&      a85b   20 6c a8                                               
la85e:
          jsr $a8c6                    //&      a85e   20 c6 a8                                               
          jsr $a8e0                    //&      a861   20 e0 a8                                               
          bne $a82c                    //&      a864   d0 c6                                                  
la866:
          ldy #$00                     //&      a866   a0 00                                                  
          sty $13,x                    //&      a868   94 13                                                  
          ldx #$12                     //&      a86a   a2 12                                                  
CRDO:
          lda #$0d                     //&      a86c   a9 0d                                                  
          sta $0e                      //&      a86e   85 0e                                                
          jsr $a8e5                    //&      a870   20 e5 a8                                               
          lda #$0a                     //&      a873   a9 0a                                                  
          jsr $a8e5                    //&      a875   20 e5 a8                                               
PRINTNULLS:
          txa                          //&      a878   8a                                               
          pha                          //&      a879   48                                               
          ldx $0d                      //&      a87a   a6 0d                                                
          beq $a886                    //&      a87c   f0 08                                                  
          lda #$00                     //&      a87e   a9 00                                                  
la880:
          jsr $a8e5                    //&      a880   20 e5 a8                                               
          dex                          //&      a883   ca                                               
          bne $a880                    //&      a884   d0 fa                                                  
la886:
          stx $0e                      //&      a886   86 0e                                                
          pla                          //&      a888   68                                               
          tax                          //&      a889   aa                                               
la88a:
          rts                          //&      a88a   60                                               
la88b:
          lda $0e                      //&      a88b   a5 0e                                                
          cmp $10                      //&      a88d   c5 10                                                
          bcc $a897                    //&      a88f   90 06                                                  
          jsr $a86c                    //&      a891   20 6c a8                                               
          jmp $a8bd                    //&      a894   4c bd a8                                               
la897:
          sec                          //&      a897   38                                               
la898:
          sbc #$0e                     //&      a898   e9 0e                                                  
          bcs $a898                    //&      a89a   b0 fc                                                  
          eor #$ff                     //&      a89c   49 ff                                                  
          adc #$01                     //&      a89e   69 01                                                  
          bne $a8b6                    //&      a8a0   d0 14                                                  
la8a2:
          pha                          //&      a8a2   48                                               
          jsr $b3ab                    //&      a8a3   20 ab b3                                               
          cmp #$29                     //&      a8a6   c9 29                                                  
          bne $a910                    //&      a8a8   d0 66                                                  
          pla                          //&      a8aa   68                                               
          cmp #$9c                     //&      a8ab   c9 9c                                                  
          bne $a8b7                    //&      a8ad   d0 08                                                  
          txa                          //&      a8af   8a                                               
          sbc $0e                      //&      a8b0   e5 0e                                                
          bcc $a8bd                    //&      a8b2   90 09                                                  
          beq $a8bd                    //&      a8b4   f0 07                                                  
la8b6:
          tax                          //&      a8b6   aa                                               
la8b7:
          jsr $a8e0                    //&      a8b7   20 e0 a8                                               
          dex                          //&      a8ba   ca                                               
          bne $a8b7                    //&      a8bb   d0 fa                                                  
la8bd:
          jsr $00bc                    //&      a8bd   20 bc 00                                               
          jmp $a831                    //&      a8c0   4c 31 a8                                               
// ----------------------------------------------------------------------------
// PRINT STRING AT (Y,A)
// ----------------------------------------------------------------------------
STROUT:
          jsr $b0ae                    //&      a8c3   20 ae b0                                               
// ----------------------------------------------------------------------------
// PRINT STRING AT (FACMO,FACLO)
// ----------------------------------------------------------------------------
STRPRT:
          jsr $b2b6                    //&      a8c6   20 b6 b2                                               
          tax                          //&      a8c9   aa                                               
          ldy #$00                     //&      a8ca   a0 00                                                  
          inx                          //&      a8cc   e8                                               
la8cd:
          dex                          //&      a8cd   ca                                               
          beq $a88a                    //&      a8ce   f0 ba                                                  
          lda ($71),y                   //&      a8d0   b1 71                                                   
          jsr $a8e5                    //&      a8d2   20 e5 a8                                               
          iny                          //&      a8d5   c8                                               
          cmp #$0d                     //&      a8d6   c9 0d                                                  
          bne $a8cd                    //&      a8d8   d0 f3                                                  
          jsr $a878                    //&      a8da   20 78 a8                                               
          jmp $a8cd                    //&      a8dd   4c cd a8                                               
// ----------------------------------------------------------------------------
OUTSP:
          lda #$20                     //&      a8e0   a9 20                                                  
          .byte $2c                    //&      a8e2   2c      
OUTQUES:          
          lda #$3f                     //&      a8e3   a9 3f                          
// ----------------------------------------------------------------------------
// PRINT CHAR FROM (A)
// ----------------------------------------------------------------------------
OUTDO:
          bit $64                      //&      a8e5   24 64                                                
          bmi $a901                    //&      a8e7   30 18                                                  
// Commodore forgot to remove this in CBM1
          pha                          //&      a8e9   48                                               
          cmp #$20                     //&      a8ea   c9 20                                                  
          bcc $a8f9                    //&      a8ec   90 0b                                                  
          lda $0e                      //&      a8ee   a5 0e                                                
          cmp $0f                      //&      a8f0   c5 0f                                                
          bne $a8f7                    //&      a8f2   d0 03                                                  
          jsr $a86c                    //&      a8f4   20 6c a8                                               
la8f7:
          inc $0e                      //&      a8f7   e6 0e                                                
la8f9:
// Commodore forgot to remove this in CBM1
          pla                          //&      a8f9   68                                               
          jsr $ffee                    //&      a8fa   20 ee ff                                               
          nop                          //&      a8fd   ea                                               
          nop                          //&      a8fe   ea                                               
          nop                          //&      a8ff   ea                                               
          nop                          //&      a900   ea                                               
la901:
          and #$ff                     //&      a901   29 ff                                                  
          rts                          //&      a903   60                                               
// ----------------------------------------------------------------------------
// ???
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// INPUT CONVERSION ERROR:  ILLEGAL CHARACTER
// IN NUMERIC FIELD.  MUST DISTINGUISH
// BETWEEN INPUT, READ, AND GET
// ----------------------------------------------------------------------------
INPUTERR:
          lda $62                      //&      a904   a5 62                                                
          beq $a913                    //&      a906   f0 0b                                                  
// without this, it treats GET errors
// like READ errors
          lda $8d                      //&      a908   a5 8d                                                
          ldy $8e                      //&      a90a   a4 8e                                                
          sta $87                      //&      a90c   85 87                                                
          sty $88                      //&      a90e   84 88                                                
SYNERR4:
          jmp $ac0c                    //&      a910   4c 0c ac                                               
RESPERR:
          lda #$2d                     //&      a913   a9 2d                                                  
          ldy #$aa                     //&      a915   a0 aa                                                  
          jsr $a8c3                    //&      a917   20 c3 a8                                               
          lda $8b                      //&      a91a   a5 8b                                                
          ldy $8c                      //&      a91c   a4 8c                                                
          sta.zp $c3                      //&      a91e   85 c3                                                
          sty.zp $c4                      //&      a920   84 c4                                                
          rts                          //&      a922   60                                               
// ----------------------------------------------------------------------------
// "GET" STATEMENT
// ----------------------------------------------------------------------------
GET:
// ----------------------------------------------------------------------------
// "INPUT#" STATEMENT
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// "INPUT" STATEMENT
// ----------------------------------------------------------------------------
INPUT:
          lsr $64                      //&      a923   46 64                                                
          cmp #$22                     //&      a925   c9 22                                                  
          bne $a934                    //&      a927   d0 0b                                                  
          jsr $abc1                    //&      a929   20 c1 ab                                               
          lda #$3b                     //&      a92c   a9 3b                                                  
          jsr $ac03                    //&      a92e   20 03 ac                                               
          jsr $a8c6                    //&      a931   20 c6 a8                                               
la934:
   jsr $afd4                    //&      a934   20 d4 af                                               
          lda #$2c                     //&      a937   a9 2c                                                  
          sta $12                      //&      a939   85 12                                                
          jsr $a946                    //&      a93b   20 46 a9                                               
          lda $13                      //&      a93e   a5 13                                                
          bne $a954                    //&      a940   d0 12                                                  
          clc                          //&      a942   18                                               
          jmp $a647                    //&      a943   4c 47 a6                                               
NXIN:
          jsr $a8e3                    //&      a946   20 e3 a8                                               
          jsr $a8e0                    //&      a949   20 e0 a8                                               
          jmp $a357                    //&      a94c   4c 57 a3                                               
// ----------------------------------------------------------------------------
// "GETC" STATEMENT
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// "READ" STATEMENT
// ----------------------------------------------------------------------------
READ:
          ldx $8f                      //&      a94f   a6 8f                                                
          ldy $90                      //&      a951   a4 90                                                
 // AppleSoft II, too // LDA #$98
          .byte $a9                    //&      a953   a9                                                 
L2ABE:
          tya                          //&      a954
// ----------------------------------------------------------------------------
// PROCESS INPUT LIST
//
// (Y,X) IS ADDRESS OF INPUT DATA STRING
// (A) = VALUE FOR INPUTFLG:  $00 FOR INPUT
// 				$40 FOR GET
//				$98 FOR READ
// ----------------------------------------------------------------------------
          sta.zp $62                    //&      a955   85 62                                                
          stx.zp $91                    //&      a957   86 91                                                
          sty.zp $92                    //&      a959   84 92                                                
PROCESS_INPUT_ITEM:
          jsr $ad0b                    //&      a95b   20 0b ad                                               
          sta $97                      //&      a95e   85 97                                                
          sty $98                      //&      a960   84 98                                                
          lda.zp $c3                      //&      a962   a5 c3                                                
          ldy.zp $c4                      //&      a964   a4 c4                                                
          sta $11                      //&      a966   85 11                                                
          sty $12                      //&      a968   84 12                                                
          ldx $91                      //&      a96a   a6 91                                                
          ldy $92                      //&      a96c   a4 92                                                
          stx.zp $c3                      //&      a96e   86 c3                                                
          sty.zp $c4                      //&      a970   84 c4                                                
          jsr $00c2                    //&      a972   20 c2 00                                               
          bne $a985                    //&      a975   d0 0e                                                  
          bit $62                      //&      a977   24 62                                                
// BUG: The beq/bne L2AF8 below is supposed
// to be always taken. For this to happen,
// the last load must be a 0 for beq
// and != 0 for bne. The original Microsoft
// code had ldx/ldy/bne here, which was only
// correct for a non-ZP INPUTBUFFER. Commodore
// fixed it in CBMBASIC V1 by swapping the
// ldx and the ldy. It was broken on KIM,
// but okay on APPLE and CBM2, because
// these used a non-ZP INPUTBUFFER.
// Microsoft fixed this somewhere after KIM
// and before MICROTAN, by using beq instead
// of bne in the ZP case.
          bmi $a9dd                    //&      a979   30 62                                                  
          jsr $a8e3                    //&      a97b   20 e3 a8                                               
          jsr $a946                    //&      a97e   20 46 a9                                               
          stx.zp $c3                      //&      a981   86 c3                                                
          sty.zp $c4                      //&      a983   84 c4                                                
// ----------------------------------------------------------------------------
INSTART:
          jsr $00bc                    //&      a985   20 bc 00                                               
          bit $5f                      //&      a988   24 5f                                                
          bpl $a9b0                    //&      a98a   10 24                                                  
          sta $5b                      //&      a98c   85 5b                                                
          cmp #$22                     //&      a98e   c9 22                                                  
          beq $a999                    //&      a990   f0 07                                                  
          lda #$3a                     //&      a992   a9 3a                                                  
          sta $5b                      //&      a994   85 5b                                                
          lda #$2c                     //&      a996   a9 2c                                                  
          clc                          //&      a998   18                                               
la999:
          sta $5c                      //&      a999   85 5c                                                
          lda.zp $c3                      //&      a99b   a5 c3                                                
          ldy.zp $c4                      //&      a99d   a4 c4                                                
          adc #$00                     //&      a99f   69 00                                                  
          bcc $a9a4                    //&      a9a1   90 01                                                  
          iny                          //&      a9a3   c8                                               
la9a4:
          jsr $b0b4                    //&      a9a4   20 b4 b0                                               
          jsr $b3f3                    //&      a9a7   20 f3 b3                                               
          jsr $a7d5                    //&      a9aa   20 d5 a7                                               
          jmp $a9b6                    //&      a9ad   4c b6 a9                                               
// ----------------------------------------------------------------------------

          jsr $b887                    //&      a9b0   20 87 b8                                               
          jsr $b774                    //&      a9b3   20 74 b7                                               
// ----------------------------------------------------------------------------
INPUT_MORE:
          jsr $00c2                    //&      a9b6   20 c2 00                                               
          beq $a9c2                    //&      a9b9   f0 07                                                  
          cmp #$2c                     //&      a9bb   c9 2c                                                  
          beq $a9c2                    //&      a9bd   f0 03                                                  
          jmp $a904                    //&      a9bf   4c 04 a9                                               
la9c2:
          lda.zp $c3                      //&      a9c2   a5 c3                                                
          ldy.zp $c4                      //&      a9c4   a4 c4                                                
          sta $91                      //&      a9c6   85 91                                                
          sty $92                      //&      a9c8   84 92                                                
          lda $11                      //&      a9ca   a5 11                                                
          ldy $12                      //&      a9cc   a4 12                                                
          sta.zp $c3                      //&      a9ce   85 c3                                                
          sty.zp $c4                      //&      a9d0   84 c4                                                
          jsr $00c2                    //&      a9d2   20 c2 00                                               
          beq $aa03                    //&      a9d5   f0 2c                                                  
          jsr $ac01                    //&      a9d7   20 01 ac                                               
          jmp $a95b                    //&      a9da   4c 5b a9                                               
// ----------------------------------------------------------------------------
FINDATA:
          jsr $a71a                    //&      a9dd   20 1a a7                                               
          iny                          //&      a9e0   c8                                               
          tax                          //&      a9e1   aa                                               
          bne $a9f6                    //&      a9e2   d0 12                                                  
          ldx #$06                     //&      a9e4   a2 06                                                  
          iny                          //&      a9e6   c8                                               
          lda ($c3),y                   //&      a9e7   b1 c3                                                   
          beq $aa54                    //&      a9e9   f0 69                                                  
          iny                          //&      a9eb   c8                                               
          lda ($c3),y                   //&      a9ec   b1 c3                                                   
          sta $8d                      //&      a9ee   85 8d                                                
          iny                          //&      a9f0   c8                                               
          lda ($c3),y                   //&      a9f1   b1 c3                                                   
          iny                          //&      a9f3   c8                                               
          sta $8e                      //&      a9f4   85 8e                                                
la9f6:
          lda ($c3),y                   //&      a9f6   b1 c3                                                   
          tax                          //&      a9f8   aa                                               
          jsr $a70f                    //&      a9f9   20 0f a7                                               
          cpx #$83                     //&      a9fc   e0 83                                                  
          bne $a9dd                    //&      a9fe   d0 dd                                                  
          jmp $a985                    //&      aa00   4c 85 a9                                               
// ---NO MORE INPUT REQUESTED------
INPDONE:
          lda $91                      //&      aa03   a5 91                                                
          ldy $92                      //&      aa05   a4 92                                                
          ldx $62                      //&      aa07   a6 62                                                
          beq $aa0e                    //&      aa09   f0 03                                                  
          jmp $a624                    //&      aa0b   4c 24 a6                                               
laa0e:
          ldy #$00                     //&      aa0e   a0 00                                                  
          lda ($91),y                   //&      aa10   b1 91                                                   
          beq $aa1b                    //&      aa12   f0 07                                                  
          lda #$1c                     //&      aa14   a9 1c                                                  
          ldy #$aa                     //&      aa16   a0 aa                                                  
          jmp $a8c3                    //&      aa18   4c c3 a8                                               
laa1b:
          rts                          //&      aa1b   60                                               
// ----------------------------------------------------------------------------
ERREXTRA:
          .byte $3f                    //&      aa1c   3f         %00111111 '?'                                                     
          eor $58                      //&      aa1d   45 58                                                
          .byte $54                    //&      aa1f   54         %01010100 'T'                                                     
          .byte $52                    //&      aa20   52         %01010010 'R'                                                     
          eor ($20,x)                   //&      aa21   41 20                                                   
          eor #$47                     //&      aa23   49 47                                                  
          lsr $524f                    //&      aa25   4e 4f 52                                               
          eor $44                      //&      aa28   45 44                                                
          ora.abs $000a                    //&      aa2a   0d 0a 00 
ERRREENTRY:                                                        
          .byte $3f                    //&      aa2d   3f         %00111111 '?'                                                     
          .byte $52                    //&      aa2e   52         %01010010 'R'                                                     
          eor $44                      //&      aa2f   45 44                                                
          .byte $4f                    //&      aa31   4f         %01001111 'O'                                                     
          jsr $5246                    //&      aa32   20 46 52                                               
          .byte $4f                    //&      aa35   4f         %01001111 'O'                                                     
          eor $5320                    //&      aa36   4d 20 53                                               
          .byte $54                    //&      aa39   54         %01010100 'T'                                                     
          eor ($52,x)                   //&      aa3a   41 52                                                   
          .byte $54                    //&      aa3c   54         %01010100 'T'                                                     
          ora.abs $000a                    //&      aa3d   0d 0a 00                                               
          
 // ----------------------------------------------------------------------------
// "NEXT" STATEMENT
// ----------------------------------------------------------------------------
NEXT:          
          bne $aa46                    //&      aa40   d0 04                                                  
          ldy #$00                     //&      aa42   a0 00                                                  
          beq $aa49                    //&      aa44   f0 03                                                  
NEXT1:
          jsr $ad0b                    //&      aa46   20 0b ad                                               
NEXT2:
          sta $97                      //&      aa49   85 97                                                
          sty $98                      //&      aa4b   84 98                                                
          jsr $a1a1                    //&      aa4d   20 a1 a1                                               
          beq $aa56                    //&      aa50   f0 04                                                  
          ldx #$00                     //&      aa52   a2 00                                                  
GERR:
          beq $aabe                    //&      aa54   f0 68                                                  
NEXT3:
          txs                          //&      aa56   9a                                               
          inx                          //&      aa57   e8                                               
          inx                          //&      aa58   e8                                               
          inx                          //&      aa59   e8                                               
          inx                          //&      aa5a   e8                                               
          txa                          //&      aa5b   8a                                               
          inx                          //&      aa5c   e8                                               
          inx                          //&      aa5d   e8                                               
          inx                          //&      aa5e   e8                                               
          inx                          //&      aa5f   e8                                               
          inx                          //&      aa60   e8                                               
          stx $73                      //&      aa61   86 73                                                
          ldy #$01                     //&      aa63   a0 01                                                  
          jsr $b74b                    //&      aa65   20 4b b7                                               
          tsx                          //&      aa68   ba                                               
          lda $0108,x                   //&      aa69   bd 08 01                                                 
          sta $b0                      //&      aa6c   85 b0                                                
          lda $97                      //&      aa6e   a5 97                                                
          ldy $98                      //&      aa70   a4 98                                                
          jsr $b46c                    //&      aa72   20 6c b4                                               
          jsr $b774                    //&      aa75   20 74 b7                                               
          ldy #$01                     //&      aa78   a0 01                                                  
          jsr $b7fa                    //&      aa7a   20 fa b7                                               
          tsx                          //&      aa7d   ba                                               
          sec                          //&      aa7e   38                                               
          sbc $0108,x                   //&      aa7f   fd 08 01                                                 
          beq $aa9b                    //&      aa82   f0 17                                                  
          lda $010d,x                   //&      aa84   bd 0d 01                                                 
          sta $87                      //&      aa87   85 87                                                
          lda $010e,x                   //&      aa89   bd 0e 01                                                 
          sta $88                      //&      aa8c   85 88                                                
          lda $0110,x                   //&      aa8e   bd 10 01                                                 
          sta.zp $c3                      //&      aa91   85 c3                                                
          lda $010f,x                   //&      aa93   bd 0f 01                                                 
          sta.zp $c4                      //&      aa96   85 c4                                                
laa98:
          jmp $a5c2                    //&      aa98   4c c2 a5                                               
laa9b:
          txa                          //&      aa9b   8a                                               
          adc #$0f                     //&      aa9c   69 0f                                                  
          tax                          //&      aa9e   aa                                               
          txs                          //&      aa9f   9a                                               
          jsr $00c2                    //&      aaa0   20 c2 00                                               
          cmp #$2c                     //&      aaa3   c9 2c                                                  
          bne $aa98                    //&      aaa5   d0 f1                                                  
          jsr $00bc                    //&      aaa7   20 bc 00                                               
          jsr $aa46                    //&      aaaa   20 46 aa                                               
// ----------------------------------------------------------------------------
// EVALUATE EXPRESSION, MAKE SURE IT IS NUMERIC
// ----------------------------------------------------------------------------
FRMNUM:
          jsr $aac1                    //&      aaad   20 c1 aa                                               
// ----------------------------------------------------------------------------
// MAKE SURE (FAC) IS NUMERIC
// ----------------------------------------------------------------------------
CHKNUM:
          clc                          //&      aab0   18                                               
          .byte $24                    //&      aab1   24
// ----------------------------------------------------------------------------
// MAKE SURE (FAC) IS STRING
// ----------------------------------------------------------------------------
CHKSTR:
          sec                          //&      aab2   38  
// ----------------------------------------------------------------------------
// MAKE SURE (FAC) IS CORRECT TYPE
// IF C=0, TYPE MUST BE NUMERIC
// IF C=1, TYPE MUST BE STRING
// ----------------------------------------------------------------------------
CHKVAL:
          bit $5f                      //&      aab3   24 5f                                                
          bmi $aaba                    //&      aab5   30 03                                                  
          bcs $aabc                    //&      aab7   b0 03                                                  
laab9:
          rts                          //&      aab9   60                                               
laaba:
          bcs $aab9                    //&      aaba   b0 fd                                                  
laabc:
          ldx #$18                     //&      aabc   a2 18                                                  
JERROR:
          jmp $a24e                    //&      aabe   4c 4e a2                                               
// ----------------------------------------------------------------------------
// EVALUATE THE EXPRESSION AT TXTPTR, LEAVING THE
// RESULT IN FAC.  WORKS FOR BOTH STRING AND NUMERIC
// EXPRESSIONS.
// ----------------------------------------------------------------------------
FRMEVL:
          ldx.zp $c3                    //&      aac1   a6 c3                                                
          bne $aac7                    //&      aac3   d0 02                                                  
          dec.zp $c4                    //&      aac5   c6 c4                                                
laac7:
          dec.zp $c3                    //&      aac7   c6 c3                                                
          ldx #$00                     //&      aac9   a2 00                                                  
          .byte $24                    //&      aacb   24 48                                                
FRMEVL1:
          pha                          //&      aacc   48                                                
          txa                          //&      aacd   8a                                               
          pha                          //&      aace   48                                               
          lda #$01                     //&      aacf   a9 01                                                  
          jsr $a212                    //&      aad1   20 12 a2                                               
          jsr $aba0                    //&      aad4   20 a0 ab                                               
          lda #$00                     //&      aad7   a9 00                                                  
          sta $9b                      //&      aad9   85 9b                                                
FRMEVL2:
          jsr $00c2                    //&      aadb   20 c2 00                                               
laade:
          sec                          //&      aade   38                                               
          sbc #$aa                     //&      aadf   e9 aa                                                  
          bcc $aafa                    //&      aae1   90 17                                                  
          cmp #$03                     //&      aae3   c9 03                                                  
          bcs $aafa                    //&      aae5   b0 13                                                  
          cmp #$01                     //&      aae7   c9 01                                                  
          rol                          //&      aae9   2a                                                 
          eor #$01                     //&      aaea   49 01                                                  
          eor $9b                      //&      aaec   45 9b                                                
          cmp $9b                      //&      aaee   c5 9b                                                
          bcc $ab53                    //&      aaf0   90 61                                                  
          sta $9b                      //&      aaf2   85 9b                                                
          jsr $00bc                    //&      aaf4   20 bc 00                                               
          jmp $aade                    //&      aaf7   4c de aa                                               
laafa:
          ldx $9b                      //&      aafa   a6 9b                                                
          bne $ab2a                    //&      aafc   d0 2c                                                  
          bcs $ab78                    //&      aafe   b0 78                                                  
          adc #$07                     //&      ab00   69 07                                                  
          bcc $ab78                    //&      ab02   90 74                                                  
          adc $5f                      //&      ab04   65 5f                                                
          bne $ab0b                    //&      ab06   d0 03                                                  
          jmp $b24d                    //&      ab08   4c 4d b2                                               
lab0b:
          adc #$ff                     //&      ab0b   69 ff                                                  
          sta $71                      //&      ab0d   85 71                                                
          asl                          //&      ab0f   0a                                                 
          adc $71                      //&      ab10   65 71                                                
          tay                          //&      ab12   a8                                               
FRM_PRECEDENCE_TEST:
          pla                          //&      ab13   68                                               
          cmp $a066,y                   //&      ab14   d9 66 a0                                                 
          bcs $ab7d                    //&      ab17   b0 64                                                  
          jsr $aab0                    //&      ab19   20 b0 aa                                               
lab1c:
          pha                          //&      ab1c   48                                               
lab1d:
          jsr $ab43                    //&      ab1d   20 43 ab                                               
          pla                          //&      ab20   68                                               
          ldy $99                      //&      ab21   a4 99                                                
          bpl $ab3c                    //&      ab23   10 17                                                  
          tax                          //&      ab25   aa                                               
          beq $ab7b                    //&      ab26   f0 53                                                  
          bne $ab86                    //&      ab28   d0 5c                                                  
// ----------------------------------------------------------------------------
// FOUND ONE OR MORE RELATIONAL OPERATORS <,=,>
// ----------------------------------------------------------------------------
FRM_RELATIONAL:
          lsr $5f                      //&      ab2a   46 5f                                                
          txa                          //&      ab2c   8a                                               
          rol                          //&      ab2d   2a                                                 
          ldx.zp $c3                      //&      ab2e   a6 c3                                                
          bne $ab34                    //&      ab30   d0 02                                                  
          dec.zp $c4                      //&      ab32   c6 c4                                                
lab34:
   dec.zp $c3                      //&      ab34   c6 c3                                                
          ldy #$1b                     //&      ab36   a0 1b                                                  
          sta $9b                      //&      ab38   85 9b                                                
          bne $ab13                    //&      ab3a   d0 d7                                                  
PREFNC:
   cmp $a066,y                   //&      ab3c   d9 66 a0                                                 
          bcs $ab86                    //&      ab3f   b0 45                                                  
          bcc $ab1c                    //&      ab41   90 d9                                                  
// ----------------------------------------------------------------------------
// STACK THIS OPERATION AND CALL FRMEVL FOR
// ANOTHER ONE
// ----------------------------------------------------------------------------
FRM_RECURSE:
          lda $a068,y                   //&      ab43   b9 68 a0                                                 
          pha                          //&      ab46   48                                               
          lda $a067,y                   //&      ab47   b9 67 a0                                                 
          pha                          //&      ab4a   48                                               
          jsr $ab56                    //&      ab4b   20 56 ab                                               
          lda $9b                      //&      ab4e   a5 9b                                                
          jmp $aacc                    //&      ab50   4c cc aa                                               
SNTXERR:
   jmp $ac0c                    //&      ab53   4c 0c ac                                               
// ----------------------------------------------------------------------------
// STACK (FAC)
// THREE ENTRY POINTS:
// 	1, FROM FRMEVL
//	2, FROM "STEP"
//	3, FROM "FOR"
// ----------------------------------------------------------------------------
FRM_STACK1:
          lda $b0                      //&      ab56   a5 b0                                                
          ldx $a066,y                   //&      ab58   be 66 a0                                                 
// ----------------------------------------------------------------------------
// ENTER HERE FROM "STEP", TO PUSH STEP SIGN AND VALUE
// ----------------------------------------------------------------------------
FRM_STACK2:
          tay                          //&      ab5b   a8                                               
          pla                          //&      ab5c   68                                               
          sta $71                      //&      ab5d   85 71     
          inc $71                      //&      ab5f   e6 71    // bug: assumes not on page boundary                                                
// bug exists on AppleSoft II
          pla                          //&      ab61   68                                               
          sta $72                      //&      ab62   85 72                                                
          tya                          //&      ab64   98                                               
          pha                          //&      ab65   48                                               
// ----------------------------------------------------------------------------
// ENTER HERE FROM "FOR", WITH (INDEX) = STEP,
// TO PUSH INITIAL VALUE OF "FOR" VARIABLE
// ----------------------------------------------------------------------------
FRM_STACK3:
          jsr $b7ba                    //&      ab66   20 ba b7                                               
          lda $af                      //&      ab69   a5 af                                                
          pha                          //&      ab6b   48                                               
          lda $ae                      //&      ab6c   a5 ae                                                
          pha                          //&      ab6e   48                                               
          lda $ad                      //&      ab6f   a5 ad                                                
          pha                          //&      ab71   48                                               
          lda $ac                      //&      ab72   a5 ac                                                
          pha                          //&      ab74   48                                               
          jmp ($0071)                   //&      ab75   6c 71 00                                                 
lab78:
          ldy #$ff                     //&      ab78   a0 ff                                                  
          pla                          //&      ab7a   68                                               
GOEX:
          beq $ab9d                    //&      ab7b   f0 20                                                  
// ----------------------------------------------------------------------------
// PERFORM STACKED OPERATION
//
// (A) = PRECEDENCE BYTE
// STACK:  1 -- CPRMASK
//	5 -- (ARG)
//	2 -- ADDR OF PERFORMER
// ----------------------------------------------------------------------------
FRM_PERFORM1:
          cmp #$64                     //&      ab7d   c9 64                                                  
          beq $ab84                    //&      ab7f   f0 03                                                  
          jsr $aab0                    //&      ab81   20 b0 aa                                               
lab84:
          sty $99                      //&      ab84   84 99                                                
FRM_PERFORM2:
          pla                          //&      ab86   68                                               
          lsr                          //&      ab87   4a                                                 
          sta $63                      //&      ab88   85 63                                                
          pla                          //&      ab8a   68                                               
          sta $b3                      //&      ab8b   85 b3                                                
          pla                          //&      ab8d   68                                               
          sta $b4                      //&      ab8e   85 b4                                                
          pla                          //&      ab90   68                                               
          sta $b5                      //&      ab91   85 b5                                                
          pla                          //&      ab93   68                                               
          sta $b6                      //&      ab94   85 b6                                                
          pla                          //&      ab96   68                                               
          sta $b7                      //&      ab97   85 b7                                                
          eor $b0                      //&      ab99   45 b0                                                
          sta $b8                      //&      ab9b   85 b8                                                
EXIT:
          lda $ac                      //&      ab9d   a5 ac                                                
          rts                          //&      ab9f   60                                               
// ----------------------------------------------------------------------------
// GET ELEMENT IN EXPRESSION
//
// GET VALUE OF VARIABLE OR NUMBER AT TXTPNT, OR POINT
// TO STRING DESCRIPTOR IF A STRING, AND PUT IN FAC.
// ----------------------------------------------------------------------------
FRM_ELEMENT:
          lda #$00                     //&      aba0   a9 00                                                  
          sta $5f                      //&      aba2   85 5f                                                
laba4:
          jsr $00bc                    //&      aba4   20 bc 00                                               
          bcs $abac                    //&      aba7   b0 03                                                  
laba9:
          jmp $b887                    //&      aba9   4c 87 b8                                               
labac:
          jsr $ad81                    //&      abac   20 81 ad                                               
          bcs $ac18                    //&      abaf   b0 67                                                  
CON_PI:
          cmp #$2e                     //&      abb1   c9 2e                                                  
          beq $aba9                    //&      abb3   f0 f4                                                  
          cmp #$a4                     //&      abb5   c9 a4                                                  
          beq $ac11                    //&      abb7   f0 58                                                  
          cmp #$a3                     //&      abb9   c9 a3                                                  
          beq $aba4                    //&      abbb   f0 e7                                                  
          cmp #$22                     //&      abbd   c9 22                                                  
          bne $abd0                    //&      abbf   d0 0f                                                  
// ----------------------------------------------------------------------------
// STRING CONSTANT ELEMENT
//
// SET Y,A = (TXTPTR)+CARRY
// ----------------------------------------------------------------------------
STRTXT:
          lda.zp $c3                      //&      abc1   a5 c3                                                
          ldy.zp $c4                      //&      abc3   a4 c4                                                
          adc #$00                     //&      abc5   69 00                                                  
          bcc $abca                    //&      abc7   90 01                                                  
          iny                          //&      abc9   c8                                               
labca:
          jsr $b0ae                    //&      abca   20 ae b0                                               
          jmp $b3f3                    //&      abcd   4c f3 b3                                               
// ----------------------------------------------------------------------------
// "NOT" FUNCTION
// IF FAC=0, RETURN FAC=1
// IF FAC<>0, RETURN FAC=0
// ----------------------------------------------------------------------------
NOT_:
          cmp #$a1                     //&      abd0   c9 a1                                                  
          bne $abe7                    //&      abd2   d0 13                                                  
          ldy #$18                     //&      abd4   a0 18                                                  
          bne $ac13                    //&      abd6   d0 3b                                                  
// ----------------------------------------------------------------------------
// COMPARISON FOR EQUALITY (= OPERATOR)
// ALSO USED TO EVALUATE "NOT" FUNCTION
// ----------------------------------------------------------------------------
EQUOP:
          jsr $ae05                    //&      abd8   20 05 ae                                               
          lda $af                      //&      abdb   a5 af                                                
          eor #$ff                     //&      abdd   49 ff                                                  
          tay                          //&      abdf   a8                                               
          lda $ae                      //&      abe0   a5 ae                                                
          eor #$ff                     //&      abe2   49 ff                                                  
          jmp $afc1                    //&      abe4   4c c1 af                                               
labe7:
          cmp #$9e                     //&      abe7   c9 9e                                                  
          bne $abee                    //&      abe9   d0 03                                                  
          jmp $b01e                    //&      abeb   4c 1e b0                                               
labee:
          cmp #$ad                     //&      abee   c9 ad                                                  
          bcc $abf5                    //&      abf0   90 03                                                  
          jmp $ac27                    //&      abf2   4c 27 ac                                               
// ----------------------------------------------------------------------------
// EVALUATE "(EXPRESSION)"
// ----------------------------------------------------------------------------
PARCHK:
          jsr $abfe                    //&      abf5   20 fe ab                                               
          jsr $aac1                    //&      abf8   20 c1 aa                                               
CHKCLS:
          lda #$29                     //&      abfb   a9 29                                                  
          .byte $2c                    //&      abfd   2c
CHKOPN:    
          lda #$28                     //&      abfe   a9 28
          .byte $2c                    //&      ac00   2c
CHKCOM:
          lda #$2c                     //&      ac01   a9 2c                                                                                         ldy #$00                     //&      ac03   a0 00                                                  
// ----------------------------------------------------------------------------
// UNLESS CHAR AT TXTPTR = (A), SYNTAX ERROR
// ----------------------------------------------------------------------------
SYNCHR:	// XXX all CBM code calls SYNCHR instead of CHKCOM
          ldy #$00                     //&      ac03   a0 00
          cmp ($c3),y                   //&      ac05   d1 c3                                                   
          bne $ac0c                    //&      ac07   d0 03                                                  
          jmp $00bc                    //&      ac09   4c bc 00                                               
// ----------------------------------------------------------------------------
SYNERR:
          ldx #$02                     //&      ac0c   a2 02                                                  
          jmp $a24e                    //&      ac0e   4c 4e a2                                               
// ----------------------------------------------------------------------------
MIN:
          ldy #$15                     //&      ac11   a0 15                                                  
EQUL:
          pla                          //&      ac13   68                                               
          pla                          //&      ac14   68                                               
          jmp $ab1d                    //&      ac15   4c 1d ab                                               
// ----------------------------------------------------------------------------
FRM_VARIABLE:
          jsr $ad0b                    //&      ac18   20 0b ad                                               
.label FRM_VARIABLE_CALL	= *-1
          sta $ae                      //&      ac1b   85 ae                                                
          sty $af                      //&      ac1d   84 af                                                
          ldx $5f                      //&      ac1f   a6 5f                                                
          beq $ac24                    //&      ac21   f0 01                                                  
// bugfix?
// fixed on AppleSoft II, not on any CBM
          rts                          //&      ac23   60                                               
lac24:
          jmp $b74b                    //&      ac24   4c 4b b7                                               
// ----------------------------------------------------------------------------
UNARY:
          asl                          //&      ac27   0a                                                 
          pha                          //&      ac28   48                                               
          tax                          //&      ac29   aa                                               
          jsr $00bc                    //&      ac2a   20 bc 00                                               
          cpx #$81                     //&      ac2d   e0 81                                                  
          bcc $ac51                    //&      ac2f   90 20                                                  
          jsr $abfe                    //&      ac31   20 fe ab                                               
          jsr $aac1                    //&      ac34   20 c1 aa                                               
          jsr $ac01                    //&      ac37   20 01 ac                                               
          jsr $aab2                    //&      ac3a   20 b2 aa                                               
          pla                          //&      ac3d   68                                               
          tax                          //&      ac3e   aa                                               
          lda $af                      //&      ac3f   a5 af                                                
          pha                          //&      ac41   48                                               
          lda $ae                      //&      ac42   a5 ae                                                
          pha                          //&      ac44   48                                               
          txa                          //&      ac45   8a                                               
          pha                          //&      ac46   48                                               
          jsr $b3ae                    //&      ac47   20 ae b3                                               
          pla                          //&      ac4a   68                                               
          tay                          //&      ac4b   a8                                               
          txa                          //&      ac4c   8a                                               
          pha                          //&      ac4d   48                                               
          jmp $ac56                    //&      ac4e   4c 56 ac                                               
lac51:
          jsr $abf5                    //&      ac51   20 f5 ab                                               
          pla                          //&      ac54   68                                               
          tay                          //&      ac55   a8                                               
lac56:
          lda $9fde,y                   //&      ac56   b9 de 9f                                                 
          sta $a2                      //&      ac59   85 a2                                                
          lda $9fdf,y                   //&      ac5b   b9 df 9f                                                 
          sta $a3                      //&      ac5e   85 a3                                                
          jsr $00a1                    //&      ac60   20 a1 00                                               
          jmp $aab0                    //&      ac63   4c b0 aa                                               
// ----------------------------------------------------------------------------
OR:
          ldy #$ff                     //&      ac66   a0 ff                                                  
          .byte $2c                    //&      ac68   2c
// ----------------------------------------------------------------------------
TAND:
          ldy #$00                     //&      ac69   a0 00
          sty $5d                      //&      ac6b   84 5d                                                
          jsr $ae05                    //&      ac6d   20 05 ae                                               
          lda $ae                      //&      ac70   a5 ae                                                
          eor $5d                      //&      ac72   45 5d                                                
          sta $5b                      //&      ac74   85 5b                                                
          lda $af                      //&      ac76   a5 af                                                
          eor $5d                      //&      ac78   45 5d                                                
          sta $5c                      //&      ac7a   85 5c                                                
          jsr $b79b                    //&      ac7c   20 9b b7                                               
          jsr $ae05                    //&      ac7f   20 05 ae                                               
          lda $af                      //&      ac82   a5 af                                                
          eor $5d                      //&      ac84   45 5d                                                
          and $5c                      //&      ac86   25 5c                                                
          eor $5d                      //&      ac88   45 5d                                                
          tay                          //&      ac8a   a8                                               
          lda $ae                      //&      ac8b   a5 ae                                                
          eor $5d                      //&      ac8d   45 5d                                                
          and $5b                      //&      ac8f   25 5b                                                
          eor $5d                      //&      ac91   45 5d                                                
          jmp $afc1                    //&      ac93   4c c1 af                                               
// ----------------------------------------------------------------------------
// PERFORM RELATIONAL OPERATIONS
// ----------------------------------------------------------------------------
RELOPS:
          jsr $aab3                    //&      ac96   20 b3 aa                                               
          bcs $acae                    //&      ac99   b0 13                                                  
          lda $b7                      //&      ac9b   a5 b7                                                
          ora #$7f                     //&      ac9d   09 7f                                                  
          and $b4                      //&      ac9f   25 b4                                                
          sta $b4                      //&      aca1   85 b4                                                
          lda #$b3                     //&      aca3   a9 b3                                                  
          ldy #$00                     //&      aca5   a0 00                                                  
          jsr $b7f8                    //&      aca7   20 f8 b7                                               
          tax                          //&      acaa   aa                                               
          jmp $ace1                    //&      acab   4c e1 ac                                               
// ----------------------------------------------------------------------------
// STRING COMPARISON
// ----------------------------------------------------------------------------
STRCMP:
          lda #$00                     //&      acae   a9 00                                                  
          sta $5f                      //&      acb0   85 5f                                                
          dec $9b                      //&      acb2   c6 9b                                                
          jsr $b2b6                    //&      acb4   20 b6 b2                                               
          sta $ac                      //&      acb7   85 ac                                                
          stx $ad                      //&      acb9   86 ad                                                
          sty $ae                      //&      acbb   84 ae                                                
          lda $b5                      //&      acbd   a5 b5                                                
          ldy $b6                      //&      acbf   a4 b6                                                
          jsr $b2ba                    //&      acc1   20 ba b2                                               
          stx $b5                      //&      acc4   86 b5                                                
          sty $b6                      //&      acc6   84 b6                                                
          tax                          //&      acc8   aa                                               
          sec                          //&      acc9   38                                               
          sbc $ac                      //&      acca   e5 ac                                                
          beq $acd6                    //&      accc   f0 08                                                  
          lda #$01                     //&      acce   a9 01                                                  
          bcc $acd6                    //&      acd0   90 04                                                  
          ldx $ac                      //&      acd2   a6 ac                                                
          lda #$ff                     //&      acd4   a9 ff                                                  
lacd6:
          sta $b0                      //&      acd6   85 b0                                                
          ldy #$ff                     //&      acd8   a0 ff                                                  
          inx                          //&      acda   e8                                               
STRCMP1:
          iny                          //&      acdb   c8                                               
          dex                          //&      acdc   ca                                               
          bne $ace6                    //&      acdd   d0 07                                                  
          ldx $b0                      //&      acdf   a6 b0                                                
NUMCMP:
          bmi $acf2                    //&      ace1   30 0f                                                  
          clc                          //&      ace3   18                                               
          bcc $acf2                    //&      ace4   90 0c                                                  
lace6:
          lda ($b5),y                   //&      ace6   b1 b5                                                   
          cmp ($ad),y                   //&      ace8   d1 ad                                                   
          beq $acdb                    //&      acea   f0 ef                                                  
          ldx #$ff                     //&      acec   a2 ff                                                  
          bcs $acf2                    //&      acee   b0 02                                                  
          ldx #$01                     //&      acf0   a2 01                                                  
CMPDONE:
          inx                          //&      acf2   e8                                               
          txa                          //&      acf3   8a                                               
          rol                          //&      acf4   2a                                                 
          and $63                      //&      acf5   25 63                                                
          beq $acfb                    //&      acf7   f0 02                                                  
          lda #$ff                     //&      acf9   a9 ff                                                  
lacfb:
   jmp $b7db                    //&      acfb   4c db b7                                               
// ----------------------------------------------------------------------------
// "DIM" STATEMENT
// ----------------------------------------------------------------------------
NXDIM:
          jsr $ac01                    //&      acfe   20 01 ac                                               
DIM:
          tax                          //&      ad01   aa                                               
          jsr $ad10                    //&      ad02   20 10 ad                                               
          jsr $00c2                    //&      ad05   20 c2 00                                               
          bne $acfe                    //&      ad08   d0 f4                                                  
          rts                          //&      ad0a   60                                               
// ----------------------------------------------------------------------------
// PTRGET -- GENERAL VARIABLE SCAN
//
// SCANS VARIABLE NAME AT TXTPTR, AND SEARCHES THE
// VARTAB AND ARYTAB FOR THE NAME.
// IF NOT FOUND, CREATE VARIABLE OF APPROPRIATE TYPE.
// RETURN WITH ADDRESS IN VARPNT AND Y,A
//
// ACTUAL ACTIVITY CONTROLLED SOMEWHAT BY TWO FLAGS:
//	DIMFLG -- NONZERO IF CALLED FROM "DIM"
//		ELSE = 0
//
//	SUBFLG -- = $00
//		= $40 IF CALLED FROM "GETARYPT"
// ----------------------------------------------------------------------------
PTRGET:
          ldx #$00                     //&      ad0b   a2 00                                                  
          jsr $00c2                    //&      ad0d   20 c2 00                                               
PTRGET2:
            stx $5e                      //&      ad10   86 5e                                                
PTRGET3:
          sta $93                      //&      ad12   85 93                                                
          jsr $00c2                    //&      ad14   20 c2 00                                               
          jsr $ad81                    //&      ad17   20 81 ad                                               
          bcs $ad1f                    //&      ad1a   b0 03                                                  
          jmp $ac0c                    //&      ad1c   4c 0c ac                                               
NAMOK:
          ldx #$00                     //&      ad1f   a2 00                                                  
          stx $5f                      //&      ad21   86 5f                                                
          jsr $00bc                    //&      ad23   20 bc 00                                               
          bcc $ad2d                    //&      ad26   90 05                                                  
          jsr $ad81                    //&      ad28   20 81 ad                                               
          bcc $ad38                    //&      ad2b   90 0b                                                  
lad2d:
          tax                          //&      ad2d   aa                                               
lad2e:
          jsr $00bc                    //&      ad2e   20 bc 00                                               
          bcc $ad2e                    //&      ad31   90 fb                                                  
          jsr $ad81                    //&      ad33   20 81 ad                                               
          bcs $ad2e                    //&      ad36   b0 f6                                                  
lad38:
          cmp #$24                     //&      ad38   c9 24                                                  
          bne $ad47                    //&      ad3a   d0 0b                                                  
          lda #$ff                     //&      ad3c   a9 ff                                                  
          sta $5f                      //&      ad3e   85 5f                                                
          txa                          //&      ad40   8a                                               
          ora #$80                     //&      ad41   09 80                                                  
          tax                          //&      ad43   aa                                               
          jsr $00bc                    //&      ad44   20 bc 00                                               
lad47:
          stx $94                      //&      ad47   86 94                                                
          sec                          //&      ad49   38                                               
          ora $61                      //&      ad4a   05 61                                                
          sbc #$28                     //&      ad4c   e9 28                                                  
          bne $ad53                    //&      ad4e   d0 03                                                  
          jmp $ae17                    //&      ad50   4c 17 ae                                               
lad53:
          lda #$00                     //&      ad53   a9 00                                                  
          sta $61                      //&      ad55   85 61                                                
          lda $7b                      //&      ad57   a5 7b                                                
          ldx $7c                      //&      ad59   a6 7c                                                
          ldy #$00                     //&      ad5b   a0 00                                                  
lad5d:
          stx $ab                      //&      ad5d   86 ab                                                
lad5f:
          sta $aa                      //&      ad5f   85 aa                                                
          cpx $7e                      //&      ad61   e4 7e                                                
          bne $ad69                    //&      ad63   d0 04                                                  
          cmp $7d                      //&      ad65   c5 7d                                                
          beq $ad8b                    //&      ad67   f0 22                                                  
lad69:
          lda $93                      //&      ad69   a5 93                                                
          cmp ($aa),y                   //&      ad6b   d1 aa                                                   
          bne $ad77                    //&      ad6d   d0 08                                                  
          lda $94                      //&      ad6f   a5 94                                                
          iny                          //&      ad71   c8                                               
          cmp ($aa),y                   //&      ad72   d1 aa                                                   
          beq $add7                    //&      ad74   f0 61                                                  
          dey                          //&      ad76   88                                               
lad77:
          clc                          //&      ad77   18                                               
          lda $aa                      //&      ad78   a5 aa                                                
          adc #$06                     //&      ad7a   69 06                                                  
          bcc $ad5f                    //&      ad7c   90 e1                                                  
          inx                          //&      ad7e   e8                                               
          bne $ad5d                    //&      ad7f   d0 dc                                                  
// ----------------------------------------------------------------------------
// CHECK IF (A) IS ASCII LETTER A-Z
//
// RETURN CARRY = 1 IF A-Z
//	= 0 IF NOT
// ----------------------------------------------------------------------------
ISLETC:
          cmp #$41                     //&      ad81   c9 41                                                  
          bcc $ad8a                    //&      ad83   90 05                                                  
          sbc #$5b                     //&      ad85   e9 5b                                                  
          sec                          //&      ad87   38                                               
          sbc #$a5                     //&      ad88   e9 a5                                                  
lad8a:
   rts                          //&      ad8a   60                                               
// ----------------------------------------------------------------------------
// VARIABLE NOT FOUND, SO MAKE ONE
// ----------------------------------------------------------------------------
NAMENOTFOUND:
          pla                          //&      ad8b   68                                               
          pha                          //&      ad8c   48                                               
          cmp #$1a                     //&      ad8d   c9 1a                                                  
          bne $ad98                    //&      ad8f   d0 07                                                  
          lda #$96                     //&      ad91   a9 96                                                  
          ldy #$ad                     //&      ad93   a0 ad                                                  
          rts                          //&      ad95   60                                               
// ----------------------------------------------------------------------------
C_ZERO:
          brk                          //&      ad96   00                                               
          brk                          //&      ad97   00                                               
// ----------------------------------------------------------------------------
// MAKE A NEW SIMPLE VARIABLE
//
// MOVE ARRAYS UP 7 BYTES TO MAKE ROOM FOR NEW VARIABLE
// ENTER 7-BYTE VARIABLE DATA IN THE HOLE
// ----------------------------------------------------------------------------
MAKENEWVARIABLE:
          lda $7d                      //&      ad98   a5 7d                                                
          ldy $7e                      //&      ad9a   a4 7e                                                
          sta $aa                      //&      ad9c   85 aa                                                
          sty $ab                      //&      ad9e   84 ab                                                
          lda $7f                      //&      ada0   a5 7f                                                
          ldy $80                      //&      ada2   a4 80                                                
          sta $a6                      //&      ada4   85 a6                                                
          sty $a7                      //&      ada6   84 a7                                                
          clc                          //&      ada8   18                                               
          adc #$06                     //&      ada9   69 06                                                  
          bcc $adae                    //&      adab   90 01                                                  
          iny                          //&      adad   c8                                               
ladae:
          sta $a4                      //&      adae   85 a4                                                
          sty $a5                      //&      adb0   84 a5                                                
          jsr $a1cf                    //&      adb2   20 cf a1                                               
          lda $a4                      //&      adb5   a5 a4                                                
          ldy $a5                      //&      adb7   a4 a5                                                
          iny                          //&      adb9   c8                                               
          sta $7d                      //&      adba   85 7d                                                
          sty $7e                      //&      adbc   84 7e                                                
          ldy #$00                     //&      adbe   a0 00                                                  
          lda $93                      //&      adc0   a5 93                                                
          sta ($aa),y                   //&      adc2   91 aa                                                   
          iny                          //&      adc4   c8                                               
          lda $94                      //&      adc5   a5 94                                                
          sta ($aa),y                   //&      adc7   91 aa                                                   
          lda #$00                     //&      adc9   a9 00                                                  
          iny                          //&      adcb   c8                                               
          sta ($aa),y                   //&      adcc   91 aa                                                   
          iny                          //&      adce   c8                                               
          sta ($aa),y                   //&      adcf   91 aa                                                   
          iny                          //&      add1   c8                                               
          sta ($aa),y                   //&      add2   91 aa                                                   
          iny                          //&      add4   c8                                               
          sta ($aa),y                   //&      add5   91 aa                                                   
// ----------------------------------------------------------------------------
// PUT ADDRESS OF VALUE OF VARIABLE IN VARPNT AND Y,A
// ----------------------------------------------------------------------------
SET_VARPNT_AND_YA:
          lda $aa                      //&      add7   a5 aa                                                
          clc                          //&      add9   18                                               
          adc #$02                     //&      adda   69 02                                                  
          ldy $ab                      //&      addc   a4 ab                                                
          bcc $ade1                    //&      adde   90 01                                                  
          iny                          //&      ade0   c8                                               
lade1:
          sta $95                      //&      ade1   85 95                                                
          sty $96                      //&      ade3   84 96                                                
          rts                          //&      ade5   60                                               
// ----------------------------------------------------------------------------
// COMPUTE ADDRESS OF FIRST VALUE IN ARRAY
// ARYPNT = (LOWTR) + #DIMS*2 + 5
// ----------------------------------------------------------------------------
GETARY:
          lda $5d                      //&      ade6   a5 5d                                                
          asl                          //&      ade8   0a                                                 
          adc #$05                     //&      ade9   69 05                                                  
          adc $aa                      //&      adeb   65 aa                                                
          ldy $ab                      //&      aded   a4 ab                                                
          bcc $adf2                    //&      adef   90 01                                                  
          iny                          //&      adf1   c8                                               
ladf2:
          sta $a4                      //&      adf2   85 a4                                                
          sty $a5                      //&      adf4   84 a5                                                
          rts                          //&      adf6   60                                               
// ----------------------------------------------------------------------------
NEG32768:
          bcc $ad79                    //&      adf7   90 80                                                  
          brk                          //&      adf9   00                                               
          brk                          //&      adfa   00                                               
// ----------------------------------------------------------------------------
// EVALUATE NUMERIC FORMULA AT TXTPTR
// CONVERTING RESULT TO INTEGER 0 <= X <= 32767
// IN FAC+3,4
// ----------------------------------------------------------------------------
MAKINT:
          jsr $00bc                    //&      adfb   20 bc 00                                               
          jsr $aaad                    //&      adfe   20 ad aa       // ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// CONVERT FAC TO INTEGER
// MUST BE POSITIVE AND LESS THAN 32768
// ----------------------------------------------------------------------------
MKINT:
          lda $b0                      //&      ae01   a5 b0                                                
          bmi $ae12                    //&      ae03   30 0d                                                  
// ----------------------------------------------------------------------------
// CONVERT FAC TO INTEGER
// MUST BE -32767 <= FAC <= 32767
// ----------------------------------------------------------------------------
AYINT:
          lda $ac                      //&      ae05   a5 ac                                                
          cmp #$90                     //&      ae07   c9 90                                                  
          bcc $ae14                    //&      ae09   90 09                                                  
          lda #$f7                     //&      ae0b   a9 f7                                                  
          ldy #$ad                     //&      ae0d   a0 ad                                                  
          jsr $b7f8                    //&      ae0f   20 f8 b7                                               
MI1:
          bne $ae88                    //&      ae12   d0 74                                                  
MI2:
          jmp $b831                    //&      ae14   4c 31 b8                                               
// ----------------------------------------------------------------------------
// LOCATE ARRAY ELEMENT OR CREATE AN ARRAY
// ----------------------------------------------------------------------------
ARRAY:
          lda $5e                      //&      ae17   a5 5e                                                
          pha                          //&      ae19   48                                               
          lda $5f                      //&      ae1a   a5 5f                                                
          pha                          //&      ae1c   48                                               
          ldy #$00                     //&      ae1d   a0 00                                                  
lae1f:
          tya                          //&      ae1f   98                                               
          pha                          //&      ae20   48                                               
          lda $94                      //&      ae21   a5 94                                                
          pha                          //&      ae23   48                                               
          lda $93                      //&      ae24   a5 93                                                
          pha                          //&      ae26   48                                               
          jsr $adfb                    //&      ae27   20 fb ad                                               
          pla                          //&      ae2a   68                                               
          sta $93                      //&      ae2b   85 93                                                
          pla                          //&      ae2d   68                                               
          sta $94                      //&      ae2e   85 94                                                
          pla                          //&      ae30   68                                               
          tay                          //&      ae31   a8                                               
          tsx                          //&      ae32   ba                                               
          lda $0102,x                   //&      ae33   bd 02 01                                                 
          pha                          //&      ae36   48                                               
          lda $0101,x                   //&      ae37   bd 01 01                                                 
          pha                          //&      ae3a   48                                               
          lda $ae                      //&      ae3b   a5 ae                                                
          sta $0102,x                   //&      ae3d   9d 02 01                                                 
          lda $af                      //&      ae40   a5 af                                                
          sta $0101,x                   //&      ae42   9d 01 01                                                 
          iny                          //&      ae45   c8                                               
          jsr $00c2                    //&      ae46   20 c2 00                                               
          cmp #$2c                     //&      ae49   c9 2c                                                  
          beq $ae1f                    //&      ae4b   f0 d2                                                  
          sty $5d                      //&      ae4d   84 5d                                                
          jsr $abfb                    //&      ae4f   20 fb ab                                               
          pla                          //&      ae52   68                                               
          sta $5f                      //&      ae53   85 5f                                                
          pla                          //&      ae55   68                                               
// ----------------------------------------------------------------------------
// SEARCH ARRAY TABLE FOR THIS ARRAY NAME
// ----------------------------------------------------------------------------
          sta $5e                      //&      ae56   85 5e                                                
          ldx $7d                      //&      ae58   a6 7d                                                
          lda $7e                      //&      ae5a   a5 7e                                                
lae5c:
          stx $aa                      //&      ae5c   86 aa                                                
          sta $ab                      //&      ae5e   85 ab                                                
          cmp $80                      //&      ae60   c5 80                                                
          bne $ae68                    //&      ae62   d0 04                                                  
          cpx $7f                      //&      ae64   e4 7f                                                
          beq $aea1                    //&      ae66   f0 39                                                  
lae68:
          ldy #$00                     //&      ae68   a0 00                                                  
          lda ($aa),y                   //&      ae6a   b1 aa                                                   
          iny                          //&      ae6c   c8                                               
          cmp $93                      //&      ae6d   c5 93                                                
          bne $ae77                    //&      ae6f   d0 06                                                  
          lda $94                      //&      ae71   a5 94                                                
          cmp ($aa),y                   //&      ae73   d1 aa                                                   
          beq $ae8d                    //&      ae75   f0 16                                                  
lae77:
          iny                          //&      ae77   c8                                               
          lda ($aa),y                   //&      ae78   b1 aa                                                   
          clc                          //&      ae7a   18                                               
          adc $aa                      //&      ae7b   65 aa                                                
          tax                          //&      ae7d   aa                                               
          iny                          //&      ae7e   c8                                               
          lda ($aa),y                   //&      ae7f   b1 aa                                                   
          adc $ab                      //&      ae81   65 ab                                                
          bcc $ae5c                    //&      ae83   90 d7                                                  
// ----------------------------------------------------------------------------
// ERROR:  BAD SUBSCRIPTS
// ----------------------------------------------------------------------------
SUBERR:
          ldx #$10                     //&      ae85   a2 10                                                  
          .byte $2c                    //&      ae87   2c                                              
// ----------------------------------------------------------------------------
// ERROR:  ILLEGAL QUANTITY
// ----------------------------------------------------------------------------
IQERR:
          ldx #$08                     //&      ae88   a2 08
JER:
          jmp $a24e                    //&      ae8a   4c 4e a2                                               
// ----------------------------------------------------------------------------
// FOUND THE ARRAY
// ----------------------------------------------------------------------------
USE_OLD_ARRAY:
          ldx #$12                     //&      ae8d   a2 12                                                  
          lda $5e                      //&      ae8f   a5 5e                                                
          bne $ae8a                    //&      ae91   d0 f7                                                  
          jsr $ade6                    //&      ae93   20 e6 ad                                               
          lda $5d                      //&      ae96   a5 5d                                                
          ldy #$04                     //&      ae98   a0 04                                                  
          cmp ($aa),y                   //&      ae9a   d1 aa                                                   
          bne $ae85                    //&      ae9c   d0 e7                                                  
          jmp $af24                    //&      ae9e   4c 24 af                                               
// ----------------------------------------------------------------------------
// CREATE A NEW ARRAY, UNLESS CALLED FROM GETARYPT
// ----------------------------------------------------------------------------
MAKE_NEW_ARRAY:
          jsr $ade6                    //&      aea1   20 e6 ad                                               
          jsr $a21f                    //&      aea4   20 1f a2                                               
          lda #$00                     //&      aea7   a9 00                                                  
          tay                          //&      aea9   a8                                               
          sta $bb                      //&      aeaa   85 bb                                                
          ldx #$04                     //&      aeac   a2 04                                                  
          stx $ba                      //&      aeae   86 ba                                                
          lda $93                      //&      aeb0   a5 93                                                
          sta ($aa),y                   //&      aeb2   91 aa                                                   
          iny                          //&      aeb4   c8                                               
          lda $94                      //&      aeb5   a5 94                                                
          sta ($aa),y                   //&      aeb7   91 aa                                                   
          lda $5d                      //&      aeb9   a5 5d                                                
          iny                          //&      aebb   c8                                               
          iny                          //&      aebc   c8                                               
          iny                          //&      aebd   c8                                               
          sta ($aa),y                   //&      aebe   91 aa                                                   
laec0:
          ldx #$0b                     //&      aec0   a2 0b                                                  
          lda #$00                     //&      aec2   a9 00                                                  
          bit $5e                      //&      aec4   24 5e                                                
          bvc $aed0                    //&      aec6   50 08                                                  
          pla                          //&      aec8   68                                               
          clc                          //&      aec9   18                                               
          adc #$01                     //&      aeca   69 01                                                  
          tax                          //&      aecc   aa                                               
          pla                          //&      aecd   68                                               
          adc #$00                     //&      aece   69 00                                                  
laed0:
          iny                          //&      aed0   c8                                               
          sta ($aa),y                   //&      aed1   91 aa                                                   
          iny                          //&      aed3   c8                                               
          txa                          //&      aed4   8a                                               
          sta ($aa),y                   //&      aed5   91 aa                                                   
          jsr $af7c                    //&      aed7   20 7c af                                               
          stx $ba                      //&      aeda   86 ba                                                
          sta $bb                      //&      aedc   85 bb                                                
          ldy $71                      //&      aede   a4 71                                                
          dec $5d                      //&      aee0   c6 5d                                                
          bne $aec0                    //&      aee2   d0 dc                                                  
          adc $a5                      //&      aee4   65 a5                                                
          bcs $af45                    //&      aee6   b0 5d                                                  
          sta $a5                      //&      aee8   85 a5                                                
          tay                          //&      aeea   a8                                               
          txa                          //&      aeeb   8a                                               
          adc $a4                      //&      aeec   65 a4                                                
          bcc $aef3                    //&      aeee   90 03                                                  
          iny                          //&      aef0   c8                                               
          beq $af45                    //&      aef1   f0 52                                                  
laef3:
          jsr $a21f                    //&      aef3   20 1f a2                                               
          sta $7f                      //&      aef6   85 7f                                                
          sty $80                      //&      aef8   84 80                                                
          lda #$00                     //&      aefa   a9 00                                                  
          inc $bb                      //&      aefc   e6 bb                                                
          ldy $ba                      //&      aefe   a4 ba                                                
          beq $af07                    //&      af00   f0 05                                                  
laf02:
          dey                          //&      af02   88                                               
          sta ($a4),y                   //&      af03   91 a4                                                   
          bne $af02                    //&      af05   d0 fb                                                  
laf07:
          dec $a5                      //&      af07   c6 a5                                                
          dec $bb                      //&      af09   c6 bb                                                
          bne $af02                    //&      af0b   d0 f5                                                  
          inc $a5                      //&      af0d   e6 a5                                                
          sec                          //&      af0f   38                                               
          lda $7f                      //&      af10   a5 7f                                                
          sbc $aa                      //&      af12   e5 aa                                                
          ldy #$02                     //&      af14   a0 02                                                  
          sta ($aa),y                   //&      af16   91 aa                                                   
          lda $80                      //&      af18   a5 80                                                
          iny                          //&      af1a   c8                                               
          sbc $ab                      //&      af1b   e5 ab                                                
          sta ($aa),y                   //&      af1d   91 aa                                                   
          lda $5e                      //&      af1f   a5 5e                                                
          bne $af7b                    //&      af21   d0 58                                                  
          iny                          //&      af23   c8                                               
// ----------------------------------------------------------------------------
// FIND SPECIFIED ARRAY ELEMENT
//
// (LOWTR),Y POINTS AT # OF DIMS IN ARRAY DESCRIPTOR
// THE SUBSCRIPTS ARE ALL ON THE STACK AS INTEGERS
// ----------------------------------------------------------------------------
FIND_ARRAY_ELEMENT:
          lda ($aa),y                   //&      af24   b1 aa                                                   
          sta $5d                      //&      af26   85 5d                                                
          lda #$00                     //&      af28   a9 00                                                  
          sta $ba                      //&      af2a   85 ba                                                
laf2c:
          sta $bb                      //&      af2c   85 bb                                                
          iny                          //&      af2e   c8                                               
          pla                          //&      af2f   68                                               
          tax                          //&      af30   aa                                               
          sta $ae                      //&      af31   85 ae                                                
          pla                          //&      af33   68                                               
          sta $af                      //&      af34   85 af                                                
          cmp ($aa),y                   //&      af36   d1 aa                                                   
          bcc $af48                    //&      af38   90 0e                                                  
          bne $af42                    //&      af3a   d0 06                                                  
          iny                          //&      af3c   c8                                               
          txa                          //&      af3d   8a                                               
          cmp ($aa),y                   //&      af3e   d1 aa                                                   
          bcc $af49                    //&      af40   90 07                                                  
// ----------------------------------------------------------------------------
GSE:
          jmp $ae85                    //&      af42   4c 85 ae                                               
GME:
          jmp $a24c                    //&      af45   4c 4c a2                                               
// ----------------------------------------------------------------------------
FAE2:
          iny                          //&      af48   c8                                               
FAE3:
          lda $bb                      //&      af49   a5 bb                                                
          ora $ba                      //&      af4b   05 ba                                                
          clc                          //&      af4d   18                                               
          beq $af5a                    //&      af4e   f0 0a                                                  
          jsr $af7c                    //&      af50   20 7c af                                               
          txa                          //&      af53   8a                                               
          adc $ae                      //&      af54   65 ae                                                
          tax                          //&      af56   aa                                               
          tya                          //&      af57   98                                               
          ldy $71                      //&      af58   a4 71                                                
laf5a:
   adc $af                      //&      af5a   65 af                                                
          stx $ba                      //&      af5c   86 ba                                                
          dec $5d                      //&      af5e   c6 5d                                                
          bne $af2c                    //&      af60   d0 ca                                                  
          asl $ba                      //&      af62   06 ba                                                
          rol                          //&      af64   2a                                                 
          bcs $af42                    //&      af65   b0 db                                                  
          asl $ba                      //&      af67   06 ba                                                
          rol                          //&      af69   2a                                                 
          bcs $af42                    //&      af6a   b0 d6                                                  
          tay                          //&      af6c   a8                                               
          lda $ba                      //&      af6d   a5 ba                                                
          adc $a4                      //&      af6f   65 a4                                                
          sta $95                      //&      af71   85 95                                                
          tya                          //&      af73   98                                               
          adc $a5                      //&      af74   65 a5                                                
          sta $96                      //&      af76   85 96                                                
          tay                          //&      af78   a8                                               
          lda $95                      //&      af79   a5 95                                                
RTS9:
          rts                          //&      af7b   60                                               
// ----------------------------------------------------------------------------
// MULTIPLY (STRNG2) BY ((LOWTR),Y)
// LEAVING PRODUCT IN A,X.  (HI-BYTE ALSO IN Y.)
// USED ONLY BY ARRAY SUBSCRIPT ROUTINES
// ----------------------------------------------------------------------------
MULTIPLY_SUBSCRIPT:
          sty $71                      //&      af7c   84 71                                                
          lda ($aa),y                   //&      af7e   b1 aa                                                   
          sta $76                      //&      af80   85 76                                                
          dey                          //&      af82   88                                               
          lda ($aa),y                   //&      af83   b1 aa                                                   
          sta $77                      //&      af85   85 77                                                
          lda #$10                     //&      af87   a9 10                                                  
          sta $a8                      //&      af89   85 a8                                                
          ldx #$00                     //&      af8b   a2 00                                                  
          ldy #$00                     //&      af8d   a0 00                                                  
laf8f:
          txa                          //&      af8f   8a                                               
          asl                          //&      af90   0a                                                 
          tax                          //&      af91   aa                                               
          tya                          //&      af92   98                                               
          rol                          //&      af93   2a                                                 
          tay                          //&      af94   a8                                               
          bcs $af45                    //&      af95   b0 ae                                                  
          asl $ba                      //&      af97   06 ba                                                
          rol $bb                      //&      af99   26 bb                                                
          bcc $afa8                    //&      af9b   90 0b                                                  
          clc                          //&      af9d   18                                               
          txa                          //&      af9e   8a                                               
          adc $76                      //&      af9f   65 76                                                
          tax                          //&      afa1   aa                                               
          tya                          //&      afa2   98                                               
          adc $77                      //&      afa3   65 77                                                
          tay                          //&      afa5   a8                                               
          bcs $af45                    //&      afa6   b0 9d                                                  
lafa8:
          dec $a8                      //&      afa8   c6 a8                                                
          bne $af8f                    //&      afaa   d0 e3                                                  
          rts                          //&      afac   60                                               
// ----------------------------------------------------------------------------
// "FRE" FUNCTION
//
// COLLECTS GARBAGE AND RETURNS # BYTES OF MEMORY LEFT
// ----------------------------------------------------------------------------
FRE:
          lda $5f                      //&      afad   a5 5f                                                
          beq $afb4                    //&      afaf   f0 03                                                  
          jsr $b2b6                    //&      afb1   20 b6 b2                                               
lafb4:
          jsr $b147                    //&      afb4   20 47 b1                                               
          sec                          //&      afb7   38                                               
          lda $81                      //&      afb8   a5 81                                                
          sbc $7f                      //&      afba   e5 7f                                                
          tay                          //&      afbc   a8                                               
          lda $82                      //&      afbd   a5 82                                                
          sbc $80                      //&      afbf   e5 80                                                
// FALL INTO GIVAYF TO FLOAT THE VALUE
// NOTE THAT VALUES OVER 32767 WILL RETURN AS NEGATIVE
// ----------------------------------------------------------------------------
// FLOAT THE SIGNED INTEGER IN A,Y
// ----------------------------------------------------------------------------
GIVAYF:
          ldx #$00                     //&      afc1   a2 00                                                  
          stx $5f                      //&      afc3   86 5f                                                
          sta $ad                      //&      afc5   85 ad                                                
          sty $ae                      //&      afc7   84 ae                                                
          ldx #$90                     //&      afc9   a2 90                                                  
          jmp $b7e3                    //&      afcb   4c e3 b7                                               
POS:
          ldy $0e                      //&      afce   a4 0e                                                
// ----------------------------------------------------------------------------
// FLOAT (Y) INTO FAC, GIVING VALUE 0-255
// ----------------------------------------------------------------------------
SNGFLT:
          lda #$00                     //&      afd0   a9 00                                                  
          beq $afc1                    //&      afd2   f0 ed                                                  
// ----------------------------------------------------------------------------
// CHECK FOR DIRECT OR RUNNING MODE
// GIVING ERROR IF DIRECT MODE
// ----------------------------------------------------------------------------
ERRDIR:
          ldx $88                      //&      afd4   a6 88                                                
          inx                          //&      afd6   e8                                               
          bne $af7b                    //&      afd7   d0 a2                                                  
          ldx #$16                     //&      afd9   a2 16                                                  
lafdb:
          jmp $a24e                    //&      afdb   4c 4e a2                                               
DEF:
          jsr $b00b                    //&      afde   20 0b b0                                               
          jsr $afd4                    //&      afe1   20 d4 af                                               
          jsr $abfe                    //&      afe4   20 fe ab                                               
          lda #$80                     //&      afe7   a9 80                                                  
          sta $61                      //&      afe9   85 61                                                
          jsr $ad0b                    //&      afeb   20 0b ad                                               
          jsr $aab0                    //&      afee   20 b0 aa                                               
          jsr $abfb                    //&      aff1   20 fb ab                                               
          lda #$ab                     //&      aff4   a9 ab                                                  
          jsr $ac03                    //&      aff6   20 03 ac                                               
          lda $96                      //&      aff9   a5 96                                                
          pha                          //&      affb   48                                               
          lda $95                      //&      affc   a5 95                                                
          pha                          //&      affe   48                                               
          lda.zp $c4                   //&      afff   a5 c4                                                
          pha                          //&      b001   48                                               
          lda.zp $c3                   //&      b002   a5 c3                                                
          pha                          //&      b004   48                                               
          jsr $a70c                    //&      b005   20 0c a7                                               
          jmp $b07a                    //&      b008   4c 7a b0                                               
FNC:
          lda #$9e                     //&      b00b   a9 9e                                                  
          jsr $ac03                    //&      b00d   20 03 ac                                               
          ora #$80                     //&      b010   09 80                                                  
          sta $61                      //&      b012   85 61                                                
          jsr $ad12                    //&      b014   20 12 ad                                               
          sta $9c                      //&      b017   85 9c                                                
          sty $9d                      //&      b019   84 9d                                                
          jmp $aab0                    //&      b01b   4c b0 aa                                               
lb01e:
          jsr $b00b                    //&      b01e   20 0b b0                                               
          lda $9d                      //&      b021   a5 9d                                                
          pha                          //&      b023   48                                               
          lda $9c                      //&      b024   a5 9c                                                
          pha                          //&      b026   48                                               
          jsr $abf5                    //&      b027   20 f5 ab                                               
          jsr $aab0                    //&      b02a   20 b0 aa                                               
          pla                          //&      b02d   68                                               
          sta $9c                      //&      b02e   85 9c                                                
          pla                          //&      b030   68                                               
          sta $9d                      //&      b031   85 9d                                                
          ldy #$02                     //&      b033   a0 02                                                  
          ldx #$20                     //&      b035   a2 20                                                  
          lda ($9c),y                   //&      b037   b1 9c                                                   
          beq $afdb                    //&      b039   f0 a0                                                  
          sta $95                      //&      b03b   85 95                                                
          tax                          //&      b03d   aa                                               
          iny                          //&      b03e   c8                                               
          lda ($9c),y                   //&      b03f   b1 9c                                                   
          sta $96                      //&      b041   85 96                                                
lb043:
          lda ($95),y                   //&      b043   b1 95                                                   
          pha                          //&      b045   48                                               
          dey                          //&      b046   88                                               
          bpl $b043                    //&      b047   10 fa                                                  
          ldy $96                      //&      b049   a4 96                                                
          jsr STORE_FAC_AT_YX_ROUNDED                    //&      b04b   20 78 b7                                               
          lda.zp $c4                      //&      b04e   a5 c4                                                
          pha                          //&      b050   48                                               
          lda.zp $c3                      //&      b051   a5 c3                                                
          pha                          //&      b053   48                                               
          lda ($9c),y                   //&      b054   b1 9c                                                   
          sta.zp $c3                      //&      b056   85 c3                                                
          iny                          //&      b058   c8                                               
          lda ($9c),y                   //&      b059   b1 9c                                                   
          sta $c4                      //&      b05b   85 c4                                                
          lda $96                      //&      b05d   a5 96                                                
          pha                          //&      b05f   48                                               
          lda $95                      //&      b060   a5 95                                                
          pha                          //&      b062   48                                               
          jsr $aaad                    //&      b063   20 ad aa                                               
          pla                          //&      b066   68                                               
          sta $9c                      //&      b067   85 9c                                                
          pla                          //&      b069   68                                               
          sta $9d                      //&      b06a   85 9d                                                
          jsr $00c2                    //&      b06c   20 c2 00                                               
          beq $b074                    //&      b06f   f0 03                                                  
          jmp $ac0c                    //&      b071   4c 0c ac                                               
lb074:
          pla                          //&      b074   68                                               
          sta.zp $c3                      //&      b075   85 c3                                                
          pla                          //&      b077   68                                               
          sta.zp $c4                      //&      b078   85 c4                                                
lb07a:
          ldy #$00                     //& b07a   a0 00                                                  
          pla                          //&      b07c   68                                               
          sta ($9c),y                   //&      b07d   91 9c                                                   
          pla                          //&      b07f   68                                               
          iny                          //&      b080   c8                                               
          sta ($9c),y                   //&      b081   91 9c                                                   
          pla                          //&      b083   68                                               
          iny                          //&      b084   c8                                               
          sta ($9c),y                   //&      b085   91 9c                                                   
          pla                          //&      b087   68                                               
          iny                          //&      b088   c8                                               
          sta ($9c),y                   //&      b089   91 9c                                                   
          rts                          //&      b08b   60                                               
// ----------------------------------------------------------------------------
// "STR$" FUNCTION
// ----------------------------------------------------------------------------
STR:
          jsr $aab0                    //&      b08c   20 b0 aa                                               
          ldy #$00                     //&      b08f   a0 00                                                  
          jsr $b970                    //&      b091   20 70 b9                                               
          pla                          //&      b094   68                                               
          pla                          //&      b095   68                                               
          lda #$ff                     //&      b096   a9 ff                                                  
          ldy #$00                     //&      b098   a0 00                                                  
          beq $b0ae                    //&      b09a   f0 12                                                  
// ----------------------------------------------------------------------------
// GET SPACE AND MAKE DESCRIPTOR FOR STRING WHOSE
// ADDRESS IS IN FAC+3,4 AND WHOSE LENGTH IS IN A-REG
// ----------------------------------------------------------------------------
STRINI:
          ldx $ae                      //&      b09c   a6 ae                                                
          ldy $af                      //&      b09e   a4 af                                                
          stx $9e                      //&      b0a0   86 9e                                                
          sty $9f                      //&      b0a2   84 9f                                                
// ----------------------------------------------------------------------------
// GET SPACE AND MAKE DESCRIPTOR FOR STRING WHOSE
// ADDRESS IS IN Y,X AND WHOSE LENGTH IS IN A-REG
// ----------------------------------------------------------------------------
STRSPA:
          jsr $b115                    //&      b0a4   20 15 b1                                               
          stx $ad                      //&      b0a7   86 ad                                                
          sty $ae                      //&      b0a9   84 ae                                                
          sta $ac                      //&      b0ab   85 ac                                                
          rts                          //&      b0ad   60                                               
// ----------------------------------------------------------------------------
// BUILD A DESCRIPTOR FOR STRING STARTING AT Y,A
// AND TERMINATED BY $00 OR QUOTATION MARK
// RETURN WITH DESCRIPTOR IN A TEMPORARY
// AND ADDRESS OF DESCRIPTOR IN FAC+3,4
// ----------------------------------------------------------------------------
STRLIT:
          ldx #$22                     //&      b0ae   a2 22                                                  
          stx $5b                      //&      b0b0   86 5b                                                
          stx $5c                      //&      b0b2   86 5c                                                
// ----------------------------------------------------------------------------
// BUILD A DESCRIPTOR FOR STRING STARTING AT Y,A
// AND TERMINATED BY $00, (CHARAC), OR (ENDCHR)
//
// RETURN WITH DESCRIPTOR IN A TEMPORARY
// AND ADDRESS OF DESCRIPTOR IN FAC+3,4
// ----------------------------------------------------------------------------
STRLT2:
          sta $b8                      //&      b0b4   85 b8                                                
          sty $b9                      //&      b0b6   84 b9                                                
          sta $ad                      //&      b0b8   85 ad                                                
          sty $ae                      //&      b0ba   84 ae                                                
          ldy #$ff                     //&      b0bc   a0 ff                                                  
lb0be:
          iny                          //&      b0be   c8                                               
          lda ($b8),y                   //&      b0bf   b1 b8                                                   
          beq $b0cf                    //&      b0c1   f0 0c                                                  
          cmp $5b                      //&      b0c3   c5 5b                                                
          beq $b0cb                    //&      b0c5   f0 04                                                  
          cmp $5c                      //&      b0c7   c5 5c                                                
          bne $b0be                    //&      b0c9   d0 f3                                                  
lb0cb:
          cmp #$22                     //&      b0cb   c9 22                                                  
          beq $b0d0                    //&      b0cd   f0 01                                                  
lb0cf:
          clc                          //&      b0cf   18                                               
lb0d0:
          sty $ac                      //&      b0d0   84 ac                                                
          tya                          //&      b0d2   98                                               
          adc $b8                      //&      b0d3   65 b8                                                
          sta $ba                      //&      b0d5   85 ba                                                
          ldx $b9                      //&      b0d7   a6 b9                                                
          bcc $b0dc                    //&      b0d9   90 01                                                  
          inx                          //&      b0db   e8                                               
lb0dc:
          stx $bb                      //&      b0dc   86 bb                                                
          lda $b9                      //&      b0de   a5 b9                                                
          bne $b0ed                    //&      b0e0   d0 0b                                                  
          tya                          //&      b0e2   98                                               
          jsr $b09c                    //&      b0e3   20 9c b0                                               
          ldx $b8                      //&      b0e6   a6 b8                                                
          ldy $b9                      //&      b0e8   a4 b9                                                
          jsr $b298                    //&      b0ea   20 98 b2                                               
// ----------------------------------------------------------------------------
// STORE DESCRIPTOR IN TEMPORARY DESCRIPTOR STACK
//
// THE DESCRIPTOR IS NOW IN FAC, FAC+1, FAC+2
// PUT ADDRESS OF TEMP DESCRIPTOR IN FAC+3,4
// ----------------------------------------------------------------------------
PUTNEW:
          ldx $65                      //&      b0ed   a6 65                                                
          cpx #$71                     //&      b0ef   e0 71                                                  
          bne $b0f8                    //&      b0f1   d0 05                                                  
          ldx #$1c                     //&      b0f3   a2 1c                                                  
JERR:
          jmp $a24e                    //&      b0f5   4c 4e a2                                               
PUTEMP:
          lda $ac                      //&      b0f8   a5 ac                                                
          sta $00,x                    //&      b0fa   95 00                                                  
          lda $ad                      //&      b0fc   a5 ad                                                
          sta $01,x                    //&      b0fe   95 01                                                  
          lda $ae                      //&      b100   a5 ae                                                
          sta $02,x                    //&      b102   95 02                                                  
          ldy #$00                     //&      b104   a0 00                                                  
          stx $ae                      //&      b106   86 ae                                                
          sty $af                      //&      b108   84 af                                                
          dey                          //&      b10a   88                                               
          sty $5f                      //&      b10b   84 5f                                                
          stx $66                      //&      b10d   86 66                                                
          inx                          //&      b10f   e8                                               
          inx                          //&      b110   e8                                               
          inx                          //&      b111   e8                                               
          stx $65                      //&      b112   86 65                                                
          rts                          //&      b114   60                                               
// ----------------------------------------------------------------------------
// MAKE SPACE FOR STRING AT BOTTOM OF STRING SPACE
// (A)=# BYTES SPACE TO MAKE
//
// RETURN WITH (A) SAME,
//	AND Y,X = ADDRESS OF SPACE ALLOCATED
// ----------------------------------------------------------------------------
GETSPA:
          lsr $60                      //&      b115   46 60                                                
lb117:
   pha                          //&      b117   48                                               
          eor #$ff                     //&      b118   49 ff                                                  
          sec                          //&      b11a   38                                               
          adc $81                      //&      b11b   65 81                                                
          ldy $82                      //&      b11d   a4 82                                                
          bcs $b122                    //&      b11f   b0 01                                                  
          dey                          //&      b121   88                                               
lb122:
   cpy $80                      //&      b122   c4 80                                                
          bcc $b137                    //&      b124   90 11                                                  
          bne $b12c                    //&      b126   d0 04                                                  
          cmp $7f                      //&      b128   c5 7f                                                
          bcc $b137                    //&      b12a   90 0b                                                  
lb12c:
   sta $81                      //&      b12c   85 81                                                
          sty $82                      //&      b12e   84 82                                                
          sta $83                      //&      b130   85 83                                                
          sty $84                      //&      b132   84 84                                                
          tax                          //&      b134   aa                                               
          pla                          //&      b135   68                                               
          rts                          //&      b136   60                                               
lb137:
   ldx #$0c                     //&      b137   a2 0c                                                  
          lda $60                      //&      b139   a5 60                                                
          bmi $b0f5                    //&      b13b   30 b8                                                  
          jsr $b147                    //&      b13d   20 47 b1                                               
          lda #$80                     //&      b140   a9 80                                                  
          sta $60                      //&      b142   85 60                                                
          pla                          //&      b144   68                                               
          bne $b117                    //&      b145   d0 d0                                                  
// ----------------------------------------------------------------------------
// SHOVE ALL REFERENCED STRINGS AS HIGH AS POSSIBLE
// IN MEMORY (AGAINST HIMEM), FREEING UP SPACE
// BELOW STRING AREA DOWN TO STREND.
// ----------------------------------------------------------------------------
GARBAG: GARBA2:
          ldx $85                      //&      b147   a6 85                                                
          lda $86                      //&      b149   a5 86                                                
FINDHIGHESTSTRING:
          stx $81                      //&      b14b   86 81                                                
          sta $82                      //&      b14d   85 82                                                
          ldy #$00                     //&      b14f   a0 00                                                  
          sty $9d                      //&      b151   84 9d                                                
          lda $7f                      //&      b153   a5 7f                                                
          ldx $80                      //&      b155   a6 80                                                
          sta $aa                      //&      b157   85 aa                                                
          stx $ab                      //&      b159   86 ab                                                
          lda #$68                     //&      b15b   a9 68                                                  

          sta $71                      //&      b15d   85 71                                                
          sty $72                      //&      b15f   84 72                                                
lb161:
          cmp $65                      //&      b161   c5 65                                                
          beq $b16a                    //&      b163   f0 05                                                  
          jsr $b1d7                    //&      b165   20 d7 b1                                               
          beq $b161                    //&      b168   f0 f7                                                  
lb16a:
          lda #$06                     //&      b16a   a9 06                                                  
          sta $a0                      //&      b16c   85 a0                                                
          lda $7b                      //&      b16e   a5 7b                                                
          ldx $7c                      //&      b170   a6 7c                                                
          sta $71                      //&      b172   85 71                                                
          stx $72                      //&      b174   86 72                                                
lb176:
          cpx $7e                      //&      b176   e4 7e                                                
          bne $b17e                    //&      b178   d0 04                                                  
          cmp $7d                      //&      b17a   c5 7d                                                
          beq $b183                    //&      b17c   f0 05                                                  
lb17e:
          jsr $b1d1                    //&      b17e   20 d1 b1                                               
          beq $b176                    //&      b181   f0 f3                                                  
lb183:
          sta $a4                      //&      b183   85 a4                                                
          stx $a5                      //&      b185   86 a5                                                
          lda #$04                     //&      b187   a9 04                                                  
          sta $a0                      //&      b189   85 a0                                                
lb18b:
          lda $a4                      //&      b18b   a5 a4                                                
          ldx $a5                      //&      b18d   a6 a5                                                
lb18f:
          cpx $80                      //&      b18f   e4 80                                                
          bne $b19a                    //&      b191   d0 07                                                  
          cmp $7f                      //&      b193   c5 7f                                                
          bne $b19a                    //&      b195   d0 03                                                  
          jmp $b216                    //&      b197   4c 16 b2                                               
lb19a:
          sta $71                      //&      b19a   85 71                                                
          stx $72                      //&      b19c   86 72                                                
          ldy #$01                     //&      b19e   a0 01                                                  
          lda ($71),y                   //&      b1a0   b1 71                                                   
          php                          //&      b1a2   08                                               
          iny                          //&      b1a3   c8                                               
          lda ($71),y                   //&      b1a4   b1 71                                                   
          adc $a4                      //&      b1a6   65 a4                                                
          sta $a4                      //&      b1a8   85 a4                                                
          iny                          //&      b1aa   c8                                               
          lda ($71),y                   //&      b1ab   b1 71                                                   
          adc $a5                      //&      b1ad   65 a5                                                
          sta $a5                      //&      b1af   85 a5                                                
          plp                          //&      b1b1   28                                               
          bpl $b18b                    //&      b1b2   10 d7                                                  
          iny                          //&      b1b4   c8                                               
          lda ($71),y                   //&      b1b5   b1 71                                                   
          asl                          //&      b1b7   0a                                                 
          adc #$05                     //&      b1b8   69 05                                                  
          adc $71                      //&      b1ba   65 71                                                
          sta $71                      //&      b1bc   85 71                                                
          bcc $b1c2                    //&      b1be   90 02                                                  
          inc $72                      //&      b1c0   e6 72                                                
lb1c2:
          ldx $72                      //&      b1c2   a6 72                                                
lb1c4:
          cpx $a5                      //&      b1c4   e4 a5                                                
          bne $b1cc                    //&      b1c6   d0 04                                                  
          cmp $a4                      //&      b1c8   c5 a4                                                
          beq $b18f                    //&      b1ca   f0 c3                                                  
lb1cc:
          jsr $b1d7                    //&      b1cc   20 d7 b1                                               
          beq $b1c4                    //&      b1cf   f0 f3                                                  
// ----------------------------------------------------------------------------
// PROCESS A SIMPLE VARIABLE
// ----------------------------------------------------------------------------
CHECK_SIMPLE_VARIABLE:
          iny                          //&      b1d1   c8                                               
          lda ($71),y                   //&      b1d2   b1 71                                                   
          bpl $b206                    //&      b1d4   10 30                                                  
          iny                          //&      b1d6   c8                                               
// ----------------------------------------------------------------------------
// IF STRING IS NOT EMPTY, CHECK IF IT IS HIGHEST
// ----------------------------------------------------------------------------
CHECK_VARIABLE:
          lda ($71),y                   //&      b1d7   b1 71                                                   
          beq $b206                    //&      b1d9   f0 2b                                                  
          iny                          //&      b1db   c8                                               
          lda ($71),y                   //&      b1dc   b1 71                                                   
          tax                          //&      b1de   aa                                               
          iny                          //&      b1df   c8                                               
          lda ($71),y                   //&      b1e0   b1 71                                                   
          cmp $82                      //&      b1e2   c5 82                                                
          bcc $b1ec                    //&      b1e4   90 06                                                  
          bne $b206                    //&      b1e6   d0 1e                                                  
          cpx $81                      //&      b1e8   e4 81                                                
          bcs $b206                    //&      b1ea   b0 1a                                                  
lb1ec:
          cmp $ab                      //&      b1ec   c5 ab                                                
          bcc $b206                    //&      b1ee   90 16                                                  
          bne $b1f6                    //&      b1f0   d0 04                                                  
          cpx $aa                      //&      b1f2   e4 aa                                                
          bcc $b206                    //&      b1f4   90 10                                                  
lb1f6:
          stx $aa                      //&      b1f6   86 aa                                                
          sta $ab                      //&      b1f8   85 ab                                                
          lda $71                      //&      b1fa   a5 71                                                
          ldx $72                      //&      b1fc   a6 72                                                
          sta $9c                      //&      b1fe   85 9c                                                
          stx $9d                      //&      b200   86 9d                                                
 
          dey                          //&      b202   88                                               
          dey                          //&      b203   88                                               
          sty $a2                      //&      b204   84 a2                                                
// ----------------------------------------------------------------------------
// ADD (DSCLEN) TO PNTR IN INDEX
// RETURN WITH Y=0, PNTR ALSO IN X,A
// ----------------------------------------------------------------------------
CHECK_BUMP:
          lda $a0                      //&      b206   a5 a0                                                
          clc                          //&      b208   18                                               
          adc $71                      //&      b209   65 71                                                
          sta $71                      //&      b20b   85 71                                                
          bcc $b211                    //&      b20d   90 02                                                  
          inc $72                      //&      b20f   e6 72                                                
lb211:
          ldx $72                      //&      b211   a6 72                                                
          ldy #$00                     //&      b213   a0 00                                                  
          rts                          //&      b215   60                                               
// ----------------------------------------------------------------------------
// FOUND HIGHEST NON-EMPTY STRING, SO MOVE IT
// TO TOP AND GO BACK FOR ANOTHER
// ----------------------------------------------------------------------------
MOVE_HIGHEST_STRING_TO_TOP:
          dec $a0                      //&      b216   c6 a0                                                
          ldx $9d                      //&      b218   a6 9d                                                
          beq $b211                    //&      b21a   f0 f5                                                  
          ldy $a2                      //&      b21c   a4 a2                                                
          clc                          //&      b21e   18                                               
          
          
          lda ($9c),y                   //&      b21f   b1 9c                                                   
          adc $aa                      //&      b221   65 aa                                                
          sta $a6                      //&      b223   85 a6                                                
          lda $ab                      //&      b225   a5 ab                                                
          adc #$00                     //&      b227   69 00                                                  
          sta $a7                      //&      b229   85 a7                                                
          lda $81                      //&      b22b   a5 81                                                
          ldx $82                      //&      b22d   a6 82                                                
          sta $a4                      //&      b22f   85 a4                                                
          stx $a5                      //&      b231   86 a5                                                
          jsr $a1d6                    //&      b233   20 d6 a1                                               
          ldy $a2                      //&      b236   a4 a2                                                
          iny                          //&      b238   c8                                               
          lda $a4                      //&      b239   a5 a4                                                
          sta ($9c),y                   //&      b23b   91 9c                                                   
          tax                          //&      b23d   aa                                               
          inc $a5                      //&      b23e   e6 a5                                                
          lda $a5                      //&      b240   a5 a5                                                
          iny                          //&      b242   c8                                               
          sta ($9c),y                   //&      b243   91 9c                                                   
          jmp $b14b                    //&      b245   4c 4b b1                                               
          .byte $53                    //&      b248   53         %01010011 'S'                                                     
          .byte $54                    //&      b249   54         %01010100 'T'                                                     
          .byte $49, $42                     //&      b24a   49 42                                                  
          .byte $4f                    //&      b24c   4f         %01001111 'O'                                                     
// ----------------------------------------------------------------------------
// CONCATENATE TWO STRINGS
// ----------------------------------------------------------------------------
CAT:
          lda $af                      //&      b24d   a5 af                                                
          pha                          //&      b24f   48                                               
          lda $ae                      //&      b250   a5 ae                                                
          pha                          //&      b252   48                                               
          jsr $aba0                    //&      b253   20 a0 ab                                               
          jsr $aab2                    //&      b256   20 b2 aa                                               
          pla                          //&      b259   68                                               
          sta $b8                      //&      b25a   85 b8                                                
          pla                          //&      b25c   68                                               
          sta $b9                      //&      b25d   85 b9                                                
          ldy #$00                     //&      b25f   a0 00                                                  
          lda ($b8),y                   //&      b261   b1 b8                                                   
          clc                          //&      b263   18                                               
          adc ($ae),y                   //&      b264   71 ae                                                   
          bcc $b26d                    //&      b266   90 05                                                  
          ldx #$1a                     //&      b268   a2 1a                                                  
          jmp $a24e                    //&      b26a   4c 4e a2                                               
lb26d:
          jsr $b09c                    //&      b26d   20 9c b0                                               
          jsr $b28a                    //&      b270   20 8a b2                                               
          lda $9e                      //&      b273   a5 9e                                                
          ldy $9f                      //&      b275   a4 9f                                                
          jsr $b2ba                    //&      b277   20 ba b2                                               
          jsr $b29c                    //&      b27a   20 9c b2                                               
          lda $b8                      //&      b27d   a5 b8                                                
          ldy $b9                      //&      b27f   a4 b9                                                
          jsr $b2ba                    //&      b281   20 ba b2                                               
          jsr $b0ed                    //&      b284   20 ed b0                                               
          jmp $aadb                    //&      b287   4c db aa                                               
// ----------------------------------------------------------------------------
// GET STRING DESCRIPTOR POINTED AT BY (STRNG1)
// AND MOVE DESCRIBED STRING TO (FRESPC)
// ----------------------------------------------------------------------------
MOVINS:
          ldy #$00                     //&      b28a   a0 00                                                  
          lda ($b8),y                   //&      b28c   b1 b8                                                   
          pha                          //&      b28e   48                                               
          iny                          //&      b28f   c8                                               
          lda ($b8),y                   //&      b290   b1 b8                                                   
          tax                          //&      b292   aa                                               
          iny                          //&      b293   c8                                               
          lda ($b8),y                   //&      b294   b1 b8                                                   
          tay                          //&      b296   a8                                               
          pla                          //&      b297   68                                               
// ----------------------------------------------------------------------------
// MOVE STRING AT (Y,X) WITH LENGTH (A)
// TO DESTINATION WHOSE ADDRESS IS IN FRESPC,FRESPC+1
// ----------------------------------------------------------------------------
MOVSTR:
          stx $71                      //&      b298   86 71                                                
          sty $72                      //&      b29a   84 72                                                
MOVSTR1:
          tay                          //&      b29c   a8                                               
          beq $b2a9                    //&      b29d   f0 0a                                                  
          pha                          //&      b29f   48                                               
lb2a0:
          dey                          //&      b2a0   88                                               
          lda ($71),y                   //&      b2a1   b1 71                                                   
          sta ($83),y                   //&      b2a3   91 83                                                   
          tya                          //&      b2a5   98                                               
          bne $b2a0                    //&      b2a6   d0 f8                                                  
          pla                          //&      b2a8   68                                               
lb2a9:
          clc                          //&      b2a9   18                                               
          adc $83                      //&      b2aa   65 83                                                
          sta $83                      //&      b2ac   85 83                                                
          bcc $b2b2                    //&      b2ae   90 02                                                  
          inc $84                      //&      b2b0   e6 84                                                
lb2b2:
          rts                          //&      b2b2   60                                               
// ----------------------------------------------------------------------------
// IF (FAC) IS A TEMPORARY STRING, RELEASE DESCRIPTOR
// ----------------------------------------------------------------------------
FRESTR:
          jsr $aab2                    //&      b2b3   20 b2 aa                                               
// ----------------------------------------------------------------------------
// IF STRING DESCRIPTOR POINTED TO BY FAC+3,4 IS
// A TEMPORARY STRING, RELEASE IT.
// ----------------------------------------------------------------------------
FREFAC:
          lda $ae                      //&      b2b6   a5 ae                                                
          ldy $af                      //&      b2b8   a4 af                                                
// ----------------------------------------------------------------------------
// IF STRING DESCRIPTOR WHOSE ADDRESS IS IN Y,A IS
// A TEMPORARY STRING, RELEASE IT.
// ----------------------------------------------------------------------------
FRETMP:
          sta $71                      //&      b2ba   85 71                                                
          sty $72                      //&      b2bc   84 72                                                
          jsr $b2eb                    //&      b2be   20 eb b2                                               
          php                          //&      b2c1   08                                               
          ldy #$00                     //&      b2c2   a0 00                                                  
          lda ($71),y                   //&      b2c4   b1 71                                                   
          pha                          //&      b2c6   48                                               
          iny                          //&      b2c7   c8                                               
          lda ($71),y                   //&      b2c8   b1 71                                                   
          tax                          //&      b2ca   aa                                               
          iny                          //&      b2cb   c8                                               
          lda ($71),y                   //&      b2cc   b1 71                                                   
          tay                          //&      b2ce   a8                                               
          pla                          //&      b2cf   68                                               
          plp                          //&      b2d0   28                                               
          bne $b2e6                    //&      b2d1   d0 13                                                  
          cpy $82                      //&      b2d3   c4 82                                                
          bne $b2e6                    //&      b2d5   d0 0f                                                  
          cpx $81                      //&      b2d7   e4 81                                                
          bne $b2e6                    //&      b2d9   d0 0b                                                  
          pha                          //&      b2db   48                                               
          clc                          //&      b2dc   18                                               
          adc $81                      //&      b2dd   65 81                                                
          sta $81                      //&      b2df   85 81                                                
          bcc $b2e5                    //&      b2e1   90 02                                                  
          inc $82                      //&      b2e3   e6 82                                                
lb2e5:
          pla                          //&      b2e5   68                                               
lb2e6:
          stx $71                      //&      b2e6   86 71                                                
          sty $72                      //&      b2e8   84 72                                                
          rts                          //&      b2ea   60                                               
// ----------------------------------------------------------------------------
// RELEASE TEMPORARY DESCRIPTOR IF Y,A = LASTPT
// ----------------------------------------------------------------------------
FRETMS:
          cpy $67                      //&      b2eb   c4 67                                                
          bne $b2fb                    //&      b2ed   d0 0c                                                  
          cmp $66                      //&      b2ef   c5 66                                                
          bne $b2fb                    //&      b2f1   d0 08                                                  
          sta $65                      //&      b2f3   85 65                                                
          sbc #$03                     //&      b2f5   e9 03                                                  
          sta $66                      //&      b2f7   85 66                                                
          ldy #$00                     //&      b2f9   a0 00                                                  
lb2fb:
          rts                          //&      b2fb   60                                               
// ----------------------------------------------------------------------------
// "CHR$" FUNCTION
// ----------------------------------------------------------------------------
CHRSTR:
          jsr $b3b1                    //&      b2fc   20 b1 b3                                               
          txa                          //&      b2ff   8a                                               
          pha                          //&      b300   48                                               
          lda #$01                     //&      b301   a9 01                                                  
          jsr $b0a4                    //&      b303   20 a4 b0                                               
          pla                          //&      b306   68                                               
          ldy #$00                     //&      b307   a0 00                                                  
          sta ($ad),y                   //&      b309   91 ad                                                   
          pla                          //&      b30b   68                                               
          pla                          //&      b30c   68                                               
          jmp $b0ed                    //&      b30d   4c ed b0                                               
// ----------------------------------------------------------------------------
// "LEFT$" FUNCTION
// ----------------------------------------------------------------------------
LEFTSTR:
          jsr $b36f                    //&      b310   20 6f b3                                               
          cmp ($9e),y                   //&      b313   d1 9e                                                   
          tya                          //&      b315   98                                               
SUBSTRING1:
          bcc $b31c                    //&      b316   90 04                                                  
          lda ($9e),y                   //&      b318   b1 9e                                                   
          tax                          //&      b31a   aa                                               
          tya                          //&      b31b   98                                               
lb31c:
          pha                          //&      b31c   48                                               
SUBSTRING2:
   txa                          //&      b31d   8a                                               
SUBSTRING3:
   pha                          //&      b31e   48                                               
          jsr $b0a4                    //&      b31f   20 a4 b0                                               
          lda $9e                      //&      b322   a5 9e                                                
          ldy $9f                      //&      b324   a4 9f                                                
          jsr $b2ba                    //&      b326   20 ba b2                                               
          pla                          //&      b329   68                                               
          tay                          //&      b32a   a8                                               
          pla                          //&      b32b   68                                               
          clc                          //&      b32c   18                                               
          adc $71                      //&      b32d   65 71                                                
          sta $71                      //&      b32f   85 71                                                
          bcc $b335                    //&      b331   90 02                                                  
          inc $72                      //&      b333   e6 72                                                
lb335:
   tya                          //&      b335   98                                               
          jsr $b29c                    //&      b336   20 9c b2                                               
          jmp $b0ed                    //&      b339   4c ed b0                                               
// ----------------------------------------------------------------------------
// "RIGHT$" FUNCTION
// ----------------------------------------------------------------------------
RIGHTSTR:
          jsr $b36f                    //&      b33c   20 6f b3                                               
          clc                          //&      b33f   18                                               
          sbc ($9e),y                   //&      b340   f1 9e                                                   
          eor #$ff                     //&      b342   49 ff                                                  
          jmp $b316                    //&      b344   4c 16 b3                                               
// ----------------------------------------------------------------------------
// "MID$" FUNCTION
// ----------------------------------------------------------------------------
MIDSTR:
          lda #$ff                     //&      b347   a9 ff                                                  
          sta $af                      //&      b349   85 af                                                
          jsr $00c2                    //&      b34b   20 c2 00                                               
          cmp #$29                     //&      b34e   c9 29                                                  
          beq $b358                    //&      b350   f0 06                                                  
          jsr $ac01                    //&      b352   20 01 ac                                               
          jsr $b3ae                    //&      b355   20 ae b3                                               
lb358:
          jsr $b36f                    //&      b358   20 6f b3                                               
          dex                          //&      b35b   ca                                               
          txa                          //&      b35c   8a                                               
          pha                          //&      b35d   48                                               
          clc                          //&      b35e   18                                               
          ldx #$00                     //&      b35f   a2 00                                                  
          sbc ($9e),y                   //&      b361   f1 9e                                                   
          bcs $b31d                    //&      b363   b0 b8                                                  
          eor #$ff                     //&      b365   49 ff                                                  
          cmp $af                      //&      b367   c5 af                                                
          bcc $b31e                    //&      b369   90 b3                                                  
          lda $af                      //&      b36b   a5 af                                                
          bcs $b31e                    //&      b36d   b0 af                                                  
lb36f:
 // ----------------------------------------------------------------------------
// COMMON SETUP ROUTINE FOR LEFT$, RIGHT$, MID$:
// REQUIRE ")"// POP RETURN ADRS, GET DESCRIPTOR
// ADDRESS, GET 1ST PARAMETER OF COMMAND
// ----------------------------------------------------------------------------
SUBSTRING_SETUP:
          jsr $abfb                    //&      b36f   20 fb ab                                               
          pla                          //&      b372   68                                               
          sta $a2                      //&      b373   85 a2                                                
          pla                          //&      b375   68                                               
          sta $a3                      //&      b376   85 a3                                                
          pla                          //&      b378   68                                               
          pla                          //&      b379   68                                               
          pla                          //&      b37a   68                                               
          tax                          //&      b37b   aa                                               
          pla                          //&      b37c   68                                               
          sta $9e                      //&      b37d   85 9e                                                
          pla                          //&      b37f   68                                               
          sta $9f                      //&      b380   85 9f                                                
          ldy #$00                     //&      b382   a0 00                                                  
          txa                          //&      b384   8a                                               
          beq $b3a8                    //&      b385   f0 21                                                  
          inc $a2                      //&      b387   e6 a2                                                
          jmp ($00a2)                   //&      b389   6c a2 00                                                 
// ----------------------------------------------------------------------------
// "LEN" FUNCTION
// ----------------------------------------------------------------------------
LEN:
          jsr $b392                    //&      b38c   20 92 b3                                               
SNGFLT1:
   jmp $afd0                    //&      b38f   4c d0 af                                               
// ----------------------------------------------------------------------------
// IF LAST RESULT IS A TEMPORARY STRING, FREE IT
// MAKE VALTYP NUMERIC, RETURN LENGTH IN Y-REG
// ----------------------------------------------------------------------------
GETSTR:
   jsr $b2b3                    //&      b392   20 b3 b2                                               
          ldx #$00                     //&      b395   a2 00                                                  
          stx $5f                      //&      b397   86 5f                                                
          tay                          //&      b399   a8                                               
          rts                          //&      b39a   60                                               
// ----------------------------------------------------------------------------
// "ASC" FUNCTION
// ----------------------------------------------------------------------------
ASC:
          jsr $b392                    //&      b39b   20 92 b3                                               
          beq $b3a8                    //&      b39e   f0 08                                                  
          ldy #$00                     //&      b3a0   a0 00                                                  
          lda ($71),y                   //&      b3a2   b1 71                                                   
          tay                          //&      b3a4   a8                                               
          jmp $b38f                    //&      b3a5   4c 8f b3                                               
// ----------------------------------------------------------------------------
GOIQ:
   jmp $ae88                    //&      b3a8   4c 88 ae                                               
// ----------------------------------------------------------------------------
// SCAN TO NEXT CHARACTER AND CONVERT EXPRESSION
// TO SINGLE BYTE IN X-REG
// ----------------------------------------------------------------------------
GTBYTC:
   jsr $00bc                    //&      b3ab   20 bc 00                                               
// ----------------------------------------------------------------------------
// EVALUATE EXPRESSION AT TXTPTR, AND
// CONVERT IT TO SINGLE BYTE IN X-REG
// ----------------------------------------------------------------------------
GETBYT:
          jsr $aaad                    //&      b3ae   20 ad aa                                               
// ----------------------------------------------------------------------------
// CONVERT (FAC) TO SINGLE BYTE INTEGER IN X-REG
// ----------------------------------------------------------------------------
CONINT:
          jsr $ae01                    //&      b3b1   20 01 ae                                               
          ldx $ae                      //&      b3b4   a6 ae                                                
          bne $b3a8                    //&      b3b6   d0 f0                                                  
          ldx $af                      //&      b3b8   a6 af                                                
          jmp $00c2                    //&      b3ba   4c c2 00                                               
// ----------------------------------------------------------------------------
// "VAL" FUNCTION
// ----------------------------------------------------------------------------
VAL:
          jsr $b392                    //&      b3bd   20 92 b3                                               
          bne $b3c5                    //&      b3c0   d0 03                                                  
          jmp $b4f1                    //&      b3c2   4c f1 b4                                               
lb3c5:
          ldx.zp $c3                      //&      b3c5   a6 c3                                                
          ldy.zp $c4                      //&      b3c7   a4 c4                                                
          stx $ba                      //&      b3c9   86 ba                                                
          sty $bb                      //&      b3cb   84 bb                                                
          ldx $71                      //&      b3cd   a6 71                                                
          stx.zp $c3                      //&      b3cf   86 c3                                                
          clc                          //&      b3d1   18                                               
          adc $71                      //&      b3d2   65 71                                                
          sta $73                      //&      b3d4   85 73                                                
          ldx $72                      //&      b3d6   a6 72                                                
          stx.zp $c4                      //&      b3d8   86 c4                                                
          bcc $b3dd                    //&      b3da   90 01                                                  
          inx                          //&      b3dc   e8                                               
lb3dd:
          stx $74                      //&      b3dd   86 74                                                
          ldy #$00                     //&      b3df   a0 00                                                  
          lda ($73),y                   //&      b3e1   b1 73                                                   
          pha                          //&      b3e3   48                                               
          lda #$00                     //&      b3e4   a9 00                                                  
          sta ($73),y                   //&      b3e6   91 73                                                   
          jsr $00c2                    //&      b3e8   20 c2 00                                               
          jsr $b887                    //&      b3eb   20 87 b8                                               
          pla                          //&      b3ee   68                                               
          ldy #$00                     //&      b3ef   a0 00                                                  
          sta ($73),y                   //&      b3f1   91 73                                                   
// ----------------------------------------------------------------------------
// COPY STRNG2 INTO TXTPTR
// ----------------------------------------------------------------------------
POINT:
          ldx $ba                      //&      b3f3   a6 ba                                                
          ldy $bb                      //&      b3f5   a4 bb                                                
          stx.zp $c3                      //&      b3f7   86 c3                                                
          sty.zp $c4                      //&      b3f9   84 c4                                                
          rts                          //&      b3fb   60                                               
// ----------------------------------------------------------------------------
// EVALUATE "EXP1,EXP2"
//
// CONVERT EXP1 TO 16-BIT NUMBER IN LINNUM
// CONVERT EXP2 TO 8-BIT NUMBER IN X-REG
// ----------------------------------------------------------------------------
GTNUM:
          jsr $aaad                    //&      b3fc   20 ad aa                                               
          jsr $b408                    //&      b3ff   20 08 b4                                               
// ----------------------------------------------------------------------------
// EVALUATE ",EXPRESSION"
// CONVERT EXPRESSION TO SINGLE BYTE IN X-REG
// ----------------------------------------------------------------------------
COMBYTE:
          jsr $ac01                    //&      b402   20 01 ac                                               
          jmp $b3ae                    //&      b405   4c ae b3                                               
// ----------------------------------------------------------------------------
// CONVERT (FAC) TO A 16-BIT VALUE IN LINNUM
// ----------------------------------------------------------------------------
GETADR:
          lda $b0                      //&      b408   a5 b0                                                
          bmi $b3a8                    //&      b40a   30 9c                                                  
          lda $ac                      //&      b40c   a5 ac                                                
          cmp #$91                     //&      b40e   c9 91                                                  
          bcs $b3a8                    //&      b410   b0 96                                                  
          jsr $b831                    //&      b412   20 31 b8                                               
          lda $ae                      //&      b415   a5 ae                                                
          ldy $af                      //&      b417   a4 af                                                
          sty $11                      //&      b419   84 11                                                
          sta $12                      //&      b41b   85 12                                                
          rts                          //&      b41d   60                                               
// ----------------------------------------------------------------------------
// "PEEK" FUNCTION
// ----------------------------------------------------------------------------
PEEK:
          jsr $b408                    //&      b41e   20 08 b4                                               
          ldy #$00                     //&      b421   a0 00                                                  
// disallow PEEK between $C000 and $DFFF
          lda ($11),y                   //&      b423   b1 11                                                   
          tay                          //&      b425   a8                                               
          jmp $afd0                    //&      b426   4c d0 af                                               
// ----------------------------------------------------------------------------
// "POKE" STATEMENT
// ----------------------------------------------------------------------------
POKE:
          jsr $b3fc                    //&      b429   20 fc b3                                               
          txa                          //&      b42c   8a                                               
          ldy #$00                     //&      b42d   a0 00                                                  
          sta ($11),y                   //&      b42f   91 11                                                   
          rts                          //&      b431   60                                               
// ----------------------------------------------------------------------------
// "WAIT" STATEMENT
// ----------------------------------------------------------------------------
WAIT:
          jsr $b3fc                    //&      b432   20 fc b3                                               
          stx $97                      //&      b435   86 97                                                
          ldx #$00                     //&      b437   a2 00                                                  
          jsr $00c2                    //&      b439   20 c2 00                                               
          beq $b441                    //&      b43c   f0 03                                                  
          jsr $b402                    //&      b43e   20 02 b4                                               
lb441:
          stx $98                      //&      b441   86 98                                                
          ldy #$00                     //&      b443   a0 00                                                  
lb445:
          lda ($11),y                   //&      b445   b1 11                                                   
          eor $98                      //&      b447   45 98                                                
          and $97                      //&      b449   25 97                                                
          beq $b445                    //&      b44b   f0 f8                                                  
RTS3:
          rts                          //&      b44d   60                                               
.label TEMP1X = TEMP1+(5-BYTES_FP)
// ----------------------------------------------------------------------------
// ADD 0.5 TO FAC
// ----------------------------------------------------------------------------
FADDH:
          lda #$96                     //&      b44e   a9 96                                                  
          ldy #$ba                     //&      b450   a0 ba                                                  
          jmp $b46c                    //&      b452   4c 6c b4                                               
// ----------------------------------------------------------------------------
// FAC = (Y,A) - FAC
// ----------------------------------------------------------------------------
FSUB:
          jsr $b64d                    //&      b455   20 4d b6                                               
// ----------------------------------------------------------------------------
// FAC = ARG - FAC
// ----------------------------------------------------------------------------
FSUBT:
   lda $b0                      //&      b458   a5 b0                                                
          eor #$ff                     //&      b45a   49 ff                                                  
          sta $b0                      //&      b45c   85 b0                                                
          eor $b7                      //&      b45e   45 b7                                                
          sta $b8                      //&      b460   85 b8                                                
          lda $ac                      //&      b462   a5 ac                                                
          jmp $b46f                    //&      b464   4c 6f b4                                               
// ----------------------------------------------------------------------------
// Commodore BASIC V2 Easter Egg
// ----------------------------------------------------------------------------
// ----------------------------------------------------------------------------
// SHIFT SMALLER ARGUMENT MORE THAN 7 BITS
// ----------------------------------------------------------------------------
FADD1:
          jsr $b57b                    //&      b467   20 7b b5                                               
          bcc $b4a8                    //&      b46a   90 3c                                                  
// ----------------------------------------------------------------------------
// FAC = (Y,A) + FAC
// ----------------------------------------------------------------------------
FADD:
          jsr $b64d                    //&      b46c   20 4d b6                                               
// ----------------------------------------------------------------------------
// FAC = ARG + FAC
// ----------------------------------------------------------------------------
FADDT:
          bne $b474                    //&      b46f   d0 03                                                  
          jmp $b79b                    //&      b471   4c 9b b7                                               
lb474:
          ldx $b9                      //&      b474   a6 b9                                                
          stx $a3                      //&      b476   86 a3                                                
          ldx #$b3                     //&      b478   a2 b3                                                  
          lda $b3                      //&      b47a   a5 b3                                                
FADD2:
          tay                          //&      b47c   a8                                               
          beq $b44d                    //&      b47d   f0 ce                                                  
          sec                          //&      b47f   38                                               
          sbc $ac                      //&      b480   e5 ac                                                
          beq $b4a8                    //&      b482   f0 24                                                  
          bcc $b498                    //&      b484   90 12                                                  
          sty $ac                      //&      b486   84 ac                                                
          ldy $b7                      //&      b488   a4 b7                                                
          sty $b0                      //&      b48a   84 b0                                                
          eor #$ff                     //&      b48c   49 ff                                                  
          adc #$00                     //&      b48e   69 00                                                  
          ldy #$00                     //&      b490   a0 00                                                  
          sty $a3                      //&      b492   84 a3                                                
          ldx #$ac                     //&      b494   a2 ac                                                  
          bne $b49c                    //&      b496   d0 04                                                  
lb498:
          ldy #$00                     //&      b498   a0 00                                                  
          sty $b9                      //&      b49a   84 b9                                                
lb49c:
          cmp #$f9                     //&      b49c   c9 f9                                                  
          bmi $b467                    //&      b49e   30 c7                                                  
          tay                          //&      b4a0   a8                                               
          lda $b9                      //&      b4a1   a5 b9                                                
          lsr $01,x                    //&      b4a3   56 01                                                  
          jsr $b592                    //&      b4a5   20 92 b5                                               
FADD3:
          bit $b8                      //&      b4a8   24 b8                                                
          bpl $b4f8                    //&      b4aa   10 4c                                                  
          ldy #$ac                     //&      b4ac   a0 ac                                                  
          cpx #$b3                     //&      b4ae   e0 b3                                                  
          beq $b4b4                    //&      b4b0   f0 02                                                  
          ldy #$b3                     //&      b4b2   a0 b3                                                  
lb4b4:
          sec                          //&      b4b4   38                                               
          eor #$ff                     //&      b4b5   49 ff                                                  
          adc $a3                      //&      b4b7   65 a3                                                
          sta $b9                      //&      b4b9   85 b9                                                
          lda $0003,y                   //&      b4bb   b9 03 00                                                 
          sbc $03,x                    //&      b4be   f5 03                                                  
          sta $af                      //&      b4c0   85 af                                                
          lda $0002,y                   //&      b4c2   b9 02 00                                                 
          sbc $02,x                    //&      b4c5   f5 02                                                  
          sta $ae                      //&      b4c7   85 ae                                                
          lda $0001,y                   //&      b4c9   b9 01 00                                                 
          sbc $01,x                    //&      b4cc   f5 01                                                  
          sta $ad                      //&      b4ce   85 ad                                                
// ----------------------------------------------------------------------------
// NORMALIZE VALUE IN FAC
// ----------------------------------------------------------------------------
NORMALIZE_FAC1:
          bcs $b4d5                    //&      b4d0   b0 03                                                  
          jsr $b537                    //&      b4d2   20 37 b5                                               
NORMALIZE_FAC2:
          ldy #$00                     //&      b4d5   a0 00                                                  
          tya                          //&      b4d7   98                                               
          clc                          //&      b4d8   18                                               
lb4d9:
          ldx $ad                      //&      b4d9   a6 ad                                                
          bne $b51b                    //&      b4db   d0 3e                                                  
          ldx $ae                      //&      b4dd   a6 ae                                                
          stx $ad                      //&      b4df   86 ad                                                
          ldx $af                      //&      b4e1   a6 af                                                
          stx $ae                      //&      b4e3   86 ae                                                
          ldx $b9                      //&      b4e5   a6 b9                                                
          stx $af                      //&      b4e7   86 af                                                
          sty $b9                      //&      b4e9   84 b9                                                
          adc #$08                     //&      b4eb   69 08                                                  
// bugfix?
// fix does not exist on AppleSoft 2
          cmp #$18                     //&      b4ed   c9 18                                                  
          bne $b4d9                    //&      b4ef   d0 e8                                                  
// ----------------------------------------------------------------------------
// SET FAC = 0
// (ONLY NECESSARY TO ZERO EXPONENT AND SIGN CELLS)
// ----------------------------------------------------------------------------
ZERO_FAC:
          lda #$00                     //&      b4f1   a9 00                                                  
STA_IN_FAC_SIGN_AND_EXP:
          sta $ac                      //&      b4f3   85 ac                                                
STA_IN_FAC_SIGN:
          sta $b0                      //&      b4f5   85 b0                                                
          rts                          //&      b4f7   60                                               
// ----------------------------------------------------------------------------
// ADD MANTISSAS OF FAC AND ARG INTO FAC
// ----------------------------------------------------------------------------
FADD4:
          adc $a3                      //&      b4f8   65 a3                                                
          sta $b9                      //&      b4fa   85 b9                                                
          lda $af                      //&      b4fc   a5 af                                                
          adc $b6                      //&      b4fe   65 b6                                                
          sta $af                      //&      b500   85 af                                                
          lda $ae                      //&      b502   a5 ae                                                
          adc $b5                      //&      b504   65 b5                                                
          sta $ae                      //&      b506   85 ae                                                
          lda $ad                      //&      b508   a5 ad                                                
          adc $b4                      //&      b50a   65 b4                                                
          sta $ad                      //&      b50c   85 ad                                                
          jmp $b528                    //&      b50e   4c 28 b5                                               
// ----------------------------------------------------------------------------
// FINISH NORMALIZING FAC
// ----------------------------------------------------------------------------
NORMALIZE_FAC3:
          adc #$01                     //&      b511   69 01                                                  
          asl $b9                      //&      b513   06 b9                                                
          rol $af                      //&      b515   26 af                                                
          rol $ae                      //&      b517   26 ae                                                
          rol $ad                      //&      b519   26 ad                                                
NORMALIZE_FAC4:
          bpl $b511                    //&      b51b   10 f4                                                  
          sec                          //&      b51d   38                                               
          sbc $ac                      //&      b51e   e5 ac                                                
          bcs $b4f1                    //&      b520   b0 cf                                                  
          eor #$ff                     //&      b522   49 ff                                                  
          adc #$01                     //&      b524   69 01                                                  
          sta $ac                      //&      b526   85 ac                                                
NORMALIZE_FAC5:
          bcc $b536                    //&      b528   90 0c                                                  
NORMALIZE_FAC6:
          inc $ac                      //&      b52a   e6 ac                                                
          beq $b564                    //&      b52c   f0 36                                                  
          ror $ad                      //&      b52e   66 ad                                                
          ror $ae                      //&      b530   66 ae                                                
          ror $af                      //&      b532   66 af                                                
          ror $b9                      //&      b534   66 b9                                                
lb536:
          rts                          //&      b536   60                                               
// ----------------------------------------------------------------------------
// 2'S COMPLEMENT OF FAC
// ----------------------------------------------------------------------------
COMPLEMENT_FAC:
          lda $b0                      //&      b537   a5 b0                                                
          eor #$ff                     //&      b539   49 ff                                                  
          sta $b0                      //&      b53b   85 b0                                                
// ----------------------------------------------------------------------------
// 2'S COMPLEMENT OF FAC MANTISSA ONLY
// ----------------------------------------------------------------------------
COMPLEMENT_FAC_MANTISSA:
          lda $ad                      //&      b53d   a5 ad                                                
          eor #$ff                     //&      b53f   49 ff                                                  
          sta $ad                      //&      b541   85 ad                                                
          lda $ae                      //&      b543   a5 ae                                                
          eor #$ff                     //&      b545   49 ff                                                  
          sta $ae                      //&      b547   85 ae                                                
          lda $af                      //&      b549   a5 af                                                
          eor #$ff                     //&      b54b   49 ff                                                  
          sta $af                      //&      b54d   85 af                                                
          lda $b9                      //&      b54f   a5 b9                                                
          eor #$ff                     //&      b551   49 ff                                                  
          sta $b9                      //&      b553   85 b9                                                
          inc $b9                      //&      b555   e6 b9                                                
          bne $b563                    //&      b557   d0 0a                                                  
// ----------------------------------------------------------------------------
// INCREMENT FAC MANTISSA
// ----------------------------------------------------------------------------
INCREMENT_FAC_MANTISSA:
          inc $af                      //&      b559   e6 af                                                
          bne $b563                    //&      b55b   d0 06                                                  
          inc $ae                      //&      b55d   e6 ae                                                
          bne $b563                    //&      b55f   d0 02                                                  
          inc $ad                      //&      b561   e6 ad                                                
RTS12:
   rts                          //&      b563   60                                               
OVERFLOW:
   ldx #$0a                     //&      b564   a2 0a                                                  
          jmp $a24e                    //&      b566   4c 4e a2                                               
// ----------------------------------------------------------------------------
// SHIFT 1,X THRU 5,X RIGHT
// (A) = NEGATIVE OF SHIFT COUNT
// (X) = POINTER TO BYTES TO BE SHIFTED
//
// RETURN WITH (Y)=0, CARRY=0, EXTENSION BITS IN A-REG
// ----------------------------------------------------------------------------
SHIFT_RIGHT1:
          ldx #$74                     //&      b569   a2 74                                                  
SHIFT_RIGHT2:
          ldy $03,x                    //&      b56b   b4 03                                                  
          sty $b9                      //&      b56d   84 b9                                                
          ldy $02,x                    //&      b56f   b4 02                                                  
          sty $03,x                    //&      b571   94 03                                                  
          ldy $01,x                    //&      b573   b4 01                                                  
          sty $02,x                    //&      b575   94 02                                                  
          ldy $b2                      //&      b577   a4 b2                                                
          sty $01,x                    //&      b579   94 01                                                  
// ----------------------------------------------------------------------------
// MAIN ENTRY TO RIGHT SHIFT SUBROUTINE
// ----------------------------------------------------------------------------
SHIFT_RIGHT:
          adc #$08                     //&      b57b   69 08                                                  
          bmi $b56b                    //&      b57d   30 ec                                                  
          beq $b56b                    //&      b57f   f0 ea                                                  
          sbc #$08                     //&      b581   e9 08                                                  
          tay                          //&      b583   a8                                               
          lda $b9                      //&      b584   a5 b9                                                
          bcs $b59a                    //&      b586   b0 12                                                  
lb588:
          asl $01,x                    //&      b588   16 01                                                  
          bcc $b58e                    //&      b58a   90 02                                                  
          inc $01,x                    //&      b58c   f6 01                                                  
lb58e:
          ror $01,x                    //&      b58e   76 01                                                  
          ror $01,x                    //&      b590   76 01                                                  
// ----------------------------------------------------------------------------
// ENTER HERE FOR SHORT SHIFTS WITH NO SIGN EXTENSION
// ----------------------------------------------------------------------------
SHIFT_RIGHT4:
          ror $02,x                    //&      b592   76 02                                                  
          ror $03,x                    //&      b594   76 03                                                  
          ror                          //&      b596   6a                                                 
          iny                          //&      b597   c8                                               
          bne $b588                    //&      b598   d0 ee                                                  
SHIFT_RIGHT5:
          clc                          //&      b59a   18                                               
          rts                          //&      b59b   60                                               
// ----------------------------------------------------------------------------
CON_ONE:
          sta ($00,x)                   //&      b59c   81 00                                                   
          brk                          //&      b59e   00                                               
POLY_LOG:
          brk                          //&      b59f   00                                               
          .byte $02                    //&      b5a0   02         %00000010                                                     
          .byte $80                    //&      b5a1   80         %10000000                                                     
          ora $6256,y                   //&      b5a2   19 56 62                                                 
          .byte $80                    //&      b5a5   80         %10000000                                                     
          ror $22,x                    //&      b5a6   76 22                                                  
          .byte $f3                    //&      b5a8   f3         %11110011                                                     
          .byte $82                    //&      b5a9   82         %10000010                                                     
          sec                          //&      b5aa   38                                               
          tax                          //&      b5ab   aa                                               
          rti                          //&      b5ac   40                                               
CON_SQR_HALF:
          .byte $80                    //&      b5ad   80         %10000000                                                     
          and $04,x                    //&      b5ae   35 04                                                  
          .byte $f3                    //&      b5b0   f3         %11110011                                                     
CON_SQR_TWO:
          sta ($35,x)                   //&      b5b1   81 35                                                   
          .byte $04                    //&      b5b3   04         %00000100                                                     
          .byte $f3                    //&      b5b4   f3         %11110011                                                     
CON_NEG_HALF:
          .byte $80                    //&      b5b5   80         %10000000                                                     
          .byte $80                    //&      b5b6   80         %10000000                                                     
          brk                          //&      b5b7   00                                               
          brk                          //&      b5b8   00                                               
CON_LOG_TWO:
          .byte $80                    //&      b5b9   80         %10000000                                                     
          and ($72),y                   //&      b5ba   31 72                                                   
          clc                          //&      b5bc   18                                               
// ----------------------------------------------------------------------------
// "LOG" FUNCTION
// ----------------------------------------------------------------------------
LOG:
          jsr $b7ca                    //&      b5bd   20 ca b7                                               
          beq $b5c4                    //&      b5c0   f0 02                                                  
          bpl $b5c7                    //&      b5c2   10 03                                                  
GIQ:
          jmp $ae88                    //&      b5c4   4c 88 ae                                               
LOG2:
          lda $ac                      //&      b5c7   a5 ac                                                
          sbc #$7f                     //&      b5c9   e9 7f                                                  
          pha                          //&      b5cb   48                                               
          lda #$80                     //&      b5cc   a9 80                                                  
          sta $ac                      //&      b5ce   85 ac                                                
          lda #$ad                     //&      b5d0   a9 ad                                                  
          ldy #$b5                     //&      b5d2   a0 b5                                                  
          jsr $b46c                    //&      b5d4   20 6c b4                                               
          lda #$b1                     //&      b5d7   a9 b1                                                  
          ldy #$b5                     //&      b5d9   a0 b5                                                  
          jsr FDIV                    //&      b5db   20 ca b6                                               
          lda #$9c                     //&      b5de   a9 9c                                                  
          ldy #$b5                     //&      b5e0   a0 b5                                                  
          jsr $b455                    //&      b5e2   20 55 b4                                               
          lda #$a0                     //&      b5e5   a9 a0                                                  
          ldy #$b5                     //&      b5e7   a0 b5                                                  
          jsr POLYNOMIAL_ODD                    //&      b5e9   20 6e bb                                               
          lda #$b5                     //&      b5ec   a9 b5                                                  
          ldy #$b5                     //&      b5ee   a0 b5                                                  
          jsr $b46c                    //&      b5f0   20 6c b4                                               
          pla                          //&      b5f3   68                                               
          jsr $b912                    //&      b5f4   20 12 b9                                               
          lda #$b9                     //&      b5f7   a9 b9                                                  
          ldy #$b5                     //&      b5f9   a0 b5                                                  
// ----------------------------------------------------------------------------
// FAC = (Y,A) * FAC
// ----------------------------------------------------------------------------
FMULT:
          jsr $b64d                    //&      b5fb   20 4d b6                                               
// ----------------------------------------------------------------------------
// FAC = ARG * FAC
// ----------------------------------------------------------------------------
FMULTT:
          beq $b64c                    //&      b5fe   f0 4c                                                  
          jsr $b673                    //&      b600   20 73 b6                                               
          lda #$00                     //&      b603   a9 00                                                  
          sta $75                      //&      b605   85 75                                                
          sta $76                      //&      b607   85 76                                                
          sta $77                      //&      b609   85 77                                                
          lda $b9                      //&      b60b   a5 b9                                                
          jsr $b622                    //&      b60d   20 22 b6                                               
          lda $af                      //&      b610   a5 af                                                
          jsr $b622                    //&      b612   20 22 b6                                               
          lda $ae                      //&      b615   a5 ae                                                
          jsr $b622                    //&      b617   20 22 b6                                               
          lda $ad                      //&      b61a   a5 ad                                                
          jsr $b627                    //&      b61c   20 27 b6                                               
          jmp $b73c                    //&      b61f   4c 3c b7                                               
// ----------------------------------------------------------------------------
// MULTIPLY ARG BY (A) INTO RESULT
// ----------------------------------------------------------------------------
MULTIPLY1:
          bne $b627                    //&      b622   d0 03                                                  
          jmp $b569                    //&      b624   4c 69 b5                                               
MULTIPLY2:
          lsr                          //&      b627   4a                                                 
          ora #$80                     //&      b628   09 80                                                  
lb62a:
   tay                          //&      b62a   a8                                               
          bcc $b640                    //&      b62b   90 13                                                  
          clc                          //&      b62d   18                                               
          lda $77                      //&      b62e   a5 77                                                
          adc $b6                      //&      b630   65 b6                                                
          sta $77                      //&      b632   85 77                                                
          lda $76                      //&      b634   a5 76                                                
          adc $b5                      //&      b636   65 b5                                                
          sta $76                      //&      b638   85 76                                                
          lda $75                      //&      b63a   a5 75                                                
          adc $b4                      //&      b63c   65 b4                                                
          sta $75                      //&      b63e   85 75                                                
lb640:
          ror $75                      //&      b640   66 75                                                
          ror $76                      //&      b642   66 76                                                
// this seems to be a bad byte in the dump
          ror $77                      //&      b644   66 77                                                
          ror $b9                      //&      b646   66 b9                                                
          tya                          //&      b648   98                                               
          lsr                          //&      b649   4a                                                 
          bne $b62a                    //&      b64a   d0 de                                                  
lb64c:
          rts                          //&      b64c   60                                               
// ----------------------------------------------------------------------------
// UNPACK NUMBER AT (Y,A) INTO ARG
// ----------------------------------------------------------------------------
LOAD_ARG_FROM_YA:
          sta $71                      //&      b64d   85 71                                                
          sty $72                      //&      b64f   84 72                                                
          ldy #$03                     //&      b651   a0 03                                                  
          lda ($71),y                   //&      b653   b1 71                                                   
          sta $b6                      //&      b655   85 b6                                                
          dey                          //&      b657   88                                               
          lda ($71),y                   //&      b658   b1 71                                                   
          sta $b5                      //&      b65a   85 b5                                                
          dey                          //&      b65c   88                                               
          lda ($71),y                   //&      b65d   b1 71                                                   
          sta $b7                      //&      b65f   85 b7                                                
          eor $b0                      //&      b661   45 b0                                                
          sta $b8                      //&      b663   85 b8                                                
          lda $b7                      //&      b665   a5 b7                                                
          ora #$80                     //&      b667   09 80                                                  
          sta $b4                      //&      b669   85 b4                                                
          dey                          //&      b66b   88                                               
          lda ($71),y                   //&      b66c   b1 71                                                   
          sta $b3                      //&      b66e   85 b3                                                
          lda $ac                      //&      b670   a5 ac                                                
          rts                          //&      b672   60                                               
// ----------------------------------------------------------------------------
// ADD EXPONENTS OF ARG AND FAC
// (CALLED BY FMULT AND FDIV)
//
// ALSO CHECK FOR OVERFLOW, AND SET RESULT SIGN
// ----------------------------------------------------------------------------
ADD_EXPONENTS:
          lda $b3                      //&      b673   a5 b3                                                
ADD_EXPONENTS1:
          beq $b696                    //&      b675   f0 1f                                                  
          clc                          //&      b677   18                                               
          adc $ac                      //&      b678   65 ac                                                
          bcc $b680                    //&      b67a   90 04                                                  
          bmi $b69b                    //&      b67c   30 1d                                                  
          clc                          //&      b67e   18                                                         
          .byte $2c                    //&      b67f   2c

          bpl ZERO                      //&      b680   10 14 
          adc #$80                     //&      b682   69 80                                                  
          sta $ac                      //&      b684   85 ac                                                
          bne $b68b                    //&      b686   d0 03                                                  
          jmp $b4f5                    //&      b688   4c f5 b4                                               
lb68b:
          lda $b8                      //&      b68b   a5 b8                                                
          sta $b0                      //&      b68d   85 b0                                                
          rts                          //&      b68f   60                                               
// ----------------------------------------------------------------------------
// IF (FAC) IS POSITIVE, GIVE "OVERFLOW" ERROR
// IF (FAC) IS NEGATIVE, SET FAC=0, POP ONE RETURN, AND RTS
// CALLED FROM "EXP" FUNCTION
// ----------------------------------------------------------------------------
OUTOFRNG:
          lda $b0                      //&      b690   a5 b0                                                
          eor #$ff                     //&      b692   49 ff                                                  
          bmi $b69b                    //&      b694   30 05                                                  
// ----------------------------------------------------------------------------
// POP RETURN ADDRESS AND SET FAC=0
// ----------------------------------------------------------------------------
ZERO:
          pla                          //&      b696   68                                               
          pla                          //&      b697   68                                               
          jmp $b4f1                    //&      b698   4c f1 b4                                               
JOV:
          jmp $b564                    //&      b69b   4c 64 b5                                               
// ----------------------------------------------------------------------------
// MULTIPLY FAC BY 10
// ----------------------------------------------------------------------------
MUL10:
          jsr $b7ab                    //&      b69e   20 ab b7                                               
          tax                          //&      b6a1   aa                                               
          beq $b6b4                    //&      b6a2   f0 10                                                  
          clc                          //&      b6a4   18                                               
          adc #$02                     //&      b6a5   69 02                                                  
          bcs $b69b                    //&      b6a7   b0 f2                                                  
          ldx #$00                     //&      b6a9   a2 00                                                  
          stx $b8                      //&      b6ab   86 b8                                                
          jsr $b47c                    //&      b6ad   20 7c b4                                               
          inc $ac                      //&      b6b0   e6 ac                                                
          beq $b69b                    //&      b6b2   f0 e7                                                  
lb6b4:
          rts                          //&      b6b4   60                                               
// ----------------------------------------------------------------------------
CONTEN:
          .byte   $84,$20,$00,$00        //&      b6b5   84 20 00 00                                               
// ----------------------------------------------------------------------------
// DIVIDE FAC BY 10
// ----------------------------------------------------------------------------
DIV10:
          jsr $b7ab                    //&      b6b9   20 ab b7                                               
          lda #$b5                     //&      b6bc   a9 b5                                                  
          ldy #$b6                     //&      b6be   a0 b6                                                  
          ldx #$00                     //&      b6c0   a2 00                                                  
// ----------------------------------------------------------------------------
// FAC = ARG / (Y,A)
// ----------------------------------------------------------------------------
DIV:
          stx $b8                      //&      b6c2   86 b8                                                
          jsr $b74b                    //&      b6c4   20 4b b7                                               
          jmp $b6cd                    //&      b6c7   4c cd b6                                               
// ----------------------------------------------------------------------------
// FAC = (Y,A) / FAC
// ----------------------------------------------------------------------------
FDIV:
          jsr $b64d                    //&      b6ca   20 4d b6                                               
// ----------------------------------------------------------------------------
// FAC = ARG / FAC
// ----------------------------------------------------------------------------
FDIVT:
          beq $b737                    //&      b6cd   f0 68                                                  
          jsr $b7ba                    //&      b6cf   20 ba b7                                               
          lda #$00                     //&      b6d2   a9 00                                                  
          sec                          //&      b6d4   38                                               
          sbc $ac                      //&      b6d5   e5 ac                                                
          sta $ac                      //&      b6d7   85 ac                                                
          jsr $b673                    //&      b6d9   20 73 b6                                               
          inc $ac                      //&      b6dc   e6 ac                                                
          beq $b69b                    //&      b6de   f0 bb                                                  
          ldx #$fd                     //&      b6e0   a2 fd                                                  
          lda #$01                     //&      b6e2   a9 01                                                  
lb6e4:
          ldy $b4                      //&      b6e4   a4 b4                                                
          cpy $ad                      //&      b6e6   c4 ad                                                
          bne $b6f4                    //&      b6e8   d0 0a                                                  
          ldy $b5                      //&      b6ea   a4 b5                                                
          cpy $ae                      //&      b6ec   c4 ae                                                
          bne $b6f4                    //&      b6ee   d0 04                                                  
          ldy $b6                      //&      b6f0   a4 b6                                                
          cpy $af                      //&      b6f2   c4 af                                                
lb6f4:
          php                          //&      b6f4   08                                               
          rol                          //&      b6f5   2a                                                 
          bcc $b701                    //&      b6f6   90 09                                                  
          inx                          //&      b6f8   e8                                               
          sta $77,x                    //&      b6f9   95 77                                                  
          beq $b727                    //&      b6fb   f0 2a                                                  
          bpl $b72b                    //&      b6fd   10 2c                                                  
          lda #$01                     //&      b6ff   a9 01                                                  
lb701:
          plp                          //&      b701   28                                               
          bcs $b710                    //&      b702   b0 0c                                                  
lb704:
          asl $b6                      //&      b704   06 b6                                                
          rol $b5                      //&      b706   26 b5                                                
          rol $b4                      //&      b708   26 b4                                                
          bcs $b6f4                    //&      b70a   b0 e8                                                  
          bmi $b6e4                    //&      b70c   30 d6                                                  
          bpl $b6f4                    //&      b70e   10 e4                                                  
lb710:
            tay                          //&      b710   a8                                               
          lda $b6                      //&      b711   a5 b6                                                
          sbc $af                      //&      b713   e5 af                                                
          sta $b6                      //&      b715   85 b6                                                
          lda $b5                      //&      b717   a5 b5                                                
          sbc $ae                      //&      b719   e5 ae                                                
          sta $b5                      //&      b71b   85 b5                                                
          lda $b4                      //&      b71d   a5 b4                                                
          sbc $ad                      //&      b71f   e5 ad                                                
          sta $b4                      //&      b721   85 b4                                                
          tya                          //&      b723   98                                               
          jmp $b704                    //&      b724   4c 04 b7                                               
lb727:
          lda #$40                     //&      b727   a9 40                                                  
          bne $b701                    //&      b729   d0 d6                                                  
lb72b:
          asl                          //&      b72b   0a                                                 
          asl                          //&      b72c   0a                                                 
          asl                          //&      b72d   0a                                                 
          asl                          //&      b72e   0a                                                 
          asl                          //&      b72f   0a                                                 
          asl                          //&      b730   0a                                                 
          sta $b9                      //&      b731   85 b9                                                
          plp                          //&      b733   28                                               
          jmp $b73c                    //&      b734   4c 3c b7                                               
lb737:
          ldx #$14                     //&      b737   a2 14                                                  
          jmp $a24e                    //&      b739   4c 4e a2                                               
// ----------------------------------------------------------------------------
// COPY RESULT INTO FAC MANTISSA, AND NORMALIZE
// ----------------------------------------------------------------------------
COPY_RESULT_INTO_FAC:
          lda $75                      //&      b73c   a5 75                                                
          sta $ad                      //&      b73e   85 ad                                                
          lda $76                      //&      b740   a5 76                                                
          sta $ae                      //&      b742   85 ae                                                
          lda $77                      //&      b744   a5 77                                                
          sta $af                      //&      b746   85 af                                                
          jmp $b4d5                    //&      b748   4c d5 b4                                               
// ----------------------------------------------------------------------------
// UNPACK (Y,A) INTO FAC
// ----------------------------------------------------------------------------
LOAD_FAC_FROM_YA:
          sta $71                      //&      b74b   85 71                                                
          sty $72                      //&      b74d   84 72                                                
          ldy #$03                     //&      b74f   a0 03                                                  
          lda ($71),y                   //&      b751   b1 71                                                   
          sta $af                      //&      b753   85 af                                                
          dey                          //&      b755   88                                               
          lda ($71),y                   //&      b756   b1 71                                                   
          sta $ae                      //&      b758   85 ae                                                
          dey                          //&      b75a   88                                               
          lda ($71),y                   //&      b75b   b1 71                                                   
          sta $b0                      //&      b75d   85 b0                                                
          ora #$80                     //&      b75f   09 80                                                  
          sta $ad                      //&      b761   85 ad                                                
          dey                          //&      b763   88                                               
          lda ($71),y                   //&      b764   b1 71                                                   
          sta $ac                      //&      b766   85 ac                                                
          sty $b9                      //&      b768   84 b9                                                
          rts                          //&      b76a   60                                               
// ----------------------------------------------------------------------------
// ROUND FAC, STORE IN TEMP2
// ----------------------------------------------------------------------------
STORE_FAC_IN_TEMP2_ROUNDED:
          ldx #$a8                     //&      b76b   a2 a8                                                  
          bit $a4a2                    //&      b76d   2c a2 a4                                               
// ----------------------------------------------------------------------------
// ROUND FAC, STORE IN TEMP1
// ----------------------------------------------------------------------------


          ldy #$00                     //&      b770   a0 00                                                  
          beq STORE_FAC_AT_YX_ROUNDED                    //&      b772   f0 04                                                  
// ----------------------------------------------------------------------------
// ROUND FAC, AND STORE WHERE FORPNT POINTS
// ----------------------------------------------------------------------------
SETFOR:
          ldx $97                      //&      b774   a6 97                                                
          ldy $98                      //&      b776   a4 98                                                
// ----------------------------------------------------------------------------
// ROUND FAC, AND STORE AT (Y,X)
// ----------------------------------------------------------------------------
STORE_FAC_AT_YX_ROUNDED:
          jsr $b7ba                    //&      b778   20 ba b7                                               
          stx $71                      //&      b77b   86 71                                                
          sty $72                      //&      b77d   84 72                                                
          ldy #$03                     //&      b77f   a0 03                                                  
          lda $af                      //&      b781   a5 af                                                
          sta ($71),y                   //&      b783   91 71                                                   
          dey                          //&      b785   88                                               
          lda $ae                      //&      b786   a5 ae                                                
          sta ($71),y                   //&      b788   91 71                                                   
          dey                          //&      b78a   88                                               
          lda $b0                      //&      b78b   a5 b0                                                
          ora #$7f                     //&      b78d   09 7f                                                  
          and $ad                      //&      b78f   25 ad                                                
          sta ($71),y                   //&      b791   91 71                                                   
          dey                          //&      b793   88                                               
          lda $ac                      //&      b794   a5 ac                                                
          sta ($71),y                   //&      b796   91 71                                                   
          sty $b9                      //&      b798   84 b9                                                
          rts                          //&      b79a   60                                               
// ----------------------------------------------------------------------------
// COPY ARG INTO FAC
// ----------------------------------------------------------------------------
COPY_ARG_TO_FAC:
          lda $b7                      //&      b79b   a5 b7                                                
MFA:
          sta $b0                      //&      b79d   85 b0                                                
          ldx #$04                     //&      b79f   a2 04                                                  
lb7a1:
   lda $b2,x                    //&      b7a1   b5 b2                                                  
          sta $ab,x                    //&      b7a3   95 ab                                                  
          dex                          //&      b7a5   ca                                               
          bne $b7a1                    //&      b7a6   d0 f9                                                  
          stx $b9                      //&      b7a8   86 b9                                                
          rts                          //&      b7aa   60                                               
// ----------------------------------------------------------------------------
// ROUND FAC AND COPY TO ARG
// ----------------------------------------------------------------------------
COPY_FAC_TO_ARG_ROUNDED:
          jsr $b7ba                    //&      b7ab   20 ba b7                                               
MAF:
          ldx #$05                     //&      b7ae   a2 05                                                  
lb7b0:
          lda $ab,x                    //&      b7b0   b5 ab                                                  
          sta $b2,x                    //&      b7b2   95 b2                                                  
          dex                          //&      b7b4   ca                                               
          bne $b7b0                    //&      b7b5   d0 f9                                                  
          stx $b9                      //&      b7b7   86 b9                                                
RTS14:
          rts                          //&      b7b9   60                                               
// ----------------------------------------------------------------------------
// ROUND FAC USING EXTENSION BYTE
// ----------------------------------------------------------------------------
ROUND_FAC:
          lda $ac                      //&      b7ba   a5 ac                                                
          beq $b7b9                    //&      b7bc   f0 fb                                                  
          asl $b9                      //&      b7be   06 b9                                                
          bcc $b7b9                    //&      b7c0   90 f7                                                  
// ----------------------------------------------------------------------------
// INCREMENT MANTISSA AND RE-NORMALIZE IF CARRY
// ----------------------------------------------------------------------------
INCREMENT_MANTISSA:
          jsr $b559                    //&      b7c2   20 59 b5                                               
          bne $b7b9                    //&      b7c5   d0 f2                                                  
          jmp $b52a                    //&      b7c7   4c 2a b5                                               
// ----------------------------------------------------------------------------
// TEST FAC FOR ZERO AND SIGN
//
// FAC > 0, RETURN +1
// FAC = 0, RETURN  0
// FAC < 0, RETURN -1
// ----------------------------------------------------------------------------
SIGN:
          lda $ac                      //&      b7ca   a5 ac                                                
          beq $b7d7                    //&      b7cc   f0 09                                                  
lb7ce:
          lda $b0                      //&      b7ce   a5 b0                                                
SIGN2:
          rol                          //&      b7d0   2a                                                 
          lda #$ff                     //&      b7d1   a9 ff                                                  
          bcs $b7d7                    //&      b7d3   b0 02                                                  
          lda #$01                     //&      b7d5   a9 01                                                  
RTS15:
          rts                          //&      b7d7   60                                               
// ----------------------------------------------------------------------------
// "SGN" FUNCTION
// ----------------------------------------------------------------------------
SGN:
          jsr $b7ca                    //&      b7d8   20 ca b7                                               
// ----------------------------------------------------------------------------
// CONVERT (A) INTO FAC, AS SIGNED VALUE -128 TO +127
// ----------------------------------------------------------------------------
FLOAT:
          sta $ad                      //&      b7db   85 ad                                                
          lda #$00                     //&      b7dd   a9 00                                                  
          sta $ae                      //&      b7df   85 ae                                                
          ldx #$88                     //&      b7e1   a2 88                                                  
// ----------------------------------------------------------------------------
// FLOAT UNSIGNED VALUE IN FAC+1,2
// (X) = EXPONENT
// ----------------------------------------------------------------------------
FLOAT1:
          lda $ad                      //&      b7e3   a5 ad                                                
          eor #$ff                     //&      b7e5   49 ff                                                  
          rol                          //&      b7e7   2a                                                 
// ----------------------------------------------------------------------------
// FLOAT UNSIGNED VALUE IN FAC+1,2
// (X) = EXPONENT
// C=0 TO MAKE VALUE NEGATIVE
// C=1 TO MAKE VALUE POSITIVE
// ----------------------------------------------------------------------------
FLOAT2:
          lda #$00                     //&      b7e8   a9 00                                                  
          sta $af                      //&      b7ea   85 af                                                
          stx $ac                      //&      b7ec   86 ac                                                
          sta $b9                      //&      b7ee   85 b9                                                
          sta $b0                      //&      b7f0   85 b0                                                
          jmp $b4d0                    //&      b7f2   4c d0 b4                                               
// ----------------------------------------------------------------------------
// "ABS" FUNCTION
// ----------------------------------------------------------------------------
ABS:
          lsr $b0                      //&      b7f5   46 b0                                                
          rts                          //&      b7f7   60                                               
// ----------------------------------------------------------------------------
// COMPARE FAC WITH PACKED # AT (Y,A)
// RETURN A=1,0,-1 AS (Y,A) IS <,=,> FAC
// ----------------------------------------------------------------------------
FCOMP:
          sta $73                      //&      b7f8   85 73                                                
// ----------------------------------------------------------------------------
// SPECIAL ENTRY FROM "NEXT" PROCESSOR
// "DEST" ALREADY SET UP
// ----------------------------------------------------------------------------
FCOMP2:
          sty $74                      //&      b7fa   84 74                                                
          ldy #$00                     //&      b7fc   a0 00                                                  
          lda ($73),y                   //&      b7fe   b1 73                                                   
          iny                          //&      b800   c8                                               
          tax                          //&      b801   aa                                               
          beq $b7ca                    //&      b802   f0 c6                                                  
          lda ($73),y                   //&      b804   b1 73                                                   
          eor $b0                      //&      b806   45 b0                                                
          bmi $b7ce                    //&      b808   30 c4                                                  
          cpx $ac                      //&      b80a   e4 ac                                                
          bne $b828                    //&      b80c   d0 1a                                                  
          lda ($73),y                   //&      b80e   b1 73                                                   
          ora #$80                     //&      b810   09 80                                                  
          cmp $ad                      //&      b812   c5 ad                                                
          bne $b828                    //&      b814   d0 12                                                  
          iny                          //&      b816   c8                                               
          lda ($73),y                   //&      b817   b1 73                                                   
          cmp $ae                      //&      b819   c5 ae                                                
          bne $b828                    //&      b81b   d0 0b                                                  
          iny                          //&      b81d   c8                                               
          lda #$7f                     //&      b81e   a9 7f                                                  
          cmp $b9                      //&      b820   c5 b9                                                
          lda ($73),y                   //&      b822   b1 73                                                   
          sbc $af                      //&      b824   e5 af                                                
          beq $b850                    //&      b826   f0 28                                                  
lb828:
          lda $b0                      //&      b828   a5 b0                                                
          bcc $b82e                    //&      b82a   90 02                                                  
          eor #$ff                     //&      b82c   49 ff                                                  
lb82e:
          jmp $b7d0                    //&      b82e   4c d0 b7                                               
// ----------------------------------------------------------------------------
// QUICK INTEGER FUNCTION
//
// CONVERTS FP VALUE IN FAC TO INTEGER VALUE
// IN FAC+1...FAC+4, BY SHIFTING RIGHT WITH SIGN
// EXTENSION UNTIL FRACTIONAL BITS ARE OUT.
//
// THIS SUBROUTINE ASSUMES THE EXPONENT < 32.
// ----------------------------------------------------------------------------
QINT:
          lda $ac                      //&      b831   a5 ac                                                
          beq $b87f                    //&      b833   f0 4a                                                  
          sec                          //&      b835   38                                               
          sbc #$98                     //&      b836   e9 98                                                  
          bit $b0                      //&      b838   24 b0                                                
          bpl $b845                    //&      b83a   10 09                                                  
          tax                          //&      b83c   aa                                               
          lda #$ff                     //&      b83d   a9 ff                                                  
          sta $b2                      //&      b83f   85 b2                                                
          jsr $b53d                    //&      b841   20 3d b5                                               
          txa                          //&      b844   8a                                               
lb845:
          ldx #$ac                     //&      b845   a2 ac                                                  
          cmp #$f9                     //&      b847   c9 f9                                                  
          bpl $b851                    //&      b849   10 06                                                  
          jsr $b57b                    //&      b84b   20 7b b5                                               
          sty $b2                      //&      b84e   84 b2                                                
lb850:
          rts                          //&      b850   60                                               
QINT2:
          tay                          //&      b851   a8                                               
          lda $b0                      //&      b852   a5 b0                                                
          and #$80                     //&      b854   29 80                                                  
          lsr $ad                      //&      b856   46 ad                                                
          ora $ad                      //&      b858   05 ad                                                
          sta $ad                      //&      b85a   85 ad                                                
          jsr $b592                    //&      b85c   20 92 b5                                               
          sty $b2                      //&      b85f   84 b2                                                
          rts                          //&      b861   60                                               
// ----------------------------------------------------------------------------
// "INT" FUNCTION
//
// USES QINT TO CONVERT (FAC) TO INTEGER FORM,
// AND THEN REFLOATS THE INTEGER.
// ----------------------------------------------------------------------------
INT:
          lda $ac                      //&      b862   a5 ac                                                
          cmp #$98                     //&      b864   c9 98                                                  
          bcs $b886                    //&      b866   b0 1e                                                  
          jsr $b831                    //&      b868   20 31 b8                                               
          sty $b9                      //&      b86b   84 b9                                                
          lda $b0                      //&      b86d   a5 b0                                                
          sty $b0                      //&      b86f   84 b0                                                
          eor #$80                     //&      b871   49 80                                                  
          rol                          //&      b873   2a                                                 
          lda #$98                     //&      b874   a9 98                                                  
          sta $ac                      //&      b876   85 ac                                                
          lda $af                      //&      b878   a5 af                                                
          sta $5b                      //&      b87a   85 5b                                                
          jmp $b4d0                    //&      b87c   4c d0 b4                                               
QINT3:
          sta $ad                      //&      b87f   85 ad                                                
          sta $ae                      //&      b881   85 ae                                                
          sta $af                      //&      b883   85 af                                                
          tay                          //&      b885   a8                                               
RTS17:
          rts                          //&      b886   60                                               
// ----------------------------------------------------------------------------
// CONVERT STRING TO FP VALUE IN FAC
//
// STRING POINTED TO BY TXTPTR
// FIRST CHAR ALREADY SCANNED BY CHRGET
// (A) = FIRST CHAR, C=0 IF DIGIT.
// ----------------------------------------------------------------------------
FIN:
          ldy #$00                     //&      b887   a0 00                                                  
          ldx #$09                     //&      b889   a2 09                                                  
lb88b:
          sty $a8,x                    //&      b88b   94 a8                                                  
          dex                          //&      b88d   ca                                               
          bpl $b88b                    //&      b88e   10 fb                                                  
          bcc $b8a1                    //&      b890   90 0f                                                  
          cmp #$2d                     //&      b892   c9 2d                                                  
          bne $b89a                    //&      b894   d0 04                                                  
          stx $b1                      //&      b896   86 b1                                                
          beq $b89e                    //&      b898   f0 04                                                  
lb89a:
          cmp #$2b                     //&      b89a   c9 2b                                                  
          bne $b8a3                    //&      b89c   d0 05                                                  
FIN1:
          jsr $00bc                    //&      b89e   20 bc 00                                               
FIN2:
          bcc $b8fe                    //&      b8a1   90 5b                                                  
FIN3:
          cmp #$2e                     //&      b8a3   c9 2e                                                  
          beq $b8d5                    //&      b8a5   f0 2e                                                  
          cmp #$45                     //&      b8a7   c9 45                                                  
          bne $b8db                    //&      b8a9   d0 30                                                  
          jsr $00bc                    //&      b8ab   20 bc 00                                               
          bcc $b8c7                    //&      b8ae   90 17                                                  
          cmp #$a4                     //&      b8b0   c9 a4                                                  
          beq $b8c2                    //&      b8b2   f0 0e                                                  
          cmp #$2d                     //&      b8b4   c9 2d                                                  
          beq $b8c2                    //&      b8b6   f0 0a                                                  
          cmp #$a3                     //&      b8b8   c9 a3                                                  
          beq $b8c4                    //&      b8ba   f0 08                                                  
          cmp #$2b                     //&      b8bc   c9 2b                                                  
          beq $b8c4                    //&      b8be   f0 04                                                  
          bne $b8c9                    //&      b8c0   d0 07                                                  
lb8c2:
          ror $ab                      //&      b8c2   66 ab                                                
FIN4:
          jsr $00bc                    //&      b8c4   20 bc 00                                               
FIN5:
          bcc $b925                    //&      b8c7   90 5c                                                  
FIN6:
          bit $ab                      //&      b8c9   24 ab                                                
          bpl $b8db                    //&      b8cb   10 0e                                                  
          lda #$00                     //&      b8cd   a9 00                                                  
          sec                          //&      b8cf   38                                               
          sbc $a9                      //&      b8d0   e5 a9                                                
          jmp $b8dd                    //&      b8d2   4c dd b8                                               
// ----------------------------------------------------------------------------
// FOUND A DECIMAL POINT
// ----------------------------------------------------------------------------
FIN10:
          ror $aa                      //&      b8d5   66 aa                                                
          bit $aa                      //&      b8d7   24 aa                                                
          bvc $b89e                    //&      b8d9   50 c3                                                  
// ----------------------------------------------------------------------------
// NUMBER TERMINATED, ADJUST EXPONENT NOW
// ----------------------------------------------------------------------------
FIN7:
          lda $a9                      //&      b8db   a5 a9                                                
FIN8:
          sec                          //&      b8dd   38                                               
          sbc $a8                      //&      b8de   e5 a8                                                
          sta $a9                      //&      b8e0   85 a9                                                
          beq $b8f6                    //&      b8e2   f0 12                                                  
          bpl $b8ef                    //&      b8e4   10 09                                                  
lb8e6:
          jsr $b6b9                    //&      b8e6   20 b9 b6                                               
          inc $a9                      //&      b8e9   e6 a9                                                
          bne $b8e6                    //&      b8eb   d0 f9                                                  
          beq $b8f6                    //&      b8ed   f0 07                                                  
lb8ef:
          jsr $b69e                    //&      b8ef   20 9e b6                                               
          dec $a9                      //&      b8f2   c6 a9                                                
          bne $b8ef                    //&      b8f4   d0 f9                                                  
lb8f6:
          lda $b1                      //&      b8f6   a5 b1                                                
          bmi $b8fb                    //&      b8f8   30 01                                                  
          rts                          //&      b8fa   60                                               
lb8fb:
          jmp $baef                    //&      b8fb   4c ef ba                                               
// ----------------------------------------------------------------------------
// ACCUMULATE A DIGIT INTO FAC
// ----------------------------------------------------------------------------
FIN9:
          pha                          //&      b8fe   48                                               
          bit $aa                      //&      b8ff   24 aa                                                
          bpl $b905                    //&      b901   10 02                                                  
          inc $a8                      //&      b903   e6 a8                                                
lb905:
          jsr $b69e                    //&      b905   20 9e b6                                               
          pla                          //&      b908   68                                               
          sec                          //&      b909   38                                               
          sbc #$30                     //&      b90a   e9 30                                                  
          jsr $b912                    //&      b90c   20 12 b9                                               
          jmp $b89e                    //&      b90f   4c 9e b8                                               
// ----------------------------------------------------------------------------
// ADD (A) TO FAC
// ----------------------------------------------------------------------------
ADDACC:
          pha                          //&      b912   48                                               
          jsr $b7ab                    //&      b913   20 ab b7                                               
          pla                          //&      b916   68                                               
          jsr $b7db                    //&      b917   20 db b7                                               
          lda $b7                      //&      b91a   a5 b7                                                
          eor $b0                      //&      b91c   45 b0                                                
          sta $b8                      //&      b91e   85 b8                                                
          ldx $ac                      //&      b920   a6 ac                                                
          jmp $b46f                    //&      b922   4c 6f b4                                               
// ----------------------------------------------------------------------------
// ACCUMULATE DIGIT OF EXPONENT
// ----------------------------------------------------------------------------
GETEXP:
          lda $a9                      //&      b925   a5 a9                                                
          cmp #$0a                     //&      b927   c9 0a                                                  
          bcc $b934                    //&      b929   90 09                                                  
          lda #$64                     //&      b92b   a9 64                                                  
          bit $ab                      //&      b92d   24 ab                                                
          bmi $b942                    //&      b92f   30 11                                                  
          jmp $b564                    //&      b931   4c 64 b5                                               
lb934:
          asl                          //&      b934   0a                                                 
          asl                          //&      b935   0a                                                 
          clc                          //&      b936   18                                               
          adc $a9                      //&      b937   65 a9                                                
          asl                          //&      b939   0a                                                 
          clc                          //&      b93a   18                                               
          ldy #$00                     //&      b93b   a0 00                                                  
          adc ($c3),y                   //&      b93d   71 c3                                                   
          sec                          //&      b93f   38                                               
          sbc #$30                     //&      b940   e9 30                                                  
lb942:
          sta $a9                      //&      b942   85 a9                                                
          jmp $b8c4                    //&      b944   4c c4 b8                                               
// ----------------------------------------------------------------------------
// these values are /1000 of what the labels say
          sta ($43),y                   //&      b947   91 43                                                   
          .byte $4f                    //&      b949   4f         %01001111 'O'                                                     
          sed                          //&      b94a   f8                                               
          sty $74,x                    //&      b94b   94 74                                                  
          .byte $23                    //&      b94d   23         %00100011 '#'                                                     
          .byte $f7                    //&      b94e   f7         %11110111                                                     
          sty $74,x                    //&      b94f   94 74                                                  
          bit $00                      //&      b951   24 00                                                
// ----------------------------------------------------------------------------
// PRINT "IN <LINE #>"
// ----------------------------------------------------------------------------
INPRT:
          lda #$8d                     //&      b953   a9 8d                                                  
          ldy #$a1                     //&      b955   a0 a1                                                  
          jsr $b96b                    //&      b957   20 6b b9                                               
          lda $88                      //&      b95a   a5 88                                                
          ldx $87                      //&      b95c   a6 87                                                
// ----------------------------------------------------------------------------
// PRINT A,X AS DECIMAL INTEGER
// ----------------------------------------------------------------------------
LINPRT:
          sta $ad                      //&      b95e   85 ad                                                
          stx $ae                      //&      b960   86 ae                                                
          ldx #$90                     //&      b962   a2 90                                                  
          sec                          //&      b964   38                                               
          jsr $b7e8                    //&      b965   20 e8 b7                                               
          jsr $b96e                    //&      b968   20 6e b9                                               
GOSTROUT2:
          jmp $a8c3                    //&      b96b   4c c3 a8                                               
// ----------------------------------------------------------------------------
// CONVERT (FAC) TO STRING STARTING AT STACK
// RETURN WITH (Y,A) POINTING AT STRING
// ----------------------------------------------------------------------------
FOUT:
          ldy #$01                     //&      b96e   a0 01                                                  
// ----------------------------------------------------------------------------
// "STR$" FUNCTION ENTERS HERE, WITH (Y)=0
// SO THAT RESULT STRING STARTS AT STACK-1
// (THIS IS USED AS A FLAG)
// ----------------------------------------------------------------------------
FOUT1:
          lda #$20                     //&      b970   a9 20                                                  
          bit $b0                      //&      b972   24 b0                                                
          bpl $b978                    //&      b974   10 02                                                  
          lda #$2d                     //&      b976   a9 2d                                                  
lb978:
          sta $00ff,y                   //&      b978   99 ff 00                                                 
          sta $b0                      //&      b97b   85 b0                                                
          sty $ba                      //&      b97d   84 ba                                                
          iny                          //&      b97f   c8                                               
          lda #$30                     //&      b980   a9 30                                                  
          ldx $ac                      //&      b982   a6 ac                                                
          bne $b989                    //&      b984   d0 03                                                  
          jmp $ba89                    //&      b986   4c 89 ba                                               
lb989:
          lda #$00                     //&      b989   a9 00                                                  
          cpx #$80                     //&      b98b   e0 80                                                  
          beq $b991                    //&      b98d   f0 02                                                  
          bcs $b99a                    //&      b98f   b0 09                                                  
lb991:
          lda #$4f                     //&      b991   a9 4f                                                  
          ldy #$b9                     //&      b993   a0 b9                                                  
          jsr FMULT                    //&      b995   20 fb b5                                               
          lda #$fa                     //&      b998   a9 fa                                                  
// ----------------------------------------------------------------------------
// ADJUST UNTIL 1E8 <= (FAC) <1E9
// ----------------------------------------------------------------------------
lb99a:
          sta $a8                      //&      b99a   85 a8                                                
lb99c:
          lda #$4b                     //&      b99c   a9 4b                                                  
          ldy #$b9                     //&      b99e   a0 b9                                                  
          jsr $b7f8                    //&      b9a0   20 f8 b7                                               
          beq $b9c3                    //&      b9a3   f0 1e                                                  
          bpl $b9b9                    //&      b9a5   10 12                                                  
lb9a7:
          lda #$47                     //&      b9a7   a9 47                                                  
          ldy #$b9                     //&      b9a9   a0 b9                                                  
          jsr $b7f8                    //&      b9ab   20 f8 b7                                               
          beq $b9b2                    //&      b9ae   f0 02                                                  
          bpl $b9c0                    //&      b9b0   10 0e                                                  
lb9b2:
          jsr $b69e                    //&      b9b2   20 9e b6                                               
          dec $a8                      //&      b9b5   c6 a8                                                
          bne $b9a7                    //&      b9b7   d0 ee                                                  
lb9b9:
          jsr $b6b9                    //&      b9b9   20 b9 b6                                               
          inc $a8                      //&      b9bc   e6 a8                                                
          bne $b99c                    //&      b9be   d0 dc                                                  
lb9c0:
          jsr $b44e                    //&      b9c0   20 4e b4                                               
lb9c3:
          jsr $b831                    //&      b9c3   20 31 b8                                               
// ----------------------------------------------------------------------------
// FAC+1...FAC+4 IS NOW IN INTEGER FORM
// WITH POWER OF TEN ADJUSTMENT IN TMPEXP
//
// IF -10 < TMPEXP > 1, PRINT IN DECIMAL FORM
// OTHERWISE, PRINT IN EXPONENTIAL FORM
// ----------------------------------------------------------------------------
          ldx #$01                     //&      b9c6   a2 01                                                  
          lda $a8                      //&      b9c8   a5 a8                                                
          clc                          //&      b9ca   18                                               
          adc #$07                     //&      b9cb   69 07                                                  
          bmi $b9d8                    //&      b9cd   30 09                                                  
          cmp #$08                     //&      b9cf   c9 08                                                  
          bcs $b9d9                    //&      b9d1   b0 06                                                  
          adc #$ff                     //&      b9d3   69 ff                                                  
          tax                          //&      b9d5   aa                                               
          lda #$02                     //&      b9d6   a9 02                                                  
lb9d8:
          sec                          //&      b9d8   38                                               
lb9d9:
          sbc #$02                     //&      b9d9   e9 02                                                  
          sta $a9                      //&      b9db   85 a9                                                
          stx $a8                      //&      b9dd   86 a8                                                
          txa                          //&      b9df   8a                                               
          beq $b9e4                    //&      b9e0   f0 02                                                  
          bpl $b9f7                    //&      b9e2   10 13                                                  
lb9e4:
          ldy $ba                      //&      b9e4   a4 ba                                                
          lda #$2e                     //&      b9e6   a9 2e                                                  
          iny                          //&      b9e8   c8                                               
          sta $00ff,y                   //&      b9e9   99 ff 00                                                 
          txa                          //&      b9ec   8a                                               
          beq $b9f5                    //&      b9ed   f0 06                                                  
          lda #$30                     //&      b9ef   a9 30                                                  
          iny                          //&      b9f1   c8                                               
          sta $00ff,y                   //&      b9f2   99 ff 00                                                 
lb9f5:
          sty $ba                      //&      b9f5   84 ba                                                
// ----------------------------------------------------------------------------
// NOW DIVIDE BY POWERS OF TEN TO GET SUCCESSIVE DIGITS
// ----------------------------------------------------------------------------
lb9f7:
          ldy #$00                     //&      b9f7   a0 00                                                  
          ldx #$80                     //&      b9f9   a2 80                                                  
lb9fb:
          lda $af                      //&      b9fb   a5 af                                                
          clc                          //&      b9fd   18                                               
          adc $ba9c,y                   //&      b9fe   79 9c ba                                                 
          sta $af                      //&      ba01   85 af                                                
          lda $ae                      //&      ba03   a5 ae                                                
          adc $ba9b,y                   //&      ba05   79 9b ba                                                 
          sta $ae                      //&      ba08   85 ae                                                
          lda $ad                      //&      ba0a   a5 ad                                                
          adc $ba9a,y                   //&      ba0c   79 9a ba                                                 
          sta $ad                      //&      ba0f   85 ad                                                
          inx                          //&      ba11   e8                                               
          bcs $ba18                    //&      ba12   b0 04                                                  
          bpl $b9fb                    //&      ba14   10 e5                                                  
          bmi $ba1a                    //&      ba16   30 02                                                  
lba18:
          bmi $b9fb                    //&      ba18   30 e1                                                  
lba1a:
          txa                          //&      ba1a   8a                                               
          bcc $ba21                    //&      ba1b   90 04                                                  
          eor #$ff                     //&      ba1d   49 ff                                                  
          adc #$0a                     //&      ba1f   69 0a                                                  
lba21:
          adc #$2f                     //&      ba21   69 2f                                                  
          iny                          //&      ba23   c8                                               
          iny                          //&      ba24   c8                                               
          iny                          //&      ba25   c8                                               
          sty $95                      //&      ba26   84 95                                                
          ldy $ba                      //&      ba28   a4 ba                                                
          iny                          //&      ba2a   c8                                               
          tax                          //&      ba2b   aa                                               
          and #$7f                     //&      ba2c   29 7f                                                  
          sta $00ff,y                   //&      ba2e   99 ff 00                                                 
          dec $a8                      //&      ba31   c6 a8                                                
          bne $ba3b                    //&      ba33   d0 06                                                  
          lda #$2e                     //&      ba35   a9 2e                                                  
          iny                          //&      ba37   c8                                               
          sta $00ff,y                   //&      ba38   99 ff 00                                                 
lba3b:
          sty $ba                      //&      ba3b   84 ba                                                
          ldy $95                      //&      ba3d   a4 95                                                
          txa                          //&      ba3f   8a                                               
          eor #$ff                     //&      ba40   49 ff                                                  
          and #$80                     //&      ba42   29 80                                                  
          tax                          //&      ba44   aa                                               
          cpy #$12                     //&      ba45   c0 12                                                  
          bne $b9fb                    //&      ba47   d0 b2                                                  
// ----------------------------------------------------------------------------
// NINE DIGITS HAVE BEEN STORED IN STRING.  NOW LOOK
// BACK AND LOP OFF TRAILING ZEROES AND A TRAILING
// DECIMAL POINT.
// ----------------------------------------------------------------------------
          ldy $ba                      //&      ba49   a4 ba                                                
lba4b:
          lda $00ff,y                   //&      ba4b   b9 ff 00                                                 
          dey                          //&      ba4e   88                                               
          cmp #$30                     //&      ba4f   c9 30                                                  
          beq $ba4b                    //&      ba51   f0 f8                                                  
          cmp #$2e                     //&      ba53   c9 2e                                                  
          beq $ba58                    //&      ba55   f0 01                                                  
          iny                          //&      ba57   c8                                               
lba58:
          lda #$2b                     //&      ba58   a9 2b                                                  
          ldx $a9                      //&      ba5a   a6 a9                                                
          beq $ba8c                    //&      ba5c   f0 2e                                                  
          bpl $ba68                    //&      ba5e   10 08                                                  
          lda #$00                     //&      ba60   a9 00                                                  
          sec                          //&      ba62   38                                               
          sbc $a9                      //&      ba63   e5 a9                                                
          tax                          //&      ba65   aa                                               
          lda #$2d                     //&      ba66   a9 2d                                                  
lba68:
          sta $0101,y                   //&      ba68   99 01 01                                                 
          lda #$45                     //&      ba6b   a9 45                                                  
          sta $0100,y                   //&      ba6d   99 00 01                                                 
          txa                          //&      ba70   8a                                               
          ldx #$2f                     //&      ba71   a2 2f                                                  
          sec                          //&      ba73   38                                               
lba74:
          inx                          //&      ba74   e8                                               
          sbc #$0a                     //&      ba75   e9 0a                                                  
          bcs $ba74                    //&      ba77   b0 fb                                                  
          adc #$3a                     //&      ba79   69 3a                                                  
          sta $0103,y                   //&      ba7b   99 03 01                                                 
          txa                          //&      ba7e   8a                                               
          sta $0102,y                   //&      ba7f   99 02 01                                                 
          lda #$00                     //&      ba82   a9 00                                                  
          sta $0104,y                   //&      ba84   99 04 01                                                 
          beq $ba91                    //&      ba87   f0 08                                                  
lba89:
          sta $00ff,y                   //&      ba89   99 ff 00                                                 
lba8c:
          lda #$00                     //&      ba8c   a9 00                                                  
          sta $0100,y                   //&      ba8e   99 00 01                                                 
lba91:
          lda #$00                     //&      ba91   a9 00                                                  
          ldy #$01                     //&      ba93   a0 01                                                  
          rts                          //&      ba95   60                                               
// ----------------------------------------------------------------------------
CON_HALF:
          .byte $80                    //&      ba96   80         %10000000                                                     
          brk                          //&      ba97   00                                               
          brk                          //&      ba98   00                                               
          brk                          //&      ba99   00                                               
// ----------------------------------------------------------------------------
// POWERS OF 10 FROM 1E8 DOWN TO 1,
// AS 32-BIT INTEGERS, WITH ALTERNATING SIGNS
// ----------------------------------------------------------------------------
DECTBL:
    .byte $FE,$79,$60 // -100000       // ba9a fe 79 60
		.byte	$00,$27,$10 // 10000         // ba9d 00 27 10
		.byte	$FF,$FC,$18 // -1000         // baa0 ff fc 18
		.byte	$00,$00,$64 // 100           // baa3 00 00 64
		.byte	$FF,$FF,$F6 // -10           // baa6 ff ff f6
		.byte	$00,$00,$01 // 1             // bab9 00 00 01
DECTBL_END:
// ----------------------------------------------------------------------------
// "SQR" FUNCTION
// ----------------------------------------------------------------------------
SQR:
          jsr $b7ab                    //&      baac   20 ab b7                                                 
          // .byte $ab                    //&      baad   ab         %10101011                                                     
          // .byte $b7                    //&      baae   b7         %10110111                                                     
          lda #$96                     //&      baaf   a9 96                                                  
          ldy #$ba                     //&      bab1   a0 ba                                                  
          jsr $b74b                    //&      bab3   20 4b b7                                               
// ----------------------------------------------------------------------------
// EXPONENTIATION OPERATION
//
// ARG ^ FAC  =  EXP( LOG(ARG) * FAC )
// ----------------------------------------------------------------------------
FPWRT:
          beq $bb1b                    //&      bab6   f0 63                                                  
          lda $b3                      //&      bab8   a5 b3                                                
          bne $babf                    //&      baba   d0 03                                                  
          jmp $b4f3                    //&      babc   4c f3 b4                                               
lbabf:
          ldx #$9c                     //&      babf   a2 9c                                                  
          ldy #$00                     //&      bac1   a0 00                                                  
          jsr STORE_FAC_AT_YX_ROUNDED                    //&      bac3   20 78 b7                                               
          lda $b7                      //&      bac6   a5 b7                                                
          bpl $bad9                    //&      bac8   10 0f                                                  
          jsr $b862                    //&      baca   20 62 b8                                               
          lda #$9c                     //&      bacd   a9 9c                                                  
          ldy #$00                     //&      bacf   a0 00                                                  
          jsr $b7f8                    //&      bad1   20 f8 b7                                               
          bne $bad9                    //&      bad4   d0 03                                                  
          tya                          //&      bad6   98                                               
          ldy $5b                      //&      bad7   a4 5b                                                
lbad9:
          jsr $b79d                    //&      bad9   20 9d b7                                               
          tya                          //&      badc   98                                               
          pha                          //&      badd   48                                               
          jsr $b5bd                    //&      bade   20 bd b5                                               
          lda #$9c                     //&      bae1   a9 9c                                                  
          ldy #$00                     //&      bae3   a0 00                                                  
          jsr FMULT                    //&      bae5   20 fb b5                                               
          jsr $bb1b                    //&      bae8   20 1b bb                                               
          pla                          //&      baeb   68                                               
          lsr                          //&      baec   4a                                                 
          bcc $baf9                    //&      baed   90 0a                                                  
// ----------------------------------------------------------------------------
// NEGATE VALUE IN FAC
// ----------------------------------------------------------------------------
NEGOP:
   lda $ac                      //&      baef   a5 ac                                                
          beq $baf9                    //&      baf1   f0 06                                                  
          lda $b0                      //&      baf3   a5 b0                                                
          eor #$ff                     //&      baf5   49 ff                                                  
          sta $b0                      //&      baf7   85 b0                                                
lbaf9:
          rts                          //&      baf9   60                                               
// ----------------------------------------------------------------------------
CON_LOG_E:
          sta ($38,x)                   //&      bafa   81 38                                                   
          tax                          //&      bafc   aa                                               
          .byte $3b                    //&      bafd   3b         %00111011 ''                                                     
POLY_EXP:
		.byte	$06                          // bafe 06   
		.byte	$74,$63,$90,$8C              // baff 74 63 90 8C
		.byte	$77,$23,$0C,$AB              // bb03 77 23 0C AB
		.byte	$7A,$1E,$94,$00              // bb07 7A 1E 94 00
		.byte	$7C,$63,$42,$80              // bb0b 7C 63 42 80
		.byte	$7E,$75,$FE,$D0              // bb0f 7E 75 FE D0
		.byte	$80,$31,$72,$15              // bb13 80 31 72 15
		.byte	$81,$00,$00,$00              // bb17 81 00 00 00                                            
// ----------------------------------------------------------------------------
// "EXP" FUNCTION
//
// FAC = E ^ FAC
// ----------------------------------------------------------------------------
EXP:   
          lda #$fa                     //&      bb1b   a9 fa                                                  
          ldy #$ba                     //&      bb1d   a0 ba                                                  
          jsr FMULT                    //&      bb1f   20 fb b5                                               
          lda $b9                      //&      bb22   a5 b9                                                
          adc #$50                     //&      bb24   69 50                                                  
          bcc $bb2b                    //&      bb26   90 03                                                  
          jsr $b7c2                    //&      bb28   20 c2 b7                                               
lbb2b:
          sta $a3                      //&      bb2b   85 a3                                                
          jsr $b7ae                    //&      bb2d   20 ae b7                                               
          lda $ac                      //&      bb30   a5 ac                                                
          cmp #$88                     //&      bb32   c9 88                                                  
          bcc $bb39                    //&      bb34   90 03                                                  
lbb36:
          jsr $b690                    //&      bb36   20 90 b6                                               
lbb39:
          jsr $b862                    //&      bb39   20 62 b8                                               
          lda $5b                      //&      bb3c   a5 5b                                                
          clc                          //&      bb3e   18                                               
          adc #$81                     //&      bb3f   69 81                                                  
          beq $bb36                    //&      bb41   f0 f3                                                  
          sec                          //&      bb43   38                                               
          sbc #$01                     //&      bb44   e9 01                                                  
          pha                          //&      bb46   48                                               
          ldx #$04                     //&      bb47   a2 04                                                  
lbb49:
          lda $b3,x                    //&      bb49   b5 b3                                                  
          ldy $ac,x                    //&      bb4b   b4 ac                                                  
          sta $ac,x                    //&      bb4d   95 ac                                                  
          sty $b3,x                    //&      bb4f   94 b3                                                  
          dex                          //&      bb51   ca                                               
          bpl $bb49                    //&      bb52   10 f5                                                  
          lda $a3                      //&      bb54   a5 a3                                                
          sta $b9                      //&      bb56   85 b9                                                
          jsr $b458                    //&      bb58   20 58 b4                                               
          jsr $baef                    //&      bb5b   20 ef ba                                               
          lda #$fe                     //&      bb5e   a9 fe                                                  
          ldy #$ba                     //&      bb60   a0 ba                                                  
          jsr $bb84                    //&      bb62   20 84 bb                                               
          lda #$00                     //&      bb65   a9 00                                                  
          sta $b8                      //&      bb67   85 b8                                                
          pla                          //&      bb69   68                                               
          jsr $b675                    //&      bb6a   20 75 b6                                               
          rts                          //&      bb6d   60                                               
// ----------------------------------------------------------------------------
// ODD POLYNOMIAL SUBROUTINE
//
// F(X) = X * P(X^2)
//
// WHERE:  X IS VALUE IN FAC
//	Y,A POINTS AT COEFFICIENT TABLE
//	FIRST BYTE OF COEFF. TABLE IS N
//	COEFFICIENTS FOLLOW, HIGHEST POWER FIRST
//
// P(X^2) COMPUTED USING NORMAL POLYNOMIAL SUBROUTINE
// ----------------------------------------------------------------------------
POLYNOMIAL_ODD:
          sta $ba                      //&      bb6e   85 ba                                                
          sty $bb                      //&      bb70   84 bb                                                
          jsr $b76e                    //&      bb72   20 6e b7                                               
          lda #$a4                     //&      bb75   a9 a4                                                  
          jsr FMULT                    //&      bb77   20 fb b5                                               
          jsr $bb88                    //&      bb7a   20 88 bb                                               
          lda #$a4                     //&      bb7d   a9 a4                                                  
          ldy #$00                     //&      bb7f   a0 00                                                  
          jmp FMULT                    //&      bb81   4c fb b5                                               
// ----------------------------------------------------------------------------
// NORMAL POLYNOMIAL SUBROUTINE
//
// P(X) = C(0)*X^N + C(1)*X^(N-1) + ... + C(N)
//
// WHERE:  X IS VALUE IN FAC
//	Y,A POINTS AT COEFFICIENT TABLE
//	FIRST BYTE OF COEFF. TABLE IS N
//	COEFFICIENTS FOLLOW, HIGHEST POWER FIRST
// ----------------------------------------------------------------------------
POLYNOMIAL:
          sta $ba                      //&      bb84   85 ba                                                
          sty $bb                      //&      bb86   84 bb                                                
SERMAIN:
          jsr $b76b                    //&      bb88   20 6b b7                                               
          lda ($ba),y                   //&      bb8b   b1 ba                                                   
          sta $b1                      //&      bb8d   85 b1                                                
          ldy $ba                      //&      bb8f   a4 ba                                                
          iny                          //&      bb91   c8                                               
          tya                          //&      bb92   98                                               
          bne $bb97                    //&      bb93   d0 02                                                  
          inc $bb                      //&      bb95   e6 bb                                                
lbb97:
   sta $ba                      //&      bb97   85 ba                                                
          ldy $bb                      //&      bb99   a4 bb                                                
lbb9b:
   jsr FMULT                    //&      bb9b   20 fb b5                                               
          lda $ba                      //&      bb9e   a5 ba                                                
          ldy $bb                      //&      bba0   a4 bb                                                
          clc                          //&      bba2   18                                               
          adc #$04                     //&      bba3   69 04                                                  
          bcc $bba8                    //&      bba5   90 01                                                  
          iny                          //&      bba7   c8                                               
lbba8:
   sta $ba                      //&      bba8   85 ba                                                
          sty $bb                      //&      bbaa   84 bb                                                
          jsr $b46c                    //&      bbac   20 6c b4                                               
          lda #$a8                     //&      bbaf   a9 a8                                                  
          ldy #$00                     //&      bbb1   a0 00                                                  
          dec $b1                      //&      bbb3   c6 b1                                                
          bne $bb9b                    //&      bbb5   d0 e4                                                  
lbbb7:
          rts                          //&      bbb7   60                                               
// ----------------------------------------------------------------------------
// "RND" FUNCTION
// ----------------------------------------------------------------------------
CONRND1:
          tya                          //&      bbb8   98                                               
          and $44,x                    //&      bbb9   35 44                                                  
          .byte $7a                    //&      bbbb   7a         %01111010 'z'                                                     
CONRND2:
          pla                          //&      bbbc   68                                               
          plp                          //&      bbbd   28                                               
          lda ($46),y                   //&      bbbe   b1 46                                                   
RND:
          jsr $b7ca                    //&      bbc0   20 ca b7                                               
          tax                          //&      bbc3   aa                                               
          bmi $bbde                    //&      bbc4   30 18                                                  
          lda #$d4                     //&      bbc6   a9 d4                                                  
          ldy #$00                     //&      bbc8   a0 00                                                  
          jsr $b74b                    //&      bbca   20 4b b7                                               
          txa                          //&      bbcd   8a                                               
          beq $bbb7                    //&      bbce   f0 e7                                                  
          lda #$b8                     //&      bbd0   a9 b8                                                  
          ldy #$bb                     //&      bbd2   a0 bb                                                  
          jsr FMULT                    //&      bbd4   20 fb b5                                               
          lda #$bc                     //&      bbd7   a9 bc                                                  
          ldy #$bb                     //&      bbd9   a0 bb                                                  
          jsr $b46c                    //&      bbdb   20 6c b4                                               
lbbde:
          ldx $af                      //&      bbde   a6 af                                                
          lda $ad                      //&      bbe0   a5 ad                                                
          sta $af                      //&      bbe2   85 af                                                
          stx $ad                      //&      bbe4   86 ad                                                
          lda #$00                     //&      bbe6   a9 00                                                  
          sta $b0                      //&      bbe8   85 b0                                                
          lda $ac                      //&      bbea   a5 ac                                                
          sta $b9                      //&      bbec   85 b9                                                
          lda #$80                     //&      bbee   a9 80                                                  
          sta $ac                      //&      bbf0   85 ac                                                
          jsr $b4d5                    //&      bbf2   20 d5 b4                                               
          ldx #$d4                     //&      bbf5   a2 d4                                                  
          ldy #$00                     //&      bbf7   a0 00                                                  
GOMOVMF:
          jmp STORE_FAC_AT_YX_ROUNDED                    //&      bbf9   4c 78 b7                                               
// ----------------------------------------------------------------------------
// "COS" FUNCTION
// ----------------------------------------------------------------------------
COS:
          lda #$78                     //&      bbfc   a9 78                                                  
          ldy #$bc                     //&      bbfe   a0 bc                                                  
          jsr $b46c                    //&      bc00   20 6c b4                                               
// ----------------------------------------------------------------------------
// "SIN" FUNCTION
// ----------------------------------------------------------------------------
SIN:
          jsr $b7ab                    //&      bc03   20 ab b7                                               
          lda #$7c                     //&      bc06   a9 7c                                                  
          ldy #$bc                     //&      bc08   a0 bc                                                  
          ldx $b7                      //&      bc0a   a6 b7                                                
          jsr $b6c2                    //&      bc0c   20 c2 b6                                               
          jsr $b7ab                    //&      bc0f   20 ab b7                                               
          jsr $b862                    //&      bc12   20 62 b8                                               
          lda #$00                     //&      bc15   a9 00                                                  
          sta $b8                      //&      bc17   85 b8                                                
          jsr $b458                    //&      bc19   20 58 b4                                               
// ----------------------------------------------------------------------------
// (FAC) = ANGLE AS A FRACTION OF A FULL CIRCLE
//
// NOW FOLD THE RANGE INTO A QUARTER CIRCLE
//
// <<< THERE ARE MUCH SIMPLER WAYS TO DO THIS >>>
// ----------------------------------------------------------------------------
          lda #$80                     //&      bc1c   a9 80                                                  
          ldy #$bc                     //&      bc1e   a0 bc                                                  
          jsr $b455                    //&      bc20   20 55 b4                                               
          lda $b0                      //&      bc23   a5 b0                                                
          pha                          //&      bc25   48                                               
          bpl $bc35                    //&      bc26   10 0d                                                  
          jsr $b44e                    //&      bc28   20 4e b4                                               
          lda $b0                      //&      bc2b   a5 b0                                                
          bmi $bc38                    //&      bc2d   30 09                                                  
          lda $63                      //&      bc2f   a5 63                                                
          eor #$ff                     //&      bc31   49 ff                                                  
          sta $63                      //&      bc33   85 63                                                
// ----------------------------------------------------------------------------
// IF FALL THRU, RANGE IS 0...1/2
// IF BRANCH HERE, RANGE IS 0...1/4
// ----------------------------------------------------------------------------
SIN1:
          jsr $baef                    //&      bc35   20 ef ba                                               
// ----------------------------------------------------------------------------
// IF FALL THRU, RANGE IS -1/2...0
// IF BRANCH HERE, RANGE IS -1/4...0
// ----------------------------------------------------------------------------
L3F5B:
          lda #$80                     //&      bc38   a9 80                                                  
          ldy #$bc                     //&      bc3a   a0 bc                                                  
          jsr $b46c                    //&      bc3c   20 6c b4                                               
          pla                          //&      bc3f   68                                               
          bpl $bc45                    //&      bc40   10 03                                                  
          jsr $baef                    //&      bc42   20 ef ba                                               
lbc45:
          lda #$84                     //&      bc45   a9 84                                                  
          ldy #$bc                     //&      bc47   a0 bc                                                  
          jmp POLYNOMIAL_ODD                    //&      bc49   4c 6e bb                                               
// ----------------------------------------------------------------------------
// "TAN" FUNCTION
//
// COMPUTE TAN(X) = SIN(X) / COS(X)
// ----------------------------------------------------------------------------
TAN:
          jsr $b76e                    //&      bc4c   20 6e b7                                               
          lda #$00                     //&      bc4f   a9 00                                                  
          sta $63                      //&      bc51   85 63                                                
          jsr $bc03                    //&      bc53   20 03 bc                                               
          ldx #$9c                     //&      bc56   a2 9c                                                  
          ldy #$00                     //&      bc58   a0 00                                                  
          jsr $bbf9                    //&      bc5a   20 f9 bb                                               
          lda #$a4                     //&      bc5d   a9 a4                                                  
          ldy #$00                     //&      bc5f   a0 00                                                  
          jsr $b74b                    //&      bc61   20 4b b7                                               
          lda #$00                     //&      bc64   a9 00                                                  
          sta $b0                      //&      bc66   85 b0                                                
          lda $63                      //&      bc68   a5 63                                                
          jsr $bc74                    //&      bc6a   20 74 bc                                               
          lda #$9c                     //&      bc6d   a9 9c                                                  
          ldy #$00                     //&      bc6f   a0 00                                                  
          jmp FDIV                    //&      bc71   4c ca b6                                               
TAN1:
          pha                          //&      bc74   48                                               
          jmp $bc35                    //&      bc75   4c 35 bc                                               
// ----------------------------------------------------------------------------
CON_PI_HALF:
          sta ($49,x)                   //&      bc78   81 49                                                   
          .byte $0f                    //&      bc7a   0f         %00001111                                                     
          .byte $db                    //&      bc7b   db         %11011011                                                     
CON_PI_DOUB:
          .byte $83                    //&      bc7c   83         %10000011                                                     
          eor #$0f                     //&      bc7d   49 0f                                                  
          .byte $db                    //&      bc7f   db         %11011011                                                     
QUARTER:
          .byte $7f                    //&      bc80   7f         %01111111                                                     
          brk                          //&      bc81   00                                               
          brk                          //&      bc82   00                                               
          brk                          //&      bc83   00                                               
POLY_SIN:
          .byte $04                    //&      bc84   04         %00000100                                                     
          stx $1e                      //&      bc85   86 1e                                                
          .byte $d7                    //&      bc87   d7         %11010111                                                     
          .byte $fb                    //&      bc88   fb         %11111011                                                     
          .byte $87                    //&      bc89   87         %10000111                                                     
          sta $6526,y                   //&      bc8a   99 26 65                                                 
          .byte $87                    //&      bc8d   87         %10000111                                                     
          .byte $23                    //&      bc8e   23         %00100011 '#'                                                     
          .byte $34                    //&      bc8f   34         %00110100 '4'                                                     
          cli                          //&      bc90   58                                               
          stx $a5                      //&      bc91   86 a5                                                
          eor $83e1,x                   //&      bc93   5d e1 83                                                 
          eor #$0f                     //&      bc96   49 0f                                                  
          .byte $db                    //&      bc98   db         %11011011                                                     

// ----------------------------------------------------------------------------
// "ATN" FUNCTION
// ----------------------------------------------------------------------------
ATN:
          lda $b0                      //&      bc99   a5 b0                                                
          pha                          //&      bc9b   48                                               
          bpl $bca1                    //&      bc9c   10 03                                                  
          jsr $baef                    //&      bc9e   20 ef ba                                               
lbca1:
          lda $ac                      //&      bca1   a5 ac                                                
          pha                          //&      bca3   48                                               
          cmp #$81                     //&      bca4   c9 81                                                  
          bcc $bcaf                    //&      bca6   90 07                                                  
          lda #$9c                     //&      bca8   a9 9c                                                  
          ldy #$b5                     //&      bcaa   a0 b5                                                  
          jsr FDIV                    //&      bcac   20 ca b6                                               
// ----------------------------------------------------------------------------
// 0 <= X <= 1
// 0 <= ATN(X) <= PI/8
// ----------------------------------------------------------------------------
lbcaf:
          lda #$c9                     //&      bcaf   a9 c9                                                  
          ldy #$bc                     //&      bcb1   a0 bc                                                  
          jsr POLYNOMIAL_ODD                    //&      bcb3   20 6e bb                                               
          pla                          //&      bcb6   68                                               
          cmp #$81                     //&      bcb7   c9 81                                                  
          bcc $bcc2                    //&      bcb9   90 07                                                  
          lda #$78                     //&      bcbb   a9 78                                                  
          ldy #$bc                     //&      bcbd   a0 bc                                                  
          jsr $b455                    //&      bcbf   20 55 b4                                               
// ----------------------------------------------------------------------------
lbcc2:
          pla                          //&      bcc2   68                                               
          bpl $bcc8                    //&      bcc3   10 03                                                  
          jmp $baef                    //&      bcc5   4c ef ba                                               
lbcc8:
          rts                          //&      bcc8   60                                               
POLY_ATN:
          php                          //&      bcc9   08                                               
          sei                          //&      bcca   78                                               
          .byte $3a                    //&      bccb   3a         %00111010 ':'                                                     
          cmp $37                      //&      bccc   c5 37                                                
          .byte $7b                    //&      bcce   7b         %01111011 '{'                                                     
          .byte $83                    //&      bccf   83         %10000011                                                     
          ldx #$5c                     //&      bcd0   a2 5c                                                  
          .byte $7c                    //&      bcd2   7c         %01111100 '|'                                                     
          rol $4ddd                    //&      bcd3   2e dd 4d                                               
          adc $b099,x                   //&      bcd6   7d 99 b0                                                 
          asl $597d,x                   //&      bcd9   1e 7d 59                                                 
          sbc $7e24                    //&      bcdc   ed 24 7e                                               
          sta ($72),y                   //&      bcdf   91 72                                                   
          brk                          //&      bce1   00                                               
          ror $b94c,x                   //&      bce2   7e 4c b9                                                 
          .byte $73                    //&      bce5   73         %01110011 's'                                                     
          .byte $7f                    //&      bce6   7f         %01111111                                                     
          tax                          //&      bce7   aa                                               
          tax                          //&      bce8   aa                                               
          .byte $53                    //&      bce9   53         %01010011 'S'                                                     
          sta ($00,x)                   //&      bcea   81 00                                                   
          brk                          //&      bcec   00                                               
          brk                          //&      bced   00                                               
GENERIC_CHRGET:
          inc.zp $c3                      //&      bcee   e6 c3                                                
          bne $bcf4                    //&      bcf0   d0 02                                                  
          inc.zp $c4                      //&      bcf2   e6 c4                                                
GENERIC_CHRGOT:
.label GENERIC_TXTPTR = GENERIC_CHRGOT + 1
          lda $ea60                    //&      bcf4   ad 60 ea                                               
          cmp #$3a                     //&      bcf7   c9 3a                                                  
          bcs $bd05                    //&      bcf9   b0 0a                                                  
GENERIC_CHRGOT2:
          cmp #$20                     //&      bcfb   c9 20                                                  
          beq $bcee                    //&      bcfd   f0 ef                                                  
          sec                          //&      bcff   38                                               
          sbc #$30                     //&      bd00   e9 30                                                  
          sec                          //&      bd02   38                                               
          sbc #$d0                     //&      bd03   e9 d0                                                  
lbd05:
          rts                          //&      bd05   60                                               
GENERIC_RNDSEED:
// random number seed
          .byte $80                    //&      bd06   80         %10000000                                                     
          .byte $4f                    //&      bd07   4f         %01001111 'O'                                                     
          .byte $c7                    //&      bd08   c7         %11000111                                                     
          .byte $52                    //&      bd09   52         %01010010 'R'                                                     
GENERIC_CHRGET_END:
// ____________________________________________________________________________
// Cold Strart
// ----------------------------------------------------------------------------
PR_WRITTEN_BY:
          lda #$4e                     //&      bd0a   a9 4e                                                  
          ldy #$be                     //&      bd0c   a0 be                                                  
          jsr $a8c3                    //&      bd0e   20 c3 a8                                               


COLD_START:
          ldx #$ff                     //&      bd11   a2 ff                                                  
          stx $88                      //&      bd13   86 88                                                
          txs                          //&      bd15   9a                                               
          lda #$11                     //&      bd16   a9 11                                                  
          ldy #$bd                     //&      bd18   a0 bd                                                  
          sta $01                      //&      bd1a   85 01                                                
          sty $02                      //&      bd1c   84 02                                                
          sta $04                      //&      bd1e   85 04                                                
          sty $05                      //&      bd20   84 05                                                
          lda #$05                     //&      bd22   a9 05                                                  
          ldy #$ae                     //&      bd24   a0 ae                                                  
          sta $06                      //&      bd26   85 06                                                
          sty $07                      //&      bd28   84 07                                                
          lda #$c1                     //&      bd2a   a9 c1                                                  
          ldy #$af                     //&      bd2c   a0 af                                                  
          sta $08                      //&      bd2e   85 08                                                
          sty $09                      //&      bd30   84 09                                                
          lda #$4c                     //&      bd32   a9 4c                                                  
          sta $00                      //&      bd34   85 00                                                
          sta $03                      //&      bd36   85 03                                                
          sta $a1                      //&      bd38   85 a1                                                
          sta $0a                      //&      bd3a   85 0a                                                
          lda #$88                     //&      bd3c   a9 88                                                  
          ldy #$ae                     //&      bd3e   a0 ae                                                  
          sta $0b                      //&      bd40   85 0b                                                
          sty $0c                      //&      bd42   84 0c                                                
          lda #$48                     //&      bd44   a9 48                                                  
          sta $0f                      //&      bd46   85 0f                                                
          lda #$38                     //&      bd48   a9 38                                                  
          sta $10                      //&      bd4a   85 10                                                
          ldx #$1c                     //&      bd4c   a2 1c                                                  
lbd4e:
          lda $bced,x                   //&      bd4e   bd ed bc                                                 
          sta $bb,x                    //&      bd51   95 bb                                                  
          dex                          //&      bd53   ca                                               
          bne $bd4e                    //&      bd54   d0 f8                                                  
          txa                          //&      bd56   8a                                               
          sta $b2                      //&      bd57   85 b2                                                
          sta $67                      //&      bd59   85 67                                                
          sta $0d                      //&      bd5b   85 0d                                                
          sta $0e                      //&      bd5d   85 0e                                                
          pha                          //&      bd5f   48                                               
          sta $64                      //&      bd60   85 64                                                
          lda #$03                     //&      bd62   a9 03                                                  
          sta $a0                      //&      bd64   85 a0                                                
          lda #$2c                     //&      bd66   a9 2c                                                  
          sta $12                      //&      bd68   85 12                                                
          jsr $a86c                    //&      bd6a   20 6c a8                                               
          ldx #$68                     //&      bd6d   a2 68                                                  
          stx $65                      //&      bd6f   86 65                                                
          lda #$72                     //&      bd71   a9 72                                                  
          ldy #$be                     //&      bd73   a0 be                                                  
          jsr $a8c3                    //&      bd75   20 c3 a8                                               
          jsr $a946                    //&      bd78   20 46 a9                                               
          stx.zp $c3                      //&      bd7b   86 c3                                                
          sty.zp $c4                      //&      bd7d   84 c4                                                
          jsr $00bc                    //&      bd7f   20 bc 00                                               
          cmp #$41                     //&      bd82   c9 41                                                  
          beq $bd0a                    //&      bd84   f0 84                                                  
          tay                          //&      bd86   a8                                               
          bne $bdaa                    //&      bd87   d0 21                                                  
          lda #$00                     //&      bd89   a9 00                                                  
          ldy #$03                     //&      bd8b   a0 03                                                  
          sta $11                      //&      bd8d   85 11                                                
          sty $12                      //&      bd8f   84 12                                                
          ldy #$00                     //&      bd91   a0 00                                                  
lbd93:
          inc $11                      //&      bd93   e6 11                                                
          bne $bd99                    //&      bd95   d0 02                                                  
          inc $12                      //&      bd97   e6 12                                                
lbd99:
          lda #$92                     //&      bd99   a9 92                                                  
          sta ($11),y                   //&      bd9b   91 11                                                   
          cmp ($11),y                   //&      bd9d   d1 11                                                   
          bne $bdb6                    //&      bd9f   d0 15                                                  
          asl                          //&      bda1   0a                                                 
          sta ($11),y                   //&      bda2   91 11                                                   
          cmp ($11),y                   //&      bda4   d1 11                                                   
          beq $bd93                    //&      bda6   f0 eb                                                  
          bne $bdb6                    //&      bda8   d0 0c                                                  
lbdaa:
          jsr $00c2                    //&      bdaa   20 c2 00                                               
          jsr $a77f                    //&      bdad   20 7f a7                                               
          tay                          //&      bdb0   a8                                               
          beq $bdb6                    //&      bdb1   f0 03                                                  
          jmp $ac0c                    //&      bdb3   4c 0c ac                                               
lbdb6:
          lda $11                      //&      bdb6   a5 11                                                
          ldy $12                      //&      bdb8   a4 12                                                
          sta $85                      //&      bdba   85 85                                                
          sty $86                      //&      bdbc   84 86                                                
          sta $81                      //&      bdbe   85 81                                                
          sty $82                      //&      bdc0   84 82                                                
lbdc2:
          lda #$7e                     //&      bdc2   a9 7e                                                  
          ldy #$be                     //&      bdc4   a0 be                                                  
          jsr $a8c3                    //&      bdc6   20 c3 a8                                               
          jsr $a946                    //&      bdc9   20 46 a9                                               
          stx.zp $c3                      //&      bdcc   86 c3                                                
          sty.zp $c4                      //&      bdce   84 c4                                                
          jsr $00bc                    //&      bdd0   20 bc 00                                               
          tay                          //&      bdd3   a8                                               
          beq $bdf2                    //&      bdd4   f0 1c                                                  
          jsr $a77f                    //&      bdd6   20 7f a7                                               
          lda $12                      //&      bdd9   a5 12                                                
          bne $bdc2                    //&      bddb   d0 e5                                                  
          lda $11                      //&      bddd   a5 11                                                
          cmp #$10                     //&      bddf   c9 10                                                  
          bcc $bdc2                    //&      bde1   90 df                                                  
          sta $0f                      //&      bde3   85 0f                                                
lbde5:
          sbc #$0e                     //&      bde5   e9 0e                                                  
          bcs $bde5                    //&      bde7   b0 fc                                                  
          eor #$ff                     //&      bde9   49 ff                                                  
          sbc #$0c                     //&      bdeb   e9 0c                                                  
          clc                          //&      bded   18                                               
          adc $0f                      //&      bdee   65 0f                                                
          sta $10                      //&      bdf0   85 10                                                
lbdf2:
          ldx #$00                     //&      bdf2   a2 00                                                  
          ldy #$03                     //&      bdf4   a0 03                                                  
          stx $79                      //&      bdf6   86 79                                                
          sty $7a                      //&      bdf8   84 7a                                                
          ldy #$00                     //&      bdfa   a0 00                                                  
          tya                          //&      bdfc   98                                               
          sta ($79),y                   //&      bdfd   91 79                                                   
          inc $79                      //&      bdff   e6 79                                                
          bne $be05                    //&      be01   d0 02                                                  
          inc $7a                      //&      be03   e6 7a                                                
lbe05:
          lda $79                      //&      be05   a5 79                                                
          ldy $7a                      //&      be07   a4 7a                                                
          jsr $a21f                    //&      be09   20 1f a2                                               
          jsr $a86c                    //&      be0c   20 6c a8                                               
          lda $85                      //&      be0f   a5 85                                                
          sec                          //&      be11   38                                               
          sbc $79                      //&      be12   e5 79                                                
          tax                          //&      be14   aa                                               
          lda $86                      //&      be15   a5 86                                                
          sbc $7a                      //&      be17   e5 7a                                                
          jsr $b95e                    //&      be19   20 5e b9                                               
          lda #$8d                     //&      be1c   a9 8d                                                  
          ldy #$be                     //&      be1e   a0 be                                                  
          jsr $a8c3                    //&      be20   20 c3 a8                                               
          lda #$c3                     //&      be23   a9 c3                                                  
          ldy #$a8                     //&      be25   a0 a8                                                  
          sta $04                      //&      be27   85 04                                                
          sty $05                      //&      be29   84 05                                                
          jsr $a463                    //&      be2b   20 63 a4                                               
          lda #$74                     //&      be2e   a9 74                                                  
          ldy #$a2                     //&      be30   a0 a2                                                  
          sta $01                      //&      be32   85 01                                                
          sty $02                      //&      be34   84 02                                                
          jmp ($0001)                   //&      be36   6c 01 00                                                 
// OSI is compiled for ROM, but includes
// this unused string
          .byte $57                    //&      be39   57         %01010111 'W'                                                     
          eor ($4e,x)                   //&      be3a   41 4e                                                   
          .byte $54                    //&      be3c   54         %01010100 'T'                                                     
          jsr $4953                    //&      be3d   20 53 49                                               
          lsr $432d                    //&      be40   4e 2d 43                                               
          .byte $4f                    //&      be43   4f         %01001111 'O'                                                     
          .byte $53                    //&      be44   53         %01010011 'S'                                                     
          and $4154                    //&      be45   2d 54 41                                               
          lsr $412d                    //&      be48   4e 2d 41                                               
          .byte $54                    //&      be4b   54         %01010100 'T'                                                     
          lsr $0d00                    //&      be4c   4e 00 0d                                               
          asl                          //&      be4f   0a                                                 
          .byte $0c                    //&      be50   0c         %00001100                                                     
          .byte $54                    //&      be51   54         %01010100 'T'                                                     
          
          pla                          //&      be52   68                                               
          adc #$73                     //&      be53   69 73                                                  
          jsr $7369                    //&      be55   20 69 73                                               
          jsr $6874                    //&      be58   20 74 68                                               
          adc $20                      //&      be5b   65 20                                                
          .byte $43                    //&      be5d   43         %01000011 'C'                                                     
          .byte $4f                    //&      be5e   4f         %01001111 'O'                                                     
          eor $5550                    //&      be5f   4d 50 55                                               
          .byte $4b                    //&      be62   4b         %01001011 'K'                                                     
          eor #$54                     //&      be63   49 54                                                  
          jsr $4b55                    //&      be65   20 55 4b                                               
          and ($30),y                   //&      be68   31 30                                                   
          and ($20),y                   //&      be6a   31 20                                                   
          .byte $0c                    //&      be6c   0c         %00001100                                                     
          jsr $0d20                    //&      be6d   20 20 0d                                               
          asl                          //&      be70   0a                                                 
          brk                          //&      be71   00                                               
          eor $4d45                    //&      be72   4d 45 4d                                               
          .byte $4f                    //&      be75   4f         %01001111 'O'                                                     
          .byte $52                    //&      be76   52         %01010010 'R'                                                     
          eor $5320,y                   //&      be77   59 20 53                                                 
          eor #$5a                     //&      be7a   49 5a                                                  
          eor $00                      //&      be7c   45 00                                                
          .byte $54                    //&      be7e   54         %01010100 'T'                                                     
          eor $52                      //&      be7f   45 52                                                
          eor $4e49                    //&      be81   4d 49 4e                                               
          eor ($4c,x)                   //&      be84   41 4c                                                   
          jsr $4957                    //&      be86   20 57 49                                               
          .byte $44                    //&      be89   44         %01000100 'D'                                                     
          .byte $54                    //&      be8a   54         %01010100 'T'                                                     
          pha                          //&      be8b   48                                               
          brk                          //&      be8c   00                                               
          jsr $5942                    //&      be8d   20 42 59                                               
          .byte $54                    //&      be90   54         %01010100 'T'                                                     
          eor $53                      //&      be91   45 53                                                
          jsr $5246                    //&      be93   20 46 52                                               
          eor $45                      //&      be96   45 45                                                
          ora $0d0a                    //&      be98   0d 0a 0d                                               
          asl                          //&      be9b   0a                                                 
          .byte $43                    //&      be9c   43         %01000011 'C'                                                     
          jsr $204f                    //&      be9d   20 4f 20                                               
          eor $5020                    //&      bea0   4d 20 50                                               
          jsr $2055                    //&      bea3   20 55 20                                               
          .byte $4b                    //&      bea6   4b         %01001011 'K'                                                     
          jsr $2049                    //&      bea7   20 49 20                                               
          .byte $54                    //&      beaa   54         %01010100 'T'                                                     
          jsr $5520                    //&      beab   20 20 55                                               
          jsr $204b                    //&      beae   20 4b 20                                               
          and ($20),y                   //&      beb1   31 20                                                   
          bmi $bed5                    //&      beb3   30 20                                                  
          and ($0d),y                   //&      beb5   31 0d                                                   
          asl                          //&      beb7   0a                                                 
          asl                          //&      beb8   0a                                                 
          bvc $bf20                    //&      beb9   50 65                                                  
          .byte $72                    //&      bebb   72         %01110010 'r'                                                     
          .byte $73                    //&      bebc   73         %01110011 's'                                                     
          .byte $6f                    //&      bebd   6f         %01101111 'o'                                                     
          ror $6c61                    //&      bebe   6e 61 6c                                               
          jsr $6f43                    //&      bec1   20 43 6f                                               
          adc $7570                    //&      bec4   6d 70 75                                               
          .byte $74                    //&      bec7   74         %01110100 't'                                                     
          adc $72                      //&      bec8   65 72                                                
          ora $0a0a                    //&      beca   0d 0a 0a                                               
          sec                          //&      becd   38                                               
          .byte $4b                    //&      bece   4b         %01001011 'K'                                                     
          jsr $6142                    //&      becf   20 42 61                                               
          .byte $73                    //&      bed2   73         %01110011 's'                                                     
          adc #$63                     //&      bed3   69 63                                                  
lbed5:
          jsr $6f43                    //&      bed5   20 43 6f                                               
          bvs $bf53                    //&      bed8   70 79                                                  
          .byte $72                    //&      beda   72         %01110010 'r'                                                     
          adc #$67                     //&      bedb   69 67                                                  
          pla                          //&      bedd   68                                               
          .byte $74                    //&      bede   74         %01110100 't'                                                     
          and ($39),y                   //&      bedf   31 39                                                   
          .byte $37                    //&      bee1   37         %00110111 '7'                                                                                            
          and $ad00,y                   //&      bee2   39 00 ad


          ora $bf                      //&      bee5   05 bf                                                                                       
          lsr                          //&      bee7   4a                                                                                        
          bcc $bee4                    //&      bee8   90 fa                                                                                         
          lda $fb03                    //&      beea   ad 03 fb                                                                                      
          sta $fb07                    //&      beed   8d 07 fb                                                                                      
          and #$7f                     //&      bef0   29 7f                                                                                         
          rts                          //&      bef2   60                                                                                      
          pha                          //&      bef3   48                                                                                      
lbef4:
          lda $fb05                    //&      bef4   ad 05 fb                                                                                      
          bpl $bef4                    //&      bef7   10 fb                                                                                         
          pla                          //&      bef9   68                                                                                      
          sta $fb04                    //&      befa   8d 04 fb                                                                                      
          rts                          //&      befd   60                                                                                      
          lda $fb06                    //&      befe   ad 06 fb                                                                                      
          lda #$ff                     //&      bf01   a9 ff                                                                                         
          sta $fb05                    //&      bf03   8d 05 fb                                                                                      
          rts                          //&      bf06   60                                                                                      
lbf07:
          lda $fc00                    //&      bf07   ad 00 fc                                                                                      
          lsr                          //&      bf0a   4a                                                                                        
          bcc $bf07                    //&      bf0b   90 fa                                                                                         
          lda $fc01                    //&      bf0d   ad 01 fc                                                                                      
          beq $bf07                    //&      bf10   f0 f5                                                                                         
          and #$7f                     //&      bf12   29 7f                                                                                         
          rts                          //&      bf14   60                                                                                      
          pha                          //&      bf15   48                                                                                      
lbf16:
   lda $fc00                    //&      bf16   ad 00 fc                                                                                      
          lsr                          //&      bf19   4a                                                                                        
          lsr                          //&      bf1a   4a                                                                                        
          bcc $bf16                    //&      bf1b   90 f9                                                                                         
          pla                          //&      bf1d   68                                                                                      
          sta $fc01                    //&      bf1e   8d 01 fc                                                                                      
          rts                          //&      bf21   60                                                                                      
          lda #$03                     //&      bf22   a9 03                                                                                         
          sta $fc00                    //&      bf24   8d 00 fc                                                                                      
          lda #$b1                     //&      bf27   a9 b1                                                                                         
          sta $fc00                    //&      bf29   8d 00 fc                                                                                      
          rts                          //&      bf2c   60                                                                                      
          sta $0202                    //&      bf2d   8d 02 02                                                                                      
          pha                          //&      bf30   48                                                                                      
          txa                          //&      bf31   8a                                                                                      
          pha                          //&      bf32   48                                                                                      
          tya                          //&      bf33   98                                                                                      
          pha                          //&      bf34   48                                                                                      
          lda $0202                    //&      bf35   ad 02 02                                                                                      
          beq $bf6d                    //&      bf38   f0 33                                                                                         
          ldy $0206                    //&      bf3a   ac 06 02                                                                                      
          beq $bf47                    //&      bf3d   f0 08                                                                                         
lbf3f:
          ldx #$40                     //&      bf3f   a2 40                                                                                         
lbf41:
          dex                          //&      bf41   ca                                                                                      
          bne $bf41                    //&      bf42   d0 fd                                                                                         
          dey                          //&      bf44   88                                                                                      
          bne $bf3f                    //&      bf45   d0 f8                                                                                         
lbf47:
          cmp #$0a                     //&      bf47   c9 0a                                                                                         
          beq $bf76                    //&      bf49   f0 2b                                                                                         
          cmp #$0d                     //&      bf4b   c9 0d                                                                                         
          bne $bf55                    //&      bf4d   d0 06                                                                                         
          jsr $bfd5                    //&      bf4f   20 d5 bf                                                                                      
          jmp $bf6d                    //&      bf52   4c 6d bf                                                                                      
lbf55: // coldstart?
          sta $0201                    //&      bf55   8d 01 02                                                                                      
          jsr $bfc2                    //&      bf58   20 c2 bf                                                                                      
          inc $0200                    //&      bf5b   ee 00 02                                                                                      
          lda $ffe1                    //&      bf5e   ad e1 ff                                                                                      
          clc                          //&      bf61   18                                                                                      
          adc $ffe0                    //&      bf62   6d e0 ff                                                                                      
          cmp $0200                    //&      bf65   cd 00 02                                                                                      
          bmi $bf73                    //&      bf68   30 09                                                                                         
lbf6a:
          jsr $bfde                    //&      bf6a   20 de bf                                                                                      
lbf6d:
          pla                          //&      bf6d   68                                                                                      
          tay                          //&      bf6e   a8                                                                                      
          pla                          //&      bf6f   68                                                                                      
          tax                          //&      bf70   aa                                                                                      
          pla                          //&      bf71   68                                                                                      
          rts                          //&      bf72   60                                                                                      
lbf73:
   jsr $bfd8                    //&      bf73   20 d8 bf                                                                                      
lbf76: // warmstart?
          jsr $bfc2                    //&      bf76   20 c2 bf                                                                                      
          lda $ffe0                    //&      bf79   ad e0 ff                                                                                      
          and #$e0                     //&      bf7c   29 e0                                                                                         
          sta $0202                    //&      bf7e   8d 02 02                                                                                      
          ldx #$07                     //&      bf81   a2 07                                                                                         
lbf83:
   lda $bff3,x                   //&      bf83   bd f3 bf                                                                                        
          sta $0207,x                   //&      bf86   9d 07 02                                                                                        
          dex                          //&      bf89   ca                                                                                      
          bpl $bf83                    //&      bf8a   10 f7                                                                                         
          ldx $bffb,y                   //&      bf8c   be fb bf                                                                                        
          lda #$20                     //&      bf8f   a9 20                                                                                         
          ldy $ffe1                    //&      bf91   ac e1 ff                                                                                      
          cpy #$20                     //&      bf94   c0 20                                                                                         
          bmi $bf99                    //&      bf96   30 01                                                                                         
          asl                          //&      bf98   0a                                                                                        
lbf99:
          sta $0208                    //&      bf99   8d 08 02                                                                                      
          ldy #$00                     //&      bf9c   a0 00                                                                                         
lbf9e:
          jsr $0207                    //&      bf9e   20 07 02                                                                                      
          bne $bf9e                    //&      bfa1   d0 fb                                                                                         
          inc $0209                    //&      bfa3   ee 09 02                                                                                      
          inc $020c                    //&      bfa6   ee 0c 02                                                                                      
          cpx $0209                    //&      bfa9   ec 09 02                                                                                      
          bne $bf9e                    //&      bfac   d0 f0                                                                                         
lbfae:
   jsr $0207                    //&      bfae   20 07 02                                                                                      
          cpy $0202                    //&      bfb1   cc 02 02                                                                                      
          bne $bfae                    //&      bfb4   d0 f8                                                                                         
          lda #$20                     //&      bfb6   a9 20                                                                                         
lbfb8:
          jsr $020a                    //&      bfb8   20 0a 02                                                                                      
          dec $0208                    //&      bfbb   ce 08 02                                                                                      
          bne $bfb8                    //&      bfbe   d0 f8                                                                                         
          beq $bf6a                    //&      bfc0   f0 a8                                                                                         
lbfc2:
          ldx $0200                    //&      bfc2   ae 00 02                                                                                      
          lda $0201                    //&      bfc5   ad 01 02                                                                                      
lbfc8:
          ldy $ffe2                    //&      bfc8   ac e2 ff                                                                                      
          bne $bfd1                    //&      bfcb   d0 04                                                                                         
          sta $d300,x                   //&      bfcd   9d 00 d3                                                                                        
          rts                          //&      bfd0   60                                                                                      
lbfd1:
          sta $d700,x                   //&      bfd1   9d 00 d7                                                                                        
          rts                          //&      bfd4   60                                                                                      
lbfd5:
          jsr $bfc2                    //&      bfd5   20 c2 bf                                                                                      
lbfd8:
          lda $ffe0                    //&      bfd8   ad e0 ff                                                                                      
          sta $0200                    //&      bfdb   8d 00 02                                                                                      
lbfde:
          ldx $0200                    //&      bfde   ae 00 02                                                                                      
          lda $d300,x                   //&      bfe1   bd 00 d3                                                                                        
          ldy $ffe2                    //&      bfe4   ac e2 ff                                                                                      
          beq $bfec                    //&      bfe7   f0 03                                                                                         
          lda $d700,x                   //&      bfe9   bd 00 d7                                                                                        
lbfec:
          sta $0201                    //&      bfec   8d 01 02                                                                                      
          lda #$9a                     //&      bfef   a9 9a                                                                                         
          bne $bfc8                    //&      bff1   d0 d5                                                                                         
          lda $d000,y                   //&      bff3   b9 00 d0                                                                                        
          sta $d000,y                   //&      bff6   99 00 d0                                                                                        
          iny                          //&      bff9   c8                                                                                      
          rts                          //&      bffa   60                                                                                      
          .byte $d3                    //&      bffb   d3         %11010011                                                                                            
          .byte $d7                    //&      bffc   d7         %11010111                                                                                            
          brk                          //&      bffd   00                                                                                      
          brk                          //&      bffe   00                                                                                      
          brk                          //&      bfff   00 

                                                                                                                                       
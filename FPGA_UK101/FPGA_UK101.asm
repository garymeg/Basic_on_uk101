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
// Name                 Release   MS Version    ROM   9digit  INPUTBUFFER   extensions   
//---------------------------------------------------------------------------------------------------
// OSI BASIC             1977     1.0 REV 3.2    Y      N          ZP            -        
//
// Credits:
// * main work by Michael Steil
// * function names and all uppercase comments taken from Bob Sander-Cederlof's excellent AppleSoft II disassembly:
//   http://www.txbobsc.com/scsc/scdocumentor/
// * Applesoft lite by Tom Greene http://cowgod* =/replica1/applesoft/ helped a lot, too.
// * Thanks to Joe Zbicak for help with Intellision Keyboard BASIC
// * This work is dedicated to the memory of my dear hacking pal Michael "acidity" Kollmann.

.cpu _6502

// zero page
.const ZP_START1        = $00
.const ZP_START2        = $0D
.const ZP_START3        = $5B
.const ZP_START4        = $65

//extra ZP variables
.label USR             = $000A

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
.label STACK              = $0100

.label INPUTBUFFERX = INPUTBUFFER & $FF00

.const CR                 =13
.const LF                 =10

.label CRLF_1             = CR
.label CRLF_2             = LF



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

* = $E000 "CODE"
TOKEN_ADDRESS_TABLE:
		.word END-1
		.word FOR-1
		.word NEXT-1
		.word DATA-1
		.word INPUT-1
		.word DIM-1
		.word READ-1
		.word LET-1
.label TOKEN_GOTO=$80+(*-TOKEN_ADDRESS_TABLE)/2
		.word GOTO-1
		.word RUN-1
		.word IF-1
		.word RESTORE-1
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
        .text "NF"
.label ERR_SYNTAX = <(*-ERROR_MESSAGES)
        .text "SN"
.label ERR_NOGOSUB = <(*-ERROR_MESSAGES)
        .text "RG"
.label ERR_NODATA = <(*-ERROR_MESSAGES)
        .text "OD"
.label ERR_ILLQTY = <(*-ERROR_MESSAGES)
        .text "FC"
.label ERR_OVERFLOW = <(*-ERROR_MESSAGES)
        .text "OV"
.label ERR_MEMFULL = <(*-ERROR_MESSAGES)
        .text "OM"
.label ERR_UNDEFSTAT = <(*-ERROR_MESSAGES)
        .text "US"
.label ERR_BADSUBS = <(*-ERROR_MESSAGES)
        .text "BS"
.label ERR_REDIMD = <(*-ERROR_MESSAGES)
        .text "DD"
.label ERR_ZERODIV = <(*-ERROR_MESSAGES)
        .text "/0"
.label ERR_ILLDIR = <(*-ERROR_MESSAGES)
        .text "ID"
.label ERR_BADTYPE = <(*-ERROR_MESSAGES)
        .text "TM"
.label ERR_STRLONG = <(*-ERROR_MESSAGES)
        .text "LS"
.label ERR_FRMCPX = <(*-ERROR_MESSAGES)
        .text "ST"
.label ERR_CANTCONT = <(*-ERROR_MESSAGES)
        .text "CN"
.label ERR_UNDEFFN = <(*-ERROR_MESSAGES)
        .text "UF"
		
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

                            * = $e000

* = $E000 "CODE"
TOKEN_ADDRESS_TABLE:
		.word END-1
		.word FOR-1
		.word NEXT-1
		.word DATA-1
		.word INPUT-1
		.word DIM-1
		.word READ-1
		.word LET-1
.label TOKEN_GOTO=$80+(*-TOKEN_ADDRESS_TABLE)/2
		.word GOTO-1
		.word RUN-1
		.word IF-1
		.word RESTORE-1
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
        .text "NF"
.label ERR_SYNTAX = <(*-ERROR_MESSAGES)
        .text "SN"
.label ERR_NOGOSUB = <(*-ERROR_MESSAGES)
        .text "RG"
.label ERR_NODATA = <(*-ERROR_MESSAGES)
        .text "OD"
.label ERR_ILLQTY = <(*-ERROR_MESSAGES)
        .text "FC"
.label ERR_OVERFLOW = <(*-ERROR_MESSAGES)
        .text "OV"
.label ERR_MEMFULL = <(*-ERROR_MESSAGES)
        .text "OM"
.label ERR_UNDEFSTAT = <(*-ERROR_MESSAGES)
        .text "US"
.label ERR_BADSUBS = <(*-ERROR_MESSAGES)
        .text "BS"
.label ERR_REDIMD = <(*-ERROR_MESSAGES)
        .text "DD"
.label ERR_ZERODIV = <(*-ERROR_MESSAGES)
        .text "/0"
.label ERR_ILLDIR = <(*-ERROR_MESSAGES)
        .text "ID"
.label ERR_BADTYPE = <(*-ERROR_MESSAGES)
        .text "TM"
.label ERR_STRLONG = <(*-ERROR_MESSAGES)
        .text "LS"
.label ERR_FRMCPX = <(*-ERROR_MESSAGES)
        .text "ST"
.label ERR_CANTCONT = <(*-ERROR_MESSAGES)
        .text "CN"
.label ERR_UNDEFFN = <(*-ERROR_MESSAGES)
        .text "UF"
		
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

e1a1   ba                   tsx
e1a2   e8                   inx
e1a3   e8                   inx
e1a4   e8                   inx
e1a5   e8                   inx
e1a6   bd 01 01   le1a6     lda $0101,x
e1a9   c9 81                cmp #$81
e1ab   d0 21                bne le1ce
e1ad   a5 98                lda $98
e1af   d0 0a                bne le1bb
e1b1   bd 02 01             lda $0102,x
e1b4   85 97                sta $97
e1b6   bd 03 01             lda $0103,x
e1b9   85 98                sta $98
e1bb   dd 03 01   le1bb     cmp $0103,x
e1be   d0 07                bne le1c7
e1c0   a5 97                lda $97
e1c2   dd 02 01             cmp $0102,x
e1c5   f0 07                beq le1ce
e1c7   8a         le1c7     txa
e1c8   18                   clc
e1c9   69 10                adc #$10
e1cb   aa                   tax
e1cc   d0 d8                bne le1a6
e1ce   60         le1ce     rts
e1cf   20 1f a2             jsr $a21f
e1d2   85 7f                sta $7f
e1d4   84 80                sty $80
e1d6   38                   sec
e1d7   a5 a6                lda $a6
e1d9   e5 aa                sbc $aa
e1db   85 71                sta $71
e1dd   a8                   tay
e1de   a5 a7                lda $a7
e1e0   e5 ab                sbc $ab
e1e2   aa                   tax
e1e3   e8                   inx
e1e4   98                   tya
e1e5   f0 23                beq le20a
e1e7   a5 a6                lda $a6
e1e9   38                   sec
e1ea   e5 71                sbc $71
e1ec   85 a6                sta $a6
e1ee   b0 03                bcs le1f3
e1f0   c6 a7                dec $a7
e1f2   38                   sec
e1f3   a5 a4      le1f3     lda $a4
e1f5   e5 71                sbc $71
e1f7   85 a4                sta $a4
e1f9   b0 08                bcs le203
e1fb   c6 a5                dec $a5
e1fd   90 04                bcc le203
e1ff   b1 a6      le1ff     lda ($a6),y
e201   91 a4                sta ($a4),y
e203   88         le203     dey
e204   d0 f9                bne le1ff
e206   b1 a6                lda ($a6),y
e208   91 a4                sta ($a4),y
e20a   c6 a7      le20a     dec $a7
e20c   c6 a5                dec $a5
e20e   ca                   dex
e20f   d0 f2                bne le203
e211   60                   rts
e212   0a                   asl a
e213   69 33                adc #$33
e215   b0 35                bcs le24c
e217   85 71                sta $71
e219   ba                   tsx
e21a   e4 71                cpx $71
e21c   90 2e                bcc le24c
e21e   60                   rts
e21f   c4 82                cpy $82
e221   90 28                bcc le24b
e223   d0 04                bne le229
e225   c5 81                cmp $81
e227   90 22                bcc le24b
e229   48         le229     pha
e22a   a2 08                ldx #$08
e22c   98                   tya
e22d   48         le22d     pha
e22e   b5 a3                lda $a3,x
e230   ca                   dex
e231   10 fa                bpl le22d
e233   20 47 b1             jsr $b147
e236   a2 f8                ldx #$f8
e238   68         le238     pla
e239   95 ac                sta $ac,x
e23b   e8                   inx
e23c   30 fa                bmi le238
e23e   68                   pla
e23f   a8                   tay
e240   68                   pla
e241   c4 82                cpy $82
e243   90 06                bcc le24b
e245   d0 05                bne le24c
e247   c5 81                cmp $81
e249   b0 01                bcs le24c
e24b   60         le24b     rts
e24c   a2 0c      le24c     ldx #$0c
e24e   46 64                lsr $64
e250   20 6c a8             jsr $a86c
e253   20 e3 a8             jsr $a8e3
e256   bd 64 a1             lda $a164,x
e259   20 e5 a8             jsr $a8e5
e25c   bd 65 a1             lda $a165,x
e25f   20 e5 a8             jsr $a8e5
e262   20 91 a4             jsr $a491
e265   a9 86                lda #$86
e267   a0 a1                ldy #$a1
e269   20 c3 a8             jsr $a8c3
e26c   a4 88                ldy $88
e26e   c8                   iny
e26f   f0 03                beq le274
e271   20 53 b9             jsr $b953
e274   46 64      le274     lsr $64
e276   a9 92                lda #$92
e278   a0 a1                ldy #$a1
e27a   20 03 00             jsr $0003
e27d   20 57 a3   le27d     jsr $a357
e280   86 c3                stx $c3
e282   84 c4                sty $c4
e284   20 bc 00             jsr $00bc
e287   f0 f4                beq le27d
e289   a2 ff                ldx #$ff
e28b   86 88                stx $88
e28d   90 06                bcc le295
e28f   20 a6 a3             jsr $a3a6
e292   4c f6 a5             jmp $a5f6
e295   20 7f a7   le295     jsr $a77f
e298   20 a6 a3             jsr $a3a6
e29b   84 5d                sty $5d
e29d   20 32 a4             jsr $a432
e2a0   90 44                bcc le2e6
e2a2   a0 01                ldy #$01
e2a4   b1 aa                lda ($aa),y
e2a6   85 72                sta $72
e2a8   a5 7b                lda $7b
e2aa   85 71                sta $71
e2ac   a5 ab                lda $ab
e2ae   85 74                sta $74
e2b0   a5 aa                lda $aa
e2b2   88                   dey
e2b3   f1 aa                sbc ($aa),y
e2b5   18                   clc
e2b6   65 7b                adc $7b
e2b8   85 7b                sta $7b
e2ba   85 73                sta $73
e2bc   a5 7c                lda $7c
e2be   69 ff                adc #$ff
e2c0   85 7c                sta $7c
e2c2   e5 ab                sbc $ab
e2c4   aa                   tax
e2c5   38                   sec
e2c6   a5 aa                lda $aa
e2c8   e5 7b                sbc $7b
e2ca   a8                   tay
e2cb   b0 03                bcs le2d0
e2cd   e8                   inx
e2ce   c6 74                dec $74
e2d0   18         le2d0     clc
e2d1   65 71                adc $71
e2d3   90 03                bcc le2d8
e2d5   c6 72                dec $72
e2d7   18                   clc
e2d8   b1 71      le2d8     lda ($71),y
e2da   91 73                sta ($73),y
e2dc   c8                   iny
e2dd   d0 f9                bne le2d8
e2df   e6 72                inc $72
e2e1   e6 74                inc $74
e2e3   ca                   dex
e2e4   d0 f2                bne le2d8
e2e6   a5 13      le2e6     lda $13
e2e8   f0 2f                beq le319
e2ea   a5 85                lda $85
e2ec   a4 86                ldy $86
e2ee   85 81                sta $81
e2f0   84 82                sty $82
e2f2   a5 7b                lda $7b
e2f4   85 a6                sta $a6
e2f6   65 5d                adc $5d
e2f8   85 a4                sta $a4
e2fa   a4 7c                ldy $7c
e2fc   84 a7                sty $a7
e2fe   90 01                bcc le301
e300   c8                   iny
e301   84 a5      le301     sty $a5
e303   20 cf a1             jsr $a1cf
e306   a5 7f                lda $7f
e308   a4 80                ldy $80
e30a   85 7b                sta $7b
e30c   84 7c                sty $7c
e30e   a4 5d                ldy $5d
e310   88                   dey
e311   b9 0f 00   le311     lda $000f,y
e314   91 aa                sta ($aa),y
e316   88                   dey
e317   10 f8                bpl le311
e319   20 77 a4   le319     jsr $a477
e31c   a5 79                lda $79
e31e   a4 7a                ldy $7a
e320   85 71                sta $71
e322   84 72                sty $72
e324   18                   clc
e325   a0 01      le325     ldy #$01
e327   b1 71                lda ($71),y
e329   d0 03                bne le32e
e32b   4c 7d a2             jmp $a27d
e32e   a0 04      le32e     ldy #$04
e330   c8         le330     iny
e331   b1 71                lda ($71),y
e333   d0 fb                bne le330
e335   c8                   iny
e336   98                   tya
e337   65 71                adc $71
e339   aa                   tax
e33a   a0 00                ldy #$00
e33c   91 71                sta ($71),y
e33e   a5 72                lda $72
e340   69 00                adc #$00
e342   c8                   iny
e343   91 71                sta ($71),y
e345   86 71                stx $71
e347   85 72                sta $72
e349   90 da                bcc le325
e34b   20 e5 a8             jsr $a8e5
e34e   ca                   dex
e34f   10 08                bpl le359
e351   20 e5 a8   le351     jsr $a8e5
e354   20 6c a8             jsr $a86c
e357   a2 00                ldx #$00
e359   20 86 a3   le359     jsr $a386
e35c   c9 07                cmp #$07
e35e   f0 14                beq le374
e360   c9 0d                cmp #$0d
e362   f0 1f                beq le383
e364   c9 0b                cmp #$0b
e366   90 f1                bcc le359
e368   c9 7f                cmp #$7f
e36a   b0 ed                bcs le359
e36c   c9 40                cmp #$40
e36e   f0 e1                beq le351
e370   4c d5 fc             jmp lfcd5
e373   d7                   ???                ;%11010111
e374   e0 47      le374     cpx #$47
e376   b0 04                bcs le37c
e378   95 13                sta $13,x
e37a   e8                   inx
e37b   2c a9 07             bit $07a9
e37e   20 e5 a8             jsr $a8e5
e381   d0 d6                bne le359
e383   4c 66 a8   le383     jmp $a866
e386   20 eb ff             jsr lffeb
e389   ea                   nop
e38a   ea                   nop
e38b   ea                   nop
e38c   ea                   nop
e38d   ea                   nop
e38e   ea                   nop
e38f   ea                   nop
e390   ea                   nop
e391   ea                   nop
e392   ea                   nop
e393   ea                   nop
e394   ea                   nop
e395   ea                   nop
e396   ea                   nop
e397   29 7f                and #$7f
e399   c9 0f                cmp #$0f
e39b   d0 08                bne le3a5
e39d   48                   pha
e39e   a5 64                lda $64
e3a0   49 ff                eor #$ff
e3a2   85 64                sta $64
e3a4   68                   pla
e3a5   60         le3a5     rts
e3a6   a6 c3                ldx $c3
e3a8   a0 04                ldy #$04
e3aa   84 60                sty $60
e3ac   b5 00      le3ac     lda $00,x
e3ae   c9 20                cmp #$20
e3b0   f0 3a                beq le3ec
e3b2   85 5c                sta $5c
e3b4   c9 22                cmp #$22
e3b6   f0 58                beq le410
e3b8   24 60                bit $60
e3ba   70 30                bvs le3ec
e3bc   c9 3f                cmp #$3f
e3be   d0 04                bne le3c4
e3c0   a9 97                lda #$97
e3c2   d0 28                bne le3ec
e3c4   c9 30      le3c4     cmp #$30
e3c6   90 04                bcc le3cc
e3c8   c9 3c                cmp #$3c
e3ca   90 20                bcc le3ec
e3cc   84 ba      le3cc     sty $ba
e3ce   a0 00                ldy #$00
e3d0   84 5d                sty $5d
e3d2   88                   dey
e3d3   86 c3                stx $c3
e3d5   ca                   dex
e3d6   c8         le3d6     iny
e3d7   e8         le3d7     inx
e3d8   b5 00      le3d8     lda $00,x
e3da   c9 20                cmp #$20
e3dc   f0 f9                beq le3d7
e3de   38                   sec
e3df   f9 84 a0             sbc $a084,y
e3e2   f0 f2                beq le3d6
e3e4   c9 80                cmp #$80
e3e6   d0 2f                bne le417
e3e8   05 5d                ora $5d
e3ea   a4 ba      le3ea     ldy $ba
e3ec   e8         le3ec     inx
e3ed   c8                   iny
e3ee   99 0e 00             sta $000e,y
e3f1   b9 0e 00             lda $000e,y
e3f4   f0 34                beq le42a
e3f6   38                   sec
e3f7   e9 3a                sbc #$3a
e3f9   f0 04                beq le3ff
e3fb   c9 49                cmp #$49
e3fd   d0 02                bne le401
e3ff   85 60      le3ff     sta $60
e401   38         le401     sec
e402   e9 54                sbc #$54
e404   d0 a6                bne le3ac
e406   85 5c                sta $5c
e408   b5 00      le408     lda $00,x
e40a   f0 e0                beq le3ec
e40c   c5 5c                cmp $5c
e40e   f0 dc                beq le3ec
e410   c8         le410     iny
e411   99 0e 00             sta $000e,y
e414   e8                   inx
e415   d0 f1                bne le408
e417   a6 c3      le417     ldx $c3
e419   e6 5d                inc $5d
e41b   c8         le41b     iny
e41c   b9 83 a0             lda $a083,y
e41f   10 fa                bpl le41b
e421   b9 84 a0             lda $a084,y
e424   d0 b2                bne le3d8
e426   b5 00                lda $00,x
e428   10 c0                bpl le3ea
e42a   99 10 00   le42a     sta $0010,y
e42d   a9 12                lda #$12
e42f   85 c3                sta $c3
e431   60                   rts
e432   a5 79                lda $79
e434   a6 7a                ldx $7a
e436   a0 01      le436     ldy #$01
e438   85 aa                sta $aa
e43a   86 ab                stx $ab
e43c   b1 aa                lda ($aa),y
e43e   f0 1f                beq le45f
e440   c8                   iny
e441   c8                   iny
e442   a5 12                lda $12
e444   d1 aa                cmp ($aa),y
e446   90 18                bcc le460
e448   f0 03                beq le44d
e44a   88                   dey
e44b   d0 09                bne le456
e44d   a5 11      le44d     lda $11
e44f   88                   dey
e450   d1 aa                cmp ($aa),y
e452   90 0c                bcc le460
e454   f0 0a                beq le460
e456   88         le456     dey
e457   b1 aa                lda ($aa),y
e459   aa                   tax
e45a   88                   dey
e45b   b1 aa                lda ($aa),y
e45d   b0 d7                bcs le436
e45f   18         le45f     clc
e460   60         le460     rts
e461   d0 fd                bne le460
e463   a9 00                lda #$00
e465   a8                   tay
e466   91 79                sta ($79),y
e468   c8                   iny
e469   91 79                sta ($79),y
e46b   a5 79                lda $79
e46d   69 02                adc #$02
e46f   85 7b                sta $7b
e471   a5 7a                lda $7a
e473   69 00                adc #$00
e475   85 7c                sta $7c
e477   20 a7 a4             jsr $a4a7
e47a   a5 85                lda $85
e47c   a4 86                ldy $86
e47e   85 81                sta $81
e480   84 82                sty $82
e482   a5 7b                lda $7b
e484   a4 7c                ldy $7c
e486   85 7d                sta $7d
e488   84 7e                sty $7e
e48a   85 7f                sta $7f
e48c   84 80                sty $80
e48e   20 1a a6             jsr $a61a
e491   a2 68                ldx #$68
e493   86 65                stx $65
e495   68                   pla
e496   8d fd 01             sta $01fd
e499   68                   pla
e49a   8d fe 01             sta $01fe
e49d   a2 fc                ldx #$fc
e49f   9a                   txs
e4a0   a9 00                lda #$00
e4a2   85 8c                sta $8c
e4a4   85 61                sta $61
e4a6   60         le4a6     rts
e4a7   18                   clc
e4a8   a5 79                lda $79
e4aa   69 ff                adc #$ff
e4ac   85 c3                sta $c3
e4ae   a5 7a                lda $7a
e4b0   69 ff                adc #$ff
e4b2   85 c4                sta $c4
e4b4   60                   rts
e4b5   90 06                bcc le4bd
e4b7   f0 04                beq le4bd
e4b9   c9 a4                cmp #$a4
e4bb   d0 e9                bne le4a6
e4bd   20 7f a7   le4bd     jsr $a77f
e4c0   20 32 a4             jsr $a432
e4c3   20 c2 00             jsr $00c2
e4c6   f0 0c                beq le4d4
e4c8   c9 a4                cmp #$a4
e4ca   d0 94                bne le460
e4cc   20 bc 00             jsr $00bc
e4cf   20 7f a7             jsr $a77f
e4d2   d0 8c                bne le460
e4d4   68         le4d4     pla
e4d5   68                   pla
e4d6   a5 11                lda $11
e4d8   05 12                ora $12
e4da   d0 06                bne le4e2
e4dc   a9 ff                lda #$ff
e4de   85 11                sta $11
e4e0   85 12                sta $12
e4e2   a0 01      le4e2     ldy #$01
e4e4   84 60                sty $60
e4e6   b1 aa                lda ($aa),y
e4e8   f0 41                beq le52b
e4ea   20 29 a6             jsr $a629
e4ed   20 6c a8             jsr $a86c
e4f0   c8                   iny
e4f1   b1 aa                lda ($aa),y
e4f3   aa                   tax
e4f4   c8                   iny
e4f5   b1 aa                lda ($aa),y
e4f7   c5 12                cmp $12
e4f9   d0 04                bne le4ff
e4fb   e4 11                cpx $11
e4fd   f0 02                beq le501
e4ff   b0 2a      le4ff     bcs le52b
e501   84 97      le501     sty $97
e503   20 5e b9             jsr $b95e
e506   a9 20                lda #$20
e508   a4 97      le508     ldy $97
e50a   29 7f                and #$7f
e50c   20 e5 a8   le50c     jsr $a8e5
e50f   c9 22                cmp #$22
e511   d0 06                bne le519
e513   a5 60                lda $60
e515   49 ff                eor #$ff
e517   85 60                sta $60
e519   c8         le519     iny
e51a   b1 aa                lda ($aa),y
e51c   d0 10                bne le52e
e51e   a8                   tay
e51f   b1 aa                lda ($aa),y
e521   aa                   tax
e522   c8                   iny
e523   b1 aa                lda ($aa),y
e525   86 aa                stx $aa
e527   85 ab                sta $ab
e529   d0 b7                bne le4e2
e52b   4c 74 a2   le52b     jmp $a274
e52e   10 dc      le52e     bpl le50c
e530   c9 ff                cmp #$ff
e532   f0 d8                beq le50c
e534   24 60                bit $60
e536   30 d4                bmi le50c
e538   38                   sec
e539   e9 7f                sbc #$7f
e53b   aa                   tax
e53c   84 97                sty $97
e53e   a0 ff                ldy #$ff
e540   ca         le540     dex
e541   f0 08                beq le54b
e543   c8         le543     iny
e544   b9 84 a0             lda $a084,y
e547   10 fa                bpl le543
e549   30 f5                bmi le540
e54b   c8         le54b     iny
e54c   b9 84 a0             lda $a084,y
e54f   30 b7                bmi le508
e551   20 e5 a8             jsr $a8e5
e554   d0 f5                bne le54b
e556   a9 80                lda #$80
e558   85 61                sta $61
e55a   20 b9 a7             jsr $a7b9
e55d   20 a1 a1             jsr $a1a1
e560   d0 05                bne le567
e562   8a                   txa
e563   69 0d                adc #$0d
e565   aa                   tax
e566   9a                   txs
e567   68         le567     pla
e568   68                   pla
e569   a9 08                lda #$08
e56b   20 12 a2             jsr $a212
e56e   20 1a a7             jsr $a71a
e571   18                   clc
e572   98                   tya
e573   65 c3                adc $c3
e575   48                   pha
e576   a5 c4                lda $c4
e578   69 00                adc #$00
e57a   48                   pha
e57b   a5 88                lda $88
e57d   48                   pha
e57e   a5 87                lda $87
e580   48                   pha
e581   a9 9d                lda #$9d
e583   20 03 ac             jsr $ac03
e586   20 b0 aa             jsr $aab0
e589   20 ad aa             jsr $aaad
e58c   a5 b0                lda $b0
e58e   09 7f                ora #$7f
e590   25 ad                and $ad
e592   85 ad                sta $ad
e594   a9 9f                lda #$9f
e596   a0 a5                ldy #$a5
e598   85 71                sta $71
e59a   84 72                sty $72
e59c   4c 66 ab             jmp $ab66
e59f   a9 9c                lda #$9c
e5a1   a0 b5                ldy #$b5
e5a3   20 4b b7             jsr $b74b
e5a6   20 c2 00             jsr $00c2
e5a9   c9 a2                cmp #$a2
e5ab   d0 06                bne le5b3
e5ad   20 bc 00             jsr $00bc
e5b0   20 ad aa             jsr $aaad
e5b3   20 ca b7   le5b3     jsr $b7ca
e5b6   20 5b ab             jsr $ab5b
e5b9   a5 98                lda $98
e5bb   48                   pha
e5bc   a5 97                lda $97
e5be   48                   pha
e5bf   a9 81                lda #$81
e5c1   48                   pha
e5c2   20 29 a6             jsr $a629
e5c5   a5 c3                lda $c3
e5c7   a4 c4                ldy $c4
e5c9   f0 06                beq le5d1
e5cb   85 8b                sta $8b
e5cd   84 8c                sty $8c
e5cf   a0 00                ldy #$00
e5d1   b1 c3      le5d1     lda ($c3),y
e5d3   f0 07                beq le5dc
e5d5   c9 3a                cmp #$3a
e5d7   f0 1d                beq le5f6
e5d9   4c 0c ac   le5d9     jmp $ac0c
e5dc   a0 02      le5dc     ldy #$02
e5de   b1 c3                lda ($c3),y
e5e0   18                   clc
e5e1   f0 6e                beq le651
e5e3   c8                   iny
e5e4   b1 c3                lda ($c3),y
e5e6   85 87                sta $87
e5e8   c8                   iny
e5e9   b1 c3                lda ($c3),y
e5eb   85 88                sta $88
e5ed   98                   tya
e5ee   65 c3                adc $c3
e5f0   85 c3                sta $c3
e5f2   90 02                bcc le5f6
e5f4   e6 c4                inc $c4
e5f6   20 bc 00   le5f6     jsr $00bc
e5f9   20 ff a5             jsr $a5ff
e5fc   4c c2 a5             jmp $a5c2
e5ff   f0 79                beq le67a
e601   38                   sec
e602   e9 80                sbc #$80
e604   b0 03                bcs le609
e606   4c b9 a7             jmp $a7b9
e609   c9 1c      le609     cmp #$1c
e60b   b0 cc                bcs le5d9
e60d   0a                   asl a
e60e   a8                   tay
e60f   b9 01 a0             lda $a001,y
e612   48                   pha
e613   b9 00 a0             lda $a000,y
e616   48                   pha
e617   4c bc 00             jmp $00bc
e61a   38                   sec
e61b   a5 79                lda $79
e61d   e9 01                sbc #$01
e61f   a4 7a                ldy $7a
e621   b0 01                bcs le624
e623   88                   dey
e624   85 8f      le624     sta $8f
e626   84 90                sty $90
e628   60         le628     rts
e629   4c f1 ff             jmp lfff1
e62c   ea                   nop
e62d   ea                   nop
e62e   ea                   nop
e62f   ea                   nop
e630   4a                   lsr a
e631   90 f5                bcc le628
e633   20 86 a3             jsr $a386
e636   c9 03                cmp #$03
e638   b0 01                bcs le63b
e63a   18                   clc
e63b   d0 3d      le63b     bne le67a
e63d   a5 c3                lda $c3
e63f   a4 c4                ldy $c4
e641   f0 0c                beq le64f
e643   85 8b                sta $8b
e645   84 8c                sty $8c
e647   a5 87                lda $87
e649   a4 88                ldy $88
e64b   85 89                sta $89
e64d   84 8a                sty $8a
e64f   68         le64f     pla
e650   68                   pla
e651   a9 99      le651     lda #$99
e653   a0 a1                ldy #$a1
e655   a2 00                ldx #$00
e657   86 64                stx $64
e659   90 03                bcc le65e
e65b   4c 69 a2             jmp $a269
e65e   4c 74 a2   le65e     jmp $a274
e661   d0 17                bne le67a
e663   a2 1e                ldx #$1e
e665   a4 8c                ldy $8c
e667   d0 03                bne le66c
e669   4c 4e a2             jmp $a24e
e66c   a5 8b      le66c     lda $8b
e66e   85 c3                sta $c3
e670   84 c4                sty $c4
e672   a5 89                lda $89
e674   a4 8a                ldy $8a
e676   85 87                sta $87
e678   84 88                sty $88
e67a   60         le67a     rts
e67b   20 ae b3             jsr $b3ae
e67e   d0 fa                bne le67a
e680   e8                   inx
e681   e0 0a                cpx #$0a
e683   b0 04                bcs le689
e685   ca                   dex
e686   86 0d                stx $0d
e688   60                   rts
e689   4c 88 ae   le689     jmp $ae88
e68c   d0 ec                bne le67a
e68e   4c 7a a4             jmp $a47a
e691   d0 03                bne le696
e693   4c 77 a4             jmp $a477
e696   20 7a a4   le696     jsr $a47a
e699   4c b0 a6             jmp $a6b0
e69c   a9 03                lda #$03
e69e   20 12 a2             jsr $a212
e6a1   a5 c4                lda $c4
e6a3   48                   pha
e6a4   a5 c3                lda $c3
e6a6   48                   pha
e6a7   a5 88                lda $88
e6a9   48                   pha
e6aa   a5 87                lda $87
e6ac   48                   pha
e6ad   a9 8c                lda #$8c
e6af   48                   pha
e6b0   20 c2 00             jsr $00c2
e6b3   20 b9 a6             jsr $a6b9
e6b6   4c c2 a5             jmp $a5c2
e6b9   20 7f a7             jsr $a77f
e6bc   20 1d a7             jsr $a71d
e6bf   a5 88                lda $88
e6c1   c5 12                cmp $12
e6c3   b0 0b                bcs le6d0
e6c5   98                   tya
e6c6   38                   sec
e6c7   65 c3                adc $c3
e6c9   a6 c4                ldx $c4
e6cb   90 07                bcc le6d4
e6cd   e8                   inx
e6ce   b0 04                bcs le6d4
e6d0   a5 79      le6d0     lda $79
e6d2   a6 7a                ldx $7a
e6d4   20 36 a4   le6d4     jsr $a436
e6d7   90 1e                bcc le6f7
e6d9   a5 aa                lda $aa
e6db   e9 01                sbc #$01
e6dd   85 c3                sta $c3
e6df   a5 ab                lda $ab
e6e1   e9 00                sbc #$00
e6e3   85 c4                sta $c4
e6e5   60         le6e5     rts
e6e6   d0 fd                bne le6e5
e6e8   a9 ff                lda #$ff
e6ea   85 97                sta $97
e6ec   20 a1 a1             jsr $a1a1
e6ef   9a                   txs
e6f0   c9 8c                cmp #$8c
e6f2   f0 0b                beq le6ff
e6f4   a2 04                ldx #$04
e6f6   2c a2 0e             bit $0ea2
e6f9   4c 4e a2             jmp $a24e
e6fc   4c 0c ac   le6fc     jmp $ac0c
e6ff   68         le6ff     pla
e700   68                   pla
e701   85 87                sta $87
e703   68                   pla
e704   85 88                sta $88
e706   68                   pla
e707   85 c3                sta $c3
e709   68                   pla
e70a   85 c4                sta $c4
e70c   20 1a a7             jsr $a71a
e70f   98         le70f     tya
e710   18                   clc
e711   65 c3                adc $c3
e713   85 c3                sta $c3
e715   90 02                bcc le719
e717   e6 c4                inc $c4
e719   60         le719     rts
e71a   a2 3a                ldx #$3a
e71c   2c a2 00             bit $00a2
e71f   86 5b                stx $5b
e721   a0 00                ldy #$00
e723   84 5c                sty $5c
e725   a5 5c      le725     lda $5c
e727   a6 5b                ldx $5b
e729   85 5b                sta $5b
e72b   86 5c                stx $5c
e72d   b1 c3      le72d     lda ($c3),y
e72f   f0 e8                beq le719
e731   c5 5c                cmp $5c
e733   f0 e4                beq le719
e735   c8                   iny
e736   c9 22                cmp #$22
e738   f0 eb                beq le725
e73a   d0 f1                bne le72d
e73c   20 c1 aa             jsr $aac1
e73f   20 c2 00             jsr $00c2
e742   c9 88                cmp #$88
e744   f0 05                beq le74b
e746   a9 a0                lda #$a0
e748   20 03 ac             jsr $ac03
e74b   a5 ac      le74b     lda $ac
e74d   d0 05                bne le754
e74f   20 1d a7             jsr $a71d
e752   f0 bb                beq le70f
e754   20 c2 00   le754     jsr $00c2
e757   b0 03                bcs le75c
e759   4c b9 a6             jmp $a6b9
e75c   4c ff a5   le75c     jmp $a5ff
e75f   20 ae b3             jsr $b3ae
e762   48                   pha
e763   c9 8c                cmp #$8c
e765   f0 04                beq le76b
e767   c9 88      le767     cmp #$88
e769   d0 91                bne le6fc
e76b   c6 af      le76b     dec $af
e76d   d0 04                bne le773
e76f   68                   pla
e770   4c 02 a6             jmp $a602
e773   20 bc 00   le773     jsr $00bc
e776   20 7f a7             jsr $a77f
e779   c9 2c                cmp #$2c
e77b   f0 ee                beq le76b
e77d   68                   pla
e77e   60         le77e     rts
e77f   a2 00                ldx #$00
e781   86 11                stx $11
e783   86 12                stx $12
e785   b0 f7                bcs le77e
e787   e9 2f                sbc #$2f
e789   85 5b                sta $5b
e78b   a5 12                lda $12
e78d   85 71                sta $71
e78f   c9 19                cmp #$19
e791   b0 d4                bcs le767
e793   a5 11                lda $11
e795   0a                   asl a
e796   26 71                rol $71
e798   0a                   asl a
e799   26 71                rol $71
e79b   65 11                adc $11
e79d   85 11                sta $11
e79f   a5 71                lda $71
e7a1   65 12                adc $12
e7a3   85 12                sta $12
e7a5   06 11                asl $11
e7a7   26 12                rol $12
e7a9   a5 11                lda $11
e7ab   65 5b                adc $5b
e7ad   85 11                sta $11
e7af   90 02                bcc le7b3
e7b1   e6 12                inc $12
e7b3   20 bc 00   le7b3     jsr $00bc
e7b6   4c 85 a7             jmp $a785
e7b9   20 0b ad             jsr $ad0b
e7bc   85 97                sta $97
e7be   84 98                sty $98
e7c0   a9 ab                lda #$ab
e7c2   20 03 ac             jsr $ac03
e7c5   a5 5f                lda $5f
e7c7   48                   pha
e7c8   20 c1 aa             jsr $aac1
e7cb   68                   pla
e7cc   2a                   rol a
e7cd   20 b3 aa             jsr $aab3
e7d0   d0 03                bne le7d5
e7d2   4c 74 b7             jmp $b774
e7d5   a0 02      le7d5     ldy #$02
e7d7   b1 ae                lda ($ae),y
e7d9   c5 82                cmp $82
e7db   90 17                bcc le7f4
e7dd   d0 07                bne le7e6
e7df   88                   dey
e7e0   b1 ae                lda ($ae),y
e7e2   c5 81                cmp $81
e7e4   90 0e                bcc le7f4
e7e6   a4 af      le7e6     ldy $af
e7e8   c4 7c                cpy $7c
e7ea   90 08                bcc le7f4
e7ec   d0 0d                bne le7fb
e7ee   a5 ae                lda $ae
e7f0   c5 7b                cmp $7b
e7f2   b0 07                bcs le7fb
e7f4   a5 ae      le7f4     lda $ae
e7f6   a4 af                ldy $af
e7f8   4c 11 a8             jmp $a811
e7fb   a0 00      le7fb     ldy #$00
e7fd   b1 ae                lda ($ae),y
e7ff   20 9c b0             jsr $b09c
e802   a5 9e                lda $9e
e804   a4 9f                ldy $9f
e806   85 b8                sta $b8
e808   84 b9                sty $b9
e80a   20 8a b2             jsr $b28a
e80d   a9 ac                lda #$ac
e80f   a0 00                ldy #$00
e811   85 9e                sta $9e
e813   84 9f                sty $9f
e815   20 eb b2             jsr $b2eb
e818   a0 00                ldy #$00
e81a   b1 9e                lda ($9e),y
e81c   91 97                sta ($97),y
e81e   c8                   iny
e81f   b1 9e                lda ($9e),y
e821   91 97                sta ($97),y
e823   c8                   iny
e824   b1 9e                lda ($9e),y
e826   91 97                sta ($97),y
e828   60                   rts
e829   20 c6 a8   le829     jsr $a8c6
e82c   20 c2 00   le82c     jsr $00c2
e82f   f0 3b                beq le86c
e831   f0 57                beq le88a
e833   c9 9c                cmp #$9c
e835   f0 6b                beq le8a2
e837   c9 9f                cmp #$9f
e839   f0 67                beq le8a2
e83b   c9 2c                cmp #$2c
e83d   f0 4c                beq le88b
e83f   c9 3b                cmp #$3b
e841   f0 7a                beq le8bd
e843   20 c1 aa             jsr $aac1
e846   24 5f                bit $5f
e848   30 df                bmi le829
e84a   20 6e b9             jsr $b96e
e84d   20 ae b0             jsr $b0ae
e850   a0 00                ldy #$00
e852   b1 ae                lda ($ae),y
e854   18                   clc
e855   65 0e                adc $0e
e857   c5 0f                cmp $0f
e859   90 03                bcc le85e
e85b   20 6c a8             jsr $a86c
e85e   20 c6 a8   le85e     jsr $a8c6
e861   20 e0 a8             jsr $a8e0
e864   d0 c6                bne le82c
e866   a0 00                ldy #$00
e868   94 13                sty $13,x
e86a   a2 12                ldx #$12
e86c   a9 0d      le86c     lda #$0d
e86e   85 0e                sta $0e
e870   20 e5 a8             jsr $a8e5
e873   a9 0a                lda #$0a
e875   20 e5 a8             jsr $a8e5
e878   8a                   txa
e879   48                   pha
e87a   a6 0d                ldx $0d
e87c   f0 08                beq le886
e87e   a9 00                lda #$00
e880   20 e5 a8   le880     jsr $a8e5
e883   ca                   dex
e884   d0 fa                bne le880
e886   86 0e      le886     stx $0e
e888   68                   pla
e889   aa                   tax
e88a   60         le88a     rts
e88b   a5 0e      le88b     lda $0e
e88d   c5 10                cmp $10
e88f   90 06                bcc le897
e891   20 6c a8             jsr $a86c
e894   4c bd a8             jmp $a8bd
e897   38         le897     sec
e898   e9 0e      le898     sbc #$0e
e89a   b0 fc                bcs le898
e89c   49 ff                eor #$ff
e89e   69 01                adc #$01
e8a0   d0 14                bne le8b6
e8a2   48         le8a2     pha
e8a3   20 ab b3             jsr $b3ab
e8a6   c9 29                cmp #$29
e8a8   d0 66                bne le910
e8aa   68                   pla
e8ab   c9 9c                cmp #$9c
e8ad   d0 08                bne le8b7
e8af   8a                   txa
e8b0   e5 0e                sbc $0e
e8b2   90 09                bcc le8bd
e8b4   f0 07                beq le8bd
e8b6   aa         le8b6     tax
e8b7   20 e0 a8   le8b7     jsr $a8e0
e8ba   ca                   dex
e8bb   d0 fa                bne le8b7
e8bd   20 bc 00   le8bd     jsr $00bc
e8c0   4c 31 a8             jmp $a831
e8c3   20 ae b0             jsr $b0ae
e8c6   20 b6 b2             jsr $b2b6
e8c9   aa                   tax
e8ca   a0 00                ldy #$00
e8cc   e8                   inx
e8cd   ca         le8cd     dex
e8ce   f0 ba                beq le88a
e8d0   b1 71                lda ($71),y
e8d2   20 e5 a8             jsr $a8e5
e8d5   c8                   iny
e8d6   c9 0d                cmp #$0d
e8d8   d0 f3                bne le8cd
e8da   20 78 a8             jsr $a878
e8dd   4c cd a8             jmp $a8cd
e8e0   a9 20                lda #$20
e8e2   2c a9 3f             bit $3fa9
e8e5   24 64                bit $64
e8e7   30 18                bmi le901
e8e9   48                   pha
e8ea   c9 20                cmp #$20
e8ec   90 0b                bcc le8f9
e8ee   a5 0e                lda $0e
e8f0   c5 0f                cmp $0f
e8f2   d0 03                bne le8f7
e8f4   20 6c a8             jsr $a86c
e8f7   e6 0e      le8f7     inc $0e
e8f9   68         le8f9     pla
e8fa   20 ee ff             jsr lffee
e8fd   ea                   nop
e8fe   ea                   nop
e8ff   ea                   nop
e900   ea                   nop
e901   29 ff      le901     and #$ff
e903   60                   rts
e904   a5 62                lda $62
e906   f0 0b                beq le913
e908   a5 8d                lda $8d
e90a   a4 8e                ldy $8e
e90c   85 87                sta $87
e90e   84 88                sty $88
e910   4c 0c ac   le910     jmp $ac0c
e913   a9 2d      le913     lda #$2d
e915   a0 aa                ldy #$aa
e917   20 c3 a8             jsr $a8c3
e91a   a5 8b                lda $8b
e91c   a4 8c                ldy $8c
e91e   85 c3                sta $c3
e920   84 c4                sty $c4
e922   60                   rts
e923   46 64                lsr $64
e925   c9 22                cmp #$22
e927   d0 0b                bne le934
e929   20 c1 ab             jsr $abc1
e92c   a9 3b                lda #$3b
e92e   20 03 ac             jsr $ac03
e931   20 c6 a8             jsr $a8c6
e934   20 d4 af   le934     jsr $afd4
e937   a9 2c                lda #$2c
e939   85 12                sta $12
e93b   20 46 a9             jsr $a946
e93e   a5 13                lda $13
e940   d0 12                bne le954
e942   18                   clc
e943   4c 47 a6             jmp $a647
e946   20 e3 a8             jsr $a8e3
e949   20 e0 a8             jsr $a8e0
e94c   4c 57 a3             jmp $a357
e94f   a6 8f                ldx $8f
e951   a4 90                ldy $90
e953   a9 98                lda #$98
e955   85 62                sta $62
e957   86 91                stx $91
e959   84 92                sty $92
e95b   20 0b ad             jsr $ad0b
e95e   85 97                sta $97
e960   84 98                sty $98
e962   a5 c3                lda $c3
e964   a4 c4                ldy $c4
e966   85 11                sta $11
e968   84 12                sty $12
e96a   a6 91                ldx $91
e96c   a4 92                ldy $92
e96e   86 c3                stx $c3
e970   84 c4                sty $c4
e972   20 c2 00             jsr $00c2
e975   d0 0e                bne le985
e977   24 62                bit $62
e979   30 62                bmi le9dd
e97b   20 e3 a8             jsr $a8e3
e97e   20 46 a9             jsr $a946
e981   86 c3                stx $c3
e983   84 c4                sty $c4
e985   20 bc 00   le985     jsr $00bc
e988   24 5f                bit $5f
e98a   10 24                bpl le9b0
e98c   85 5b                sta $5b
e98e   c9 22                cmp #$22
e990   f0 07                beq le999
e992   a9 3a                lda #$3a
e994   85 5b                sta $5b
e996   a9 2c                lda #$2c
e998   18                   clc
e999   85 5c      le999     sta $5c
e99b   a5 c3                lda $c3
e99d   a4 c4                ldy $c4
e99f   69 00                adc #$00
e9a1   90 01                bcc le9a4
e9a3   c8                   iny
e9a4   20 b4 b0   le9a4     jsr $b0b4
e9a7   20 f3 b3             jsr $b3f3
e9aa   20 d5 a7             jsr $a7d5
e9ad   4c b6 a9             jmp $a9b6
e9b0   20 87 b8   le9b0     jsr $b887
e9b3   20 74 b7             jsr $b774
e9b6   20 c2 00             jsr $00c2
e9b9   f0 07                beq le9c2
e9bb   c9 2c                cmp #$2c
e9bd   f0 03                beq le9c2
e9bf   4c 04 a9             jmp $a904
e9c2   a5 c3      le9c2     lda $c3
e9c4   a4 c4                ldy $c4
e9c6   85 91                sta $91
e9c8   84 92                sty $92
e9ca   a5 11                lda $11
e9cc   a4 12                ldy $12
e9ce   85 c3                sta $c3
e9d0   84 c4                sty $c4
e9d2   20 c2 00             jsr $00c2
e9d5   f0 2c                beq lea03
e9d7   20 01 ac             jsr $ac01
e9da   4c 5b a9             jmp $a95b
e9dd   20 1a a7   le9dd     jsr $a71a
e9e0   c8                   iny
e9e1   aa                   tax
e9e2   d0 12                bne le9f6
e9e4   a2 06                ldx #$06
e9e6   c8                   iny
e9e7   b1 c3                lda ($c3),y
e9e9   f0 69                beq lea54
e9eb   c8                   iny
e9ec   b1 c3                lda ($c3),y
e9ee   85 8d                sta $8d
e9f0   c8                   iny
e9f1   b1 c3                lda ($c3),y
e9f3   c8                   iny
e9f4   85 8e                sta $8e
e9f6   b1 c3      le9f6     lda ($c3),y
e9f8   aa                   tax
e9f9   20 0f a7             jsr $a70f
e9fc   e0 83                cpx #$83
e9fe   d0 dd                bne le9dd
ea00   4c 85 a9             jmp $a985
ea03   a5 91      lea03     lda $91
ea05   a4 92                ldy $92
ea07   a6 62                ldx $62
ea09   f0 03                beq lea0e
ea0b   4c 24 a6             jmp $a624
ea0e   a0 00      lea0e     ldy #$00
ea10   b1 91                lda ($91),y
ea12   f0 07                beq lea1b
ea14   a9 1c                lda #$1c
ea16   a0 aa                ldy #$aa
ea18   4c c3 a8             jmp $a8c3
ea1b   60         lea1b     rts
ea1c   3f                   ???                ;%00111111 '?'
ea1d   45 58                eor $58
ea1f   54                   ???                ;%01010100 'T'
ea20   52                   ???                ;%01010010 'R'
ea21   41 20                eor ($20,x)
ea23   49 47                eor #$47
ea25   4e 4f 52             lsr $524f
ea28   45 44                eor $44
ea2a   0d 0a 00             ora $000a
ea2d   3f                   ???                ;%00111111 '?'
ea2e   52                   ???                ;%01010010 'R'
ea2f   45 44                eor $44
ea31   4f                   ???                ;%01001111 'O'
ea32   20 46 52             jsr $5246
ea35   4f                   ???                ;%01001111 'O'
ea36   4d 20 53             eor $5320
ea39   54                   ???                ;%01010100 'T'
ea3a   41 52                eor ($52,x)
ea3c   54                   ???                ;%01010100 'T'
ea3d   0d 0a 00             ora $000a
ea40   d0 04                bne lea46
ea42   a0 00                ldy #$00
ea44   f0 03                beq lea49
ea46   20 0b ad   lea46     jsr $ad0b
ea49   85 97      lea49     sta $97
ea4b   84 98                sty $98
ea4d   20 a1 a1             jsr $a1a1
ea50   f0 04                beq lea56
ea52   a2 00                ldx #$00
ea54   f0 68      lea54     beq leabe
ea56   9a         lea56     txs
ea57   e8                   inx
ea58   e8                   inx
ea59   e8                   inx
ea5a   e8                   inx
ea5b   8a                   txa
ea5c   e8                   inx
ea5d   e8                   inx
ea5e   e8                   inx
ea5f   e8                   inx
ea60   e8                   inx
ea61   86 73                stx $73
ea63   a0 01                ldy #$01
ea65   20 4b b7             jsr $b74b
ea68   ba                   tsx
ea69   bd 08 01             lda $0108,x
ea6c   85 b0                sta $b0
ea6e   a5 97                lda $97
ea70   a4 98                ldy $98
ea72   20 6c b4             jsr $b46c
ea75   20 74 b7             jsr $b774
ea78   a0 01                ldy #$01
ea7a   20 fa b7             jsr $b7fa
ea7d   ba                   tsx
ea7e   38                   sec
ea7f   fd 08 01             sbc $0108,x
ea82   f0 17                beq lea9b
ea84   bd 0d 01             lda $010d,x
ea87   85 87                sta $87
ea89   bd 0e 01             lda $010e,x
ea8c   85 88                sta $88
ea8e   bd 10 01             lda $0110,x
ea91   85 c3                sta $c3
ea93   bd 0f 01             lda $010f,x
ea96   85 c4                sta $c4
ea98   4c c2 a5   lea98     jmp $a5c2
ea9b   8a         lea9b     txa
ea9c   69 0f                adc #$0f
ea9e   aa                   tax
ea9f   9a                   txs
eaa0   20 c2 00             jsr $00c2
eaa3   c9 2c                cmp #$2c
eaa5   d0 f1                bne lea98
eaa7   20 bc 00             jsr $00bc
eaaa   20 46 aa             jsr $aa46
eaad   20 c1 aa             jsr $aac1
eab0   18                   clc
eab1   24 38                bit $38
eab3   24 5f                bit $5f
eab5   30 03                bmi leaba
eab7   b0 03                bcs leabc
eab9   60         leab9     rts
eaba   b0 fd      leaba     bcs leab9
eabc   a2 18      leabc     ldx #$18
eabe   4c 4e a2   leabe     jmp $a24e
eac1   a6 c3                ldx $c3
eac3   d0 02                bne leac7
eac5   c6 c4                dec $c4
eac7   c6 c3      leac7     dec $c3
eac9   a2 00                ldx #$00
eacb   24 48                bit $48
eacd   8a                   txa
eace   48                   pha
eacf   a9 01                lda #$01
ead1   20 12 a2             jsr $a212
ead4   20 a0 ab             jsr $aba0
ead7   a9 00                lda #$00
ead9   85 9b                sta $9b
eadb   20 c2 00             jsr $00c2
eade   38                   sec
eadf   e9 aa                sbc #$aa
eae1   90 17                bcc leafa
eae3   c9 03                cmp #$03
eae5   b0 13                bcs leafa
eae7   c9 01                cmp #$01
eae9   2a                   rol a
eaea   49 01                eor #$01
eaec   45 9b                eor $9b
eaee   c5 9b                cmp $9b
eaf0   90 61                bcc leb53
eaf2   85 9b                sta $9b
eaf4   20 bc 00             jsr $00bc
eaf7   4c de aa             jmp $aade
eafa   a6 9b      leafa     ldx $9b
eafc   d0 2c                bne leb2a
eafe   b0 78                bcs leb78
eb00   69 07                adc #$07
eb02   90 74                bcc leb78
eb04   65 5f                adc $5f
eb06   d0 03                bne leb0b
eb08   4c 4d b2             jmp $b24d
eb0b   69 ff      leb0b     adc #$ff
eb0d   85 71                sta $71
eb0f   0a                   asl a
eb10   65 71                adc $71
eb12   a8                   tay
eb13   68         leb13     pla
eb14   d9 66 a0             cmp $a066,y
eb17   b0 64                bcs leb7d
eb19   20 b0 aa             jsr $aab0
eb1c   48         leb1c     pha
eb1d   20 43 ab             jsr $ab43
eb20   68                   pla
eb21   a4 99                ldy $99
eb23   10 17                bpl leb3c
eb25   aa                   tax
eb26   f0 53                beq leb7b
eb28   d0 5c                bne leb86
eb2a   46 5f      leb2a     lsr $5f
eb2c   8a                   txa
eb2d   2a                   rol a
eb2e   a6 c3                ldx $c3
eb30   d0 02                bne leb34
eb32   c6 c4                dec $c4
eb34   c6 c3      leb34     dec $c3
eb36   a0 1b                ldy #$1b
eb38   85 9b                sta $9b
eb3a   d0 d7                bne leb13
eb3c   d9 66 a0   leb3c     cmp $a066,y
eb3f   b0 45                bcs leb86
eb41   90 d9                bcc leb1c
eb43   b9 68 a0             lda $a068,y
eb46   48                   pha
eb47   b9 67 a0             lda $a067,y
eb4a   48                   pha
eb4b   20 56 ab             jsr $ab56
eb4e   a5 9b                lda $9b
eb50   4c cc aa             jmp $aacc
eb53   4c 0c ac   leb53     jmp $ac0c
eb56   a5 b0                lda $b0
eb58   be 66 a0             ldx $a066,y
eb5b   a8                   tay
eb5c   68                   pla
eb5d   85 71                sta $71
eb5f   e6 71                inc $71
eb61   68                   pla
eb62   85 72                sta $72
eb64   98                   tya
eb65   48                   pha
eb66   20 ba b7             jsr $b7ba
eb69   a5 af                lda $af
eb6b   48                   pha
eb6c   a5 ae                lda $ae
eb6e   48                   pha
eb6f   a5 ad                lda $ad
eb71   48                   pha
eb72   a5 ac                lda $ac
eb74   48                   pha
eb75   6c 71 00             jmp ($0071)
eb78   a0 ff      leb78     ldy #$ff
eb7a   68                   pla
eb7b   f0 20      leb7b     beq leb9d
eb7d   c9 64      leb7d     cmp #$64
eb7f   f0 03                beq leb84
eb81   20 b0 aa             jsr $aab0
eb84   84 99      leb84     sty $99
eb86   68         leb86     pla
eb87   4a                   lsr a
eb88   85 63                sta $63
eb8a   68                   pla
eb8b   85 b3                sta $b3
eb8d   68                   pla
eb8e   85 b4                sta $b4
eb90   68                   pla
eb91   85 b5                sta $b5
eb93   68                   pla
eb94   85 b6                sta $b6
eb96   68                   pla
eb97   85 b7                sta $b7
eb99   45 b0                eor $b0
eb9b   85 b8                sta $b8
eb9d   a5 ac      leb9d     lda $ac
eb9f   60                   rts
eba0   a9 00                lda #$00
eba2   85 5f                sta $5f
eba4   20 bc 00   leba4     jsr $00bc
eba7   b0 03                bcs lebac
eba9   4c 87 b8   leba9     jmp $b887
ebac   20 81 ad   lebac     jsr $ad81
ebaf   b0 67                bcs lec18
ebb1   c9 2e                cmp #$2e
ebb3   f0 f4                beq leba9
ebb5   c9 a4                cmp #$a4
ebb7   f0 58                beq lec11
ebb9   c9 a3                cmp #$a3
ebbb   f0 e7                beq leba4
ebbd   c9 22                cmp #$22
ebbf   d0 0f                bne lebd0
ebc1   a5 c3                lda $c3
ebc3   a4 c4                ldy $c4
ebc5   69 00                adc #$00
ebc7   90 01                bcc lebca
ebc9   c8                   iny
ebca   20 ae b0   lebca     jsr $b0ae
ebcd   4c f3 b3             jmp $b3f3
ebd0   c9 a1      lebd0     cmp #$a1
ebd2   d0 13                bne lebe7
ebd4   a0 18                ldy #$18
ebd6   d0 3b                bne lec13
ebd8   20 05 ae             jsr $ae05
ebdb   a5 af                lda $af
ebdd   49 ff                eor #$ff
ebdf   a8                   tay
ebe0   a5 ae                lda $ae
ebe2   49 ff                eor #$ff
ebe4   4c c1 af             jmp $afc1
ebe7   c9 9e      lebe7     cmp #$9e
ebe9   d0 03                bne lebee
ebeb   4c 1e b0             jmp $b01e
ebee   c9 ad      lebee     cmp #$ad
ebf0   90 03                bcc lebf5
ebf2   4c 27 ac             jmp $ac27
ebf5   20 fe ab   lebf5     jsr $abfe
ebf8   20 c1 aa             jsr $aac1
ebfb   a9 29                lda #$29
ebfd   2c a9 28             bit $28a9
ec00   2c a9 2c             bit $2ca9
ec03   a0 00                ldy #$00
ec05   d1 c3                cmp ($c3),y
ec07   d0 03                bne lec0c
ec09   4c bc 00             jmp $00bc
ec0c   a2 02      lec0c     ldx #$02
ec0e   4c 4e a2             jmp $a24e
ec11   a0 15      lec11     ldy #$15
ec13   68         lec13     pla
ec14   68                   pla
ec15   4c 1d ab             jmp $ab1d
ec18   20 0b ad   lec18     jsr $ad0b
ec1b   85 ae                sta $ae
ec1d   84 af                sty $af
ec1f   a6 5f                ldx $5f
ec21   f0 01                beq lec24
ec23   60                   rts
ec24   4c 4b b7   lec24     jmp $b74b
ec27   0a                   asl a
ec28   48                   pha
ec29   aa                   tax
ec2a   20 bc 00             jsr $00bc
ec2d   e0 81                cpx #$81
ec2f   90 20                bcc lec51
ec31   20 fe ab             jsr $abfe
ec34   20 c1 aa             jsr $aac1
ec37   20 01 ac             jsr $ac01
ec3a   20 b2 aa             jsr $aab2
ec3d   68                   pla
ec3e   aa                   tax
ec3f   a5 af                lda $af
ec41   48                   pha
ec42   a5 ae                lda $ae
ec44   48                   pha
ec45   8a                   txa
ec46   48                   pha
ec47   20 ae b3             jsr $b3ae
ec4a   68                   pla
ec4b   a8                   tay
ec4c   8a                   txa
ec4d   48                   pha
ec4e   4c 56 ac             jmp $ac56
ec51   20 f5 ab   lec51     jsr $abf5
ec54   68                   pla
ec55   a8                   tay
ec56   b9 de 9f             lda $9fde,y
ec59   85 a2                sta $a2
ec5b   b9 df 9f             lda $9fdf,y
ec5e   85 a3                sta $a3
ec60   20 a1 00             jsr $00a1
ec63   4c b0 aa             jmp $aab0
ec66   a0 ff                ldy #$ff
ec68   2c a0 00             bit $00a0
ec6b   84 5d                sty $5d
ec6d   20 05 ae             jsr $ae05
ec70   a5 ae                lda $ae
ec72   45 5d                eor $5d
ec74   85 5b                sta $5b
ec76   a5 af                lda $af
ec78   45 5d                eor $5d
ec7a   85 5c                sta $5c
ec7c   20 9b b7             jsr $b79b
ec7f   20 05 ae             jsr $ae05
ec82   a5 af                lda $af
ec84   45 5d                eor $5d
ec86   25 5c                and $5c
ec88   45 5d                eor $5d
ec8a   a8                   tay
ec8b   a5 ae                lda $ae
ec8d   45 5d                eor $5d
ec8f   25 5b                and $5b
ec91   45 5d                eor $5d
ec93   4c c1 af             jmp $afc1
ec96   20 b3 aa             jsr $aab3
ec99   b0 13                bcs lecae
ec9b   a5 b7                lda $b7
ec9d   09 7f                ora #$7f
ec9f   25 b4                and $b4
eca1   85 b4                sta $b4
eca3   a9 b3                lda #$b3
eca5   a0 00                ldy #$00
eca7   20 f8 b7             jsr $b7f8
ecaa   aa                   tax
ecab   4c e1 ac             jmp $ace1
ecae   a9 00      lecae     lda #$00
ecb0   85 5f                sta $5f
ecb2   c6 9b                dec $9b
ecb4   20 b6 b2             jsr $b2b6
ecb7   85 ac                sta $ac
ecb9   86 ad                stx $ad
ecbb   84 ae                sty $ae
ecbd   a5 b5                lda $b5
ecbf   a4 b6                ldy $b6
ecc1   20 ba b2             jsr $b2ba
ecc4   86 b5                stx $b5
ecc6   84 b6                sty $b6
ecc8   aa                   tax
ecc9   38                   sec
ecca   e5 ac                sbc $ac
eccc   f0 08                beq lecd6
ecce   a9 01                lda #$01
ecd0   90 04                bcc lecd6
ecd2   a6 ac                ldx $ac
ecd4   a9 ff                lda #$ff
ecd6   85 b0      lecd6     sta $b0
ecd8   a0 ff                ldy #$ff
ecda   e8                   inx
ecdb   c8         lecdb     iny
ecdc   ca                   dex
ecdd   d0 07                bne lece6
ecdf   a6 b0                ldx $b0
ece1   30 0f                bmi lecf2
ece3   18                   clc
ece4   90 0c                bcc lecf2
ece6   b1 b5      lece6     lda ($b5),y
ece8   d1 ad                cmp ($ad),y
ecea   f0 ef                beq lecdb
ecec   a2 ff                ldx #$ff
ecee   b0 02                bcs lecf2
ecf0   a2 01                ldx #$01
ecf2   e8         lecf2     inx
ecf3   8a                   txa
ecf4   2a                   rol a
ecf5   25 63                and $63
ecf7   f0 02                beq lecfb
ecf9   a9 ff                lda #$ff
ecfb   4c db b7   lecfb     jmp $b7db
ecfe   20 01 ac   lecfe     jsr $ac01
ed01   aa                   tax
ed02   20 10 ad             jsr $ad10
ed05   20 c2 00             jsr $00c2
ed08   d0 f4                bne lecfe
ed0a   60                   rts
ed0b   a2 00                ldx #$00
ed0d   20 c2 00             jsr $00c2
ed10   86 5e                stx $5e
ed12   85 93                sta $93
ed14   20 c2 00             jsr $00c2
ed17   20 81 ad             jsr $ad81
ed1a   b0 03                bcs led1f
ed1c   4c 0c ac             jmp $ac0c
ed1f   a2 00      led1f     ldx #$00
ed21   86 5f                stx $5f
ed23   20 bc 00             jsr $00bc
ed26   90 05                bcc led2d
ed28   20 81 ad             jsr $ad81
ed2b   90 0b                bcc led38
ed2d   aa         led2d     tax
ed2e   20 bc 00   led2e     jsr $00bc
ed31   90 fb                bcc led2e
ed33   20 81 ad             jsr $ad81
ed36   b0 f6                bcs led2e
ed38   c9 24      led38     cmp #$24
ed3a   d0 0b                bne led47
ed3c   a9 ff                lda #$ff
ed3e   85 5f                sta $5f
ed40   8a                   txa
ed41   09 80                ora #$80
ed43   aa                   tax
ed44   20 bc 00             jsr $00bc
ed47   86 94      led47     stx $94
ed49   38                   sec
ed4a   05 61                ora $61
ed4c   e9 28                sbc #$28
ed4e   d0 03                bne led53
ed50   4c 17 ae             jmp $ae17
ed53   a9 00      led53     lda #$00
ed55   85 61                sta $61
ed57   a5 7b                lda $7b
ed59   a6 7c                ldx $7c
ed5b   a0 00                ldy #$00
ed5d   86 ab      led5d     stx $ab
ed5f   85 aa      led5f     sta $aa
ed61   e4 7e                cpx $7e
ed63   d0 04                bne led69
ed65   c5 7d                cmp $7d
ed67   f0 22                beq led8b
ed69   a5 93      led69     lda $93
ed6b   d1 aa                cmp ($aa),y
ed6d   d0 08                bne led77
ed6f   a5 94                lda $94
ed71   c8                   iny
ed72   d1 aa                cmp ($aa),y
ed74   f0 61                beq ledd7
ed76   88                   dey
ed77   18         led77     clc
ed78   a5 aa                lda $aa
ed7a   69 06                adc #$06
ed7c   90 e1                bcc led5f
ed7e   e8                   inx
ed7f   d0 dc                bne led5d
ed81   c9 41                cmp #$41
ed83   90 05                bcc led8a
ed85   e9 5b                sbc #$5b
ed87   38                   sec
ed88   e9 a5                sbc #$a5
ed8a   60         led8a     rts
ed8b   68         led8b     pla
ed8c   48                   pha
ed8d   c9 1a                cmp #$1a
ed8f   d0 07                bne led98
ed91   a9 96                lda #$96
ed93   a0 ad                ldy #$ad
ed95   60                   rts
ed96   00                   brk
ed97   00                   brk
ed98   a5 7d      led98     lda $7d
ed9a   a4 7e                ldy $7e
ed9c   85 aa                sta $aa
ed9e   84 ab                sty $ab
eda0   a5 7f                lda $7f
eda2   a4 80                ldy $80
eda4   85 a6                sta $a6
eda6   84 a7                sty $a7
eda8   18                   clc
eda9   69 06                adc #$06
edab   90 01                bcc ledae
edad   c8                   iny
edae   85 a4      ledae     sta $a4
edb0   84 a5                sty $a5
edb2   20 cf a1             jsr $a1cf
edb5   a5 a4                lda $a4
edb7   a4 a5                ldy $a5
edb9   c8                   iny
edba   85 7d                sta $7d
edbc   84 7e                sty $7e
edbe   a0 00                ldy #$00
edc0   a5 93                lda $93
edc2   91 aa                sta ($aa),y
edc4   c8                   iny
edc5   a5 94                lda $94
edc7   91 aa                sta ($aa),y
edc9   a9 00                lda #$00
edcb   c8                   iny
edcc   91 aa                sta ($aa),y
edce   c8                   iny
edcf   91 aa                sta ($aa),y
edd1   c8                   iny
edd2   91 aa                sta ($aa),y
edd4   c8                   iny
edd5   91 aa                sta ($aa),y
edd7   a5 aa      ledd7     lda $aa
edd9   18                   clc
edda   69 02                adc #$02
eddc   a4 ab                ldy $ab
edde   90 01                bcc lede1
ede0   c8                   iny
ede1   85 95      lede1     sta $95
ede3   84 96                sty $96
ede5   60                   rts
ede6   a5 5d                lda $5d
ede8   0a                   asl a
ede9   69 05                adc #$05
edeb   65 aa                adc $aa
eded   a4 ab                ldy $ab
edef   90 01                bcc ledf2
edf1   c8                   iny
edf2   85 a4      ledf2     sta $a4
edf4   84 a5                sty $a5
edf6   60                   rts
edf7   90 80                bcc led79
edf9   00                   brk
edfa   00                   brk
edfb   20 bc 00             jsr $00bc
edfe   20 ad aa             jsr $aaad
ee01   a5 b0                lda $b0
ee03   30 0d                bmi lee12
ee05   a5 ac                lda $ac
ee07   c9 90                cmp #$90
ee09   90 09                bcc lee14
ee0b   a9 f7                lda #$f7
ee0d   a0 ad                ldy #$ad
ee0f   20 f8 b7             jsr $b7f8
ee12   d0 74      lee12     bne lee88
ee14   4c 31 b8   lee14     jmp $b831
ee17   a5 5e                lda $5e
ee19   48                   pha
ee1a   a5 5f                lda $5f
ee1c   48                   pha
ee1d   a0 00                ldy #$00
ee1f   98         lee1f     tya
ee20   48                   pha
ee21   a5 94                lda $94
ee23   48                   pha
ee24   a5 93                lda $93
ee26   48                   pha
ee27   20 fb ad             jsr $adfb
ee2a   68                   pla
ee2b   85 93                sta $93
ee2d   68                   pla
ee2e   85 94                sta $94
ee30   68                   pla
ee31   a8                   tay
ee32   ba                   tsx
ee33   bd 02 01             lda $0102,x
ee36   48                   pha
ee37   bd 01 01             lda $0101,x
ee3a   48                   pha
ee3b   a5 ae                lda $ae
ee3d   9d 02 01             sta $0102,x
ee40   a5 af                lda $af
ee42   9d 01 01             sta $0101,x
ee45   c8                   iny
ee46   20 c2 00             jsr $00c2
ee49   c9 2c                cmp #$2c
ee4b   f0 d2                beq lee1f
ee4d   84 5d                sty $5d
ee4f   20 fb ab             jsr $abfb
ee52   68                   pla
ee53   85 5f                sta $5f
ee55   68                   pla
ee56   85 5e                sta $5e
ee58   a6 7d                ldx $7d
ee5a   a5 7e                lda $7e
ee5c   86 aa      lee5c     stx $aa
ee5e   85 ab                sta $ab
ee60   c5 80                cmp $80
ee62   d0 04                bne lee68
ee64   e4 7f                cpx $7f
ee66   f0 39                beq leea1
ee68   a0 00      lee68     ldy #$00
ee6a   b1 aa                lda ($aa),y
ee6c   c8                   iny
ee6d   c5 93                cmp $93
ee6f   d0 06                bne lee77
ee71   a5 94                lda $94
ee73   d1 aa                cmp ($aa),y
ee75   f0 16                beq lee8d
ee77   c8         lee77     iny
ee78   b1 aa                lda ($aa),y
ee7a   18                   clc
ee7b   65 aa                adc $aa
ee7d   aa                   tax
ee7e   c8                   iny
ee7f   b1 aa                lda ($aa),y
ee81   65 ab                adc $ab
ee83   90 d7                bcc lee5c
ee85   a2 10      lee85     ldx #$10
ee87   2c a2 08             bit $08a2
ee8a   4c 4e a2   lee8a     jmp $a24e
ee8d   a2 12      lee8d     ldx #$12
ee8f   a5 5e                lda $5e
ee91   d0 f7                bne lee8a
ee93   20 e6 ad             jsr $ade6
ee96   a5 5d                lda $5d
ee98   a0 04                ldy #$04
ee9a   d1 aa                cmp ($aa),y
ee9c   d0 e7                bne lee85
ee9e   4c 24 af             jmp $af24
eea1   20 e6 ad   leea1     jsr $ade6
eea4   20 1f a2             jsr $a21f
eea7   a9 00                lda #$00
eea9   a8                   tay
eeaa   85 bb                sta $bb
eeac   a2 04                ldx #$04
eeae   86 ba                stx $ba
eeb0   a5 93                lda $93
eeb2   91 aa                sta ($aa),y
eeb4   c8                   iny
eeb5   a5 94                lda $94
eeb7   91 aa                sta ($aa),y
eeb9   a5 5d                lda $5d
eebb   c8                   iny
eebc   c8                   iny
eebd   c8                   iny
eebe   91 aa                sta ($aa),y
eec0   a2 0b      leec0     ldx #$0b
eec2   a9 00                lda #$00
eec4   24 5e                bit $5e
eec6   50 08                bvc leed0
eec8   68                   pla
eec9   18                   clc
eeca   69 01                adc #$01
eecc   aa                   tax
eecd   68                   pla
eece   69 00                adc #$00
eed0   c8         leed0     iny
eed1   91 aa                sta ($aa),y
eed3   c8                   iny
eed4   8a                   txa
eed5   91 aa                sta ($aa),y
eed7   20 7c af             jsr $af7c
eeda   86 ba                stx $ba
eedc   85 bb                sta $bb
eede   a4 71                ldy $71
eee0   c6 5d                dec $5d
eee2   d0 dc                bne leec0
eee4   65 a5                adc $a5
eee6   b0 5d                bcs lef45
eee8   85 a5                sta $a5
eeea   a8                   tay
eeeb   8a                   txa
eeec   65 a4                adc $a4
eeee   90 03                bcc leef3
eef0   c8                   iny
eef1   f0 52                beq lef45
eef3   20 1f a2   leef3     jsr $a21f
eef6   85 7f                sta $7f
eef8   84 80                sty $80
eefa   a9 00                lda #$00
eefc   e6 bb                inc $bb
eefe   a4 ba                ldy $ba
ef00   f0 05                beq lef07
ef02   88         lef02     dey
ef03   91 a4                sta ($a4),y
ef05   d0 fb                bne lef02
ef07   c6 a5      lef07     dec $a5
ef09   c6 bb                dec $bb
ef0b   d0 f5                bne lef02
ef0d   e6 a5                inc $a5
ef0f   38                   sec
ef10   a5 7f                lda $7f
ef12   e5 aa                sbc $aa
ef14   a0 02                ldy #$02
ef16   91 aa                sta ($aa),y
ef18   a5 80                lda $80
ef1a   c8                   iny
ef1b   e5 ab                sbc $ab
ef1d   91 aa                sta ($aa),y
ef1f   a5 5e                lda $5e
ef21   d0 58                bne lef7b
ef23   c8                   iny
ef24   b1 aa                lda ($aa),y
ef26   85 5d                sta $5d
ef28   a9 00                lda #$00
ef2a   85 ba                sta $ba
ef2c   85 bb      lef2c     sta $bb
ef2e   c8                   iny
ef2f   68                   pla
ef30   aa                   tax
ef31   85 ae                sta $ae
ef33   68                   pla
ef34   85 af                sta $af
ef36   d1 aa                cmp ($aa),y
ef38   90 0e                bcc lef48
ef3a   d0 06                bne lef42
ef3c   c8                   iny
ef3d   8a                   txa
ef3e   d1 aa                cmp ($aa),y
ef40   90 07                bcc lef49
ef42   4c 85 ae   lef42     jmp $ae85
ef45   4c 4c a2   lef45     jmp $a24c
ef48   c8         lef48     iny
ef49   a5 bb      lef49     lda $bb
ef4b   05 ba                ora $ba
ef4d   18                   clc
ef4e   f0 0a                beq lef5a
ef50   20 7c af             jsr $af7c
ef53   8a                   txa
ef54   65 ae                adc $ae
ef56   aa                   tax
ef57   98                   tya
ef58   a4 71                ldy $71
ef5a   65 af      lef5a     adc $af
ef5c   86 ba                stx $ba
ef5e   c6 5d                dec $5d
ef60   d0 ca                bne lef2c
ef62   06 ba                asl $ba
ef64   2a                   rol a
ef65   b0 db                bcs lef42
ef67   06 ba                asl $ba
ef69   2a                   rol a
ef6a   b0 d6                bcs lef42
ef6c   a8                   tay
ef6d   a5 ba                lda $ba
ef6f   65 a4                adc $a4
ef71   85 95                sta $95
ef73   98                   tya
ef74   65 a5                adc $a5
ef76   85 96                sta $96
ef78   a8                   tay
ef79   a5 95                lda $95
ef7b   60         lef7b     rts
ef7c   84 71                sty $71
ef7e   b1 aa                lda ($aa),y
ef80   85 76                sta $76
ef82   88                   dey
ef83   b1 aa                lda ($aa),y
ef85   85 77                sta $77
ef87   a9 10                lda #$10
ef89   85 a8                sta $a8
ef8b   a2 00                ldx #$00
ef8d   a0 00                ldy #$00
ef8f   8a         lef8f     txa
ef90   0a                   asl a
ef91   aa                   tax
ef92   98                   tya
ef93   2a                   rol a
ef94   a8                   tay
ef95   b0 ae                bcs lef45
ef97   06 ba                asl $ba
ef99   26 bb                rol $bb
ef9b   90 0b                bcc lefa8
ef9d   18                   clc
ef9e   8a                   txa
ef9f   65 76                adc $76
efa1   aa                   tax
efa2   98                   tya
efa3   65 77                adc $77
efa5   a8                   tay
efa6   b0 9d                bcs lef45
efa8   c6 a8      lefa8     dec $a8
efaa   d0 e3                bne lef8f
efac   60                   rts
efad   a5 5f                lda $5f
efaf   f0 03                beq lefb4
efb1   20 b6 b2             jsr $b2b6
efb4   20 47 b1   lefb4     jsr $b147
efb7   38                   sec
efb8   a5 81                lda $81
efba   e5 7f                sbc $7f
efbc   a8                   tay
efbd   a5 82                lda $82
efbf   e5 80                sbc $80
efc1   a2 00      lefc1     ldx #$00
efc3   86 5f                stx $5f
efc5   85 ad                sta $ad
efc7   84 ae                sty $ae
efc9   a2 90                ldx #$90
efcb   4c e3 b7             jmp $b7e3
efce   a4 0e                ldy $0e
efd0   a9 00                lda #$00
efd2   f0 ed                beq lefc1
efd4   a6 88                ldx $88
efd6   e8                   inx
efd7   d0 a2                bne lef7b
efd9   a2 16                ldx #$16
efdb   4c 4e a2   lefdb     jmp $a24e
efde   20 0b b0             jsr $b00b
efe1   20 d4 af             jsr $afd4
efe4   20 fe ab             jsr $abfe
efe7   a9 80                lda #$80
efe9   85 61                sta $61
efeb   20 0b ad             jsr $ad0b
efee   20 b0 aa             jsr $aab0
eff1   20 fb ab             jsr $abfb
eff4   a9 ab                lda #$ab
eff6   20 03 ac             jsr $ac03
eff9   a5 96                lda $96
effb   48                   pha
effc   a5 95                lda $95
effe   48                   pha
efff   a5 c4                lda $c4
f001   48                   pha
f002   a5 c3                lda $c3
f004   48                   pha
f005   20 0c a7             jsr $a70c
f008   4c 7a b0             jmp $b07a
f00b   a9 9e                lda #$9e
f00d   20 03 ac             jsr $ac03
f010   09 80                ora #$80
f012   85 61                sta $61
f014   20 12 ad             jsr $ad12
f017   85 9c                sta $9c
f019   84 9d                sty $9d
f01b   4c b0 aa             jmp $aab0
f01e   20 0b b0             jsr $b00b
f021   a5 9d                lda $9d
f023   48                   pha
f024   a5 9c                lda $9c
f026   48                   pha
f027   20 f5 ab             jsr $abf5
f02a   20 b0 aa             jsr $aab0
f02d   68                   pla
f02e   85 9c                sta $9c
f030   68                   pla
f031   85 9d                sta $9d
f033   a0 02                ldy #$02
f035   a2 20                ldx #$20
f037   b1 9c                lda ($9c),y
f039   f0 a0                beq lefdb
f03b   85 95                sta $95
f03d   aa                   tax
f03e   c8                   iny
f03f   b1 9c                lda ($9c),y
f041   85 96                sta $96
f043   b1 95      lf043     lda ($95),y
f045   48                   pha
f046   88                   dey
f047   10 fa                bpl lf043
f049   a4 96                ldy $96
f04b   20 78 b7             jsr $b778
f04e   a5 c4                lda $c4
f050   48                   pha
f051   a5 c3                lda $c3
f053   48                   pha
f054   b1 9c                lda ($9c),y
f056   85 c3                sta $c3
f058   c8                   iny
f059   b1 9c                lda ($9c),y
f05b   85 c4                sta $c4
f05d   a5 96                lda $96
f05f   48                   pha
f060   a5 95                lda $95
f062   48                   pha
f063   20 ad aa             jsr $aaad
f066   68                   pla
f067   85 9c                sta $9c
f069   68                   pla
f06a   85 9d                sta $9d
f06c   20 c2 00             jsr $00c2
f06f   f0 03                beq lf074
f071   4c 0c ac             jmp $ac0c
f074   68         lf074     pla
f075   85 c3                sta $c3
f077   68                   pla
f078   85 c4                sta $c4
f07a   a0 00                ldy #$00
f07c   68                   pla
f07d   91 9c                sta ($9c),y
f07f   68                   pla
f080   c8                   iny
f081   91 9c                sta ($9c),y
f083   68                   pla
f084   c8                   iny
f085   91 9c                sta ($9c),y
f087   68                   pla
f088   c8                   iny
f089   91 9c                sta ($9c),y
f08b   60                   rts
f08c   20 b0 aa             jsr $aab0
f08f   a0 00                ldy #$00
f091   20 70 b9             jsr $b970
f094   68                   pla
f095   68                   pla
f096   a9 ff                lda #$ff
f098   a0 00                ldy #$00
f09a   f0 12                beq lf0ae
f09c   a6 ae                ldx $ae
f09e   a4 af                ldy $af
f0a0   86 9e                stx $9e
f0a2   84 9f                sty $9f
f0a4   20 15 b1             jsr $b115
f0a7   86 ad                stx $ad
f0a9   84 ae                sty $ae
f0ab   85 ac                sta $ac
f0ad   60                   rts
f0ae   a2 22      lf0ae     ldx #$22
f0b0   86 5b                stx $5b
f0b2   86 5c                stx $5c
f0b4   85 b8                sta $b8
f0b6   84 b9                sty $b9
f0b8   85 ad                sta $ad
f0ba   84 ae                sty $ae
f0bc   a0 ff                ldy #$ff
f0be   c8         lf0be     iny
f0bf   b1 b8                lda ($b8),y
f0c1   f0 0c                beq lf0cf
f0c3   c5 5b                cmp $5b
f0c5   f0 04                beq lf0cb
f0c7   c5 5c                cmp $5c
f0c9   d0 f3                bne lf0be
f0cb   c9 22      lf0cb     cmp #$22
f0cd   f0 01                beq lf0d0
f0cf   18         lf0cf     clc
f0d0   84 ac      lf0d0     sty $ac
f0d2   98                   tya
f0d3   65 b8                adc $b8
f0d5   85 ba                sta $ba
f0d7   a6 b9                ldx $b9
f0d9   90 01                bcc lf0dc
f0db   e8                   inx
f0dc   86 bb      lf0dc     stx $bb
f0de   a5 b9                lda $b9
f0e0   d0 0b                bne lf0ed
f0e2   98                   tya
f0e3   20 9c b0             jsr $b09c
f0e6   a6 b8                ldx $b8
f0e8   a4 b9                ldy $b9
f0ea   20 98 b2             jsr $b298
f0ed   a6 65      lf0ed     ldx $65
f0ef   e0 71                cpx #$71
f0f1   d0 05                bne lf0f8
f0f3   a2 1c                ldx #$1c
f0f5   4c 4e a2   lf0f5     jmp $a24e
f0f8   a5 ac      lf0f8     lda $ac
f0fa   95 00                sta $00,x
f0fc   a5 ad                lda $ad
f0fe   95 01                sta $01,x
f100   a5 ae                lda $ae
f102   95 02                sta $02,x
f104   a0 00                ldy #$00
f106   86 ae                stx $ae
f108   84 af                sty $af
f10a   88                   dey
f10b   84 5f                sty $5f
f10d   86 66                stx $66
f10f   e8                   inx
f110   e8                   inx
f111   e8                   inx
f112   86 65                stx $65
f114   60                   rts
f115   46 60                lsr $60
f117   48         lf117     pha
f118   49 ff                eor #$ff
f11a   38                   sec
f11b   65 81                adc $81
f11d   a4 82                ldy $82
f11f   b0 01                bcs lf122
f121   88                   dey
f122   c4 80      lf122     cpy $80
f124   90 11                bcc lf137
f126   d0 04                bne lf12c
f128   c5 7f                cmp $7f
f12a   90 0b                bcc lf137
f12c   85 81      lf12c     sta $81
f12e   84 82                sty $82
f130   85 83                sta $83
f132   84 84                sty $84
f134   aa                   tax
f135   68                   pla
f136   60                   rts
f137   a2 0c      lf137     ldx #$0c
f139   a5 60                lda $60
f13b   30 b8                bmi lf0f5
f13d   20 47 b1             jsr $b147
f140   a9 80                lda #$80
f142   85 60                sta $60
f144   68                   pla
f145   d0 d0                bne lf117
f147   a6 85                ldx $85
f149   a5 86                lda $86
f14b   86 81                stx $81
f14d   85 82                sta $82
f14f   a0 00                ldy #$00
f151   84 9d                sty $9d
f153   a5 7f                lda $7f
f155   a6 80                ldx $80
f157   85 aa                sta $aa
f159   86 ab                stx $ab
f15b   a9 68                lda #$68
f15d   85 71                sta $71
f15f   84 72                sty $72
f161   c5 65      lf161     cmp $65
f163   f0 05                beq lf16a
f165   20 d7 b1             jsr $b1d7
f168   f0 f7                beq lf161
f16a   a9 06      lf16a     lda #$06
f16c   85 a0                sta $a0
f16e   a5 7b                lda $7b
f170   a6 7c                ldx $7c
f172   85 71                sta $71
f174   86 72                stx $72
f176   e4 7e      lf176     cpx $7e
f178   d0 04                bne lf17e
f17a   c5 7d                cmp $7d
f17c   f0 05                beq lf183
f17e   20 d1 b1   lf17e     jsr $b1d1
f181   f0 f3                beq lf176
f183   85 a4      lf183     sta $a4
f185   86 a5                stx $a5
f187   a9 04                lda #$04
f189   85 a0                sta $a0
f18b   a5 a4      lf18b     lda $a4
f18d   a6 a5                ldx $a5
f18f   e4 80      lf18f     cpx $80
f191   d0 07                bne lf19a
f193   c5 7f                cmp $7f
f195   d0 03                bne lf19a
f197   4c 16 b2             jmp $b216
f19a   85 71      lf19a     sta $71
f19c   86 72                stx $72
f19e   a0 01                ldy #$01
f1a0   b1 71                lda ($71),y
f1a2   08                   php
f1a3   c8                   iny
f1a4   b1 71                lda ($71),y
f1a6   65 a4                adc $a4
f1a8   85 a4                sta $a4
f1aa   c8                   iny
f1ab   b1 71                lda ($71),y
f1ad   65 a5                adc $a5
f1af   85 a5                sta $a5
f1b1   28                   plp
f1b2   10 d7                bpl lf18b
f1b4   c8                   iny
f1b5   b1 71                lda ($71),y
f1b7   0a                   asl a
f1b8   69 05                adc #$05
f1ba   65 71                adc $71
f1bc   85 71                sta $71
f1be   90 02                bcc lf1c2
f1c0   e6 72                inc $72
f1c2   a6 72      lf1c2     ldx $72
f1c4   e4 a5      lf1c4     cpx $a5
f1c6   d0 04                bne lf1cc
f1c8   c5 a4                cmp $a4
f1ca   f0 c3                beq lf18f
f1cc   20 d7 b1   lf1cc     jsr $b1d7
f1cf   f0 f3                beq lf1c4
f1d1   c8                   iny
f1d2   b1 71                lda ($71),y
f1d4   10 30                bpl lf206
f1d6   c8                   iny
f1d7   b1 71                lda ($71),y
f1d9   f0 2b                beq lf206
f1db   c8                   iny
f1dc   b1 71                lda ($71),y
f1de   aa                   tax
f1df   c8                   iny
f1e0   b1 71                lda ($71),y
f1e2   c5 82                cmp $82
f1e4   90 06                bcc lf1ec
f1e6   d0 1e                bne lf206
f1e8   e4 81                cpx $81
f1ea   b0 1a                bcs lf206
f1ec   c5 ab      lf1ec     cmp $ab
f1ee   90 16                bcc lf206
f1f0   d0 04                bne lf1f6
f1f2   e4 aa                cpx $aa
f1f4   90 10                bcc lf206
f1f6   86 aa      lf1f6     stx $aa
f1f8   85 ab                sta $ab
f1fa   a5 71                lda $71
f1fc   a6 72                ldx $72
f1fe   85 9c                sta $9c
f200   86 9d                stx $9d
f202   88                   dey
f203   88                   dey
f204   84 a2                sty $a2
f206   a5 a0      lf206     lda $a0
f208   18                   clc
f209   65 71                adc $71
f20b   85 71                sta $71
f20d   90 02                bcc lf211
f20f   e6 72                inc $72
f211   a6 72      lf211     ldx $72
f213   a0 00                ldy #$00
f215   60                   rts
f216   c6 a0                dec $a0
f218   a6 9d                ldx $9d
f21a   f0 f5                beq lf211
f21c   a4 a2                ldy $a2
f21e   18                   clc
f21f   b1 9c                lda ($9c),y
f221   65 aa                adc $aa
f223   85 a6                sta $a6
f225   a5 ab                lda $ab
f227   69 00                adc #$00
f229   85 a7                sta $a7
f22b   a5 81                lda $81
f22d   a6 82                ldx $82
f22f   85 a4                sta $a4
f231   86 a5                stx $a5
f233   20 d6 a1             jsr $a1d6
f236   a4 a2                ldy $a2
f238   c8                   iny
f239   a5 a4                lda $a4
f23b   91 9c                sta ($9c),y
f23d   aa                   tax
f23e   e6 a5                inc $a5
f240   a5 a5                lda $a5
f242   c8                   iny
f243   91 9c                sta ($9c),y
f245   4c 4b b1             jmp $b14b
f248   53                   ???                ;%01010011 'S'
f249   54                   ???                ;%01010100 'T'
f24a   49 42                eor #$42
f24c   4f                   ???                ;%01001111 'O'
f24d   a5 af                lda $af
f24f   48                   pha
f250   a5 ae                lda $ae
f252   48                   pha
f253   20 a0 ab             jsr $aba0
f256   20 b2 aa             jsr $aab2
f259   68                   pla
f25a   85 b8                sta $b8
f25c   68                   pla
f25d   85 b9                sta $b9
f25f   a0 00                ldy #$00
f261   b1 b8                lda ($b8),y
f263   18                   clc
f264   71 ae                adc ($ae),y
f266   90 05                bcc lf26d
f268   a2 1a                ldx #$1a
f26a   4c 4e a2             jmp $a24e
f26d   20 9c b0   lf26d     jsr $b09c
f270   20 8a b2             jsr $b28a
f273   a5 9e                lda $9e
f275   a4 9f                ldy $9f
f277   20 ba b2             jsr $b2ba
f27a   20 9c b2             jsr $b29c
f27d   a5 b8                lda $b8
f27f   a4 b9                ldy $b9
f281   20 ba b2             jsr $b2ba
f284   20 ed b0             jsr $b0ed
f287   4c db aa             jmp $aadb
f28a   a0 00                ldy #$00
f28c   b1 b8                lda ($b8),y
f28e   48                   pha
f28f   c8                   iny
f290   b1 b8                lda ($b8),y
f292   aa                   tax
f293   c8                   iny
f294   b1 b8                lda ($b8),y
f296   a8                   tay
f297   68                   pla
f298   86 71                stx $71
f29a   84 72                sty $72
f29c   a8                   tay
f29d   f0 0a                beq lf2a9
f29f   48                   pha
f2a0   88         lf2a0     dey
f2a1   b1 71                lda ($71),y
f2a3   91 83                sta ($83),y
f2a5   98                   tya
f2a6   d0 f8                bne lf2a0
f2a8   68                   pla
f2a9   18         lf2a9     clc
f2aa   65 83                adc $83
f2ac   85 83                sta $83
f2ae   90 02                bcc lf2b2
f2b0   e6 84                inc $84
f2b2   60         lf2b2     rts
f2b3   20 b2 aa             jsr $aab2
f2b6   a5 ae                lda $ae
f2b8   a4 af                ldy $af
f2ba   85 71                sta $71
f2bc   84 72                sty $72
f2be   20 eb b2             jsr $b2eb
f2c1   08                   php
f2c2   a0 00                ldy #$00
f2c4   b1 71                lda ($71),y
f2c6   48                   pha
f2c7   c8                   iny
f2c8   b1 71                lda ($71),y
f2ca   aa                   tax
f2cb   c8                   iny
f2cc   b1 71                lda ($71),y
f2ce   a8                   tay
f2cf   68                   pla
f2d0   28                   plp
f2d1   d0 13                bne lf2e6
f2d3   c4 82                cpy $82
f2d5   d0 0f                bne lf2e6
f2d7   e4 81                cpx $81
f2d9   d0 0b                bne lf2e6
f2db   48                   pha
f2dc   18                   clc
f2dd   65 81                adc $81
f2df   85 81                sta $81
f2e1   90 02                bcc lf2e5
f2e3   e6 82                inc $82
f2e5   68         lf2e5     pla
f2e6   86 71      lf2e6     stx $71
f2e8   84 72                sty $72
f2ea   60                   rts
f2eb   c4 67                cpy $67
f2ed   d0 0c                bne lf2fb
f2ef   c5 66                cmp $66
f2f1   d0 08                bne lf2fb
f2f3   85 65                sta $65
f2f5   e9 03                sbc #$03
f2f7   85 66                sta $66
f2f9   a0 00                ldy #$00
f2fb   60         lf2fb     rts
f2fc   20 b1 b3             jsr $b3b1
f2ff   8a                   txa
f300   48                   pha
f301   a9 01                lda #$01
f303   20 a4 b0             jsr $b0a4
f306   68                   pla
f307   a0 00                ldy #$00
f309   91 ad                sta ($ad),y
f30b   68                   pla
f30c   68                   pla
f30d   4c ed b0             jmp $b0ed
f310   20 6f b3             jsr $b36f
f313   d1 9e                cmp ($9e),y
f315   98                   tya
f316   90 04                bcc lf31c
f318   b1 9e                lda ($9e),y
f31a   aa                   tax
f31b   98                   tya
f31c   48         lf31c     pha
f31d   8a         lf31d     txa
f31e   48         lf31e     pha
f31f   20 a4 b0             jsr $b0a4
f322   a5 9e                lda $9e
f324   a4 9f                ldy $9f
f326   20 ba b2             jsr $b2ba
f329   68                   pla
f32a   a8                   tay
f32b   68                   pla
f32c   18                   clc
f32d   65 71                adc $71
f32f   85 71                sta $71
f331   90 02                bcc lf335
f333   e6 72                inc $72
f335   98         lf335     tya
f336   20 9c b2             jsr $b29c
f339   4c ed b0             jmp $b0ed
f33c   20 6f b3             jsr $b36f
f33f   18                   clc
f340   f1 9e                sbc ($9e),y
f342   49 ff                eor #$ff
f344   4c 16 b3             jmp $b316
f347   a9 ff                lda #$ff
f349   85 af                sta $af
f34b   20 c2 00             jsr $00c2
f34e   c9 29                cmp #$29
f350   f0 06                beq lf358
f352   20 01 ac             jsr $ac01
f355   20 ae b3             jsr $b3ae
f358   20 6f b3   lf358     jsr $b36f
f35b   ca                   dex
f35c   8a                   txa
f35d   48                   pha
f35e   18                   clc
f35f   a2 00                ldx #$00
f361   f1 9e                sbc ($9e),y
f363   b0 b8                bcs lf31d
f365   49 ff                eor #$ff
f367   c5 af                cmp $af
f369   90 b3                bcc lf31e
f36b   a5 af                lda $af
f36d   b0 af                bcs lf31e
f36f   20 fb ab             jsr $abfb
f372   68                   pla
f373   85 a2                sta $a2
f375   68                   pla
f376   85 a3                sta $a3
f378   68                   pla
f379   68                   pla
f37a   68                   pla
f37b   aa                   tax
f37c   68                   pla
f37d   85 9e                sta $9e
f37f   68                   pla
f380   85 9f                sta $9f
f382   a0 00                ldy #$00
f384   8a                   txa
f385   f0 21                beq lf3a8
f387   e6 a2                inc $a2
f389   6c a2 00             jmp ($00a2)
f38c   20 92 b3             jsr $b392
f38f   4c d0 af             jmp $afd0
f392   20 b3 b2             jsr $b2b3
f395   a2 00                ldx #$00
f397   86 5f                stx $5f
f399   a8                   tay
f39a   60                   rts
f39b   20 92 b3             jsr $b392
f39e   f0 08                beq lf3a8
f3a0   a0 00                ldy #$00
f3a2   b1 71                lda ($71),y
f3a4   a8                   tay
f3a5   4c 8f b3             jmp $b38f
f3a8   4c 88 ae   lf3a8     jmp $ae88
f3ab   20 bc 00             jsr $00bc
f3ae   20 ad aa             jsr $aaad
f3b1   20 01 ae             jsr $ae01
f3b4   a6 ae                ldx $ae
f3b6   d0 f0                bne lf3a8
f3b8   a6 af                ldx $af
f3ba   4c c2 00             jmp $00c2
f3bd   20 92 b3             jsr $b392
f3c0   d0 03                bne lf3c5
f3c2   4c f1 b4             jmp $b4f1
f3c5   a6 c3      lf3c5     ldx $c3
f3c7   a4 c4                ldy $c4
f3c9   86 ba                stx $ba
f3cb   84 bb                sty $bb
f3cd   a6 71                ldx $71
f3cf   86 c3                stx $c3
f3d1   18                   clc
f3d2   65 71                adc $71
f3d4   85 73                sta $73
f3d6   a6 72                ldx $72
f3d8   86 c4                stx $c4
f3da   90 01                bcc lf3dd
f3dc   e8                   inx
f3dd   86 74      lf3dd     stx $74
f3df   a0 00                ldy #$00
f3e1   b1 73                lda ($73),y
f3e3   48                   pha
f3e4   a9 00                lda #$00
f3e6   91 73                sta ($73),y
f3e8   20 c2 00             jsr $00c2
f3eb   20 87 b8             jsr $b887
f3ee   68                   pla
f3ef   a0 00                ldy #$00
f3f1   91 73                sta ($73),y
f3f3   a6 ba                ldx $ba
f3f5   a4 bb                ldy $bb
f3f7   86 c3                stx $c3
f3f9   84 c4                sty $c4
f3fb   60                   rts
f3fc   20 ad aa             jsr $aaad
f3ff   20 08 b4             jsr $b408
f402   20 01 ac             jsr $ac01
f405   4c ae b3             jmp $b3ae
f408   a5 b0                lda $b0
f40a   30 9c                bmi lf3a8
f40c   a5 ac                lda $ac
f40e   c9 91                cmp #$91
f410   b0 96                bcs lf3a8
f412   20 31 b8             jsr $b831
f415   a5 ae                lda $ae
f417   a4 af                ldy $af
f419   84 11                sty $11
f41b   85 12                sta $12
f41d   60                   rts
f41e   20 08 b4             jsr $b408
f421   a0 00                ldy #$00
f423   b1 11                lda ($11),y
f425   a8                   tay
f426   4c d0 af             jmp $afd0
f429   20 fc b3             jsr $b3fc
f42c   8a                   txa
f42d   a0 00                ldy #$00
f42f   91 11                sta ($11),y
f431   60                   rts
f432   20 fc b3             jsr $b3fc
f435   86 97                stx $97
f437   a2 00                ldx #$00
f439   20 c2 00             jsr $00c2
f43c   f0 03                beq lf441
f43e   20 02 b4             jsr $b402
f441   86 98      lf441     stx $98
f443   a0 00                ldy #$00
f445   b1 11      lf445     lda ($11),y
f447   45 98                eor $98
f449   25 97                and $97
f44b   f0 f8                beq lf445
f44d   60         lf44d     rts
f44e   a9 96                lda #$96
f450   a0 ba                ldy #$ba
f452   4c 6c b4             jmp $b46c
f455   20 4d b6             jsr $b64d
f458   a5 b0                lda $b0
f45a   49 ff                eor #$ff
f45c   85 b0                sta $b0
f45e   45 b7                eor $b7
f460   85 b8                sta $b8
f462   a5 ac                lda $ac
f464   4c 6f b4             jmp $b46f
f467   20 7b b5   lf467     jsr $b57b
f46a   90 3c                bcc lf4a8
f46c   20 4d b6             jsr $b64d
f46f   d0 03                bne lf474
f471   4c 9b b7             jmp $b79b
f474   a6 b9      lf474     ldx $b9
f476   86 a3                stx $a3
f478   a2 b3                ldx #$b3
f47a   a5 b3                lda $b3
f47c   a8                   tay
f47d   f0 ce                beq lf44d
f47f   38                   sec
f480   e5 ac                sbc $ac
f482   f0 24                beq lf4a8
f484   90 12                bcc lf498
f486   84 ac                sty $ac
f488   a4 b7                ldy $b7
f48a   84 b0                sty $b0
f48c   49 ff                eor #$ff
f48e   69 00                adc #$00
f490   a0 00                ldy #$00
f492   84 a3                sty $a3
f494   a2 ac                ldx #$ac
f496   d0 04                bne lf49c
f498   a0 00      lf498     ldy #$00
f49a   84 b9                sty $b9
f49c   c9 f9      lf49c     cmp #$f9
f49e   30 c7                bmi lf467
f4a0   a8                   tay
f4a1   a5 b9                lda $b9
f4a3   56 01                lsr $01,x
f4a5   20 92 b5             jsr $b592
f4a8   24 b8      lf4a8     bit $b8
f4aa   10 4c                bpl lf4f8
f4ac   a0 ac                ldy #$ac
f4ae   e0 b3                cpx #$b3
f4b0   f0 02                beq lf4b4
f4b2   a0 b3                ldy #$b3
f4b4   38         lf4b4     sec
f4b5   49 ff                eor #$ff
f4b7   65 a3                adc $a3
f4b9   85 b9                sta $b9
f4bb   b9 03 00             lda $0003,y
f4be   f5 03                sbc $03,x
f4c0   85 af                sta $af
f4c2   b9 02 00             lda $0002,y
f4c5   f5 02                sbc $02,x
f4c7   85 ae                sta $ae
f4c9   b9 01 00             lda $0001,y
f4cc   f5 01                sbc $01,x
f4ce   85 ad                sta $ad
f4d0   b0 03                bcs lf4d5
f4d2   20 37 b5             jsr $b537
f4d5   a0 00      lf4d5     ldy #$00
f4d7   98                   tya
f4d8   18                   clc
f4d9   a6 ad      lf4d9     ldx $ad
f4db   d0 3e                bne lf51b
f4dd   a6 ae                ldx $ae
f4df   86 ad                stx $ad
f4e1   a6 af                ldx $af
f4e3   86 ae                stx $ae
f4e5   a6 b9                ldx $b9
f4e7   86 af                stx $af
f4e9   84 b9                sty $b9
f4eb   69 08                adc #$08
f4ed   c9 18                cmp #$18
f4ef   d0 e8                bne lf4d9
f4f1   a9 00      lf4f1     lda #$00
f4f3   85 ac                sta $ac
f4f5   85 b0                sta $b0
f4f7   60                   rts
f4f8   65 a3      lf4f8     adc $a3
f4fa   85 b9                sta $b9
f4fc   a5 af                lda $af
f4fe   65 b6                adc $b6
f500   85 af                sta $af
f502   a5 ae                lda $ae
f504   65 b5                adc $b5
f506   85 ae                sta $ae
f508   a5 ad                lda $ad
f50a   65 b4                adc $b4
f50c   85 ad                sta $ad
f50e   4c 28 b5             jmp $b528
f511   69 01      lf511     adc #$01
f513   06 b9                asl $b9
f515   26 af                rol $af
f517   26 ae                rol $ae
f519   26 ad                rol $ad
f51b   10 f4      lf51b     bpl lf511
f51d   38                   sec
f51e   e5 ac                sbc $ac
f520   b0 cf                bcs lf4f1
f522   49 ff                eor #$ff
f524   69 01                adc #$01
f526   85 ac                sta $ac
f528   90 0c                bcc lf536
f52a   e6 ac                inc $ac
f52c   f0 36                beq lf564
f52e   66 ad                ror $ad
f530   66 ae                ror $ae
f532   66 af                ror $af
f534   66 b9                ror $b9
f536   60         lf536     rts
f537   a5 b0                lda $b0
f539   49 ff                eor #$ff
f53b   85 b0                sta $b0
f53d   a5 ad                lda $ad
f53f   49 ff                eor #$ff
f541   85 ad                sta $ad
f543   a5 ae                lda $ae
f545   49 ff                eor #$ff
f547   85 ae                sta $ae
f549   a5 af                lda $af
f54b   49 ff                eor #$ff
f54d   85 af                sta $af
f54f   a5 b9                lda $b9
f551   49 ff                eor #$ff
f553   85 b9                sta $b9
f555   e6 b9                inc $b9
f557   d0 0a                bne lf563
f559   e6 af                inc $af
f55b   d0 06                bne lf563
f55d   e6 ae                inc $ae
f55f   d0 02                bne lf563
f561   e6 ad                inc $ad
f563   60         lf563     rts
f564   a2 0a      lf564     ldx #$0a
f566   4c 4e a2             jmp $a24e
f569   a2 74                ldx #$74
f56b   b4 03      lf56b     ldy $03,x
f56d   84 b9                sty $b9
f56f   b4 02                ldy $02,x
f571   94 03                sty $03,x
f573   b4 01                ldy $01,x
f575   94 02                sty $02,x
f577   a4 b2                ldy $b2
f579   94 01                sty $01,x
f57b   69 08                adc #$08
f57d   30 ec                bmi lf56b
f57f   f0 ea                beq lf56b
f581   e9 08                sbc #$08
f583   a8                   tay
f584   a5 b9                lda $b9
f586   b0 12                bcs lf59a
f588   16 01      lf588     asl $01,x
f58a   90 02                bcc lf58e
f58c   f6 01                inc $01,x
f58e   76 01      lf58e     ror $01,x
f590   76 01                ror $01,x
f592   76 02                ror $02,x
f594   76 03                ror $03,x
f596   6a                   ror a
f597   c8                   iny
f598   d0 ee                bne lf588
f59a   18         lf59a     clc
f59b   60                   rts
f59c   81 00                sta ($00,x)
f59e   00                   brk
f59f   00                   brk
f5a0   02                   ???                ;%00000010
f5a1   80                   ???                ;%10000000
f5a2   19 56 62             ora $6256,y
f5a5   80                   ???                ;%10000000
f5a6   76 22                ror $22,x
f5a8   f3                   ???                ;%11110011
f5a9   82                   ???                ;%10000010
f5aa   38                   sec
f5ab   aa                   tax
f5ac   40                   rti
f5ad   80                   ???                ;%10000000
f5ae   35 04                and $04,x
f5b0   f3                   ???                ;%11110011
f5b1   81 35                sta ($35,x)
f5b3   04                   ???                ;%00000100
f5b4   f3                   ???                ;%11110011
f5b5   80                   ???                ;%10000000
f5b6   80                   ???                ;%10000000
f5b7   00                   brk
f5b8   00                   brk
f5b9   80                   ???                ;%10000000
f5ba   31 72                and ($72),y
f5bc   18                   clc
f5bd   20 ca b7             jsr $b7ca
f5c0   f0 02                beq lf5c4
f5c2   10 03                bpl lf5c7
f5c4   4c 88 ae   lf5c4     jmp $ae88
f5c7   a5 ac      lf5c7     lda $ac
f5c9   e9 7f                sbc #$7f
f5cb   48                   pha
f5cc   a9 80                lda #$80
f5ce   85 ac                sta $ac
f5d0   a9 ad                lda #$ad
f5d2   a0 b5                ldy #$b5
f5d4   20 6c b4             jsr $b46c
f5d7   a9 b1                lda #$b1
f5d9   a0 b5                ldy #$b5
f5db   20 ca b6             jsr $b6ca
f5de   a9 9c                lda #$9c
f5e0   a0 b5                ldy #$b5
f5e2   20 55 b4             jsr $b455
f5e5   a9 a0                lda #$a0
f5e7   a0 b5                ldy #$b5
f5e9   20 6e bb             jsr $bb6e
f5ec   a9 b5                lda #$b5
f5ee   a0 b5                ldy #$b5
f5f0   20 6c b4             jsr $b46c
f5f3   68                   pla
f5f4   20 12 b9             jsr $b912
f5f7   a9 b9                lda #$b9
f5f9   a0 b5                ldy #$b5
f5fb   20 4d b6             jsr $b64d
f5fe   f0 4c                beq lf64c
f600   20 73 b6             jsr $b673
f603   a9 00                lda #$00
f605   85 75                sta $75
f607   85 76                sta $76
f609   85 77                sta $77
f60b   a5 b9                lda $b9
f60d   20 22 b6             jsr $b622
f610   a5 af                lda $af
f612   20 22 b6             jsr $b622
f615   a5 ae                lda $ae
f617   20 22 b6             jsr $b622
f61a   a5 ad                lda $ad
f61c   20 27 b6             jsr $b627
f61f   4c 3c b7             jmp $b73c
f622   d0 03                bne lf627
f624   4c 69 b5             jmp $b569
f627   4a         lf627     lsr a
f628   09 80                ora #$80
f62a   a8         lf62a     tay
f62b   90 13                bcc lf640
f62d   18                   clc
f62e   a5 77                lda $77
f630   65 b6                adc $b6
f632   85 77                sta $77
f634   a5 76                lda $76
f636   65 b5                adc $b5
f638   85 76                sta $76
f63a   a5 75                lda $75
f63c   65 b4                adc $b4
f63e   85 75                sta $75
f640   66 75      lf640     ror $75
f642   66 76                ror $76
f644   66 77                ror $77
f646   66 b9                ror $b9
f648   98                   tya
f649   4a                   lsr a
f64a   d0 de                bne lf62a
f64c   60         lf64c     rts
f64d   85 71                sta $71
f64f   84 72                sty $72
f651   a0 03                ldy #$03
f653   b1 71                lda ($71),y
f655   85 b6                sta $b6
f657   88                   dey
f658   b1 71                lda ($71),y
f65a   85 b5                sta $b5
f65c   88                   dey
f65d   b1 71                lda ($71),y
f65f   85 b7                sta $b7
f661   45 b0                eor $b0
f663   85 b8                sta $b8
f665   a5 b7                lda $b7
f667   09 80                ora #$80
f669   85 b4                sta $b4
f66b   88                   dey
f66c   b1 71                lda ($71),y
f66e   85 b3                sta $b3
f670   a5 ac                lda $ac
f672   60                   rts
f673   a5 b3                lda $b3
f675   f0 1f                beq lf696
f677   18                   clc
f678   65 ac                adc $ac
f67a   90 04                bcc lf680
f67c   30 1d                bmi lf69b
f67e   18                   clc
f67f   2c 10 14             bit $1410
f682   69 80                adc #$80
f684   85 ac                sta $ac
f686   d0 03                bne lf68b
f688   4c f5 b4             jmp $b4f5
f68b   a5 b8      lf68b     lda $b8
f68d   85 b0                sta $b0
f68f   60                   rts
f690   a5 b0                lda $b0
f692   49 ff                eor #$ff
f694   30 05                bmi lf69b
f696   68         lf696     pla
f697   68                   pla
f698   4c f1 b4             jmp $b4f1
f69b   4c 64 b5   lf69b     jmp $b564
f69e   20 ab b7             jsr $b7ab
f6a1   aa                   tax
f6a2   f0 10                beq lf6b4
f6a4   18                   clc
f6a5   69 02                adc #$02
f6a7   b0 f2                bcs lf69b
f6a9   a2 00                ldx #$00
f6ab   86 b8                stx $b8
f6ad   20 7c b4             jsr $b47c
f6b0   e6 ac                inc $ac
f6b2   f0 e7                beq lf69b
f6b4   60         lf6b4     rts
f6b5   84 20                sty $20
f6b7   00                   brk
f6b8   00                   brk
f6b9   20 ab b7             jsr $b7ab
f6bc   a9 b5                lda #$b5
f6be   a0 b6                ldy #$b6
f6c0   a2 00                ldx #$00
f6c2   86 b8                stx $b8
f6c4   20 4b b7             jsr $b74b
f6c7   4c cd b6             jmp $b6cd
f6ca   20 4d b6             jsr $b64d
f6cd   f0 68                beq lf737
f6cf   20 ba b7             jsr $b7ba
f6d2   a9 00                lda #$00
f6d4   38                   sec
f6d5   e5 ac                sbc $ac
f6d7   85 ac                sta $ac
f6d9   20 73 b6             jsr $b673
f6dc   e6 ac                inc $ac
f6de   f0 bb                beq lf69b
f6e0   a2 fd                ldx #$fd
f6e2   a9 01                lda #$01
f6e4   a4 b4      lf6e4     ldy $b4
f6e6   c4 ad                cpy $ad
f6e8   d0 0a                bne lf6f4
f6ea   a4 b5                ldy $b5
f6ec   c4 ae                cpy $ae
f6ee   d0 04                bne lf6f4
f6f0   a4 b6                ldy $b6
f6f2   c4 af                cpy $af
f6f4   08         lf6f4     php
f6f5   2a                   rol a
f6f6   90 09                bcc lf701
f6f8   e8                   inx
f6f9   95 77                sta $77,x
f6fb   f0 2a                beq lf727
f6fd   10 2c                bpl lf72b
f6ff   a9 01                lda #$01
f701   28         lf701     plp
f702   b0 0c                bcs lf710
f704   06 b6                asl $b6
f706   26 b5                rol $b5
f708   26 b4                rol $b4
f70a   b0 e8                bcs lf6f4
f70c   30 d6                bmi lf6e4
f70e   10 e4                bpl lf6f4
f710   a8         lf710     tay
f711   a5 b6                lda $b6
f713   e5 af                sbc $af
f715   85 b6                sta $b6
f717   a5 b5                lda $b5
f719   e5 ae                sbc $ae
f71b   85 b5                sta $b5
f71d   a5 b4                lda $b4
f71f   e5 ad                sbc $ad
f721   85 b4                sta $b4
f723   98                   tya
f724   4c 04 b7             jmp $b704
f727   a9 40      lf727     lda #$40
f729   d0 d6                bne lf701
f72b   0a         lf72b     asl a
f72c   0a                   asl a
f72d   0a                   asl a
f72e   0a                   asl a
f72f   0a                   asl a
f730   0a                   asl a
f731   85 b9                sta $b9
f733   28                   plp
f734   4c 3c b7             jmp $b73c
f737   a2 14      lf737     ldx #$14
f739   4c 4e a2             jmp $a24e
f73c   a5 75                lda $75
f73e   85 ad                sta $ad
f740   a5 76                lda $76
f742   85 ae                sta $ae
f744   a5 77                lda $77
f746   85 af                sta $af
f748   4c d5 b4             jmp $b4d5
f74b   85 71                sta $71
f74d   84 72                sty $72
f74f   a0 03                ldy #$03
f751   b1 71                lda ($71),y
f753   85 af                sta $af
f755   88                   dey
f756   b1 71                lda ($71),y
f758   85 ae                sta $ae
f75a   88                   dey
f75b   b1 71                lda ($71),y
f75d   85 b0                sta $b0
f75f   09 80                ora #$80
f761   85 ad                sta $ad
f763   88                   dey
f764   b1 71                lda ($71),y
f766   85 ac                sta $ac
f768   84 b9                sty $b9
f76a   60                   rts
f76b   a2 a8                ldx #$a8
f76d   2c a2 a4             bit $a4a2
f770   a0 00                ldy #$00
f772   f0 04                beq lf778
f774   a6 97                ldx $97
f776   a4 98                ldy $98
f778   20 ba b7   lf778     jsr $b7ba
f77b   86 71                stx $71
f77d   84 72                sty $72
f77f   a0 03                ldy #$03
f781   a5 af                lda $af
f783   91 71                sta ($71),y
f785   88                   dey
f786   a5 ae                lda $ae
f788   91 71                sta ($71),y
f78a   88                   dey
f78b   a5 b0                lda $b0
f78d   09 7f                ora #$7f
f78f   25 ad                and $ad
f791   91 71                sta ($71),y
f793   88                   dey
f794   a5 ac                lda $ac
f796   91 71                sta ($71),y
f798   84 b9                sty $b9
f79a   60                   rts
f79b   a5 b7                lda $b7
f79d   85 b0                sta $b0
f79f   a2 04                ldx #$04
f7a1   b5 b2      lf7a1     lda $b2,x
f7a3   95 ab                sta $ab,x
f7a5   ca                   dex
f7a6   d0 f9                bne lf7a1
f7a8   86 b9                stx $b9
f7aa   60                   rts
f7ab   20 ba b7             jsr $b7ba
f7ae   a2 05                ldx #$05
f7b0   b5 ab      lf7b0     lda $ab,x
f7b2   95 b2                sta $b2,x
f7b4   ca                   dex
f7b5   d0 f9                bne lf7b0
f7b7   86 b9                stx $b9
f7b9   60         lf7b9     rts
f7ba   a5 ac                lda $ac
f7bc   f0 fb                beq lf7b9
f7be   06 b9                asl $b9
f7c0   90 f7                bcc lf7b9
f7c2   20 59 b5             jsr $b559
f7c5   d0 f2                bne lf7b9
f7c7   4c 2a b5             jmp $b52a
f7ca   a5 ac      lf7ca     lda $ac
f7cc   f0 09                beq lf7d7
f7ce   a5 b0      lf7ce     lda $b0
f7d0   2a                   rol a
f7d1   a9 ff                lda #$ff
f7d3   b0 02                bcs lf7d7
f7d5   a9 01                lda #$01
f7d7   60         lf7d7     rts
f7d8   20 ca b7             jsr $b7ca
f7db   85 ad                sta $ad
f7dd   a9 00                lda #$00
f7df   85 ae                sta $ae
f7e1   a2 88                ldx #$88
f7e3   a5 ad                lda $ad
f7e5   49 ff                eor #$ff
f7e7   2a                   rol a
f7e8   a9 00                lda #$00
f7ea   85 af                sta $af
f7ec   86 ac                stx $ac
f7ee   85 b9                sta $b9
f7f0   85 b0                sta $b0
f7f2   4c d0 b4             jmp $b4d0
f7f5   46 b0                lsr $b0
f7f7   60                   rts
f7f8   85 73                sta $73
f7fa   84 74                sty $74
f7fc   a0 00                ldy #$00
f7fe   b1 73                lda ($73),y
f800   c8                   iny
f801   aa                   tax
f802   f0 c6                beq lf7ca
f804   b1 73                lda ($73),y
f806   45 b0                eor $b0
f808   30 c4                bmi lf7ce
f80a   e4 ac                cpx $ac
f80c   d0 1a                bne lf828
f80e   b1 73                lda ($73),y
f810   09 80                ora #$80
f812   c5 ad                cmp $ad
f814   d0 12                bne lf828
f816   c8                   iny
f817   b1 73                lda ($73),y
f819   c5 ae                cmp $ae
f81b   d0 0b                bne lf828
f81d   c8                   iny
f81e   a9 7f                lda #$7f
f820   c5 b9                cmp $b9
f822   b1 73                lda ($73),y
f824   e5 af                sbc $af
f826   f0 28                beq lf850
f828   a5 b0      lf828     lda $b0
f82a   90 02                bcc lf82e
f82c   49 ff                eor #$ff
f82e   4c d0 b7   lf82e     jmp $b7d0
f831   a5 ac                lda $ac
f833   f0 4a                beq lf87f
f835   38                   sec
f836   e9 98                sbc #$98
f838   24 b0                bit $b0
f83a   10 09                bpl lf845
f83c   aa                   tax
f83d   a9 ff                lda #$ff
f83f   85 b2                sta $b2
f841   20 3d b5             jsr $b53d
f844   8a                   txa
f845   a2 ac      lf845     ldx #$ac
f847   c9 f9                cmp #$f9
f849   10 06                bpl lf851
f84b   20 7b b5             jsr $b57b
f84e   84 b2                sty $b2
f850   60         lf850     rts
f851   a8         lf851     tay
f852   a5 b0                lda $b0
f854   29 80                and #$80
f856   46 ad                lsr $ad
f858   05 ad                ora $ad
f85a   85 ad                sta $ad
f85c   20 92 b5             jsr $b592
f85f   84 b2                sty $b2
f861   60                   rts
f862   a5 ac                lda $ac
f864   c9 98                cmp #$98
f866   b0 1e                bcs lf886
f868   20 31 b8             jsr $b831
f86b   84 b9                sty $b9
f86d   a5 b0                lda $b0
f86f   84 b0                sty $b0
f871   49 80                eor #$80
f873   2a                   rol a
f874   a9 98                lda #$98
f876   85 ac                sta $ac
f878   a5 af                lda $af
f87a   85 5b                sta $5b
f87c   4c d0 b4             jmp $b4d0
f87f   85 ad      lf87f     sta $ad
f881   85 ae                sta $ae
f883   85 af                sta $af
f885   a8                   tay
f886   60         lf886     rts
f887   a0 00                ldy #$00
f889   a2 09                ldx #$09
f88b   94 a8      lf88b     sty $a8,x
f88d   ca                   dex
f88e   10 fb                bpl lf88b
f890   90 0f                bcc lf8a1
f892   c9 2d                cmp #$2d
f894   d0 04                bne lf89a
f896   86 b1                stx $b1
f898   f0 04                beq lf89e
f89a   c9 2b      lf89a     cmp #$2b
f89c   d0 05                bne lf8a3
f89e   20 bc 00   lf89e     jsr $00bc
f8a1   90 5b      lf8a1     bcc lf8fe
f8a3   c9 2e      lf8a3     cmp #$2e
f8a5   f0 2e                beq lf8d5
f8a7   c9 45                cmp #$45
f8a9   d0 30                bne lf8db
f8ab   20 bc 00             jsr $00bc
f8ae   90 17                bcc lf8c7
f8b0   c9 a4                cmp #$a4
f8b2   f0 0e                beq lf8c2
f8b4   c9 2d                cmp #$2d
f8b6   f0 0a                beq lf8c2
f8b8   c9 a3                cmp #$a3
f8ba   f0 08                beq lf8c4
f8bc   c9 2b                cmp #$2b
f8be   f0 04                beq lf8c4
f8c0   d0 07                bne lf8c9
f8c2   66 ab      lf8c2     ror $ab
f8c4   20 bc 00   lf8c4     jsr $00bc
f8c7   90 5c      lf8c7     bcc lf925
f8c9   24 ab      lf8c9     bit $ab
f8cb   10 0e                bpl lf8db
f8cd   a9 00                lda #$00
f8cf   38                   sec
f8d0   e5 a9                sbc $a9
f8d2   4c dd b8             jmp $b8dd
f8d5   66 aa      lf8d5     ror $aa
f8d7   24 aa                bit $aa
f8d9   50 c3                bvc lf89e
f8db   a5 a9      lf8db     lda $a9
f8dd   38                   sec
f8de   e5 a8                sbc $a8
f8e0   85 a9                sta $a9
f8e2   f0 12                beq lf8f6
f8e4   10 09                bpl lf8ef
f8e6   20 b9 b6   lf8e6     jsr $b6b9
f8e9   e6 a9                inc $a9
f8eb   d0 f9                bne lf8e6
f8ed   f0 07                beq lf8f6
f8ef   20 9e b6   lf8ef     jsr $b69e
f8f2   c6 a9                dec $a9
f8f4   d0 f9                bne lf8ef
f8f6   a5 b1      lf8f6     lda $b1
f8f8   30 01                bmi lf8fb
f8fa   60                   rts
f8fb   4c ef ba   lf8fb     jmp $baef
f8fe   48         lf8fe     pha
f8ff   24 aa                bit $aa
f901   10 02                bpl lf905
f903   e6 a8                inc $a8
f905   20 9e b6   lf905     jsr $b69e
f908   68                   pla
f909   38                   sec
f90a   e9 30                sbc #$30
f90c   20 12 b9             jsr $b912
f90f   4c 9e b8             jmp $b89e
f912   48                   pha
f913   20 ab b7             jsr $b7ab
f916   68                   pla
f917   20 db b7             jsr $b7db
f91a   a5 b7                lda $b7
f91c   45 b0                eor $b0
f91e   85 b8                sta $b8
f920   a6 ac                ldx $ac
f922   4c 6f b4             jmp $b46f
f925   a5 a9      lf925     lda $a9
f927   c9 0a                cmp #$0a
f929   90 09                bcc lf934
f92b   a9 64                lda #$64
f92d   24 ab                bit $ab
f92f   30 11                bmi lf942
f931   4c 64 b5             jmp $b564
f934   0a         lf934     asl a
f935   0a                   asl a
f936   18                   clc
f937   65 a9                adc $a9
f939   0a                   asl a
f93a   18                   clc
f93b   a0 00                ldy #$00
f93d   71 c3                adc ($c3),y
f93f   38                   sec
f940   e9 30                sbc #$30
f942   85 a9      lf942     sta $a9
f944   4c c4 b8             jmp $b8c4
f947   91 43                sta ($43),y
f949   4f                   ???                ;%01001111 'O'
f94a   f8                   sed
f94b   94 74                sty $74,x
f94d   23                   ???                ;%00100011 '#'
f94e   f7                   ???                ;%11110111
f94f   94 74                sty $74,x
f951   24 00                bit $00
f953   a9 8d                lda #$8d
f955   a0 a1                ldy #$a1
f957   20 6b b9             jsr $b96b
f95a   a5 88                lda $88
f95c   a6 87                ldx $87
f95e   85 ad                sta $ad
f960   86 ae                stx $ae
f962   a2 90                ldx #$90
f964   38                   sec
f965   20 e8 b7             jsr $b7e8
f968   20 6e b9             jsr $b96e
f96b   4c c3 a8             jmp $a8c3
f96e   a0 01                ldy #$01
f970   a9 20                lda #$20
f972   24 b0                bit $b0
f974   10 02                bpl lf978
f976   a9 2d                lda #$2d
f978   99 ff 00   lf978     sta $00ff,y
f97b   85 b0                sta $b0
f97d   84 ba                sty $ba
f97f   c8                   iny
f980   a9 30                lda #$30
f982   a6 ac                ldx $ac
f984   d0 03                bne lf989
f986   4c 89 ba             jmp $ba89
f989   a9 00      lf989     lda #$00
f98b   e0 80                cpx #$80
f98d   f0 02                beq lf991
f98f   b0 09                bcs lf99a
f991   a9 4f      lf991     lda #$4f
f993   a0 b9                ldy #$b9
f995   20 fb b5             jsr $b5fb
f998   a9 fa                lda #$fa
f99a   85 a8      lf99a     sta $a8
f99c   a9 4b      lf99c     lda #$4b
f99e   a0 b9                ldy #$b9
f9a0   20 f8 b7             jsr $b7f8
f9a3   f0 1e                beq lf9c3
f9a5   10 12                bpl lf9b9
f9a7   a9 47      lf9a7     lda #$47
f9a9   a0 b9                ldy #$b9
f9ab   20 f8 b7             jsr $b7f8
f9ae   f0 02                beq lf9b2
f9b0   10 0e                bpl lf9c0
f9b2   20 9e b6   lf9b2     jsr $b69e
f9b5   c6 a8                dec $a8
f9b7   d0 ee                bne lf9a7
f9b9   20 b9 b6   lf9b9     jsr $b6b9
f9bc   e6 a8                inc $a8
f9be   d0 dc                bne lf99c
f9c0   20 4e b4   lf9c0     jsr $b44e
f9c3   20 31 b8   lf9c3     jsr $b831
f9c6   a2 01                ldx #$01
f9c8   a5 a8                lda $a8
f9ca   18                   clc
f9cb   69 07                adc #$07
f9cd   30 09                bmi lf9d8
f9cf   c9 08                cmp #$08
f9d1   b0 06                bcs lf9d9
f9d3   69 ff                adc #$ff
f9d5   aa                   tax
f9d6   a9 02                lda #$02
f9d8   38         lf9d8     sec
f9d9   e9 02      lf9d9     sbc #$02
f9db   85 a9                sta $a9
f9dd   86 a8                stx $a8
f9df   8a                   txa
f9e0   f0 02                beq lf9e4
f9e2   10 13                bpl lf9f7
f9e4   a4 ba      lf9e4     ldy $ba
f9e6   a9 2e                lda #$2e
f9e8   c8                   iny
f9e9   99 ff 00             sta $00ff,y
f9ec   8a                   txa
f9ed   f0 06                beq lf9f5
f9ef   a9 30                lda #$30
f9f1   c8                   iny
f9f2   99 ff 00             sta $00ff,y
f9f5   84 ba      lf9f5     sty $ba
f9f7   a0 00      lf9f7     ldy #$00
f9f9   a2 80                ldx #$80
f9fb   a5 af      lf9fb     lda $af
f9fd   18                   clc
f9fe   79 9c ba             adc $ba9c,y
fa01   85 af                sta $af
fa03   a5 ae                lda $ae
fa05   79 9b ba             adc $ba9b,y
fa08   85 ae                sta $ae
fa0a   a5 ad                lda $ad
fa0c   79 9a ba             adc $ba9a,y
fa0f   85 ad                sta $ad
fa11   e8                   inx
fa12   b0 04                bcs lfa18
fa14   10 e5                bpl lf9fb
fa16   30 02                bmi lfa1a
fa18   30 e1      lfa18     bmi lf9fb
fa1a   8a         lfa1a     txa
fa1b   90 04                bcc lfa21
fa1d   49 ff                eor #$ff
fa1f   69 0a                adc #$0a
fa21   69 2f      lfa21     adc #$2f
fa23   c8                   iny
fa24   c8                   iny
fa25   c8                   iny
fa26   84 95                sty $95
fa28   a4 ba                ldy $ba
fa2a   c8                   iny
fa2b   aa                   tax
fa2c   29 7f                and #$7f
fa2e   99 ff 00             sta $00ff,y
fa31   c6 a8                dec $a8
fa33   d0 06                bne lfa3b
fa35   a9 2e                lda #$2e
fa37   c8                   iny
fa38   99 ff 00             sta $00ff,y
fa3b   84 ba      lfa3b     sty $ba
fa3d   a4 95                ldy $95
fa3f   8a                   txa
fa40   49 ff                eor #$ff
fa42   29 80                and #$80
fa44   aa                   tax
fa45   c0 12                cpy #$12
fa47   d0 b2                bne lf9fb
fa49   a4 ba                ldy $ba
fa4b   b9 ff 00   lfa4b     lda $00ff,y
fa4e   88                   dey
fa4f   c9 30                cmp #$30
fa51   f0 f8                beq lfa4b
fa53   c9 2e                cmp #$2e
fa55   f0 01                beq lfa58
fa57   c8                   iny
fa58   a9 2b      lfa58     lda #$2b
fa5a   a6 a9                ldx $a9
fa5c   f0 2e                beq lfa8c
fa5e   10 08                bpl lfa68
fa60   a9 00                lda #$00
fa62   38                   sec
fa63   e5 a9                sbc $a9
fa65   aa                   tax
fa66   a9 2d                lda #$2d
fa68   99 01 01   lfa68     sta $0101,y
fa6b   a9 45                lda #$45
fa6d   99 00 01             sta $0100,y
fa70   8a                   txa
fa71   a2 2f                ldx #$2f
fa73   38                   sec
fa74   e8         lfa74     inx
fa75   e9 0a                sbc #$0a
fa77   b0 fb                bcs lfa74
fa79   69 3a                adc #$3a
fa7b   99 03 01             sta $0103,y
fa7e   8a                   txa
fa7f   99 02 01             sta $0102,y
fa82   a9 00                lda #$00
fa84   99 04 01             sta $0104,y
fa87   f0 08                beq lfa91
fa89   99 ff 00             sta $00ff,y
fa8c   a9 00      lfa8c     lda #$00
fa8e   99 00 01             sta $0100,y
fa91   a9 00      lfa91     lda #$00
fa93   a0 01                ldy #$01
fa95   60                   rts
fa96   80                   ???                ;%10000000
fa97   00                   brk
fa98   00                   brk
fa99   00                   brk
fa9a   fe 79 60             inc $6079,x
fa9d   00                   brk
fa9e   27                   ???                ;%00100111 '''
fa9f   10 ff                bpl lfaa0
faa1   fc                   ???                ;%11111100
faa2   18                   clc
faa3   00                   brk
faa4   00                   brk
faa5   64                   ???                ;%01100100 'd'
faa6   ff                   ???                ;%11111111
faa7   ff                   ???                ;%11111111
faa8   f6 00                inc $00,x
faaa   00                   brk
faab   01 20                ora ($20,x)
faad   ab                   ???                ;%10101011
faae   b7                   ???                ;%10110111
faaf   a9 96                lda #$96
fab1   a0 ba                ldy #$ba
fab3   20 4b b7             jsr $b74b
fab6   f0 63                beq lfb1b
fab8   a5 b3                lda $b3
faba   d0 03                bne lfabf
fabc   4c f3 b4             jmp $b4f3
fabf   a2 9c      lfabf     ldx #$9c
fac1   a0 00                ldy #$00
fac3   20 78 b7             jsr $b778
fac6   a5 b7                lda $b7
fac8   10 0f                bpl lfad9
faca   20 62 b8             jsr $b862
facd   a9 9c                lda #$9c
facf   a0 00                ldy #$00
fad1   20 f8 b7             jsr $b7f8
fad4   d0 03                bne lfad9
fad6   98                   tya
fad7   a4 5b                ldy $5b
fad9   20 9d b7   lfad9     jsr $b79d
fadc   98                   tya
fadd   48                   pha
fade   20 bd b5             jsr $b5bd
fae1   a9 9c                lda #$9c
fae3   a0 00                ldy #$00
fae5   20 fb b5             jsr $b5fb
fae8   20 1b bb             jsr $bb1b
faeb   68                   pla
faec   4a                   lsr a
faed   90 0a                bcc lfaf9
faef   a5 ac                lda $ac
faf1   f0 06                beq lfaf9
faf3   a5 b0                lda $b0
faf5   49 ff                eor #$ff
faf7   85 b0                sta $b0
faf9   60         lfaf9     rts
fafa   81 38                sta ($38,x)
fafc   aa                   tax
fafd   3b                   ???                ;%00111011 ';'
fafe   06 74                asl $74
fb00   63                   ???                ;%01100011 'c'
fb01   90 8c                bcc lfa8f
fb03   77                   ???                ;%01110111 'w'
fb04   23                   ???                ;%00100011 '#'
fb05   0c                   ???                ;%00001100
fb06   ab                   ???                ;%10101011
fb07   7a                   ???                ;%01111010 'z'
fb08   1e 94 00             asl $0094,x
fb0b   7c                   ???                ;%01111100 '|'
fb0c   63                   ???                ;%01100011 'c'
fb0d   42                   ???                ;%01000010 'B'
fb0e   80                   ???                ;%10000000
fb0f   7e 75 fe             ror $fe75,x
fb12   d0 80                bne lfa94
fb14   31 72                and ($72),y
fb16   15 81                ora $81,x
fb18   00                   brk
fb19   00                   brk
fb1a   00                   brk
fb1b   a9 fa      lfb1b     lda #$fa
fb1d   a0 ba                ldy #$ba
fb1f   20 fb b5             jsr $b5fb
fb22   a5 b9                lda $b9
fb24   69 50                adc #$50
fb26   90 03                bcc lfb2b
fb28   20 c2 b7             jsr $b7c2
fb2b   85 a3      lfb2b     sta $a3
fb2d   20 ae b7             jsr $b7ae
fb30   a5 ac                lda $ac
fb32   c9 88                cmp #$88
fb34   90 03                bcc lfb39
fb36   20 90 b6   lfb36     jsr $b690
fb39   20 62 b8   lfb39     jsr $b862
fb3c   a5 5b                lda $5b
fb3e   18                   clc
fb3f   69 81                adc #$81
fb41   f0 f3                beq lfb36
fb43   38                   sec
fb44   e9 01                sbc #$01
fb46   48                   pha
fb47   a2 04                ldx #$04
fb49   b5 b3      lfb49     lda $b3,x
fb4b   b4 ac                ldy $ac,x
fb4d   95 ac                sta $ac,x
fb4f   94 b3                sty $b3,x
fb51   ca                   dex
fb52   10 f5                bpl lfb49
fb54   a5 a3                lda $a3
fb56   85 b9                sta $b9
fb58   20 58 b4             jsr $b458
fb5b   20 ef ba             jsr $baef
fb5e   a9 fe                lda #$fe
fb60   a0 ba                ldy #$ba
fb62   20 84 bb             jsr $bb84
fb65   a9 00                lda #$00
fb67   85 b8                sta $b8
fb69   68                   pla
fb6a   20 75 b6             jsr $b675
fb6d   60                   rts
fb6e   85 ba                sta $ba
fb70   84 bb                sty $bb
fb72   20 6e b7             jsr $b76e
fb75   a9 a4                lda #$a4
fb77   20 fb b5             jsr $b5fb
fb7a   20 88 bb             jsr $bb88
fb7d   a9 a4                lda #$a4
fb7f   a0 00                ldy #$00
fb81   4c fb b5             jmp $b5fb
fb84   85 ba                sta $ba
fb86   84 bb                sty $bb
fb88   20 6b b7             jsr $b76b
fb8b   b1 ba                lda ($ba),y
fb8d   85 b1                sta $b1
fb8f   a4 ba                ldy $ba
fb91   c8                   iny
fb92   98                   tya
fb93   d0 02                bne lfb97
fb95   e6 bb                inc $bb
fb97   85 ba      lfb97     sta $ba
fb99   a4 bb                ldy $bb
fb9b   20 fb b5   lfb9b     jsr $b5fb
fb9e   a5 ba                lda $ba
fba0   a4 bb                ldy $bb
fba2   18                   clc
fba3   69 04                adc #$04
fba5   90 01                bcc lfba8
fba7   c8                   iny
fba8   85 ba      lfba8     sta $ba
fbaa   84 bb                sty $bb
fbac   20 6c b4             jsr $b46c
fbaf   a9 a8                lda #$a8
fbb1   a0 00                ldy #$00
fbb3   c6 b1                dec $b1
fbb5   d0 e4                bne lfb9b
fbb7   60         lfbb7     rts
fbb8   98                   tya
fbb9   35 44                and $44,x
fbbb   7a                   ???                ;%01111010 'z'
fbbc   68                   pla
fbbd   28                   plp
fbbe   b1 46                lda ($46),y
fbc0   20 ca b7             jsr $b7ca
fbc3   aa                   tax
fbc4   30 18                bmi lfbde
fbc6   a9 d4                lda #$d4
fbc8   a0 00                ldy #$00
fbca   20 4b b7             jsr $b74b
fbcd   8a                   txa
fbce   f0 e7                beq lfbb7
fbd0   a9 b8                lda #$b8
fbd2   a0 bb                ldy #$bb
fbd4   20 fb b5             jsr $b5fb
fbd7   a9 bc                lda #$bc
fbd9   a0 bb                ldy #$bb
fbdb   20 6c b4             jsr $b46c
fbde   a6 af      lfbde     ldx $af
fbe0   a5 ad                lda $ad
fbe2   85 af                sta $af
fbe4   86 ad                stx $ad
fbe6   a9 00                lda #$00
fbe8   85 b0                sta $b0
fbea   a5 ac                lda $ac
fbec   85 b9                sta $b9
fbee   a9 80                lda #$80
fbf0   85 ac                sta $ac
fbf2   20 d5 b4             jsr $b4d5
fbf5   a2 d4                ldx #$d4
fbf7   a0 00                ldy #$00
fbf9   4c 78 b7             jmp $b778
fbfc   a9 78                lda #$78
fbfe   a0 bc                ldy #$bc
fc00   20 6c b4             jsr $b46c
fc03   20 ab b7             jsr $b7ab
fc06   a9 7c                lda #$7c
fc08   a0 bc                ldy #$bc
fc0a   a6 b7                ldx $b7
fc0c   20 c2 b6             jsr $b6c2
fc0f   20 ab b7             jsr $b7ab
fc12   20 62 b8             jsr $b862
fc15   a9 00                lda #$00
fc17   85 b8                sta $b8
fc19   20 58 b4             jsr $b458
fc1c   a9 80                lda #$80
fc1e   a0 bc                ldy #$bc
fc20   20 55 b4             jsr $b455
fc23   a5 b0                lda $b0
fc25   48                   pha
fc26   10 0d                bpl lfc35
fc28   20 4e b4             jsr $b44e
fc2b   a5 b0                lda $b0
fc2d   30 09                bmi lfc38
fc2f   a5 63                lda $63
fc31   49 ff                eor #$ff
fc33   85 63                sta $63
fc35   20 ef ba   lfc35     jsr $baef
fc38   a9 80      lfc38     lda #$80
fc3a   a0 bc                ldy #$bc
fc3c   20 6c b4             jsr $b46c
fc3f   68                   pla
fc40   10 03                bpl lfc45
fc42   20 ef ba             jsr $baef
fc45   a9 84      lfc45     lda #$84
fc47   a0 bc                ldy #$bc
fc49   4c 6e bb             jmp $bb6e
fc4c   20 6e b7             jsr $b76e
fc4f   a9 00                lda #$00
fc51   85 63                sta $63
fc53   20 03 bc             jsr $bc03
fc56   a2 9c                ldx #$9c
fc58   a0 00                ldy #$00
fc5a   20 f9 bb             jsr $bbf9
fc5d   a9 a4                lda #$a4
fc5f   a0 00                ldy #$00
fc61   20 4b b7             jsr $b74b
fc64   a9 00                lda #$00
fc66   85 b0                sta $b0
fc68   a5 63                lda $63
fc6a   20 74 bc             jsr $bc74
fc6d   a9 9c                lda #$9c
fc6f   a0 00                ldy #$00
fc71   4c ca b6             jmp $b6ca
fc74   48                   pha
fc75   4c 35 bc             jmp $bc35
fc78   81 49                sta ($49,x)
fc7a   0f                   ???                ;%00001111
fc7b   db                   ???                ;%11011011
fc7c   83                   ???                ;%10000011
fc7d   49 0f                eor #$0f
fc7f   db                   ???                ;%11011011
fc80   7f                   ???                ;%01111111
fc81   00                   brk
fc82   00                   brk
fc83   00                   brk
fc84   04                   ???                ;%00000100
fc85   86 1e                stx $1e
fc87   d7                   ???                ;%11010111
fc88   fb                   ???                ;%11111011
fc89   87                   ???                ;%10000111
fc8a   99 26 65             sta $6526,y
fc8d   87                   ???                ;%10000111
fc8e   23                   ???                ;%00100011 '#'
fc8f   34                   ???                ;%00110100 '4'
fc90   58                   cli
fc91   86 a5                stx $a5
fc93   5d e1 83             eor $83e1,x
fc96   49 0f                eor #$0f
fc98   db                   ???                ;%11011011
fc99   a5 b0                lda $b0
fc9b   48                   pha
fc9c   10 03                bpl lfca1
fc9e   20 ef ba             jsr $baef
fca1   a5 ac      lfca1     lda $ac
fca3   48                   pha
fca4   c9 81                cmp #$81
fca6   90 07                bcc lfcaf
fca8   a9 9c                lda #$9c
fcaa   a0 b5                ldy #$b5
fcac   20 ca b6             jsr $b6ca
fcaf   a9 c9      lfcaf     lda #$c9
fcb1   a0 bc                ldy #$bc
fcb3   20 6e bb             jsr $bb6e
fcb6   68                   pla
fcb7   c9 81                cmp #$81
fcb9   90 07                bcc lfcc2
fcbb   a9 78                lda #$78
fcbd   a0 bc                ldy #$bc
fcbf   20 55 b4             jsr $b455
fcc2   68         lfcc2     pla
fcc3   10 03                bpl lfcc8
fcc5   4c ef ba             jmp $baef
fcc8   60         lfcc8     rts
fcc9   08                   php
fcca   78                   sei
fccb   3a                   ???                ;%00111010 ':'
fccc   c5 37                cmp $37
fcce   7b                   ???                ;%01111011 '{'
fccf   83                   ???                ;%10000011
fcd0   a2 5c                ldx #$5c
fcd2   7c                   ???                ;%01111100 '|'
fcd3   2e dd 4d             rol $4ddd
fcd6   7d 99 b0             adc $b099,x
fcd9   1e 7d 59             asl $597d,x
fcdc   ed 24 7e             sbc $7e24
fcdf   91 72                sta ($72),y
fce1   00                   brk
fce2   7e 4c b9             ror $b94c,x
fce5   73                   ???                ;%01110011 's'
fce6   7f                   ???                ;%01111111
fce7   aa                   tax
fce8   aa                   tax
fce9   53                   ???                ;%01010011 'S'
fcea   81 00                sta ($00,x)
fcec   00                   brk
fced   00                   brk
fcee   e6 c3      lfcee     inc $c3
fcf0   d0 02                bne lfcf4
fcf2   e6 c4                inc $c4
fcf4   ad 60 ea   lfcf4     lda $ea60
fcf7   c9 3a                cmp #$3a
fcf9   b0 0a                bcs lfd05
fcfb   c9 20                cmp #$20
fcfd   f0 ef                beq lfcee
fcff   38                   sec
fd00   e9 30                sbc #$30
fd02   38                   sec
fd03   e9 d0                sbc #$d0
fd05   60         lfd05     rts
fd06   80                   ???                ;%10000000
fd07   4f                   ???                ;%01001111 'O'
fd08   c7                   ???                ;%11000111
fd09   52                   ???                ;%01010010 'R'
fd0a   a9 4e      lfd0a     lda #$4e
fd0c   a0 be                ldy #$be
fd0e   20 c3 a8             jsr $a8c3
fd11   a2 ff                ldx #$ff
fd13   86 88                stx $88
fd15   9a                   txs
fd16   a9 11                lda #$11
fd18   a0 bd                ldy #$bd
fd1a   85 01                sta $01
fd1c   84 02                sty $02
fd1e   85 04                sta $04
fd20   84 05                sty $05
fd22   a9 05                lda #$05
fd24   a0 ae                ldy #$ae
fd26   85 06                sta $06
fd28   84 07                sty $07
fd2a   a9 c1                lda #$c1
fd2c   a0 af                ldy #$af
fd2e   85 08                sta $08
fd30   84 09                sty $09
fd32   a9 4c                lda #$4c
fd34   85 00                sta $00
fd36   85 03                sta $03
fd38   85 a1                sta $a1
fd3a   85 0a                sta $0a
fd3c   a9 88                lda #$88
fd3e   a0 ae                ldy #$ae
fd40   85 0b                sta $0b
fd42   84 0c                sty $0c
fd44   a9 48                lda #$48
fd46   85 0f                sta $0f
fd48   a9 38                lda #$38
fd4a   85 10                sta $10
fd4c   a2 1c                ldx #$1c
fd4e   bd ed bc   lfd4e     lda $bced,x
fd51   95 bb                sta $bb,x
fd53   ca                   dex
fd54   d0 f8                bne lfd4e
fd56   8a                   txa
fd57   85 b2                sta $b2
fd59   85 67                sta $67
fd5b   85 0d                sta $0d
fd5d   85 0e                sta $0e
fd5f   48                   pha
fd60   85 64                sta $64
fd62   a9 03                lda #$03
fd64   85 a0                sta $a0
fd66   a9 2c                lda #$2c
fd68   85 12                sta $12
fd6a   20 6c a8             jsr $a86c
fd6d   a2 68                ldx #$68
fd6f   86 65                stx $65
fd71   a9 72                lda #$72
fd73   a0 be                ldy #$be
fd75   20 c3 a8             jsr $a8c3
fd78   20 46 a9             jsr $a946
fd7b   86 c3                stx $c3
fd7d   84 c4                sty $c4
fd7f   20 bc 00             jsr $00bc
fd82   c9 41                cmp #$41
fd84   f0 84                beq lfd0a
fd86   a8                   tay
fd87   d0 21                bne lfdaa
fd89   a9 00                lda #$00
fd8b   a0 03                ldy #$03
fd8d   85 11                sta $11
fd8f   84 12                sty $12
fd91   a0 00                ldy #$00
fd93   e6 11      lfd93     inc $11
fd95   d0 02                bne lfd99
fd97   e6 12                inc $12
fd99   a9 92      lfd99     lda #$92
fd9b   91 11                sta ($11),y
fd9d   d1 11                cmp ($11),y
fd9f   d0 15                bne lfdb6
fda1   0a                   asl a
fda2   91 11                sta ($11),y
fda4   d1 11                cmp ($11),y
fda6   f0 eb                beq lfd93
fda8   d0 0c                bne lfdb6
fdaa   20 c2 00   lfdaa     jsr $00c2
fdad   20 7f a7             jsr $a77f
fdb0   a8                   tay
fdb1   f0 03                beq lfdb6
fdb3   4c 0c ac             jmp $ac0c
fdb6   a5 11      lfdb6     lda $11
fdb8   a4 12                ldy $12
fdba   85 85                sta $85
fdbc   84 86                sty $86
fdbe   85 81                sta $81
fdc0   84 82                sty $82
fdc2   a9 7e      lfdc2     lda #$7e
fdc4   a0 be                ldy #$be
fdc6   20 c3 a8             jsr $a8c3
fdc9   20 46 a9             jsr $a946
fdcc   86 c3                stx $c3
fdce   84 c4                sty $c4
fdd0   20 bc 00             jsr $00bc
fdd3   a8                   tay
fdd4   f0 1c                beq lfdf2
fdd6   20 7f a7             jsr $a77f
fdd9   a5 12                lda $12
fddb   d0 e5                bne lfdc2
fddd   a5 11                lda $11
fddf   c9 10                cmp #$10
fde1   90 df                bcc lfdc2
fde3   85 0f                sta $0f
fde5   e9 0e      lfde5     sbc #$0e
fde7   b0 fc                bcs lfde5
fde9   49 ff                eor #$ff
fdeb   e9 0c                sbc #$0c
fded   18                   clc
fdee   65 0f                adc $0f
fdf0   85 10                sta $10
fdf2   a2 00      lfdf2     ldx #$00
fdf4   a0 03                ldy #$03
fdf6   86 79                stx $79
fdf8   84 7a                sty $7a
fdfa   a0 00                ldy #$00
fdfc   98                   tya
fdfd   91 79                sta ($79),y
fdff   e6 79                inc $79
fe01   d0 02                bne lfe05
fe03   e6 7a                inc $7a
fe05   a5 79      lfe05     lda $79
fe07   a4 7a                ldy $7a
fe09   20 1f a2             jsr $a21f
fe0c   20 6c a8             jsr $a86c
fe0f   a5 85                lda $85
fe11   38                   sec
fe12   e5 79                sbc $79
fe14   aa                   tax
fe15   a5 86                lda $86
fe17   e5 7a                sbc $7a
fe19   20 5e b9             jsr $b95e
fe1c   a9 8d                lda #$8d
fe1e   a0 be                ldy #$be
fe20   20 c3 a8             jsr $a8c3
fe23   a9 c3                lda #$c3
fe25   a0 a8                ldy #$a8
fe27   85 04                sta $04
fe29   84 05                sty $05
fe2b   20 63 a4             jsr $a463
fe2e   a9 74                lda #$74
fe30   a0 a2                ldy #$a2
fe32   85 01                sta $01
fe34   84 02                sty $02
fe36   6c 01 00             jmp ($0001)
fe39   57                   ???                ;%01010111 'W'
fe3a   41 4e                eor ($4e,x)
fe3c   54                   ???                ;%01010100 'T'
fe3d   20 53 49             jsr $4953
fe40   4e 2d 43             lsr $432d
fe43   4f                   ???                ;%01001111 'O'
fe44   53                   ???                ;%01010011 'S'
fe45   2d 54 41             and $4154
fe48   4e 2d 41             lsr $412d
fe4b   54                   ???                ;%01010100 'T'
fe4c   4e 00 0d             lsr $0d00
fe4f   0a                   asl a
fe50   0c                   ???                ;%00001100
fe51   54                   ???                ;%01010100 'T'
fe52   68                   pla
fe53   69 73                adc #$73
fe55   20 69 73             jsr $7369
fe58   20 74 68             jsr $6874
fe5b   65 20                adc $20
fe5d   43                   ???                ;%01000011 'C'
fe5e   4f                   ???                ;%01001111 'O'
fe5f   4d 50 55             eor $5550
fe62   4b                   ???                ;%01001011 'K'
fe63   49 54                eor #$54
fe65   20 55 4b             jsr $4b55
fe68   31 30                and ($30),y
fe6a   31 20                and ($20),y
fe6c   0c                   ???                ;%00001100
fe6d   20 20 0d             jsr $0d20
fe70   0a                   asl a
fe71   00                   brk
fe72   4d 45 4d             eor $4d45
fe75   4f                   ???                ;%01001111 'O'
fe76   52                   ???                ;%01010010 'R'
fe77   59 20 53             eor $5320,y
fe7a   49 5a                eor #$5a
fe7c   45 00                eor $00
fe7e   54                   ???                ;%01010100 'T'
fe7f   45 52                eor $52
fe81   4d 49 4e             eor $4e49
fe84   41 4c                eor ($4c,x)
fe86   20 57 49             jsr $4957
fe89   44                   ???                ;%01000100 'D'
fe8a   54                   ???                ;%01010100 'T'
fe8b   48                   pha
fe8c   00                   brk
fe8d   20 42 59             jsr $5942
fe90   54                   ???                ;%01010100 'T'
fe91   45 53                eor $53
fe93   20 46 52             jsr $5246
fe96   45 45                eor $45
fe98   0d 0a 0d             ora $0d0a
fe9b   0a                   asl a
fe9c   43                   ???                ;%01000011 'C'
fe9d   20 4f 20             jsr $204f
fea0   4d 20 50             eor $5020
fea3   20 55 20             jsr $2055
fea6   4b                   ???                ;%01001011 'K'
fea7   20 49 20             jsr $2049
feaa   54                   ???                ;%01010100 'T'
feab   20 20 55             jsr $5520
feae   20 4b 20             jsr $204b
feb1   31 20                and ($20),y
feb3   30 20                bmi lfed5
feb5   31 0d                and ($0d),y
feb7   0a                   asl a
feb8   0a                   asl a
feb9   50 65                bvc lff20
febb   72                   ???                ;%01110010 'r'
febc   73                   ???                ;%01110011 's'
febd   6f                   ???                ;%01101111 'o'
febe   6e 61 6c             ror $6c61
fec1   20 43 6f             jsr $6f43
fec4   6d 70 75             adc $7570
fec7   74                   ???                ;%01110100 't'
fec8   65 72                adc $72
feca   0d 0a 0a             ora $0a0a
fecd   38                   sec
fece   4b                   ???                ;%01001011 'K'
fecf   20 42 61             jsr $6142
fed2   73                   ???                ;%01110011 's'
fed3   69 63                adc #$63
fed5   20 43 6f   lfed5     jsr $6f43
fed8   70 79                bvs lff53
feda   72                   ???                ;%01110010 'r'
fedb   69 67                adc #$67
fedd   68                   pla
fede   74                   ???                ;%01110100 't'
fedf   31 39                and ($39),y
fee1   37                   ???                ;%00110111 '7'
fee2   39 00 ad             and $ad00,y
fee5   05 bf                ora $bf
fee7   4a                   lsr a
fee8   90 fa                bcc lfee4
feea   ad 03 fb             lda $fb03
feed   8d 07 fb             sta $fb07
fef0   29 7f                and #$7f
fef2   60                   rts
fef3   48                   pha
fef4   ad 05 fb   lfef4     lda $fb05
fef7   10 fb                bpl lfef4
fef9   68                   pla
fefa   8d 04 fb             sta $fb04
fefd   60                   rts
fefe   ad 06 fb             lda $fb06
ff01   a9 ff                lda #$ff
ff03   8d 05 fb             sta $fb05
ff06   60                   rts
ff07   ad 00 fc   lff07     lda $fc00
ff0a   4a                   lsr a
ff0b   90 fa                bcc lff07
ff0d   ad 01 fc             lda $fc01
ff10   f0 f5                beq lff07
ff12   29 7f                and #$7f
ff14   60                   rts
ff15   48                   pha
ff16   ad 00 fc   lff16     lda $fc00
ff19   4a                   lsr a
ff1a   4a                   lsr a
ff1b   90 f9                bcc lff16
ff1d   68                   pla
ff1e   8d 01 fc             sta $fc01
ff21   60                   rts
ff22   a9 03                lda #$03
ff24   8d 00 fc             sta $fc00
ff27   a9 b1                lda #$b1
ff29   8d 00 fc             sta $fc00
ff2c   60                   rts
ff2d   8d 02 02             sta $0202
ff30   48                   pha
ff31   8a                   txa
ff32   48                   pha
ff33   98                   tya
ff34   48                   pha
ff35   ad 02 02             lda $0202
ff38   f0 33                beq lff6d
ff3a   ac 06 02             ldy $0206
ff3d   f0 08                beq lff47
ff3f   a2 40      lff3f     ldx #$40
ff41   ca         lff41     dex
ff42   d0 fd                bne lff41
ff44   88                   dey
ff45   d0 f8                bne lff3f
ff47   c9 0a      lff47     cmp #$0a
ff49   f0 2b                beq lff76
ff4b   c9 0d                cmp #$0d
ff4d   d0 06                bne lff55
ff4f   20 d5 bf             jsr $bfd5
ff52   4c 6d bf             jmp $bf6d
ff55   8d 01 02   lff55     sta $0201
ff58   20 c2 bf             jsr $bfc2
ff5b   ee 00 02             inc $0200
ff5e   ad e1 ff             lda $ffe1
ff61   18                   clc
ff62   6d e0 ff             adc $ffe0
ff65   cd 00 02             cmp $0200
ff68   30 09                bmi lff73
ff6a   20 de bf   lff6a     jsr $bfde
ff6d   68         lff6d     pla
ff6e   a8                   tay
ff6f   68                   pla
ff70   aa                   tax
ff71   68                   pla
ff72   60                   rts
ff73   20 d8 bf   lff73     jsr $bfd8
ff76   20 c2 bf   lff76     jsr $bfc2
ff79   ad e0 ff             lda $ffe0
ff7c   29 e0                and #$e0
ff7e   8d 02 02             sta $0202
ff81   a2 07                ldx #$07
ff83   bd f3 bf   lff83     lda $bff3,x
ff86   9d 07 02             sta $0207,x
ff89   ca                   dex
ff8a   10 f7                bpl lff83
ff8c   be fb bf             ldx $bffb,y
ff8f   a9 20                lda #$20
ff91   ac e1 ff             ldy $ffe1
ff94   c0 20                cpy #$20
ff96   30 01                bmi lff99
ff98   0a                   asl a
ff99   8d 08 02   lff99     sta $0208
ff9c   a0 00                ldy #$00
ff9e   20 07 02   lff9e     jsr $0207
ffa1   d0 fb                bne lff9e
ffa3   ee 09 02             inc $0209
ffa6   ee 0c 02             inc $020c
ffa9   ec 09 02             cpx $0209
ffac   d0 f0                bne lff9e
ffae   20 07 02   lffae     jsr $0207
ffb1   cc 02 02             cpy $0202
ffb4   d0 f8                bne lffae
ffb6   a9 20                lda #$20
ffb8   20 0a 02   lffb8     jsr $020a
ffbb   ce 08 02             dec $0208
ffbe   d0 f8                bne lffb8
ffc0   f0 a8                beq lff6a
ffc2   ae 00 02             ldx $0200
ffc5   ad 01 02             lda $0201
ffc8   ac e2 ff   lffc8     ldy $ffe2
ffcb   d0 04                bne lffd1
ffcd   9d 00 d3             sta $d300,x
ffd0   60                   rts
ffd1   9d 00 d7   lffd1     sta $d700,x
ffd4   60                   rts
ffd5   20 c2 bf             jsr $bfc2
ffd8   ad e0 ff             lda $ffe0
ffdb   8d 00 02             sta $0200
ffde   ae 00 02             ldx $0200
ffe1   bd 00 d3             lda $d300,x
ffe4   ac e2 ff             ldy $ffe2
ffe7   f0 03                beq lffec
ffe9   bd 00 d7             lda $d700,x
ffec   8d 01 02   lffec     sta $0201
ffef   a9 9a                lda #$9a
fff1   d0 d5      lfff1     bne lffc8
fff3   b9 00 d0             lda $d000,y
fff6   99 00 d0             sta $d000,y
fff9   c8                   iny
fffa   60                   rts
fffb   d3                   ???                ;%11010011
fffc   d7                   ???                ;%11010111
fffd   00                   brk
fffe   00                   brk
ffff   00                   brk
                            .end

;auto-generated symbols and labels
 le015      $e015
 le0df      $e0df
 le113      $e113
 le129      $e129
 le13f      $e13f
 le177      $e177
 le1c4      $e1c4
 le1ce      $e1ce
 le1bb      $e1bb
 le1c7      $e1c7
 le1a6      $e1a6
 le20a      $e20a
 le1f3      $e1f3
 le203      $e203
 le1ff      $e1ff
 le24c      $e24c
 le24b      $e24b
 le229      $e229
 le22d      $e22d
 le238      $e238
 le274      $e274
 le27d      $e27d
 le295      $e295
 le2e6      $e2e6
 le2d0      $e2d0
 le2d8      $e2d8
 le319      $e319
 le301      $e301
 le311      $e311
 le32e      $e32e
 le330      $e330
 le325      $e325
 le359      $e359
 le374      $e374
 le383      $e383
 le351      $e351
 lfcd5      $fcd5
 le37c      $e37c
 lffeb      $ffeb
 le3a5      $e3a5
 le3ec      $e3ec
 le410      $e410
 le3c4      $e3c4
 le3cc      $e3cc
 le3d7      $e3d7
 le3d6      $e3d6
 le417      $e417
 le42a      $e42a
 le3ff      $e3ff
 le401      $e401
 le3ac      $e3ac
 le408      $e408
 le41b      $e41b
 le3d8      $e3d8
 le3ea      $e3ea
 le45f      $e45f
 le460      $e460
 le44d      $e44d
 le456      $e456
 le436      $e436
 le4bd      $e4bd
 le4a6      $e4a6
 le4d4      $e4d4
 le4e2      $e4e2
 le52b      $e52b
 le4ff      $e4ff
 le501      $e501
 le519      $e519
 le52e      $e52e
 le50c      $e50c
 le54b      $e54b
 le543      $e543
 le540      $e540
 le508      $e508
 le567      $e567
 le5b3      $e5b3
 le5d1      $e5d1
 le5dc      $e5dc
 le5f6      $e5f6
 le651      $e651
 le67a      $e67a
 le609      $e609
 le5d9      $e5d9
 le624      $e624
 lfff1      $fff1
 le628      $e628
 le63b      $e63b
 le64f      $e64f
 le65e      $e65e
 le66c      $e66c
 le689      $e689
 le696      $e696
 le6d0      $e6d0
 le6d4      $e6d4
 le6f7      $e6f7
 le6e5      $e6e5
 le6ff      $e6ff
 le719      $e719
 le725      $e725
 le72d      $e72d
 le74b      $e74b
 le754      $e754
 le70f      $e70f
 le75c      $e75c
 le76b      $e76b
 le6fc      $e6fc
 le773      $e773
 le77e      $e77e
 le767      $e767
 le7b3      $e7b3
 le7d5      $e7d5
 le7f4      $e7f4
 le7e6      $e7e6
 le7fb      $e7fb
 le86c      $e86c
 le88a      $e88a
 le8a2      $e8a2
 le88b      $e88b
 le8bd      $e8bd
 le829      $e829
 le85e      $e85e
 le82c      $e82c
 le886      $e886
 le880      $e880
 le897      $e897
 le898      $e898
 le8b6      $e8b6
 le910      $e910
 le8b7      $e8b7
 le8cd      $e8cd
 le901      $e901
 le8f9      $e8f9
 le8f7      $e8f7
 lffee      $ffee
 le913      $e913
 le934      $e934
 le954      $e954
 le985      $e985
 le9dd      $e9dd
 le9b0      $e9b0
 le999      $e999
 le9a4      $e9a4
 le9c2      $e9c2
 lea03      $ea03
 le9f6      $e9f6
 lea54      $ea54
 lea0e      $ea0e
 lea1b      $ea1b
 lea46      $ea46
 lea49      $ea49
 lea56      $ea56
 leabe      $eabe
 lea9b      $ea9b
 lea98      $ea98
 leaba      $eaba
 leabc      $eabc
 leab9      $eab9
 leac7      $eac7
 leafa      $eafa
 leb53      $eb53
 leb2a      $eb2a
 leb78      $eb78
 leb0b      $eb0b
 leb7d      $eb7d
 leb3c      $eb3c
 leb7b      $eb7b
 leb86      $eb86
 leb34      $eb34
 leb13      $eb13
 leb1c      $eb1c
 leb9d      $eb9d
 leb84      $eb84
 lebac      $ebac
 lec18      $ec18
 leba9      $eba9
 lec11      $ec11
 leba4      $eba4
 lebd0      $ebd0
 lebca      $ebca
 lebe7      $ebe7
 lec13      $ec13
 lebee      $ebee
 lebf5      $ebf5
 lec0c      $ec0c
 lec24      $ec24
 lec51      $ec51
 lecae      $ecae
 lecd6      $ecd6
 lece6      $ece6
 lecf2      $ecf2
 lecdb      $ecdb
 lecfb      $ecfb
 lecfe      $ecfe
 led1f      $ed1f
 led2d      $ed2d
 led38      $ed38
 led2e      $ed2e
 led47      $ed47
 led53      $ed53
 led69      $ed69
 led8b      $ed8b
 led77      $ed77
 ledd7      $edd7
 led5f      $ed5f
 led5d      $ed5d
 led8a      $ed8a
 led98      $ed98
 ledae      $edae
 lede1      $ede1
 ledf2      $edf2
 led79      $ed79
 lee12      $ee12
 lee14      $ee14
 lee88      $ee88
 lee1f      $ee1f
 lee68      $ee68
 leea1      $eea1
 lee77      $ee77
 lee8d      $ee8d
 lee5c      $ee5c
 lee8a      $ee8a
 lee85      $ee85
 leed0      $eed0
 leec0      $eec0
 lef45      $ef45
 leef3      $eef3
 lef07      $ef07
 lef02      $ef02
 lef7b      $ef7b
 lef48      $ef48
 lef42      $ef42
 lef49      $ef49
 lef5a      $ef5a
 lef2c      $ef2c
 lefa8      $efa8
 lef8f      $ef8f
 lefb4      $efb4
 lefc1      $efc1
 lefdb      $efdb
 lf043      $f043
 lf074      $f074
 lf0ae      $f0ae
 lf0cf      $f0cf
 lf0cb      $f0cb
 lf0be      $f0be
 lf0d0      $f0d0
 lf0dc      $f0dc
 lf0ed      $f0ed
 lf0f8      $f0f8
 lf122      $f122
 lf137      $f137
 lf12c      $f12c
 lf0f5      $f0f5
 lf117      $f117
 lf16a      $f16a
 lf161      $f161
 lf17e      $f17e
 lf183      $f183
 lf176      $f176
 lf19a      $f19a
 lf18b      $f18b
 lf1c2      $f1c2
 lf1cc      $f1cc
 lf18f      $f18f
 lf1c4      $f1c4
 lf206      $f206
 lf1ec      $f1ec
 lf1f6      $f1f6
 lf211      $f211
 lf26d      $f26d
 lf2a9      $f2a9
 lf2a0      $f2a0
 lf2b2      $f2b2
 lf2e6      $f2e6
 lf2e5      $f2e5
 lf2fb      $f2fb
 lf31c      $f31c
 lf335      $f335
 lf358      $f358
 lf31d      $f31d
 lf31e      $f31e
 lf3a8      $f3a8
 lf3c5      $f3c5
 lf3dd      $f3dd
 lf441      $f441
 lf445      $f445
 lf4a8      $f4a8
 lf474      $f474
 lf44d      $f44d
 lf498      $f498
 lf49c      $f49c
 lf467      $f467
 lf4f8      $f4f8
 lf4b4      $f4b4
 lf4d5      $f4d5
 lf51b      $f51b
 lf4d9      $f4d9
 lf511      $f511
 lf4f1      $f4f1
 lf536      $f536
 lf564      $f564
 lf563      $f563
 lf56b      $f56b
 lf59a      $f59a
 lf58e      $f58e
 lf588      $f588
 lf5c4      $f5c4
 lf5c7      $f5c7
 lf64c      $f64c
 lf627      $f627
 lf640      $f640
 lf62a      $f62a
 lf696      $f696
 lf680      $f680
 lf69b      $f69b
 lf68b      $f68b
 lf6b4      $f6b4
 lf737      $f737
 lf6f4      $f6f4
 lf701      $f701
 lf727      $f727
 lf72b      $f72b
 lf710      $f710
 lf6e4      $f6e4
 lf778      $f778
 lf7a1      $f7a1
 lf7b0      $f7b0
 lf7b9      $f7b9
 lf7d7      $f7d7
 lf7ca      $f7ca
 lf7ce      $f7ce
 lf828      $f828
 lf850      $f850
 lf82e      $f82e
 lf87f      $f87f
 lf845      $f845
 lf851      $f851
 lf886      $f886
 lf88b      $f88b
 lf8a1      $f8a1
 lf89a      $f89a
 lf89e      $f89e
 lf8a3      $f8a3
 lf8fe      $f8fe
 lf8d5      $f8d5
 lf8db      $f8db
 lf8c7      $f8c7
 lf8c2      $f8c2
 lf8c4      $f8c4
 lf8c9      $f8c9
 lf925      $f925
 lf8f6      $f8f6
 lf8ef      $f8ef
 lf8e6      $f8e6
 lf8fb      $f8fb
 lf905      $f905
 lf934      $f934
 lf942      $f942
 lf978      $f978
 lf989      $f989
 lf991      $f991
 lf99a      $f99a
 lf9c3      $f9c3
 lf9b9      $f9b9
 lf9b2      $f9b2
 lf9c0      $f9c0
 lf9a7      $f9a7
 lf99c      $f99c
 lf9d8      $f9d8
 lf9d9      $f9d9
 lf9e4      $f9e4
 lf9f7      $f9f7
 lf9f5      $f9f5
 lfa18      $fa18
 lf9fb      $f9fb
 lfa1a      $fa1a
 lfa21      $fa21
 lfa3b      $fa3b
 lfa4b      $fa4b
 lfa58      $fa58
 lfa8c      $fa8c
 lfa68      $fa68
 lfa74      $fa74
 lfa91      $fa91
 lfaa0      $faa0
 lfb1b      $fb1b
 lfabf      $fabf
 lfad9      $fad9
 lfaf9      $faf9
 lfa8f      $fa8f
 lfa94      $fa94
 lfb2b      $fb2b
 lfb39      $fb39
 lfb36      $fb36
 lfb49      $fb49
 lfb97      $fb97
 lfba8      $fba8
 lfb9b      $fb9b
 lfbde      $fbde
 lfbb7      $fbb7
 lfc35      $fc35
 lfc38      $fc38
 lfc45      $fc45
 lfca1      $fca1
 lfcaf      $fcaf
 lfcc2      $fcc2
 lfcc8      $fcc8
 lfcf4      $fcf4
 lfd05      $fd05
 lfcee      $fcee
 lfd4e      $fd4e
 lfd0a      $fd0a
 lfdaa      $fdaa
 lfd99      $fd99
 lfdb6      $fdb6
 lfd93      $fd93
 lfdf2      $fdf2
 lfdc2      $fdc2
 lfde5      $fde5
 lfe05      $fe05
 lfed5      $fed5
 lff20      $ff20
 lff53      $ff53
 lfee4      $fee4
 lfef4      $fef4
 lff07      $ff07
 lff16      $ff16
 lff6d      $ff6d
 lff47      $ff47
 lff41      $ff41
 lff3f      $ff3f
 lff76      $ff76
 lff55      $ff55
 lff73      $ff73
 lff83      $ff83
 lff99      $ff99
 lff9e      $ff9e
 lffae      $ffae
 lffb8      $ffb8
 lff6a      $ff6a
 lffd1      $ffd1
 lffec      $ffec
 lffc8      $ffc8

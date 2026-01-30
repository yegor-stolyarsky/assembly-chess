; Creator: Yegor Stolyarsky
; Guided by: Izabella Tevlin
; School: De-Shalit High School, Rehovot, Israel
; Date of submission: 05.06.2020
; :)



IDEAL
MODEL small
STACK 100h

DATASEG

;cursor mask

; 1 1 - invert
; 0 1 - red
; 1 0 - transparent
; 0 0 - black

cursorMask  dw 1111111111111111b
            dw 1111111111111111b
            dw 1111111001111111b
            dw 1111111001111111b
            dw 1111111001111111b
            dw 1111111001111111b
            dw 1111110000111111b
            dw 1100000000000011b
            dw 1100000000000011b
            dw 1111110000111111b
            dw 1111111001111111b
            dw 1111111001111111b
            dw 1111111001111111b
            dw 1111111001111111b
            dw 1111111111111111b
            dw 1111111111111111b

            dw 0000000000000000b
            dw 0000000000000000b
            dw 0000000000000000b
            dw 0000000000000000b
            dw 0000000000000000b
            dw 0000000000000000b
            dw 0000001111000000b
            dw 0000001111000000b
            dw 0000001111000000b
            dw 0000001111000000b
            dw 0000000000000000b
            dw 0000000000000000b
            dw 0000000000000000b
            dw 0000000000000000b
            dw 0000000000000000b
            dw 0000000000000000b

;for the use of bmp printing functions
;imgOffset db ?
imgHeight dw ?
imgWidth dw ?
adjustCX dw ?
currentRank db ?
currentFile db ?
currentRankHelp db ?
currentFileHelp db ?
filename db 20 dup (?)
filehandle dw ?
Header db 54 dup (0)
Palette db 256*4 dup (0)
ScrLine db 320 dup (0)
Errormsg db 'Error with images in C:/TASM/BIN', 13, 10, '$'
printAdd dw ?

;BMP file names
boardPic db 'board.bmp', 0
whiteLettersPic db 'whtLtr.bmp', 0

WrookW db 'WrookW.bmp', 0
WrookB db 'WrookB.bmp', 0
WknightW db 'WknightW.bmp', 0
Wknightb db 'WknightB.bmp', 0
WbishopW db 'WbishopW.bmp', 0
WbishopB db 'WbishopB.bmp', 0
WqueenW db 'WqueenW.bmp', 0
WqueenB db 'WqueenB.bmp', 0
WkingW db 'WkingW.bmp', 0
WkingB db 'WkingB.bmp', 0
WpawnW db 'WpawnW.bmp',0
WpawnB db 'WpawnB.bmp',0

BrookW db 'BrookW.bmp', 0
BrookB db 'BrookB.bmp', 0
BknightW db 'BknightW.bmp', 0
Bknightb db 'BknightB.bmp', 0
BbishopW db 'BbishopW.bmp', 0
BbishopB db 'BbishopB.bmp', 0
BqueenW db 'BqueenW.bmp', 0
BqueenB db 'BqueenB.bmp', 0
BkingW db 'BkingW.bmp', 0
BkingB db 'BkingB.bmp', 0
BpawnW db 'BpawnW.bmp', 0
BpawnB db 'BpawnB.bmp', 0

GrookW db 'GrookW.bmp', 0
GrookB db 'GrookB.bmp', 0
GknightW db 'GknightW.bmp', 0
Gknightb db 'GknightB.bmp', 0
GbishopW db 'GbishopW.bmp', 0
GbishopB db 'GbishopB.bmp', 0
GqueenW db 'GqueenW.bmp', 0
GqueenB db 'GqueenB.bmp', 0
;GkingW db 'GkingW.bmp', 0
;GkingB db 'GkingB.bmp', 0
GpawnW db 'GpawnW.bmp', 0
GpawnB db 'GpawnB.bmp', 0

MrookW db 'MrookW.bmp', 0
MrookB db 'MrookB.bmp', 0
MknightW db 'MknightW.bmp', 0
MknightB db 'MknightB.bmp', 0
MbishopW db 'MbishopW.bmp', 0
MbishopB db 'MbishopB.bmp', 0
MqueenW db 'MqueenW.bmp', 0
MqueenB db 'MqueenB.bmp', 0
MkingW db 'MkingW.bmp', 0
MkingB db 'MkingB.bmp', 0
MpawnW db 'MpawnW.bmp', 0
MpawnB db 'MpawnB.bmp', 0

RkingW db 'RkingW.bmp', 0
RkingB db 'RkingB.bmp', 0

greenSquare db 'grnSqr.bmp', 0
mrkSqr db 'mrkSqr.bmp', 0

blackSquare db 'blkSqr.bmp', 0
whiteSquare db 'whtSqr.bmp', 0
;greenBlackSqr db 'GblkSqr.bmp', 0
;greenWhiteSqr db 'GWhtSqr.bmp', 0

flipBoardBtnPrintAdd dw 20*320+220
flipBoardBtnWhite db 'wflpbtn.bmp', 0
flipBoardBtnBlack db 'bflpbtn.bmp', 0
flipBtnPrinted db 0
flpBtnWidth dw 24
flpBtnHeight dw 24

autoFlipBtnPrintAdd dw 20*320+245
autoFlipBtnOn db 'gaflpbtn.bmp', 0
autoFlipBtnOff db 'raflpbtn.bmp', 0
autoFlipBtnPrinted db 0
autoFlipBtnWidth dw 24
autoFlipBtnHeight dw 24
autoFlip db 0

waitForReleaseNeeded db 1

;game stuff
startingBoard db 'rnbqkbnrpppppppp00000000000000000000000000000000PPPPPPPPRNBQKBNR'
;RNBKQBNRPPPPPPPP00000000000000000000000000000000pppppppprnbkqbnr
board db 'rnbqkbnrpppppppp00000000000000000000000000000000PPPPPPPPRNBQKBNR'
boardHelp db '0000000000000000000000000000000000000000000000000000000000000000'

turnColor db 1 ;==========IMPORTANT==========IMPORTANT==========IMPORTANT==========IMPORTANT==========IMPORTANT==========IMPORTANT==========IMPORTANT==========IMPORTANT==========
boardSide db 1
WK_castle db 1
WQ_castle db 1
Bk_castle db 1
Bq_castle db 1
enPassantSquare db 64
WK_castleHelp db 0
WQ_castleHelp db 0
Bk_castleHelp db 0
Bq_castleHelp db 0
enPassantSquareHelp db 64
moveNum db 1

attackedSquares db 64 dup (0)


moveSquares db 64 dup (0)
squaresHelp db 64 dup (0)
squaresHelpB db 64 dup (0)
markedSquares db 64 dup (0)
markedSquaresHelp db 64 dup (0)

removedPiece db ?
removedSquare db ?
toRemoveEnPassant db ?

currentSquare db ?
fromSquare db ?
fromSquareToMark db ?
toSquare db ?
toSquareToMark db ?
movedPiece db ?

currentSquareColor db ?	
currentSquareGreen db ?
currentPieceColor db ?
;currentPiecePinned db ?

kingAttacked db 0
shortCastleInMoves db 0
longCastleInMoves db 0
promotionChosen db 0
;checkNow db 0
kingPosition db 64

attackedSquaresIsMove db 0

sound dw ?

CODESEG

;enables graphics mode
;IN: X
;OUT: Graphics Mode on
proc GraphicsMode
	push ax
	
	mov ax, 13h
	int 10h
		
	pop ax
	ret
endp GraphicsMode

;enables text mode
;X
proc TextMode
	push ax
	
	mov ah,0
	mov al,2
	int 10h
	
	pop ax
	ret 
endp TextMode



;in proc PrintBmp
proc OpenFile
	mov ah,3Dh
	xor al,al ;for reading only
	mov dx, offset filename
	int 21h
	jc OpenError
	mov [filehandle],ax
	ret
OpenError:
	mov dx,offset Errormsg
	mov ah,9h
	int 21h
	ret
endp OpenFile

;in proc PrintBmp
proc ReadHeader
;Read BMP file header, 54 bytes
	mov ah,3Fh
	mov bx,[filehandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	ret
endp ReadHeader

;in proc PrintBmp
proc ReadPalette
;Read BMP file color palette, 256 colors*4bytes for each (400h)
	mov ah,3Fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	ret
endp ReadPalette

;in proc PrintBmp
proc CopyPal
; Copy the colors palette to the video memory
; The number of the first color should be sent to port 3C8h
; The palette is sent to port 3C9h
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h ;port of Graphics Card
	mov al,0 ;number of first color
	;Copy starting color to port 3C8h
	out dx,al
	;Copy palette itself to port 3C9h
	inc dx
PalLoop:
	;Note: Colors in a BMP file are saved as BGR values rather than RGB.	
	mov al,[si+2] ;get red value
	shr al,2 	; Max. is 255, but video palette maximal value is 63. Therefore dividing by 4
	out dx,al ;send it to port
	mov al,[si +1];get green value
	shr al,2
	out dx,al	;send it
	mov al,[si]
	shr al,2
	out dx,al 	;send it
	add si,4	;Point to next color (There is a null chr. after every color)
	loop PalLoop
	ret
endp CopyPal

;in proc PrintBmp
proc CopyBitMap
; BMP graphics are saved upside-down.
; Read the graphic line by line ([height] lines in VGA format),
; displaying the lines from bottom to top.
	mov ax,0A000h ;value of start of video memory
	mov es,ax
	
	push ax bx

	mov ax, [imgWidth]
	mov bx, 4
	div bl
	
	cmp ah, 0
	jne NotZero
Zero:
	mov [adjustCX], 0
	jmp Continue
NotZero:
	mov [adjustCX], 4
	xor bx, bx
    mov bl, ah
	sub [adjustCX], bx
Continue:
	pop bx ax
	
	xor cx, cx
	mov cx, [imgHeight]	;reading the BMP data - upside down
	
PrintBMPLoop:
	push cx
	
	xor di, di
	push cx
	dec cx
	Multi:
		add di, 320
		loop Multi
	pop cx

    add di, [printAdd]

	mov ah, 3fh
	mov cx, [imgWidth]
	add cx, [adjustCX]
	mov dx, offset ScrLine
	int 21h
	;Copy one line into video memory
	cld	;clear direction flag - due to the use of rep
	mov cx, [imgWidth]
	mov si, offset ScrLine
	rep movsb 	;do cx times:
				;mov es:di,ds:si -- copy single value form ScrLine to video memory
				;inc si --inc - because of cld
				;inc di --inc - because of cld
	pop cx
	loop PrintBMPLoop
	ret
endp CopyBitMap

;in proc PrintBmp
proc CloseFile
	mov ah,3Eh
	mov bx,[filehandle]
	int 21h
	ret
endp CloseFile

;ax - source offset, bx - destination offset, cx - length
proc CopyText
	push di si
	mov si, ax
	mov di, bx
	
	push ax

copy:
	xor ax, ax
	mov al, [si]
	mov [di], al
	inc di
	inc si
	loop copy
	pop ax
	
	pop si di
	ret
endp CopyText

;ax - source offset, bx - target offset, cx - length
proc AndMemory
	push di si
	mov si, ax
	mov di, bx
	
	push ax

ContinueAM:
	xor ax, ax
	mov al, [si]
	and [di], al
	inc di
	inc si
	loop ContinueAM
	pop ax
	
	pop si di
	ret
endp AndMemory

;Prints the bmp file provided
;AX - offset img, imgHeight (dw), imgWidth (dw), printAdd (dw)
proc PrintBmp
	push cx

	push bx cx
	mov bx, offset filename
	mov cx, 20
	call CopyText
	pop cx bx
	

	call OpenFile
	call ReadHeader
	call ReadPalette
	
	call HideCursor
	call CopyPal
	call CopyBitMap
	call ShowCursor
	
	call CloseFile
	
	pop cx
	ret
endp PrintBmp

proc CopyToES
	;copy mask to es
	push cx dx
	mov cx, offset cursorMask
	add cx, 64
	copyMask:
	push cx
	dec cx
	mov bx, cx
	mov ax, [bx]
	mov [es:bx], ax
	pop cx
	loop copyMask
	pop dx cx
	ret
endp CopyToES
proc ClearES
	;clear es
	push cx dx
	mov cx, offset cursorMask
	add cx, 64
	copyMaskA:
	push cx
	dec cx
	mov bx, cx
	mov ax, [bx]
	mov [byte ptr es:bx], 0h
	pop cx
	loop copyMaskA
	pop dx cx
	ret
endp ClearES
proc InitMouse
	push ax bx cx dx
		
	mov ax, 0 ;reset mouse
	int 33h
	

	call CopyToES


	mov bx, 8h ;mouse hotspot place
    mov cx, 8h
    mov ax, 9h ;draw cursor with mask
    mov dx, offset cursorMask
	int 33h
	
	mov ax, 4 ;set mouse to (cx, dx) coordinates
	mov cx, 200
	mov dx, 100
    int 33h
	
	mov ax, 1 ;show cursor
	int 33h

	call ClearES
	
	pop dx cx bx ax
	ret
endp InitMouse

proc PrintBoard
	push ax
	mov ax, offset boardPic
	mov [imgWidth], 160d
	mov [imgHeight], 160d
	mov [printAdd], 20*320+20
	call PrintBmp
	
	; mov ax, offset whiteLettersPic
	; mov [imgWidth], 160d
	; mov [imgHeight], 12d
	; mov [printAdd], 182*320+20
	; call PrintBmp
	

	pop ax
	ret
endp PrintBoard
proc PrintFlipButton
	push ax dx
	cmp [boardSide], 0
	je BlackSidePB
	WhiteSidePB:
		mov ax, offset flipBoardBtnWhite
		jmp ContinuePB	
	BlackSidePB:
		mov ax, offset flipBoardBtnBlack
		jmp ContinuePB
	ContinuePB:
		mov [imgWidth], 24d
		mov [imgHeight], 24d
		mov dx, [flipBoardBtnPrintAdd]
		mov [printAdd], dx
		call PrintBmp
	mov [flipBtnPrinted], 1
	pop dx ax
	ret
endp PrintFlipButton
proc PrintAutoFlipButton
	push ax dx
	cmp [autoFlip], 1
	je PrintOnPAFB
	PrintOffPAFB:
		mov ax, offset autoFlipBtnOff
		jmp ContinuePAFB	
	PrintOnPAFB:
		mov ax, offset autoFlipBtnOn
		jmp ContinuePAFB
	ContinuePAFB:
		mov dx, [autoFlipBtnWidth]
		mov [imgWidth], dx
		mov dx, [autoFlipBtnHeight]
		mov [imgHeight], dx
		mov dx, [autoFlipBtnPrintAdd]
		mov [printAdd], dx
		call PrintBmp
	mov [autoFlipBtnPrinted], 1
	pop dx ax
	ret
endp PrintAutoFlipButton
;IN: [currentSquare]
;OUT: [currentSquareGreen], calls SetCurrentRowCol
proc SetCurrentSquareGreen
	push bx
	
	call SetCurrentRowCol
	
	xor bx, bx
	mov bl, [currentSquare]
	add bx, offset attackedSquares
	
	cmp [byte ptr bx], 1
	jne NotSCSG
	YesSCSG:
		mov [currentSquareGreen], 1
		jmp ExitSCSG
	NotSCSG:
		mov [currentSquareGreen], 0
		jmp ExitSCSG
		
	ExitSCSG:
	pop bx
	ret
endp SetCurrentSquareGreen

;IN: [currentSquare]
;OUT: [currentSquareColor], calls SetCurrentRowCol
proc SetCurrentSquareColor
	push dx
	
	call SetCurrentRowCol
	
	and [currentFile], 00000001b
	and [currentRank], 00000001b
	mov dl, [currentFile]
	cmp dl, [currentRank]
	jne BlackSquareSCSC
	mov [currentSquareColor], 1
	jmp ExitSetSquareCol
	BlackSquareSCSC:
		mov [currentSquareColor], 0
	ExitSetSquareCol:
	mov dx, 5
	pop dx	
	ret
endp SetCurrentSquareColor

;in UpdatePiecesBoard
;IN: [currentSquare] - place in board array (0-63)
proc PrintCurrentPiece
	push ax bx cx
	
	mov [imgHeight], 20
	mov [imgWidth], 20
	
	xor bx, bx
	mov bl, [currentSquare]
	add bx, offset board

	call SetCurrentSquareColor
	
	rW:
		mov ax, 'R'
		cmp [bx], al
		jne nW
		
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset markedSquares
		cmp [byte ptr bx], 1
		je MrW
		
		cmp [currentSquareColor], 1
		jne BrW
			mov ax, offset WrookW
			jmp PrintPiece
		BrW:
			mov ax, offset BrookW
			jmp PrintPiece
		
		MrW:
			mov ax, offset MrookW
			jmp PrintPiece
	nW:
		mov ax, 'N'
		cmp [bx], al
		jne bW
		
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset markedSquares
		cmp [byte ptr bx], 1
		je MnW
		
		cmp [currentSquareColor], 1
		jne BnW
		mov ax, offset WknightW
		jmp PrintPiece
		BnW:
		mov ax, offset BknightW
		jmp PrintPiece
		
		MnW:
			mov ax, offset MknightW
			jmp PrintPiece
	bW:
		mov ax, 'B'
		cmp [bx], al
		jne qW
		
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset markedSquares
		cmp [byte ptr bx], 1
		je MbW
		
		cmp [currentSquareColor], 1
		jne BbW
		mov ax, offset WbishopW
		jmp PrintPiece
		BbW:
		mov ax, offset BbishopW
		jmp PrintPiece
		
		MbW:
			mov ax, offset MbishopW
			jmp PrintPiece		
	qW:
		mov ax, 'Q'
		cmp [bx], al
		jne kW
		
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset markedSquares
		cmp [byte ptr bx], 1
		je MqW
		
		cmp [currentSquareColor], 1
		jne BqW
		mov ax, offset WqueenW
		jmp PrintPiece
		BqW:
		mov ax, offset BqueenW
		jmp PrintPiece
		
		MqW:
			mov ax, offset MqueenW
			jmp PrintPiece			
	kW:
		mov ax, 'K'
		cmp [bx], al
		jne pW
		
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset markedSquares
		cmp [byte ptr bx], 1
		je MkW
		
		cmp [currentSquareColor], 1
		jne BkW
		mov ax, offset WkingW
		jmp PrintPiece
		BkW:
		mov ax, offset BkingW
		jmp PrintPiece
		
		MkW:
			mov ax, offset MkingW
			jmp PrintPiece	
	pW:
		mov ax, 'P'
		cmp [bx], al
		jne rB
		
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset markedSquares
		cmp [byte ptr bx], 1
		je MpW
		
		cmp [currentSquareColor], 1
		jne BpW
		mov ax, offset WpawnW
		jmp PrintPiece
		BpW:
		mov ax, offset BpawnW
		jmp PrintPiece
		
		MpW:
			mov ax, offset MpawnW
			jmp PrintPiece	
	rB:
		mov ax, 'r'
		cmp [bx], al
		jne nB
		
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset markedSquares
		cmp [byte ptr bx], 1
		je MrB
		
		cmp [currentSquareColor], 1
		jne BrB
		mov ax, offset WrookB
		jmp PrintPiece
		BrB:
		mov ax, offset BrookB
		jmp PrintPiece
		
		MrB:
			mov ax, offset MrookB
			jmp PrintPiece			
	nB:	
		mov ax, 'n'
		cmp [bx], al
		jne bB
		
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset markedSquares
		cmp [byte ptr bx], 1
		je MnB
		
		cmp [currentSquareColor], 1
		jne BnB
		mov ax, offset WknightB
		jmp PrintPiece
		BnB:
		mov ax, offset BknightB
		jmp PrintPiece
		
		MnB:
			mov ax, offset MknightB
			jmp PrintPiece	
	bB:
		mov ax, 'b'
		cmp [bx], al
		jne qB
		
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset markedSquares
		cmp [byte ptr bx], 1
		je MbB
		
		cmp [currentSquareColor], 1
		jne BbB
		mov ax, offset WbishopB
		jmp PrintPiece
		BbB:
		mov ax, offset BbishopB
		jmp PrintPiece
		
		MbB:
			mov ax, offset MbishopB
			jmp PrintPiece	
	qB:	
		mov ax, 'q'
		cmp [bx], al
		jne kB

		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset markedSquares
		cmp [byte ptr bx], 1
		je MqB
		
		cmp [currentSquareColor], 1
		jne BqB
		mov ax, offset WqueenB
		jmp PrintPiece
		BqB:
		mov ax, offset BqueenB
		jmp PrintPiece
		
		MqB:
			mov ax, offset MqueenB
			jmp PrintPiece	
	kB:		
		mov ax, 'k'
		cmp [bx], al
		jne pB
		
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset markedSquares
		cmp [byte ptr bx], 1
		je MkB
		
		cmp [currentSquareColor], 1
		jne BkB
		mov ax, offset WkingB
		jmp PrintPiece
		BkB:
		mov ax, offset BkingB
		jmp PrintPiece
		
		MkB:
			mov ax, offset MkingB
			jmp PrintPiece
	pB:
		mov ax, 'p'
		cmp [bx], al
		jne EmptySquarePCP
		
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset markedSquares
		cmp [byte ptr bx], 1
		je MpB
		
		cmp [currentSquareColor], 1
		jne BpB
		mov ax, offset WpawnB
		jmp PrintPiece
		BpB:
		mov ax, offset BpawnB
		jmp PrintPiece
		
		MpB:
			mov ax, offset MpawnB
			jmp PrintPiece
	EmptySquarePCP:
		mov ax, '0'
		cmp [bx], al
		jne PossibleErrorPCP	
		
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset markedSquares
		cmp [byte ptr bx], 1
		je MarkedSquarePCP

		cmp [currentSquareColor], 1
		jne BlackSquarePCP
		
		WhiteSquarePCP:
			mov ax, offset whiteSquare
			jmp PrintPiece
		
		BlackSquarePCP:
			mov ax, offset blackSquare
			jmp PrintPiece
		
		MarkedSquarePCP:
			mov ax, offset mrkSqr
			jmp PrintPiece
		

	PrintPiece:
		call CurrentSquareToPrintAdd
		call PrintBmp
		
	PossibleErrorPCP:
	ExitPrintCurrentPiece:

	pop cx bx ax
	ret
endp PrintCurrentPiece

;IN: [currentSquare] (0-63)
;OUT: [printAdd]
proc CurrentSquareToPrintAdd
	push ax bx cx
	mov [printAdd], 20*320+20
	xor ax, ax
	mov al, [currentSquare]
	xor bx, bx
	mov bl, 8
	div bl
	xor cx, cx
	mov cl, al
	cmp cl, 0
	je NoIncPiecePosCol
	IncPiecePosCol:
		add [printAdd], 320*20
		loop IncPiecePosCol
	NoIncPiecePosCol:
	xor cx, cx
	mov cl, ah
	cmp cl, 0
	je NoIncPiecePosRow
	IncPiecePosRow:
		add [printAdd], 20
		loop IncPiecePosRow
	NoIncPiecePosRow:
	pop cx bx ax
	ret
endp CurrentSquareToPrintAdd


;prints all pieces according to board array
;X
proc UpdatePiecesOnBoard
	push ax bx cx
	mov [imgHeight], 20d
	mov [imgWidth], 20d


	mov cx, 64

	pieces:
		push ax bx cx
		dec cl
		mov [currentSquare], cl
		call SetCurrentRowCol
		call PrintCurrentPiece
		pop cx bx ax
		loop pieces
	
	pop cx bx ax
	ret
endp UpdatePiecesOnBoard

;clears the used registers
;X
proc ClearRegs
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	xor di, di
	xor si, si
	ret
endp ClearRegs

;sets rank and file vars from board index
;IN: [currentSquare] - index in [board] (0-63)
;OUT: [currentRank], [currentFile]
proc SetCurrentRowCol
	push ax bx

	xor ax, ax
	mov al, [currentSquare]
	mov bl, 8
	div bl
	mov [currentRank], al
	mov [currentFile], ah
	pop bx ax
	ret
endp SetCurrentRowCol

;sets rank and file vars from board index
;IN: [currentRank] (0-7), [currentFile] (0-7)
;OUT: [currentSquare] (0-63)
proc SetCurrentSquare
	push ax bx
	xor ax, ax
	mov al, [currentRank]
	mov bl, 8d
	mul bl
	add al, [currentFile]
	
	;mov bl, 63 ;try flip board
	;sub bl, al
	;mov al, bl
	
	mov [currentSquare], al
	pop bx ax
	ret
endp SetCurrentSquare

;waits for a mouse left click
;X
;OUT: CX - horizontal click, DX - vertical click
proc WaitForLeftClick
ContinueWaitForLeftClick:

	mov ax, 3h
	int 33h
	and bx, 00000001b
	jnz ExitWaitForLeftClick	
	jmp ContinueWaitForLeftClick
ExitWaitForLeftClick:
	ret
endp WaitForLeftClick

;waits for a mouse left release
;X
;OUT: CX - horizontal release, DX - vertical release
proc WaitForLeftRelease
ContinueWaitForLeftRelease:
	mov ax, 6h
	int 33h
	and bx, 00000001b
	jnz ExitWaitForLeftRelease
	jmp ContinueWaitForLeftRelease
ExitWaitForLeftRelease:
	ret
endp WaitForLeftRelease 

;check if coordinates in board bounds
;OUT: ax: 0 - ok
;		  1 - bad
proc CoordinateInBoardBounds
	push cx dx
	mov ax, 40
	cmp cx, ax
	jle BadCIBB
	mov ax, 360
	cmp cx, ax
	jge BadCIBB
	mov ax, 20
	cmp dx, ax
	jle BadCIBB
	mov ax, 180
	cmp dx, ax
	jge BadCIBB
	
	jmp GoodCIBB
	
	BadCIBB:
	mov ax, 1
	pop dx cx
	ret
	
	GoodCIBB:
	mov ax, 0
	pop dx cx
	ret
endp CoordinateInBoardBounds

;check if coordinates in flip button bounds
;OUT: ax: 0 - ok
;		  1 - bad
proc CoordinateInFlpBtnBounds
	push cx dx
	mov ax, 440
	cmp cx, ax
	jle BadCIFBB
	add ax, 48
	cmp cx, ax
	jge BadCIFBB
	mov ax, 20
	cmp dx, ax
	jle BadCIFBB
	add ax, 24
	cmp dx, ax
	jge BadCIFBB
	
	jmp GoodCIFBB
	
	BadCIFBB:
		mov ax, 1
		pop dx cx
		ret
	
	GoodCIFBB:
		mov ax, 0
		pop dx cx
		ret
endp CoordinateInFlpBtnBounds

;check if coordinates in auto flip button bounds
;OUT: ax: 0 - ok
;		  1 - bad
proc CoordinateInAutoFlpBtnBounds
	push cx dx
	mov ax, 490 ;checksaf
	cmp cx, ax
	jle BadCIAFBB
	add ax, 48
	cmp cx, ax
	jge BadCIAFBB
	mov ax, 20
	cmp dx, ax
	jle BadCIAFBB
	add ax, 24
	cmp dx, ax
	jge BadCIAFBB
	
	jmp GoodCIAFBB
	
	BadCIAFBB:
		mov ax, 1
		pop dx cx
		ret
	
	GoodCIAFBB:
		mov ax, 0
		pop dx cx
		ret
endp CoordinateInAutoFlpBtnBounds

;IN: CX - horizontal click, DX - vertical click
;OUT: [currentFile] (0-7), [currentRank] (0-7)
proc CoordinateToBoard
	push ax bx cx dx
	
	call CoordinateInBoardBounds
	cmp ax, 0
	je GoodCTB
	jmp ExitCoordinateToBoard
	
	GoodCTB:
	push dx
	mov ax, cx
	xor dx, dx
	mov bx, 40
	div bx
	mov [currentFile], al
	dec [currentFile]
	pop dx
	
	mov ax, dx
	xor dx, dx
	mov bx, 20
	div bx
	mov [currentRank], al
	dec [currentRank]
	
	ExitCoordinateToBoard:
	pop dx cx bx ax
	ret
endp CoordinateToBoard

proc HideCursor
	push ax
	mov ax, 2 ;hide cursor
	int 33h	
	pop ax
	ret
endp HideCursor
proc ShowCursor
	push ax
	mov ax, 1 ;hide cursor
	int 33h	
	pop ax
	ret
endp ShowCursor
proc ResetClicksInfo
	push ax bx
	mov ax, 5
	mov bx, 0
	int 33h
	mov ax, 5
	mov bx, 1
	int 33h
	mov ax, 6
	mov bx, 0
	int 33h
	mov ax, 6
	mov bx, 1
	int 33h
	pop bx ax
	ret
endp ResetClicksInfo

proc GreenMoveSquares
	push ax bx cx
	
	xor ax, ax
	mov al, [currentSquare]
	push ax
	
	mov cx, 64
	LoopGAS:
	push cx
	dec cx
	mov bx, offset moveSquares
	add bx, cx
	cmp [byte ptr bx], 1
	jne ExitIterationGAS
	mov [currentSquare], cl
	mov ax, offset greenSquare
	mov [imgHeight], 4
	mov [imgWidth], 4
	call CurrentSquareToPrintAdd
	add [printAdd], 320*8+8
	call PrintBmp
	
	ExitIterationGAS:
	pop cx
	loop LoopGAS

	ExitLoopGAS:
	pop ax
	mov [currentSquare], al
	
	pop cx bx ax
	ret
endp GreenMoveSquares

proc SetKingRed
	push ax bx cx dx
	mov al, [currentSquare]
	push ax
	
	call SetKingAttacked
	call SetKingPos
	cmp [kingAttacked], 0
	je NoCheckSKR
	CheckSKR:
		cmp [turnColor], 0
		je BlackCSKR
		WhiteCSKR:
			mov ax, offset RkingW
			jmp ContinueCSKR
		BlackCSKR:
			mov ax, offset RkingB
			jmp ContinueCSKR
			
		ContinueCSKR:
			mov [imgHeight], 20
			mov [imgWidth], 20
			mov dl, [kingPosition]
			mov [currentSquare], dl
			call CurrentSquareToPrintAdd
			call PrintBmp
			jmp EndCSKR
	NoCheckSKR:
		call SetKingPos
		mov dl, [kingPosition]
		mov [currentSquare], dl
		call PrintCurrentPiece
	
	EndCSKR:
	pop ax
	mov [currentSquare], al
	pop dx cx bx ax
	ret
endp SetKingRed

;the 'while (!gameOver)' loop for the game
proc WaitPieceClick
	mov [currentSquare], 64
	mov ah, 0
	
	call SetBoardSideAsColor
	call SetKingRed
	
ContinueWaitPieceClick:
	push ax bx cx dx
	
	; --------------------------------------------------------------------------------------------------------------------------------
	; --------------------------------------------------------------------------------------------------------------------------------
	; --------------------------------------------------------------------------------------------------------------------------------
	; --------------------------------------------------------------------------------------------------------------------------------
	; --------------------------------------------------------------------------------------------------------------------------------
	; --------------------------------------------------------------------------------------------------------------------------------
	; --------------------------------------------------------------------------------------------------------------------------------
	; --------------------------------------------------------------------------------------------------------------------------------
	; --------------------------------------------------------------------------------------------------------------------------------
	; --------------------------------------------------------------------------------------------------------------------------------
	
	call WaitForLeftClick
	
	mov al, [currentSquare]

	call CoordinateToBoard
	
	push ax
	call CoordinateInBoardBounds
	cmp ax, 0
	pop ax
	je InBoundsWPC
	
	call SetCurrentRowCol
	call ClearMoveMarks
	
	push ax
	call CoordinateInFlpBtnBounds
	cmp ax, 0
	pop ax
	je FlipButtonClick
	
	push ax
	call CoordinateInAutoFlpBtnBounds
	cmp ax, 0
	pop ax
	je AutoFlipButtonClick
	
	jmp EndClickWPC
	
	AutoFlipButtonClick:
		call SwitchAutoFlip
		call PrintAutoFlipButton
		cmp [autoFlip], 1
		jne ContinueAFBC
		call SetBoardSideAsColor
		ContinueAFBC:
		mov [waitForReleaseNeeded], 0
		push ax cx dx
		mov cx, 0003h
		mov dx, 0000h
		mov ah, 86h ;interrupt
		int 15h
		pop dx cx ax
		jmp EndClickWPC
	FlipButtonClick:
		call FlipBoard
		mov [waitForReleaseNeeded], 0
		
		push ax cx dx
		mov cx, 0003h
		mov dx, 0000h
		mov ah, 86h ;interrupt
		int 15h
		pop dx cx ax
		jmp EndClickWPC
	InBoundsWPC:
		call SetCurrentSquare
		cmp al, [currentSquare]
		jne DifferentSquareWPC
		call ClearMoveMarks ;if same piece click
		mov [currentSquare], 64d
		jmp EndClickWPC
	DifferentSquareWPC:
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset moveSquares
		cmp [byte ptr bx], 1
		je MoveSquareChosen
		jmp NotMoveSquareChosen
		
		MoveSquareChosen:
			call ClearMarkLastMove
			mov [fromSquareToMark], al
			push dx
			mov dl, [currentSquare]
			mov [toSquareToMark], dl
			pop dx
			CheckShortCMSC:
				cmp [shortCastleInMoves], 1
				je HelpShortCMSC
				jmp CheckLongCMSC
				HelpShortCMSC:
					cmp [turnColor], 1
					je WhiteSCMSC
					jmp BlackSCMSC
					WhiteSCMSC:
						cmp [boardSide], 1
						je NotFlippedWSCMSC
						FilppedWSCMSC:
							cmp [currentSquare], 1
							jne CheckLongCMSC
							jmp FlippedShortWhiteCMSC
						NotFlippedWSCMSC:
							cmp [currentSquare], 62
							jne CheckLongCMSC
							jmp NotFlippedShortWhiteCMSC
					BlackSCMSC:
						cmp [boardSide], 1
						je NotFlippedBSCMSC
						FlippedBSCMSC:
							cmp [currentSquare], 57
							jne CheckLongCMSC
							jmp FlippedShortBlackCMSC
						NotFlippedBSCMSC:
							cmp [currentSquare], 6
							jne CheckLongCMSC
							jmp NotFlippedShortBlackCMSC
				
			CheckLongCMSC:
				cmp [longCastleInMoves], 1
				je HelpLongCMSC
				jmp CheckEnPassant
				HelpLongCMSC:
					cmp [turnColor], 1
					je WhiteLCMSC
					jmp BlackLCMSC
					WhiteLCMSC:
						cmp [boardSide], 1
						je NotFlippedWLCMSC
						FlippedWLCMSC:
							cmp [currentSquare], 5
							jne CheckEnPassant
							jmp FlippedLongWhiteCMSC
						NotFlippedWLCMSC:
							cmp [currentSquare], 58
							jne CheckEnPassant
							jmp NotFlippedLongWhiteCMSC
					BlackLCMSC:
						cmp [boardSide], 1
						je NotFlippedBLCMSC
						FlippedBLCMSC:
							cmp [currentSquare], 61
							jne CheckEnPassant
							jmp FlippedLongBlackCMSC
						NotFlippedBLCMSC:
							cmp [currentSquare], 2
							jne CheckEnPassant
							jmp NotFlippedLongBlackCMSC
			CheckEnPassant:
				mov dl, [currentSquare]
				cmp dl, [enPassantSquare]
				jne NoGoodCEP
				xor bx, bx
				mov bl, al
				add bx, offset board
				cmp [byte ptr bx], 'p'
				je GoodCEP
				cmp [byte ptr bx], 'P'
				je GoodCEP
				jmp NoGoodCEP
				GoodCEP:
					jmp EnPassantMSC
				NoGoodCEP:
					mov [enPassantSquare], 64
					jmp CheckPromotionCMSC

			CheckPromotionCMSC:
				xor bx, bx
				mov bl, al
				add bx, offset board
				cmp [byte ptr bx], 'P'
				je WhiteCPCMSC			
				cmp [byte ptr bx], 'p'
				jne RegularMoveMSC	
				BlackCPCMSC:
					call SetCurrentRowCol
					cmp [boardSide], 1
					je DownGoingCPCMSC
					jmp UpGoingCPCMSC
				WhiteCPCMSC:
					call SetCurrentRowCol
					cmp [boardSide], 1
					je UpGoingCPCMSC
					jmp DownGoingCPCMSC
				UpGoingCPCMSC:
					cmp [currentRank], 0
					jne RegularMoveMSC
					jmp PromotionMSC
				DownGoingCPCMSC:
					cmp [currentRank], 7
					jne RegularMoveMSC
					jmp PromotionMSC

			RegularMoveMSC:
				mov [fromSquare], al
				mov dl, [currentSquare]
				mov [toSquare], dl
				call MakeMoveOnBoardArr
				call MakeMoveOnBoard
				jmp EndMSC
				
			CastleMSC:
				NotFlippedShortWhiteCMSC:
					mov [fromSquare], 60
					mov [toSquare], 62
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;king move

					mov [fromSquare], 63
					mov [toSquare], 61	
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;rook move
					jmp EndMSC
				FlippedShortWhiteCMSC:
					mov [fromSquare], 3
					mov [toSquare], 1
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;king move

					mov [fromSquare], 0
					mov [toSquare], 2	
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;rook move
					jmp EndMSC
					
				NotFlippedShortBlackCMSC:
					mov [fromSquare], 4
					mov [toSquare], 6	
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;king move
					
					mov [fromSquare], 7
					mov [toSquare], 5
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;rook move
					jmp EndMSC
				FlippedShortBlackCMSC:
					mov [fromSquare], 59
					mov [toSquare], 57	
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;king move
					
					mov [fromSquare], 56
					mov [toSquare], 58
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;rook move
					jmp EndMSC
					
				NotFlippedLongWhiteCMSC:
					mov [fromSquare], 60
					mov [toSquare], 58
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;king move

					mov [fromSquare], 56
					mov [toSquare], 59
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;rook move
					jmp EndMSC
				FlippedLongWhiteCMSC:
					mov [fromSquare], 3
					mov [toSquare], 5
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;king move

					mov [fromSquare], 7
					mov [toSquare], 4
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;rook move
					jmp EndMSC
					
				NotFlippedLongBlackCMSC:
					mov [fromSquare], 4
					mov [toSquare], 2
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;king move
					
					mov [fromSquare], 0
					mov [toSquare], 3
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;rook move
					jmp EndMSC
				FlippedLongBlackCMSC:
					mov [fromSquare], 59
					mov [toSquare], 61
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;king move
					
					mov [fromSquare], 63
					mov [toSquare], 60
					call MakeMoveOnBoardArr
					call MakeMoveOnBoard ;rook move
					jmp EndMSC
					
			EnPassantMSC:
				mov [fromSquare], al
				mov dl, [currentSquare]
				mov [toSquare], dl
				call MakeMoveOnBoardArr
				call MakeMoveOnBoard
				
				xor bx, bx
				mov bl, [toSquare]
				cmp [turnColor], 1
				jne BlackEPMSC
				WhiteEPMSC:
					cmp [boardSide], 1
					je UpCaptureEPMSC
					jmp DownCaptureEPMSC
				BlackEPMSC:
					cmp [boardSide], 1
					je DownCaptureEPMSC
					jmp UpCaptureEPMSC
				UpCaptureEPMSC:
					add bl, 8
					jmp ContinueEPMSC
				DownCaptureEPMSC:
					sub bl, 8
				ContinueEPMSC:
				mov [currentSquare], bl
				add bx, offset board
				mov [byte ptr bx], '0'
				call PrintCurrentPiece
				
				mov [enPassantSquare], 64
				jmp EndMSC
			PromotionMSC:
				mov [fromSquare], al
				mov dl, [currentSquare]
				mov [toSquare], dl
				call MakeMoveOnBoardArr
				call MakeMoveOnBoard
				call ClearMoveMarks
				call HandlePromotion
				mov [waitForReleaseNeeded], 0
				mov [promotionChosen], 1
				jmp EndMSC
				
			EndMSC:
				call ClearMoveMarks
				
				mov [fromSquare], al
				mov dl, [currentSquare]
				mov [toSquare], dl
				call MarkLastMove

				
				mov [currentSquare], 64
				call SetKingRed
				call SwitchTurn
				call SetKingRed
				
				cmp [autoFlip], 0
				je EEndMSC
				cmp [promotionChosen], 1
				je NoWaitReleaseEMSC
				
				call WaitForLeftRelease
				NoWaitReleaseEMSC:
				call SetBoardSideAsColor
				mov [waitForReleaseNeeded], 0
				EEndMSC:
					mov [promotionChosen], 0
					jmp EndClickWPC
			
		NotMoveSquareChosen:
			call CopyMoveSquaresToHelp ;old move
			call CopyMoveToHelpB ;old move
			
			call ClearMoveSquares
			call SetMoveSquaresOfPiece ;new move
			
			call AndMoveSquaresToHelp ;same squares for both moves in help
			call CopyHelpBtoMove ;old move to move
			call ResetGreenSquares ;clear squares for old move
			
			call ClearMoveSquares

			call SetMoveSquaresOfPiece ;new move
			call GreenMoveSquares ;green new move
		
			jmp EndClickWPC
	
	EndClickWPC:
		call ResetClicksInfo
		cmp [waitForReleaseNeeded], 0
		je EndTheEndClickWPC
		call WaitForLeftRelease
		;call PlayMoveSound with var of currentSound
		;call PlayChoosePieceSound
		EndTheEndClickWPC:
			mov [waitForReleaseNeeded], 1
			jmp NextMoveWPC
	NextMoveWPC:
		pop dx cx bx ax
		jmp ContinueWaitPieceClick
GameOver: ; or other zakif that stops like printed back button
	ret
endp WaitPieceClick

;IN: [fromSquare], [toSquare]
proc MarkLastMove
	push ax bx cx dx
		mov dl, [currentSquare]
		push dx
		
		mov al, [fromSquareToMark]
		mov [currentSquare], al
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset markedSquares
		mov [byte ptr bx], 1
		call PrintCurrentPiece
		
		mov al, [toSquareToMark]
		mov [currentSquare], al
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset markedSquares
		mov [byte ptr bx], 1
		call PrintCurrentPiece
		
		pop dx
		mov [currentSquare], dl
	pop dx cx bx ax
	ret
endp MarkLastMove
proc ClearMarkLastMove
	push ax bx cx dx
	mov dl, [currentSquare]
	push dx	
	
	call ClearMarkedSquares
	mov al, [fromSquareToMark]
	mov [currentSquare], al
	call PrintCurrentPiece
	
	mov al, [toSquareToMark]
	mov [currentSquare], al
	call PrintCurrentPiece
	
	pop dx
	mov [currentSquare], dl
	pop dx cx bx ax
	ret
endp ClearMarkLastMove

;IN: [currentSquare] - promotion square
;OUT: Choose piece and print on promotion square
proc HandlePromotion
	push ax bx cx dx
	xor bx, bx
	mov dl, [currentSquare]
	mov bl, [currentSquare]
	add bx, offset board
	mov [byte ptr bx], '0'
	call PrintCurrentPiece
	mov [imgHeight], 20d
	mov [imgWidth], 20d
	cmp [turnColor], 1
	je WhiteHP
	jmp BlackHP
	WhiteHP:
		cmp [boardSide], 1
		je UpGoingHandlePromotion
		jmp DownGoingHandlePromotion
	BlackHP:
		cmp [boardSide], 1
		jne UpGoingHandlePromotion
		jmp DownGoingHandlePromotion
	UpGoingHandlePromotion:
		;AX - offset img, imgHeight (dw), imgWidth (dw), printAdd (dw)
		cmp [turnColor], 1
		je WhitePrintOptionsUGHP
		jmp BlackPrintOptionsUGHP
		WhitePrintOptionsUGHP:
			mov ax, offset GqueenW
			call CurrentSquareToPrintAdd
			call PrintBmp
			mov ax, offset GrookW
			add [currentSquare], 8
			call CurrentSquareToPrintAdd
			call PrintBmp
			mov ax, offset GbishopW
			add [currentSquare], 8
			call CurrentSquareToPrintAdd
			call PrintBmp
			mov ax, offset GknightW
			add [currentSquare], 8
			call CurrentSquareToPrintAdd
			call PrintBmp
			sub [currentSquare], 24d
			jmp ContinueUGHP
		BlackPrintOptionsUGHP:
			mov ax, offset GqueenB
			call CurrentSquareToPrintAdd
			call PrintBmp
			mov ax, offset GrookB
			add [currentSquare], 8
			call CurrentSquareToPrintAdd
			call PrintBmp
			mov ax, offset GbishopB
			add [currentSquare], 8
			call CurrentSquareToPrintAdd
			call PrintBmp
			mov ax, offset GknightB
			add [currentSquare], 8
			call CurrentSquareToPrintAdd
			call PrintBmp
			sub [currentSquare], 24d
			jmp ContinueUGHP
		ContinueUGHP:
		call SetCurrentRowCol
		mov dl, [currentFile]
		mov [currentFileHelp], dl
		NotInBoundsUpHP:
		call WaitForLeftRelease
		call WaitForLeftClick
		call CoordinateInBoardBounds
		cmp ax, 0
		jne NotInBoundsUpHP
		call CoordinateToBoard
		mov dl, [currentFileHelp]
		cmp [currentFile], dl
		jne NotInBoundsUpHP
		
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset board
		
		cmp [turnColor], 1
		je WhiteSetChosenUGHP
		jmp BlackSetChosenUGHP
		WhiteSetChosenUGHP:	
			cmp [currentRank], 0
			je UpQueenPromotionW
			cmp [currentRank], 1
			je UpRookPromotionW
			cmp [currentRank], 2
			je UpBishopPromotionW
			cmp [currentRank], 3
			je UpKnightPromotionW
			jmp NotInBoundsUpHP
			
			UpQueenPromotionW:
				mov [byte ptr bx], 'Q'
				jmp EndUpHP
			UpRookPromotionW:
				mov [byte ptr bx], 'R'
				jmp EndUpHP
			UpBishopPromotionW:
				mov [byte ptr bx], 'B'
				jmp EndUpHP
			UpKnightPromotionW:
				mov [byte ptr bx], 'N'
				jmp EndUpHP
				
		BlackSetChosenUGHP:
			cmp [currentRank], 0
			je UpQueenPromotionB
			cmp [currentRank], 1
			je UpRookPromotionB
			cmp [currentRank], 2
			je UpBishopPromotionB
			cmp [currentRank], 3
			je UpKnightPromotionB
			jmp NotInBoundsUpHP
			
			UpQueenPromotionB:
				mov [byte ptr bx], 'q'
				jmp EndUpHP
			UpRookPromotionB:
				mov [byte ptr bx], 'r'
				jmp EndUpHP
			UpBishopPromotionB:
				mov [byte ptr bx], 'b'
				jmp EndUpHP
			UpKnightPromotionB:
				mov [byte ptr bx], 'n'
				jmp EndUpHP		
		EndUpHP:
			call UpdatePiecesOnBoard
			jmp ExitHP
	DownGoingHandlePromotion:
		;AX - offset img, imgHeight (dw), imgWidth (dw), printAdd (dw)
		cmp [turnColor], 1
		je WhitePrintOptionsDGHP
		jmp BlackPrintOptionsDGHP
		WhitePrintOptionsDGHP:	
			mov ax, offset GqueenW
			call CurrentSquareToPrintAdd
			call PrintBmp
			mov ax, offset GrookW
			sub [currentSquare], 8
			call CurrentSquareToPrintAdd
			call PrintBmp	
			mov ax, offset GbishopW
			sub [currentSquare], 8
			call CurrentSquareToPrintAdd
			call PrintBmp
			mov ax, offset GknightW
			sub [currentSquare], 8
			call CurrentSquareToPrintAdd
			call PrintBmp
			add [currentSquare], 24d
			jmp ContinueDGHP
		BlackPrintOptionsDGHP:
			mov ax, offset GqueenB
			call CurrentSquareToPrintAdd
			call PrintBmp
			mov ax, offset GrookB
			sub [currentSquare], 8
			call CurrentSquareToPrintAdd
			call PrintBmp	
			mov ax, offset GbishopB
			sub [currentSquare], 8
			call CurrentSquareToPrintAdd
			call PrintBmp
			mov ax, offset GknightB
			sub [currentSquare], 8
			call CurrentSquareToPrintAdd
			call PrintBmp
			add [currentSquare], 24d
			jmp ContinueDGHP		
		ContinueDGHP:
		call SetCurrentRowCol
		mov dl, [currentFile]
		mov [currentFileHelp], dl
		NotInBoundsDownHP:
		call WaitForLeftRelease
		call WaitForLeftClick
		call CoordinateInBoardBounds
		cmp ax, 0
		jne NotInBoundsDownHP
		call CoordinateToBoard
		mov dl, [currentFileHelp]
		cmp [currentFile], dl
		jne NotInBoundsDownHP
		
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset board
		
		cmp [turnColor], 1
		je WhiteSetChosenDGHP
		jmp BlackSetChosenDGHP
		WhiteSetChosenDGHP:	
			cmp [currentRank], 7
			je DownQueenPromotionW
			cmp [currentRank], 6
			je DownRookPromotionW
			cmp [currentRank], 5
			je DownBishopPromotionW
			cmp [currentRank], 4
			je DownKnightPromotionW
			jmp NotInBoundsDownHP
			
			DownQueenPromotionW:
				mov [byte ptr bx], 'Q'
				jmp EndDownHP
			DownRookPromotionW:
				mov [byte ptr bx], 'R'
				jmp EndDownHP
			DownBishopPromotionW:
				mov [byte ptr bx], 'B'
				jmp EndDownHP
			DownKnightPromotionW:
				mov [byte ptr bx], 'N'
				jmp EndDownHP
				
		BlackSetChosenDGHP:
			cmp [currentRank], 7
			je DownQueenPromotionB
			cmp [currentRank], 6
			je DownRookPromotionB
			cmp [currentRank], 5
			je DownBishopPromotionB
			cmp [currentRank], 4
			je DownKnightPromotionB
			jmp NotInBoundsDownHP
			
			DownQueenPromotionB:
				mov [byte ptr bx], 'q'
				jmp EndDownHP
			DownRookPromotionB:
				mov [byte ptr bx], 'r'
				jmp EndDownHP
			DownBishopPromotionB:
				mov [byte ptr bx], 'b'
				jmp EndDownHP
			DownKnightPromotionB:
				mov [byte ptr bx], 'n'
				jmp EndDownHP		
		EndDownHP:
			call UpdatePiecesOnBoard
			jmp ExitHP
	ExitHP:
	call WaitForLeftRelease
	pop ax bx cx dx
	ret
endp HandlePromotion


;IN: [currentRank], [currentFile]
;OUT: [toSquare] = [currentSquare]
proc RankFileTOtoSquare
	push ax dx
	mov dl, [currentSquare]
	call SetCurrentSquare
	mov al, [currentSquare]
	mov [toSquare], al
	mov [currentSquare], dl
	pop dx ax
	ret
endp RankFileTOtoSquare

;IN: [currentRank], [currentFile]
;OUT: [fromSquare] = [currentSquare]
proc RankFileTOfromSquare
	push ax dx
	mov dl, [currentSquare]
	call SetCurrentSquare
	mov al, [currentSquare]
	mov [fromSquare], al
	mov [currentSquare], dl
	pop dx ax
	ret
endp RankFileTOfromSquare

proc ClearMoveMarks
	call ClearSquaresHelp
	call ResetGreenSquares
	call ClearMoveSquares
	call ClearAttackedSquares
	;mov [currentSquare], 64d
	ret
endp ClearMoveMarks

;IN: [fromSquare], [toSquare]
;OUT: switched on board array
proc MakeMoveOnBoardArr
	push ax bx dx
	
	xor bx, bx
	mov dl, [currentSquare]
	
	cmp [boardSide], 1
	jne FlippedPreventCastle
	NotFlippedPreventCastle:
		cmp [fromSquare], 60
		je WhiteFSIKP
		cmp [fromSquare], 4
		je BlackFSIKP
		cmp [fromSquare], 63
		je WhiteFSIKRP
		cmp [fromSquare], 56
		je WhiteFSIQRP
		cmp [fromSquare], 7
		je BlackFSIKRP
		cmp [fromSquare], 0
		je BlackFSIQRP
		jmp CheckSetEnPassant
	FlippedPreventCastle:
		cmp [fromSquare], 3
		je WhiteFSIKP
		cmp [fromSquare], 59
		je BlackFSIKP
		cmp [fromSquare], 0
		je WhiteFSIKRP
		cmp [fromSquare], 7
		je WhiteFSIQRP
		cmp [fromSquare], 56
		je BlackFSIKRP
		cmp [fromSquare], 63
		je BlackFSIQRP
		jmp CheckSetEnPassant		
	
	FromSquareIsKingPlace:
	WhiteFSIKP:
		mov [WK_castle], 0
		mov [WQ_castle], 0
		jmp ContinueMMOBA
	BlackFSIKP:
		mov [Bk_castle], 0
		mov [Bq_castle], 0
		jmp ContinueMMOBA
		
	FromSquareIsKRookPlace:
	WhiteFSIKRP:
		mov [WK_castle], 0
		jmp ContinueMMOBA
	BlackFSIKRP:
		mov [Bk_castle], 0	
		jmp ContinueMMOBA
		
	FromSquareIsQRookPlace:
	WhiteFSIQRP:
		mov [WQ_castle], 0
		jmp ContinueMMOBA
	BlackFSIQRP:	
		mov [Bq_castle], 0
		jmp ContinueMMOBA
		

	CheckSetEnPassant:
		xor bx, bx
		mov bl, [fromSquare]
		add bx, offset board
		cmp [byte ptr bx], 'P'
		je GoodCSEP
		cmp [byte ptr bx], 'p'
		jne ContinueMMOBA
		GoodCSEP:
			mov al, [fromSquare]
			mov [currentSquare], al
			call SetCurrentRowCol
			call CheckPawnGoingSide
			cmp ax, 0
			je GoingUpCSEP
			jmp GoingDownCSEP
		GoingUpCSEP:
			mov bl, [fromSquare]
			mov [currentSquare], bl
			call SetCurrentRowCol
			cmp [currentRank], 6
			jne ContinueMMOBA
			
			mov bl, [toSquare]
			mov [currentSquare], bl
			call SetCurrentRowCol
			cmp [currentRank], 4
			jne ContinueMMOBA		
			
			mov [enPassantSquare], bl
			add [enPassantSquare], 8
			jmp ContinueMMOBA

		GoingDownCSEP:	
			mov bl, [fromSquare]
			mov [currentSquare], bl
			call SetCurrentRowCol
			cmp [currentRank], 1
			jne ContinueMMOBA
			
			mov bl, [toSquare]
			mov [currentSquare], bl
			call SetCurrentRowCol
			cmp [currentRank], 3
			jne ContinueMMOBA		
			
			mov [enPassantSquare], bl
			sub [enPassantSquare], 8
			jmp ContinueMMOBA
	
	ContinueMMOBA:
		xor bx, bx
		mov bl, [fromSquare]
		add bx, offset board
		mov al, [byte ptr bx] ;moved piece
		mov [byte ptr bx], '0'
		
		xor bx, bx
		mov bl, [toSquare]
		add bx, offset board
		mov [byte ptr bx], al
		
	mov [currentSquare], dl
	call SetCurrentRowCol
	pop dx bx ax 
	ret
endp MakeMoveOnBoardArr

;IN: [fromSquare], [toSquare]
;OUT: switched on board
proc MakeMoveOnBoard
	push ax bx
	
	mov al, [fromSquare]
	mov [currentSquare], al
	call PrintCurrentPiece
				
	mov al, [toSquare]
	mov [currentSquare], al
	call PrintCurrentPiece
	
	pop ax bx
	ret
endp MakeMoveOnBoard


;Copies [startingBoard] to [board]
proc SetStartingBoard
	;ax - source offset, bx - destination offset, cx - length
	mov ax, offset startingBoard
	mov bx, offset board
	mov cx, 64
	call CopyText
	ret
endp SetStartingBoard

;IN: X
;OUT: [squaresHelp] updated
proc SetAttackedSquares
	push ax bx cx
	call ClearAttackedSquares
	mov al, [currentSquare]
	mov cx, 64
	SetAttackedSquaresPieces:
		push cx
		dec cl
		mov [currentSquare], cl
		mov [attackedSquaresIsMove], 0
		call SetAttackedSquaresOfPiece
		pop cx
		loop SetAttackedSquaresPieces
		
	mov [currentSquare], al
	call SetCurrentRowCol
	pop cx bx ax
	ret
endp SetAttackedSquares

;IN: [currentSquare]
;OUT: [currentPieceColor] updated
proc SetPieceColor
	push ax bx
	
	mov al, [currentSquare]
	
	xor bx, bx
	mov bl, [currentSquare]
	add bx, offset board
	
	cmp [byte ptr bx], 'a'
	jge BlackCheckPieceColor
	;jl BlackCheckPieceColor ;debugging
	
	WhiteCheckPieceColor:
	mov [currentPieceColor], 1
	jmp ExitCheckPieceColor
	
	BlackCheckPieceColor:
	mov [currentPieceColor], 0
	
	ExitCheckPieceColor:
	mov [currentSquare], al
	pop bx ax
	ret
endp SetPieceColor

;IN: [fromSquare], [toSquare], [toRemoveEnPassant]
;OUT: [kingAttacked]
proc CheckKingAfterMove
	push ax bx cx dx
	call CopyBoardToHelp
	call CopyAttackedSquaresToHelp
	call CopyEnPassantAndCastlesToHelp
	call MakeMoveOnBoardArr
	cmp [toRemoveEnPassant], 64
	jnl NoEnPassantCKAM
	xor bx, bx
	mov bl, [toRemoveEnPassant]
	add bx, offset board
	mov [byte ptr bx], '0'
	NoEnPassantCKAM:
	call SetKingAttacked
	call CopyHelpToAttackedSquares
	call CopyHelpToBoard
	call CopyHelpToEnPassantAndCastles
	pop dx cx bx ax
	ret
endp CheckKingAfterMove



;IN: [currentRank], [currentFile], [attackedSquaresIsMove], [fromSquare]
;OUT: square updated in [attackedSquares], ax: 0 - continue
;										   1 - out						   
proc SetSquareAttacked
	call RowColInBoardBounds
	cmp ax, 1
	jne BoundsOkSSA
	jmp ExitBigProcSSA
	
	BoundsOkSSA:

	
	call SetCurrentSquare
	mov cl, [currentSquare]
	mov [toSquare], cl
	
	xor bx, bx
	mov bl, [currentSquare]
	add bx, offset board
	
	cmp [attackedSquaresIsMove], 1
	je MovesSSA
	jmp NotMovesSSA
	MovesSSA:
		mov [toRemoveEnPassant], 64
		call CheckKingAfterMove
		cmp [byte ptr bx], '0'
		je NoLastMoveToSide
		jmp LastMoveToSide	
		NoLastMoveToSide:
			cmp [kingAttacked], 1
			je NextSetSquareAttacked
			jmp SetAsAttacked
		LastMoveToSide:
			cmp [kingAttacked], 1
			je ExitBigProcSSA		
			jmp SetAsAttackedExit
	NotMovesSSA:
		cmp [byte ptr bx], '0'
		je SetAsAttacked
		jmp SetAsAttackedExit
			
	SetAsAttackedExit:
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset attackedSquares
		mov [byte ptr bx], 1
		jmp ExitBigProcSSA
		
	SetAsAttacked:
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset attackedSquares
		
		mov [byte ptr bx], 1
		mov ax, 0
		jmp NextSetSquareAttacked

	ExitBigProcSSA:
		mov ax, 1
		
	NextSetSquareAttacked:
	mov cl, [fromSquare]
	mov [currentSquare], cl
	ret
endp SetSquareAttacked

proc SetKingAttacked
	push ax bx cx
	call SwitchTurn

	call ClearAttackedSquares

	mov al, [fromSquare]
	mov ah, [attackedSquaresIsMove]
	push ax
	call SetAttackedSquares
	pop ax
	mov [attackedSquaresIsMove], ah
	mov [fromSquare], al
	call SwitchTurn
	
	call SetKingPos
	
	;smth strange happenned here
	; mov cx, 64
	; LoopKIA:
		; push cx
		; dec cx
		; xor bx, bx
		; mov bl, cl
		; add bx, offset board
		; cmp [turnColor], 1 (boardSide)
		; jne BlackLKIA
		; WhiteLKIA:
			; cmp [byte ptr bx], 'K'
			; je KingFoundLKIA
		; BlackLKIA:
			; cmp [byte ptr bx], 'k'
			; je KingFoundLKIA
		; pop cx
	; loop LoopKIA
	; pop cx bx ax
	; ret
	
	call SetKingPos
	;KingFoundLKIA:
		xor bx, bx	
		mov bl, [kingPosition]
		;pop cx
		add bx, offset attackedSquares
		cmp [byte ptr bx], 1
		je KingAttackedKIA
		mov [kingAttacked], 0
		jmp EndKIA
		KingAttackedKIA:
			mov [kingAttacked], 1
		EndKIA:
		pop cx bx ax
		ret
endp SetKingAttacked


;IN: [currentRank], [currentFile]
;OUT: AX - 0 - ok
;		   1 - bad
proc RowColInBoardBounds
	cmp [currentRank], 0
	jl NotRCIBB
	cmp [currentRank], 7
	jg NotRCIBB
	cmp [currentFile], 0
	jl NotRCIBB
	cmp [currentFile], 7
	jg NotRCIBB
	
	mov ax, 0
	jmp ExitRCIBB
	
	NotRCIBB:
	mov ax, 1
	
	ExitRCIBB:
	ret
endp RowColInBoardBounds

proc SetKingPos
	push bx cx
	mov cx, 64
	LoopSKP:
		push cx
		dec cx
		xor bx, bx
		mov bl, cl
		add bx, offset board
		cmp [turnColor], 1
		jne BlackSKP
		WhiteSKP:
			cmp [byte ptr bx], 'K'
			je KingFoundSKP
			jmp ContinueLoopSKP
		BlackSKP:
			cmp [byte ptr bx], 'k'
			je KingFoundSKP
			jmp ContinueLoopSKP
		ContinueLoopSKP:
		pop cx
	loop LoopSKP
	mov al, [removedPiece] ;if the king was removed in proc
	mov [kingPosition], al
	jmp EndSKP
	
	KingFoundSKP:
	mov [kingPosition], cl
	pop cx
	
	EndSKP:
	pop cx bx
	ret
endp SetKingPos
;IN: [currentFile], [currentRank], AX: 0 - up
;									   1 - up-right
;									   2 - right
;									   3 - down-right
;									   4 - down
;									   5 - down-left
;									   6 - left
;									   7 - up-left
									   
;OUT: [attackedSquares] of piece updated
proc SetAttackedSquaresOfPieceToSide
	push ax bx dx
	
	xor bx, bx
	xor dx, dx
	
	mov bl, [currentRank]
	mov dl, [currentFile]
	
	push bx dx
	LoopSetAttackedSquares:
		UpSASOP2:
			cmp ax, 0
			jne UpRightSASOP2
			jmp ContinueSetSquares
		UpRightSASOP2:
			cmp ax, 1
			jne RightSASOP2
			jmp ContinueSetSquares
		RightSASOP2:
			cmp ax, 2
			jne DownRightSASOP2
			jmp ContinueSetSquares
		DownRightSASOP2:
			cmp ax, 3
			jne DownSASOP2
			jmp ContinueSetSquares
		DownSASOP2:
			cmp ax, 4
			jne DownLeftSASOP2
			jmp ContinueSetSquares
		DownLeftSASOP2:
			cmp ax, 5
			jne LeftSASOP2
			jmp ContinueSetSquares
		LeftSASOP2:
			cmp ax, 6
			jne UpLeftSASOP2
			jmp ContinueSetSquares
		UpLeftSASOP2:
			cmp ax, 7
			jne NtrlHelpExitSASOP
			jmp ContinueSetSquares

		NtrlHelpExitSASOP:
		jmp ExitSASOP
		
		ContinueSetSquares:
		UpSASOP:
			cmp ax, 0
			jne UpRightSASOP
			dec [currentRank]
		UpRightSASOP:
			cmp ax, 1
			jne RightSASOP
			dec [currentRank]
			inc [currentFile]
		RightSASOP:
			cmp ax, 2
			jne DownRightSASOP
			inc [currentFile]
		DownRightSASOP:
			cmp ax, 3
			jne DownSASOP
			inc [currentRank]
			inc [currentFile]
		DownSASOP:
			cmp ax, 4
			jne DownLeftSASOP
			inc [currentRank]
		DownLeftSASOP:
			cmp ax, 5
			jne LeftSASOP
			inc [currentRank]
			dec [currentFile]
		LeftSASOP:
			cmp ax, 6
			jne UpLeftSASOP
			dec [currentFile]
		UpLeftSASOP:
			cmp ax, 7
			jne CntnSASOP
			dec [currentRank]
			dec [currentFile]
		CntnSASOP:
		
		push ax
		call SetSquareAttacked
		cmp ax, 1
		pop ax
		je ExitSASOP

	jmp LoopSetAttackedSquares

	ExitSASOP:
	pop dx bx
	mov [currentRank], bl
	mov [currentFile], dl
	call SetCurrentSquare
	pop dx bx ax
	ret
endp SetAttackedSquaresOfPieceToSide

;IN: [currentSquare], [attackedSquaresIsMove]
;OUT: [attackedSquares] of piece updated
proc SetAttackedSquaresOfPiece
	push ax bx cx dx
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	mov dl, [currentSquare]
	mov [fromSquare], dl
	push dx
	
	call SetCurrentRowCol
	
	mov bl, [currentSquare]
	add bx, offset board
	
	mov al, [turnColor]
	call SetPieceColor
	cmp al, [currentPieceColor]
	jne HelpExitSetAttackedSquaresOfPiece
	;je HelpExitSetAttackedSquaresOfPiece ;debugging
	jmp RookSetAttackedSquares
	
	HelpExitSetAttackedSquaresOfPiece:
	jmp ExitSetAttackedSquaresOfPiece
	
	
	

	RookSetAttackedSquares:
		mov ax, 'R'
		cmp [bx], al
		je SetAttackedSquaresForRook
		add ax, 32
		cmp [bx], al
		jne KnightSetAttackedSquares

		SetAttackedSquaresForRook:
		mov ax, 0
		call SetAttackedSquaresOfPieceToSide
		mov ax, 2
		call SetAttackedSquaresOfPieceToSide
		mov ax, 4
		call SetAttackedSquaresOfPieceToSide
		mov ax, 6
		call SetAttackedSquaresOfPieceToSide
	KnightSetAttackedSquares:
		mov ax, 'N'
		cmp [bx], al
		je SetAttackedSquaresForKnight
		add ax, 32
		cmp [bx], al
		je SetAttackedSquaresForKnight
		jmp BishopSetAttackedSquares

		SetAttackedSquaresForKnight:
		mov dh, [currentFile]
		mov dl, [currentRank]
		
		sub [currentRank], 2
		inc [currentFile]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
		dec [currentRank]
		add [currentFile], 2
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
		inc [currentRank]
		add [currentFile], 2
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
		add [currentRank], 2
		inc [currentFile]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
		add [currentRank], 2
		dec [currentFile]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
		inc [currentRank]
		sub [currentFile], 2
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
		dec [currentRank]
		sub [currentFile], 2
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
		sub [currentRank], 2
		dec [currentFile]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
	BishopSetAttackedSquares:
		mov ax, 'B'
		cmp [bx], al
		je SetAttackedSquaresForBishop
		add ax, 32
		cmp [bx], al
		jne QueenSetAttackedSquares

		SetAttackedSquaresForBishop:
		mov ax, 1
		call SetAttackedSquaresOfPieceToSide
		mov ax, 3
		call SetAttackedSquaresOfPieceToSide
		mov ax, 5
		call SetAttackedSquaresOfPieceToSide
		mov ax, 7
		call SetAttackedSquaresOfPieceToSide
	QueenSetAttackedSquares:
		mov ax, 'Q'
		cmp [bx], al
		je SetAttackedSquaresForQueen
		add ax, 32
		cmp [bx], al
		jne KingSetAttackedSquares

		SetAttackedSquaresForQueen:
		mov ax, 0
		call SetAttackedSquaresOfPieceToSide
		mov ax, 1
		call SetAttackedSquaresOfPieceToSide
		mov ax, 2
		call SetAttackedSquaresOfPieceToSide
		mov ax, 3
		call SetAttackedSquaresOfPieceToSide
		mov ax, 4
		call SetAttackedSquaresOfPieceToSide
		mov ax, 5
		call SetAttackedSquaresOfPieceToSide
		mov ax, 6
		call SetAttackedSquaresOfPieceToSide
		mov ax, 7
		call SetAttackedSquaresOfPieceToSide
		
	KingSetAttackedSquares:
		mov ax, 'K'
		cmp [bx], al
		je SetAttackedSquaresForKing
		add ax, 32
		cmp [bx], al
		je SetAttackedSquaresForKing
		jmp PawnSetAttackedSquares
		
		SetAttackedSquaresForKing:
		mov dh, [currentFile]
		mov dl, [currentRank]
		
		dec [currentRank]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
		dec [currentRank]
		inc [currentFile]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
		inc [currentFile]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
		inc [currentRank]
		inc [currentFile]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
		inc [currentRank]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
		inc [currentRank]
		dec [currentFile]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
		dec [currentFile]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
		dec [currentRank]
		dec [currentFile]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		
	PawnSetAttackedSquares:
		mov ax, 'P'
		cmp [bx], al
		je SetAttackedSquaresForPawn
		add ax, 32
		cmp [bx], al
		jne ExitSetAttackedSquaresOfPiece

		SetAttackedSquaresForPawn:
		mov dh, [currentFile]
		mov dl, [currentRank]
		
		call CheckPawnGoingSide
		cmp ax, 1
		je DownSASFP
		UpSASFP:
		dec [currentRank]
		dec [currentFile]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl

		dec [currentRank]
		inc [currentFile]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
		jmp ExitSetAttackedSquaresOfPiece
		
		DownSASFP:
		inc [currentRank]
		dec [currentFile]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl

		inc [currentRank]
		inc [currentFile]
		call SetSquareAttacked
		mov [currentFile], dh
		mov [currentRank], dl
	ExitSetAttackedSquaresOfPiece:
	pop dx
	mov [currentSquare], dl
	pop dx cx bx ax
	ret
endp SetAttackedSquaresOfPiece

;IN: AX: 0 - short
;		 1 - long
;OUT: AX: 0 - ok
;		  1 - no
proc SetMoveSquareCastle
	push bx
	
	cmp [boardSide], 1
	je NotFlippedSMSC
	jmp FlippedSMSC
	
	NotFlippedSMSC:
		cmp [turnColor], 1
		je NFWhiteSMSSC
		jmp NFBlackSMSSC
		NFWhiteSMSSC:
			mov [currentRank], 7
			jmp NFContinueSMSSCA
		NFBlackSMSSC:
			mov [currentRank], 0
			jmp NFContinueSMSSCA
			
		NFContinueSMSSCA:
		cmp ax, 0
		je NFShortSMSC
		NFLongSMSC:
			mov [currentFile], 3
			jmp NFContinueSMSSCB
		NFShortSMSC:
			mov [currentFile], 5
			jmp NFContinueSMSSCB
			
		NFContinueSMSSCB:
		call SetCurrentSquare
		
		xor bx, bx
		call SetKingPos
		mov bl, [kingPosition]
		add bx, offset attackedSquares
		cmp [byte ptr bx], 0
		je NFKingNotChecked
		jmp ExitSMSSC
		NFKingNotChecked:
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset board
		cmp [byte ptr bx], '0'
		je ContinueNFKNCA
		jmp ExitSMSSC
		ContinueNFKNCA:
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset attackedSquares
		cmp [byte ptr bx], 0
		je ContinueNFKNCB
		jmp ExitSMSSC
		ContinueNFKNCB:
		NFFirstSquareOkSMSK:	
			cmp ax, 0
			je NFShortSMSCC
			NFLongSMSCC:
				dec [currentFile]
				jmp NFContinueSMSSCC
			NFShortSMSCC:
				inc [currentFile]
				jmp NFContinueSMSSCC
				
			NFContinueSMSSCC:
			call SetCurrentSquare
		
			xor bx, bx
			mov bl, [currentSquare]
			add bx, offset board
			cmp [byte ptr bx], '0'
			je ContinueNFKNCC
			jmp ExitSMSSC
			ContinueNFKNCC:
			xor bx, bx
			mov bl, [currentSquare]
			add bx, offset attackedSquares
			cmp [byte ptr bx], 0
			je NFSecondSquareOkSMSK
			jmp ExitSMSSC
		NFSecondSquareOkSMSK:
			cmp ax, 0
			je NFLongSquareOK
			NFLongSquareCheck:
				dec [currentFile]
				call SetCurrentSquare
				xor bx, bx
				mov bl, [currentSquare]
				add bx, offset board
				inc [currentFile]
				call SetCurrentSquare				
				cmp [byte ptr bx], '0'
				je NFLongSquareOK
				jmp ExitSMSSC
			NFLongSquareOK:
			cmp ax, 0
			je NFShortSMSCD
			jmp NFLongSMSCD
			NFLongSMSCD:
				mov [longCastleInMoves], 1
				jmp NFContinueSMSSCD
			NFShortSMSCD:
				mov [shortCastleInMoves], 1
				jmp NFContinueSMSSCD
				
			NFContinueSMSSCD:
			jmp SetMoveSMSSC
			
			
	FlippedSMSC:
		cmp [turnColor], 1
		je FWhiteSMSSC
		jmp FBlackSMSSC
		FWhiteSMSSC:
			mov [currentRank], 0
			jmp FContinueSMSSCA
		FBlackSMSSC:
			mov [currentRank], 7
			jmp FContinueSMSSCA
			
		FContinueSMSSCA:
		cmp ax, 0
		je FShortSMSC
		FLongSMSC:
			mov [currentFile], 4
			jmp FContinueSMSSCB
		FShortSMSC:
			mov [currentFile], 2
			jmp FContinueSMSSCB
			
		FContinueSMSSCB:
		call SetCurrentSquare
		
		xor bx, bx
		call SetKingPos
		mov bl, [kingPosition]
		add bx, offset attackedSquares
		cmp [byte ptr bx], 0
		je FKingNotChecked
		jmp ExitSMSSC
		FKingNotChecked:
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset board
		cmp [byte ptr bx], '0'
		je FFristSquareEmpty
		jmp ExitSMSSC
		FFristSquareEmpty:
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset attackedSquares
		cmp [byte ptr bx], 0
		jne ExitSMSSC
		
		FFirstSquareOkSMSK:	
			cmp ax, 0
			je FShortSMSCC
			FLongSMSCC:
				inc [currentFile]
				jmp FContinueSMSSCC
			FShortSMSCC:
				dec [currentFile]
				jmp FContinueSMSSCC
				
			FContinueSMSSCC:
			call SetCurrentSquare
		
			xor bx, bx
			mov bl, [currentSquare]
			add bx, offset board
			cmp [byte ptr bx], '0'
			jne ExitSMSSC
			
			xor bx, bx
			mov bl, [currentSquare]
			add bx, offset attackedSquares
			cmp [byte ptr bx], 0
			je FSecondSquareOkSMSK
			jmp ExitSMSSC
		FSecondSquareOkSMSK:
			cmp ax, 0
			je FLongSquareOK
			FLongSquareCheck:
				inc [currentFile]
				call SetCurrentSquare
				xor bx, bx
				mov bl, [currentSquare]
				add bx, offset board
				dec [currentFile]
				call SetCurrentSquare
				cmp [byte ptr bx], '0'
				jne ExitSMSSC
			FLongSquareOK:
			cmp ax, 0
			je FShortSMSCD
			FLongSMSCD:
				mov [longCastleInMoves], 1
				jmp FContinueSMSSCD
			FShortSMSCD:
				mov [shortCastleInMoves], 1
				jmp FContinueSMSSCD
				
			FContinueSMSSCD:
			jmp SetMoveSMSSC
	
	
	ExitSMSSC:
		mov ax, 1
		pop bx
		ret
	SetMoveSMSSC:
		mov ax, 0
		pop bx
		ret
endp SetMoveSquareCastle



;IN: [currentRank], [currentFile], ax: 0 - fwd, [attackedSquaresIsMove], [fromSquare]
;									   1 - eat
;OUT: square updated in [moveSquares]		ax: 0 - ok
;									  		 	1 - stop fwd		   
proc SetMoveSquarePawn
	push bx 
	push ax
	call RowColInBoardBounds
	cmp ax, 1
	pop ax
	
	jne BoundsOkSMAP
	jmp ExitSMSP
	BoundsOkSMAP:
	call SetCurrentSquare
	xor bx, bx
	mov bl, [currentSquare]
	mov [toSquare], bl
	add bx, offset board
	
	mov [toRemoveEnPassant], 64
			
	cmp ax, 0
	je ForwardSMSP
	jmp CaptureSMSP
	ForwardSMSP:
		cmp [byte ptr bx], '0'
		je SetAsMove
		jmp StopExitSMSP
	CaptureSMSP:
		mov al, [enPassantSquare]
		cmp al, [currentSquare]
		je EnPassantCSMSP
		jmp NoEnPassantCSMSP
		EnPassantCSMSP:
			mov al, [enPassantSquare]
			mov [toRemoveEnPassant], al
			jmp SetAsMove
		NoEnPassantCSMSP:
		cmp [byte ptr bx], '0'
		je ExitSMSP
	
		call SetPieceColor
		mov al, [currentPieceColor]
		cmp al, [turnColor]
		je ExitSMSP
		jmp SetAsMove
	
	SetAsMove:
		call CheckKingAfterMove
		cmp [kingAttacked], 1
		je ExitSMSP
		
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset moveSquares

		mov [byte ptr bx], 1
		jmp ExitSMSP
		
	StopExitSMSP:
	mov ax, 1
	pop bx
	ret
	
	ExitSMSP:
	mov ax, 0
	pop bx
	ret
endp SetMoveSquarePawn 

;IN: [currentRank], [currentFile], all enemy [attackedSquares], ax: 0 - regular mov
;									   								1 - short castle
;									   								2 - long castle
;OUT: square updated in [moveSquares]					   
proc SetMoveSquareKing
	push ax bx dx
	mov dl, [currentSquare]
	cmp ax, 0
	je RegularMoveSMSK
	jmp CastleSMSK
	
	RegularMoveSMSK:
		push ax
		call RowColInBoardBounds
		cmp ax, 0
		pop ax
		
		je BoundsOkSMSK
		jmp ExitSMSK
		
		BoundsOkSMSK:
		call SetCurrentSquare
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset attackedSquares
		cmp [byte ptr bx], 0
		je AttackedOkSMSK
		jmp ExitSMSK
		
		AttackedOkSMSK:
		xor bx, bx
		mov bl, [currentSquare]
		add bx, offset board
		cmp [byte ptr bx], '0'
		je BlankSquareSMSK
		jmp NotBlankSquareSMSK
		BlankSquareSMSK:
			jmp SetAsMoveSMSK
		NotBlankSquareSMSK:
			call SetPieceColor
			mov al, [currentPieceColor]
			cmp al, [turnColor]
			jne HelpSetAsMoveSMSK
			jmp ExitSMSK
			HelpSetAsMoveSMSK:
			jmp SetAsMoveSMSK
			
	CastleSMSK:
		cmp ax, 1
		je ShortCastleSMSK
		jmp LongCastleSMSK
		
		ShortCastleSMSK:
			cmp [turnColor], 1
			je WhiteSCSMSK
			jmp BlackSCSMSK
			WhiteSCSMSK:
				cmp [WK_castle], 1
				je ContinueSCSMSK
				jmp ExitSMSK
			BlackSCSMSK:
				cmp [Bk_castle], 1
				je ContinueSCSMSK
				jmp ExitSMSK
			ContinueSCSMSK:
				mov ax, 0
				call SetMoveSquareCastle
				cmp ax, 0
				je SetAsMoveSMSK
				jmp ExitSMSK
			
		LongCastleSMSK:
			cmp [turnColor], 1
			je WhiteLCSMSK
			jmp BlackLCSMSK
			WhiteLCSMSK:
				cmp [WQ_castle], 1
				je ContinueLCSMSK
				jmp ExitSMSK
			BlackLCSMSK:
				cmp [Bq_castle], 1
				je ContinueLCSMSK
				jmp ExitSMSK
			ContinueLCSMSK:
				mov ax, 1
				call SetMoveSquareCastle
				cmp ax, 0
				je SetAsMoveSMSK
				jmp ExitSMSK
			
	SetAsMoveSMSK:
	xor bx, bx
	mov bl, [currentSquare]
	add bx, offset moveSquares
	mov [byte ptr bx], 1
	jmp ExitSMSK
	
	ExitSMSK:
	mov [currentSquare], dl
	pop dx bx ax
	ret
endp SetMoveSquareKing

;IN: [currentSquare]
;OUT: [squaresHelp] of piece updated
proc SetMoveSquaresOfPiece
	push ax bx cx dx
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	
	mov dl, [currentSquare]
	mov [fromSquare], dl
	push dx
	
	call SetCurrentRowCol
	mov dh, [currentFile]
	mov dl, [currentRank]
	
	mov bl, [currentSquare]
	add bx, offset board
	
	mov al, [turnColor]
	call SetPieceColor
	cmp al, [currentPieceColor]
	jne HelpExitSMSOP
	jmp PawnSMS
	
	HelpExitSMSOP:
	jmp ExitSMSOP
	
	
	PawnSMS:
		mov ax, 'P'
		cmp [bx], al
		je ContinuePawnSMS
		add ax, 32
		cmp [bx], al
		je ContinuePawnSMS
		jmp KingSMS
		
		ContinuePawnSMS:
			call SetCurrentRowCol
			call CheckPawnGoingSide
			cmp ax, 1
			je DownSMSFP
			UpSMSFP:
			ForwardSMSFPU:
				cmp [currentRank], 6
				je FirstMoveSMSFPU
				
				NotFirstMoveSMSFPU:
					dec [currentRank]
					mov ax, 0
					call SetMoveSquarePawn
					mov [currentRank], dl
					jmp CaptureSMSFPU
					
				FirstMoveSMSFPU:
					FirstSquareFMSMSFPU:
						dec [currentRank]
						mov ax, 0
						call SetMoveSquarePawn
						mov [currentRank], dl	

					cmp ax, 1
					jne SecondSquareFMSMSFPU
					jmp CaptureSMSFPU

					SecondSquareFMSMSFPU:
						sub [currentRank], 2
						mov ax, 0
						call SetMoveSquarePawn
						mov [currentRank], dl
						jmp CaptureSMSFPU
					
			CaptureSMSFPU:		
				dec [currentRank]
				dec [currentFile]
				mov ax, 1
				call SetMoveSquarePawn
				mov [currentFile], dh
				mov [currentRank], dl

				dec [currentRank]
				inc [currentFile]
				mov ax, 1
				call SetMoveSquarePawn
				mov [currentFile], dh
				mov [currentRank], dl
				
				jmp ExitSMSOP
				
				
			DownSMSFP:
			ForwardSMSFPD:
				mov ax, 0
				cmp [currentRank], 1
				je FirstMoveSMSFPD
				
				NotFirstMoveSMSFPD:
					inc [currentRank]
					mov ax, 0
					call SetMoveSquarePawn
					mov [currentRank], dl
					jmp CaptureSMSFPD
					
				FirstMoveSMSFPD:
					FirstSquareFMSMSFPD:
						inc [currentRank]
						mov ax, 0
						call SetMoveSquarePawn
						mov [currentRank], dl	

					cmp ax, 1
					jne SecondSquareFMSMSFPD
					jmp CaptureSMSFPD

					SecondSquareFMSMSFPD:
						add [currentRank], 2
						mov ax, 0
						call SetMoveSquarePawn
						mov [currentRank], dl
						jmp CaptureSMSFPD
					
			CaptureSMSFPD:		
				inc [currentRank]
				dec [currentFile]
				mov ax, 1
				call SetMoveSquarePawn
				mov [currentFile], dh
				mov [currentRank], dl

				inc [currentRank]
				inc [currentFile]
				mov ax, 1
				call SetMoveSquarePawn
				mov [currentFile], dh
				mov [currentRank], dl
				
				jmp ExitSMSOP
	KingSMS:
		mov ax, 'K'
		cmp [bx], al
		je ContinueKingSMS
		add ax, 32
		cmp [bx], al
		je ContinueKingSMS
		jmp OtherPieceSMS
		
		ContinueKingSMS:
			call RemovePiece
			call SwitchTurn
			call SetAttackedSquares
			call SwitchTurn
			call ReturnPiece
			
			mov dh, [currentFile]
			mov dl, [currentRank]
		
			dec [currentRank]
			mov ax, 0
			call SetMoveSquareKing
			mov [currentFile], dh
			mov [currentRank], dl
		
			dec [currentRank]
			inc [currentFile]
			mov ax, 0
			call SetMoveSquareKing
			mov [currentFile], dh
			mov [currentRank], dl
		
			inc [currentFile]
			mov ax, 0
			call SetMoveSquareKing
			mov [currentFile], dh
			mov [currentRank], dl
		
			inc [currentRank]
			inc [currentFile]
			mov ax, 0
			call SetMoveSquareKing
			mov [currentFile], dh
			mov [currentRank], dl
		
			inc [currentRank]
			mov ax, 0
			call SetMoveSquareKing
			mov [currentFile], dh
			mov [currentRank], dl
		
			inc [currentRank]
			dec [currentFile]
			mov ax, 0
			call SetMoveSquareKing
			mov [currentFile], dh
			mov [currentRank], dl
			
			dec [currentFile]
			mov ax, 0
			call SetMoveSquareKing
			mov [currentFile], dh
			mov [currentRank], dl
			
			dec [currentRank]
			dec [currentFile]
			mov ax, 0
			call SetMoveSquareKing
			mov [currentFile], dh
			mov [currentRank], dl
			
			ShortCastle:
			mov ax, 1
			call SetMoveSquareKing
			
			LongCastle:
			mov ax, 2
			call SetMoveSquareKing
			jmp ExitSMSOP
	OtherPieceSMS:
		call ClearAttackedSquares
		mov [attackedSquaresIsMove], 1
		call SetAttackedSquaresOfPiece
		call CopyAttackedSquaresToMove
		call RemoveMyPiecesFromMoveSquares
	ExitSMSOP:
	pop dx
	mov [currentSquare], dl
	pop dx cx bx ax
	ret
endp SetMoveSquaresOfPiece

;IN: [currentSquare]
;OUT: [removedPiece], [removedSquare], '0' in board
proc RemovePiece
	push ax bx
	xor bx, bx
	mov bl, [currentSquare]
	add bx, offset board
	
	mov al, [currentSquare]
	mov [removedSquare], al
	
	mov al, [byte ptr bx]
	mov [removedPiece], al
	
	mov [byte ptr bx], '0'
	
	pop bx ax
	ret
endp RemovePiece

;IN: [removedPiece], [removedSquare]
;OUT: [removedPiece] back in [removedSquare]
proc ReturnPiece
	push ax bx
	
	xor bx, bx
	mov bl, [removedSquare]
	add bx, offset board
	
	mov al, [removedPiece]
	mov [byte ptr bx], al
	
	pop bx ax
	ret
endp ReturnPiece

proc RemoveMyPiecesFromMoveSquares
	push ax bx cx dx

	mov dl, [currentSquare]
	
	
	mov cx, 64
	LoopRMPFMS:
	push cx
	mov bx, offset moveSquares
	dec cx
	add bx, cx
	cmp [byte ptr bx], 1
	je IsAttackedRMPFMS
	jmp NotAttackedRMPFMS
	
	IsAttackedRMPFMS:
		push bx
		mov bx, offset board
		add bx, cx
		cmp [byte ptr bx], '0'
		pop bx
		jne IsPieceRMPFMS
		jmp NotPieceRMPFMS
		
		IsPieceRMPFMS:
			mov [currentSquare], cl
			call SetPieceColor
			mov al, [turnColor]
			cmp [currentPieceColor], al
			je OurPieceRMPFMS
			jmp OpponentPieceRMPFMS
			OurPieceRMPFMS:
				mov [byte ptr bx], 0
			OpponentPieceRMPFMS:
		NotPieceRMPFMS:
	NotAttackedRMPFMS:
	pop cx
	loop LoopRMPFMS
	
	mov [currentSquare], dl
	pop dx cx bx ax
	ret
endp RemoveMyPiecesFromMoveSquares


proc CopyAttackedToMove
	push ax bx cx
	mov ax, offset attackedSquares
	mov bx, offset moveSquares
	mov cx, 64
	call CopyText
	pop ax bx cx
	ret
endp CopyAttackedToMove

;IN: [currentRank], [currentFile]
;OUT: ax: 0 - up
;		  1 - down
proc CheckPawnGoingSide
	call SetCurrentSquare
	call SetPieceColor
	; xor bx, bx
	; mov bl, [currentSquare]
	; add bx, offset board
	; mov ax, 'P'
	; cmp [bx], al
	cmp [currentPieceColor], 0
	je BlackCPGS
	WhiteCPGS:
		cmp [boardSide], 1
		je UpExitCPGS
		jmp DownExitCPGS	
	BlackCPGS:
		cmp [boardSide], 1
		je DownExitCPGS
		jmp UpExitCPGS
	UpExitCPGS:
		mov ax, 0
		ret
	DownExitCPGS:
		mov ax, 1
		ret
endp CheckPawnGoingSide

;IN: CX - number of places to clear, BX - first place to clear
;OUT: [BX] - [CX+BX-1] cleared
proc ClearInDS
	ClearingLoop:
		push bx cx
		dec cx
		add bx, cx
		mov [byte ptr bx], 0
		pop cx bx
	loop ClearingLoop
	ret
endp ClearInDS

proc ClearBoard
	push bx cx
	mov bx, offset board
	mov cx, 64
	call ClearInDS
	pop cx bx
	ret
endp ClearBoard

;IN:X
proc CopyMoveSquaresToHelp
	push ax bx cx
	mov ax, offset moveSquares
	mov bx, offset squaresHelp
	mov cx, 64
	call CopyText
	pop cx bx ax
	ret
endp CopyMoveSquaresToHelp

;IN:X
proc CopyAttackedSquaresToHelp
	push ax bx cx
	mov ax, offset attackedSquares
	mov bx, offset squaresHelp
	mov cx, 64
	call CopyText
	pop cx bx ax
	ret
endp CopyAttackedSquaresToHelp

;IN:X
proc CopyAttackedSquaresToMove
	push ax bx cx
	mov ax, offset attackedSquares
	mov bx, offset moveSquares
	mov cx, 64
	call CopyText
	pop cx bx ax
	ret
endp CopyAttackedSquaresToMove

;IN:X
proc CopyHelpToAttackedSquares
	push ax bx cx
	mov ax, offset squaresHelp
	mov bx, offset attackedSquares
	mov cx, 64
	call CopyText
	pop cx bx ax
	ret
endp CopyHelpToAttackedSquares

;IN:X
proc CopyHelpBtoMove
	push ax bx cx
	mov ax, offset squaresHelpB
	mov bx, offset moveSquares
	mov cx, 64
	call CopyText
	pop cx bx ax
	ret
endp CopyHelpBtoMove

;IN:X
proc CopyMovetoHelpB
	push ax bx cx
	mov ax, offset moveSquares
	mov bx, offset squaresHelpB
	mov cx, 64
	call CopyText
	pop cx bx ax
	ret
endp CopyMovetoHelpB

;IN:X
proc CopyHelpToHelpB
	push ax bx cx
	mov ax, offset squaresHelp
	mov bx, offset squaresHelpB
	mov cx, 64
	call CopyText
	pop cx bx ax
	ret
endp CopyHelpToHelpB

;IN:X
proc CopyHelpToMoveSquares
	push ax bx cx
	mov ax, offset squaresHelp
	mov bx, offset moveSquares
	mov cx, 64
	call CopyText
	pop cx bx ax
	ret
endp CopyHelpToMoveSquares
;IN:X
proc CopyHelpToBoard
	push ax bx cx
	mov ax, offset boardHelp
	mov bx, offset board
	mov cx, 64
	call CopyText
	pop cx bx ax
	ret
endp CopyHelpToBoard

;IN:X
proc CopyHelpToMarkedSquares
	push ax bx cx
	mov ax, offset markedSquaresHelp
	mov bx, offset markedSquares
	mov cx, 64
	call CopyText
	pop cx bx ax
	ret
endp CopyHelpToMarkedSquares

;IN:X
proc CopyBoardToHelp
	push ax bx cx
	mov ax, offset board
	mov bx, offset boardHelp
	mov cx, 64
	call CopyText
	pop cx bx ax
	ret
endp CopyBoardToHelp
proc CopyEnPassantAndCastlesToHelp
	push ax
	mov al, [WK_castle]
	mov [WK_castleHelp], al
	mov al, [WQ_castle]
	mov [WQ_castleHelp], al
	mov al, [Bk_castle]
	mov [Bk_castleHelp], al
	mov al, [Bq_castle]
	mov [Bq_castleHelp], al
	pop ax
	ret
endp CopyEnPassantAndCastlesToHelp
proc CopyHelpToEnPassantAndCastles
	push ax
	mov al, [WK_castleHelp]
	mov [WK_castle], al
	mov al, [WQ_castleHelp]
	mov [WQ_castle], al
	mov al, [Bk_castleHelp]
	mov [Bk_castle], al
	mov al, [Bq_castleHelp]
	mov [Bq_castle], al
	pop ax
	ret
endp CopyHelpToEnPassantAndCastles
proc AndMoveSquaresToHelp
	push ax bx cx
	mov ax, offset moveSquares
	mov bx, offset squaresHelp
	mov cx, 64
	call AndMemory
	pop cx bx ax
	ret	
endp AndMoveSquaresToHelp

;IN: Old piece in [currentSquare]
;OUT: Needed green squares reset
proc ResetGreenSquares
	push ax bx cx dx
	
	call AndMoveSquaresToHelp
	
	mov al, [currentSquare]
	
	mov cx, 64
	LoopCAS:
	push cx
	dec cx
	mov bx, offset moveSquares
	add bx, cx
	cmp [byte ptr bx], 1
	jne ExitIteration
	mov bx, offset squaresHelp
	add bx, cx
	cmp [byte ptr bx], 1
	je ExitIteration
	mov [currentSquare], cl
	call SetCurrentRowCol
	call PrintCurrentPiece
	ExitIteration:
	pop cx
	loop LoopCAS

	mov [currentSquare], al
	pop dx cx bx ax
	ret
endp ResetGreenSquares

;IN: X
;OUT: Set all [attackedSquares] to 0
proc ClearAttackedSquares
	push bx cx
	mov bx, offset attackedSquares
	mov cx, 64
	call ClearInDS
	pop cx bx
	ret
endp ClearAttackedSquares

;IN: X
;OUT: Set all [markedSquares] to 0
proc ClearMarkedSquares
	push bx cx
	mov bx, offset markedSquares
	mov cx, 64
	call ClearInDS
	pop cx bx
	ret
endp ClearMarkedSquares

;IN: X
;OUT: Set all [squaresHelp] to 0
proc ClearSquaresHelp
	push bx cx
	mov bx, offset squaresHelp
	mov cx, 64
	call ClearInDS
	pop cx bx
	ret
endp ClearSquaresHelp

;IN: X
;OUT: Set all [moveSquares] to 0
proc ClearMoveSquares
	push bx cx
	mov bx, offset moveSquares
	mov cx, 64
	call ClearInDS
	
	mov [shortCastleInMoves], 0
	mov [longCastleInMoves], 0
	;mov [promotionChosen], 0 - bad in waitForReleaseNeeded
	pop cx bx
	ret
endp ClearMoveSquares

proc SwitchTurn
	cmp [turnColor], 1
	je FromWhiteST
	jmp FromBlackST
	
	FromWhiteST:
		mov [turnColor], 0
		ret
	FromBlackST:
		mov [turnColor], 1
		ret
endp SwitchTurn

proc SwitchBoardSide
	cmp [boardSide], 1
	je FromWhiteSBS
	jmp FromBlackSBS
	
	FromWhiteSBS:
		mov [boardSide], 0
		ret
	FromBlackSBS:
		mov [boardSide], 1
		ret
endp SwitchBoardSide

proc SwitchAutoFlip
	cmp [autoFlip], 1
	je TurnAfOff
	jmp TurnAfOn
	
	TurnAfOff:
		mov [autoFlip], 0
		ret
	TurnAfOn:
		mov [autoFlip], 1
		ret
endp SwitchAutoFlip

proc PlaySound

	push ax
	
    mov     al, 182         ; Prepare the speaker for the
    out     43h, al         ;  note.
    mov     ax, [sound]     ; Frequency number (in decimal)
                                ;  for middle C.
    out     42h, al         ; Output low byte.
    mov     al, ah          ; Output high byte.
    out     42h, al 
	
    in      al, 61h         ; Turn on note (get value from
                                ;  port 61h).
    or      al, 00000011b   ; Set bits 1 and 0.
    out     61h, al         ; Send new value.
	
	push ax
    mov ah, 86h ;interrupt
	int 15h
	pop ax
	
    in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
    and     al, 11111100b   ; Reset bits 1 and 0.
    out     61h, al         ; Send new value.
	pop ax
	
	
	mov ah, 86h ;interrupt
	int 15h
	
	ret
endp PlaySound

proc InitSound
	push cx dx
	mov cx, 0000h 
	mov dx, 0300h
	mov [sound], 0
	call PlaySound
	pop dx cx
	ret
endp InitSound

proc PlayChoosePieceSound


	call InitSound
	
	
	
	; mov [sound], 4000
	; mov cx, 5
	; LoopPCPS:
	; push cx
	; mov cx, 0000h 
	; mov dx, 03000h
	; add [sound], 200
	; call PlaySound
	; pop cx
	; loop LoopPCPS
	
	mov cx, 0001h 
	mov dx, 00000h
	mov [sound], 8126
	call PlaySound
	ret
endp PlayChoosePieceSound

proc FlipBoardArr
	push ax bx cx
	mov cx, 64
	LoopFBA:
		push cx
		dec cx
		xor bx, bx
		mov bl, cl
		add bx, offset board
		mov al, [byte ptr bx]
		xor bx, bx
		mov bl, 63
		sub bl, cl
		add bx, offset boardHelp
		mov [byte ptr bx], al
		pop cx
	loop LoopFBA
	
	call CopyHelpToBoard
	pop cx bx ax
	ret
endp FlipBoardArr

proc FlipMarkedSquaresArr
	push ax bx cx
	mov cx, 64
	LoopFMSA:
		push cx
		dec cx
		xor bx, bx
		mov bl, cl
		add bx, offset markedSquares
		mov al, [byte ptr bx]
		xor bx, bx
		mov bl, 63
		sub bl, cl
		add bx, offset markedSquaresHelp
		mov [byte ptr bx], al
		pop cx
	loop LoopFMSA
	
	call CopyHelpToMarkedSquares
	pop cx bx ax
	ret
endp FlipMarkedSquaresArr

proc FlipBoard
	push ax bx cx dx
	call SwitchBoardSide
	call FlipBoardArr
	call FlipMarkedSquaresArr
	mov al, 63d ;also flip the help mark squares
	sub al, [fromSquareToMark]
	mov [fromSquareToMark], al
	mov al, 63d
	sub al, [toSquareToMark]
	mov [toSquareToMark], al	
	
	call ClearBoard ;first clear and then print new
	call UpdatePiecesOnBoard
	call CopyHelpToBoard
	
	call PrintFlipButton
	call UpdatePiecesOnBoard
	
	call SetKingRed
	call ResetClicksInfo
	
	mov al, 63d
	sub al, [enPassantSquare]
	mov [enPassantSquare], al
	
	pop dx cx bx ax
	ret
endp FlipBoard
proc SetBoardSideAsColor
	push ax dx
	mov al, [turnColor]

	cmp al, [boardSide]
	je ExitSBSAC
	call FlipBoard
	ExitSBSAC:
	pop dx ax	
	ret
endp SetBoardSideAsColor

start:
	mov ax, @data
	mov ds, ax
	
	call SetStartingBoard
	
	call ClearRegs
	call GraphicsMode
	call PrintBoard
	call PrintFlipButton
	call PrintAutoFlipButton
	call UpdatePiecesOnBoard
	call InitMouse
	call WaitPieceClick

exit:
	mov ax, 4c00h
	int 21h
END start



TITLE Program #4     (program4.asm)

; Author: Stephen Sullivan
; Last Modified: 11/03/18
; OSU email address: sulliste@oregonstate.edu
; Course number/section: CS271/400
; Assignment Number: 4               Due Date: 11/04/18
; Description: This program calculates composite numbers from user input integer

INCLUDE Irvine32.inc

	LOWLMT = 1
	UPLMT = 400

.data

	inputNum	DWORD	?
	compNum		DWORD	?
	lineCt		DWORD	?

	introMsg	BYTE "		Composite Number Calculator		by: Stephen Sullivan", 0

	rules		BYTE	"Enter the number of composite numbers to output.", 0
	rules2		BYTE	"Enter numbers in the range of 1 - 400.", 0
	errorMsg	BYTE	"Error: invalid input. Try again.", 0

	space		BYTE	"     ", 0

	outroMSG	BYTE	"GoodBye!", 0

.code
main PROC

	call	intro
	call	getData
	call	showComp
	call	outro
	
	exit
main ENDP

intro PROC	;Displays program introduction and initial prompt

	mov			edx, OFFSET introMsg
	call	WriteString
	call	CrLf
	mov			edx, OFFSET rules
	call	WriteString
	call	CrLf
	ret
intro ENDP

getData PROC	;Gets user input

;Prompt user for number input
	mov			edx, OFFSET rules2
	call	WriteString
	call	CrLf
	call	ReadInt

;Takes user input to global scale and calls validation
	mov			inputNum, eax
	call	validate
	call CrLf
	ret
getData ENDP

validate PROC	;Input Validation

;Validates input in scale of 1-400
;If out of scale, calls Error
	cmp			inputNum, LOWLMT
	jl			Error
	cmp			inputNum, UPLMT
	jg			Error
	ret

Error:	;If data invalid, display error message - jump back to input
	mov			edx, OFFSET errorMsg
	call	WriteString
	call	CrLf
	jmp		getData
validate ENDP

showComp PROC	;Displays composite number for user input
;Move user input to loop counter
;Initialize eax to 4 and ebx to 2(4 is lowest composite num and 2 is lowest divider)
	mov			ecx, inputNum
	mov			eax, 4
	mov			compNum, eax
	mov			ebx, 2

outerLoop: ; Initialize outer loop counter
	call	isComp

;Finds Composite number, prints, and increments number
	mov			eax, compNum
	call	WriteDec
	inc			compNum

;Count number of integers each line
	inc			lineCt
	mov			eax, lineCt
	mov			ebx, 10
	cdq
	div			ebx

; Checks if 10 in line
;If yes, add new line, if no, jump and add spaces
	cmp			edx, 0
	je			newLine
	jne			addSp

newLine:
	call	CrLf
	jmp			resumeLp

addSp:
	mov			edx, OFFSET space
	call	WriteString

resumeLp:
	mov			ebx, 2
	mov			eax, compNum
	loop	outerLoop
	ret
showComp ENDP

;Finds nect composite number and returns to showComp
isComp PROC

innerLoop:
;checks if number can be composite
	cmp			ebx, eax

;If not, jump to increment restart
	je			noComposites

;Checks if number is composite through division and comparison with modulus
	cdq
	div			ebx
	cmp			edx, 0
	je			yesComp
	jne			notComp

;Finish inner loop if composite
yesComp:
	ret

;If not composite witih divisor, increment div, reset num, and restart
notComp:
	mov			eax, compNum
	inc			ebx
	jmp			innerLoop

;If not composite at all, increment composite num, reset divisor, and restart
noComposites:
	inc			compNum
	mov			eax, compNum
	mov			ebx, 2
	jmp			innerLoop

isComp ENDP

outro PROC
	mov			edx, OFFSET outroMsg
	call	CrLf
	call	CrLf
	call	WriteString
	call	CrLf
	ret
outro ENDP
END main

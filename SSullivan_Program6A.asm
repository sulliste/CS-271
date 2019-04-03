TITLE Program #5A     (program5A.asm)

; Author: Stephen Sullivan
; Last Modified: 12/1/18
; OSU email address: sulliste@oregonstate.edu
; Course number/section: CS271/400
; Assignment Number: 6A               Due Date: 12/2/18
; Description: This program will implement and test ReadVal and WriteVal
;				Implements macros getString and displayString
;				Gets 10 integers from user, stores them in an array, and displays
;				The integers, their sum ,and their average

INCLUDE Irvine32.inc

	NUM = 10

.data

	sum				DWORD	?
	avg				DWORD	?
	arrayIn			DWORD	10	DUP(0)
	
	buffer			BYTE	255 DUP(0)
	tempStr			BYTE	32 DUP(?);

	intro			BYTE	"TITLE: Assignment 5A by Stephen Sullivan",0
	intro1			BYTE	"Please provide 10 unsigned decimal integers.",0
	intro2			BYTE	"Each number needs to be small enough to fit inside a 32 bit register.",0
	intro3			BYTE	"After you have finished inputting the raw numbers, I will display a list",0
	intro4			BYTE	"of the integers, their sum, and their average value.",0
	inPrompt		BYTE	"Enter an unsigned integer: ", 0
	errorMsg		BYTE	"Invalid input, please try again: ",0
	valMsg			BYTE	"Your input: ",0
	sumMsg			BYTE	"The sum is: ",0
	avgMsg			BYTE	"The average is: ",0

	outroMSG		BYTE	"Goodbye.", 0

;Moves user input into memory location
getString	MACRO address, length	
	push	edx
	push	ecx
	mov  	edx, address
	mov  	ecx, length
	call 	ReadString
	pop			ecx
	pop			edx
ENDM

;Displays string stored in memory
displayString	MACRO	uString
	push	edx
	mov			edx, OFFSET uString
	call	WriteString
	pop			edx
ENDM

.code

main PROC

;Print intro
	displayString	intro
	call	CrLf
	displayString	intro1
	call	CrLf
	displayString	intro2
	call	CrLf
	displayString	intro3
	call	CrLf
	displayString	intro4
	call	CrLf
	call	CrLf

;Set loop control
	mov			ecx, NUM
	mov			edi, OFFSET arrayIn

userPrompt:
	displayString	inPrompt

;Push to stack
	push	OFFSET buffer
	push	SIZEOF buffer
	call	rdValues

	mov			eax, DWORD PTR buffer
	mov			[edi], eax
	add			edi, 4

	loop	userPrompt		;loop until 10 values

	mov			ecx, NUM
	mov			esi, OFFSET arrayIn
	mov			ebx, 0

	displayString	valMsg
	call				CrLf

;Calculates sum and prints to console
printSum:
	mov			eax, [esi]
	add			ebx, eax

	push	eax
	push	OFFSET tempStr
	call	writeValues
	add		esi, 4
	loop	printSum

	mov				eax, ebx
	mov				sum, eax
	displayString	sumMsg

	push	sum
	push	OFFSET tempStr
	call	writeValues
	call	CrLf

;Clear edx and move 10 in
	mov			ebx, NUM
	mov			edx, 0

	div			ebx

;Determines if average needs to be rounded  
	mov			ecx, eax
	mov			eax, edx
	mov			edx, 2
	mul			edx
	cmp			eax, ebx
	mov			eax, ecx
	mov			avg, eax
	jb			notRound
	inc			eax
	mov			avg, eax

notRound:
	displayString	avgMsg

	push	avg
	push	OFFSET tempStr
	call	writeValues
	call	CrLf

	displayString	outroMsg
	call	CrLf

	exit
main	ENDP

;**********************************************************
;rdValues uses getString macro to get string from user
;converts digit string to numbers and validates input
;**********************************************************
rdValues PROC
	push	ebp
	mov			ebp, esp
	pushad

starting:
	mov			edx, [ebp+12]
	mov			ecx, [ebp+8]

	getString	edx, ecx

	mov			esi, edx
	mov			eax, 0
	mov			ecx, 0
	mov			ebx, 10

loadString:
	lodsb
	cmp			ax, 0
	je			done

;Checks range if character is an int in ASCII
	cmp			ax, 48
	jb			printError
	cmp			ax, 57
	ja			printError

	sub			ax, 48
	xchg	eax, ecx
	mul			ebx
	jc			printError
	jnc			noError

printError:
	displayString	errorMsg
	jmp					starting

noError:
	add			eax, ecx
	xchg	eax, ecx
	jmp			loadString

done:
	xchg	ecx, eax
	mov			DWORD PTR buffer, eax
	popad
	pop		ebp
	ret		8
rdValues ENDP

;*************************************************************
;Converts number value into digit string, calls dsiplayString
;*************************************************************
writeValues PROC
	push	ebp
	mov			ebp, esp
	pushad

	mov			eax, [ebp+12]
	mov			edi, [ebp+8]
	mov			ebx, 10
	push	0

convertStr:
	mov			edx, 0
	div			ebx
	add			edx, 48
	push	edx

	cmp			eax, 0
	jne			convertStr

;Pop numbers off stack
popNum:
	pop			[edi]
	mov			eax, [edi]
	inc			edi
	cmp			eax, 0
	jne			popNum

;Write string using macro
	mov			edx, [ebp+8]
	displayString	OFFSET tempStr
	call			CRLF

	popad
	pop		ebp
	ret		8

writeValues	ENDP

END main

TITLE Program #5     (program5.asm)

; Author: Stephen Sullivan
; Last Modified: 11/17/18
; OSU email address: sulliste@oregonstate.edu
; Course number/section: CS271/400
; Assignment Number: 5               Due Date: 11/18/18
; Description: This program displays a random array of integers based on user input. 
;			It then sorts and displays the sorted list along with the median of the list.

INCLUDE Irvine32.inc

	MIN = 10
	MAX = 200

	LOWLMT = 100
	HILMT = 999

.data

	inputRg		DWORD	?
	arrayIn		DWORD	MAX			DUP(?)
	arrayCt		DWORD	0

	intro1		BYTE	"Assignment 4: Random Number Generator and Sorter by: Stephen Sullivan", 0
	intro2		BYTE	"This program will generate random numbers from 100 to 999.", 0
	intro3		BYTE	"It will display the unsorted list, then sorts the list, ", 0
	intro4		BYTE	"calculates and displays the median, and finally displays the list in descending order.", 0
	inPrompt	BYTE	"How many integers should be generated? Range: 10 - 200", 0
	errorMsg	BYTE	"Error: invalid input. Try again.", 0

	list1		BYTE	"Unsorted List: ", 0
	list2		BYTE	"Sorted List: ", 0
	list3		BYTE	"Median: ", 0
	space		BYTE	"     ", 0


.code

;****************************************************************
;Initializes all functions in the program
;Returns the printed arrays from each procedure
;****************************************************************
main PROC

;Displays introduction
	push	OFFSET	intro1
	push	OFFSET	intro2
	push	OFFSET	intro3
	push	OFFSET	intro4
	call	intro

;Gets user data
	push	OFFSET	inputRg		;Pass by ref
	call	getData

;Fills array with random numbers
	push	OFFSET	arrayIn		;Pass by ref
	push	inputRg				;Pass by val
	call	arrayFill

;Displays the array
	push	OFFSET	arrayIn		
	push	inputRg				;Pass by val
	push	OFFSET	list1		;Pass by ref
	call	dispList

;Sorts array
	push	OFFSET	arrayIn		;Pass by ref
	push	inputRg				;Pass by val
	call	sort

;Finds Median
	push	OFFSET	arrayIn		
	push	inputRg				;Pass by val
	push	OFFSET	list3		;Pass by ref
	call	dispMedian

;Displays sorted array
	push	OFFSET	arrayIn		
	push	inputRg				;Pass by val
	push	OFFSET	list2		;Pass by ref
	call	dispList
	
;	call	outro
	
	exit
main ENDP

;***********************************************
;Introduction display
;***********************************************
intro PROC	;Displays program introduction 

	pushad
	mov			ebp, esp

	mov			edx, [ebp+48]
	call	WriteString
	call	CrLf

	mov			edx, [ebp+44]
	call	WriteString
	call	CrLf

	mov			edx, [ebp+40]
	call	WriteString
	call	CrLf

	mov			edx, [ebp+36]
	call	WriteString
	call	CrLf
	call	CrLf

	popad
	ret			16
intro ENDP

;***********************************************
;Gets user data for program to function
;Provides input validation functions
;***********************************************
getData PROC	;Gets user input

;Sets up stack
	push	ebp
	mov			ebp, esp
	mov			ebx, [esp+8]

;Initial prompt
prompt:
	mov			edx, OFFSET inPrompt
	call	WriteString
	call	ReadInt
	cmp			eax, MIN
	jl			invalidIn
	cmp			eax, MAX
	jg			invalidIn
	jmp			validIn

;Error loop
invalidIn:
	mov			edx, OFFSET errorMsg
	call	WriteString
	call	CrLf
	jmp			Prompt

;Accept valid input
validIn:
	mov			[ebx], eax
	pop			ebp
	ret			4
getData ENDP

;**********************************************
;Fills array with randomly generated integers
;Returns array of random integers
;**********************************************
arrayFill PROC	;Fills array with random integers
;Initialize stack and array
	push	ebp
	mov			ebp, esp
	mov			edi, [ebp+12]	;@array in edi
	mov			ecx, [ebp+8]	;value of count in ecx
	call	Randomize		;Random number generation

;While still spots in array, generate number
notDone:
	mov			eax, HILMT			;Generate random number
	sub			eax, LOWLMT
	inc			eax
	call	RandomRange
	add			eax, LOWLMT

;Set number, increment, and repeat
	mov			[edi], eax
	add			edi, 4
	loop	notDone

;Restore the stack
	pop			ebp
	ret			8

arrayFill ENDP

;***********************************************
;Obtains and sorts random array
;returns sorted list
;***********************************************
sort PROC
;Initialize stack
	pushad
	mov			ebp, esp
	mov			ecx, [ebp+36]
	mov			edi, [ebp+40]
	dec 	ecx 			;request-1
	mov			ebx, 0

;Outer loop initialization
outLoop:
	mov			eax, ebx		;i=k
	mov			edx, eax
	inc 	edx 			;j=k+1
	push 	ecx
	mov 	ecx, [ebp+36]	;request

;inner loop initialization
inLoop:
	mov			esi, [edi+edx*4]
	cmp			esi, [edi+eax*4]
	jle			pass
	mov			eax, edx

;Skip if not greater
pass:
	inc 	edx
	loop 	inLoop

;If greater we swap
	lea 	esi, [edi+ebx*4]
	push 	esi
	lea 	esi, [edi+eax*4]
	push 	esi
	call 	swapInd
	pop 	ecx
	inc 	ebx
	loop 	outLoop
	popad
	ret 	8

sort ENDP

;****************************************************************
; Obtains array indexes and swaps them
; Returns swapped indexes
;****************************************************************
swapInd PROC

;Swap array values
	pushad
	mov 		ebp, esp
	mov 		eax, [ebp+40] 		;array[k] (low)
	mov 		ecx, [eax]
	mov 		ebx, [ebp+36] 		;array[i] (high)
	mov			edx, [ebx]
	mov			[eax], edx
	mov 		[ebx], ecx
	popad
	ret 	8

swapInd ENDP

;****************************************************************
; Finds and displays median of the array
; Returns median number of the array
;****************************************************************
dispMedian PROC
;Initilize stack
	pushad
    mov			ebp, esp
    mov			edi, [ebp+44]

;Print title
    mov			edx, [ebp+36]
    call    WriteString

;Find the median
    mov			eax, [ebp+40]
    cdq
    mov			ebx, 2
    div			ebx
    shl			eax, 2
    add			edi, eax
    cmp			edx, 0
    je			evenNum

;Odd array = display middle     
    mov			eax, [edi]
    call    writeDec
    call    CrLf
    call    CrLf
    jmp			complete

;Even array = add the two middle integers and divide by 2
evenNum:
    mov			eax, [edi]
    add			eax, [edi-4]
    cdq     
    mov			ebx, 2
    div			ebx
    call    WriteDec
    call    CrLf
    call    CrLf

;Clear the stack
complete:
    popad
    ret			12

dispMedian ENDP

;****************************************************************
;Prints out the listed array
;Returns the printed array
;****************************************************************
dispList PROC
;Initialize the stack and variables
	push		ebp
	mov			ebp, esp
	mov			esi, [ebp+16]	;@array
	mov			ecx, [ebp+12]	;ecx is loop control
	mov			edx, [ebp+8]	;print title
	mov			ebx, 0
	call	WriteString
	call	CrLf

;Count for rows, continue looping
continue:
	inc			ebx
	mov			eax, [esi]
	call	WriteDec
	add			esi, 4
	cmp			ebx, 10
	jne			addSpace
	call	CrLf
	mov			ebx, 0
	jmp			endCont

;Insert spaces
addSpace:
	mov			edx, OFFSET space
	call	WriteString

;Clear stack and end the loop
endCont:
	loop		continue
	call	CrLf
	pop			ebp
	ret			12

dispList ENDP

;outro PROC
;	mov			edx, OFFSET outroMsg
;	call	CrLf
;	call	CrLf
;	call	WriteString
;	call	CrLf
;	ret
;outro ENDP

END main

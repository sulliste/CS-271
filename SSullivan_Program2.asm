TITLE Program #2     (program2.asm)

; Author: Stephen Sullivan
; Last Modified: 10/13/18
; OSU email address: sulliste@oregonstate.edu
; Course number/section: CS271/400
; Assignment Number: 2               Due Date: 10/14/18
; Description: This program takes user input integer between 1 & 46.
;				Generates and displays the Fibonacci sequence of the input.

INCLUDE Irvine32.inc

.data

high_limit	DWORD	46	;	top limit of user input
low_limit	DWORD	1	;	low limit of user input
user_input	DWORD	?	;	user input
fibb1		DWORD	?	
fibb2		DWORD	?
fibb3		DWORD	?

intro		BYTE "Fibonacci Sequence Generator		by: Stephen Sullivan", 0
rules		BYTE "Enter your name and press enter", 0
userName	BYTE 33 DUP(0)
greet		BYTE "Welcome: ",0
prompt		BYTE "Please enter a number between 1 and 46 ", 0

too_low		BYTE " Your input is too low, please try again ", 0
too_high	BYTE " Your input is too high, please try again ", 0
spaces		BYTE "     ", 0
prompt_loop BYTE " Would you like to enter another number? Choose 1 for yes or any key to exit. ", 0
answer_loop	DWORD	?
good_bye	BYTE "Goodbye, ", 0

.code
main PROC
Introduction:
; Display introduction intro
	mov		edx,OFFSET intro
	call WriteString 
	call CrLF

; Display instructions 
	mov		edx, OFFSET rules
	call WriteString

; Get user input for name
	mov		edx, OFFSET userName
	mov		ecx, 32
	call ReadString
	call CrLf

; Greet user and print name
	mov		edx, OFFSET greet
	call WriteString
	mov		edx, OFFSET userName
	call WriteString
	call CrLF

getUserData:
; Prompt user for input
	mov		edx, OFFSET prompt
	call WriteString
	call readInt
	mov		user_input, eax
	call CrLF
	jmp fibOutput

tooLow:
; User input too low
	mov		edx, offset too_low
	call writeString
	call crlf
	call crlf
	jmp		getUserData

tooHigh:
; User input too high
	mov	edx, offset too_high
	call writeString
	call crlf
	call crlf
	jmp		getUserData

fibOutPut:
; Displays Fibonacci number output
	mov		ecx, user_input			;set loopcounter ecx to integer chosen by user
	mov		fibb1, 1				;initialize terms
	mov		fibb2, 1		
	mov		fibb3, 0
	mov		ebx, 0

clear:
; Clears new line after 5 numbers
	call CrLf
	mov		ebx,0

fibLoop:
; Fibonacci loop
	inc		ebx						;increment ebx 
	cmp		ebx, 6					;If ebx is 6, jump to clear which  resets ebx, and moves line down 1
	je		clear					;makes sure only 5 numbers per line.
					
	mov		eax, fibb3				;move latest term into eax
	mov		fibb1, eax				;save this term in variable fibb1
	add		eax, fibb2				;add the 2nd previous term to the previous term
	call	writeInt				;display fibonacci number
					
	mov		edx,offset spaces		;allows 5 spaces in between each number
	call	writeString
	mov		fibb3,eax				;store this as latest term in fibb3
	mov		eax, fibb1				;move the old fibb1 into eax
	mov		fibb2, eax				;save this old fibb1 as fibb2
					

	;POST-TEST to check if number was valid. After running 1 loop of fibonacci
	mov		eax, user_input			
	cmp		low_limit, eax			;check if input is less than 1 
	jg		tooLow					;if less than 1, go to tooLow
					
	mov		eax, user_input
	cmp		high_limit, eax			;check if input is greater than 46
	jl		tooHigh					;if greater than 46, go to tooHigh
					
	Loop	fibLoop			

outro:
; Display goodbye
	call	CrLf
	call	CrLf
	mov		edx,offset prompt_loop	;prompt for entering in a new number	
	call	writeString				
	call	readInt
	mov		answer_loop,eax			;store loop answer 1 for yes, 0 for no
	cmp		eax, 1
	je		getUserData				;if 1 is entered, go back to get user data

	call	CrLf
	call	CrLf
	mov		edx,offset good_bye		;farewell
	call	writeString
	mov		edx,offset userName		;with user name
	call	writeString
	call	CrLf
	call	CrLf

exit	
main ENDP

END main

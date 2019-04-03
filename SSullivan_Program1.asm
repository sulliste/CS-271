TITLE Program #1     (program1.asm)

; Author: Stephen Sullivan
; Last Modified: 10/6/18
; OSU email address: sulliste@oregonstate.edu
; Course number/section: CS271/400
; Assignment Number: 1               Due Date: 10/7/18
; Description: This program takes 2 integers from the user and calculates and displays
;				the sum, difference, product, quotient, and remainder.

INCLUDE Irvine32.inc

.data

a DWORD		?	; first user integer
b DWORD		?	; second user integer

sum	DWORD	?	; sum of user input
diff DWORD	?	; difference of user input
prod DWORD	?	; product of user input
quo DWORD	?	; quotient of user input
rem	DWORD	?	; remainder of quotient

intro	BYTE "Elementary Arithmetic		by: Stephen Sullivan", 0

rules1	BYTE "Enter 2 numbers, and I'll show you the sum, difference,", 0
rules2	BYTE "product, quotient, and remainder", 0
prompt1	BYTE "First number: ", 0
prompt2 BYTE "Second number: ", 0

calcSum BYTE " + ", 0
calcDif BYTE " - ", 0
calcPrd BYTE " x ", 0
calcQuo BYTE " / ", 0
calcRem	BYTE " remainder ", 0
calcEq	BYTE " = ", 0

outro	BYTE "Impressed?	Bye!", 0

.code
main PROC
; Display introduction intro
	mov		edx,OFFSET intro
	call WriteString 
	call CrLF

; Display instructions line 1
	mov		edx, OFFSET rules1
	call WriteString
	call CrLF
; Display instructions line 2
	mov		edx, OFFSET rules2
	call WriteString
	call CrLF

; Get user input for integer a
	mov		edx, OFFSET prompt1
	call WriteString
	call ReadInt
	mov		a, eax
; Get user input for integer b
	mov		edx, OFFSET prompt2
	call WriteString
	call ReadInt
	mov		b, eax
	call CrLF

; Find sum
	mov		eax, a
	add		eax, b
	mov		sum, eax
; Display sum
	mov		eax, a
	call WriteDec
	mov		edx, OFFSET calcSum
	call WriteString
	mov		eax, b
	call WriteDec
	mov		edx, OFFSET calcEq
	call WriteString
	mov		eax, sum
	call WriteDec
	Call CrLF

; Find difference
	mov		eax, a
	sub		eax, b
	mov		diff, eax
; Display difference
	mov		eax, a
	call WriteDec
	mov		edx, OFFSET calcDif
	call WriteString
	mov		eax, b
	call WriteDec
	mov		edx, OFFSET calcEq
	call WriteString
	mov		eax, diff
	call WriteDec
	Call CrLF

; Find product
	mov		eax, a
	mov		ebx, b
	mul		ebx
	mov		prod, eax
; Display product
	mov		eax, a
	call WriteDec
	mov		edx, OFFSET calcPrd
	call WriteString
	mov		eax, b
	call WriteDec
	mov		edx, OFFSET calcEq
	call WriteString
	mov		eax, prod
	call WriteDec
	Call CrLF

; Find quotient
	mov		eax, a
	mov		ebx, b
	sub		edx, edx
	div		ebx
	mov		quo, eax
	mov		rem, edx
; Display quotient and remainder
	mov		eax, a
	call WriteDec
	mov		edx, OFFSET calcQuo
	call WriteString
	mov		eax, b
	call WriteDec
	mov		edx, OFFSET calcEq
	call WriteString
	mov		eax, quo
	call WriteDec
	mov		edx, OFFSET calcRem
	call WriteString
	mov		eax, rem
	call WriteDec
	Call CrLF

; Display goodbye
	mov		edx, OFFSET outro
	call WriteString
	call CrLF

exit	
main ENDP

END main

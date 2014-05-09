TITLE Prime Calculator			(primecalculator.asm)

; Program Description: This program calculates prime numbers, and was created
;	for the sake of practicing the following objectives in MASM:
;		1. Procedures
;		2. Loops
;		3. Nested Loops
;		4. Data validation
;	The user enters the number of primes they wish to calculate, and the porgram
;	lists the first n primes, with twin primes indicated with an asterisk on the second twin
; Author: Sam Snyder
; Date Created: 5/7/2014
; Last Modification Date:
; Example Output
COMMENT !
Prime Calculator Programmed by Sam Snyder 
 
Enter the number of prime numbers you would like to see. 
I’ll accept orders for up to 300 primes. 
 
Enter the number of primes to display [1 - 300]: 301 
Out of range. Try again. 
Enter the number of primes to display [1 - 300]: 0 
Out of range. Try again. 
Enter the number of primes to display [1 - 300]: 31 
 
2 3 5* 7* 11 13* 17 
19* 23 29 31* 37 41 43* 
47 53 59 61* 67 71 73* 
79 83 89 97 101 103* 107 
109* 113 127 
 
Results certified by Sam Snyder. Goodbye.
!
INCLUDE Irvine32.inc

;Constants
UPPER_LIMIT = 300;Upper limit as constant
PRIMES_PER_LINE = 10

.data
;Title message
titleMessage BYTE "Prime Calculator Programmed by Sam Snyder",0

;Instructions
instructionMessage1 BYTE "Enter the number of prime numbers you would like to see.",0
instructionMessage2 BYTE "I will accept orders for up to ", 0
instructionMessage3 BYTE  " primes.", 0

;Get input message
getInputMessage1 BYTE "Enter the number of primes to display [1 - ",0 
getInputMessage2 BYTE "]: ", 0

;invalid data message
invalidInputMessage BYTE "Out of range. Try again.", 0

;for displaying primes
primesPerLine DWORD PRIMES_PER_LINE
starChar BYTE '*',0
threeSpaces BYTE "   ",0

.code
main PROC

	call introduction
	call getUserData
	call showPrimes
	call farewell

	exit		; exit to operating system
main ENDP

;----------------------------------------------------------------------
introduction PROC USES eax edx 
;Description: States Title and Author. Instructs user to enter number
;	from 1 to UPPER_LIMIT
; Receives: nothing
; Returns: nothing
;----------------------------------------------------------------------
	
	;Prime Calculator Programmed by Sam Snyder
	mov edx, OFFSET titleMessage
	call WriteString 
	call Crlf;
	call Crlf;

	;Enter the number of prime numbers you would like to see. 
	mov edx, OFFSET instructionMessage1 
	call WriteString
	call Crlf

	;I’ll accept orders for up to 300 primes. 
	mov edx, OFFSET instructionMessage2
	call WriteString
	mov eax, UPPER_LIMIT
	call WriteDec
	mov edx, OFFSET instructionMessage3
	call WriteString
	call Crlf
	call Crlf

	ret
introduction ENDP

;----------------------------------------------------------------------
getUserData PROC USES eax edx
; Description: Prompts user to enter how many primes they would like to
;	calculate, and checks to see if in range.
; Receieves: nothing
; Returns: ebx = number of primes
;----------------------------------------------------------------------
	; Enter the number of primes to display [1 - 300]: 
	mov edx, OFFSET getInputMessage1
	call WriteString
	mov eax, UPPER_LIMIT
	call WriteDec
	mov edx, OFFSET getInputMessage2
	call WriteString
	call ReadInt
	mov ebx, eax
	call validateInput

	ret
getUserData ENDP

;----------------------------------------------------------------------
validateInput PROC USES edx
;Description: Checks to see if input number is between 1 and UPPER_LIMIT
; if not, it informs user and calls getUserData 
;Receives: ebx = number of primes
;Returns: ebx = post-validation number of primes
;----------------------------------------------------------------------
	call dumpregs

	jl invalidData; 
	
	cmp ebx, UPPER_LIMIT
	jg invalidData;

	jmp validData

	invalidData:
		;Out of range. Try again. 
		mov edx, OFFSET invalidInputMessage 
		call WriteString
		call Crlf
		call getUserData	
	validData:

	ret
validateInput ENDP

;----------------------------------------------------------------------
showPrimes PROC USES eax esi edi
;Receives: ebx = numnber of primes to show
;Returns: None
;Preconditions: number of primes is a positive number between 1 and 
; UPPER_LIMIT
;----------------------------------------------------------------------
	mov ecx, ebx
	mov esi, 0; esi will be used as counter for printed primes
	mov edi, 1; edi will be used as counter for candidate numbers
	push 1; first prime, stack used for finding first twin prime

	CounterLoop: ;loop, up to user numner
		call isPrime
		cmp eax, 0
		je InputNotPrime

		InputIsPrime:
			mov eax, edi
			call WriteInt; Print prime to screen

			;Is it a twin prime?
			pop eax; pop previous prime
			push edi; push current prime
			sub eax, 2
			cmp eax, edi
			jne NotTwin
			
			IsTwin:
				mov edx, OFFSET starChar
				call WriteString; '*'

			NotTwin:
				;don't need to print '*'

				;Do we need to create a new line?
				mov eax, edi
				div primesPerLine
				cmp edx, 0
				jne NoNewLine
			
				inc esi; increment print counter before priting

			NewLine:
				call Crlf; end of line after 10 primes

			NoNewLine:
				;print spaces between primes
				mov edx, OFFSET threeSpaces
				call WriteString; 3 spaces
			InputNotPrime:
				;skip printing candidate number

				inc esi;increment candidate prime
				call DumpRegs
		loop CounterLoop
			


	ret
showPrimes ENDP

;----------------------------------------------------------------------
isPrime PROC
;----------------------------------------------------------------------
	;loop n/i, initial i=n/2
	
	;if remainder is 0, not prime
	
	;end loop
	;survived loop, number is prime
	ret
isPrime ENDP
;----------------------------------------------------------------------
farewell PROC
;----------------------------------------------------------------------
	call WriteString; Results certified by Sam Snyder. Goodbye.
	ret
farewell ENDP



END main
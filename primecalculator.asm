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
; Last Modification Date: 5/11/13
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
UPPER_LIMIT EQU 300;Upper limit as constant
PRIMES_PER_LINE EQU 10

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
currentNumber DWORD 0
prevPrime DWORD 1
printedPrimes DWORD 0
primesPerLine DWORD 10
starChar BYTE '*',0
threeSpaces BYTE "   ",0

;Farewell
farewellMessage BYTE "Results certified by Sam Snyder. Goodbye.",0
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
	cmp ebx, 1
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
showPrimes PROC USES eax ebx edx 
;Receives: ebx = numnber of primes to show
;Returns: None
;Preconditions: number of primes is a positive number between 1 and 
; UPPER_LIMIT
;----------------------------------------------------------------------
	mov ecx, ebx
	CounterLoop: ;loop, up to user number
		NextNumber:

		inc currentNumber
		mov eax, currentNumber
		call isPrime
		cmp eax, 0
		jne InputIsPrime

		InputNotPrime:
				jmp NextNumber

		InputIsPrime:
			mov eax, currentNumber
			call WriteDec; Print prime to screen
			inc printedPrimes

			;Is it a twin prime?
			mov eax, prevPrime
			mov ebx, currentNumber 
			sub ebx, eax
			mov eax, currentNumber
			mov prevPrime, eax
			cmp ebx, 2
			jne NotTwin
			
			IsTwin:
				mov edx, OFFSET starChar
				call WriteString; '*'

			NotTwin:
				;don't need to print '*'

				;Do we need to create a new line?
				mov eax, printedPrimes
				mov edx, 0
				div primesPerLine
				cmp dx, 0
					je NewLine

			;print spaces between primes
				mov edx, OFFSET threeSpaces
				call WriteString; 3 spaces
				jmp EndOfLoop

			NewLine:
				call Crlf; end of line after 10 primes
			
			EndOfLoop:						

		loop CounterLoop
		ret
showPrimes ENDP

;----------------------------------------------------------------------
isPrime PROC USES ebx ecx edx
;Receives EAX=number to investigate if prime
;Returns EAX=0 if not prime
;----------------------------------------------------------------------
	
	mov ebx, eax ;make a copy of target number
	
	;1 2 3are prime
	cmp ebx, 1 
		je TruePrime
	cmp ebx, 2
		je TruePrime
	cmp ebx, 3
		je TruePrime

	mov ecx, 2
	mov edx, 0
	div ecx; initialize loop to n/2
	mov ecx, eax;



	IsPrimeLoop:
		mov eax, ebx ; mov target into eax for division
		cmp ecx, 1
			je TruePrime; if we made it to ecx=1, not prime
		mov edx, 0
		div ecx;
		cmp edx, 0;if remainder is 0, not prime
			je NotPrime
	loop IsPrimeLoop
		jmp TruePrime;survived loop, number is prime

	NotPrime:
		mov eax, 0; return value of 0 for not prime
	TruePrime:
		;nothing to do, eax is not 0
	ret
isPrime ENDP
;----------------------------------------------------------------------
farewell PROC USES edx
;Receives: nothing
;Returns: nothing
;----------------------------------------------------------------------
	mov edx, OFFSET farewellMessage
	call WriteString; Results certified by Sam Snyder. Goodbye.
	call Crlf
	ret
farewell ENDP



END main
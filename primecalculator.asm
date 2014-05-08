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

UPPER_LIMIT = 300;Upper limit as constant

.data
;Title message
title BYTE "Prime Calculator Programmed by Sam Snyder",0

;Instructions
instructionMessage1 BYTE "Enter the number of prime numbers you would like to see.",0
instructionMessage2 BYTE "I’ll accept orders for up to ", 0
instructionMessage3 BYTE  " primes.", 0

;Get input message
getInputMessage1 BYTE "Enter the number of primes to display [1 - UPPER_LIMIT]: ", 0

.code
main PROC

	call introduction
	call getUserData
	call showPrimes
	call farewell

	exit		; exit to operating system
main ENDP

;----------------------------------------------------------------------
introduction PROC
;----------------------------------------------------------------------
	call WriteString;Prime Calculator Programmed by Sam Snyder 
	call Crlf;
	call Crlf;
	call WriteString;Enter the number of prime numbers you would like to see. 
	call Crlf
	call WriteString;I’ll accept orders for up to 300 primes. 
	call Crlf
	call Crlf
	ret
introduction ENDP

;----------------------------------------------------------------------
getUserData PROC
;----------------------------------------------------------------------
	call WriteString; Enter the number of primes to display [1 - 300]: 
	call ReadInt
	
	call validateInput

	ret
getUserData ENDP

;----------------------------------------------------------------------
validateInput PROC
;----------------------------------------------------------------------
	;Out of range
	call WriteString; Out of range. Try again. 
	ret
validateInput ENDP

;----------------------------------------------------------------------
showPrimes PROC
;----------------------------------------------------------------------
;outer loop, up to user numner

;inner loop, to print 10 primes per line
call isPrime
call WriteInt; Print prime to screen
call WriteString; '*'
call WriteString; 3 spaces
call Crlf; end of line after 10 spaces
;inner loop

;outer loop

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
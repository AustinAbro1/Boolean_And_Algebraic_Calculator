; main.asm - assignment 5 CIS 310

; Austin Abro

; 03/22/2024

; 03/23/2024


;//
;// The following assembly program implements the following procedures :
;// 1-AND_op: Prompt the user for two hexadecimal integers.AND them
;//   together and display the result in hexadecimal.
;//
;//
;//Assignmnet:
;//
;// Extend the program to implement the following operators (per the menu given already):
;// 2- OR_op: Prompt the user for two hexadecimal integers.OR them
;//
;//    together and display the result in hexadecimal.
;// 3- NOT_op: Prompt the user for a hexadecimal integer.NOT the
;//
;//    integer and display the result in hexadecimal.
;// 4- XOR_op: Prompt the user for two hexadecimal integers.Exclusive - OR
;//    them together and display the result in hexadecimal.


include Irvine32.inc


.data
	msgMenu BYTE "---- Boolean Calculator ----------", 0dh, 0ah
	BYTE 0dh, 0ah
	BYTE "1. x AND y", 0dh, 0ah
	BYTE "2. x OR y", 0dh, 0ah
	BYTE "3. NOT x", 0dh, 0ah
	BYTE "4. NOT y", 0dh, 0ah
	BYTE "5. x XOR y", 0dh, 0ah
	BYTE "6. x XOR y XOR x", 0dh, 0ah
	BYTE "7. x XOR y XOR y", 0dh, 0ah
	BYTE "8. x + y", 0dh, 0ah
	BYTE "9. x - y", 0dh, 0ah

	BYTE "A. Exit program", 0dh, 0ah, 0dh, 0ah
	BYTE "Enter integer> ", 0

	msgAND BYTE "Boolean x AND y:", 0
	msgOR  BYTE "Boolean x OR y:", 0
	msgNOT BYTE "Boolean NOT:", 0
	msgXOR BYTE "Boolean x XOR y:", 0
	msgXOR2 BYTE "Boolean x xor y xor x",0
	msgXOR3 BYTE "Boolean x xor y xor y",0
	msgADD BYTE "Adding Operands:",0
	msgSUB BYTE "Subtracting Operands:",0

	msgOperand1 BYTE "Input the first 32-bit hexadecimal operand:  ", 0
	msgOperand2 BYTE "Input the second 32-bit hexadecimal operand: ", 0
	msgResult   BYTE "The 32-bit hexadecimal result is:            ", 0

	caseTable BYTE '1'	;// lookup value
	DWORD AND_op		;// address of procedure
	EntrySize = ($ - caseTable)
	BYTE '2'
	DWORD OR_op
	BYTE '3'
	DWORD NOT_op
	BYTE '4'
	DWORD NOT_op
	BYTE '5'
	DWORD XOR_op
	BYTE '6'
	DWORD XOR2_op
	BYTE '7'
	DWORD XOR3_op
	BYTE '8'
	DWORD ADD_op
	BYTE '9'
	DWORD SUB_op
	BYTE 'A'
	DWORD ExitProgram
	NumberOfEntries = ($ - caseTable) / EntrySize

.code
main PROC
	call Clrscr

Menu:
	mov	edx, OFFSET msgMenu	;// menu choices
	call WriteString

L1: call ReadChar
	cmp  al, 'A'	;// is selection valid(1 - 5) ?
	ja   L1			;// if above 5, go back
	cmp  al, '1'
	jb   L1			;// if below 1, go back

	call Crlf
	call ChooseProcedure
	jc   quit		;// if CF = 1 exit

	call Crlf
	jmp  Menu		;// display menu again

quit :
exit
main ENDP

;// ------------------------------------------------
ChooseProcedure PROC
;//
;// Selects a procedure from the caseTable
;// Receives: AL = number of procedure
;// Returns: nothing
;// ------------------------------------------------
	push ebx
	push ecx

	mov  ebx, OFFSET caseTable	;// pointer to the table
	mov  ecx, NumberOfEntries	;// loop counter

L1 : cmp  al, [ebx]				;// match found ?
	jne  L2						;// no: continue
	call NEAR PTR[ebx + 1]		;// yes: call the procedure
	jmp  L3

L2 : add  ebx, EntrySize;// point to the next entry
	loop L1;// repeat until ECX = 0

L3:	pop  ecx
	pop  ebx

ret
ChooseProcedure ENDP

;// ------------------------------------------------
AND_op PROC
;//
;// Performs a boolean AND operation
;// Receives: Nothing
;// Returns: Nothing
;// ------------------------------------------------
	pushad;// save registers

	mov	edx, OFFSET msgAND;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  edx, OFFSET msgOperand1;// ask for first operand
	call WriteString
	call ReadHex;// get hexadecimal integer
	mov  ebx, eax;// move first operand to EBX

	mov  edx, OFFSET msgOperand2;// ask for second operand
	call WriteString
	call ReadHex;// EAX = second operand

	and eax, ebx;// operand1 AND operand2

	mov  edx, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers
	ret
AND_op ENDP


;// ------------------------------------------------
OR_op PROC
;//
;// Performs a boolean OR operation
;// Receives: Nothing
;// Returns: Nothing
;// ------------------------------------------------


pushad;// save registers

	mov	edx, OFFSET msgOR;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  edx, OFFSET msgOperand1;// ask for first operand
	call WriteString
	call ReadHex;// get hexadecimal integer
	mov  ebx, eax;// move first operand to EBX

	mov  edx, OFFSET msgOperand2;// ask for second operand
	call WriteString
	call ReadHex;// EAX = second operand

	or eax, ebx;// operand1 OR operand2

	mov  edx, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers

ret
OR_op ENDP

;// ------------------------------------------------
NOT_op PROC
;//
;// Performs a boolean NOT operation.
;// Receives: Nothing
;// Returns: Nothing
;// ------------------------------------------------

pushad;// save registers

	mov	edx, OFFSET msgNOT;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  edx, OFFSET msgOperand1;// ask for first operand
	call WriteString
	call ReadHex;// get hexadecimal integer
	mov  ebx, eax;// move first operand to EBX

	;mov  edx, OFFSET msgOperand2;// ask for second operand
	;call WriteString
	;call ReadHex;// EAX = second operand

	not eax;//not operand1
	mov  edx, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers

ret

NOT_op ENDP



;// ------------------------------------------------
XOR_op PROC
;//
;// Performs an Exclusive - OR operation
;// Receives: Nothing
;// Returns: Nothing
;// ------------------------------------------------
	pushad;// save registers


	mov	edx, OFFSET msgXOR;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  edx, OFFSET msgOperand1;// ask for first operand
	call WriteString
	call ReadHex;// get hexadecimal integer
	mov  ebx, eax;// move first operand to EBX

	mov  edx, OFFSET msgOperand2;// ask for second operand
	call WriteString
	call ReadHex;// EAX = second operand

	xor eax, ebx;// operand1 XOR operand2

	mov  edx, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers




	ret
XOR_op ENDP

XOR2_op PROC
;//
;// Performs an Exclusive - OR operation
;// Receives: Nothing
;// Returns: Nothing
;// ------------------------------------------------
	pushad;// save registers


	mov	edx, OFFSET msgXOR2;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  edx, OFFSET msgOperand1;// ask for first operand
	call WriteString
	call ReadHex;// get hexadecimal integer
	mov  ebx, eax;// move first operand to EBX

	mov  edx, OFFSET msgOperand2;// ask for second operand
	call WriteString
	call ReadHex;// EAX = second operand

	xor eax, ebx;// operand1 XOR operand2
	xor eax,ebx;// then result of (operand1 XOR operand 2) XOR operand 1

	mov  edx, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers




	ret
XOR2_op ENDP

XOR3_op PROC
;//
;// Performs an Exclusive - OR operation
;// Receives: Nothing
;// Returns: Nothing
;// ------------------------------------------------
	pushad;// save registers


	mov	edx, OFFSET msgXOR3;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  edx, OFFSET msgOperand1;// ask for first operand
	call WriteString
	call ReadHex;// get hexadecimal integer
	mov  ebx, eax;// move first operand to EBX

	mov  edx, OFFSET msgOperand2;// ask for second operand
	call WriteString
	call ReadHex;// EAX = second operand
	mov ecx,eax ;x is stored in ecx

	xor eax, ebx;// operand1 XOR operand2
	xor eax,ecx;// ;// then result of (operand1 XOR operand 2) XOR operand 2

	mov  edx, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers




	ret
XOR3_op ENDP

;// ------------------------------------------------
ADD_op PROC
;//
;// Performs an Exclusive - OR operation
;// Receives: Nothing
;// Returns: Nothing
;// ------------------------------------------------
	pushad;// save registers


	mov	edx, OFFSET msgADD;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  edx, OFFSET msgOperand1;// ask for first operand
	call WriteString
	call ReadHex;// get hexadecimal integer
	mov  ebx, eax;// move first operand to EBX

	mov  edx, OFFSET msgOperand2;// ask for second operand
	call WriteString
	call ReadHex;// EAX = second operand

	add eax, ebx;// operand1 add operand2

	mov  edx, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers




	ret
ADD_op ENDP

SUB_op PROC
;//
;// Performs an Exclusive - OR operation
;// Receives: Nothing
;// Returns: Nothing
;// ------------------------------------------------
	pushad;// save registers


	mov	edx, OFFSET msgSUB;// name of the operation
	call WriteString;// display message
	call Crlf
	call Crlf

	mov  edx, OFFSET msgOperand1;// ask for first operand
	call WriteString
	call ReadHex;// get hexadecimal integer
	mov  ebx, eax;// move first operand to EBX

	mov  edx, OFFSET msgOperand2;// ask for second operand
	call WriteString
	call ReadHex;// EAX = second operand
	mov ecx,eax
	mov eax,ebx

	sub eax, ecx;// operand1 minus operand2

	mov  edx, OFFSET msgResult;// result of operation
	call WriteString
	call WriteHex;// EAX = result
	call Crlf

	popad;// restore registers




	ret
SUB_op ENDP


;// ------------------------------------------------
ExitProgram PROC
;//
;// Receives: Nothing
;// Returns: Sets CF = 1 to signal end of program
;// ------------------------------------------------
	stc;// CF = 1
	ret
ExitProgram ENDP

END main
myss SEGMENT PARA STACK 'stack'
	DW 30 DUP (?)
myss ENDS

myds SEGMENT PARA 'data'
    NUMBERS DW 10 DUP(?)          ; array to store a maximum of 10 integers
    COUNT DW ?                    ; actual number of elements in NUMBERS
    MODE_VALUE DW ?               ; mode of the array
    MAX_FREQ DW 0                 ; frequency of the mode
    ENTER_SIZE DB 'Enter number of integers (max 10): $'
    ENTER_NUMBERS DB 13, 10, 'Enter integer: $'
    OUTPUT_MESSAGE DB 13, 10, 'The mode of the array is: $'
myds ENDS

mycs SEGMENT PARA 'code'
	ASSUME CS: mycs, DS:myds, SS:myss
INPUT_ARRAY MACRO				  ; Macro to input array elements
    POP CX                        ; Get COUNT from stack, put it in CX
    MOV SI, 0                     ; NUMBERS array index

INPUT_LOOP:
    MOV DX, OFFSET ENTER_NUMBERS  ; ask user to enter integer to NUMBERS array
    MOV AH, 09h
    INT 21h

    MOV AH, 01h					  ; Read integer from console, put it in AL
    INT 21h
    SUB AL, '0'                   ; Convert ASCII to integer
	AND AX, 00FFH				  ; only add the last two bytes to array NUMBERS
    MOV [NUMBERS + SI], AX        ; Store element in NUMBERS array
    ADD SI, 2                     ; Move to next element in NUMBERS
    LOOP INPUT_LOOP
ENDM
	
MAIN PROC
    PUSH DS
	XOR AX, AX
	PUSH AX
	MOV AX, myds
	MOV DS, AX

    MOV DX, OFFSET ENTER_SIZE	  ; Display prompt for number of elements
    MOV AH, 09h
    INT 21h

    MOV AH, 01h					  ; Read number of elements, put it in AL
    INT 21h
    SUB AL, '0'                   ; Convert ASCII to integer
	AND AX, 00FFH				  ; since count must be less than 10, we only need the last two bytes of AX
    MOV COUNT, AX                 ; Store number of elements

    PUSH COUNT					  ; Push COUNT onto stack call INPUT_ARRAY to fill NUMBERS array
    INPUT_ARRAY					  ; call INPUT_ARRAY to fill NUMBERS array

    PUSH COUNT					  ; Push COUNT
    CALL MODE					  ; call MODE to calculate the mode

    MOV DX, OFFSET OUTPUT_MESSAGE ; Display the output message
    MOV AH, 09h
    INT 21h

    MOV AX, MODE_VALUE			  ; move mode value to AX, so that user can check what number is 
	ADD AX, '0'					  ; add '0' to number in AX to get its ASCII character
	MOV DL, AL				      ; move AL to DL to print it on the screen	
    MOV AH, 02h					  ; print function for a single character
    INT 21h			

    MOV AH, 4Ch
    INT 21h
MAIN ENDP

MODE PROC

	PUSH BP						   ; push BP to stack to save it before changing
    MOV BP, SP					   ; move SP to BP to access elements in the stack without popping
    MOV CX, [BP + 4]               ; Get COUNT from stack
	SHL CX, 1					   ; multiply by 2 since NUMBERS is of type word
    XOR DI, DI                     ; DI is outer loop index for NUMBERS

    MOV MAX_FREQ, 0                
    MOV MODE_VALUE, 0              

OUTER_LOOP:
    MOV AX, [NUMBERS + DI]		   ; move NUMBERS[DI] to AX
    MOV BX, 0                      ; Reset frequency count after each iteration of the outter loop
    MOV SI, 0                      ; SI is inner loop index

INNER_LOOP:
    CMP AX, [NUMBERS + SI]		   ; Compare NUMBERS[DI] with NUMBERS[SI]
    JNE SKIP_INCREMENT			   ; if not equal, go to next iteration of the inner loop
    INC BX                         ; if equal, increment frequency count

SKIP_INCREMENT:
    ADD SI, 2                      ; Move to next element in NUMBERS
    CMP SI, CX					   ; compare with CX, size of array
    JL INNER_LOOP				   ; if less, iterate again in inner loop

    CMP BX, MAX_FREQ			   ; Check if this frequency is the highest so far
    JLE SKIP_UPDATE_MODE		   ; if frequency is less or equal, skip this and start from outer loop
    MOV MAX_FREQ, BX               ; if frequency is bigger, update max frequency
    MOV MODE_VALUE, AX             ; make MODE_VALUE the new mode of the array

SKIP_UPDATE_MODE:
    ADD DI, 2                      ; Move to next element in NUMBERS
    CMP DI, CX					   ; compare with CX, size of array
    JL OUTER_LOOP
    POP BP						   ; pop BP, so that program can return safely to MAIN PROC
    RET
MODE ENDP
mycs ENDS
END MAIN

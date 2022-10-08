;*******************************************************************************
;
;    CS 107: Computer Architecture and Organization -- LAB 6
;    Filename: Lab06.s
;    Date: [4/19/22]
;    Author: [Lucas Kelley]
;
;*******************************************************************************
;
	GLOBAL __main
	AREA main, CODE, READONLY
	EXPORT __main
	EXPORT __use_two_region_memory
__use_two_region_memory EQU 0
	EXPORT SystemInit
	ENTRY

; System Init routine
SystemInit
;
	BX		LR
;
; Main program
;
__main
;
; Test 'delay'
;
; vvvvvv Uncomment when function 'delay' is ready to test! vvvvv	
	LDR		R1, =5
	BL		delay
	LDR		R1, =0
	BL		delay
; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;
; Test 'my_rbit'
;
; vvvvvv Uncomment when function 'my_rbit' is ready to test! vvvvv
	LDR		R1, = 0x1
	LDR		R2, = 0x1
	BL		my_rbit
	RBIT	R2, R2
	
	LDR		R1, = 0x80000000
	LDR		R2, = 0x80000000
	BL		my_rbit
	RBIT	R2, R2
	
	LDR		R1, = 0x05000000
	LDR		R2, = 0x05000000
	BL		my_rbit
	RBIT	R2, R2
; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
;
; Test 'strcpy' and 'strcat'
;
; vvvvvv Uncomment when functions 'strcpy' and 'strcat' are ready to test! vvvvv
	LDR		R0, =result_str
	LDR		R1, =test_str_1
	BL		strcpy
	LDR		R1, =test_str_2
	BL		strcat
; ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
	
stop
	B		stop

	ALIGN

;
; 1. In future labs you will use 'delay' function. The function may be described as:
;
; void delay(unsigned long rx)
; {
;    while (rx--);
; }
;
; Please note: the function should also work for parameter = 0. Check the parameter and return if 0 before the loop. 
;
; Write this function in assembler. Pass parameter throw register R1.
; (You may use the 'delay' code from Lab05.)
;
delay
; -- Your code for function is here ---'
	CMP 	R1, #0
	BXEQ 	LR
	SUBS 	R1, #1
	B    	delay
	

	ALIGN

;
; 2. Write a routine the reverse the bits in a register R1, so then
; a register containing 
;    Bit31 Bit30 Bit29 ... Bit1  Bit0 
; now contains 
;    Bit0  Bit1  Bit2  ... Bit30 Bit31
;
; Example:
;    Initail value: 00100000 00000000 00000000 10000000 (0x20000080)
;    Reversed:      00000001 00000000 00000000 00000100 (0x01000004)
;
; Compare this to the instruction RBIT to check if your routine works ok.
;
; Parameter: R1
; Result: R1
; 
; The subroutine should preserve all other registers used.
;
my_rbit
; -- Your code for function is here ---'
	PUSH 	{R0,R2-R12, R14}
	MOV 	R3, #0
	MOV 	R4, #32

loop
	LSLS 	R1, #1
	RRX 	R3
	SUBS 	R4, #1
	BNE 	loop

	MOV 	R1, R3
	POP 	{R0,R2-R12, R14}
	BX		LR

	ALIGN

;
; 3. Wrirte the standard C 'strcpy' function in Assembler.
;
;    char* strcpy(char* destination, const char* source);
;
; Parameters
;
;    dest - This is the pointer to the destination array where the content is to be copied.
;
;    src - This is the string to be copied.
;
; Use R0 for 'dest' and R1 for 'src'. 
;
; The function should not change R0 and R1 as well as all another register(s) that may be used in the function
; 
;
strcpy
; -- Your code for function is here ---' 
	PUSH 	{R0-R12, R14}

cpy_loop
	LDRB 	R3, [R1, #0]
	STRB 	R3, [R0]
	ADD 	R1, #1
	ADD 	R0, #1
	TEQ 	R3, #0
	BNE 	cpy_loop
	
	POP	 	{R0-R12, R14}
	BX 		LR
 
	ALIGN

;
; 4. Wrirte the standard C 'strcat' function in Assembler.
;
; char *strcat(char *dest, const char *src)
; 
; Parameters
;
;   dest - This is pointer to the destination array, which should contain a C string, and should be large enough to contain the concatenated resulting string.
;
;   src - This is the string to be appended. This should not overlap the destination.
;
; Use R0 for 'dest' and R1 for 'src'. 
;
; The function should not change R0 and R1 as well as all another register(s) that may be used in the function
; 
; Tip: You may want to call strcpy function!
;
strcat
; -- Your code for function is here ---' 
	PUSH 	{R0-R12, R14}

cat_loop
	LDRB 	R3, [R0, #1]
	ADD 	R0, #1
	TEQ		R3, #0
	BNE 	cat_loop
	
	BL    	strcpy
	POP	 	{R0-R12, R14}
	BX 		LR

	ALIGN

test_str_2
	DCB		"City College", 0
	ALIGN
some_data
	DCD	   0x24374732, 0x93a5cd12, 0xffda34e3
	ALIGN
test_str_1
	DCB		"Santa Barbara ", 0
	ALIGN

	AREA variables, DATA, ALIGN=2
result_str
	SPACE	64

	END
		
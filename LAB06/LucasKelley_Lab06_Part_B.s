;*******************************************************************************
;
;    CS 107: Computer Architecture and Organization -- LAB 5
;    Filename: Lab05.s
;    Date: [4/5/2022]
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
	EXPORT Virtual_GPIO1_PIN
	ENTRY

	GET		BOARD.S

; You may want to define some constant(s) for delay and/or bitmask.
; if so, do it below this lines or uncomment following lines and
; type proper constant(s) instead of '??????'
;
main_delay	EQU	32
red_delay	EQU	102
green_delay EQU	498
blue_delay	EQU	1843
;
; #11. Make the mask for your virtual pin(s)  
;
RGB_PINS	EQU (RGBLED_R_BIT:OR:RGBLED_G_BIT:OR:RGBLED_B_BIT)

RED_PIN		EQU (RGBLED_R_BIT)
GREEN_PIN 	EQU	(RGBLED_G_BIT)
BLUE_PIN	EQU (RGBLED_B_BIT)

; System Init routine
SystemInit
;================ DO NOT CHANGE ANYTHING BELOW THIS LINE =======================
	LDR		r1, =0x34525363
	LDR		r0, =Virtual_GPIO1_PIN
	STR		r1, [r0]
	MOV		r1, #0
	MOV		r0, #0
;================ DO NOT CHANGE ANYTHING ABOVE THIS LINE =======================
;
; #10. Reset virtual GPIO R, G andB Pins, do not change any another virtual pins!
;
; --- Write your code to turn all 3 virtual LEDs off here...

	LDR 	R0, =Virtual_GPIO1_PIN
	LDR 	R1, [R0]
	BIC 	R1, #(RGBLED_R_BIT:OR:RGBLED_G_BIT:OR:RGBLED_B_BIT)
	STR 	R1, [R0]

;
	BX		LR
;
	ALIGN

__main
;
; #12. You may write some additional initialization code here...


	LDR 	R5, =red_delay
	MOV 	R6, R5
	LDR 	R7, =green_delay
	MOV 	R8, R7
	LDR 	R9, =blue_delay
	MOV 	R10, R9
    LDR 	R0, =Virtual_GPIO1_PIN

loop
	LDR		R3, =main_delay
	BL 		delay

;
; #14. Invert pin(s)
;
; --- Write your code to invert virtual pin(s) here...
	
	MOV 	R4, R5
	MOV 	R11, R6
	LDR 	R1, =RED_PIN
	BL 		invert_pin
	MOV 	R5, R4
	
	MOV 	R4, R7
	MOV 	R11, R8
	LDR 	R1, =GREEN_PIN
	BL 		invert_pin
	MOV 	R7, R4
	
	MOV 	R4, R9
	MOV 	R11, R10
	LDR 	R1, =BLUE_PIN
	BL 		invert_pin
	MOV 	R9, R4

	
	B		loop	; Loop forever!
	
delay
	SUBS 	R3, #1
	BXEQ 	LR
	B    	delay
	
	ALIGN

invert_pin
	SUBS 	R4, #1
	BXNE 	LR
	MOV 	R4, R11
	LDR 	R2, [R0]
	EOR 	R2, R1
	STR 	R2, [R0]
	BX 		LR


;================ DO NOT CHANGE ANYTHING BELOW THIS LINE =======================
	ALIGN

	AREA vars, DATA, ALIGN=2

Virtual_GPIO1_PIN
	SPACE	4
;================ DO NOT CHANGE ANYTHING ABOVE THIS LINE =======================
	
	END
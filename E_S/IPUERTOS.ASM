;	Archivo Fuente 		ipuertos.asm
;
; 	Objetivo		Inicializa los perifericos de la CPU
;				8253, 8251,8259
;
;	Revision		2/Oct/1992
;				3/Mar/1993
;
;	Elaboro			Herrera Charles Roberto

NAME INICIALIZA_PERIFERICOS

	DOSSEG
	MODEL   tiny


	DATASEG


	CODESEG

; Constantes de programacion de perifericos
; definidas en funcion de sus caracteristicas para posibles reconfiguraciones

; Constantes para el 8259

	PICR0 	EQU	0C0H	; direccion registro cero del 8259
	PICR1	EQU	0C2H	; direccion registro uno del 8259
;	PICR0 	EQU	4010H	; direccion registro cero del 8259
;	PICR1	EQU	4012H	; direccion registro uno del 8259

	ICW1	EQU     17H	; Se activa por flaco ; se necesita ICW4;
				; llama direcciones de intervalo de 4 bytes
	ICW2	EQU     20H	; vector inicial de la tabla de interrup-
				; ciones para el 8259
	ICW3	EQU     04H	; Solo un maestro, ningun esclavo
	ICW4	EQU     0DH	; No anidado; modo con buffer ; EOI normal
				; modo 8086
;	OCW1	EQU     0EFH	; Interrupcion parasita habilitada
	OCW1	EQU     0FFH	; Interrupcion parasita deshabilitada



; Constantes para el 8253

	PROGMODO EQU  	0D6H	; puerto de control del 8253
	CONTAD0  EQU  	0D0H	; puerto para contador 0 del 8253
	CONTAD1  EQU    0D2H	; puerto para contador 1 del 8253
	CONTAD3	 EQU	0D4H	; puerto para contador 2 del 8253
	PULSO_IT EQU	0b4H	; bit de programacion del contador 0  = 34h
				; 			  contador 3  = b4h
				; bit 7 y 6 = 00 contador 0; bit 5 y 4 = 11
				; carga parte alta y baja; bit 3, 2 y 1 = 100
				; modo generador de pulso; bit 0 contador binario

	ONDA_CUAD EQU	036H	; bit de programacion del contador 3 = B6
				; 			  Contador 2 = 76
				;			  contador 1 = 36
				; bit 7 y 6 = 10 contador 3; bit 5 y 4 = 11
				; carga parte alta y baja; bit 3, 2 y 1 = x11
				; modo generador de onda cuadrada,
				; bit 1 contador BCD

	FACTH	EQU	02H	; factor de division 2 para 9600 bauds
	FACTL	EQU	00H	; parte alta

;	FACTH	EQU	0dH	; factor de division 13 para 4800 bauds(4MHz)
;	FACTL	EQU	00H	; parte alta


	TIEMPO 	EQU	10	; Tiempo de interrupcion de reloj tiempo real
				; en milisegundos (10 ms)
	FACTOR  EQU	1193	; CLK = 1 193 181 Hz * 0.001 seg =  1193
;	FACTOR  EQU	4000	; CLK = 4 000 000 Hz * 0.001 seg =  4000

; Constantes para del 8251

	P8251CTL	EQU  	0DAH
	P8251DAT	EQU  	0D8H

	RESET		EQU	40H
	IWCTL		EQU	0EFH
	IWOPR		EQU	15H

; 	Funcion:	Inicializa el 8259
;
;       Paramentro: 	Ningun valor
;
;	Regresa:	Ningun valor
;

	PUBLIC  _I8259
	_I8259  PROC NEAR

	PUSH    SI      	; Prologo
	PUSH    DI
	PUSH    BP
	MOV     BP,SP

	PUSH    DX
	PUSH    AX

	MOV     DX,PICR0   	; Programa palabra de control uno
	MOV     AL,ICW1		;
	OUT     DX,AL        	;
	MOV     AH,AL

	MOV     DX,PICR1      	; Programa palabra de control dos
	MOV     AL,ICW2
	OUT     DX,AL
	TEST    AH,2    	; Prueba si se requiere palabra tres
	JNZ     CONT
	MOV     AL,ICW3
	OUT     DX,AL


CONT: 	MOV     AL,ICW4		; Programa palabra de control cuatro
	OUT     DX,AL
	MOV     AL,OCW1		; Programa palabra de operacion
	OUT     DX,AL

	POP     AX		; Epilogo
	POP     DX

	POP     BP
	POP     DI
	POP     SI
	RET
	_I8259 ENDP


; 	Funcion:	inicializa el 8253
;
;       Paramentro: 	Ningun valor
;
;	Regresa:	Ningun valor
;

	_I8253 PROC  NEAR

	PUBLIC  _I8253

	PUSH    SI		; prologo guarda registros
	PUSH    DI
	PUSH    BP
	MOV     BP,SP

	PUSH    DX
	PUSH    AX

	MOV     DX,PROGMODO   	; Carga la direccion del puerto control
	MOV     AL,PULSO_IT 	; Carga el dato en AL
	OUT     DX,AL        	; Escribe el dato en el puerto

	MOV     AX,TIEMPO      	; Calcula factor para un tiempo de 10 ms
	MOV     CX,FACTOR	; lo obtiene multiplicando factor base por
	MUL     CX		; tiempo del duracion de cada impulso de reloj
	MOV     DX,CONTAD0 	; Carga en el contador cero el factor de
	OUT     DX,AL		; cuenta, primero parte baja del factor
	MOV     AL,AH
	OUT     DX,AL		; despues parte alta del factor

;   cambios para el 80286 habia que reprogramar el EPROM Y realambrar

;	MOV     DX,PROGMODO   	; Carga la direccion del puerto control
;	MOV     AL,PULSO_IT 	; Carga el dato en AL
;	OUT     DX,AL        	; Escribe el dato en el puerto
;
;	MOV     AX,TIEMPO      	; Calcula factor para un tiempo de 10 ms
;	MOV     CX,FACTOR	; lo obtiene multiplicando factor base por
;	MUL     CX		; tiempo del duracion de cada impulso de reloj
;	MOV     DX,CONTAD3 	; Carga en el contador cero el factor de
;	OUT     DX,AL		; cuenta, primero parte baja del factor
;	MOV     AL,AH
;	OUT     DX,AL		; despues parte alta del factor


	MOV	DX,PROGMODO 	; Carga la direccion de puerto de control
	MOV 	AL,ONDA_CUAD	; Programa el contador 3 gen. onda cuadrada
	OUT	DX,AL
	MOV 	AL,FACTH	; Carga en el contador 3 el factor de cuenta
	MOV	DX,CONTAD3	; para obtener un reloj de transmision
	OUT	DX,AL		; de 9600 x 64, carga parte baja
	MOV 	AL,FACTL	;
	OUT	DX,AL 		; carga parte alta.

;   cambios para el 80286 habia que reprogramar el EPROM Y realambrar
;	MOV	DX,PROGMODO 	; Carga la direccion de puerto de control
;	MOV 	AL,ONDA_CUAD	; Programa el contador 0 gen. onda cuadrada
;	OUT	DX,AL
;	MOV 	AL,FACTH	; Carga en el contador 3 el factor de cuenta
;	MOV	DX,CONTAD0	; para obtener un reloj de transmision
;	OUT	DX,AL		; de 9600 x 64, carga parte baja
;	MOV 	AL,FACTL	;
;	OUT	DX,AL 		; carga parte alta.



	POP     AX		; Epilogo
	POP     DX

	POP     BP
	POP     DI
	POP     SI
	RET
	_I8253 ENDP


; Rutina que inicializa el 8251
; Tiene su equivante en lenguaje C borrar una de las rutinas


	_II8251 PROC  NEAR

	PUBLIC  _II8251

	PUSH    SI
	PUSH    DI
	PUSH    BP
	MOV     BP,SP

	PUSH    DX
	PUSH    AX

	MOV     AL,RESET		; Solo para el caso programa en RAM
	MOV	DX,P8251CTL		; Reset por software
	OUT     DX,AL

	MOV 	AL,IWCTL		; Programacion de Control1
	OUT	DX,AL

	MOV 	AL,IWOPR		; Programacion de Operacion
	OUT	DX,AL

	POP     AX			; Epilogo
	POP     DX

	POP     BP
	POP     DI
	POP     SI
	RET
	_II8251 ENDP

	END
;	fuente 	servint.asm
;
;	Codigo de de entrada de los manejadore de interrupciones
;
;	CITEDI (c) /Depto. de Investigacion 1992  Charles
;
;	revision 15 de diciembre de 1992
; 	ultima   18 de marzo de 1993
;
;      IDEAL
      DOSSEG
      MODEL   tiny ;small

;  definiciones de constante para el la operacion de perifericose

	include ..\h\llamantr.asm

	PICR0 	EQU 	0C0H    ; direccion de registro 0 del 8259
	PICR1 	EQU 	0C2H	; direccion de registro 1 del 8259

;	PICR0 	EQU 	4010H    ; direccion de registro 0 del 8259
;	PICR1 	EQU 	4012H	; direccion de registro 1 del 8259

	EOI   	EQU	020H	; Fin de interrupcion para 8259
	SETWD 	EQU	0F0H    ; direccion de armado del watchdog
	RSTWD	EQU	0F8H	; direccion de reset del watchdog
	NUCLEO	EQU	012h	; Interrupcion del nucleo
	SERCONT EQU	0DAH	; Registro de control de 8251
	RESET	EQU	040H	; Reset para el 8251
	DOS	EQU	02H	; Senal dos



	DATASEG


	CODESEG

; funciones externas que llaman las rutinas de servicio de interrupciones

;	EXTRN 	_reloj_tiemp : near , _fin_int:near ,_envia_senal:near
;	EXTRN  _esigit:near, _pruebaTx: near
	EXTRN  _pruebaTx: near

;
;  	Rutina de servicio de los manejadores de interrupciones
;

;--------------------------------------------------------------------
; 	interrupcion del reloj de tiempo real
;--------------------------------------------------------------------
; La interrupcion del manejador de reloj Realiza:
;
;	1) Guarda los tres registros generales DS, ES y AX
;	2) Habilita las interrupciones para el 8259.Con el envio de la
;	   se¤al de EOI
;	3) Manda la reinicializaci¢n del "Watch-Dog" escribiendo un dato
;	   a su direcci¢n.
;	4) Al final salta a el manejador reloj. El mantiene el control de
;	   las alarmas y de terminar la interrupci¢n.
;
servicioIt:

	PROC _it_drvrtr  NEAR

		PUBLIC  _it_drvrtr

INTRELOJ:
	PUSH	DS			; Prologo para compatibilidad
	PUSH    ES			; con llamadas al sistema
	PUSH    AX

	PUSH    DX			; registro de uso interno

;	MOV    	DX,SETWD  		; Arma la alarma de Watch-Dog
;	OUT    	DX,AL			; El valor de AL no importa
	MOV     AL,EOI          	; Resetea la linea que interrupcion
	MOV     DX,PICR0
	OUT     DX,AL

	POP     DX			; recupera registro que uso

	XOR	AX,AX			; llama a primitiva que maneja reloj
	MOV	ES,AX			; La llamada se hace por un salto largo
	MOV	AX, _reloj_tiemp	; Primitiva del reloj DRVHTR
	JMP	ES:DWORD PTR [4*NUCLEO]	; Llamada por un salto lejano
;	DB	26H
;	DW 	02EFFH, (4*NUCLEO)	; Codigo equivante para formato .COM
	;	La interrupcion se termina en el manejador del reloj de
	;	tiempo real
	ENDP _it_drvrtr


;--------------------------------------------------------------------
; 	interrupcion del NMI, rutina de servicio del Watch - Dog
;--------------------------------------------------------------------
; La rutina interrupcion del la interrupcion no mascarable
;
;	1) Manda el reset al "Watch-Dog" escribiendo un dato
;	   a su direcci¢n.
;	2) Resetea los dispositivos que necesita reset por software para su
; 	   reprogramacion. Ejemplo el 8251.
;	3) Hace un reset por software saltando a la direccion de inicio de
;	   RESET FFFF:0
;
;

 _NMI:  				; direccion donde entra la rutina de
					; servicio de alarma de Watch dog
	MOV	DX,RSTWD    		; reset la alarma de Watch dog
	OUT    	DX,AL			; el valor de dato no importa
	MOV	DX,SERCONT 		; resetea el 8251 para reprogramacion
	MOV	AL,RESET		; carga la palabra de control
	OUT	DX,AL			; lo escribe al puerto de control

; 	RESET DEL SISTEMA EQUIVALE EN CODIGO ENSAMBLADOR A
; 	JMP FFFF:0000
	DB 0EAH,0,0,0FFH,0FFH		; "Reset por software" inicializa todo los
					; perifericos

	RET				; Nunca se ejecuta esta instruccion

;---------------------------------------------------------------------
; 	Interrupcion parasita ( interrupciones de hardware no
;	reconocidas por el sistema)
;---------------------------------------------------------------------
; La rutina interrupcion parasitas. Son interrupciones no reconocida o ines-
; peradas
;
;	1) Habilita las interrupciones para el 8259. Con el envio de la
;	   se¤al de EOI
;	2) Y retorna de la interrupcion.
;
;
	PUBLIC  _it_parasita, _NMI

	PROC _it_parasita      NEAR

	PUSH 	DS			; Prologo
	PUSH    ES
	PUSH   	AX
	PUSH	BX
	PUSH 	DX


	MOV     AL,EOI			; Resetea linea de interrupcion
	MOV	DX,PICR0		; Carga direccion
	OUT 	DX,AL			; del controlador del 8259

	POP 	DX     			; Epilogo de la interrupcion
	POP     BX
	POP     AX
	POP    	ES
	POP 	DS
	IRET
	ENDP _it_parasita

;--------------------------------------------------------------------
; 	interrupcion de manejador de puerto serie 8251
;--------------------------------------------------------------------
; La rutina interrupcion de recepcion de puerto serie
;
;	1) Guardo los cuatro registros generales DS, ES, AX y BX
;	2) Habilita las interrupciones para el 8259. Con el envio de la
;	   se¤al de EOI
;	3) Llama a la rutina que inserta los caracteres a la cola de recepcion
;	4) Envia una se¤al indicando que se recibio un caracter. Se encuentra
;	   en archivo recepcio.c
;	5) Llama a la primitiva fin de interrupcion FIT. La cual se
;	   encarga de terminar la rutina de interrupcion
;

	EXTRN _recbuf:NEAR, _emibuf:NEAR

	PROC _rutirecep NEAR

	    PUBLIC  _rutirecep


	PUSH 	DS			; Prologo
	PUSH    ES
	PUSH   	AX
	PUSH	BX


	MOV     AL,EOI			; Resetea linea de interrupcion
	PUSH	DX			;
	MOV     DX,PICR0                ; Carga direccion del 8259
	OUT 	DX,AL			; del controlador del 8259
	POP  	DX                      ;

        PUSH	DS			;*
	XOR 	AX,AX			;* Borra DS: Cambia ZDES
	MOV 	DS,AX			;*


	CALL	_recbuf			; llama al manejador buffer de
					; recepcion

	POP	DS			;* recupera

					; envia la se¤al 2 de rececpion de dato
	mov 	ax,  _esigit 	; direccion de la primitiva.
	mov	bx, DOS 		; Carga el numero de la senal
	int	NUCLEO

	XOR	AX,AX           	; llama a la primitiva fin de interrupcion
	MOV	ES,AX			; FIT
	MOV	AX, _fin_int 	; FIT
	JMP	ES:DWORD PTR[4*NUCLEO] 	; vector de interrupcion NUCLEO
;	DB	26H
;	DW 	02EFFH, (4*NUCLEO)

	ENDP _rutirecep

;---------------------------------------------------------------------
; 	Rutina de servio de interrupcion de transmision de un caracter
;	del 8251
;---------------------------------------------------------------------
;	1) Guardo los cuatro registros generales DS, ES, AX y BX
;	2) Habilita las interrupciones para el 8259.Con el envio de la
;	   se¤al de EOI
;	3) Llama a la rutina que toma un caractere de la cola de transmision
; 	   y lo coloca en el puerto serie. Archivo recepcio.c
;	5) Llama a la primitiva fin de interrupcion FIT. La cual se
;	   encarga de terminar la rutina de interrupcion
;

	COMESP	EQU	0BH		; INVESTIGAR QUE SIGNIFICA

	PROC _rutitrans NEAR

	    PUBLIC  _rutitrans


	PUSH 	DS			; Prologo
	PUSH    ES
	PUSH   	AX
	PUSH	BX

	NOP				; retardo
	NOP
	NOP
	NOP


	PUSH	DS			;*
;	XOR 	AX,AX			;* Borra DS o cambia zona de E/S
;	MOV 	DS,AX			;*
;	call  _pruebaTx

	call	_emibuf			; llama al manejador buffer de
					; emision

	POP	DS			;* recupera DS

	MOV     AL,EOI			; Resetea linea de interrupcion
	PUSH	DX			;
	MOV     DX,PICR0                ; Carga direccion del 8259
	OUT 	DX,AL			; del controlador del 8259
	POP  	DX                      ;


	XOR	AX,AX           	; llama a la primitiva fin de interrupcion
	MOV	ES,AX			; FIT
	MOV	AX, _fin_int 	; tabla de definiciones de salto
	JMP	ES:DWORD PTR[4*NUCLEO] 	; vector de interrupcion NUCLEO
;	DB	26H			; Equivalencia para formato com
;	DW 	02EFFH, (4*NUCLEO)	;

;	POP 	BX			; Prologo
;	POP     AX
;	POP   	ES
;	POP	DS
;	IRET


	ENDP _rutitrans

	END servicioIt






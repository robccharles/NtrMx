;	Archivo Fuente 		saltoses.asm
;
; 	Objetivo		Tabla de salto de todas las llamadas de Entradas
;				y Salidas
;
;
;	Revision		23/Sept/1993
;
;				Herrera Charles Roberto

	DOSSEG
	MODEL   tiny


	DATASEG

	include ..\h\stdioh.asm

	EXTRN  _imprimes:near, _Mgetch:near, _Mputchar:near

	PUBLIC _int_ES

	CODESEG
;    tabla de saltos para E/S, el salto se hace de acuerdo a la llamada
;
_int_ES:    	jmp ax			; Entrada de todas las Entradas y salidas
_imprime_e:	jmp imprime_m   	; imprime una cadena por la salida estandar
_getch_e:	jmp getch_m		; espera un caracter por la salida estandar
_putch_e:	jmp putch_m		; imprime un caracter


imprime_m:      push ds			; Cambia Zona de datos ES (ZDES)
		mov  ax,cs:ZDES		; Recupera el segmento de ZDES
		mov  ds,ax		; y lo actualiza en DS

		push es
		push cx
		call _imprimes
		pop  cx
		pop  cx
		pop  ds			; recupera DS del la tarea
		iret

getch_m:        push ds			; Cambia Zona de datos ES (ZDES)
		mov  ax,cs:ZDES		; Recupera el segmento de ZDES
		mov  ds,ax		; y lo actualiza en DS

		call _Mgetch

		pop  ds			; recupera DS del la tarea
		iret

putch_m:        push bp			;
		mov  bp,sp		;

		push ds			; Cambia Zona de datos ES (ZDES)
		mov  ax,cs:ZDES		; Recupera el segmento de ZDES
		mov  ds,ax		; y lo actualiza en DS

		mov  ax,[bp+10]		;toma el parametro
		push ax

		call _Mputchar

		pop  ax

		pop  ds			; recupera DS del la tarea
		pop  bp
		iret

		end



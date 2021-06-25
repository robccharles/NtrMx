	DOSSEG
	MODEL   tiny

	INCLUDE ..\h\stdioh.asm

	DATASEG

	PUBLIC _imprime
	CODESEG

_imprime proc near
; Libreria que llama a la funcion de E/S que imprime una cadena de caracteres
; por la salida estandar.
; La llama es:
;	int imprime(char far *ptr);
; donde:
;	ptr 	Apunta al inicio de la cadena que se desea imprimir.
; regresa:
;	ninguno
;
; Nota
;	La cadena de caracteres debe terminar con un caracter nulo.
;
	push 	bp			; Prologo
	mov     bp,sp
	push	es
	push	cx


	mov 	ax,[bp+6]		;* obtiene el parametro del segmento
	mov 	es,ax			;* en es esta el segmento.

	mov	ax,[bp+4]		;***
	mov	cx,ax			; ahora el parametro esta en cx
	mov 	ax,_imprime_real	; desplazamiento de funcion
	INT	SIST_ES

	pop	cx
	pop	es
	pop	bp			; Epilogo
	ret
 _imprime endp

	PUBLIC _getch
_getch  proc near
; Libreria de las funciones de E/S que espera un caracter del la entrada estandar.
; La llama es:
;	int getch(void);
; donde:
;	Sin parametros
; regresa:
;	El caracter que se recibio a la entrada.
;
; Nota:
;	Si no hay caracter disponible la tarea se bloque esperando una se¤al
;
	mov 	ax,_getch_efec		; desplazamiento de funcion getch
	INT	SIST_ES
	ret

_getch	endp

	PUBLIC _putchar
_putchar  proc near
; Libreria de las funciones de E/S que espera imprime un caracter.
; La llama es:
;	int putchar(void);
; donde:
;	Sin parametros
; regresa:
;	El caracter que se recibio a la entrada.
;
; Nota:
;	Si no hay caracter disponible la tarea se bloque esperando una se¤al
;
	mov 	ax,_putchar_efec		; desplazamiento de funcion putchar

	INT	SIST_ES
	ret

_putchar	endp



	end
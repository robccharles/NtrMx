;	Archivo Fuente 		fit.asm
;
; 	Objetivo		Terminacion de una interrupcion.
;				Es la parte fundamental de manejador de
;				interrupciones
;
;
;	Revision		15/Mar/1993
;
;				Herrera Charles Roberto

	DOSSEG
	MODEL   tiny

	include  ..\h\constant.asm

	DATASEG

	CODESEG

	EXTRN 	loc_3 : near, sub_5 : near
	PUBLIC	loc_42


; Fin de interrupcion

;
_finit:
loc_42:
	mov	ds,cs:data_16e		; Obtiene la zona de datos del sistema
	inc	word ptr ds:data_8e	; Determina si numero de tarea que
	jnz	TareaEspIT;loc_43	; reciben se¤al de impulso
	dec	word ptr ds:data_8e	; Si es cero lo decrementa
	pop	bx 			; regresa de la interrupcion
	pop	ax			; recupera los registro
	pop	es
	pop	ds
	iret
loc_43:                                 ; Tareas esperando interrupcion
TareaEspIT:
	mov	word ptr ds:data_19e,0FFFFh ; Pone marca indicar cambio
	push	cx			; Guarda todos los registros
	push	dx
	push	bp
	push	si
	push	di
	mov	bx,ds:data_16		; Apuntador de tarea en ejecucion
	sub	bx,4			; Guarda el valor de la pila
	mov	[bx],sp			; corriente SS y SP
	mov	[bx+2],ss       	;
	jmp	loc_3			; Salta a primitiva "START"
	end
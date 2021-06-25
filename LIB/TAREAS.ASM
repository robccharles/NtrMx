	DOSSEG
	MODEL   tiny

	INCLUDE ..\h\llamantr.asm

	DATASEG

	CODESEG
;=======================================================================
	PUBLIC	_creaTarea
_creaTarea proc near

; Solicitud para la creacion de una tarea dentro del sistema
; La llamada es:
;	creaTarea(numPulsos)
; donde
; 	numPulso apuntador al descriptor de creacion de tarea
; 		 para detalles ver primitiva de creacion de tarea
;
; Nota  El segmento que se pone es el mismo que el segmento del programa
;       hay que implementarlo para llamadas lejanas.

	push 	bp			; Prologo
	mov     bp,sp

IF	EPROM
	mov 	ax,0000H		;	creacion de tarea ociosa
ELSE
	mov 	ax,cs			;	creacion de tarea ociosa
ENDIF
	mov	es,ax                   ; Segmento de bloque de creacion
	mov 	ax,  _crea_tarea	; de tarea.
	mov	bx,[bp+4] 		; Carga el offset del bloque
					; de creacion de tarea
	int	SISTEMA

	pop	bp			; Epilogo
	ret

_creaTarea endp
	end
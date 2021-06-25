	DOSSEG
	MODEL   tiny

	INCLUDE ..\h\llamantr.asm

	DATASEG

	public _libMem
_libMem proc near
; Libera una zona de memoria dinamica asignada en un pozo
; La llamada es:
;	libMem(segMem, offMem )
; donde
; 	segMem Segmento de la memoria a liberar
;	offMem  de la memoria a liberar
;
; Nota: Los cuatro primeros octetos contienen la informacion para la libera-
;       cion del tama¤o, y pozo donde se va liberar la memoria

	push 	bp			; Prologo
	mov     bp,sp
	push 	es
	push	bx
					; Carga los parametros a los reg
	mov	ax,[bp+4]		;  segMem
	mov	es,ax
	mov	bx,[bp+6]		;  offMem
	mov 	ax,  _xlibm 		; Direccion de la primitiva.
	int	SISTEMA

	pop	bx
	pop	es
	pop	bp			; Epilogo
	ret

_libMem endp

	public _asigMem
_asigMem proc near
; Asigna una zona de memoria dinamica en un pozo y regresa la direccion
; asignada en parrafos
; La llamada es:
;	seg asigMem(numPozo, numParraf )
; donde
; 	numPozo  Numero de pozo donde se va asignar la memoria
;	numParraf Numero de parrafos solicitados
; regresa
;       seg 	direccion de inicio, en parrafos de la memoria asignada
;
; Nota: En los cuatro primeros octetos de la memoria asignada se guarda:
;      	el tama¤o, el offset en el pozo y numero pozo. Informacion que se uti-
;	liza durante la liberacion de la memoria asignada.
;

	push 	bp			; Prologo
	mov     bp,sp
	push 	es
	push 	cx
	push	bx
					; Carga los parametros a los reg
	mov	bx,[bp+4]		;  numPozo
	mov	cx,[bp+6]		;  numParraf
	mov 	ax,  _xdemm 	; Direccion de la primitiva.
	int	SISTEMA
	mov 	ax,es   		; Regresa el valor inicio de memoria
					; asignada
	pop	bx
	pop	cx
	pop	es
	pop	bp			; Epilogo
	ret

_asigMem endp


	end
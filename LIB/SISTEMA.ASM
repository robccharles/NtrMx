	DOSSEG
	MODEL   tiny

	INCLUDE ..\h\llamantr.asm

	DATASEG

	CODESEG
	public _segZDS
_segZDS proc near
; obtiene la direccion del segmento de la zona de datos de sistema
; La llamada es:
;	direccion segZDS()
; donde         
; 	direccion es el segmento donde inicia la Zona de Dato del Sistema
;

	push 	bp			; Prologo
	mov     bp,sp
	push	es

	mov 	ax,  _gs_ds 	; Direccion de la primitiva.
	int	SISTEMA
	mov	ax,es			; regresa valor de la zona de
					; datos del sistema

	pop 	es
	pop	bp			; Epilogo
	ret

_segZDS endp


	public _inicPozo
_inicPozo proc near
; inicializa el pozo para el manejo dinamico de memoria
; La llamada es:
;	inicPozo(numPozo, dirBase, logBloque)
; donde
; 	numPozo	Numero de pozo a inicializar
;	dirBase Direccion donde inicia el pozo en parrafos
;	logBloque longitud de bloque en parrafos
;
	push 	bp			; Prologo
	mov     bp,sp
	push	dx
	push 	cx
	push	bx
					; Carga los parametros a los reg
	mov	bx,[bp+4]		;  numPozo
	mov	dx,[bp+6]		;  dirBase
	mov	cx,[bp+8]		;  logBloque
	mov 	ax,  _inpool 	; Direccion de la primitiva.
	int	SISTEMA

	pop	bx
	pop	cx
	pop 	dx
	pop	bp			; Epilogo
	ret

_inicPozo endp
	end
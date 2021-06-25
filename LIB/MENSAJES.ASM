	DOSSEG
	MODEL   tiny

	INCLUDE ..\h\llamantr.asm

	DATASEG

	CODESEG
	public _enviaMensaje
_enviaMensaje proc near
; envio de un mensaje en un buzon
; La llamada es:
;	enviaMensaje(numBuzon,dirMensaje)
; donde
; 	numBuzon Numero de buzon
;
; Nota El segmento utilizado es DS, se necesita ampliar la llamada
;      para que el segmento cambie

	push 	bp			; Prologo
	mov     bp,sp

	mov	ax,ds			; El segmento del mensaje
	mov	es,ax			; es el mismo que los datos
	mov 	ax,  _envia_mensaje 	; direccion de la primitiva.
	mov	bx,[bp+4] 		; Carga el numero del buzon
	mov 	dx,[bp+6]		; Carga la direccion del mensaje

	int	SISTEMA

	pop	bp			; Epilogo
	ret

_enviaMensaje endp


	public _esperaMensaje
_esperaMensaje proc near
; espera de un mensaje en un buzon, sin tiempo de espera
; La llamada es:
;	Mensaje *esperaMensaje(numBuzon)
; donde
; 	numBuzon Numero de buzon
; Regresa
;	Mensaje: La direccion donde se encuentra el mensaje
;
; Nota: Se requiere un ajuste ES:AX de apuntadores lejanos para el mensaje
; 	compatibilidad para el lenguaje C

	push 	bp			; Prologo
	mov     bp,sp

	xor 	cx,cx 			; Espera el mensaje sin timeout
	mov 	ax,  _espera_mensaje ; Direccion de la primitiva.
	mov	bx,[bp+4] 		; Carga el numero de buzon
	int	SISTEMA
	mov	ax,dx			; regresa el off del mensaje
	mov     dx,es			; el segmento regresa en DX

	pop	bp			; Epilogo
	ret

_esperaMensaje endp
	end
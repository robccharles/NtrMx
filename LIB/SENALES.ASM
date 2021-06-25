	DOSSEG
	MODEL   tiny

	INCLUDE ..\h\llamantr.asm

	DATASEG

	CODESEG
;=======================================================================
	public _enviaSenal
_enviaSenal proc near
; envia una se¤al numerada
; La llamada es:
;	enviaSenal(numSenal)
; donde
; 	numSenal Numero de se¤al
;

	push 	bp			; Prologo
	mov     bp,sp


	mov 	ax,  _envia_senal	; direccion de la primitiva.
	mov	bx,[bp+4] 		; Carga el numero de la se¤al
	int	SISTEMA

	pop	bp			; Epilogo
	ret

_enviaSenal endp


	public _esperaSenal
_esperaSenal proc near
; espera de una se¤al numerada, sin tiempo de espera
; La llamada es:
;	espera(numSenal)
; donde
; 	numSenal Numero de se¤al
;

	push 	bp			; Prologo
	mov     bp,sp

	xor 	cx,cx 			; Espera la se¤al sin timeout
	mov 	ax,  _espera_senal ; Direccion de la primitiva.
	mov	bx,[bp+4] 		; Carga el numero de se¤al
	int	SISTEMA

	pop	bp			; Epilogo
	ret

_esperaSenal endp
	end
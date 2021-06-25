	DOSSEG
	MODEL   tiny

	INCLUDE ..\h\llamantr.asm

	DATASEG

	PUBLIC	_duerme
_duerme	proc near

; Cambia al proceso al estado dormido, durante numero de pulso de
; reloj solicitados, depues de que transcurre el tiempo el proceso toma el esta-
; do listo
; La llamada es:
;	durme(numPulsos)
; donde
; 	numPulso Numero de pulso de reloj que el proceso estara dormindo
;
	push 	bp			; Prologo
	mov     bp,sp

	mov	AX,  _espera_temp ;
	mov	CX, [bp+4]		; Cx contiene parametro
	int	SISTEMA   		;

	pop	bp			; Epilogo
	ret

_duerme	endp
	end
;	Archivo Fuente 		copiacam.asm
;
; 	Objetivo		Liberia que copia un bloque de memoria. Esta
;				puede llamarse desde lenguaje C. Hace una llamada
;				a la libreria scopy.
;
;	Revision		18/Mar/1993
;
;	Elaboro			Herrera Charles Roberto

      DOSSEG
      MODEL   tiny

      DATASEG

       INCLUDE ..\h\constant.asm

     CODESEG


	public _copiaCampo

; void copiCampo(unsigned int ZDS, unsigned int* fuente, unsigned int* destino);
; 	Copia un tipo a otro tipo, en distintos segemento de memoria
;
;	Parametros
;		Segmento fuente :	ZDS
;		offset fuente   :	fuente
;		offset destino 	:	destino
;
;		tama¤o del tipo	:	CX = TIPOtarea
;
;	Nota:  La otra solucion a este problema es utilizar una
;              libreria de copia de memoria, y obteniendo el tama¤o
;	       de la estructura.
;	Falta: Introducir el tama¤o del tipo como paramentro.

	EXTRN	scopy@:near

_copiaCampo	proc	near
	push	bp
	mov	bp,sp
	push	cx

	mov	cx,TIPOtarea			; parametro de tama¤o
						; del tipo

	push	ds
	mov	ax,word ptr [bp+8]		; parametro destino
	push	ax
	mov	ax,word ptr [bp+4]		; parametro ZDS
	push	ax
	mov	ax,word ptr [bp+6]		; parametro fuente
	push	ax
	push	cs
	call	scopy@				; llama subrutina que
						; copia las cadenas.
	pop 	cx
	mov	sp,bp
	pop	bp
	ret

_copiaCampo endp
	end
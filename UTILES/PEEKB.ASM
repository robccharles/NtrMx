;	Archivo Fuente 		peekb.asm
;
; 	Objetivo		Lee un byte de una localidad de memoria
;				especificada
;
;
;	Revision		18/Mar/1993
;
;				Herrera Charles Roberto

      DOSSEG
      MODEL   tiny

      DATASEG

     CODESEG
     start:

; unsigned int  peekb(unsigned int, unsigned int);
; lectura esritura a memoria
	public _peekb
_peekb  proc	near
	push	bp
	mov	bp,sp
	push	si
	push    ds
	push    bx

	xor	ax,ax			; borra el contenido de ax
	mov	ds,word ptr [bp+4]	; Ajusta el segmento de datos
	mov	bx,word ptr [bp+6]	; Pone el valor del offset
	mov	al,[bx]			; lee un byte

	pop     bx
	pop     ds
	pop	si
	pop	bp
	ret
_peekb endp
END start

;	Archivo Fuente 		peek.asm
;
; 	Objetivo		Lee un palabara de la memoria.
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

; unsigned int  peek(unsigned int, unsigned int);
; lectura esritura a memoria
	public _peek
_peek  proc	near
	push	bp
	mov	bp,sp
	push	si
	push    ds
	push    bx

	mov	ds,word ptr [bp+4]	; cambia el segmento de datos
	mov	bx,word ptr [bp+6]	; pone la direccion del offset
	mov	ax,[bx]			; lee el dato

	pop     bx
	pop     ds
	pop	si
	pop	bp
	ret
_peek endp
END start

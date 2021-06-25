;	Archivo Fuente 		inpool.asm
;
; 	Objetivo		Inicializa los pozos de memoria
;
;
;	Revision		18/Mar/1993
;
;				Herrera Charles Roberto
	DOSSEG
	MODEL   tiny

	include  ..\h\constant.asm

	DATASEG

	CODESEG

	PUBLIC	inpool, loc_129

	CODINPOOL	equ	128	; Numero de bloques libres

loc_129:
inpool:

	push	ds 			; guarda registros
	push    ax
	push    bx
	push    cx

	mov     ds,cs:data_16e        	; toma ZDS
	mov     ax,bx                 	; copia en AX NUMPOOL
	shl     bx,1                  	; NUMPOOL*4
	shl     bx,1                  	;
	mov     ds:data_14e[bx],dx    	; guarda ABASE en
					;[d4+NUMPOOL*4]

	mov     ds:data_15e[bx],cx    	; guarda LBOL en

	mov     cx,7
	shl     ax,cl                 	; multiplica NUMPOOL*128
	mov     bx,ax                 	; copia a BX
	add     bx,ds:data_13e        	; bx apunta a ZONAPOOL
					;+ NUMPOOL*128
	mov     byte ptr [bx],CODINPOOL	;marca el inicio con  80h
					; numero de bloques libres
	mov     byte ptr [bx+7Fh],CODINPOOL;marca el final con 80h
					; numero de bloques libres
	pop     cx                    	; recupera registros
	pop     bx
	pop     ax
	pop     ds
	iret                          	; retorno de Interrupcion

	end inpool


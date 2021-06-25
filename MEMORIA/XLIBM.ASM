;	fuente 	xlibm.asm
;
;	Primitiva de liberacion de memoria dinamica
;
;	CITEDI (c) /Depto. de Investigacion 1993  Charles
;
;	revision 27 de Febrero de 1993
;
;	Parametros de entrada
;
;		ES:BX 	direccion de inicio del bloque de memoria a liberar
;
	DOSSEG
	MODEL   tiny

	include  ..\h\constant.asm

	DATASEG

	CODESEG

	PUBLIC	xlibm, loc_136

	BLOQPOZO	equ	80h	; Tama¤o de descriptor de tarea

loc_136:
xlibm:
	push	ds			; Prologo
	push	es
	push	ax
	push	bx
	push	cx
	push	dx
	push	di

	mov	ds,cs:data_16e		; Obtiene la Zona de datos del sistema
	les	ax,dword ptr es:[bx]	; Carga los primeros 4 byte del bloque
					; de la memoria asignada, su contenido
					; es: AL el offset del hueco asignado
					; AH el numero de bloques asignados
					; ES el numero de pozo asignado
	mov	di,es			; Guarda en di en numero de pozo
	mov	cl,7			; lo multiplica por 128 para obtener
	shl	di,cl			; la ocupacion de este pozo
	add	di,ds:data_13e		; Se lo suma a tabla de descriptores
					; de pozos del sistema (DI)
	mov	cx,ds			; Copia a ES el segmento de datos del
	mov	es,cx			; sistema

	mov	bx,0			; Borra los registros bx, dx, y cx
	mov	dx,bx
	mov	cx,bx

	xchg	dl,al			; pon en dl el offset del bloques y al=0
	xchg	al,ah			; pon en AL numero bloques asignados y
					; AH=0
	add	di,dx                   ; DI apunta al inicio del hueco que se
					; va liberar
	dec	di			; ajusta al fin del hueco a anterior a
					; liberar
	or	dx,dx			; prueba si el offset es nulo
	jz	loc_137			; Salta si es el principio del pozo
	xchg	bl,[di]			; Toma en BL el tama¤o del hueco ante-
					; rior y pone a cero este octeto
loc_137:
ini_pozo:
	add	di,ax			; DI apunta al final de hueco a liberar
	inc	di			; lo ajusta DI al principio de siguente
					; hueco
	add	dx,ax			; dx es offset al final del hueco
	cmp	dl,BLOQPOZO 		; compara si no es el final del pozo
	jae	loc_138			; Salta si es el final de pozo
	xchg	cl,[di]			; Toma en CL el tama¤o del hueco si-
					; guiente y pone a cero este octeto
loc_138:
fin_pozo:
	dec	di			; Ajusta DI al final de hueco a liberar
	add	di,cx			; Ahora DI apunta al final de hueco si-
					; guiente

	add	ax,bx			; Suma los tama¤os de los tres huecos
	add	ax,cx			; contiguos: BL anterior, CL siguiente y
					; AL de hueco a liberar
	mov	[di],al 		; Guarda al final del hueco el nuevo
					; tama¤o del hueco
	sub	di,ax			; DI apunta al principio de la union
	inc	di			; de los tres huecos
	mov	[di],al			; Guarda al principio del hueco el nuevo
					; tama¤o del hueco
	pop	di			; recupera los registros
	pop	dx
	pop	cx
	pop	bx
	pop	ax
	pop	es
	pop	ds
	iret				; retorna de interrupcion


	end xlibm


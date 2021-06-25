;	fuente 	xdemm.asm
;
;	Primitiva de peticion de un bloque de memoria
;
;	CITEDI (c) /Depto. de Investigacion 1993  Charles
;
;	revision 27 de Febrero de 1993
;
;	Parametros de entrada
;
;		BX 	Numero de pozo(pool) donde se solicitan los bloques
;		CX	Numero de parrafos solicitados
;
;	Parametros de salida
;
;		ACARREO	En uno si no hay espacio en la memoria para asignar
;			el numero de parrafos solicitados a este pozo
;
;		ES	Contiene la direccion de inicio de parrafo si la soli-
;			citud fue exitosa. Con bit de acarreo en cero
;
	DOSSEG
	MODEL   tiny

	include  ..\h\constant.asm

	DATASEG

	CODESEG

	PUBLIC	xdemm, loc_130

	BLOQPOZO	EQU	128	; Numero de bloques en el pozo
	ACARREO		EQU	1	; Bandera de acarreo
loc_130:
xdemm:
	push	bp			; Guarda el apuntador bp

	push	ds			; Salva el contexto en forma normal
	push	di
	push	si
	push	ax
	push	dx
	push	cx
	push	bx

	mov	ds,cs:data_16e		; Obtiene la zona de datos del sistema
	mov	ax,bx   		; Copia en AX en numero de pozo(pool)
	shl	bx,1			; Obtiene la direccion de descriptor
	shl	bx,1			; del pozo (pozo*4)
	mov	si,bx			; SI apunta al descriptor de pozo
	mov	di,ds:data_13e		; DI apunta al inicio de ocupacion
					; del pozos(pool)
	mov	dx,cx                   ; Guarda en dx numero de parrafos soli-
					; citados
	mov	cx,7			; Multiplica el numero de pozo * 128
	shl	ax,cl                   ; Con un corrimiento a la izquierda 7
					; veces
	add	di,ax			; ahora DI apunta al inicio del pozo
					; donde se solicito memoria
	mov	bp,di			; BP tiene una copia
	mov	ax,ds			; Se copia en ES el segmento de datos
	mov	es,ax                   ; del sistema

	mov	ax,dx			; AX = numero de parrafos solicitados
	mov	dx,0			; Borra el valor de BX, uso posterior
	mov	cx,ds:data_15e[si]	; CX tiene el tama¤o de bloques en
					; parrafos para este pozo "[si+d6h]"
	div	cx			; Divide numero de parrafos solicitados
					; por el tama¤o del bloque, ax/cx= AX
					; contiene el numero de bloques solici-
					; tados,(rem=dx:ax/reg) y DX el residuo
	or	dx,dx			; Prueba si residuo es cero ?
	jz	loc_131			; Si no es cero incrementa en uno el
	inc	ax			; numero de bloques solicitados, para
					; contener el residuo de parrafos
loc_131:
si_residuo:
	cmp	ax,BLOQPOZO+1		; Si el numero de bloques solicitados
	jae	loc_133			; es mayor que 128, regresa de la
					; primitiva con bit de acarreo = 1

	; Inicializacion para la busqueda de hueco libre de "primer ajuste"
	mov	bl,al			; BL = numero de bloques solicitados
	mov	al,0			; borra los registros al
	mov	dh,al			; dh, y bh
	mov	bh,al
	cld				; borra el bit de direccion para di++
	mov	cx,BLOQPOZO		; Pon en CX el numero total de bloques
	; Busqueda de un hueco de memoria libre, un hueco esta libre cuando
	; indica el numero de bloque libre, si esta ocupado contiene cero
loc_132:

sig_hueco:
	repe	scasb			; Busca el primer hueco libre
					; rep zf=1 + cx >0 busca en ES:[DI++]
					; el valor de distinto a AL = 00
	jz	loc_133			; no se encontro espacio, regresa
					; con acarre = 1
	mov	dl,[di-1]		; Toma el tama¤o de hueco libre
	cmp	dl,bl			; Se compara con el tama¤o solicitado
	jae	loc_134			; Si es mayor o igual, se encotro hueco
	dec	dx			; si no Salta este hueco
	add	di,dx			; suma DI el tama¤o del hueco
	sub	cx,dx			; restalacelo a CX, pasa la busqueda
	ja	loc_132			; Si no se el final pozo continua

loc_133:
sin_asignar:
	pop	bx			; recupera el contexto
	pop	cx
	pop	dx
	pop	ax
	pop	si
	pop	di
	pop	ds			; recupero el contexto
	; pon el bit de acarreo en 1
	mov	bp,sp               	; guarda bp el valor apuntador de la
					; pila
	or	word ptr [bp+6],ACARREO	; pon a uno la bandera de acarreo en
					; el registro de esta guardado en la
					; pila
	pop	bp			; recupera el valor original de bp
	iret				; regresa de la interrupcion

	iret				; regresa de la interrupcion ??

loc_134:
asigna_mem:
	; condiciones de entrada
	; di apunta al siguiente octeto del hueco de "primer ajuste"
	; bp al inicio de ocupacion de pozo
	; bl bloque solicitados
	; dl bloque que tiene el hueco del "primer ajuste"

	dec	di			; DI apunta al principio del hueco
	mov	cx,di			; Calcula el offset del hueco que se va
	sub	cx,bp			; asignar: resta los inicios del pozo y
					; del hueco. El valor se guarda en CX.
	mov	[di],al			; Hace cero el primer octetos del hueco
	mov	ax,dx			; Calcula la diferencia entre los blo-
	sub	ax,bx   		; ques libres y solicitado en el hueco
					; y lo guarda en ax
	add	di,bx			; DI se incrementa los bloques asignados
	or	ax,ax			; prueba si la diferencia es cero
	jz	loc_135			; Salta si el numero de bloques
					; solicitados y del hueco son iguales
	mov	[di],al			; Coloca nuevo tama¤o del hueco libre
loc_135:
sin_div:
	add	di,ax			; Apunta al final del bloque
	dec	di			; ajusta que apunte al ultimo octeto
	mov	[di],al			; Coloca nuevo tama¤o del hueco libre
	; Guarda parametros de asignacion en los primeros cuatro octetos
	; de la seccion de memoria asignada y regresa en ES  el apuntador
	; al principio de esta

	mov	ax,ds:data_21e[si]	; Obtiene el tama¤o de cada bloque
	mul	cx			; dx:ax = reg * ax
	add	ax,ds:data_20e[si]	; Obtiene la direccion base del pozo
	mov	es,ax			; la copia en el registro ES
	mov	si,0			;
	mov	es:[si],cl             	; coloca en el primer octeto el offset
					; de hueco asignado
	inc	si
	mov	es:[si],bl              ; coloca en el segundo octeto el numero
					; de bloques asignados(solicitados)
	inc	si
	pop	bx			; recupera el numero de pozo
	mov	es:[si],bx		; lo guarda en los octetos 3 y 4 de la
					; memoria asignada

	pop	cx			; recupera el registros
	pop	dx
	pop	ax
	pop	si
	pop	di
	pop	ds

	mov	bp,sp			; copia bp el apuntador de la pila
	and	word ptr [bp+6],0FFFEh	; borra la bandera de acarreo en el
					; registro de estados
	pop	bp			; recupera el valor original de bp
	iret				; Regresa de la interrupcion

	end xdemm


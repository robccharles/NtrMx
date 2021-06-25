;	Archivo Fuente 		drvrtr.asm
;
; 	Objetivo		Manejador del reloj de tiempo real
;
;
;	Revision		13/Nov/1992
;
;				Herrera Charles Roberto

	DOSSEG
	MODEL   tiny

	include  ..\h\constant.asm

	DATASEG

	CODESEG

	EXTRN 	loc_3 : near, sub_5 : near
	PUBLIC	drvrtr , loc_26_1


; Manejador del reloj de tiempo real

;
loc_26_1:
drvrtr:
	mov	ds,cs:data_16e		; obtiene zona de datos del sistema
	mov	ax,ds:data_6e		; obtiene valor de alarma siguiente
	sub	ax,1            	; decrementa valor de alarma siguiente
	jz	loc_27			; si es cero termino alarma
	jnc	loc_26			; Cuando no hay alarma(= 0)
	inc	ax			; se mantien siempre en cero
	; No se ha llegado a final de la alarma
loc_26:
sin_alarma:
	mov	ds:data_6e,ax		; guarda decremento de alarma siguiente
	pop	ax			; Epilogo
	pop	es
	pop	ds
	iret				; Retono si no hay alarma
	; se termino la alarma, hay que actualizar la cola de alarmas
loc_27:
alarma:
	mov	ds:data_17e,ax		; pone la alarma proxima a cero
	push	bx			; Guarda contexto adicional
	push	cx			; Cambio de tarea
	push	dx
	push	bp
	push	si
	push	di
	; Guarda contexto de tarea en ejecucion y cambia a modo kernel
	;
	mov	bx,ds:data_16		; apuntador de tarea en ejecucion
	sub	bx,4			; apunta a campo de la pila en des-
					; criptor de tarea
	mov	[bx],sp			; Guarda el valor de la pila corriente
	mov	[bx+2],ss
	; Cambia la pila a modo kernel
	mov	ax,ds			; La pila de kernel apunta a zona de
	mov	ss,ax			; datos del sistema
	mov	es,ax			;
	mov	sp,0D4h                 ; es la direccion offset 212 decimal

	; Actualiza la lista de alarmas
	;

	; Es seguro que se eliminara tarea que esta a la cabeza de las lista de
	; alarmas
	mov	bx,ds:data_18e		; Apuntador de lista de alarma
	xor	cx,cx			; Borra su contador residual de alarma
	xchg	cx,[bx]             	; y obtiene el valor alarma por el cual
					; estaba esperando, este valor sera
					; restado a las demas tareas que espera
					; alarma
	jmp	short loc_29		; Pasa a prueba de ciclo o mensaje


	;
loc_28:
analisis:
	mov	word ptr [bx+4],0	; Hace nulo el apuntador hacia atras
	sub	[bx],cx			; resta el valor original proxima alarma
					; a el valor residual de esta tarea
	jnz	loc_31			; Salta cuando no hay mas tarea a elimi-
					; nar
	; Si es cero el resultado, esta tarea debe se eliminada de la cola.
	; Verifica si la tareas con alarma esperan tambien mensaje
loc_29:
espera_com:
	mov	si,bx			; Guarda temporalmente PTR alarma en SI
	add	bx,6			; Ajusta BX apuntador de comunicacion
	test	word ptr [bx],0FFFFh	; Prueba si PTR comunicacion es nulo
	jz	loc_30			; Si es nulo, no espera comunicacion
;	call	sub_5			; Si espera comunicacion lo elimina cola
					; cola de se¤al o mensaje
	push	es			; Carga el apuntador del Stack para modi-
	les	di,dword ptr [bx+8]	; ficar el Carry con lo que si indica
	or	byte ptr es:[di+16h],1	; que la tarea esta activa pero no reci-
	pop	es			; bio la comunicacion

;	revisa si la tarea es ciclica

loc_30:
es_ciclica:
	or	byte ptr [bx+0Ch],1	; Cambia el estado de la tarea lista
	mov	bx,si			; bx es PTR del descriptor de tarea
	test	byte ptr [bx+12h],40h	; prueba el bit de ciclo, byte de estado
	jnz	loc_34			; Si es ciclica salta, caso especial
	mov	bx,[bx+2]		; Recorre lista de alarmas. Pasa siguien-
					; te descriptor
	mov	word ptr [si+2],0      	; Hace nulo  el enlace hacia adelante
	or	bx,bx			; Prueba si esta al final de la lista
	jnz	loc_28			; Si no, analiza el estado de alarma de
					; la siguiente tarea en la lista
	mov	ds:data_3e,bx		; Pone la cabeza de la lista de alarmas
	jmp	loc_3			; Salta a primitiva START

	; Inicializacion para restar el valor de alarma para toda la lista

loc_31:
no_eliminar:
	mov	ax,[bx]			; AX contiene el valor de alarma de esta
					; tarea
	mov	ds:data_2e,ax		; Lo cola en registro de alarma proxima
	mov	ds:data_3e,bx		; hace que esta tarea sea la primera en
					; la lista de alarmas
	;
loc_32:
pasa_sig:
	mov	bx,[bx+2]		; BX apunta a la siguiente tarea en la
					; lista
	or	bx,bx			; Prueba si es el final de la lista ?
	jnz	loc_33			; Salta si no es el final
	jmp	loc_3			; Si es el final falta a START
	;
loc_33:
resta_cx:
	sub	[bx],cx    		; resta el valor de alarma
	jmp	short loc_32		; continua recorriendo la lista

	;	Reinsercion en la lista de una tarea ciclica.
	;	reposiciona la tarea ciclica antes de hacer la resta, de
	; 	valor de alarma a todas las tareas en la lista
loc_34:
ciclica:
	mov	dx,[bx+18h]		; DX Contiene el valor del ciclo
	mov	si,[bx+2]		; Si es el apuntador a la siguiente[2a]
					; tarea en la lista de alarmas
	mov	word ptr [bx+2],0	; Hace nulo el apuntador hacia adelante
					; de la tarea ciclica
	or	si,si			; Prueba si esta al final la lista
	jz	loc_41			; Si, se encontro posicion y salta
	mov	word ptr [si+4],0	; Hace nulo el apuntador hacia atras de
					; la siguiente tarea[2a]
	mov	bp,si			; BP es el apuntador a la siguiente[2a]
					; tarea en la lista de alarmas
	;	Busca posicion a la tarea ciclica

	mov	di,0			; Condicion inicial di es nulo

loc_35:
salta_cx:
	cmp	[si],cx			; Compara la volar de alarma con el
	jne	loc_37			; valor de cada tarea (pasa todas las
					; tareas que se van eliminar de la lista)
	mov	di,si			; Avanza los apuntadores en la lista
	mov	si,[si+2]		; DI anterior y SI siguiente
	or	si,si			; Prueba si es el final de la lista ?
	jnz	loc_35			; No, continua recorriendo la lista
	add	dx,cx 			; DX tiene valor ciclico mas valor
					; de alarma
	;	Posicion de tarea ciclica al final de la lista
loc_36:
pos_final:
	mov	[bx],dx			; Pone en tarea ciclica valor de
					; espera
					; Liga enlaces
	mov	[di+2],bx 		; Enlace hacia adelante
	mov	[bx+4],di		; Enlace hacia atras
	mov	bx,bp   		; bx apuntador de siguiente
	jmp	loc_28			; Continua el analisis en la lista
					; de alarmas
	; 	Posicion de tarea ciclica intermedia en la lista

loc_37:
pos_inter:
	add	dx,cx			; DX tiene valor ciclico mas valor
					; de alarma
loc_38:
busca_pos:
	cmp	[si],dx 		; Compara con alarma de tarea
					; siguiente
	jae	loc_39			; Salta si encontro posicion
	mov	di,si                   ; Si no encuentra posicion, continua
	mov	si,[si+2]		; recorriendo la lista de alarmas
	or	si,si			; Prueba si esta al final de lista
	jnz	loc_38			; Si no continua busqueda de posicion
	jmp	loc_36			; Si esta al final, inserta al final

	; 	Encontro posicion intermedia
loc_39:
enlaza_inter:
	mov	[bx],dx			; Guarda el valor de alarma para la
					; tarea ciclica
	mov	[bx+2],si		; Enlace hacia adelante
	mov	[si+4],bx		; Enlace hacia atras
	or	di,di			; Si la posicion es al pricipio
	jz	loc_40			; No hay necesidad de 2a. enlace
	mov	[bx+4],di		; Enlace hacia adelante
	mov	[di+2],bx		; Enlace hacia atras
	mov	bx,bp			; bx recupera valor, punto de analisis
loc_40:
pos_frente:
	jmp	loc_28			; Continua el analisis

loc_41:
solo_ciclica:
	; 	Solo hay una tarea ciclica en la cola de alarma
	;	Se reinserta en la cola y se ajusta apuntador de
	;	cabeza de la cola de alarmas y el valor de la alarma

	mov	ds:data_3e,bx		; Ajuste apuntador de cabeza
	mov	ds:data_2e,dx		; valor de la alarma proxima
	mov	[bx],dx			; Valor de alarma en la tarea ciclica
	jmp	loc_3			; Salto a START

	end loc_26_1
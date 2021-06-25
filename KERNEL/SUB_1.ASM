;	Archivo Fuente 		sub_1.asm
;
; 	Objetivo		Subrutinas para la manipulacion de colas(listas
;				doblemente enlazada). Estas subrutinas son uti-
;				lizadas por varias primitivas. La primera inser-
;				ta elementos en la lista de prioridades, la se-
;				gunda para el cambio de prioridad y ultima in-
;				serta una tarea en la fila de alarmas.
;
;
;	Revision		12/Nov/1992
;                               18/Mar/1992
;
;	Tesis 			Nucleo de Tiempo Real
	DOSSEG
	MODEL   tiny

	include  ..\h\constant.asm

	DATASEG


	CODESEG

	PUBLIC	sub_1, sub_3, sub_4

;
;			       SUBRUTINA1
;
;  	Inserta un elemento en la lista de prioridades
;       La lista es doblemente encadenada
; 	La posicion en de acuerdo a la prioridad que tiene la tarea,
;	la de mayor prioridad esta al inicio de la lista,
;
;	Parametros
;		DX:BX	apunta a la prioridad de la tarea
;
sub_1	proc	near
	pushf				; Enpuja banderas
	push	ax			; y registros
	push	bx			; en la pila
	push	cx
	push	si
	push	di

	mov	di,ds:data_5e		; Toma el apuntador al principio
					; de la lista
	or	di,di			; Prueba si la lista esta vacia
	jz	loc_10			; Salta si ningun elemento
loc_7:
noVacia:
	mov	si,di			; respalda DI en SI (apuntan al
					; estado de la tarea)
	sub	di,13h			; DI apunta a la prioridad de la
					; tarea a la cabeza de la fila
	mov	al,[di]			; AL contiene el valor de prioridad
	cmp	[bx],al			; La compara con prioridad de tarea
					; a insertar
	jae	loc_8			; Salta si encontro posicion
	mov	di,[si+2]		; Pasa a la siguiente tarea
	or	di,di			; Prueba si es el final de cola
	jnz	loc_7			; Si no es final, busca posicion
					; Si es final, inserta al final
	add	bx,13h			; BX apunta al estado de la tarea
					; El enlace se hace apuntando a el
					; campo de estado de la tarea
	mov	[si+2],bx		; Enlace hacia adelante, tarea insertar
	mov	[bx+4],si		; Enlace hacia atras, la ultima tarea
	jmp	loc_15			; Salta epilogo
loc_8:
posInter:
	add	bx,13h   		; BX apunta al estado de la tarea
	mov	di,[si+4]		; Obtiene enlace hacia atras
	or	di,di			; Prueba si es primer elemento
	jz	loc_9			; Salta si posicion al frente

	mov	[bx+2],si		; Enlace hacia adelante nueva tarea
	mov	[bx+4],di		; Enlace hacia atras nueva tarea
	mov	[di+2],bx		; Enlace hacia adelate tarea anterior
	mov	[si+4],bx		; Enlace hacia atras tarea siguiente
	jmp	loc_15			; Salta epilogo
loc_9:
posFrente:
	mov	[si+4],bx		; Enlace hacia atras primera tarea
	mov	[bx+2],si		; Enlace hacia adelante tarea insertada
	mov	ds:data_5e,bx		; Actualiza la cabeza de la lista
	jmp	loc_15			; Salta epilogo
loc_10:
unica:
	add	bx,13h			; Apunta a el estado de la tarea
	mov	ds:data_5e,bx		; Actualiza la cabeza de la lista
	jmp	loc_15			; Salta epilogo

;===== Entrada externas a Subroutina =====

sub_2:
	pushf				; Empuja banderas
	push	ax			; y registros
	push	bx			; en la pila
	push	cx
	push	si
	push	di

	mov	si,[bx+2]		; Guarda enlaces
	mov	di,[bx+4]
	or	di,di			; Prueba si es al frente
	jnz	loc_11			;
	mov	ds:data_1e,si		; Pone nuevo inicio de la lista
	jmp	loc_12			;
loc_11:
	mov	[di+2],si               ; Pasa al siguiente elemento
loc_12:
	or	si,si			; prueba si no es el final
	jz	loc_13			;
	mov	[si+4],di		;
loc_13:
	mov	ax,0                  	;
	mov	[bx+2],ax               ;
	mov	[bx+4],ax               ;
	jmp	loc_15			;

; ===== Entrada externas a Subroutina =====
; Inserta un tarea en la lista de alarmas para el reloj
;
;	Parametros
;		DS:BX 	apunta al campo de alarma de la tarea
;		CX	contiene el numero de "pulsaciones del reloj"
;			solicitadas
sub_3:
	pushf				; Empuja banderas
	push	ax			; y registros en la pila
	push	bx
	push	cx
	push	si
	push	di

	test	word ptr [bx],0FFFFh	; Prueba si la tarea ya esta insertada
					; en la fila de alarmas
	jnz	loc_15			; No insertar a la tarea (ciclicas)
	mov	si,ds:data_7e		; SI apunta a la cabeza de la lista de
					; alarmas
	or	si,si			; Prueba si esta vacia
	jz	loc_17			; Si esta vacia, inserta y salta
	mov	ax,ds:data_6e		; AX Toma el valor de proxima alarma
	sub	ax,cx			; Prueba si el valor solicitado de alarma
					; es menor o igual de proxima alarma
	jnc	loc_18			; Salta si la posicion es al frente
	mov	cx,ax			; CX contiene ajuste con proxima alarma
	mov	ax,[si]			; AX valor de alarma de tarea a la cabeza
					;
	sub	ax,cx                  	;  %^%$^%$%^ ax contiene valor revisar
	mov	[bx],ax			; Guarda el valor efectivo de alarma
					; considerando el tiempo de alarma
					; que ha pasado desde que sono la ulti-
					; ma alarma
loc_14:
	mov	di,si			; Respalda apuntador a la cabeza para
					; buscar posicion de tarea
	mov	si,[di+2]		; Recorre la lista
	or	si,si			; Prueba si esta al final de la lista
	jz	loc_16			; Salta inserta al final de la lista
	cmp	[si],ax			; Prueba si valor de solicitud de alarma
					; es menor a tarea en esta posicion
	jb	loc_14			; Si no continua buscando posicion

					; Inserta posicion intermedia
	mov	[di+2],bx		; Enlace hacia adelante tarea en lista
	mov	[si+4],bx		; Enlace hacia atras de tarea en lista
	mov	[bx+2],si		;  " "   hacia adelante de tarea insertada
	mov	[bx+4],di		; Enlace hacia atras de tarea insertar

loc_15:
epilogo:
	pop	di			; Epilogo de subrutina 1 y 3
	pop	si			; Recupera registros
	pop	cx
	pop	bx
	pop	ax
	popf				; y banderas de la pila
	retn
loc_16:
alarmaFinal:
	mov	[di+2],bx		; Enlace hacia adelate ultima tarea
	mov	[bx+4],di		; Enlace hacia atras tarea a insertar
	jmp	short loc_15		; Salta epilogo

loc_17:
alarmaVacia:
	mov	ds:data_7e,bx		; Actualiza cabeza de lista de alarmas
	mov	[bx],cx			; Pon valor de alarma de tarea
	mov	ds:data_6e,cx		; Actualiza valor de proxima alarma
	jmp	short loc_15		; Salta epilogo
loc_18:
InsercionFrente:
	mov	ds:data_6e,cx		; Actualiza valor de proxima alarma
	mov	cx,ax			; Actualiza pulso de reloj de la tarea
	mov	ax,[si] 		; que estaba al principio de la lista
					; pulsos de reloj transcurrido menos
					; nuevo valor de proxima alarma
	sub	ax,cx			; %%%%%#$#$
	mov	[bx],ax			; &*&^*&^  revisar
	mov	[si+4],bx		; Enlace hacia atras de tarea en lista
	mov	[bx+2],si          	; Enlacia hacia adenlante tarea a
					; insertar
	mov	ds:data_7e,bx		; Actualiza cabeza de lista de alarmas
	jmp	short loc_15		; Salta epilogo
sub_1	endp

; ===== Entrada externas a Subroutina  4 =====
; Elimina una tarea de la cola de alarma cuando recibe senal o mensaje
;
;	Parametros
;		DS:BX 	apunta al campo de alarma de la tarea

sub_4	proc	near
	pushf				; Empuja a la pila bandera
	push	ax			; y registros
	push	bx
	push	cx
	push	si
	push	di
	; Guarda los enlaces hacia atras y adenlante de la tarea a eliminar
	mov	di,[bx+4]		; Enlace hacia atras
	mov	si,[bx+2]		; Enlace hacia adelante
	; Prueba si la tarea a eliminar esta al inicio de la fila
	or	di,di			; Prueba enlace hacia atras
	jnz	loc_20			; Salta si no al inicio de la fila
	; Eliminacion al inicio de la fila
	mov	ds:data_7e,si		; Actualiza cabeza de lista de alarmas
	or	si,si			; Prueba si la lista esta vacia
	jnz	loc_19			; Salta si la lista no esta vacia
	; La lista solo contenia la tarea que se ha eliminado
	xor	ax,ax			; Borra el valor del registro AX
	mov	[bx],ax			; Borra el valor de alarma de tarea
	mov	ds:data_6e,ax		; Borra el valor de proxima alarma
	jmp	loc_15			; Salta al final de la subrutina
	; Eliminacion al inicio de la lista
loc_19:
eliminaInic:
	mov	ax,ds:data_6e		; Obtiene el valor de proxima alarma
	sub	ax,[bx]			; Le resta el valor por el cual estaba
					; esperando la tarea, el resultado es un
					; valor negativo.
	add	ax,[si]			; Se los suma a la nueva tarea al inicio
					; de la lista para obtener valor proxima
					; alarma
	mov	ds:data_6e,ax		; Se actualiza proxima alarma
	xor	ax,ax			; Borra el registro AX
	; borra el valor de alarma y los enlace de la tarea a eliminar
	mov	[bx],ax                 ; borra el valor de alarma
	mov	[bx+2],ax		; borra el enlace siguiente
	mov	[si+4],ax		; borra el enlace anterior de la nueva
					; tarea a inicio de la lista de alarmas
	jmp	loc_15			; Salta al final de la subrutina

	; Eliminacion intermedia o al final de la lista
loc_20:
eliminaInter:
	or	si,si			; Prueba si esta al final de la lista
	jz	loc_21			; Salta si esta al final de la lista
	; Eliminacion intermedia
	mov	[di+2],si    		; Enlace de tarea siguiente
	mov	[si+4],di		; Enlace de tarea anterior
	; borra el valor de alarma y los enlace de la tarea a eliminar
	mov	ax,0			; borra el valor del registro AX
	mov	[bx],ax			; borra el valor de alarma
	mov	[bx+2],ax		; borra enlace siguiente
	mov	[bx+4],ax		; borra enlace anterior
	jmp	loc_15			; Salta al final de la subrutina
	; Eliminacion al final de lista
loc_21:
eliminaFinal:
	xor	ax,ax			; Borra el contenido del registro AX
	mov	[di+2],ax		; borra el enlace siguiete de la ultima
					; tarea en la lista
	mov	[bx+4],ax		; borra el enlace anterior de la tarea
					; que se elimina
	mov	[bx],ax			; borra el valor de alarma
	jmp	loc_15			; salta al final de la subrutina
sub_4		endp

	end
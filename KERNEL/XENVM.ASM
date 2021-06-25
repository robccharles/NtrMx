;	Archivo Fuente 		xenvm.asm
;  
; 	Objetivo		Envio de un mensaje
;
;	Revision		22/Nov/1992
;
;				Herrera Charles Roberto  

	DOSSEG
	MODEL   tiny
        	include  ..\h\constant.asm

	DATASEG
	EXTRN	loc_3:near, sub_4:near
	PUBLIC  loc_108, _xenvm

	CODESEG
loc_108:
_xenvm:
	;principia primitiva XENVM
	push 	ds 			; prologo
	push 	es
	push 	ax
	push 	bx
	push 	cx

	; Calcula la direccion del buzon
	mov  	ax,bx
	shl  	bx,1           		; NUMBAL*2
	shl 	bx,1           		; NUMBAL*4
	shl  	bx,1           		; NUMBAL*8
	sub  	bx,ax          		; NUMBAL*7
	shl  	bx,1           		; NUMBAL*14
	mov  	ds,cs:data_16e 		; Obtiene la ZDS
	add  	bx,ds:data_11e 		; BX apunta al buzon solicitado
loc_109:                            	;
	;  borra los enlaces del mensaje (para lista de mensajes)
	xchg 	bx,dx          		; intercambia ptr buzon y mensaje
	mov  	word ptr es:[bx],0  	; borra enlace mensaje sig
	mov  	word ptr es:[bx+2],0	; borra enlace mensaje ant

	; guarda en el mensaje el descriptor de c¢digo de la
	;tarea emisora
	mov  	ax,ds:data_4e       	; Obtiene ptr tarea en
					; ejecuci¢n
	sub  	ax,18h              	; ax apunta al inicio del
					; descritor de la tarea (desp tarea)
	mov  	es:[bx+4],ax   		; Copia desp tarea en mensaje[4]
	xchg 	bx,dx          		; Intercambia ptr mensaje y buzon

	; prueba la lista de tarea que esperan este mensaje
	mov  	ax,es          		; copia ax seg del mensaje
	test 	word ptr [bx+4],0FFFFh  ; prueba ptr tarea
					; final en buz¢n
	jnz  loc_112         		; Salta si hay tareas esperando
	; no hay tareas esperando el mensaje
	; enlaza  apuntador de mensaje final en buz¢n
	mov  	cx,dx          		; copia cx ptr mensaje
		; copia e intercambia ptr y campos del buzon
	xchg 	dx,[bx+6] 		; ptr mensaje y offset ptr mensaje final
	xchg 	ax,[bx+8] 		; ptr seg mensaje y offset ptr seg
					; mensaje final
	; prueba si habia otro mensaje el la cola
	push 	ax             		; salva seg del mensaje en la pila
	or   	ax,dx          		; enmascara ptr mensaje off y seg
	pop  	ax             		; recupera ptr seg mensaje (N/C
					; banderas)
	jz   	loc_111         	; Salta si la cola de mensajes
					; esta vacia
	; hay mas mensaje en la cola por lo tanto
	; actualiza apuntador a mensaje final.
	mov  	bx,dx          		; bx ptr mensaje final de la cola
	mov  	dx,es          		; dx ptr seg de mensaje
	mov  	es,ax          		; es ptr seg mensaje final en la
					;cola

		; Enlaza en nuevo mensaje a la cola
	mov  	es:[bx],cx     		; copia en mensaje final off
					; nuevo mensaje
	mov  	es:[bx+2],dx   		; copia en mensaje final seg
					; nuevo mensaje
	mov  	dx,cx          		; dx tiene el ptr off mensaje
	; epilogo de la primitiva
loc_110:                       		;
retorno:
	pop  	cx
	pop  	bx
	pop  	ax
	pop  	es
	pop  	ds
	iret                		; Retorno de interrupciones


	; La cola de mensaje tiene un solo elemento
	; por lo tanto el apuntador final y inicial de mensaje
	; son iguales
loc_111:                       		;
sinMensaje:
	mov  	[bx+0Ah],cx    		; copia off ptr mensaje inicial
	mov  	[bx+0Ch],es    		; copia seg ptr mensaje inicial
	mov  	dx,cx          		; dx ptr mensaje
	jmp  	loc_110         	; retorna de interrupciones

	; Hay tarea esperando este mensaje entonces debe
	; de eliminarse  la tarea al final la cola y en
	; sus registros ES:DX copiar el apuntador del mensaje
loc_112:                            	;
esperaMensaje:
	; prepara cambio de contexto
	push 	dx
	push 	bp
	push 	si
	push 	di
	; guarda la pila de tarea en ejecuci¢n
	; no cambia la pila al sistema por que es seguro que
	; una tarea se activara.
	mov  	di,ds:data_16 		; Obtiene ptr tarea en ejecuci¢n
	sub  	di,4           		; apunta pila de la tarea
	mov  	[di],sp        		; Guarda SP
	mov  	[di+2],ss      		; Guarda SS
	; Toma apuntador de tarea inicial
	mov  	si,[bx+4]      		; SI tiene ptr tarea inicial
	xor  	cx,cx          		; borra cx
	mov  	[si],cx        		; borra ptr comunicaci¢n
	mov  	di,cx          		; borra di
	xchg 	di,[si+4]      		; intercambia nulo y enlace tarea
					; siguiente
	; Cambia el estado de tarea a activo
	or   	byte ptr [si+0Ch],1
	;  Pruebas si hay mas tareas esperando este mensaje
	or   	di,di          		; prueba enlace de tarea siguiente
	jz   	loc_113        		; Salta si no hay tarea
	;  Hay mas tareas esperando por lo que borra enlace
	;  tarea anterior (en descriptor tarea final)
	mov  	[di+6],cx      		; borra enlace tarea anterior
	jmp  	short loc_114  		;

	; borra apuntadore tarea final y inicial en buz¢n
loc_113:                       		;
sinTareas:
	mov  	[bx+2],di      		; borra ptr tarea final en buz¢n
loc_114:                       		;
conTareas:
	mov  	[bx+4],di      		; borra ptr tarea inicial en buz¢n
	; copia apuntador del mensaje en los registros ES:DX
	; en la pila de tarea que recibio el mensaje
	mov  	ax,es          		; ax es ptr del seg del mensaje
	les  	di,dword ptr [si+8] 	; carga apuntador de pila de
					;registros de la tarea al
					;final de la cola
	mov  	es:[di+0Eh],ax 		; copia seg mensaje en reg ES
	mov  	es:[di+6],dx   		; copia off mensaje en reg DX
	; Elimina la tarea de la cola de alarmas
	mov  	bx,si          		; bx es ptr de comunicaci¢n
	sub  	bx,6           		; bx apunta al campo de alarma
	test 	word ptr [bx],0FFFFh	; Prueba la alarma
	jz   	loc_115        		; Salta si la alarma en nula
	test byte ptr [bx+12h],40h    	; Prueba estado c¡clico
	jnz  	loc_115             	; No la elimina si es ciclica
	call 	sub_4    		; Se elimina de la cola de alarmas
loc_115:                       		;
sinAlarma:
	jmp 	loc_3          		; Salta a la primitiva START

	end



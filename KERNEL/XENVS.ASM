;	Archivo Fuente 		xenvs.asm
;
; 	Objetivo		Envia una se¤al
;
;	Revision		18/Nov/1992
;
;				Herrera Charles Roberto

	DOSSEG
	MODEL   tiny
	include  ..\h\constant.asm

	DATASEG

	PASANTE		EQU 	0FDh
	IMPULSO		EQU	02
	ACTIVA		EQU	01
	CICLO		EQU	40h

	EXTRN	loc_3:near
	EXTRN	sub_4:near
	public loc_100
	CODESEG

loc_97:
esperaSenal:
          ; Hay tareas que esta esperando esta se¤al.

	push 	cx  			; guarda el resto del contexto para
	push 	dx			; preparacion de cambio de contexto
	push 	bp
	push 	si
	push 	di

	mov  	di,ds:data_16      	; Obtiene PRT de tarea en
					;ejecuci¢n
	; Guarda el apuntador de la pila de la tarea en
	; ejecucion y compia a la pila del sistema(kernel)
	sub  	di,4                	; di apunta a campo SS:SP
	mov  	[di],sp             	; Guarda SP
	mov 	[di+2],ss           	; Guarda SS
	mov  	ax,ds               	; SS apunta a ZDS
	mov  	ss,ax               	;
	mov  	sp,0D4h             	; SP pila del sistema
	; Obtiene el apuntador al final lista y borra los
	; enlaces de la se¤al de la tareas que esta al final de la lista
	mov  	di,[bx+4]           	; Obtiene de la se¤al el PTR
					; a la tarea final de la lista
	mov  	ax,0                	; Borra los PTR de la tarea
	mov  	[bx+2],ax           	; al principio de la cola
	mov  	[bx+4],ax           	; al final de la cola
	; Borra los enlaces de la siguiente tarea y pone en
	; estado activo la tarea que esperaba la se¤al
loc_98:                            	;
eliminaTarea:
	xor  	ax,ax               	; Borra los enlaces de tarea
	mov  	[di],ax             	; PTR de comunicacion
	mov  	[di+6],ax           	; enlace de comunicacion anterior
	or   	word ptr [di+0Ch],ACTIVA ; activa la tarea
	; Elimina a la tarea de la cola de alarma si ella esperaba
	; la se¤al con espera m xima (o alarma)
	mov  	bx,di               	; Guarda temporalmente PTR de
					;la se¤al
	sub  	bx,6                	; Apunta a la alarma de tarea
	test 	word ptr [bx],0FFFFh 	; Espera Alarma
	jz   	loc_99              	; Salta si No espera alarma
	test 	byte ptr [bx+12h],CICLO	; Es tarea ciclica
	jnz  	loc_99              	; Salta si es tarea ciclica
	call 	sub_4               	; Se elimina la tarea de la
					; cola de alarmas
	; Prueba si hay mas tareas que esperan esta se¤al
loc_99:					;
sinAlarma:
	xchg 	ax,[di+4]           	; Borra enlace siguiente
	or   	ax,ax               	; Prueba si enlace siguiente
	mov  	di,ax               	; es nulo y lo copia en di
	jnz  	loc_98              	; Si no cero elimina la tarea
					; de cola de tareas que
					; esperan esta se¤al
	jmp  	loc_3               	; Fin de la lista y de la
					; primitiva

loc_100:
xenvs:
	push 	ds			;prologo
					;principio de primitiva XENVS
	push 	es
	push 	ax
	push 	bx
	; obtiene apuntador de la se¤al
	shl  	bx,1           		; NUNSIG*2
	mov  	ax,bx          		; respalda NUMSIG*2
	shl  	bx,1           		; NUNSIG*4
	add  	bx,ax          		; NUMSIG*6
	mov  	ds,cs:data_16e      	; Obtiene la ZDS
	add  	bx,ds:data_10e      	; BX apunta a la se¤al(NUMSIG)
	; Cambia el estado de la se¤al
;	and  	byte ptr [bx],PASANTE 	; pone se¤al pasante
	or	byte ptr [bx],IMPULSO	; pone la se¤al como impulso
	or   	byte ptr [bx],ACTIVA 	; pone la se¤al activa
	; Prueba la cola de tareas que esperan la se¤al

	test 	word ptr [bx+4],0FFFFh  ; prueba PTR final
	jnz  	loc_97              	;Si la cola no esta vacia
	; termina primitiva
	pop  	bx			; epilogo
	pop  	ax
	pop  	es
	pop 	ds
	iret                     	; returna de Interrupcion

	end














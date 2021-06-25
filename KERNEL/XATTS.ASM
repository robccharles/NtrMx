;	Archivo Fuente 		xatts.asm
;
; 	Objetivo		Espera de una se¤al
;
;	Revision		18/Nov/1992
;
;				Herrera Charles Roberto

	DOSSEG
	MODEL   tiny
        	include  ..\h\constant.asm

	DATASEG
	ACTIVA	EQU 01h
	EXTRN	loc_3:near
	EXTRN	sub_3:near
	public	loc_101, loc_104

	CODESEG
loc_101:
xatts:

	push 	ds			;principio de la primitiva XATTS
	push 	es             		;prologo
	push 	ax
	push 	bx
	mov  	ds,cs:data_16e 		; Obtiene la ZDS
	; Borra la bandera de acarreo
	xchg 	bx,sp
	and  	word ptr ss:[bx+0Ch],0FFFEh; Borra el acarreo de la tarea que
					; recibe la senal
	xchg 	bx,sp

	;  Calcula de apuntador de se¤al
	shl  	bx,1           		; NUMSIG*2
	mov  	ax,bx
	shl  	bx,1           		; NUMSIG*4
	add  	bx,ax          		; NUMSIG*6
	add  	bx,ds:data_10e 		; BASESIG+NUSIG*6

	; Prueba si la se¤al es activa
loc_102:                            	;
	test 	byte ptr [bx],ACTIVA 	; prueba si la se¤al esta activa
	jz   	loc_104              	; Salta si no esta activa
	; Prueba si la se¤al es un impulso
	test 	byte ptr [bx],2
	jz   	loc_103              	; Salta si no es impulso
	and  	byte ptr [bx],0FEh  	; Borra el impulso
loc_103:                            	; Epilogo
noImpulso:
	pop  	bx			; Epilogo
	pop  	ax
	pop  	es
	pop  	ds
	iret                     	; retorno de Interrupcion

	;Tratamiento de la se¤al bloqueada (Espera de la se¤al)
loc_104:                            	;
noActiva:
	push 	cx                  	; Guarda contexto
	push 	dx
	push 	bp
	push 	si
	push 	di
	; Bloquea la tarea que solicito la espera de la se¤al
	mov  	di,bx             	; respalda apuntador se¤al
	mov  	bx,ds:data_16      	; Obtiene apuntado de tarea
					; en ejecucion, direccion cero
	and  	byte ptr [bx],0FEh  	; Cambia el estado a bloqueada
	; Cambia de pila: de la tarea a la del sistema
	sub  bx,4                	; bx apuntador de la pila de
					; la tarea
	mov  	[bx],sp             	; Guarda SP
	mov  	[bx+2],ss           	; Guarda SS
	mov  	ax,ds               	;
	mov  	ss,ax               	; Pone SS a ZDS
	mov  	sp,0D4h             	;
	; Determina si se solicito espera con alarma
	or   	cx,cx               	; prueba si TIMEOUT es cero
	jnz  	loc_107              	; Salta si solicito tiempo
					; de alarma

	; Inserta la tarea al frente de la cola de tareas que esperan la se¤al
	sub  bx,8                	; Apunta a PTR de comunicacion
loc_105:                            	;
insertaLista:
	mov  	[bx],di             	; Guarda apuntador de se¤al
	mov  	si,bx               	; copia apuntador PTR comunicacion
	xchg 	si,[di+2]           	; Pone enlace tarea inicial(frente)
	or   	si,si               	; Prueba si hay mas elemento
					; en la lista
	jz   	loc_106              	; Salta si no mas elementos
	mov  	[si+4],bx           	; Pone enlace tarea siguiente
	mov  	[bx+6],si           	; Pone enlace tarea anterior
	jmp  	loc_3               	; Salta a primitiva START
	; Caso lista vacia y solo se ha insertado un elemento
loc_106:				;
listaVacia:
	mov  	[di+4],bx           	; Pone enlace final(una sola tarea)
	jmp  	loc_3               	; Salta a primitiva START

	; Inserta la tarea en la cola de espera de alarmas
loc_107:				;
conAlarma:
	sub  	bx,0Eh              	; bx apunta a campo de
					; alarma en el descriptor de
					; la tarea
	call 	sub_3               	; Subrutina que inserta a
					; tarea en la cola de alarmas
	add  	bx,6                	; Apunta a PTR de comunicacion
	jmp  	short loc_105        	; Continua insercion en
					; espera de se¤al
	end

















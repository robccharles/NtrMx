;	Archivo Fuente 		xattm.asm
;
; 	Objetivo		Espera de un mensaje
;
;	Revision		22/Nov/1992
;
;				Herrera Charles Roberto

	DOSSEG
	MODEL   tiny
        	include  ..\h\constant.asm

	DATASEG

		EXTRN loc_104:near
		PUBLIC loc_116
	CODESEG
loc_116:
_xattm:
	;principia primitiva XATTM
	push 	ds			; prologo
	push 	es
	push 	ax
	push 	bx
	; borra la bandera de acarreo
	xchg 	bx,sp          		; intercambia NUMBAL y SP
	and  	word ptr ss:[bx+0Ch],0FFFEh ; Cambia reg de bandera(acarreo)
	xchg 	bx,sp          		; intercambia SP y NUMBAL

	; obtiene la direccion del buz¢n
	mov  	ds,cs:data_16e 		; Obtiene ZDS
	mov  	ax,bx          		; ax = NUMBAL (numero de buzon)
	shl  	bx,1           		; NUMBAL*2
	shl  	bx,1           		; NUMBAL*4
	shl  	bx,1           		; NUMBAL*8
	sub  	bx,ax          		; NUMBAL*7
	shl  	bx,1           		; NUMBAL*14
	add  	bx,ds:data_11e 		; bx es ptr del buzon NUMBAL

	; Prueba el estado de la lista de mensajes
	; y toma el apuntador de mensaje final en buzon ax:dx
loc_117:                       		;
	mov  	dx,[bx+0Ah]    		; dx es ptr off mensaje inicial
	mov  	ax,[bx+0Ch]    		; ax es ptr seg mensaje inicial
	cmp  	ax,dx          		; prueba si seg no es igual al off
	jne  	loc_118        		; Salta si cola de mensaje no esta
					; vacia
	or   	ax,ax          		; Prueba si seg y off son nulos
	jz  	loc_120        		; Salta si la cola esta vacia

	; hay mensajes en la lista. Elimina el mensaje al
	; inicio de la cola
loc_118:                       		;
tomaMensaje:
	; Toma enlace siguiente mensaje en la  lista de mensaje
	push 	ax            		; Guarda seg mensaje
	mov  	es,ax          		; ES es ptr seg mensaje
	xchg 	bx,dx          		; intercambia ptr mensaje y ptr
					; mensaje inicial
	les  	ax,dword ptr es:[bx]    ; Carga en ES:AX ptr de
					; mensaje siguiente
	xchg 	bx,dx          		; intercambia ptr mensaje inicial
					; y ptr mensaje

	; Pone el nuevo valor de mensaje inicial en la lista
	; de mesajes dentro del buz¢n
	mov  	[bx+0Ah],ax    		; Guarda off de mensaje
	mov  	[bx+0Ch],es    		; Guarda seg de mensaje
	; prueba si la lista de mensaje esta vacia
	or   	ax,[bx+0Ch]    		; enmascara seg y off del mensaje
	jnz  	loc_119         	; Salta si cola no esta vacia
	; borra el apuntador mensaje final
	mov  	[bx+6],ax      		; borra ptr off mensaje final
	mov  	[bx+8],ax      		; borra ptr seg mensaje final
loc_119:                       		;
masMensajes:
	; epilogo no recupera el valor es
	pop  	es             		; recupera el ptr seg del mensaje
	pop  	bx             		; recupera bx
	pop  	ax             		; recupera ax
	add  	sp,2           		; debe recupera es (lo salta)
	pop  	ds             		; recupera ds
	iret                		; Retorno interrupci¢n

; el codigo continua en la primitiva XATTS, codigo comun para amba primitivas
;
;    Se inserta la tarea a la fila de tareas que esperan mensaje en
; 	este buzon
loc_120:  				;
insertaEspera:
	jmp  	loc_104        		; Continua en tratamiento igua
					; que la primitiva XATTS
	end



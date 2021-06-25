;	Archivo Fuente 		esigit.asm
;
; 	Objetivo		Envio de un impulso particular de una de
;				un manejador de interrupciones
;
;
;	Revision		13/Mar/1993
;
;				Herrera Charles Roberto

	DOSSEG
	MODEL   tiny

	include  ..\h\constant.asm



	DATASEG

	EXTRN sub_4:near
	PUBLIC loc_83

	CODESEG

loc_83:
_esigit:

          ;inicia la primitiva ESIGIT
	push 	ds				; prologo
	push 	bx
	push 	ax

	  ; Calcula el apuntador del n£mero de se¤al NUMSIG
	mov  	ds,cs:data_16e 		; Obtiene ZDS
	shl  	bx,1           		; NUMSIG*2
	mov  	ax,bx
	shl  	bx,1           		; NUMSIG*4
	add  	bx,ax
	add  	bx,ds:data_10e 		;bx apunta a la se¤al NUMSIG

          ; prueba el estado de la fila de espera de esta se¤al
          test word ptr [bx+4],0FFFFh
	  jnz  loc_84         		; Salta si la lista no esta vacia
          ; Si la lista esta vacia cambia el estado de la se¤al
	  or   byte ptr [bx],3 		; El estado de la se¤al es impulso

	  pop  ax        		; epilogo
          pop  bx
          pop  ds
	  iret           		; retorno de interrupci¢n



	  ; Hay tarea que esta esperando esta se¤al
loc_84:
      push 	si        		; Guarda contexto
      push 	di

      ; Elimina la ultima tarea de la lista de espera
      mov  	di,[bx+4] 		; Toma el apuntador a tarea final
      mov  	ax,0
      mov  	[di],ax   		; Borra PTR de comunicaci¢n
      mov  	[di+2],ax 		; Borra enlace siguiente tarea
      inc  	word ptr ds:data_19e    ; Cambia de se¤al de
                                        ;impulso de Interrupci¢n
      or   	word ptr [di+0Ch],1     ; activa la tarea



	; Revisa si hay mas tareas esperando esta se¤al
	mov  	si,[di+4] 		; Copia enlace tarea anterior
	or   	si,si     		; Prueba si es cero
	jz   	loc_87    		; Si no hay mas tareas salta
	;  Restablece los nuevos enlaces de la lista
	mov  	[di+4],ax 		;
	mov  	[si+6],ax
	mov  	[bx+4],si

	; Elimina la tarea de la cola de alarmas
loc_85:                            	;
	sub  	di,6      		; apunta a el campo de alarmas
	mov  	bx,di     		; lo copia en bx
	test 	word ptr [bx],0FFFFh	; prueba si alarma cero
	jz   	loc_86              	; Salta si no tiene alarma
	test 	byte ptr [bx+12h],40h 	; prueba si es tarea c¡clica
	jnz  	loc_86              	; Salta si no
	call 	sub_4     		; Elimina la tarea de cola de alarmas


loc_86:                  		;
	pop  	di        		; epilogo
	pop  	si
	pop  	ax
	pop  	bx
	pop  	ds
	iret           			; retorno de Interrupcion
          ; Borra enlaces de la se¤al si fila de espera vacia
loc_87:                  		;
	mov  	[bx+2],ax 		; Borra apuntador tarea inicial
	mov  	[bx+4],ax 		; Borra apuntador tarea final
	jmp  	loc_85    		; Va a eliminacion de cola de alarmas

	end




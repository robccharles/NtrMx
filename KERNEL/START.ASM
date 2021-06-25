

	DOSSEG
	MODEL   tiny

	include  ..\h\constant.asm

	DATASEG

	PtrAct		equ	00h	; Apuntador de prioridad
	Kernel		equ	0C2h	; Modo kernel
	PilaKernel	equ	9ch	; Pila del kernel

	CODESEG

	PUBLIC	_start
	PUBLIC 	loc_3 , loc_2, despachador



 ; C¢digo de la primitiva "START"

loc_2:
_start:
	mov	ds, cs:data_16e 	; obtiene zona de datos del sistema
loc_3:
despachador:
	mov	bx,ds:data_5e		; Apuntador inicial de lista de
					; prioridades
					; Punto de entrada de las
					; primitivas que solicitan cambio
					; de contexto

loc_4:
sigTarea:
	mov   al,[bx]           	; Prueba el estado de la tarea
	and   al,91h            	;  en la cola de prioridades
	dec   al                	;
	jz    _activa           	; Si esta lista la ejecuta
	mov   bx,[bx+2]         	; No lista recorre la cola
	or    bx,bx             	;
	jnz   loc_4             	; Si ninguna tarea activa
	mov   word ptr ds:PtrAct,02Ch   ;
	mov   sp,94h                	; Cambia de la pila de la tarea
	mov   ax,ds                 	;  a la pila del sistema
	mov   ss,ax                     ;
	sti				; Habilita interrupciones
_aqui:                                  ; c¢digo equivalente de la
	jmp   short _aqui               ; instrucci¢n HALT(sola sale por
					; un evento externo, interrupci¢n)
_activa:                                ; Inicia recuperaci¢n de contexto
	mov  ds:PtrAct,bx           	; Indica que tarea se encuentra
					; activo
	les    sp,dword ptr[bx-4]       ; Cambia de pila para la nueva
					; tarea
        mov   ax,es
        mov   ss,ax

	pop   di                    	; Inicia la restituci¢n de
					; registros, para cambio de
					; contexto
	pop   si                    	; restituye si
	pop   bp                    	; restituye bp
	pop   dx                    	; restituye dx
	pop   cx                    	; restituye cx
	pop   bx                    	; restituye bx
	pop   ax                    	; restituye ax
	pop   es                    	; restituye es
	pop   ds                    	; restituye ds
	iret                            ; regresa a la tarea

	end _start


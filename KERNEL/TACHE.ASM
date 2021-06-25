;	Archivo Fuente 		tache.asm
;
; 	Objetivo		Solicitud de la creacion de una tarea
;
;
;	Revision                11/Nov/1992
;				13/Mar/1993
;
;				Herrera Charles Roberto

	DOSSEG
	MODEL   tiny

	include  ..\h\constant.asm


	TAREAS_DES 	equ 	200h	; Direccion de inicio de des-
					; criptores de tarea
	TAM_DES         equ     40h	; Tama¤o del descriptor
	TAM_SP		equ	18h	; Tama¤o del contexto de la pila


	DATASEG


	CODESEG

	EXTRN 	sub_1 : near
	PUBLIC	crea_tarea , loc_121

;_crea_tarea:
loc_121:
crea_tarea:			; Guarda Contexto de tarea en ejecuci¢n
	push ax         	; guarda el registros en la pila
	push bx
	push cx
	push dx
	push bp
	push si
	push di
	push ds
	push es

	push bx          	; guarda direcci¢n off par(parametros)

	mov  ds,cs:data_16e 	; obtiene zona de datos del sistema
	mov  bx,200h        	; inicia descriptores de tareas

	; Busca  espacio libre para nuevo descriptor de tarea

	mov  cx,ds:data_9e  	; valor del numero de tareas
loc_122:
busca_esp:
	mov  ax,[bx]        	; prueba si el descriptor de tarea
	or   ax,[bx+2]      	; esta vacio (disponible)
	jz   loc_124        	; si cero termina busqueda
	add  bx,40h         	; pasa al siguiente descriptor
	dec  cx             	; decrementa el contador de tareas
	jnz  loc_122       	; si no cero, continua la busqueda de espacio
	pop  bx             	; No hay espacio, sale sin crear tarea
loc_123:
ret_prim:
	pop  es             	; recupera registros en la pila
	pop  ds
	pop  di
	pop  si
	pop  bp
	pop  dx
	pop  cx
	pop  bx
	pop  ax
	iret                	; retorno de interrupci¢n
loc_124:
llena_des:

	;    Llena el descriptor de tarea con el bloque de creaci¢n
	;    tarea(BCT)
	pop  si             	; copia off BCT en SI
	mov  ax,es:[si]     	; Inicializa offset Bloque Descrip-
	mov  [bx],ax        	; tor de Codigo(DBC)
	mov  ax,es:[si+2]   	; Inicializa seg BDC
	mov  [bx+2],ax      	;  en descriptor de tarea
	mov  ax,es:[si+4]   	; Inicializa N£mero de tarea
	mov  [bx+4],ax      	;  en descriptor de tarea
	mov  ax,es:[si+6]   	; Inicializa Estado inicial
	mov  [bx+18h],ax    	;  en descriptor de tarea
	mov  bp,es:[si+2]   	; Copia seg BDC en BP
	mov  di,es:[si]     	; Copia off BDC en SI
	mov  ax,es          	; Respalda seg off par en AX
	mov  es,bp          	; ES es ahora seg BDC

	; guarda temporalmente en la pila para posterior uso

	push word ptr es:[di] 	; Pone en Pila seg c¢digo ent.
	push word ptr es:[di+2] ; Pone en Pila off c¢digo ent.

	; Inicializa el valor de la pila del proceso

	mov  bp,es:[di+6]  	; Toma la longitud de la pila
	sub  bp,18h       	; Da espacio contexto regs.
	mov  [bx+14h],bp 	; Inicializa off la pila tarea
	mov  es,ax     		; ES es ahora seg BCT
	mov  ax,es:[si+8]       ; Inicializa seg la pila tarea
	mov  [bx+16h],ax        ; en descriptor de la tarea
	mov  di,es              ; copia seg BCT en DI

	;    construye el contexto de registros en la pila
               ;simulando que fueron llamados de una
	       ;interrupcion.

	mov  es,ax           	; ES apunta al segmento de
				;pila de la tarea (SS)
	pop  word ptr es:[bp+12h];pone pila-tarea seg c¢digo
	pop  word ptr es:[bp+14h];pone pila-tarea off c¢digo
	mov  word ptr es:[bp+16h],200h; banderas Int habilitadas
	mov  ax,es               ;respalda en AX seg pila-tarea
	mov  es,di               ;ES es ahora seg BCT
	push word ptr es:[si+0Ah];Pone en la pila DS tarea
	push word ptr es:[si+0Ch];Pone en la pila ES tarea
	mov  di,es:[si+0Eh]      ;Obtiene apuntador bloque reg.
	mov  dl,7                ;N£mero de registro en bloque
		    ; Inicializa registros en la pila de la tarea

 loc_125:           ; Los pone en la pila temporalmente
 reg_pila:
	push word ptr es:[di]    ;Guarda en la pila reg
	add  di,2                ;pasa siguiente reg
	dec  dl                  ;Decrementa contador
	jnz  loc_125             ;Salta si no es el £ltimo

	mov  es,ax               ; Es es ahora seg pila-tarea
	mov  dl,7                ; N£mero de registros

loc_126:            ; Los recupera de la pila
sig_reg:
	pop  word ptr es:[bp]    ; Pone pila-tarea registro
	add  bp,2                ; Pasa siguiente reg
	dec  dl                  ; Decrementa contador
	jnz  loc_126             ; Salta si no es el ultimo

 
	pop  word ptr es:[bp]    ; Pone pila-tarea DS
	pop  word ptr es:[bp+2]  ; Pone pita-tare  ES

	; Inserta tarea en lista de prioridad

	add  bx,5                ; BX apunta prioridad
	call sub_1               ; Inserta tarea
	jmp  loc_123             ; regreso de primitiva

	end crea_tarea 
;	Archivo Fuente 		inisys.asm
;
; 	Objetivo		Inicializacion de tablas y constantes del
;				Nucleo de tiempo Real MX
;
;
;	Revision		18/Nov/1993
;
;				Herrera Charles Roberto

; Nota:  Se deben incluir todos los manejadores de interrupciones
;	 Parametros
;
;		NTCH	Numero de tareas
;		NSIG	 "  "  de se¤ales
;		NBAL	 "  "  de buzones
;		NBAN     "  "  de banderas  
;		NPOOL    "  "  de pozos
;


	DOSSEG
	MODEL   tiny

	include  ..\h\constant.asm

	DATASEG

	CODESEG

	PUBLIC	inisys, loc_127

	TAM_DES		equ	40h	; Tama¤o del descriptor de tarea
	ESP_NUCLEO      equ	200h	; Espacio reservado para el nucleo

	EXTRN	int_div0 : near, int_1:near,int_3:near, int_ov:near
	EXTRN	int_5:near, int_6:near

loc_127:
inisys:

	push    si     			; Guarda registros (cambio de contexto)
	push    dx
	push    bx
	push    cx
	push    ax
	push    di
	push    bp
	push    es
	push    ds

	mov     ax,cs:data_16e   	; obtine la zona de datos
					; del sistema
	mov     es,ax            	; Guarda ES ZDS
	mov     ds,ax            	; Actualiza DS con ZDS
	mov     bp,dx           	; guarda temporalmete NBAL
	push    cx               	; guarda NTCH en la pila
	mov     ax,40h           	; Espacio que ocupa cada
					; descriptor de tareas
	mul     cx               	; dx:ax = reg * ax
	add     ax,200h          	; suma el espacio resavador
					; para el nucleo 512 octetos
	mov     cx,ax
	push    cx               	; guarda apuntador NTCH*64+512

	shl     bx,1             	; multiplica NSIG*6, NSIG*2
	mov     ax,bx            	;
	shl     bx,1             	; NSIG*4
	add     ax,bx            	; NSIG*6= NSIG*4 + NSIG*2
	add     cx,ax            	; CX=NTCH*64+512+NSIG*6
	push    cx               	; Guarda apuntador
	mov     dx,bp            	; Recupera NBAL
	mov     ax,dx            	; copia NBAL en AX
	shl     dx,1             	; NBAL * 2
	shl     dx,1             	; NBAL * 4 = (NBAL * 2) * 2
	shl     dx,1             	; NBAL * 8
	sub     dx,ax            	; NBAL * 7= NBAL*8 - NBAL
	shl     dx,1             	; NBAL * 14 = NBAL* 7 * 2
	add     cx,dx            	; CX = NTCH*64+512+NSIG*6 + NBAL*14
	push    cx               	; Guarda el apuntador CX
	shl     si,1             	; NBAN * 2
	shl     si,1             	; NBAN * 4
	shl     si,1             	; NBAN * 8
	add     cx,si            	; CX = NTCH*64+512+NSIG*6 +
					; NBAL*14 +NBAN *8
	push    cx               	; Guarda el apuntador CX
	mov     bp,cx            	; Guarda temporalmente cx en
					; BP
	mov     cx,7
	shl     di,cl            	; NPOOL * 128 (2 exp 7)
	mov     cx,bp            	; recupera apuntador CX
	add     cx,di            	; CX = NTCH*64+512+NSIG*12 +
					; NBAL*14 +NBAN *8+NPOOL*128
	shr     cx,1             	; CX/2
	cld                      	; borra direccion
					; (decremento)
	mov     ax,0             	; toma el valor nulo
	mov     di,ax            	;
	rep     stosw            	; Rep mientras cx >0
					; almacena ax a es:[di]
					; llena zona de datos con
					; ceros
					; Guarda apuntadores del
					; sistema
	pop     word ptr ds:data_13e  	; Apuntador NPOOL
	pop     word ptr ds:data_12e  	; Apuntador NBAN
	pop     word ptr ds:data_11e  	; Apuntador NBAL
	pop     word ptr ds:data_10e  	; Apuntador NSIG
	pop     word ptr ds:data_9e   	; Apuntador NTCH

	; Inicializacion de los vectores de Interrupciones

	mov     bx,0             	; cambia ES a tabla de
	mov     es,bx            	; vectores de interrupciones
	mov     word ptr es:[bx],3AAh 	; INT /0: offset => 3AAH
	mov     es:[bx+2],cs          	;  segmento => CS MTR
	mov     word ptr es:[bx+4],47Ah ;INT paso a paso
                                        ; offset => 47ah
	mov     es:[bx+6],cs          	; segmento=> CS MTR
	mov     word ptr es:[bx+0Ch],452h ;INT paso a paso
                                        ; offset => 452h
	mov     es:[bx+0Eh],cs        	; segmento => CS MTR
	mov     word ptr es:[bx+10h],402h; INT OV sobreflujo
                                        ; offset => 402h
	mov     es:[bx+12h],cs        	; segmento => MTR
	mov     word ptr es:[bx+14h],42Ah; INT 5
                                        ; offset => 42Ah
	mov     es:[bx+16h],cs        	; segmento => CS MTR
	mov     word ptr es:[bx+18h],3DAh; INT 6
					; offset => 3DAh
	mov     es:[bx+1Ah],cs        	; segmento => CS MTR

	pop     ds                    	; recupera contexto
	pop     es
	pop     bp
	pop     di
	pop     ax
	pop     cx
	pop     bx
	pop     dx
	pop     si
	iret                          	; Retorna de Interrucion

	end inisys
;	Archivo Fuente 		primcall.asm
;
; 	Objetivo		Define en ensamblador todas las llamadas de
;				las primitivas para que pueden ser utilizadas
;				desde el lenguaje C. (libreria de llamadas)
;
;	Revision		13/Nov/1992
;				18/Mar/1993
;
;	Elaboro			Herrera Charles Roberto

	DOSSEG
	MODEL   tiny


	SISTEMA 	equ	12h
	EPROM		equ	0

	DATASEG

	INCLUDE ..\h\llamantrm.asm

     DATASEG
;     EXTRN  _tarea: near, _despacha : near, _crea_tarea
;     EXTRN  _inic_sist : near, _espera_temp:near, _envia_senal:near
;     EXTRN  _espera_senal:near, _envia_mensaje:near, _espera_mensaje:near
;     EXTRN  _gs_ds:near, _inpool:near, _xlibm:near, _xdemm:near
     PUBLIC _duerme, _creaTarea

	CODESEG
;=======================================================================
	PUBLIC	_duerme
_duerme	proc near

; Cambia al proceso al estado dormido, durante numero de pulso de
; reloj solicitados, depues de que transcurre el tiempo el proceso toma el esta-
; do listo
; La llamada es:
;	durme(numPulsos)
; donde
; 	numPulso Numero de pulso de reloj que el proceso estara dormindo
;
	push 	bp			; Prologo
	mov     bp,sp

	mov	AX,  _espera_temp ;
	mov	CX, [bp+4]		; Cx contiene parametro
	int	SISTEMA   		;

	pop	bp			; Epilogo
	ret

_duerme	endp

;=======================================================================
	PUBLIC	_creaTarea
_creaTarea proc near

; Solicitud para la creacion de una tarea dentro del sistema
; La llamada es:
;	creaTarea(numPulsos)
; donde
; 	numPulso apuntador al descriptor de creacion de tarea
; 		 para detalles ver primitiva de creacion de tarea
;
; Nota  El segmento que se pone es el mismo que el segmento del programa
;       hay que implementarlo para llamadas lejanas.

	push 	bp			; Prologo
	mov     bp,sp

IF	EPROM
	mov 	ax,0000H		;	creacion de tarea ociosa
ELSE
	mov 	ax,cs			;	creacion de tarea ociosa
ENDIF
	mov	es,ax                   ; Segmento de bloque de creacion
	mov 	ax,  _crea_tarea	; de tarea.
	mov	bx,[bp+4] 		; Carga el offset del bloque
					; de creacion de tarea
	int	SISTEMA

	pop	bp			; Epilogo
	ret

_creaTarea endp

;=======================================================================
	public _enviaSenal
_enviaSenal proc near
; envia una se¤al numerada
; La llamada es:
;	enviaSenal(numSenal)
; donde
; 	numSenal Numero de se¤al
;

	push 	bp			; Prologo
	mov     bp,sp


	mov 	ax,  _envia_senal	; direccion de la primitiva.
	mov	bx,[bp+4] 		; Carga el numero de la se¤al
	int	SISTEMA

	pop	bp			; Epilogo
	ret

_enviaSenal endp


	public _esperaSenal
_esperaSenal proc near
; espera de una se¤al numerada, sin tiempo de espera
; La llamada es:
;	espera(numSenal)
; donde
; 	numSenal Numero de se¤al
;

	push 	bp			; Prologo
	mov     bp,sp

	xor 	cx,cx 			; Espera la se¤al sin timeout
	mov 	ax,  _espera_senal ; Direccion de la primitiva.
	mov	bx,[bp+4] 		; Carga el numero de se¤al
	int	SISTEMA

	pop	bp			; Epilogo
	ret

_esperaSenal endp


	public _enviaMensaje
_enviaMensaje proc near
; envio de un mensaje en un buzon
; La llamada es:
;	enviaMensaje(numBuzon,dirMensaje)
; donde
; 	numBuzon Numero de buzon
;
; Nota El segmento utilizado es DS, se necesita ampliar la llamada
;      para que el segmento cambie

	push 	bp			; Prologo
	mov     bp,sp

	mov	ax,ds			; El segmento del mensaje
	mov	es,ax			; es el mismo que los datos
	mov 	ax,  _envia_mensaje ; direccion de la primitiva.
	mov	bx,[bp+4] 		; Carga el numero del buzon
	mov 	dx,[bp+6]		; Carga la direccion del mensaje

	int	SISTEMA

	pop	bp			; Epilogo
	ret

_enviaMensaje endp


	public _esperaMensaje
_esperaMensaje proc near
; espera de un mensaje en un buzon, sin tiempo de espera
; La llamada es:
;	Mensaje *esperaMensaje(numBuzon)
; donde
; 	numBuzon Numero de buzon
; Regresa
;	Mensaje: La direccion donde se encuentra el mensaje
;
; Nota: Se requiere un ajuste ES:AX de apuntadores lejanos para el mensaje
; 	compatibilidad para el lenguaje C

	push 	bp			; Prologo
	mov     bp,sp

	xor 	cx,cx 			; Espera el mensaje sin timeout
	mov 	ax,  _espera_mensaje ; Direccion de la primitiva.
	mov	bx,[bp+4] 		; Carga el numero de buzon
	int	SISTEMA
	mov	ax,dx			; regresa el off del mensaje

	pop	bp			; Epilogo
	ret

_esperaMensaje endp


	public _segZDS
_segZDS proc near
; obtiene la direccion del segmento de la zona de datos de sistema
; La llamada es:
;	direccion segZDS()
; donde
; 	direccion es el segmento donde inicia la Zona de Dato del Sistema
;

	push 	bp			; Prologo
	mov     bp,sp
	push	es

	mov 	ax,  _gs_ds 	; Direccion de la primitiva.
	int	SISTEMA
	mov	ax,es			; regresa valor de la zona de
					; datos del sistema

	pop 	es
	pop	bp			; Epilogo
	ret

_segZDS endp


	public _inicPozo
_inicPozo proc near
; inicializa el pozo para el manejo dinamico de memoria
; La llamada es:
;	inicPozo(numPozo, dirBase, logBloque)
; donde
; 	numPozo	Numero de pozo a inicializar
;	dirBase Direccion donde inicia el pozo en parrafos
;	logBloque longitud de bloque en parrafos
;
	push 	bp			; Prologo
	mov     bp,sp
	push	dx
	push 	cx
	push	bx
					; Carga los parametros a los reg
	mov	bx,[bp+4]		;  numPozo
	mov	dx,[bp+6]		;  dirBase
	mov	cx,[bp+8]		;  logBloque
	mov 	ax,  _inpool 	; Direccion de la primitiva.
	int	SISTEMA

	pop	bx
	pop	cx
	pop 	dx
	pop	bp			; Epilogo
	ret

_inicPozo endp


	public _libMem
_libMem proc near
; Libera una zona de memoria dinamica asignada en un pozo
; La llamada es:
;	libMem(segMem, offMem )
; donde
; 	segMem Segmento de la memoria a liberar
;	offMem offset de la memoria a liberar
;
; Nota: Los cuatro primeros octetos contienen la informacion para la libera-
;       cion del tama¤o, y pozo donde se va liberar la memoria

	push 	bp			; Prologo
	mov     bp,sp
	push 	es
	push	bx
					; Carga los parametros a los reg
	mov	ax,[bp+4]		;  segMem
	mov	es,ax
	mov	bx,[bp+6]		;  offMem
	mov 	ax,  _xlibm 	; Direccion de la primitiva.
	int	SISTEMA

	pop	bx
	pop	es
	pop	bp			; Epilogo
	ret

_libMem endp

	public _asigMem
_asigMem proc near
; Asigna una zona de memoria dinamica en un pozo y regresa la direccion
; asignada en parrafos
; La llamada es:
;	seg asigMem(numPozo, numParraf )
; donde
; 	numPozo  Numero de pozo donde se va asignar la memoria
;	numParraf Numero de parrafos solicitados
; regresa
;       seg 	direccion de inicio, en parrafos de la memoria asignada
;
; Nota: En los cuatro primeros octetos de la memoria asignada se guarda:
;      	el tama¤o, el offset en el pozo y numero pozo. Informacion que se uti-
;	liza durante la liberacion de la memoria asignada.
;

	push 	bp			; Prologo
	mov     bp,sp
	push 	es
	push 	cx
	push	bx
					; Carga los parametros a los reg
	mov	bx,[bp+4]		;  numPozo
	mov	cx,[bp+6]		;  numParraf
	mov 	ax,  _xdemm 	; Direccion de la primitiva.
	int	SISTEMA
	mov 	ax,es   		; Regresa el valor inicio de memoria
					; asignada
	pop	bx
	pop	cx
	pop	es
	pop	bp			; Epilogo
	ret

_asigMem endp


	end
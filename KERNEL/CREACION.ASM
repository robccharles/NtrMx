;	Archivo Fuente 		creacion.asm
;
; 	Objetivo		Crea las tareas con las cuales opera el
;				Sistema y transfiere el control al planificador
;
;	Revision		13/Nov/1992
;
;	Elaboro			Herrera Charles Roberto

	DOSSEG
	MODEL   tiny

	include  ..\h\confintr.asm
	include  ..\h\llamantr.asm
	PUBLIC __f		; Define el final de segmento de datos

     DATASEG

	EXTRN _tarea0: near, tache:near, _pruebaTx:near; , _despacha : near, _crea_tarea
;	EXTRN  _inic_sist : near,
	EXTRN _p_tarea_con

	PUBLIC _PARAMETROS, BLOC_DE, _creacion, _datos_nucleo

; Estructuras para la creacion de tarea inicial
; Esta estructura tambien tiene  su equivalente en lenguaje C

;IF  0	;EPROM
; BLOC_DE     DW 0f000h,OFFSET _tarea0	;segmento y offset de inicio de codigo
;ELSE
 BLOC_DE     DW 00h,OFFSET _tarea0	;segmento y offset de inicio de codigo
;ENDIF
	    DW 00H     			;longitud de los datos
	    DW 190h                     ;longitud del stack
	    DW 0h                       ;reservado
	    DB  "TASK ",0               ;nombre de la tarea

_PARAMETROS DW  OFFSET BLOC_DE 		;offset de block de descripcion de task
	    DW  00h			;segmento '  "    "       "      "  "
	    DB  01H                    	;numero de tarea
	    DB  03                     	;prioridad inicial
	    DW  01h                    	;estado inicial
	    DW  250h                   	;segmento SS
	    DW  00h                    	;    "    DS
	    DW  00h                    	;    "    ES
	    DW  00h 			;offset de block descriptor de registros
__f	db 'final'			; Referencia en donde termina el
					; segmento de datos del nucleo
  CODESEG


_creacion  proc near

; Esta rutina inicializa el Nucleo NTRMX, los parametro de configuracion del
; sistema estan dados por las constante definidas en el archivo confintr.asm
; Crea la una tarea de ocisiosa de baja prioridad y transfiere el control a la
; primitiva reiniciar. Que es el despachador del sistema.



	call _datos_sist		; Ajusta los datos del sistema solo
					; para la ejecucion del programa en RAM

	mov	AX,  _inic_sist	; Llama a la primitiva de inicializa-
	mov	CX, N_TAREAS		; cion del sistema. Numero de tareas
	mov	BX, N_SENALES		; Numero de senales
	mov	DX, N_BUZONES		; Numero de buzones
	mov	SI, N_BANDERA		; Numero de banderas
	mov	DI, N_POZOS		; Numero de pozos
	int	SISTEMA   		; Llamada al sistema


;	mov 	ax,cs			; creacion de tarea ociosa
;	mov	es,ax                   ; Ajusta apuntadores de descriptor
;	mov 	ax,  _crea_tarea	; de creacion de la tarea osciosa
;	mov	bx,offset _p_tarea_con 	;
;	int	SISTEMA			; Elimina la tarea ociosa 28/Sept/93



	mov 	ax,cs			; crea la tarea de cero (tarea0)
	mov	es,ax                   ; Ajusta apuntadores de descriptor
	mov 	ax,  _crea_tarea	; de creacion de la tarea inicial
	mov	bx,offset _PARAMETROS   ;
	int	SISTEMA			;

;	call    _pruebaTx		; lla a prueba de transmision
;xxxx:
;	jmp xxxx
	mov	AX,  _despacha 	; Transfiere en control al kernel
        int	SISTEMA   		;

	ret

_creacion endp

IF 1;NOT EPROM
_datos_sist     proc  near
; Ajusta el inicio de segmegto del sistema para cuando se carga en RAM
; En EPROM el ajuste es directo no se requiere esta rutina.
	      push bx
	      lea   ax, _datos_nucleo		; direccion de datos del sistema
	      mov   bx,ax                       ; carga en la direccion
	      mov   ax, [bx]                    ; 2000h
	      mov   bx, 02000h			; La ajusta a direccion 2000h
	      mov   [bx], ax			; carga el valor real segmento para NTR
	      xor   ax,ax
	      mov   [bx+2],ax			; carga el valor de segmeto para ES
	      pop   bx
	      ret
_datos_sist     endp

ENDIF
; Aqui se coloca la Zona de Datos de Sistema(Nucleo)
; Este ajuste se require para cuando se carga el sistema en RAM
_datos_nucleo	db  00h, 03h		;direccion de la zona de datos 0200
_datos_es	db  00h, 00h

	end
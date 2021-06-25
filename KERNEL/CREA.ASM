;	Archivo Fuente 		crea.asm
;
; 	Objetivo		Crea las tareas con las cuales opera el
;				Sistema y transfiere el control al planificador
;
;	Revision		13/Nov/1992
;
;	Elaboro			Herrera Charles Roberto

	DOSSEG
	MODEL   tiny


	SISTEMA 	equ	12h
	N_TAREAS 	equ	6h;
	N_SENALES 	equ	4h;
	N_BUZONES 	equ	3h;
	N_BANDERA 	equ	0h;
	N_POOL 		equ	2h;

	DATASEG



     DATASEG
     EXTRN _tarea: near, tache:near, _despacha : near, _crea_tarea
     EXTRN  _inic_sist : near,
     EXTRN _p_tarea_con

     PUBLIC _PARAMETROS, BLOC_DE, _inicia, _datos_nucleo

BLOC_DE     DW 00h,OFFSET _tarea	;segmento y offset de inicio de codigo
	    DW 00H     			;longitud de los datos
	    DW 90h                      ;logitud del stack
	    DW 0h                       ;reservado
	    DB  "TASK ",0               ;nombre de la tarea

_PARAMETROS DW  OFFSET BLOC_DE 		;offset de block de descripcion de tsk
	    DW  00h			;segmento '  "    "       "      "  "
	    DB  01H                    	;numero de tarea
	    DB  03                     	;prioridad inicial
	    DW  01h                    	;estado inicial
	    DW  450h                   	;segmento SS
	    DW  00h                    	;    "    DS
	    DW  00h                    	;    "    ES
	    DW  00h 			;offset de block descriptor de registros

	CODESEG

_inicia	proc near

	call _datos_sist


	mov	AX, offset _inic_sist	;
	mov	CX, N_TAREAS		;
	mov	BX, N_SENALES		;
	mov	DX, N_BUZONES		;
	mov	SI, N_BANDERA		;
	mov	DI, N_POOL		;
	int	SISTEMA   		;

	mov 	ax,cs			;	creacion de tarea ociosa
	mov	es,ax                   ;
	mov 	ax, offset _crea_tarea	;
	mov	bx,offset _p_tarea_con 	;
	int	SISTEMA


	mov 	ax,cs
	mov	es,ax
	mov 	ax, offset _crea_tarea	;
	mov	bx,offset _PARAMETROS
	int	SISTEMA

	mov	AX, offset _despacha 	;
        int	SISTEMA   		;

	ret

_inicia endp

;inicio de segmegto del sistema
_datos_sist     proc  near
	      push bx
	      lea   ax, _datos_nucleo		; direccion de datos del sistema
	      mov   bx,ax                       ; carga en la direccion
	      mov   ax, [bx]                    ; 2000h
	      mov   bx, 2000h			; La ajusta a direccion 2000h
	      mov   [bx], ax			; carga el valor real segmento
	      pop   bx
	      ret
_datos_sist     endp

;		org  1000h		; se ilimino 25/nov
_datos_nucleo	db  00h, 03h		;direccion de la zona de datos 0200

	end
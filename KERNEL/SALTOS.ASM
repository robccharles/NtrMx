;	Archivo Fuente 		saltos.asm
;
; 	Objetivo		Tabla de salto de todas las llamadas al Nucleo
;
;
;	Revision		13/Nov/1992
;				14/Marzo/1993
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


	EXTRN  _tarea:near , _salidas:near, _tarea1:near
	EXTRN  loc_2:near, loc_49:near, loc_26_1:near, loc_121:near,loc_127:near
	EXTRN  loc_42:near, loc_83:near, loc_100:near, loc_101:near, loc_108:near
	EXTRN  loc_116:near, _gsds:near, loc_129:near, loc_130:near, loc_136:near
	PUBLIC _int_250 ;, _reloj_tiemp ,_inic_sist, _fin_int , _despacha , _esigit ; , _crea_tarea,_espera_temp
;	PUBLIC  _espera_senal, _envia_senal
;	PUBLIC _envia_mensaje, _espera_mensaje, _gs_ds , _esigit, _inpool
;	PUBLIC _xlibm, _xdemm

;    PUBLIC _auto_desct,_tarea_locdes,_activa_tarea
;    PUBLIC _auto_locdes, _seg_sistema, _suspen_tarea,_dat_sist

;    tabla de saltos, el salto se hace de acuerdo a la llamada
;
_int_250:    	jmp ax			; Entrada de todas las Primitivas
_despacha:	jmp loc_2   		; del despachador o planificador
_espera_temp:   jmp loc_49              ; espera temporizada
_reloj_tiemp:   jmp loc_26_1            ; manejador reloj tiempo real
_crea_tarea:    jmp loc_121		; crea descriptor de tarea
_inic_sist:     jmp loc_127             ; inicializa sistema
_inpool:	jmp loc_129		; inicializacion de un pozo (pool)
_xdemm:		jmp loc_130		; Solicitud de memoria del un pozo
_xlibm:		jmp loc_136		; liberacion de memoria del un pozo
_fin_int:	jmp loc_42		; fin de interrupcion
_espera_senal:	jmp loc_101		; Espera una se¤al
_envia_senal:	jmp loc_100		; Envia una se¤al
_espera_mensaje: jmp loc_116		; Espera un mensaje en un buzon
_envia_mensaje:	jmp loc_108		; Envia un mensaje a un buzon
_gs_ds:		jmp _gsds		; Obtien el segmeto de datos NTRMX
_esigit:	jmp loc_83		; Envio de una senal de una Int.

; Estas primitivas no se ha incluida. Eliminar si no se incluyen
		db 18 dup(12)
;_suspen_tarea:  jmp loc_48		; autosuspension de tarea
;_auto_locdes:   jmp loc_56              ; localizacion de su propio descriptor
;_para_tarea:    jmp loc_57		; desativacion de una tarea por otra
;_activa_tarea:  jmp loc_58		; activa una tarea por otra tarea
;_auto_desct:	jmp loc_66		; autodesactivacion de tarea
;_tarea_locdes:	jmp loc_68              ; localizacion del descriptor de tarea

loc_ret_1:
		iret				; Interrupt return

		end
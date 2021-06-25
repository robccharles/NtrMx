
	base	equ 114h  		; 126 ajustado de codigo inicia
_despacha	equ base+0*3   		; del despachador o planificador
_espera_temp    equ base+1*3            ; espera temporizada
_reloj_tiemp    equ base+2*3            ; manejador reloj tiempo real
_crea_tarea     equ base+3*3 		; crea descriptor de tarea
_inic_sist      equ base+4*3            ; inicializa sistema
_inpool 	equ base+5*3		; inicializacion de un pozo (pool)
_xdemm 		equ base+6*3		; Solicitud de memoria del un pozo
_xlibm 		equ base+7*3		; liberacion de memoria del un pozo
_fin_int 	equ base+8*3 	        ; fin de interrupcion
_espera_senal 	equ base+9*3		; Espera una se¤al
_envia_senal 	equ base+10*3		; Envia una se¤al
_espera_mensaje  equ base+11*3		; Espera un mensaje en un buzon
_envia_mensaje 	equ base+12*3		; Envia un mensaje a un buzon
_gs_ds 		equ base+13*3		; Obtiene el segmeto de datos NTRMX
_esigit 	equ base+14*3		; Envio de una senal de una Int.

	SISTEMA 	equ	12h
	EPROM		equ	0
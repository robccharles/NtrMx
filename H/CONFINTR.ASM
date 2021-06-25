;	Archivo Fuente 		cofigntr.asm
;
; 	Objetivo	Constantes con las cuales se configura el nucleo
;			de Tiempo Real	MX
;
;	Revision		4/Marzo/1993
;
;	Elaboro			Herrera Charles Roberto

	SISTEMA 	equ	12h	; Interrupcion del sistema
	N_TAREAS 	equ	6h	; Numero maximo de tareas
	N_SENALES 	equ	4h	; Numero maximo de senales
	N_BUZONES 	equ	3h	; Numero maximo de buzones
	N_BANDERA 	equ	0h	; Numero maximo de banderas
	N_POZOS		equ	2h	; Numero maximo de pozos
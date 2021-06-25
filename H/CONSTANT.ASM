;	Archivo Fuente 		constantes.asm
;
; 	Objetivo		Define las constantes del nucleo.
; 				Constantes que utiliza el nucleo en las
;				llamadas al sistema
;
;	Revision		13/Nov/1992
;				18/Mar/1992
;
;	Elaboro			Herrera Charles Roberto


data_1e		equ	2			; Aparece en sub_1 (lin=96)
data_2e		equ	4			; Alarma Siguiente
data_3e		equ	6			; Apuntador de Alarma
data_4e		equ	0			; Apuntador de tarea en eje-
						; cucion
data_5e		equ	2			; Apuntador de Prioridades
data_6e		equ	4			; Alarma Siguiente (duplicado)
data_7e		equ	6			; Apuntador de Alarma (duplicada)
data_8e		equ	8			; Senales recibidas
data_9e		equ	0Ah			; Numero de tareas
data_10e	equ	0Ch			; Apuntador de senales
data_11e	equ	0Eh			; Apuntador de buzones
data_12e	equ	10h			; Apuntador de banderas
data_13e	equ	12h			; Apuntador de "pools"
data_14e	equ	0D4h			; Zona de descriptores de Pools
data_15e	equ	0D6h			; Tamano del pool
data_16e	equ	02000h       ; 0f000 eprom	; Zona de datos del sistema
						; Esta constante es reubicable
data_17e	equ	4			; Alarma Siguiente (duplicado)
data_18e	equ	6			; Apuntador de Alarma (duplicada)
data_19e	equ	8			; Senales recibidas(duplicado)
data_20e	equ	0D4h			; Zona de descriptores de Pools
data_21e	equ	0D6h			; Tamano del pool (duplicado)
data_16		equ	0			; Apuntador de tarea en eje-
						; cucion para distinguir de
						; data_16e


; Constantes para en control de tarea

	TIPOtarea equ 	64			; Tama¤o de tipo tarea
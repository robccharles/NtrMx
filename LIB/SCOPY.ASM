;	Archivo Fuente 		scopy.asm
;
; 	Objetivo		Libreria para la copia de un bloque
;				de memoria a otro. Se esta se llama cuando se
;				copian tipos definidos como estructuras
;
;	Revision		18/Mar/1993
;
;				Herrera Charles Roberto

	DOSSEG
	MODEL tiny
	DATASEG

	CODESEG

;	funcion implicita
;		scopy(segFuente,offFuente,segDestino,offDestino)
;
;
;	Libreria que se utiliza para compiar los campos de un tipo
;	a el mismo tipo en turbo C
;
;	Parametros:
;		segmento fuente  :	segFuente
;		offset   fuente  :	offFuente
;		segmento destino :	segDestino
;		offset   destino :	offDestino
;		tama¤o del tipo  :	cx  (en byte)

	PUBLIC scopy@

 scopy@ proc near

	PUSH	BP			; prologo
	MOV	BP,SP
	PUSH	SI
	PUSH	DI
	PUSH	DS

	LDS	SI,[BP+06]		; Carga apuntador fuente
	LES	DI,[BP+0AH]		; Carga apuntador destino
	CLD				; Borra la direccion SI -> DI
	SHR	CX,1			; CX/2 tama¤o en palabra
	REPZ                  		;
	MOVSW                           ; Tranfiere palabras de tipo
	ADC	CX,CX                   ; Copia en caso de tipos de tama¤o
	REPZ				; non
	MOVSB

	POP	DS			; epilogo
	POP	DI
	POP	SI
	POP	BP

	RETF	0008

scopy@	endp
	end

;	Archivo Fuente 		gsds.asm
;
; 	Objetivo		Localizacion del segmento de datos del
;				sistema.
;
;	Revision		25/Nov/1992
;
;	Elaboro			Herrera Charles Roberto

	DOSSEG
	MODEL   tiny
        	include  ..\h\constant.asm

	DATASEG

	PUBLIC   _gsds

	CODESEG
_gsds:
	mov 	es,cs:data_16e		; Carga en ES el segmento de datos
					; del sistema
	iret
	end

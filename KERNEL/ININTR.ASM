
      DOSSEG
      MODEL   tiny

      ; insertar INCLUDE "filename" directives here

      ;  insertar EQU ans = equates here

      DATASEG

     CODESEG


     ORG 100H

     ZDS	EQU	0200H	; Defiene la zona la ubicacion de la
				; zona de datos del sistema


start:

PROC PROG FAR
AQUI:
	dw ZDS  		; Define zona de datos del nucleo
				;
ENDP PROG
END start

pendiente

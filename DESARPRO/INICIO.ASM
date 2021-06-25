
      DOSSEG
      MODEL   tiny

      ; insertar INCLUDE "filename" directives here

      ;  insertar EQU ans = equates here

      DATASEG
_BSS segment word public 'BSS'
_a label byte
_BSS  ENDS
     CODESEG

	EXTRN _main:near
	EXTRN _parametros
	PUBLIC _inicio

     ORG 100H

start:
PROC PROG FAR
_inicio:
AQUI:
	call _main
	nop
parametro DW offset _parametros
	  DW ?
;_PARAMETROS DW  OFFSET _bloc_De 	;offset de block de descripcion de task
;	    DW  0390h			;segmento '  "    "       "      "  "
;	    DB  01H                    	;numero de tarea
;	    DB  02                     	;prioridad inicial
;	    DW  01h                    	;estado inicial
;	    DW  2c0h                   	;segmento SS
;	    DW  00h                    	;    "    DS
;	    DW  00h                    	;    "    ES
;	    DW  00h 			;offset de block descriptor de registros
;_bloc_De    DW 8 dup(?);0390h,OFFSET AQUI	;segmento y offset de inicio de codigo
;	    DW 00H     			;longitud de los datos
;	    DW 90h                      ;longitud del stack
;	    DW 0h                       ;reservado
;	    DB  "TAR1  ",0               ;nombre de la tarea


	RET
ENDP PROG
END start



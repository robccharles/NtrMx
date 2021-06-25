;	Archivo Fuente 		inicio.asm
;
; 	Objetivo		Punto de entrada para Nucleo de Tiempo Real
;				MX (NTRMX)
;
;	Revision		4/Mar/1993
;				12/Mar/1993
;
;	Elaboro			Herrera Charles Roberto

	DOSSEG
	MODEL   tiny


	PUBLIC __i
	DATASEG

	__i  db 'inicio'		; Referencia donde inicia el
					; segmento de datos del programa
	EXTRN __f			; Referencia donde termina el
					; segmento de datos del programa
	CODESEG

	EXTRN _main:near,scopy@:near

	ORG 100H

NTRMX:
proc origen far

; Punto de entrada del sistema equivalente a ambiente del c
; aqui entra el programa despues del reset

; Inicializacion de los registros de segmentacion y pila
	xor 	ax,ax			; Borra el contenido del registro AX
	mov	ds,ax			; Inicializa con cero los segmentos
	mov	es,ax			; Datos, Extra y Pila
	mov	ss,ax
	mov	ax,7a00h		; Inicializa apuntador de la pila
	mov 	sp,ax
	cli

; Copia de las zona de datos de la EPROM  a la RAM
;	mov 	ax,offset __f		; Obtiene apuntador al inicio y al final
;	mov 	bx,offset __i          	; del segmento de la zona de datos
;	push 	ds			; Pasa los parametros para que la fun-
;	push	bx			; cion scopy los copia a la memoria
;	push	cs			; RAM
;	push	bx
;
;	sub	ax,bx			; El registro CX contien la cantidad
;	mov	cx,ax			; de octetos que se copiaran
;	push 	cs
;	call	scopy@			; se realiza la copia con scopy@

	call _main			; Salta al programa main de config
;	cli
;	retf				; Nunca se ejecuta
endp origen
	end NTRMX			; Debe terminar con etiqueta para COM



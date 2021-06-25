;	Archivo Fuente 		xatt.asm
;
; 	Objetivo		Espera la terminacion de una alarma soli-
;				citada
;
;	Revision                10/Nov/1992
;				13/Mar/1993
;
;				Herrera Charles Roberto
	DOSSEG
	MODEL   tiny

	include  ..\h\constant.asm

	BLOQUEADO_N	equ	0FEH	; bit0 = 0 indica tarea bloqueado
					; bit0 = 1 indica estado listo

	DATASEG


	CODESEG

	EXTRN 	loc_3:near, sub_3 : near
	PUBLIC	xatt, loc_49

;---
; primitiva espera temporizada
;	parametros
;
;	   CX : Contiene el numero de unidades de temporizacion de espera
;
;---

loc_49:
xatt:
	push	ds                      ; Prologo
	push	es			; guarda contexto de tarea
	push	ax
	push	bx
	push	cx
	push	dx
	push	bp
	push	si
	push	di
	mov	ds,cs:data_16e		; obtiene zona de datos del nucleo
	mov	bx,ds:data_4e		; obtiene ptr de tarea en ejecucion
	and	byte ptr [bx],0FEh      ; cambia estado de tarea a espera
	sub	bx,4                    ; cambia contexto de pila proceso al kernel
	mov	[bx],sp			; Guarda el valor de SP del proceso
	mov	[bx+2],ss		; Guarda el valor de SS del proceso
	mov	ax,ds			;
	mov	ss,ax                   ; Pone el stack del kernel
	mov	sp,0D4h			; En la zona de datos del sistema
	sub	bx,0Eh                  ; BX apunta al campo de alarma en el
					; descriptor de la tarea
	or	cx,cx			; Prueba si tiempo de espera es cero ?
	jz	loc_50			; Si, regresa sin insertar la tarea
					; en la lista de alarmas
	call	sub_3			; Inserta la tarea en cola de espera
					; de alarma, de acuerdo a la valor de
					; espera
loc_50:
sinInsetar:
	jmp	loc_3			; transfiere control a despachador

	end xatt

	base	equ 156h
_imprime_real	equ base+0   		; funci¢n de impresi¢n de cadena
_getch_efec	equ base+1*3		; lee un caracter por el puerto serie
_putchar_efec   equ base+2*3		; imprime un caracter

	SIST_ES equ 11h			; sistema de entrada y salidas
	ZDES	equ 00f8h		; apuntador de ZDES (compatibilidad)


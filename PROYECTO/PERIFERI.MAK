# Dependecia de archivos de puertos

..\E_S\recepcio.obj:	..\E_S\recepcio.c  ..\incluye\llamadas.h\
			..\incluye\con825x.h
	$(CE_S)
	tcc -c -Ic:\tc2\include $*.c
	$(CPY)
..\E_S\ipuertos.obj:	..\E_S\ipuertos.asm  ..\h\constant.asm
	$(CE_S)
	tasm /ml $*.asm, $*.obj
	$(CPY)
..\E_S\saltoses.obj:  	..\E_S\saltoses.asm ..\h\stdioh.asm
	$(CE_S)
	tasm /ml $*.asm, $*.obj
	$(CPY)
# Dependecia de archivos de configuracion y aplicacion

..\config\inicio.obj:	..\config\inicio.asm
	$(CCONF)
	tasm /ml $*.asm, $*.obj
        $(CPY)
..\config\main.obj:	..\config\main.c ..\incluye\iniciali.h\
			..\incluye\con825x.h
	$(CCONF)
	tcc -c  $*.c
        $(CPY)
..\aplica\tarea0.obj:	 ..\aplica\tarea0.c ..\incluye\con825x.h\
			 ..\incluye\primitiv.h
	$(CAPLI)
	tcc -c -Ic:\tc2\include $*.c
	$(CPY)



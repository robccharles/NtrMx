# Dependecia de archivos de pruebas

..\prueba\mensajes.obj: ..\prueba\mensajes.c  ..\incluye\llamadas.h\
			..\incluye\iniciali.h ..\incluye\primitiv.h\
			..\incluye\procesos.h ..\prueba\senales.h
	$(CPRU)
	tcc -c $*.c
	$(CPY)
..\prueba\pruebmem.obj: ..\prueba\pruebmem.c ..\incluye\primitiv.h\
			..\prueba\memoria.h
	$(CPRU)
	tcc -c $*.c
	$(CPY)


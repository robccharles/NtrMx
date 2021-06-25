
# Hace respaldo de los archivos que fueron modificados
copia.exe : a:\comand\primcall.asm a:\utiles\estadotk.c\
	    a:\utiles\peek.asm a:\utiles\peekb.asm a:\utiles\copiacam.asm\
	    a:\utiles\dump.c\
	    a:\lib\scopy.asm a:\lib\duerme.asm a:\lib\memoria.asm a:\lib\mensajes.asm\
	    a:\lib\primcall.asm  a:\lib\senales.asm a:\lib\sistema.asm a:\lib\tareas.asm\
	    a:\lib\libreria.c a:\lib\ntrmx.lib a:\lib\cs.lib\
	    a:\prueba\mensajes.c a:\prueba\pruebast.c a:\prueba\pruebmem.c\
	    a:\prueba\senales.c a:\prueba\senales.h a:\prueba\memoria.h a:\prueba\watchdog.c\
	    a:\incluye\INICIALI.H a:\incluye\LLAMADAS.H a:\incluye\PROCESOS.H\
	    a:\incluye\PRIMITIV.H a:\incluye\CON825x.H a:\incluye\stdio.h\
	    a:\e_s\ipuertos.asm a:\e_s\recepcio.c a:\e_s\stdio.asm\
	    a:\e_s\saltoses.asm a:\e_s\stdio.lib\
	    a:\e_s\PRUEBA.MAK  a:\e_s\COMAND.MAK\
	    a:\e_s\RESPALS_.MAK	a:\e_s\INCLUYE.MAK a:\e_s\E_S.MAK a:\e_s\remak.mak



! include "comand.mak"
! include "prueba.mak"
! include "incluye.mak"
! include "e_s.mak"
! include "remak.mak"

# copy ..\mm\*.* a:\mm
# copy ..\config\*.* a:\config

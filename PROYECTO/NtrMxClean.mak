#	Fuente:	 	ntrmxclean.mak
#
#	Objectivo:	borra archivo obj y libreria del NtrMx
#
#
#
# Ensamblado de todos los archivos del nucleo
#
CPY = cd ..\proyectos	# Cambio al directorio de proyectos
CCOMD = cd ..\comand	# cambio al directorio de comandos
CUTIL = cd ..\utiles	# cambio al directorio de utilerias
CLIB  = cd ..\lib 	# cambio al directorio de libreria
CCONF = cd ..\config 	# cambio al directorio de configuracion
CAPLI = cd ..\aplica 	# cambio al directorio de aplicaciones
CE_S  = cd ..\E_S	# cambio al directorio de Entrada/Salidas
CKER  = cd ..\kernel 	# cambio al directorio de Kernel
CPRU  = cd ..\prueba	# cambio al directorio de Kernel
CMEM  = cd ..\memoria 	# cambio al directorio de Memoria
CDES  = cd ..\desarpro 	# cambio al directorio desarrollo de programas

#
clean: ..\config\inicio.obj ..\config\main.obj ..\aplica\tarea0.obj\
	   ..\comand\primcall.obj ..\utiles\estadotk.obj ..\utiles\peek.obj\
	    ..\utiles\peekb.obj ..\utiles\copiacam.obj ..\utiles\dump.obj\
	     ..\lib\scopy.obj\
	     ..\desarpro\shell.obj ..\lib\libreria.obj\
	    ..\kernel\xenvs.obj ..\kernel\xatts.obj ..\kernel\xenvm.obj\
	    ..\kernel\xattm.obj\
	    ..\prueba\mensajes.obj ..\prueba\pruebmem.obj\
	    ..\e_s\recepcio.obj ..\e_s\ipuertos.obj ..\e_s\saltoses.obj\
	    ..\kernel\servint.obj ..\kernel\saltos.obj ..\kernel\start.obj\
	    ..\kernel\drvrtr.obj ..\kernel\inisys.obj ..\kernel\tache.obj\
	    ..\kernel\xatt.obj  ..\kernel\fit.obj ..\kernel\sub_1.obj\
	    ..\kernel\gsds.obj  ..\kernel\esigit.obj ..\kernel\creacion.obj\
	    ..\memoria\inpool.obj ..\memoria\xlibm.obj ..\memoria\xdemm.obj



# Se ligan todos los archivos objeto dependientes
  $(CKER)
       del *.obj \
  $(CPY)
  $(CE_S)
         del *.obj \
  $(CPY)
  $(CMEM)
           del *.obj
  $(CPY)
	
  del ntrmx1.com
#tlink @configur @periferi @comand @comunica @memoria @prueba @nucleo   , ntrmx  , ,..\e_s\stdio.lib ..\lib\cs.lib
# Ensamblado de todos los archivos de nucleo en ensamblador


# incluye todos las dependencia de comandos
!include "comand.mak"

# incluye todos las dependencia de configuracion
!include "configur.mak"

# incluye todos las dependencia de perifericos
!include "periferi.mak"

# incluye todos las dependencia de comunicacion
!include "comunica.mak"

# incluye todos las dependencia de prueba
!include "prueba.mak"

# incluye todos las dependencia de nucleo
!include "nucleo.mak"

# incluye todas las dependencia de memoria
!include "memoria.mak"
# Fin de los archivos de ensamblado
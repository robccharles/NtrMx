# Hace respaldo de los archivos que fueron modificados
copia.exe : a:\config\inicio.asm a:\config\main.c\
	    a:\kernel\xenvs.asm a:\kernel\xatts.asm a:\kernel\xenvm.asm\
	    a:\kernel\xattm.asm\
	    a:\kernel\servint.asm a:\kernel\saltos.asm a:\kernel\start.asm\
	    a:\kernel\drvrtr.asm a:\kernel\inisys.asm a:\kernel\tache.asm\
	    a:\kernel\xatt.asm  a:\kernel\fit.asm a:\kernel\sub_1.asm\
	    a:\kernel\gsds.asm a:\kernel\esigit.asm a:\kernel\creacion.asm\
	    a:\kernel\nucleo.mak a:\kernel\config.mak a:\kernel\memoria.mak\
	    a:\kernel\respaldo.mak\
	    a:\memoria\INPOOL.ASM a:\memoria\XLIBM.ASM  a:\memoria\XDEMM.ASM\
	    a:\h\CONSTANT.asm a:\h\INICIALI.H1 a:\h\llamantr.asm a:\h\stdioh.asm\
	    a:\h\confintr.asm


! include "nucleo.mak"
! include "config.mak"
! include "kermak.mak"
! include "comuni.mak"
! include "memoria.mak"

# copy ..\mm\*.* a:\mm
# copy ..\config\*.* a:\config




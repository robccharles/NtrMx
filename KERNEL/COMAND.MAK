# precedencia para todos los archivos de comando y de utilerias
# falta poner la precendencia en caso de los archivo que se incluyen
#

..\comand\primcall.obj : ..\comand\primcall.asm
	$(CCOMD)
	tasm /ml $*.asm, $*.obj
	$(CPY)
..\utiles\estadotk.obj: ..\utiles\estadotk.c ..\incluye\procesos.h
	$(CUTIL)
	tcc -c $*.c
	$(CPY)
..\utiles\peek.obj:     ..\utiles\peek.asm
	$(CUTIL)
	tasm /ml $*.asm, $*.obj
	$(CPY)
..\utiles\peekb.obj:	..\utiles\peekb.asm
	$(CUTIL)
	tasm /ml $*.asm, $*.obj
	$(CPY)
..\utiles\copiacam.obj:  ..\utiles\copiacam.asm
	$(CUTIL)
	tasm /ml $*.asm, $*.obj
	$(CPY)
..\lib\scopy.obj:	..\lib\scopy.asm
	$(CLIB)
	tasm /ml $*.asm, $*.obj
	$(CPY)
# Dependecia de archivos de manejo de memoria

..\memoria\inpool.obj:	..\memoria\inpool.asm ..\h\constant.asm
	$(CMEM)
	tasm /ml $*.asm, $*.obj
	$(CPY)
..\memoria\xlibm.obj:	..\memoria\xlibm.asm ..\h\constant.asm
	$(CMEM)
	tasm /ml $*.asm, $*.obj
	$(CPY)
..\memoria\xdemm.obj:	..\memoria\xdemm.asm ..\h\constant.asm
	$(CMEM)
	tasm /ml $*.asm, $*.obj
	$(CPY)

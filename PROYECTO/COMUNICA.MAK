# Dependecia de archivos de configuracion y aplicacion

..\kernel\xenvs.obj:	..\kernel\xenvs.asm ..\h\constant.asm
	$(CKER)
	tasm /ml $*.asm, $*.obj
	$(CPY)
..\kernel\xatts.obj:	..\kernel\xatts.asm ..\h\constant.asm
	$(CKER)
	tasm /ml $*.asm, $*.obj
	$(CPY)
..\kernel\xenvm.obj:	..\kernel\xenvm.asm ..\h\constant.asm
	$(CKER)
	tasm /ml $*.asm, $*.obj
	$(CPY)
..\kernel\xattm.obj:	..\kernel\xattm.asm ..\h\constant.asm
	$(CKER)
	tasm /ml $*.asm, $*.obj
	$(CPY)
# Dependecia de archivos de configuracion y aplicacion

..\kernel\servint.obj:	..\kernel\servint.asm ..\h\constant.asm
	tasm /ml $*.asm,  $*.obj
..\kernel\saltos.obj:	..\kernel\saltos.asm ..\h\constant.asm
	tasm /ml $*.asm, $*.obj
..\kernel\start.obj:	..\kernel\start.asm ..\h\constant.asm
	tasm /ml $*.asm, $*.obj
..\kernel\drvrtr.obj:	..\kernel\drvrtr.asm ..\h\constant.asm
	tasm /ml $*.asm, $*.obj
..\kernel\inisys.obj:	..\kernel\inisys.asm ..\h\constant.asm
	tasm /ml $*.asm, $*.obj
..\kernel\tache.obj:	..\kernel\tache.asm  ..\h\constant.asm
	tasm /ml $*.asm, $*.obj
..\kernel\xatt.obj:	..\kernel\xatt.asm ..\h\constant.asm
	tasm /ml $*.asm, $*.obj
..\kernel\fit.obj:	..\kernel\fit.asm  ..\h\constant.asm
	tasm /ml $*.asm, $*.obj
..\kernel\sub_1.obj:	..\kernel\sub_1.asm ..\h\constant.asm
	tasm /ml $*.asm, $*.obj
..\kernel\gsds.obj:	..\kernel\gsds.asm ..\h\constant.asm
	tasm /ml $*.asm, $*.obj
..\kernel\esigit.obj: ..\kernel\esigit.asm ..\h\constant.asm
	tasm /ml $*.asm, $*.obj
..\kernel\creacion.obj: ..\kernel\creacion.asm ..\h\confintr.asm ..\h\llamantr.asm
	tasm /ml $*.asm, $*.obj

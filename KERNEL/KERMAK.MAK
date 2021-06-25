# respaldo de los archivos de respaldo para el nucleo


a:\kernel\nucleo.mak: ..\kernel\nucleo.mak
	copy ..\kernel\nucleo.mak $*.mak

a:\kernel\config.mak: ..\kernel\config.mak
	copy ..\kernel\config.mak $*.mak

a:\kernel\memoria.mak: ..\kernel\memoria.mak
	copy ..\kernel\memoria.mak $*.mak
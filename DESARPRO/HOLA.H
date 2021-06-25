#define puts imprime
#include "..\incluye\procesos.h"
#include "..\incluye\stdio.h"
void inicio(void);
extern BLOC_DES bloc_De;
PARAM_TSK parametros={&bloc_De,(BLOC_DES*)0x390,1,20,1,0x2c0,0,0,0};
BLOC_DES bloc_De={0,(int)inicio,0,0x90,0,"tare2"};
main()
{
	int i;
	for(;;){
		 puts("Hola mundo  .\n  ");
		 duerme(50);

	}
}
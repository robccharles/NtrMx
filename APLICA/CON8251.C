/* fuente 		con8251.c
 *
 *	objetivo        Tarea de comunicacion uno en accion
 *
 *	revision	21 Octubre de 1992		rhc
 *
 *
 */
#include <dos.h>
#include "..\incluye\con8251.h"
#include "..\incluye\primitiv.h"
#define TAB  '\t'
tarea()
{
/* Primera tarea que se ejecuta de deberia llamara inicio */
	int ch=0,i,j;


	imprime("inicia MICRONUCLEO NTRMX 1.0 \r\n");
					/* prueba de la primitiva xatt */
	imprime("Espera temporizada por 1 seg...\r\n");
	duerme(100);			/* duerme por un segundo */
	imprime(" realiza eco en forma intermitente \r\n\r\n");
	while((char)ch!=TAB ){  	/* hace eco con interrrupciones */
		ch=getch1();		/* lee un caracter del bufeer */
		if( ch != -1){		/* imprime si leyo caracter */
			switch(ch){
			case '1':
				duerme(10);
				continue;
			case '2':
				duerme(1000);
				break;
			case '3':
				pruebaMensaje();
				break;
			case '4':
				estadoTareas();
				break;
			case '5':
				pruebaMemoria();
				break;
			}
			if(ch == '\r')
				imprime("\n\rNTRMX>");
			else
				ponbuffer ( ( char ) ch ) ; /* pone caracter buffer */
		}
	}
	for(i=0; i<10;i++)
		for(j=0; j< 20000;j++)
		 ;
	disable();			/* deshabilita interrupcione 	*/



	outportb(PICR1,MASCARA1);	/* controlador de interrupciones
					   deshabilita todas las interrupcione*/
}
/*-- tarea osciosa de mas bajo nivel
 --*/
ociosa(void)
{
	/* no realiza ninguna funcion pero nos permite conservar la zona de
	   datos del sistema */
	int i,j;
	for(;;){
		for(j=0; j< 30000;j++);
		/* imprime("tarea ociosa \r\n");*/
		
	}

}


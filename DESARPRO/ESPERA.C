#include "..\incluye\primitiv.h"
#include "..\incluye\procesos.h"
#include "..\incluye\stdio.h"
#include "espera.h"
#define BUZON1 1
#define ESPERA 95


main()
/*	Codigo de tarea dos. Espera un mensaje en el buzon 1 y despues lo
 *	imprime.
 */
{

	MENSAJE far *ptr,carta;
	for(;;){
		ptr=(MENSAJE far *)esperaMensaje(BUZON1); /* Espera la se¤al UNO para seguier */
		carta = *ptr;
		imprime(carta.mensaje);    		 /* imprime un mensaje de
							   identificacion */
	}
}

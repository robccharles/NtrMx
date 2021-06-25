#include "..\incluye\primitiv.h"
#include "..\incluye\procesos.h"
#include "..\incluye\stdio.h"
#include "envia.h"
#define BUZON1 1
#define ESPERA 95
MENSAJE datos = {0,0,0,"Micro Nucleo NTRMX1.1 "}; 	/* mensaje a transmitir */

main()
/*	Codigo de tarea uno. Envia un mensaje a el buzon 1, se duerme
 *	durante el tiempo ESPERA = 95 pulsos de reloj y al final espera un
 *	caracter por el teclado para continuar
 *   Nota:
 *	Como el teclado es comun para el shell y esta tarea de envia necesita
 *	enviar dos caracteres por el teclado. Uno para el shell y el otro para
 *	esta tarea. Una soluci¢n es bloquear a la tarea del shell otra soluci¢n
 *	es conmutar de teclado y pantalla para cada tarea.
 */
{
	int mensaje;
	for(;;){
		enviaMensaje(BUZON1,(char *)&datos);	/* envia mensaje a buzon 1 */
		duerme(ESPERA);				/* Se duerme por cierto tiempo */
		puts("\n\nespera un caracter\n");
		getch();				/* Espera un caracter de teclado */

	}


}


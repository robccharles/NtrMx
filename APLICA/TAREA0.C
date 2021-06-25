/* 	fuente 		tarea0.c
 *
 *	objetivo        Tarea cero que mantien la comunicacion con
 *			el puerto serie
 *
 *	revision	21 Octubre de 1992		rhc
 *                      3/Marzo/1993
 *
 */
#include <dos.h>
#include "..\incluye\con825x.h"
#include "..\incluye\primitiv.h"
#include "..\incluye\iniciali.h"
#include "..\incluye\stdio.h"

int putchar (char );

tarea0()
{
/* Primera tarea que se ejecuta cuando el sistema se activa
 * Manda el mensaje inicial al puerto serie realiza alguna pruebas
 * despues hace eco con la terminal espera algun comando
 */
	int ch=0,i,j;
	imprime(CLRSCR); 		/* borra la pantalla e imprime */
	imprime("N£cleo de Tiempo Real MX 1.0 (c)1992\r\n");  /* logotipo */
	imprime("\r\n            CITEDI-IPN  \r\n");	     /* compania */
	imprime("Tarea 0 del sistema \r\n\r\n");
/*	asignaMemoria(); */ /* revisar proximo dia */
	while((char)ch!=TAB ){  	/* hace eco con interrrupciones */
		ch=getch();		/* lee un caracter del bufeer */
		if( ch != -1){		/* imprime si leyo caracter */
			switch(ch){
			case '1':
                        	shell();
				duerme(10);
				continue;
			case '2':
				duerme(10000);  /* no funciona */
				break;
			case '3':
				pruebaMensaje(); /* Prueba mesajes */
				break;
			case '4':
				  /* Impreme los Estados */
				break;		 /* De todas las tareas */
			case '5':
				pruebaMemoria(); /* Prueba memoria */
				break;		 /* Dinamica */
			case '6':
				pruebaMemoria(); /* Prueba memoria */
				break;		 /* Dinamica */
			case '7':
				cargaProg(); /* Prueba memoria */
				break;		 /* Dinamica */
			}
			if(ch == '\r')
				imprime("\n\rNTRMX>");/* imprime el prog */
			else
				putchar ((char)ch); /*pone caracter buffer */
		}
	}
	/* En caso de que el sistema se aborte se activa el watch-Dog */
	for(i=0; i<10;i++)
		for(j=0; j< 20000;j++)
		 ;
	disable();			/* deshabilita interrupcione 	*/
	outportb(PICR1,MASCARA1);	/* controlador de interrupciones
					   deshabilita todas las interrupcione*/
}


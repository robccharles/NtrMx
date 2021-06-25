/* 	fuente 		recepcio.c
 *
 *	objetivo        Implementar las funciones manejador del 8251
 *			con interrupciones y seccion critica.
 *
 *	revision	12 Diciembre de 1992		rhc
 *			18 Marzo de 1992
 *
 */

#include "c:\tc2\include\dos.h"
#include "..\incluye\llamadas.h"
#include "..\incluye\con825x.h"

#define DOS 2

unsigned segDS;
int imprimes(char far *);
char *gets(char *s);
extern char *frente, *atras,*cabeza,*cola;	/* apuntadores del buffer de
						   transmision */
extern char buffer_tra[TAMANO];			/* buffer de transmision */
extern int flag;				/* bandera si hay transmision directa*/

char buffer_rec[TAMANO];			/* buffer de recepcion 	*/

int f=4,r=4;
void recbuf()
{
/*  Funcion llamada por el manejador de recepcion serie. Lee un caracter del
 *  puerto serie y lo introduce en la cola circular(buffer de recepcion).
 */
	f = ( f + 1 )%TAMANO;	/* avanza apuntador de buffer 		*/
	if( f == r){    	/* prueba si buffer esta lleno 		*/
		f=( f-1 + TAMANO ) %TAMANO ;
		inportb(P8251DAT);      /* lee puerto para limpiar buffer */
		return;
	}
	buffer_rec[f]=inportb( P8251DAT); /* si hay espacion mete al buffer */
}

int leebuffer()
{
	int entero;
/*	Toma un caracter de la cola circular si esta disponible en caso contrario
 * 	se bloque esperando la senal DOS y despues retorna un -1.
 */
	disable();
	if(f==r){			/* prueba si el buffer esta vacio */
		enable();
		esperaSenal(DOS);	/* espera la senal 	*/
		return -1;		/* hay que evitar esto 	*/
	}
	else{
		r = ( r + 1 ) % TAMANO ; /* ajusta apuntador para leer  */
		enable();		 /* habilita interrupciones 	*/
		entero = (int)buffer_rec[r];/* retorna un valor del buffer */
		return (entero & 0xff);	 /* enmascara para carater */
	}
}
Mgetch()
{
	int temp;
	while( (temp=leebuffer()) == -1);
		return (temp);
}



imprimes(char far *ptr)
/* 	funcion  imprime
 *
 *		imprime un cadena de caracteres por el puerto serie
 *
 *	parametro
 *		ptr: 	cadena de caracteres a imprimir
 *	regresa
 *		ningun valor
 */
{
	while(*ptr != '\0'){		/* Pone un caracter de la cadena, en el	*/
					/* buffer de transmision. Mientras  no	*/
		if( ponbuffer(*ptr)==1)	/* sea el final de la cadena 		*/
			ptr++;
	}

}


void Mputchar(char ch)
/* 	funcion  putchar
 *
 *		imprime un caracter por el puerto serie
 *
 *	parametro
 *		ch: 	caracter a imprimir
 *	regresa
 *		ningun valor
 */
{
	while(ponbuffer(ch)== -1);	/* introduce el caracter al buffer */
					/* espera hasta que el buffer tenga
					   espacio para el caracter */
}

getche()
/*	recibe un caracter con eco no bufferado
 *	Nota:    ######
 *		 Revisar estas funciones para el manejador
 */
{
	putchar(getch());
}
int ponbuffer(char ch)
/* 	funcion  ponbuffer
 *
 *		Si el buffer esta vacio transmite el caracter inicial en forma
 *		directa y lo indica con la bandera, en otra caso pone el caracter
 *		en buffer de transmision.
 *
 *	parametro
 *		ch: 	caracter a poner en buffer
 *	regresa
 *		 1 si el caracter se metio al buffer
 *		-1 si en buffer esta lleno y el caracter no entro en buffer
 *
 *	nota:	Mejorar el manejador de entrada y salida a nivel del usuario
 */
 {
	disable();
	if( (frente == atras) && (flag==FALSO) ) {
		outportb(P8251DAT, ch);
		flag = VERDAD;
	}else{
		if( (frente == atras - 1) || (frente==cola && atras==cabeza)){
			enable();
			return -1;	/* el buffer esta lleno */
		}
		*frente++ = ch;		/* introduce el caracter en buffer 	*/
					/* e incrementa el apuntador del buffer */
	}
	if(frente-1==cola)
		frente=cabeza;		/* prueba si hay que dar vuelta a los apuntadores */
	enable();
	return(1);			/* caracter en buffer */


}

emibuf()
/* 	funcion  emibuf
 *
 *		rutina de la interrupcion de emision. Toma un caracter del
 *		buffer de transmision y lo envia al 8251. La transmision termina
 *		cuando el buffer est  vacio.
 *
 *	parametros
 *		ninguno
 *	regresa
 *		ninguno
 */
{

	if(frente == atras){
		disable();
		flag = FALSO;
		enable();
		return ;
	}
		outportb(P8251DAT,*atras++); /*  si no esta vacio transmiste */
					     /*  siguiente caracter en buffer */
	if(atras-1==cola)
		atras=cabeza;	/* prueba si hay que dar vuelta a los apuntadores */
	enable();
}



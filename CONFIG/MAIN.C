 /* 	fuente 		main.c
 *
 *	objetivo        Inicializacion del nucleo del sistema
 *			es el codigo de configuracion del sistema
 *
 *	revision	21 Octubre de 1992		rhc
 *			19 Marzo de 1992
 *
 */

#include "c:\tc2\include\dos.h"
#include "..\incluye\llamadas.h"
#include "..\incluye\con825x.h"
#include  "..\incluye\iniciali.h"
#include  "..\incluye\stdio.h"
#define EPROM 0



void rutirecep(void),rutitrans(void);	/* rutina de interrupciones para
					   transmision y recepcion */
					/* prototipos de rutinas de interrupciones */
void it_drvrtr(void),NMI(void),int_250(void),int_ES(void),it_parasita(void);

/* funciones prototipos */
void inicia(void),durme(int );

/* bloque para la creacion de tareas */


char *frente, *atras,*cabeza,*cola;	/* apuntadore para el buffer de transmision */

char buffer_tra[TAMANO];			/* define el buffer de transmision */
int flag,i,j;					/* bandera si hay transmision directa*/

/*--
	main
  --*/
main()
/*	Primera funcion que se ejecuta despues del reset esta es la entrada
 *	de todo el sistema. La funcion inicializa los perifericos: de comunica-
 *	cion(8251), de reloj(8253) y de el controlador de interrupciones(8259),
 *	los vectores de interrupciones y transfiere en control a la inicializa
 *	cion del sistema con la funcio inicio.asm
 */
{


	flag = FALSO;
	frente = atras= cabeza = buffer_tra; /* inicializa apuntadores de cola */
	cola   = &buffer_tra[TAMANO];	/* al final de la cola */

	I8253(); 			  /* inicializa el reloj para Tx y Rx */
	while( ! I8251() );               /* inicializa el periferico serie   */

	i_vectorint(REC51,(int )rutirecep);	/*inicializa los vectores para*/
	i_vectorint(TRA51,(int )rutitrans);   	/* transmision y recepcion */
	i_vectorint(RELOJ,(int )it_drvrtr);   	/* reloj de tiempo real */
	i_vectorint(NMIT,(int )NMI);   		/* watch-dog */
	i_vectorint(PARASITA,(int )it_parasita); /* interrupcion parasita */
	i_vectorint(NUCLEO,(int)int_250);       /* primitivas del NTRMX */
	i_vectorint(SIST_ES,(int)int_ES);       /* llamadas de ES */
	disable();      		/* modifica la mascara del (8259) */
	I8259(); 			/* inicializa el controlar de inte-
					   rrupciones */
	disable();

	outportb(PICR1,MASCARA); 	/* controlador de interrupciones  */

	creacion();			/* se transfiere el control a tarea
					   inicial */
	outportb(PICR1,MASCARA1);	/* controlador de interrupciones
					   deshabilita todas las interrupcione*/
}

/*--
	I8251	 inicializa el periferico 8251
  --*/
I8251()
{
/* 	inicializa el puerto serie en modo asincrono, 8 bit de datos, no
 *  	paridad, 2 bits de paro
 */

	int i;
#if !EPROM
	outportb(P8251CON,RESET ); 	 /* reinicia la programacion del
					    controlador serie 		*/
#endif
	outportb(P8251CON,PAL_CONTROL);	 /* carga el modo programacion */
	outportb(P8251CON,PAL_OPERACION);/* carga el modo de operacion */
	for(i=0;i<100;i++);
	return (inportb(P8251CON) & 0x01 );
}

/*--
	I8253 	inicializa el periferico 8253
  --*/
IX8253()
{
/* Inicializa el canal 3 del contador del 8253 a 9600 baud x 64 */
/* frecuencia de entrada de 595 833 Hz				*/

	unsigned int contador;
	outportb(PROGMODO, ONDA_CUADRADA3);/* pogramacion para el contador 3 */
	contador = (unsigned) FACTOR;
	outportb(CONTADOR3, contador);	   /* carga parte baja en el contador*/
	outportb(CONTADOR3, contador >> 8); /* carga parte alta en el contador*/
}
/*--
	i_vector
  --*/
i_vectorint(int numero, unsigned int rutina)
{
/*	Inicializa los vectores de interrupciones en la tabla de vector
 * 	de interrupciones.
 *	parametros:
 *		numero: indica que numero de vector se desea colocar
 *		rutina: la direccion de la rutina que dara servicion
 *			a la interrupcion
 */

	int temp;
	temp = _CS;			/* seudo operacion para el caso del
					   turbo c; carga CS 		*/
	poke(0, numero*4, rutina);	/* coloca el offset 		*/
	poke(0, numero*4+2, temp);	/* y el segmento en la tabla	*/
}

pruebaTx()
{
	int i;
	static char a='a';
	for(i=0;i<460;i++){
		while( ( inportb(0xda) & 0x01 ) == 0);
		outportb( 0xd8,a );
	}
	a++;
}

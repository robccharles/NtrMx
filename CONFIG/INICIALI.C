/* fuente 		main.c
 *
 *	objetivo        Inicializacion del sistema del nucleo del sistema
 *			es el codigo de configuracion del sistema
 *
 *	revision	21 Octubre de 1992		rhc
 *
 */

#include "d:\tc2\include\dos.h"
#include "..\incluye\llamadas.h"
#include "..\incluye\con8251.h"
#include  "..\h\iniciali.h"


void rutirecep(void),rutitrans(void);	/* rutina de interrupciones para
					   transmision y recepcion */
void it_drvrtr(void),NMI(void),int_250(void),it_parasita(void);/* rutina de interrupcion para
					   reloj de tiempo real    */
void inicia(void),durme(int );

void ociosa(void);

/* bloque para la creacion de tareas */
BLOC_DES b_tarea_con={0,(int)ociosa,0, 0x90,0,"TAE "};
PARAM_TSK p_tarea_con={&b_tarea_con,NULL,03,01,ACTIVA,0x470,0,0,0};

char *frente, *atras,*cabeza,*cola;	/* apuntadore para el buffer de transmision */

char buffer[TAMANO];			/* define el buffer de transmision */
int flag,i,j;				/* bandera si hay transmision directa*/
/*--		main
 --*/
main()
{

	int ch=0;			/* caracter leido  */

	flag = FALSO;
	frente = atras= cabeza = buffer;/* inicializa apuntadores de cola */
	cola   = &buffer[TAMANO-1];	/* al final de la cola */
	I8253(); 			/* inicializa el reloj para Tx y Rx */
	I8251();               		/* inicializa el periferico serie   */
	i_vectorint(REC51,(int )rutirecep);	/*inicializa los vectores para*/
	i_vectorint(TRA51,(int )rutitrans);   	/* transmision y recepcion */
	i_vectorint(RELOJ,(int )it_drvrtr);   	/* transmision y recepcion */
	i_vectorint(NMIT,(int )NMI);   	/* transmision y recepcion */
	i_vectorint(PARASITA,(int )it_parasita); /* interrupcion parasita */
	i_vectorint(NUCLEO,(int)int_250);

	I8259();			/* iniccializa el controlar de inte-
					   rrupciones */

	disable();      		/* modifica la mascara del (8259) */
	outportb(PICR1,MASCARA);	/* controlador de interrupciones  */
/*	return(0);*/
/*	enable();	*/		/* habilita interrupciones */
	inicia();
	imprime("comienzo de un final feliz\r\n");
	imprime(" al final\r\n\r\n");
	while((char)ch!='\r'){  	/* hace eco con interrrupciones */
		ch=getch1();		/* lee un caracter del bufeer */
		if( ch != -1)		/* imprime si leyo caracter */
			ponbuffer ( ( char ) ch ) ; /* pone caracter buffer */
	}

	for(i=0; i<10;i++)
		for(j=0; j< 20000;j++)
		 ;
	disable();			/* deshabilita interrupcione 	*/



	outportb(PICR1,MASCARA1);	/* controlador de interrupciones
					   deshabilita todas las interrupcione*/
}

/*--
	I8251	 inicializa el periferico 8251
  --*/
I8251()
{
	/* incializa el puerto serie en modo asincron, 8 bit de datos, no
	   paridad, 2 bits de paro */

	outportb(P8251CON,RESET );	/* reinicia la programacion del
					   controlador serie 		*/
	outportb(P8251CON,PAL_CONTROL);	 /* carga el modo programacion */
	outportb(P8251CON,PAL_OPERACION);/* carga el modo de operacion */
}

/*--
	I8253 	inicializa el periferico 8253
  --*/
IX8253()
{
	/* inicializa el canal 3 del contador del 8253 a 9600 baud x 64 */
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
	/*	inicializa los vectores de interrupciones en la tabla de vector
	 * 	de interrupciones.
	 *	parametros:
	 *		numero: indica que numero de vector se desea colocar
	 *		rutina: la direccion de la rutina que dara servicion
	 *			a la interrupcion
	 */

	int temp;
	temp = _CS;			/* seudo operacion para el caso del
					   turbo c; carga CS 		*/
	poke(0,numero*4,rutina);	/* coloca el offset 		*/
	poke(0,numero*4+2,temp);	/* y el segmento en la tabla	*/
}

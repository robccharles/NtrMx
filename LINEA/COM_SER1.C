/*======================================================================*
* Nombre del archivo:   COM_SERI.C                                      *
*       Funcion :       Manejador del puerto serie por                  *
*                       interrupciones. Dise¤ado para IBM-AT            *                               una AT.                                 *
*                       sin protocolo XON   XOFF                        *
*=======================================================================*
*/
#include        "stdio.h"
#include        "ctype.h"
#include        "dos.h"
#include        "bios.h"
#include        "conio.h"
#include        "com_seri.h"

typedef struct  QTYPE   	/* Estructura para una FILA circular */
{
	int     count;
	int     front;
	int     rear;
	int     maxsize;
	char    *data;
} QTYPE;

static  char    rxbuf [ RXQSIZE ] , txbuf [ TXQSIZE ];

static  QTYPE   rcvq = { 0, -1, -1, RXQSIZE, rxbuf },
		trmq = { 0, -1, -1, TXQSIZE, txbuf };

/* Indicadores de estado, globales */

int     s_linestatus, s_modemstatus;
int 	c1;

static  QTYPE   *txq = &trmq, *rxq = &rcvq;
static  short   comport = 0 ,
		int_number = 12,
		int_enable_mask = 0xEF,
		int_disable_mask = 0x10;

/* Funciones Prototipo */

int     s_sendchar(int);
int     s_rcvchar(void);
int     s_setup( short , unsigned );
int     s_cleanup( void );

char    *q_getfrom ( QTYPE * , char * );
int     q_puton ( QTYPE * , char * );
int 	ch1;
char 	ch2;

void    interrupt       far     s_inthndlr ( void );

static  void    s_rda ( void );
static  void    s_trmty ( void );
static  void    ( interrupt far *old_handler )();

/*-------------------------------------------------------------*/

main ( int argc, char **argv )
{
   int     ch , port_number = 0;
   int i ;
   /* obtiene no. de puerto , si est  en la linea de comando */

   if ( argc > 1 ) port_number = atoi ( argv [ 1 ] ) - 1;
   printf ( "\nCOMUNICACION SERIE\n\
 9600 bits/s, 8 bits de datos , no paridad ,2 bits de paro\
 USANDO COM%d\n" , port_number + 1 );

   /* Primero se registra el puerto serie */

   s_setup ( port_number , COM_PARAMS );
   comando() ;
}
/*----------- Fin de Programa Principal ----------------------*/

/* ----------------------------------------------------------*
 *  s _ i n t h n d l r                                      *
 *  Manejador para todas las interrupciones del puerto serie *
 *-----------------------------------------------------------*
 */

void interrupt far s_inthndlr ( void )
{
   char     c;
   register        int     int_id , intmask;


   enable();		/* habilita interrupciones */

   while ( TRUE )
   {

	/* Lee el registro de identificaci¢n de interrupciones, IIR */

	int_id = inportb ( IIR );
	if ( bit0(int_id) == 1 )
	    {
	      /* Si bit 0 = 1 no hay interrupci¢n pendiente. Manda una *
	       * se¤al de FIN DE INTERRUPCION(EOI) al 8259 y regresa   *
	       */

	      outportb ( P8259_0 , END_OF_INT );
	      return;
	      }
	      if ( int_id >= RXDATAREADY )
		turnon_int(THREINT,intmask);

	      /* Procesa la interrupci¢n de acuerdo al ID. La lista *
	       * siguiente est  en orden de prioridades.            *
	       */
	      switch ( int_id )
		{
		   case    MDMSTATUS:  /* Lee estado del modem  */
				s_modemstatus = inportb ( MSR );
				break;

		   case    TXREGEMPTY: /*  transmision vacia    */
				s_trmty();
				break;
		   case    RXDATAREADY: /* lee el puerto serie  */
				c = inportb(comport) ;
				ch2=c;
				q_puton(rxq, &c);
				break;
		   case    RLINESTATUS: /* Lee linea de estados */
				s_linestatus = inportb ( LSR );
				break;

		/* Sale si no es uno de los de arriba */

		}
   }

}
/*------------------ Fin de  "s _ i n t h n d l r" -----------------------*/

/*---------------------------------------------------------*
 * s _ t r m t y                                           *
 * Procesa la interrupci¢n "Registro de transmisi¢n vac¡o" *
 *---------------------------------------------------------*
 */

static void s_trmty(void)
{
   char    c;
   register        int     ierval;

   /* Pone un caracter en el registro de transmisi¢n */

   if( q_getfrom(txq,&c) != NULL )
	{
	   outportb ( comport , c );
	   return;
	}


   /* si no hay que mandar -- desactiva interrupiones de THRE */

   ierval = inportb(IER);
   if ( ierval & THREINT ) outportb ( IER , ierval & THREOFF );

}
/*------------------- Fin de "s _ t r m t y"------------------------*/

/*----------------------------------------------------*
 * s _ s e t u p                                      *
 * Inicializa los perifericos para las comunicaciones *
 * Regresa 1 si todo bien , si no regresa 0.          *
 *----------------------------------------------------*
 */

int s_setup ( short port_number , unsigned commparams )
{
   int     intmask;

   if ( port_number < 0 || port_number > 1 )
	report_error( "N£mero de puerto inv lido ! \n" );

   /* Obtiene la base del puerto serie del  rea de datos del BIOS */

   comport = *( BIOS_DATA + port_number );
   if ( comport ==0 )
     {
	report_error ( "El BIOS no puede encontrar el puerto!\n" );
	return ( 0 );
     }

   /* Pone las mascaras para el 8259. Para habilitar interrupciones    *
    * del puerto, se hace un AND con el registro de mascaras 21H. Para *
    * deshabilitar, se hace un OR de la mascara de deshabilitar con el *
    * registro de mascaras. El n£mero de la interrupci¢n es el nivel   *
    * de IRQ + 8. El puerto COM 1 tiene el IRQ 4, COM 2 tiene el IRQ 3.*
    */

    if ( port_number == 0 )
      {
	int_enable_mask = 0xEF;
	int_disable_mask = 0x10;
	int_number = 12;
      }
    if ( port_number == 1 )
      {
	int_enable_mask = 0xF7;
	int_disable_mask = 8;
	int_number = 11;
      }

    /* Obtiene el vector viejo y lo guarda.*/

    old_handler = getvect ( int_number );

    /* Instala el nuevo manejador, llamado s_inthndlr             *
     * Deshabilita las interrupciones cuando cambia el manejador  *
     */

     disable ();
     setvect ( int_number , s_inthndlr );
     enable ();

     /* Establece los par metros para las comunicaciones */
     bioscom(0, commparams, port_number);

     /* Activa interrupciones del puerto de comunicaciones + setup 8259 */

     disable ();

     /* Registra el registro de control del modem ( puerto = MCR ) */

     outportb ( MCR , MCRALL );

     /* Habilita todas las interrupciones de la tarjeta serie
      * ( puerto = IER )
      */

     outportb ( IER , IERALL );

     /* Lee registro de mascara de interrupciones del 8259 y lo escribe
      * de regreso despu‚s de hacer un AND con int_enable_mask.
      */

     intmask = inportb ( P8259_1 ) & int_enable_mask;
     outportb ( P8259_1 , intmask );

     enable ();

     return ( 1 );

}
/*---------------------- Fin de "s _ s e t u p" -------------------------*/

/*-----------------------------------------------------------------*
 * s _ c l e a n u p                                               *
 * Limpia despu‚s de que la sesi¢n de comunicaciones ha terminado. *
 * Desactiva todas las interrupciones.                             *
 *-----------------------------------------------------------------*
 */

int     s_cleanup ( void )
{
   int     intmask;

   /* Desactiva interrupciones de la tarjeta serie */

   disable ();

   /* Primero "resetea" el registro de habilitaci¢n de interrupciones
   * del puerto
   */

   outportb ( IER , IEROFF );

   /* Desactiva todos los bits del registro de control del modem */

   outportb ( MCR , MCROFF );

   /* Despues deshabilita al 8259 para que no reconozca
    * interrupciones  del puerto serie
    */

   intmask = inportb ( P8259_1 ) | int_disable_mask;
   outportb ( P8259_1 , intmask );

   /* Restaura el vector de interrupciones original */

   setvect ( int_number , old_handler );

   /* Habilita las interrupciones de nuevo */

   enable ();
}
/*----------------- Fin de "s _ c l e a n u p" -----------------------*/

/*-----------------------------------------------------------------------*
 * s _ s e n d c h a r                                                   *
 * Pone un caracter en la Fila de transmisi¢n. Regresa un 1 si todo est  *
 * bi‚n, 0 si hubo problemas.                                            *
 *-----------------------------------------------------------------------*
 */

int s_sendchar ( int ch )
{
   int     retval , intmask;

   disable ();
   ch2 = ch;
   retval = q_puton ( txq , ( char * ) &ch );
   enable ();
   turnon_int(THREINT,intmask) ;
   return ( retval );
}
/*------------------ Fin de "s _ s e n d c h a r" ------------------------*/

/*-------------------------------------------------------------*
 * s _ r c v c h a r                                           *
 * Retorna un caracter de la fila de recepcion.                *
 * Retorna -1 si la fila esta vacia.                           *
 *-------------------------------------------------------------*
 */
int s_rcvchar(void)
{
   int ch, intmask;
   disable();
   if (q_getfrom(rxq, (char*)&ch) == NULL)
     {
	enable();
	return(-1);
     }
     else
     {
	/*ch1=ch;*/
	enable();
	return(ch);
     }

}
/*--------------- fin de  s_rcvchar ---------------------------------*/

/*---------------------------------------------------------*
 * q _ g e t f r o m                                       *
 * Copia el proximo elemento de la FILa a una localidad    *
 * Especifica. Retorna el aputandor de este elemento.      *
 *---------------------------------------------------------*
 */
char *q_getfrom( QTYPE *queue, char *data)
{
   char *current;
   current = NULL;
   if(queue->front == -1) return(current);
   current = &(queue->data[queue->front]);
   *data = *current;
   queue->count--;
   if ( queue -> count == 0 )
     {
	/* Si la fila est  vac¡a. Reset el Frente, el
	 * Fin y el Conteo.
	 */

	 queue->front = queue->rear = -1;
	 return ( current );
     }

   /* Incrementa el indice Frontal y checa por "wraparound" */

   if ( queue->front == queue->maxsize - 1 )
	queue -> front = 0;
	else
	   queue->front++;
	return ( current );
}
/*------------------- Fin de "q _ g e t f r o m ------------------*/

/*--------------------------------------------------*
 * q - p u t o n                                    *
 * Pone un caracter dentro de la FILA.              *
 *--------------------------------------------------*
 */
int q_puton(QTYPE *queue, char *data)
{

   /* ch2=*data;*/
   /* Prueba si la FILA esta llena. Retorna un 0 si esta llena. */
   if(queue->count == queue->maxsize) return(0);
   /* En otro caso, ajusta el indice posterior y prueba pora "wrap-around" */
   if(queue->rear == queue->maxsize-1)
       queue->rear = 0;
   else
       queue->rear++;
   /* Guarda el caracter en la FILA  */
   queue->data[queue->rear] = *data;
   queue->count++;
   if(queue->front == -1) queue->front = 0;
   return(1); 			/* Exito en insersion de un caracter */
}
/*----------------- Fin de q _ p u t o n --------------------------*/

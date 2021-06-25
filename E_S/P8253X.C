/* 	fuente		P8253X.c
 *
 *	Objetivo        Procedimiento para la inicializaci¢n de los registros
 *			de un controlador de dispositivos.
 *			El manejo de bits puede realizarse de dos manera:
 *			primera, con una estructura en uni¢n con entero y
 *			segunda, con una estructura y un apuntador a la
 *			estructura.
 *			Con esta t‚cnica, la programaci¢n del controlador del
 *			dispositivo, requiere de una consulta m¡nima del
 *			del C.I. 8253.
 *
 *	Revisi¢n	1 Mayo de 1994.
 */

#include <dos.h>

/* 	Define las distintas funciones, que toman los bit's de los
 *	registros de programaci¢n y estado, del controlador del dispositivo. */

	enum 	modo_contador 	{ binario=0, bcd=1};
	enum 	funcion_temp  	{ contador=0, monoestable, genera_pulsos,\
				  onda_cuadrada, disparo_soft, dispara_hard };
	enum 	modoLeCarg    	{ cerrar_ctr, LeCarg_alto, LeCarg_bajo,\
				  LeCarg_ambos };
	enum	contador	{ cont_1, cont_2, cont_3 };

 /*	Especifica la posicion de los bit's en el registro de programaci¢n.
	Se define un tipo de estructura REGPRO*/
typedef struct regCon{
		int  	m_c:1;		/* modo_contador */
		int 	f_t:3;		/* funcion_temp  */
		int	m_l:2;		/* modo lectura carga */
		int	ctr:2; 		/* numero de contador */

}REGPRO;

/*	Define la direcci¢n de los registro del perif‚rico		*/
#define	REGMODO	0x2301
#define REGCONT	0x2300

/*	Se define una variable del tipo registro de programaci¢n(REGPRO).
	Y se inicializa de acuerdo a modo de operaci¢n deseada.		*/

 REGPRO modoTemporizador = {binario,contador,LeCarg_ambos,cont_2};

/*---	       Definiciones utilizando unio de estructuras		---*/
union {
	int regModo;
	struct{
		int  	m_c:1;		/* modo_contador */
		int 	f_t:3;		/* funcion_temp  */
		int	m_l:2;		/* modo lectura carga */
		int	ctr:2; 		/* numero de contador */

	}regCon;
 }regPRO;


/*      Se inicializa el perif‚rico 8253 contador dos en modo temporizador */
main()
{
	const contador = 1000;		/* factor de divisi¢n del contador */
	int *val;			/* apuntador a reg de control	   */

	val =(int *)&modoTemporizador;	/* Apunta a la estructura para
					   Inicializar con los valores
					   definidos			   */
	outportb(REGMODO, (char) *val); /* Inicializa el registro del 8253 */
	outportb(REGCONT, contador % 256); /* Parte baja del contador      */
	outportb(REGCONT, contador / 256); /* Parte alta del contador      */

	/* Aqui se repite la inicializaci¢n pero utilzando la union	   */

	modoCuadrado( bcd, onda_cuadrada, LeCarg_ambos, cont_2);
	outportb(REGMODO, (char) regPRO.regModo);/* Inicializa el registro
						    del 8253 		   */
	outportb(REGCONT, contador % 256); /* Parte baja del contador      */
	outportb(REGCONT, contador / 256); /* Parte alta del contador      */

	/* Aqui continua el c¢digo de funci¢n del manejador */

}

modoCuadrado(int m_c, int f_t, int m_l, int ctr)
/*	Rutina que inicializa los distintos bit's de la estructura para
 *	definir el modo de operaci¢n del 8253.				   */
{
	regPRO.regCon.m_c=m_c;
	regPRO.regCon.f_t=f_t;
	regPRO.regCon.m_l=m_l;
	regPRO.regCon.ctr=ctr;
}
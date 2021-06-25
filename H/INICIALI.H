/*	iniciali.h
	Define estructuras para la creacion y manejo de tarea

	CITEDI (c) /Depto. de Investigacion 1991  Charles
*/


#define BIT(i)	(1 <<(i-1))
#define NULL 	0
#define ACTIVA 	BIT(1)
#define SUSPEN 	BIT(7)
#define CLRSCR	"\x1b\x45"	/* Equivale a secuencia ESC E */
/*	definicion de estructura de parametros para creacion de tarea
 */

 typedef struct{
	int  	 	seg_tarea;	/* segmento y offset del codigo */
	unsigned int 	off_tarea;   	/* de la tarea */
	int 		tam_datos;
	int 		tam_stack;	/* longitud de la pila */
	int 		dato;		/* reservado */
	char 		nom_tarea[7];  	/* nombre de la tarea */
	} BLOC_DES;

 typedef struct{
	BLOC_DES *off_bloc_des;		/* offset y segmento de bloque de */
	BLOC_DES *seg_bloc_des;         /* descripcion de tarea */
	unsigned char  	nun_tarea;	/* numero */
	unsigned char  	prioridad;
	int	estado;
	int	seg_SS;                 /* registro de segmentos */
	int 	seg_DS;
	int	seg_ES;
	int	off_reg;
	} PARAM_TSK;
 typedef struct{
	int segm;
	int desp;
	} ID_TAREA;

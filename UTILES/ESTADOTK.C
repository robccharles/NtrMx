/* 	fuente 		estadotk.c
 *
 *	objetivo        Informar sobre el estado de las tarea que tiene el
 *			sistema en operacion.
 *
 *	revision	22 Octubre de 1992		rhc
 *			9  Diciembre de 1992
 *
 */

#include "..\incluye\procesos.h"
#include "..\incluye\stdio.h"
#define puts imprime

TAREA desTarea;
REGISTROS far *ptrReg;

estadoTareas()
{
	int i;
	int ptr,ajuste,*temp;
	char *prioridades;
	TAREA *apuntador;
	BLOC_DES far *nomTarea;



	/* obtiene la zona de datos del sistema */
	puts(" segmento de zona de datos: ");
	ponPalabra( ptr=segZDS() );

	/* Ajusta el apuntador de a inicio de las tarea */
	prioridades = (char *)peek(ptr,2);	/* abtiene la tarea inicial */
	ajuste = (int)&desTarea.prioriTarea-(int)&desTarea; /* apunta al campo de
								prioridades */
	/*dump(ptr,prioridades - ajuste );*/
	puts("\r\n\r\n");
	puts("Tarea 	Estado");
	puts(" \tPrio \tSS \tSP \tIP \t\CS \tDS \tES \r\n      ");
	puts("\r\n\r\n");
	do{
		prioridades = prioridades - ajuste ;
		/* apuntador =(TAREA *)prioridad;*/
		apuntador = &desTarea;
		copiaCampo( ptr , prioridades, apuntador);

		/* despliega el contenido de este campo */
		ponByte(apuntador->numTarea);
		puts(":");
		nomTarea = apuntador ->ptrBDC;
		/* puts( (char near *)nomTarea ->nom_tarea); */
		puts( nomTarea ->nom_tarea);
		puts("  ");
		ponByte(apuntador->prioriTarea.estado);
		puts("\t");
		ponByte(apuntador->prioridad);
		puts("\t");
		ponPalabra(apuntador->segPila);
		puts("\t");
		ponPalabra(apuntador->offPila);
		ptrReg = (REGISTROS *)apuntador->offPila; /* toma el campo de */
		temp = (int* )&ptrReg;			  /* registros   */
		temp += 1;                                /* Lo ajusta a  */
		*temp =(int) apuntador->segPila;
                puts("\t");
		ponPalabra(ptrReg -> ip);
		puts("\t");
		ponPalabra(ptrReg -> cs);
		puts("\t");
		ponPalabra(ptrReg -> ds);
		puts("\t");
		ponPalabra(ptrReg -> es);
		puts("\t");
		prioridades =(char *) apuntador->prioriTarea.sigPrioridad;
		puts("\n\r");
	}while( (prioridades ) != NULL);

}

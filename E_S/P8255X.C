/* 	fuente		P8255X.c
 *
 *	Objetivo        Procedimiento para la inicializaci¢n de los registros
 *			de un controlador de dispositivos.
 *			Interface paralela 8255.
 *
 *	Revisi¢n	1 Mayo de 1994.
 */

/* 	Define las distintas funciones, que toman los bit's de los
 *	registros de control, del controlador del dispositivo. */
	/* Registro de Control del 8255 */
	enum 	linea 		{ salida=0, entrada };
	enum 	modoSelec	{ modo_0, modo_1, modo_2 };
	enum 	PonBand		{ desactiva=0, activa =1};

/*	Especifica la posicion de los bit's en el registro de comando.
	Se define un tipo de estructura REGCTR55*/
typedef struct regMod{
		int  	puertoC_bajo:1; /* Puerto C parte baja  */
		int 	puertoB:1;	/* Puerto B             */
		int	selecModoA:1;	/* Selecciona modo A	*/
		int	puertoC_alto:1; /* Puerto C parte alta  */
		int	puertoA:1;	/* Puerto A		*/
		int 	selecModoB:2;   /* Selecciona modo B	*/
		int	modoBandera:1;	/* Habilita modo band.	*/

}REGCTR55;

REGCTR55 modoSalida = { salida, salida, modo_0, salida, salida, modo_0, activa };

main()
{
	int *v;
	v=(int *)&modoSalida;
	*v=*v/2;
}
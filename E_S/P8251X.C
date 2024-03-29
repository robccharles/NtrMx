/* 	fuente		P8251X.c
 *
 *	Objetivo        Procedimiento para la inicializaci�n de los registros
 *			de un controlador de dispositivos.
 *			Con esta t�cnica, la programaci�n del controlador del
 *			dispositivo, requiere de una consulta m�nima del
 *			del C.I. 8251.
 *
 *	Revisi�n	1 Mayo de 1994.
 */

/* 	Define las distintas funciones, que toman los bit's de los
 *	registros de programaci�n y estado, del controlador del dispositivo. */
	/* Palabra de Modo del 8251 */
	enum 	factBaud 	{ sync=0, x_1, x_16, x64};
	enum 	longCarat  	{ bit_5=0, bit_6, bit_7, bit_8 };
	enum 	habParidad    	{ deshab=0, habilita };
	enum	paridad		{ impar=0, par };
	enum	bitParo		{ noVal=0, par_1, par_1m, par_2};

	/* Registro de Comandos */

	enum	TxEn		{ T_Des=0, T_En };
	enum    DTR		{ DTR_Des=0, DTR_En };
	enum	RxEn		{ R_Des=0, R_En };
	enum	SBRK		{ TxD_cero, T_normal };
	enum	ErroReset	{ ResetBand=1 };
	enum	RTS		{ RTS_cero=1 };
	enum	intReset        { ResetSoft=1 };
	enum	EnCasador	{ EnCas=1 };

/*	Especifica la posicion de los bit's en el registro de comando.
	Se define un tipo de estructura REGMOD51*/
typedef struct regMod{
		int  	baud:2;		/* Factor de baudr 	*/
		int 	carat:2;	/* Longitud de caracter */
		int	pEn:1;		/* Habilita paridad 	*/
		int	paridad:1; 	/* Paridad  		*/
		int	bitParo:2;	/* Bit's de paro	*/

}REGMOD51;

/*	Especifica la posicion de los bit's en el registro de modo.
	Se define un tipo de estructura REGCOM51*/
typedef struct regCom{
		int  	txEn:1;		/* Habilita transmisi�n */
		int 	dtr:1;		/* Forza Data Set Ready */
		int	rxE:1;		/* Habilita recepci�n	*/
		int	sbrk:1; 	/* Manda corte de Tx	*/
		int	eR:1;		/* Resetea errores	*/
		int	rts:1;          /* Forza RTS		*/
		int	ir:1;		/* Reset por software   */
		int	eh:1;		/* Habilita Mod Casador */


}REGCOM51;

/*	Especifica la posicion de los bit's en el registro de estado.
	Se define un tipo de estructura REGEST51*/
typedef struct regEst{
		int  	txLista:1;	/* Listo P/Transmisi�n	*/
		int 	rxLista:1;	/* Listo P/Recepci�n 	*/
		int	txVacia:1;	/* Transmisi�n vacia 	*/
		int	erParida:1; 	/* error de Paridad 	*/
		int	erSobre:1;	/* error Sobrescritura 	*/
		int	erCuadro:1;     /* error de Trama	*/
		int	detSinc:1;	/* Detecci�n de Sincro	*/
		int	dsr:1;		/* Grupo de Datos Listo	*/
}REGEST51;



 /*	Especifica la posicion de los bit's en el registro de programaci¢n.
	Se define un tipo de estructura REGPRO*/
typedef struct regCon{
		int  	m_c:1;		/* modo_contador */
		int 	f_t:3;		/* funcion_temp  */
		int	m_l:2;		/* modo lectura carga */
		int	ctr:2; 		/* numero de contador */

}REGPRO;
/*---	       Definiciones utilizando unio de estructuras		---*/
union {
	int regModo;
	struct{
		int  	m_c:1;		/* modo_contador */
		int 	f_t:3;		/* funcion_temp  */
		int	m_l:2;		/* modo lectura carga */
		int	ctr:2; 		/* numero de contador */

	}regCon;
 }regPRO;
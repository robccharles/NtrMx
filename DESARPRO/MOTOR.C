/* 	fuente:		Motor.c
 *
 *	Objetivo:       Procedimiento para el manejo de la direcci�n de
 *			tres motores por medio de un registro de control:
 *
 *                        motor tres    motor dos     motor uno
 *			+-----------------------------------------+
 *                      | M3_1 | M3_0 | M2_1 | M2_0 | M1_1 | M1_0 |
 *			+-----------------------------------------+
 *
 *			Sentido:
 *
 *			    Derecha 	M1_1,M1_1 = 01b
 *			    Izquierda  	M1_1,M1_1 = 10b
 *
 *			    Paro:       M1_1,M1_1 = 00b/11b
 *
 *
 *	Revisi�n:	15 de Mayo de 1994.
 */

 enum sentido { paro1, derecha, izquierda, paro2 };

/*---	Posiciona los bit's para el control de motores   ---*/
union Con{
	int regMotores;
	struct{
		int  	motor1:2;	/* Control motor uno 	*/
		int 	motor2:2;	/* Control motor dos 	*/
		int	motor3:2;	/* Control motor tres	*/
		int	      :2; 	/* No usado 		*/

	}reg;
 }Control;

 #define PUERTO_A 0x2300

 union Con prueba;	/* tambien se puede definir un tipo con union */

 main()
 {
	while(1){
		Control.reg.motor1 = izquierda;
		outportb(PUERTO_A, Control.regMotores);
		Control.reg.motor2 = paro1;
		outportb(PUERTO_A, Control.regMotores);
		Control.reg.motor3 = derecha;
		outportb(PUERTO_A, Control.regMotores);
		Control.reg.motor1 = paro2;
		outportb(PUERTO_A, Control.regMotores);
		Control.reg.motor2 = izquierda;
		outportb(PUERTO_A, Control.regMotores);
		Control.reg.motor3 = izquierda;
		outportb(PUERTO_A, Control.regMotores);
		Control.reg.motor1 = paro1;
		outportb(PUERTO_A, Control.regMotores);
		Control.reg.motor2 = derecha;
		outportb(PUERTO_A, Control.regMotores);
		Control.reg.motor3 = paro2;
		outportb(PUERTO_A, Control.regMotores);
		Control.reg.motor1 = izquierda;
		outportb(PUERTO_A, Control.regMotores);
       }
 }


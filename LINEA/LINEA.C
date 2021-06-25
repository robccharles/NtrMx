#include        <stdio.h>
#include        <ctype.h>
#include        <fcntl.h>

#define     FIN  0x80
#define     HT  0x09
#define     ESC 0X1b
char cad[5], p_reg[5], p_ofs[5], s[40],cad_seg[5], cad_ofs[5] ;
int ban1, ban2 ;

/* Functions Prototypes */
void    trans_prog(void) ;
char  coman  ;
/*--	interpretador de comandos
  --*/
comando ()
{
	int     i, j, ch ;
	int  	val_d = 0, val_reg = 0, val_ofs = 0 ;
	char  	ch2, ch1 ;
	char	a[6] ;
	while ( 1 ) {  			/* 	delay
					 */
		for ( i = 0 ; i < 2000 ; i++ ) ;
			/* 	si hay un caracter en el buffer de recep.
			 */
		while ( ( ch = s_rcvchar() ) != -1 ){
			for ( i = 0 ; i < 100 ; i++ ) ;
			ch1 = ch ;
			putchar(ch1) ;
		}
		if ( kbhit() != 0 )  {
			linea_com( ) ;    /* 	linea de comando */
			if ( coman == 'Q' )
				if ( ban2 )
					mod_reg() ;
				else
					s_sendchar('V') ;
			else
			{
			   if ( ban2 ){  /* se tecleo valor del reg. de offset
				       */
				if ( ban1 )
					/* 	se tecleo valor del reg de
						 segmento
					 */
					val_reg = cad_hex(p_reg) ;
				val_ofs = cad_hex(p_ofs) ;
				if ( (val_reg != -1) && (val_ofs != -1) ) {
					switch( coman ) {
					case 'D' :
						s_sendchar('D') ;
						if ( ban1 ) {
							s_sendchar(0x55) ;
							hex_cad(val_reg) ;
						for ( i = 0 ; i < 4 ; i++ )
							s_sendchar(cad[i]) ;
						}
						else
							s_sendchar(0xaa) ;
						hex_cad(val_ofs) ;
						for ( i = 0 ;i < 4 ; i++ )
							s_sendchar(cad[i]);
						break ;
					case 'L' :
						trans_com(coman,val_reg,
								 val_ofs) ;
						val_d = val_ofs + 0x80 ;
						break ;
					case 'M' :
						trans_com(coman,
							   val_reg,val_ofs) ;
						edita() ;
						break ;
					case 'O' :
						if ( ! ban1 ) {
							printf("    DATO: ") ;
							gets(a) ;
							if ( strlen(a) < 3 ) {
							   for (i=0;i< 2;i++)
								a[i] = toupper
								      (a[i]) ;
							 if(( a[0]>='0'&& a[0]<=
							  '9'||a[0]>='A'&& a[0]
							   <='F')&&( a[1]>= '0'
							   && a[1]<= '9' || a[1]
							    >='A' && a[1] <='F'
									) ){
							      s_sendchar('O');
							      hex_cad(val_ofs) ;
							      for (i=0;i<4;i++)
								s_sendchar(cad
									[i]);
							      s_sendchar(a[0]);
							      s_sendchar(a[1]) ;

							 }
							 else
							   printf("\nerror: el\
							   dato debe ser un\
							   numero hexadecimal\
							   \n-") ;
							}
							else
							 printf("\nerror: el\
							 dato debe ser de 2\
							 digitos\n-") ;
						}
						else
							printf("\n error\n-") ;

						break ;
					case 'I' :
					/*	pertenece al caso i
					 */
					 if ( ! ban1 ) {
						 s_sendchar('I') ;
						 hex_cad(val_ofs) ;
						 for ( i = 0 ; i < 4 ; i++ )
							s_sendchar(cad[i]) ;
						 printf("   DATO LEIDO:  ") ;
						 for ( i = 0 ; i < 2 ; i++ ) {
								ch=esp_recibir
									   ();
								putchar(ch);
						 }
					 }
					 else
						printf("\nerror\n-") ;
					 break ;
					default :
						printf("\n ....error en el\
							  comando\n-") ;
					}
				}
				else
					printf("\n error en el valor\n-") ;
			}
			else {
				switch( coman ) {
				case 'L' :
				      val_ofs = val_d ;
				      trans_com(coman,val_reg,val_ofs) ;
				      val_d +=  0x80 ;
				      break ;
				case 'D' :
				      s_sendchar('D') ;
				      s_sendchar(0) ;  /* no se mandan parametros */
				      break ;
				case 'T' :
				      s_sendchar('T') ;
				      corre() ;
				      break ;
				case 'P' :
				      s_sendchar('P') ;
				      corre() ;
				      break ;
				case 'M' :
				      trans_com(coman,val_reg,val_ofs) ;
				      edita() ;
				      break ;
				case 'E' :
				      s_sendchar('E') ;
				      corre() ;
				      break ;
				case 'R' :
				      printf("Ejucion en Ram\n");
				      s_sendchar('R') ;
				      corre() ;
				      break ;
				case 'C' :
				      trans_prog() ;
				      break ;
				case 'S' :
				      sel_menu() ;
				      break ;
				case 0x0d :
				      printf("-") ;
				      break ;
				case 'A' : /* 	si se regresa un ESC limpia */
					s_cleanup() ; /* 	todo y se sale
						       */
				       exit(0) ;
				       break ;
				default :
				      printf(" error en el comando\n-") ;
				}

			 }
			}
		}
	}
}
/*--  	encabezado del menu de selecciones
   --*/
sel_menu()
{
	 clrscr() ;
	 printf("               MONITOR CITEDI Version 2.0\n\n" ) ;
	 printf("             OPCION                            TECLEAR\n") ;
	 printf("         LISTAR MEMORIA                          L\n") ;
	 printf("         MODIFICAR MEMORIA                       M\n") ;
	 printf("         EJECUTAR UN PROGRAMA EN MEMORIA         E\n") ;
	 printf("         CARGAR UN PROGRAMA EN MEMORIA           C\n") ;
	 printf("         EJECUTAR UN PROGRAMA PASO A PASO        P\n") ;
	 printf("         TRAZO DE PROGRAMA                       T\n") ;
	 printf("         DESENSAMBLAR MEMORIA                    D\n") ;
	 printf("         DESPLEGAR/MODIFICAR REGISTROS           R\n");
	 printf("         SELECCION DE MENU                       S\n\n") ;

	 printf("         SALIR                                   A\n\n>") ;

}
/*-- 		manejo de la opcion de registros
  --*/
mod_reg()
{
	char ch, valor[20] ;
	int i, j,ch1, val_hex ;
	s_sendchar('R') ;
	if ( strcmp("AX",p_ofs) == 0 ) {
		s_sendchar('1') ;
	}
	else
		if ( strcmp("BX",p_ofs) == 0 ){
			s_sendchar ('2') ;
		}
		else
			if ( strcmp("CX",p_ofs) == 0 )
				s_sendchar('3') ;
			else
				if (strcmp("DX",p_ofs) == 0 )
					s_sendchar('4') ;
				else
					if ( strcmp("SI",p_ofs) == 0 )
						s_sendchar('5') ;
				       else
						if ( strcmp("DI",p_ofs)==0)
							s_sendchar('6') ;
						else
							if ( strcmp("SP",
								p_ofs) == 0 )
								s_sendchar
									('7');
							else
								if (strcmp(
								  "BP",p_ofs)
								    == 0 )
									s_sendchar('8') ;
								else
									if ( strcmp("DS",p_ofs) == 0 )
										s_sendchar('9') ;
									else
										if ( strcmp("ES",p_ofs) == 0 )
											s_sendchar(0x0a) ;
										else
											if ( strcmp("SS",p_ofs) == 0 )
												s_sendchar(0x0b) ;
											else
												if ( strcmp("CS",p_ofs) == 0 )
													s_sendchar(0x0c) ;
												else
													if ( strcmp("IP",p_ofs) == 0 )
														s_sendchar(0x0d) ;
													else {
														printf("error") ;
														s_sendchar(ESC) ;
														return ;
													}
	for ( i = 0 ; i < 12 ; i++ ) {
		ch1 = esp_recibir() ;
			if ( ch1 != -1 )
				putch(ch1) ;
			else
				printf("error en la transmision\n") ;
	}
	printf("\n      ? ") ;
	gets(valor) ;
	i = 0 ;
	while ( ( ch = valor[i]) != '\0')
		valor[i++] = toupper(ch) ;
	if ( strlen(valor) < 5 )
		if ( (val_hex = cad_hex(valor)) != -1 ) {
			hex_cad(val_hex) ;
			 for ( i = 0 ; i < 4 ; i++ )
				s_sendchar(cad[i]) ;
		}
		else
			printf("error en el valor\n") ;
	else
		printf(" error\n") ;
}
/*-- 	espera la recepcion de algun dato
   --*/
esp_recibir()
{
	unsigned int j = 0 ;
	int ch ;

	while ( j < 0xffff )
		if ( ( ch = s_rcvchar() ) == -1 )
			j++ ;
		else
			return(ch) ;
	return(-1) ;
}
/*-- 	manda el comando de ejecucion y pone a la PC como terminal
 --*/
corre()
{
	char ch1  ;
	int ch, ren, col ;
	FILE *fp;
	fp = fopen("coma.txt","wb+");

	while ( 1 ) {
		if ( ( ch = s_rcvchar() ) != -1 ) {
			ch1 = ch ;
			if ( 1 ){
				putchar(ch1) ;
				putc((char)ch1,fp);
				printf(" -%02X- ",ch1);  /* Agregar El archivo
							y protocolo ACK */

			}

			else {
				while ( ( ch = s_rcvchar() ) == -1 ) ;
				ch1 = ch ;
				switch(ch1) {
					case 'E' :
					clrscr() ;
					break ;
				case 0x71 :         /* apagar cursor   */

					break ;
				case 0x72 :         /* encender cursor  */

					break ;
				case 'F' :
					while ( ( ch = s_rcvchar() ) == -1 ) ;
						ch1 = ch ;
					ren = ch1 - 0x1F ;
					while ( ( ch = s_rcvchar() ) == -1 ) ;
						ch1 = ch ;
					col = ch1 - 0x1F ;
					gotoxy(col,ren) ;
					break ;
				case 0x55 :
					return ;
				}
			}
		}
		if ( kbhit() != 0 ) {
			ch = getch() ;
			if ( ch == ESC )
			fclose(fp);
			return ;
			s_sendchar(ch) ;
		}
	}
}
/*--   	transmite el valor de un registro
  --*/
trans_com(ch1,val_reg,val_ofs)
char ch1 ;
int val_reg ;
int val_ofs ;
{
	int i ;

	s_sendchar(ch1) ;
	hex_cad(val_reg) ;
	for ( i= 0 ; i < 4 ; i++ ) {
		s_sendchar(cad[i]) ;
	}
	hex_cad(val_ofs) ;
	for ( i= 0 ; i < 4 ; i++ ) {
		s_sendchar(cad[i]) ;
	}
}
/*--	edita la memoria para cambios
 --*/
edita()
{
	int i, ch ;
	char ch2 ;
	for ( i = 0 ; i < 20000 ; i++ ) ;
	while ( ( ch = s_rcvchar() ) != -1 )
		putch(ch) ;
	ch2 = '*' ;                 /* se define ch2 != FIN */
	while ( ch2 != 0x0d ) {
		for ( i = 0 ; i < 2 ; i++ ) {
			if( (ch2 = getch()) != 0x0d ) {
				ch2 = toupper(ch2) ;
				if ( ch2 >= '0' && ch2 <= '9') {
					putch(ch2) ;
					ch2 = ch2 & 0x0F ;
					s_sendchar(ch2) ;
				}
				if ( ch2 >= 'A' && ch2 <= 'F') {
					putch(ch2) ;
					ch2 = ch2 - 0x37 ;
					s_sendchar(ch2) ;
					ch2 = '*' ;
				}
				if ( ch2 == ' ' ) {
					s_sendchar(' ') ;
					putch(' ') ;
					putch(' ') ;
				}
			}
			else {
				s_sendchar(FIN) ;
				break ;
			}
			for ( i = 0 ; i < 10000 ; i++ ) ;
			while ( ( ch = s_rcvchar() ) != -1 ) {
				putch(ch) ;
			}
		}
	}
}
/*--	transmite un archivo al banco de pruebas
  --*/
void trans_prog(void)
{
	int  fd, porcien, conta, i, j, j1, ii ;
	unsigned int tam ;
	float  part, res  ;
	char arch[12] ;
	unsigned char ch, dato ;

	FILE *fp ;
	printf("\n DAME EL NOMBRE DEL ARCHIVO EN BINARIO\n") ;
	scanf("%s",arch) ;
	if (  (fd = open(arch,O_RDONLY | O_BINARY ) ) != -1 ) {
		/* s_sendchar('C') ; */
		tam = filelength(fd) ;
		clrscr() ;
		printf(" TRANSMITIRNDO EL ARCHIVO %s", arch ) ;
		printf("\n LA LONGITUD DEL ARCHIVO ES: %d bytes \n",tam) ;
		fp = fopen(arch,"rb") ;
		ch = tam % 256 ;
		/* s_sendchar( ch ) ;   */ ch=ch;
		ch = tam / 256 ;
		/* s_sendchar( ch ) ;   */
		part = tam / 10 ;
		i = 1 ;
		ii =1;
        	for ( conta = 0 ; conta < tam ; conta++ ) {
			dato = getc(fp) ;
			if( (j=ii%8) == 0){
				/*for ( j = 0 ; j < 5; j++ )    respueta  * /
				    / * respueta */
				 /* while ( ( j1 = s_rcvchar() ) == -1 ){ */
				   while ( ( j1 = s_kbhit() ) == -1 ){
					gotoxy(6,6) ;
					printf("--charater  %d -- valor ii %d j %d", j1, ii, j);
				 }
			}
			for ( j1 = 0 ; j1 < 1000; j1++ );
			while(!s_sendchar( dato )  ) ;
                         if( (j=ii%8) == 0){
			     for ( j = 0 ; j < 3; j++ )
				/* while ( ( j1 = s_rcvchar() ) != -1 ) */
				while ( ( j1 = s_kbhit() ) == -1 )
						;
			 }
                	ii++;

       		     	if ( conta  >= ( part * i ) ) {
           		 	i++ ;
		   	 	res = ((float) conta / (float) tam )   ;

		    		printf(" %6.1f por ciento ", (res * 100)  ) ;
	 		}
      		}
      		gotoxy(4,4) ;
      		printf("EL PROGRAMA SE HA TRANSMITIDO TOTALMENTE") ;
      		fclose(fp) ;
   	}
   	else
       		printf("EL ARCHIVO %s NO ESTA ABIERTO\n",arch) ;
}
/********************************************************************
*   funcion cad_hex()                                               *
* Convierte una cadena de caracteres a un numero hexadecimal        *
*********************************************************************/
int cad_hex(char p[])
{
   	int i,n ;
   	char c ;

   	n =0 ;
   	i = 0 ;
   	while ( ( c = p[i++] ) != '\0' ) {
      		if ( c >= '0' && c <= '9' ) /* caso en que el caracter es decimal */
         		n = 16 * n +  c - '0' ;
         	else
             		if ( c >= 'A' && c <= 'F' ) /*	caso en que el caracter
							es hexadecimal*/
	        		n = 16 * n + c  - 55 ;   /* entre 0AH y 0FH */
             		else    /* Caso contrario regresa un codigo de error*/
                 		return(-1) ;
        }
   	return(n) ;          /* se regresa el valor hexadecimal  */
}
/*-----------------  fin de cad_hex  -------------------------------*/

/*******************************************************************
*   funcion hex_cad()                                              *
* Convierte un numero hexadecimal a una cadena de caracteres       *
********************************************************************/

hex_cad( unsigned int n )
{
   	int  r, i ;

   	for ( i = 0 ; i < 4 ; i++ )
       		cad[i] = '0' ;
        cad[i] = '\0' ;
   	i = 3 ;
   	do {
      		r = n % 16 ;
      		if ( r < 10 )
	 		cad[i--] = r + '0' ;
      		else
	 		cad[i--] = r + 55 ;
   	} while ( ( n /= 16 ) > 0 ) ;
}
/*-------------------  fin de hex_cad  ----------------------------*/

/***********************************************************************
*    funcion  linea_com()                                              *
*  Se hacen las operaciones sobre la linea de comando para determinar  *
* cual es el comando que se desea y se guardan en un arreglo los       *
* caracteres que corresponden al valor de la direccion. Regresa el     *
* comando, un espacio si hay error o un ESC.                           *
************************************************************************/
linea_com(void)
{
   	int i, j, n, ch1  ;
   	char  ch, aux[5] ;

   	for ( i= 0 ; i < 20000 ; i++ ) ;
   	while ( ( ch1 = s_rcvchar() ) != -1 ) {   /* si hay un caracter*/
	 	for ( i = 0 ; i < 100 ; i++ ) ;    /* en el buffer de recep.*/
                ch = ch1 ;
	 	putch(ch) ;                          /* se despliega*/
      	}
   	gets(s) ;
   	i = 0 ;
   	while ( ( ch = s[i]) != '\0')
      		s[i++] = toupper(ch) ;
   	ban1 = 0 ;
   	ban2 = 0 ;
   	i = 0 ;
   	coman = 0x0d ;
   	while ( ( ch = s[i++] ) == ' ') ;
   	if ( ch != '\0' ) {
      		coman = ch ;
      		while ( ( ch = s[i++] ) == ' ') ;
      		if ( ch != '\0' ) {
	 		i-- ;
	 		j = 0 ;
	 		ban2 = 1 ;
		 	/* 	se guarda en el arreglo p[j] los caracteres
		  	*/
	 		while( s[i] != ':' && s[i] != '\0' ) {
			 	/* 	que corresponden a la direccion
			  	*/
	    			aux[j++] = s[i++] ;
		 	}
		 	aux[j] = '\0' ;
		 	if ( j > 4 ) {
		    		coman = ' ' ;
		   		 return ;
		 	}
		 	if ( s[i] != '\0' ){   /* se tecleo ':' */
		    		for ( n = 0 ; n <= j ; n++)
		       			p_reg[n] = aux[n] ;
                                ban1 = 1 ;
		    		j = 0 ;
		    		i++ ;
		    		while( s[i] != '\0' )
	       			p_ofs[j++] = s[i++] ;
		    		p_ofs[j] = '\0' ;
		    		if ( j > 4 ) {
		       			coman = ' ' ;
		       			return ;
		    		}
		 	}
		 	else
		    		for ( i = 0 ; i <= j ; i++)
		       			p_ofs[i] = aux[i] ;
        	}
   	}
}
/*------------------  fin de linea_com  ---------------------------*/

int s_kbhit()
{
	if(kbhit())
		return (getch(stdin));
	else
		return (-1);
}


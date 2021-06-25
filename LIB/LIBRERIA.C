/* 	fuente 		libreria.c
 *
 *	objetivo        Libreria estandar
 *
 *	revision	17 Septiembre rhc
 *
 */
#include "..\incluye\iniciali.h"
#define MAXGETS 120
#define CAMPANA '\x07'
int isspace(char s)
/* 	regresa uno si el caracter es un espacio, un cero
 * 	en caso contrario esta puede ser sustituida por un macro
 */
{
	if(s == ' ' || s =='\t' || s == '\r' || s==':')
		return 1;
	else
		return 0;
}

int cadHex(char p[])
/*
 * 	Convierte una cadena de caracteres a un numero hexadecimal
 */
{
	int  i,n;
	char c;

	n=i=0;
	while( (c=p[i++]) != '\0' ){
		if( c >= '0' && c <= '9' ) 	/* caso en que el caracter */
			n = 16*n + c - '0';	/* es decimal */
		else
			if(c >= 'a' && c <= 'f')/* caso en que el caracter
						   es hexadecimal*/
				n = 16 * n + c  - 87 ;   /* entre 0AH y 0FH */
			else    		/* en caso contrario */
                 		return(-1);	/* regresa un codigo de error*/
        }
   	return(n) ;          /* se regresa el valor hexadecimal  */
}

int cpstr(char *s,char *p)
/* 	funcion que compara dos cadena de caracteres
 *	si las cadenas son iguales retorna 0
 *	en otro caso retorna 1 o -1
*/
{
	while(*s++ == *p++ ){
		if(*s =='\0'&& *p =='\0')
			return 0;
	}
	if(*(s-1) < *(p-1) )	/* ver para el caso de comparacion > */
		return 1;   	/* se debe correguir porque esta mal ?? */
	else
		return -1;
}
char *gets(char *sptr)
/*    	Obtiene una linea de datos a la entrada solo filtra el caso de
 *      borrado de caracter. Agregar mas funciones para el manejador de
 *	la terminal
 */
{
	int i=0,ch=0;
	char *temp;
	temp = sptr;
	do{

		ch=getch();	/* obtiene un caracter */
		switch(ch){
			case '\b':
				sptr--;
				putchar((char)'\b');
				putchar((char)' ');
                                putchar((char)'\b');
				break;

			default:
				if( i < MAXGETS){
					*sptr=(char)ch;
					sptr++;
					i++;
					putchar((char)ch);/* ponlo en la pantalla */
				}else
					putchar(CAMPANA);
		}


	}while( ch != '\r'); 		/* hasta que sea el cambio de linea */
	if (*temp == '\r')
		return NULL;
	else{
		*sptr=NULL;
		return temp;
	}
}

ponByte(int num)
/*	imprime un entero de un byte en pantalla en formato hexadecimal
 *	ponByte(int)
 */
{
	int temp;
	num = num &0xff;	/* Enmascara la parte baja */
	temp = num & 0xf;	/* Separa el nibble bajo */
	num = num >> 4;		/* Sera el nibble alto 	*/
	ponHex (num);		/* Imprime parte baja */
	ponHex (temp);		/* Imprime parta alta */
}

ponHex(int hex)
/*	Imprime un caracter en formato hexadecimal
 *
 */
{
	hex = hex & 0xf;
	if (hex > 9)
		hex =hex + 7;	/* imprime letra de A-F */
	putchar( (hex + '0') );	/* imprime numero de 0-9 */
}

ponPalabra(int num)
/*	imprime un entero en pantalla en formato hexadecimal
 *	ponPalabra(int)
 */
{
	int temp;
	temp=num&0xff;			/* separa parte alta y baja */
	ponByte( (num&0xff00) >>8);	/* imprime parte baja */
	ponByte( temp);			/* imprime parte alta */
}
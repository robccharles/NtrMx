/* 	fuente 		dump.c
 *
 *	objetivo        Imprime un bloque de memoria en puesto de entrada y
 *			salida estandar (puerto serie)
 *
 *	revision	9  Diciembre de 1992		rhc
 *
 */

/*--	Despliega un bloque de 256 bytes en pantalla con su codigo ASCII
 --*/
dump(segmento, inicio)
{
	int i,j ;
	unsigned temp,dato;
	char ch,ch1;

	for(i=0; i<8; i++ ){
		putchar('\n');
		ponPalabra(segmento);	/* imprime el segmento */
		putchar(':');
		ponPalabra(inicio+i*16);
		putchar(' ');
		for(j=0; j <16; j++){	/* imprime una linea con el valor hex */
			dato=peekb(segmento,inicio+i*16+j);
			ponByte (dato);
			putchar(' ');
		}
		for(j=0; j <16; j++){	/* imprime una linea con el valor ASCII */
			ch=peekb(segmento,inicio+i*16+j);
			if((int)ch > 31)
				putchar(ch);
			else
				putchar('.');
		}

	}
	putchar('\n');
}
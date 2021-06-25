	if( frente != atras && (flag==FALSO)){
		outportb(P8251DAT,ch);		/* inicia la transmision */
		while ( (inportb(P8251CON) & 0x01) == 0 ) ;
		outportb(P8251DAT,ch);
		flag=VERDAD;
		enable();
	}else{
		if( (frente == atras - 1) || (frente==cola && atras==cabeza)){
			enable();
			return -1;	/* el buffer esta lleno */
		}
		*frente++ = ch;		/* introduce el caracter en buffer 	*/


					/* e incrementa el apuntador del buffer */
	}

	if(frente-1==cola)              /* prueba si hay que dar vuenta a los */
		frente=cabeza;		/* apuntadores de inicio y final */
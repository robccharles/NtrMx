/* 	fuente 		shell.c
 *
 *	objetivo        Programa de interpretador de comandos para ntrmx
 *
 *	revision	21 Septiembre 1993	rhc
 *
 */
#include <ctype.h>
#include "..\incluye\procesos.h"
#include "..\prueba\memoria.h"
#include "..\incluye\stdio.h"
#define printer imprime
#define puts imprime
#define INICOM	0x100		/* punto de entrada de un archivo en formato COM */
#define PARRAFO 16		/* tama�o en byte de un parrafo			 */
#define ENCABEZADO 16		/* tama�o de encabezado en parrafos		*/


#define SALIR 's'
#define COMANDOS 11
/*#define DEPURAR  1*/ 	/* define si se incluye depurar */

/* funciones prototipo,  incluirlas en un archivo de cabecera */

char *gets(char *), *obtmarca(char *), *marca(char *);
int cadHex(char p[]), cpstr(char *s,char *p);

static char *ptr;

/* comandos del shell */

int func_lista(),func_tarea(),func_mem(),func_final(),cargaProg(),func_duerme(),ejecuta();
int ayuda();
int (*ptrfunc[])()={ayuda,cargaProg,cargaProg,func_duerme,ejecuta,ejecuta,func_lista,\
			func_lista,func_tarea,\
				func_tarea,func_mem,func_final,func_final};

/* arreglos para los argumentos de los comandos equivalentes argv y argc */

char bufferCom[80], *argumentos[10];	/* char *argv[]  arreglo de argumentos */
int numArg;				/* int argc 	numero de argumentos */
	static	unsigned char *comandos[]={
				"ayuda",
				"carga",
                                "c",
				"duerme",
				"ejecuta",
				"x",
				"l",
				"lista",
				"t",
				"tareas",
				"memoria"};

shell()
{
	int i;
	static	unsigned char buffer3[80],*comando,*ptr1;
	/* nombres de los comandos validos */


	printer("\n\r\nInterpretador de comandos del NTRMX ver 1.1 (c) 1993\n\n");
	do{
		printer("&");			/* progmt del shell */
		comando=obtmarca(buffer3);	/* obtiene una cadena de comandos */
		ptr=buffer3;          		/* apuntador usado marca, mejorar */
		if( (comando) == NULL){		/* si fue nula solo imprime prog & */
			printer("\n\r");
			continue;
		}
		/* conforma los argumentos del comando */

		i=0;				/* numero de argumento cero */
		argumentos[i]=bufferCom;	/* separa los tokens hasta el final */
		while( (ptr1=marca( argumentos[i] )) != NULL){
			i++;
			argumentos[i]=ptr1;
		}
		numArg=i;			/* numero de argumentos capturados */
		for(i=0;i<COMANDOS;i++)  	/* compara el token uno con los
						   camandos validos */
			if( cpstr(comandos[i],argumentos[0]) == 0)
				break;
		ptrfunc[i]();			/* llama a el comando valido o funciones */

 #ifdef DEPURAR
		for(i=0;i<numArg;i++){		/* imprime los argumentos */
			printer(" [");
			putchar( i + '0');
			printer("]");
			printer(argumentos[i]);
		}
 #endif
	}while(*comando !=(char) SALIR); /* se repite hasta el comaando de salida */
}

char *obtmarca(char *sps)
/* 	Lee una linea de comandos  y los guarda en el buffer de Comandos(bufferCom)
 *      borra el buffer anterior
 */
{
	int i;
	char *ptr;
	for(i=0; i<100 ;i++)      	/* borra buffer de argumentos */
		bufferCom[i]=0x0;
	sps = gets(sps);
	ptr = sps;
	/* Convierte la cadena a minusculas */
	while(*ptr != NULL){
		if( isupper(*ptr) )
			*ptr = _tolower(*ptr);
		ptr++;
	}


					/* falta convertir a minusculas */
	return sps;
}

char *marca(char *token)
/*	separa los token de una cadena de caracteres
 *	y los copia en un apuntador
 *	si esta al final de la cadena regresa un nulo
 */
{
	while( *ptr !='\x0')
	{
		while(isspace(*ptr))	/* salta espacios en blanco */
			ptr++;
		if(*ptr == '\x0')
			return NULL;	/* Es nulo si solo fueron espacios */
		while( !isspace(*ptr) && *ptr !='\x0')
			*token++=*(ptr++);
		*token='\x0';		/* Pon el final de la cadena */
		return ++token;		/* retorna el apuntador */
	}
	return NULL;
}

/* funciones del shell */
func_lista()
/* 	lista el contenido de la memoria en formato hex y ASCII
 */
{
	static unsigned int offset,segmento;
	if( numArg > 1){
		offset=cadHex(argumentos[1]);
	}
	if( numArg > 2){
		offset=cadHex(argumentos[2]);
		segmento=cadHex(argumentos[1]);
	}
	if( !cpstr(argumentos[1],"/h")){

		printer("\n\r Ayuda para el comando Uno\n");
		printer("\n\r ...........el comando Uno\n");
		printer("\n\r .......... el comando Uno\n");
	}
	dump(segmento,offset);
	offset = offset + 0x80;
}

func_tarea()
/*	Lista el estado de los procesos activo del nucleo NTRMX.
 */
{
	estadoTareas();
}

func_mem()
/*	 Imprime la ocupacion de la memoria por los procesos y
 *	la cantidad de memoria libre.
 */
{
	printer("\n\rEstado de la memoria \n");
	estadoTareas();
	/*	estadoMemoria(); */
}

func_duerme()
/*	Duerme una tarea durante cierto intervalo de tiempo
 */
{
	int pulsos;
	if( numArg == 1){
		printer("\n\r Falta el par�metro de n�mero de pulsos\n");
		return;
	}
	if( (pulsos = cadHex(argumentos[1]) ) != -1){
		printer("\n\rLa tarea duerme por un tiempo de: ");
		printer(argumentos[1]);
		printer(" tics\n\n");
		duerme(pulsos);
		}
	else
		printer("\nerror en argumento del tiempo\n\n");
}

func_final()
/* 	A esta funcion llegan todos los comandos erroneos
 */
{
	printer("\n\rError en el comando\n\r");
}
	PARAM_TSK *ptrD=NULL;
cargaProg()
/*	Carga un programa en memoria.
 *		Solicita el area de memoria de acuerdo al tama�o del
 *		programa mas el encabezado.
 *		Despues lee por el puerto estandar el programa y lo
 *		carga a la zona de memoria asignada.
 *
 *	Nota: falta indicar errores
 */
{
	unsigned char *dir,temp,*raiz;
	static int  tam, i, *temp2;

	puts("\nCarga el program desde la PC\n\t\t<ESC>\n\t\t<c>\n\n");
	temp=getch();			/* imprime el valor de la C */
	tam = (char )getch() & 0xff;    /* toma el tama�o del archivo, parte baja */
	tam = tam + ( getch() << 8); 	/* parte alta				  */
	dir =(char *)asigMem(POOL1, tam/PARRAFO\
				 + ENCABEZADO+1);		/* solicita memoria */
	dir =(char*) ( (int)dir << 4 ) + INICOM;         /* ajusta el apuntador */
	raiz=dir;
	for(i=tam ; i > 0 ; i--){			/* lee el programa y lo carga */
		temp =(unsigned char) getch();
		*dir++ = temp;
		}

	/* 	llena los segmentos de los estructura para la creacion de tarea */
	temp2 = (int *)(raiz+4);		/* [apuntador] a la inicio de PARAM_TSK */
	temp2 =(int *) *temp2;			/* es la direccion de la estructura */
	i = ( (int) raiz >> 4) - ENCABEZADO;	/* Es el segmento asignado a la tarea */
	ptrD = (PARAM_TSK *) (i*8 + temp2 );	/* diferencia de segmentos */

	ptrD -> seg_bloc_des =(BLOC_DES *) i;	/* actualiza segmento el segmento */
	ptrD -> seg_SS = i;			/* actualiza el segmento de datos */
	ptrD -> seg_DS =i;			/* +++ */
	temp2 = (int *)ptrD -> off_bloc_des;     /* Ahora a que apunta al bloque 2 */
	temp2 = (i*8+ temp2);			/* ajusta diferencia de segmentos */
	*temp2 = i;				/* actualiza el segmento de punto de entrada */
	ponPalabra(raiz);			/* El punto de entrada del codigo */
	/* creaTarea(ptrD); */ 				/* crea la tarea */
	/* este programa se puede mejora con apuntadores far */

}

ejecuta()
{
	if (ptrD != NULL){
		creaTarea(ptrD);
		ptrD=NULL;
	}else{
		puts(__FILE__);puts(" ");
		puts(__DATE__);puts(" ");
		puts(__TIME__);puts(" ");
		ponPalabra(__LINE__);
		puts("\nError: no se ha cargado codigo para la tarea \n");
	}
}


 char *textoAyuda[]={
		"Men� de ayuda",
		"Carga un programa",		/* repite */
		"Carga un programa",
		"Duerme un proceso",
		"Crea y ejecuta una tarea",
		"Crea y ejecuta una tarea",
		"Lista la memoria",
                "Lista la memoria",
		"Lista los descriptores de tareas creadas en NTRMX",
		"Lista los descriptores de tareas creadas en NTRMX",
		"Lista la ocupaci�n de memoria de las tareas",
	};

ayuda()
{
	int i;
	puts("\nlista de comandos de shell del NTRMX 1.0\n");
	for(i=0; i<COMANDOS ; i++){
		puts(comandos[i]);
		puts(":\t\t");
		puts(textoAyuda[i]);
		puts("\n");
	}

}

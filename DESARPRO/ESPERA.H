#define  EPROM 0

int tarea1Codigo(void),tarea2Codigo(void);

/* bloque para la creacion de tareas de prueba */
void inicio(void);
extern BLOC_DES bloc_De;
PARAM_TSK parametros={&bloc_De,NULL,03,05,ACTIVA,0x480,0,0,0};
#if EPROM
 BLOC_DES bloc_De={0xf000,(int)tarea1Codigo,0, 0x90,0,"TAR1 "};
#else
 BLOC_DES bloc_De={0,(int)tarea1Codigo,0, 0x90,0,"TAR1 "};
#endif


#define UNO 02
#define DOS 03
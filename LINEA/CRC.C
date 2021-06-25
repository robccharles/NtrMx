/*  Calcula el CRC hay que ver como va dando el resultado porque no
 *  funciona correctamente
 */
#include <stdio.h>
typedef unsigned char byte;
typedef unsigned int word;

void Calc_CRC(byte bl, word *ax);


main()
{
	/* word b = 0x1756; */
	word b = 0x00;
	unsigned char ch =0;
	printf("dato de entrada %04X\n",b);
	ch=0x1B;
	Calc_CRC(ch,&b);
	printf("byte = %02X, dato = %04X\n", ch, b);


}


void Calc_CRC(byte bl, word *ax) {
  word dx;
  byte *al = (byte *)ax;
  byte *ah = al+1;
  byte *dl = (byte *)&dx;
  byte *dh = dl+1;
  byte tmp;
  tmp = *al;
  *al = *ah;
  *ah = tmp;
  dx = *ax;
  *dl = *al ^ bl;
  *dl = *dl ^ (*dl / 16);
  *ah = *dl * 16;
  *dh = *dh ^ *ah;
  *al = *dl;
  *ah = 0;
  *ax *= 32;
  *ax = *ax ^ dx;
} /* Calc_CRC */


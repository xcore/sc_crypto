#include "AESincludes.h"
#include "AESfunctions.h"

#ifdef GENERATE_TABLES

#define Xtime(x, y) if(x & 0x80) y = (x << 1) ^ 0x1b; else y = (x << 1) ^ 0x00

#pragma unsafe arrays
static void GenerateM0(unsigned int table[256])
{
	unsigned char i=0;
	unsigned char x1, x4, x8;

	while(1) {
		Xtime(i, x1);					
		Xtime(x1, x4);
		Xtime(x4, x8);

		table[(unsigned)i] = ((x8 ^ x1 ^ i) << 24) |\
						((x8 ^ x4 ^ i)	<< 16) |\
						((x8 ^ i) << 8)	|\
						((x8 ^ x4 ^ x1));
		
		if (i == 255) {
			break;
		}
		i++;
	}
}

#pragma unsafe arrays
static void GenerateSBoxInv(unsigned char sBoxInv[256])
{
	unsigned i;

	for(i = 0; i < 256; i++) {
		sBoxInv[(unsigned)sBox[i]] = i;
	}
}

void DecryptInit(void)
{
	GenerateSBoxInv(sBoxInv);
	GenerateM0(M0);
#ifndef FEWER_TABLES
	RotateTable(M1, M0);
	RotateTable(M2, M1);
	RotateTable(M3, M2);
#endif
}

#pragma unsafe arrays
static void GenerateT0(unsigned int table[256])
{
	unsigned i=0;
	unsigned char x1, val;

	while (1) {
		val = sBox[i];
		Xtime(val, x1);

		table[i] = 	((x1 ^ val)  << 24) |
					 (val << 16) |
					 (val << 8)	|
					 (x1);

		if(i == 255) {
			break;
		}
		i++;
	}
}

static void RotateTable(unsigned dst[256], unsigned src[256])
{
	for (unsigned i = 0; i < 256; i++) {
		unsigned value = src[i];
		dst[i] = (value >> 24) | (value << 8);
	}
}

void EncryptInit(void)
{
	GenerateT0(T0);
#ifndef FEWER_TABLES
	RotateTable(T1, T0);
	RotateTable(T2, T1);
	RotateTable(T3, T2);
#endif
}

#else

void DecryptInit(void)
{
}

void EncryptInit(void)
{
}

#endif

/*
 * source.c
 *
 *  Created on: May 8, 2025
 *      Author: Annnguyen
 */




#include <stdio.h>
#include "io.h"
#include "system.h"
void main() {
	int data;
	char i;
	for (i = 0; i < 16; i++) {
		IOWR(MEMORY_0_BASE, i, i);
	}
	for (i = 0; i < 16; i++) {
		data = IORD(MEMORY_0_BASE, i);
		printf("data[%d] = %d\n", i, data);
	}
}

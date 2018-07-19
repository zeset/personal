#include "TheOutsider.h"

extern void TuplaSwap(Tupla a, unsigned long i, unsigned long j) {
  /* Función de swappeo de la estructura tupla, que va a ser explicada
  mas adelante */

    u32 tmp = a[i].vert1;
    a[i].vert1 = a[j].vert1;
    a[j].vert1 = tmp;
		tmp = a[i].vert2;
		a[i].vert2 = a[j].vert2;
		a[j].vert2 = tmp;
}

extern unsigned long partiTupla(Tupla a, unsigned long izq, unsigned long der) {
  /* Función auxiliar de nuestro quick_sort de nuestra estructura de tuplas
  usada para ordenar el arreglo de tuplas*/
	unsigned long pivot = izq;
	unsigned long i = izq + 1;
	unsigned long j = der;
	while (i <= j) {
		if (a[i].vert1 <= a[pivot].vert1) {
			i++;
		} else if (a[j].vert1 >= a[pivot].vert1) {
			j--;
		} else if (a[i].vert1 > a[pivot].vert1 && a[j].vert1 < a[pivot].vert1) {
			TuplaSwap(a,i,j);
			i++;
			j--;
		}
	}
	TuplaSwap(a,pivot,j);
	return(j);
}

extern void QuickSortTupla_rec(Tupla a, unsigned long izq, unsigned long der) {
	unsigned long pivot;
	if (der > izq) {
		pivot = partiTupla(a,izq,der);
    if (pivot > 0) {
      QuickSortTupla_rec(a,izq,pivot-1);
    }
      QuickSortTupla_rec(a,pivot+1,der);
	}
}

extern void QuickSortTupla(Tupla a, unsigned long length) {
  /*Algoritmo de ordenación de tuplas, las ordena de menor a mayor teniendo
  en cuenta el primer elemento de la estructura */
    QuickSortTupla_rec(a, 0, (length == 0) ? 0 : length - 1);
}

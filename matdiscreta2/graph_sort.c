#include "TheOutsider.h"

extern void Verticeswap(Grafo G, unsigned long i, unsigned long j) {
    Vertice tmp = G->vs[i];
    G->vs[i] = G->vs[j];
    G->vs[j] = tmp;
}


extern unsigned long GraphpartitionPorNombre(Grafo G, unsigned long izq, unsigned long der) {
	unsigned long pivot = izq;
	unsigned long i = izq + 1;
	unsigned long j = der;
	while (i <= j) {
		if (G->vs[i]->nombre <= G->vs[pivot]->nombre) {
			i++;
		} else if (G->vs[j]->nombre >= G->vs[pivot]->nombre) {
			j--;
		} else if (G->vs[i]->nombre > G->vs[pivot]->nombre && G->vs[j]->nombre < G->vs[pivot]->nombre) {
			Verticeswap(G,i,j);
			i++;
			j--;
		}
	}

	Verticeswap(G,pivot,j);
	return(j);
}

extern void OrdenNatural_rec(Grafo G, unsigned long izq, unsigned long der) {
	unsigned long pivot;
	if (der > izq) {
		pivot = GraphpartitionPorNombre(G,izq,der);
    if (pivot > 0) {
      OrdenNatural_rec(G,izq,pivot-1);
    }
      OrdenNatural_rec(G,pivot+1,der);
	}
}

extern unsigned long GraphpartitionPorGrado(Grafo G, unsigned long izq, unsigned long der) {
	unsigned long pivot = izq;
	unsigned long i = izq + 1;
	unsigned long j = der;
	while (i <= j) {
		if (G->vs[i]->grado >= G->vs[pivot]->grado) {
			i++;
		} else if (G->vs[j]->grado <= G->vs[pivot]->grado) {
			j--;
		} else if (G->vs[i]->grado < G->vs[pivot]->grado && G->vs[j]->grado > G->vs[pivot]->grado) {
			Verticeswap(G,i,j);
			i++;
			j--;
		}
	}
	Verticeswap(G,pivot,j);
	return(j);
}

extern void OrdenWelshPowell_rec(Grafo G, unsigned long izq, unsigned long der) {
	unsigned long pivot;
	if (der > izq) {
		pivot = GraphpartitionPorGrado(G,izq,der);
    if (pivot > 0) {
      OrdenWelshPowell_rec(G,izq,pivot-1);
    }
      OrdenWelshPowell_rec(G,pivot+1,der);
	}
}

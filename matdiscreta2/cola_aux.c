#include "TheOutsider.h"

extern cola CrearCola() {
	cola q = (cola)malloc(sizeof(_cola));
	ColaVacia(q);
	return (q);
}

extern void ColaVacia(cola q) {
	q->inicio = NULL;
	q->fin = NULL;
}

/* pre: !is_full_queue(q) */
extern void Encolar(cola q, u32 elem) {
	cnodo p = (cnodo)malloc(sizeof(struct _cnodo));
	p->elem = elem;
	p->siguiente = NULL;
	if (q->fin == NULL) {
			q->inicio = p;
			q->fin = p;
	} else {
		(q->fin)->siguiente = p;
		q->fin = p;
	}
}

/* pre: !is_empty_queue(q) */
extern u32 Cabeza(cola q) {
	u32 elem;
	elem = (q->inicio)->elem;
	return elem;
}

/* pre: !is_empty_queue(q) */
extern void Decolar(cola q) {
	cnodo p;
	p = q->inicio;
	if (q->inicio == q->fin) {
		q->inicio = NULL;
		q->fin = NULL;
	} else {
		q->inicio = (q->inicio)->siguiente;
	}
	free(p);
}

extern bool Cola_vacia(cola q) {
	return (q->inicio == NULL);
}


extern void ExterminateCola(cola q) {
	while (!Cola_vacia(q)) {
		Decolar(q);
	}
	free(q);
}

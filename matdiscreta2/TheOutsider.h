#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>

typedef uint32_t u32;
typedef struct _pila * pila;
typedef struct _cola * cola;

typedef struct GrafoSt *Grafo;
typedef struct _Vertice_ *Vertice;
typedef struct TuplaSt *Tupla;

struct GrafoSt {
  u32 vn; /* numero de vertices */
  u32 ln; /* numero de lados */
	u32 cn; /* cant de colores del grafo */
	Vertice *vs; /* array donde guardamos vertices */
};

struct _Vertice_ {
  u32 nombre;
  u32 pos_i;
  u32 color;
  u32 grado;
  Vertice vecinos[];
};

struct TuplaSt {
  u32 vert1;
  u32 vert2;
};

typedef struct _cnodo * cnodo;

struct _cnodo{
  u32 elem;
  cnodo *siguiente;
};

typedef struct _pila {
    cnodo la_pila;
} _pila;

typedef struct _cola {
    cnodo inicio;
    cnodo fin;
} _cola;


void quick_sort(Tupla a, unsigned long length);

Grafo ConstruccionDelGrafo(); //done, falta optimizar by José

void DestruccionDelGrafo(Grafo G); //done José

u32 NumeroDeVertices(Grafo G); //done pau Chequeado, funciona

u32 NumeroDeLados(Grafo G);		//done pau Chequeado, funciona

u32 NumeroDeColores(Grafo G); 		//done pau Chequeado, funciona

u32 NombreDelVertice(Grafo G, u32 i);   //done pau Chequeado, funciona

u32 ColorDelVertice(Grafo G, u32 i);  //done pau Chequeado, funciona

u32 GradoDelVertice(Grafo G, u32 i);  //done pau Chequeado, funciona

u32 ColorJotaesimoVecino(Grafo G, u32 i,u32 j); //done pau, Chequeado, funciona

u32 NombreJotaesimoVecino(Grafo G, u32 i,u32 j); //done pau, Chequeado, funciona

u32 GradoJotaesimoVecino(Grafo G, u32 i, u32 j); //listo

u32 NotSoGreedy(Grafo G,u32 semilla); // Done José, hay lugar para optimizar

int Bipartito(Grafo G); //liSTA

void OrdenNatural(Grafo G);

void OrdenWelshPowell(Grafo G);

void AleatorizarVertices(Grafo G,u32 semilla); //lista apparently

void ReordenManteniendoBloqueColores(Grafo G,u32 x);

//Ordenación de Tupla

void TuplaSwap(Tupla a, unsigned long i, unsigned long j);

unsigned long partiTupla(Tupla a, unsigned long izq, unsigned long der);

void QuickSortTupla_rec(Tupla a, unsigned long izq, unsigned long der);

void QuickSortTupla(Tupla a, unsigned long length);

// Auxiliares

void InsertarVertice(Grafo G, u32 vertice_input, u32 m, unsigned long i);

u32 ReturnPosition(Grafo G, u32 nombre, u32 largo);

u32 randum (u32 min, u32 max, u32 seed);

// Funciones de Pila

extern pila CrearPila();

extern void Apilar(u32 color, pila s);

extern void Eliminar(u32 color, pila s, u32 largo);

extern void ExterminatePila(pila a);

//Funciones de Cola

extern cola CrearCola();

extern void ColaVacia(cola q);

extern void Encolar(cola q, u32 elem);

extern u32 Cabeza(cola q);

extern void Decolar(cola q);

extern bool Cola_vacia(cola q);

extern void ExterminateCola(cola q);

//Funciones auxiliares para la ordenación del Grafo

extern void Verticeswap(Grafo G, unsigned long i, unsigned long j);

extern unsigned long GraphpartitionPorNombre(Grafo G, unsigned long izq, unsigned long der);

extern void OrdenNatural_rec(Grafo G, unsigned long izq, unsigned long der);

extern unsigned long GraphpartitionPorGrado(Grafo G, unsigned long izq, unsigned long der);

extern void OrdenWelshPowell_rec(Grafo G, unsigned long izq, unsigned long der);

// Funcion de randomizar
extern u32 TakeRandom(pila a, u32 min, u32 max, u32 semilla);

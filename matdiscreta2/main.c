#include "TheOutsider.h"

int main() {
    printf("Hola mundo \n");
    Grafo G = NULL;
    G = ConstruccionDelGrafo();
    OrdenWelshPowell(G);
    OrdenNatural(G);
    AleatorizarVertices(G, 19238281);
    ReordenManteniendoBloqueColores(G,2);

    u32 b = 0;
    printf("Adios mundo \n");
    u32 a = NumeroDeVertices(G);
    printf("Número de vértices %u\n", a);
    a = NumeroDeLados(G);
    printf("Número de lados %u\n", a);
    a = NumeroDeColores(G);
    printf("Número de colores %u\n", a);
    for(u32 i = 0; i < NumeroDeVertices(G); i++) {
      a = NombreDelVertice(G, i);
      b = GradoDelVertice(G, i);
      printf("Nombre del vértice %u: %u, color: %u\n",i, a, G->vs[i]->color);
    }
    /*
    for(u32 i = 0; i < NumeroDeVertices(G); i++) {
      a = ColorDelVertice(G, i);
      printf("Color del vértice %u: %u\n",i, a);
    }
    for(u32 i = 0; i < NumeroDeVertices(G); i++) {
      a = GradoDelVertice(G, i);
      printf("Grado del vértice %u: %u\n",i, a);
    }
    for(u32 i = 0; i < NumeroDeVertices(G); i++) {
      for(u32 j = 0; j < G->vs[i]->grado; j++) {
        a = ColorJotaesimoVecino(G, i, j);
        printf("Color del %u vecino del vértice %u: %u\n",j, i, a);
      }
    }

    for(u32 i = 0; i < NumeroDeVertices(G); i++) {
      for(u32 j = 0; j < G->vs[i]->grado; j++) {
        a = GradoJotaesimoVecino(G, i, j);
        printf("Grado del %u vecino del vértice %u: %u\n",j, i, a);
      }
    }

    for(u32 i = 0; i < NumeroDeVertices(G); i++) {
      for(u32 j = 0; j < G->vs[i]->grado ; j++) {
        a = NombreJotaesimoVecino(G, i, j);
        printf("Nombre del %u vecino del vértice %u: %u\n",j, i, a);
      }
    }
    */
    DestruccionDelGrafo(G);
}

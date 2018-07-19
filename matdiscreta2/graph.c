#include "TheOutsider.h"

u32 randum (u32 min, u32 max, u32 seed) {
  /* Función pseudoaleatoria que utilizamos para el NotSoGreedy, y las
  funciones de ordenación aleatorias */
  u32 result = (seed * 65521 + 104729) % ((max - min) + min);
  return result;
}

void InsertarVertice(Grafo G, u32 vertice_input, u32 m, unsigned long i) {
  /*Esta función se encarga de crear un vértice e insertarlo en el grafo */
  Vertice v;
  v = calloc(1, sizeof(struct _Vertice_) + sizeof(Vertice[m])); // alloco un struct size _Vertice_
  v->nombre = vertice_input;
  v->color = 0;
  v->grado = 0;
  v->pos_i = i;
  G->vs[v->pos_i] = v;
}
u32 ReturnPosition(Grafo G, u32 nombre, u32 left, u32 right){
  if (right >= left){
      int mid = left + (right - left)/2;
      if (G->vs[mid]->nombre == nombre) {
        return mid;
      } else if (G->vs[mid]->nombre > nombre) {
        return binarySearch(G, nombre, left, mid-1);
      } else {
        return binarySearch(G, nombre, mid+1, right);
      }
    }
    return -1;
}


Grafo ConstruccionDelGrafo() {

    /* Recorro las primeras lineas del archivo, salteando los comentarios
    (lineas que arrancan en 'c') y obteniendo la cantidad de vertices y lados,
    (linea que arranca en 'p edge') */
    Grafo G = NULL;
    char c;
    char edge[4];
    u32 n = 0, m = 0, v1 = 0, v2 = 0;  // Cantidad de vertices (n) y cantidad de lados (m) del grafo
    unsigned long i = 0;
    scanf("%c", &c);
    while (c == 'c') {
      scanf("%*[^\n]\n");
      scanf("%c", &c);
    }
    // skippeo los comentarios (por que no me gustan :@)
    if ((scanf(" %4s", edge) && scanf(" %u",&n) && scanf(" %u",&m) != 0)){;// es una declaración de n° de vertices y n° de lados
      G = calloc(1, sizeof(struct GrafoSt) + sizeof(Vertice[n]));
      G->vn = n;
      G->ln = m;
      G->cn = 0;
      G->vs = calloc(n,sizeof(struct _Vertice_));
    }
    Tupla arr = calloc(1, sizeof(Tupla[2*m]));
    /*Utilizaremos el arreglo de tuplas para almacenar temporalmente los datos
    ingresados en el archivo, luego los ordenamos de menor a mayor con un
    Quick Sort para poder agregarlos al grafo de manera más intuitiva*/
    do {
      if (scanf(" %c", &c) && scanf(" %u", &v1) && scanf(" %u", &v2)){
        arr[i].vert1 = v1;
        arr[i].vert2 = v2;
        arr[i+1].vert1 = v2;
        arr[i+1].vert2 = v1;
        i = i + 2;
        } else {
        break;
        }
    } while (i < 2*m);
    i = 0;
    u32 aux1 = -1;
    u32 j = 0;
    QuickSortTupla(arr, 2*m);
    /*Una vez ya ordenado el arreglo de tuplas, insertamos los vértices dentro
    de la estructura del grafo*/
    while(i < 2*m){
      if (i == 0 || aux1 < arr[i].vert1) {
        aux1 = arr[i].vert1;
        InsertarVertice(G, arr[i].vert1, m, j);
        j++;
      }
      i++;
    }
    i = 0;
    j = 0;
    aux1 = arr[0].vert1;
    /*Una vez hecho esto, establecemos las relaciones de los vecinos*/
    while(i < 2*m) {
      if (aux1 == arr[i].vert1) {
        G->vs[j]->grado++;
        G->vs[j]->vecinos[G->vs[j]->grado - 1] = G->vs[ReturnPosition(G, arr[i].vert2, 0,n)];
      } else {
        aux1 = arr[i].vert1;
        j++;
        G->vs[j]->grado++;
        G->vs[j]->vecinos[G->vs[j]->grado - 1] = G->vs[ReturnPosition(G, arr[i].vert2, 0,n)];
      }
      i++;
    }
    /*Aplicamos un coloreo al grafo, y liberamos el arreglo de tuplas*/
    G->cn = NotSoGreedy(G, 1234);

    free(arr);

    return G;
}

void DestruccionDelGrafo(Grafo G) {
  /*Libera la memoria al terminar el programa*/
  for(unsigned long i = 0; i < G->vn; i++) {
    free(G->vs[i]);
  }
  free(G->vs);
  free(G);
}

u32 NumeroDeVertices(Grafo G){
	return G->vn;
}

u32 NumeroDeLados(Grafo G){
	return G->ln;
}

u32 NumeroDeColores(Grafo G){
	return G->cn;
}

u32 NombreDelVertice(Grafo G, u32 i){
	return G->vs[i]->nombre;
}

u32 ColorDelVertice(Grafo G, u32 i){
	return G->vs[i]->color;
}

u32 GradoDelVertice(Grafo G, u32 i){
	return G->vs[i]->grado;
}
u32 ColorJotaesimoVecino(Grafo G, u32 i,u32 j){
	u32 jotacolor;
	Vertice aux = G->vs[i];
	jotacolor = aux->vecinos[j]->color;
	return jotacolor;
}

u32 NombreJotaesimoVecino(Grafo G, u32 i,u32 j){
	u32 jotanombre;
	Vertice aux = G->vs[i];
	jotanombre = aux->vecinos[j]->nombre;
	return jotanombre;
}

u32 GradoJotaesimoVecino(Grafo G, u32 i,u32 j){
  u32 jotagrado;
  Vertice aux = G->vs[i];
  jotagrado = aux->vecinos[j]->grado;
  return jotagrado;
}

u32 NotSoGreedy(Grafo G,u32 semilla){
  pila a;
  a = CrearPila();
  G->vs[0]->color = 1;
  Apilar(1,a);
  u32 maxColor = 1;
  for (u32 i = 1; i < G->vn ;i++) {
    G->vs[i]->color = 0; //vaciamos de color el resto del grafo
  }
  u32 ColorAux = maxColor;
  Vertice aux1;
  for (u32 i = 1; i < G->vn; i++) {
    aux1 = G->vs[i];
    for (u32 j = 0; j < aux1->grado; j++){
      if(aux1->vecinos[j]->color >= 1 && ColorAux != 0) {
        /*Aquí, si el vértice está coloreado, lo elimina de la pila que nos
        indica los colores usados anteriormente pero que están libres para
        colorear el vértice donde estamos parados */
        Eliminar(aux1->vecinos[j]->color, a, ColorAux);
        ColorAux--;
      }
    }
    if(ColorAux == 0){
      /*En este caso, si la pila resulta estar vacía, le asigna maxColor+1 y
      actualiza el valor de la misma variable*/
      G->vs[i]->color = maxColor + 1;
      maxColor++;
      ColorAux = maxColor;

    }else if (ColorAux == 1) {
      /*En este caso, si la pila tiene un solo color, le asigna el único color
      que hay dentro de la misma*/
      G->vs[i]->color = a->la_pila->elem;
      ExterminatePila(a);
      ColorAux = maxColor;
    }else{
      /*Por último, si no ocurre ninguno de estos casos, elige un color al
      azar de los disponibles entre la pila */
      G->vs[i]->color = TakeRandom(a,0,ColorAux-1, semilla);
      ExterminatePila(a);
      ColorAux = maxColor;
    }
    /* Aquí reiniciamos la pila, para así poder colorear el próximo vértice */
    for(u32 i = 1; i<=maxColor; i++) {
      Apilar(i,a);
    }
  }
    ExterminatePila(a); //Vaciamos la pila
    free(a);
    return(maxColor);
}


int Bipartito(Grafo G){
    for(u32 i = 0; i < G->vn ;i++) {
        G->vs[i]->color = 0; //Despintamos el grafo
    }
    /* Utilizaremos una cola para recorrer en BFS el grafo */
    cola c;
    c = CrearCola();
    u32 largo_c = 0;
    bool ExisteError = false;
    bool DobleError = false;
    G->vs[0]->color = 1;
    largo_c = 1;
    Encolar(c, G->vs[0]->pos_i);
    u32 i = 0;
    u32 j = 0;
    u32 k = 0;
    /*Pinto de un color un vértice y luego pinto a todos sus vecinos con
    otro color, utilizamos dos bools para ahorrarnos pasos, si encuentra
    que no es bipartito en medio del coloreo, frena el programa y lo
    repinta con NotSoGreedy, como no es infalible, se hace un segundo chequeo
    más adelante.*/
    while(largo_c > 0) {
      k++;
      while(j < G->vs[i]->grado){
        if(G->vs[i]->vecinos[j]->color == 0) {
          Encolar(c, G->vs[i]->vecinos[j]->pos_i);
          largo_c++;
          G->vs[i]->vecinos[j]->color = 3 - G->vs[i]->color;
        } else if(G->vs[i]->vecinos[j]->color == G->vs[i]->color){
          ExisteError = true;
          break;
        }
        j++;
      }
      j = 0;
      if(ExisteError) {
        break;
      }
      Decolar(c);
      largo_c--;
      if(!Cola_vacia){
        i = Cabeza(c);
      } else {
        /* k nos indica si hemos recorrido todos los vértices independientemente
        de la relación de los vecinos, entonces busca el próximo vertice sin
        colorear */
        if(k < G->vn) {
          while(j < G->vn) {
            if(G->vs[j]->color == 0){
              G->vs[j]->color = 1;
              i = G->vs[j]->pos_i;
              Encolar(c,i);
              largo_c++;
              j = 0;
              break;
            }
            j++;
          }
        }
      }
    }
    /* Si falla en el primer chequeo, retorna -2 y no hace el segundo*/
    if(ExisteError){
      NotSoGreedy(G, 1234);
      return -2;
    }
    i = 0;
    j = 0;
    ExterminateCola(c);
    /* Aquí ocurre el segundo chequeo */
    while(i < G->vn){
      while(j < G->vs[i]->grado){
        if(G->vs[i]->vecinos[j]->color == G->vs[i]->color){
          DobleError = true;
          break;
        }
        j++;
      }
      if(DobleError){
        break;
      }
      j = 0;
      i++;
    }
    if(DobleError){
      NotSoGreedy(G, 1234);
      return -2;
    }
    G->cn = 2;
    return 2;
}

void OrdenNatural(Grafo G) {
  OrdenNatural_rec(G, 0, (G->vn == 0) ? 0 : G->vn - 1);
}

void OrdenWelshPowell(Grafo G){
  OrdenWelshPowell_rec(G, 0, (G->vn == 0) ? 0 : G->vn - 1);
}

void AleatorizarVertices (Grafo G, u32 semilla) {
  for (unsigned int i = 0; i < (G->vn +1)/ 2; i++) {
    Vertice temp = G->vs[i];
    G->vs[i] = G->vs[randum(0, G->vn-1, semilla + i)];
    G->vs[randum(0, G->vn-1, semilla+i)] = temp;
    Vertice* temp2 = G->vs[G->vn-1-i];
    G->vs[G->vn-1-i] = G->vs[randum(0, G->vn-1, semilla + G->vn-1-i)];
    G->vs[randum(0, G->vn-1, semilla + G->vn-1-i)] = temp2;
  }
}

void ReordenManteniendoBloqueColores(Grafo G,u32 x) {
  // Este funcion ordena por bloques de colores
  // En caso de que el input recibido(x) sea igual a 0, se ordenaran los bloques de colores segun su color de mayor a menor
  // En caso de que el input recibido(x) sea igual a 1, se ordenaran los vertices de forma ascendente segun el tamaño de los bloques
  // En caso de que el input recibido(x) sea mayor a 1, se ordenaran los bloques aleatoriamente tomando el input como semilla(en este caso, x es
  // modificado para poder ser utilizado como tal)
  if (G->cn > 1 && G != NULL) {
    Vertice **TodosLosBloques = calloc(G->cn, sizeof (Vertice)); // creo un arreglo de punteros a estructas vertice [0, cn]
    Tupla BloquesYSusTam = calloc(G->cn, sizeof (struct TuplaSt)); //

    for (unsigned int i = 0; i < G->cn; i++) {
      TodosLosBloques[i] = calloc(G->vn, sizeof (Vertice));
      BloquesYSusTam[i].vert1 = 0;
      BloquesYSusTam[i].vert2 = 0;
    }
    // TodosLosBloques[i] es el bloque de color i
    // TodosLosBloques[i][j] el vertice j del bloque de color i
    for(unsigned int i = 0; i < G->vn; i++) {
      // fuerzo el concepto de tuplas de vertices para usarlos segun v1 = tam del bloque, v2 = numero de bloque
      // chequear
      TodosLosBloques[G->vs[i]->color-1][BloquesYSusTam[G->vs[i]->color-1].vert1] = G->vs[i];
      BloquesYSusTam[G->vs[i]->color-1].vert1 = BloquesYSusTam[G->vs[i]->color-1].vert1 + 1; // aumento el tamaño del bloque
      BloquesYSusTam[G->vs[i]->color-1].vert2 = G->vs[i]->color-1; // le asigno el color que le corresponde al bloque
    }

    if ( x == 0 ) {
      unsigned int i = G->cn-1;
      unsigned int l = 0;
      while (i >= 0 && l < G->vn) { // llevo la cuenta de la posicion vs
        for (unsigned int j = 0; j < BloquesYSusTam[i].vert1; j++) { // llevo la cuenta de la posicion en el bloque del color
          if ( l >= G->vn ) {
            break;
          }
          G->vs[l] = TodosLosBloques[i][j];
          l++;
        }
        i--;
      }
    } else if ( x == 1 ) {
      QuickSortTupla(BloquesYSusTam, G->cn);
      // BloquesYSusTam va a quedar ordenado por tamaño (de menor a mayor)
      unsigned int i = 0;
      unsigned int l = 0;
      while (i < G->cn && l < G->vn) { // llevo la cuenta de la posicion vs
        for (unsigned int j = 0; j < BloquesYSusTam[i].vert1; j++) { // llevo la cuenta de la posicion en el bloque del color
          if (l >= G->vn) {
            break;
          }
          G->vs[l] = TodosLosBloques[BloquesYSusTam[i].vert2][j];
          l++;
        }
        i++;
      }
    } else {
      int temp = 0;
      int temp2 = 0;
      // Aleatorizo los bloques para obtener de ahi las direcciones aleatorizadas
      for (unsigned int i = 0; i < G->cn; i++) {
        temp = BloquesYSusTam[i].vert2;
        temp2 = BloquesYSusTam[i].vert1;
        BloquesYSusTam[i].vert2 = BloquesYSusTam[randum(0, G->cn-1, x*i*i*i)].vert2;
        BloquesYSusTam[i].vert1 = BloquesYSusTam[randum(0, G->cn-1, x*i*i*i)].vert1;
        BloquesYSusTam[randum(0, G->cn-1, x*i*i*i)].vert2 = temp;
        BloquesYSusTam[randum(0, G->cn-1, x*i*i*i)].vert1 = temp2;
      }

      unsigned int i = 0;
      unsigned int l = 0;
      while (i < G->cn && l < G->vn) { // llevo la cuenta de la posicion vs
        for (unsigned int j = 0; j < BloquesYSusTam[i].vert1; j++) { // llevo la cuenta de la posicion en el bloque del color
          if ( l >= G->vn ) {
            break;
          }
          G->vs[l] = TodosLosBloques[BloquesYSusTam[i].vert2][j];
          l++;
        }
        i++;
      }
    }
    // Libero la memoria
    for (int j = 0; j < G->cn; j++) {
      free(TodosLosBloques[j]);
    }
    free(TodosLosBloques);
    free(BloquesYSusTam);
  }
}

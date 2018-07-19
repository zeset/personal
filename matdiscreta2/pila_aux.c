#include "TheOutsider.h"

extern pila CrearPila() {
    pila s = (pila)malloc(sizeof(_pila));
    s->la_pila = NULL;
    return (s);
}

extern void Apilar(u32 color, pila s) {
    cnodo p = (cnodo)malloc(sizeof(struct _cnodo));
    p->elem = color;
    p->siguiente = s->la_pila;
    s->la_pila = p;
}

extern void Eliminar(u32 color, pila s, u32 largo) {
  if(color != 0){ //Si el color del vértice en el que estamos parados es 0, significa que no está coloriau
    u32 i = 0;
    cnodo q;
    q = s->la_pila;
    cnodo aux = q->siguiente;
    while(i < largo) {
      if(q->elem == color && i == 0){
        s->la_pila = (s->la_pila)->siguiente;
        free(q);
        break;
      } else if(aux->elem == color){
        q->siguiente = aux->siguiente;
        free(aux);
        break;
      } else {
        q = q->siguiente;
        aux = q->siguiente;
        i++;
      }
    }
  }
}

extern void ExterminatePila(pila a){
  cnodo q;
  while(a->la_pila != NULL){
    q = a->la_pila;
    a->la_pila = (a->la_pila)->siguiente;
    free(q);
  }
}

extern u32 TakeRandom(pila a, u32 min, u32 max, u32 semilla){
  //semilla = semilla; //Semilla sería usada por rand, pero en esta versión de prueba no sé como hacerlo
  //u32 position = rand() % (max + 1 - min) + min;
  u32 position = 0;
  if(min != max){
    position = randum(min, max, semilla);
  }
  u32 i = 0;
  u32 result = 0;
  cnodo q = a->la_pila;
  while(i < max+1){
    if(i == position) {
      result = q->elem;
      break;
    } else {
      q = q->siguiente;
      i++;
    }
  }
  return result;
}

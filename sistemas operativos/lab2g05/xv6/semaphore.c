#include "types.h"
#include "stat.h"
#include "defs.h"
#include "semaphore.h"
#include "spinlock.h"

struct spinlock semlock;


void 
semlock_init()
{
  initlock(&semlock,"sem");
}

void
sem_init(int semaphore, int value)
{
  total_sem[semaphore] = value;
}

void
sem_release(int semaphore)
{
  total_sem[semaphore] = 0;
}

void
sem_down(int semaphore)
{
  while(total_sem[semaphore] == 0){
    sleep(&total_sem[semaphore],&semlock);
  }
  total_sem[semaphore]--;
}

void
sem_up(int semaphore)
{
  if(total_sem[semaphore] == 0){
    wakeup(&total_sem[semaphore]);
  }
  total_sem[semaphore]++;
}

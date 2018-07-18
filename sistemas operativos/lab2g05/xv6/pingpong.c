#include "types.h"
#include "user.h"
#define SEM1  0
#define SEM2  1

int main(int argc, char *argv[]){
  if(argc != 2 || atoi(argv[1]) <= 0){
    exit();
  }
  int pid,reps;
  sem_init(SEM1,1);
  sem_init(SEM2,0);
  reps = atoi(argv[1]);
  pid = fork();
  if(pid > 0){
    int j;
    for(j=0;j<reps;++j){
      sem_down(SEM1);
      printf(1,"ping\n");
      sem_up(SEM2);
    }
    pid = wait();
  }
  else if(pid == 0){
    int j;
    for(j=0;j<reps;++j){
      sem_down(SEM2);
      printf(1,"pong\n");
      sem_up(SEM1);
    }
  }
  else{
    printf(1,"Couldn't fork\n");
  }
  exit();
}

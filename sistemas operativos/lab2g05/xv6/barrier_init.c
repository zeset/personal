#include "types.h"
#include "user.h"
#define SEM_BARRIER 0

int
main(int argc, char *argv[])
{
  sem_init(SEM_BARRIER, 0);
  exit();
}

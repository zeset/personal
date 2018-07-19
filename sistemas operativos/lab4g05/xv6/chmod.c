#include "types.h"
#include "stat.h"
#include "user.h"


int
main(int argc, char* argv[])
{
  int perms;
  char * filename;
 
  if(argc != 3){
    exit();
  }
  perms = atoi(argv[1]);
  filename = argv[2]; 
  chmod(filename,perms);

  exit();
}










#define MAX_SEM   20

struct spinlock;

extern struct spinlock semlock;
int total_sem[MAX_SEM];
void		semlock_init(void);
void            sem_init(int, int);
void            sem_release(int);
void            sem_up(int);
void            sem_down(int);

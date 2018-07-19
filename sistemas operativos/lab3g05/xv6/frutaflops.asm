
_frutaflops:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 18             	sub    $0x18,%esp
  int pid = getpid();
  14:	e8 b9 03 00 00       	call   3d2 <getpid>
  19:	31 c9                	xor    %ecx,%ecx
  1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
static float b[N][N];
static float c[N][N];

static void init(void) {
  int x, y;
  for (y = 0; y < N; ++y) {
  1e:	31 c0                	xor    %eax,%eax
  20:	89 c2                	mov    %eax,%edx
  22:	8d 70 80             	lea    -0x80(%eax),%esi
  25:	89 c3                	mov    %eax,%ebx
  27:	f7 da                	neg    %edx
    for (x = 0; x < N; ++x) {
      a[y][x] = y - x;
  29:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  2c:	83 eb 01             	sub    $0x1,%ebx
      b[y][x] = x - y;
      c[y][x] = 0.0f;
  2f:	c7 84 91 80 0a 00 00 	movl   $0x0,0xa80(%ecx,%edx,4)
  36:	00 00 00 00 

static void init(void) {
  int x, y;
  for (y = 0; y < N; ++y) {
    for (x = 0; x < N; ++x) {
      a[y][x] = y - x;
  3a:	db 45 e4             	fildl  -0x1c(%ebp)
      b[y][x] = x - y;
  3d:	89 55 e4             	mov    %edx,-0x1c(%ebp)

static void init(void) {
  int x, y;
  for (y = 0; y < N; ++y) {
    for (x = 0; x < N; ++x) {
      a[y][x] = y - x;
  40:	d9 9c 91 80 0a 02 00 	fstps  0x20a80(%ecx,%edx,4)
      b[y][x] = x - y;
  47:	db 45 e4             	fildl  -0x1c(%ebp)
  4a:	d9 9c 91 80 0a 01 00 	fstps  0x10a80(%ecx,%edx,4)
  51:	83 c2 01             	add    $0x1,%edx
static float c[N][N];

static void init(void) {
  int x, y;
  for (y = 0; y < N; ++y) {
    for (x = 0; x < N; ++x) {
  54:	39 f3                	cmp    %esi,%ebx
  56:	75 d1                	jne    29 <main+0x29>
static float b[N][N];
static float c[N][N];

static void init(void) {
  int x, y;
  for (y = 0; y < N; ++y) {
  58:	83 c0 01             	add    $0x1,%eax
  5b:	81 c1 04 02 00 00    	add    $0x204,%ecx
  61:	3d 80 00 00 00       	cmp    $0x80,%eax
  66:	75 b8                	jne    20 <main+0x20>
  68:	d9 e8                	fld1   
  6a:	d9 5d d8             	fstps  -0x28(%ebp)
  6d:	bf 80 0a 02 00       	mov    $0x20a80,%edi
  int pid = getpid();
  float beta = 1.0f;

  init();
  for (;;) {
    int start = uptime();
  72:	e8 73 03 00 00       	call   3ea <uptime>
  77:	d9 45 d8             	flds   -0x28(%ebp)
  7a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  7d:	c7 45 e4 80 0a 00 00 	movl   $0xa80,-0x1c(%ebp)
static float b[N][N];
static float c[N][N];

static void init(void) {
  int x, y;
  for (y = 0; y < N; ++y) {
  84:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  87:	bb 80 0a 01 00       	mov    $0x10a80,%ebx
  8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  90:	d9 06                	flds   (%esi)
  92:	8d 8b 00 00 01 00    	lea    0x10000(%ebx),%ecx
  98:	89 d8                	mov    %ebx,%eax
  9a:	89 fa                	mov    %edi,%edx
  9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void smm(float beta) {
  int x, y, k;
  for (y = 0; y < N; ++y) {
    for (x = 0; x < N; ++x) {
      for (k = 0; k < N; ++k) {
        c[y][x] += beta * a[y][k] * b[k][x];
  a0:	d9 02                	flds   (%edx)
  a2:	05 00 02 00 00       	add    $0x200,%eax
  a7:	83 c2 04             	add    $0x4,%edx
  aa:	d8 ca                	fmul   %st(2),%st
  ac:	d8 88 00 fe ff ff    	fmuls  -0x200(%eax)

static void smm(float beta) {
  int x, y, k;
  for (y = 0; y < N; ++y) {
    for (x = 0; x < N; ++x) {
      for (k = 0; k < N; ++k) {
  b2:	39 c8                	cmp    %ecx,%eax
        c[y][x] += beta * a[y][k] * b[k][x];
  b4:	de c1                	faddp  %st,%st(1)

static void smm(float beta) {
  int x, y, k;
  for (y = 0; y < N; ++y) {
    for (x = 0; x < N; ++x) {
      for (k = 0; k < N; ++k) {
  b6:	75 e8                	jne    a0 <main+0xa0>
  b8:	83 c3 04             	add    $0x4,%ebx
  bb:	d9 1e                	fstps  (%esi)
  bd:	83 c6 04             	add    $0x4,%esi
}

static void smm(float beta) {
  int x, y, k;
  for (y = 0; y < N; ++y) {
    for (x = 0; x < N; ++x) {
  c0:	81 fb 80 0c 01 00    	cmp    $0x10c80,%ebx
  c6:	75 c8                	jne    90 <main+0x90>
  c8:	81 c7 00 02 00 00    	add    $0x200,%edi
  }
}

static void smm(float beta) {
  int x, y, k;
  for (y = 0; y < N; ++y) {
  ce:	b8 80 0a 03 00       	mov    $0x30a80,%eax
  d3:	81 45 e4 00 02 00 00 	addl   $0x200,-0x1c(%ebp)
  da:	39 f8                	cmp    %edi,%eax
  dc:	75 a6                	jne    84 <main+0x84>

  init();
  for (;;) {
    int start = uptime();
    smm(beta);
    beta = -beta;
  de:	d9 e0                	fchs   
  e0:	d9 5d e4             	fstps  -0x1c(%ebp)
    int end = uptime();
  e3:	e8 02 03 00 00       	call   3ea <uptime>
    long elapsed = (long) end - (long) start;
    long ops = 3 * N * N * N;

    printf(1, "%d %d FrutaFLOPS\n", pid, (int) (ops / elapsed));
  e8:	2b 45 dc             	sub    -0x24(%ebp),%eax
  eb:	89 c1                	mov    %eax,%ecx
  ed:	b8 00 00 60 00       	mov    $0x600000,%eax
  f2:	99                   	cltd   
  f3:	f7 f9                	idiv   %ecx
  f5:	50                   	push   %eax
  f6:	ff 75 e0             	pushl  -0x20(%ebp)
  f9:	68 c0 07 00 00       	push   $0x7c0
  fe:	6a 01                	push   $0x1
 100:	e8 9b 03 00 00       	call   4a0 <printf>
  }
 105:	83 c4 10             	add    $0x10,%esp
 108:	d9 45 e4             	flds   -0x1c(%ebp)
 10b:	e9 5a ff ff ff       	jmp    6a <main+0x6a>

00000110 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	53                   	push   %ebx
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11a:	89 c2                	mov    %eax,%edx
 11c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 120:	83 c1 01             	add    $0x1,%ecx
 123:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 127:	83 c2 01             	add    $0x1,%edx
 12a:	84 db                	test   %bl,%bl
 12c:	88 5a ff             	mov    %bl,-0x1(%edx)
 12f:	75 ef                	jne    120 <strcpy+0x10>
    ;
  return os;
}
 131:	5b                   	pop    %ebx
 132:	5d                   	pop    %ebp
 133:	c3                   	ret    
 134:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 13a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000140 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	56                   	push   %esi
 144:	53                   	push   %ebx
 145:	8b 55 08             	mov    0x8(%ebp),%edx
 148:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 14b:	0f b6 02             	movzbl (%edx),%eax
 14e:	0f b6 19             	movzbl (%ecx),%ebx
 151:	84 c0                	test   %al,%al
 153:	75 1e                	jne    173 <strcmp+0x33>
 155:	eb 29                	jmp    180 <strcmp+0x40>
 157:	89 f6                	mov    %esi,%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 160:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 163:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 166:	8d 71 01             	lea    0x1(%ecx),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 169:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 16d:	84 c0                	test   %al,%al
 16f:	74 0f                	je     180 <strcmp+0x40>
 171:	89 f1                	mov    %esi,%ecx
 173:	38 d8                	cmp    %bl,%al
 175:	74 e9                	je     160 <strcmp+0x20>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 177:	29 d8                	sub    %ebx,%eax
}
 179:	5b                   	pop    %ebx
 17a:	5e                   	pop    %esi
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    
 17d:	8d 76 00             	lea    0x0(%esi),%esi
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 180:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 182:	29 d8                	sub    %ebx,%eax
}
 184:	5b                   	pop    %ebx
 185:	5e                   	pop    %esi
 186:	5d                   	pop    %ebp
 187:	c3                   	ret    
 188:	90                   	nop
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000190 <strlen>:

uint
strlen(char *s)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 196:	80 39 00             	cmpb   $0x0,(%ecx)
 199:	74 12                	je     1ad <strlen+0x1d>
 19b:	31 d2                	xor    %edx,%edx
 19d:	8d 76 00             	lea    0x0(%esi),%esi
 1a0:	83 c2 01             	add    $0x1,%edx
 1a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1a7:	89 d0                	mov    %edx,%eax
 1a9:	75 f5                	jne    1a0 <strlen+0x10>
    ;
  return n;
}
 1ab:	5d                   	pop    %ebp
 1ac:	c3                   	ret    
uint
strlen(char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 1ad:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    
 1b1:	eb 0d                	jmp    1c0 <memset>
 1b3:	90                   	nop
 1b4:	90                   	nop
 1b5:	90                   	nop
 1b6:	90                   	nop
 1b7:	90                   	nop
 1b8:	90                   	nop
 1b9:	90                   	nop
 1ba:	90                   	nop
 1bb:	90                   	nop
 1bc:	90                   	nop
 1bd:	90                   	nop
 1be:	90                   	nop
 1bf:	90                   	nop

000001c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cd:	89 d7                	mov    %edx,%edi
 1cf:	fc                   	cld    
 1d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1d2:	89 d0                	mov    %edx,%eax
 1d4:	5f                   	pop    %edi
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    
 1d7:	89 f6                	mov    %esi,%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001e0 <strchr>:

char*
strchr(const char *s, char c)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	53                   	push   %ebx
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1ea:	0f b6 10             	movzbl (%eax),%edx
 1ed:	84 d2                	test   %dl,%dl
 1ef:	74 1d                	je     20e <strchr+0x2e>
    if(*s == c)
 1f1:	38 d3                	cmp    %dl,%bl
 1f3:	89 d9                	mov    %ebx,%ecx
 1f5:	75 0d                	jne    204 <strchr+0x24>
 1f7:	eb 17                	jmp    210 <strchr+0x30>
 1f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 200:	38 ca                	cmp    %cl,%dl
 202:	74 0c                	je     210 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 204:	83 c0 01             	add    $0x1,%eax
 207:	0f b6 10             	movzbl (%eax),%edx
 20a:	84 d2                	test   %dl,%dl
 20c:	75 f2                	jne    200 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 20e:	31 c0                	xor    %eax,%eax
}
 210:	5b                   	pop    %ebx
 211:	5d                   	pop    %ebp
 212:	c3                   	ret    
 213:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000220 <gets>:

char*
gets(char *buf, int max)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	57                   	push   %edi
 224:	56                   	push   %esi
 225:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 226:	31 f6                	xor    %esi,%esi
    cc = read(0, &c, 1);
 228:	8d 7d e7             	lea    -0x19(%ebp),%edi
  return 0;
}

char*
gets(char *buf, int max)
{
 22b:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22e:	eb 29                	jmp    259 <gets+0x39>
    cc = read(0, &c, 1);
 230:	83 ec 04             	sub    $0x4,%esp
 233:	6a 01                	push   $0x1
 235:	57                   	push   %edi
 236:	6a 00                	push   $0x0
 238:	e8 2d 01 00 00       	call   36a <read>
    if(cc < 1)
 23d:	83 c4 10             	add    $0x10,%esp
 240:	85 c0                	test   %eax,%eax
 242:	7e 1d                	jle    261 <gets+0x41>
      break;
    buf[i++] = c;
 244:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 248:	8b 55 08             	mov    0x8(%ebp),%edx
 24b:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 24d:	3c 0a                	cmp    $0xa,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 24f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 253:	74 1b                	je     270 <gets+0x50>
 255:	3c 0d                	cmp    $0xd,%al
 257:	74 17                	je     270 <gets+0x50>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 259:	8d 5e 01             	lea    0x1(%esi),%ebx
 25c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 25f:	7c cf                	jl     230 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 268:	8d 65 f4             	lea    -0xc(%ebp),%esp
 26b:	5b                   	pop    %ebx
 26c:	5e                   	pop    %esi
 26d:	5f                   	pop    %edi
 26e:	5d                   	pop    %ebp
 26f:	c3                   	ret    
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 270:	8b 45 08             	mov    0x8(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 273:	89 de                	mov    %ebx,%esi
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 275:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 279:	8d 65 f4             	lea    -0xc(%ebp),%esp
 27c:	5b                   	pop    %ebx
 27d:	5e                   	pop    %esi
 27e:	5f                   	pop    %edi
 27f:	5d                   	pop    %ebp
 280:	c3                   	ret    
 281:	eb 0d                	jmp    290 <stat>
 283:	90                   	nop
 284:	90                   	nop
 285:	90                   	nop
 286:	90                   	nop
 287:	90                   	nop
 288:	90                   	nop
 289:	90                   	nop
 28a:	90                   	nop
 28b:	90                   	nop
 28c:	90                   	nop
 28d:	90                   	nop
 28e:	90                   	nop
 28f:	90                   	nop

00000290 <stat>:

int
stat(char *n, struct stat *st)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	56                   	push   %esi
 294:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 295:	83 ec 08             	sub    $0x8,%esp
 298:	6a 00                	push   $0x0
 29a:	ff 75 08             	pushl  0x8(%ebp)
 29d:	e8 f0 00 00 00       	call   392 <open>
  if(fd < 0)
 2a2:	83 c4 10             	add    $0x10,%esp
 2a5:	85 c0                	test   %eax,%eax
 2a7:	78 27                	js     2d0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 2a9:	83 ec 08             	sub    $0x8,%esp
 2ac:	ff 75 0c             	pushl  0xc(%ebp)
 2af:	89 c3                	mov    %eax,%ebx
 2b1:	50                   	push   %eax
 2b2:	e8 f3 00 00 00       	call   3aa <fstat>
 2b7:	89 c6                	mov    %eax,%esi
  close(fd);
 2b9:	89 1c 24             	mov    %ebx,(%esp)
 2bc:	e8 b9 00 00 00       	call   37a <close>
  return r;
 2c1:	83 c4 10             	add    $0x10,%esp
 2c4:	89 f0                	mov    %esi,%eax
}
 2c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2c9:	5b                   	pop    %ebx
 2ca:	5e                   	pop    %esi
 2cb:	5d                   	pop    %ebp
 2cc:	c3                   	ret    
 2cd:	8d 76 00             	lea    0x0(%esi),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 2d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2d5:	eb ef                	jmp    2c6 <stat+0x36>
 2d7:	89 f6                	mov    %esi,%esi
 2d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002e0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	53                   	push   %ebx
 2e4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2e7:	0f be 11             	movsbl (%ecx),%edx
 2ea:	8d 42 d0             	lea    -0x30(%edx),%eax
 2ed:	3c 09                	cmp    $0x9,%al
 2ef:	b8 00 00 00 00       	mov    $0x0,%eax
 2f4:	77 1f                	ja     315 <atoi+0x35>
 2f6:	8d 76 00             	lea    0x0(%esi),%esi
 2f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 300:	8d 04 80             	lea    (%eax,%eax,4),%eax
 303:	83 c1 01             	add    $0x1,%ecx
 306:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 30a:	0f be 11             	movsbl (%ecx),%edx
 30d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 310:	80 fb 09             	cmp    $0x9,%bl
 313:	76 eb                	jbe    300 <atoi+0x20>
    n = n*10 + *s++ - '0';
  return n;
}
 315:	5b                   	pop    %ebx
 316:	5d                   	pop    %ebp
 317:	c3                   	ret    
 318:	90                   	nop
 319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000320 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	56                   	push   %esi
 324:	53                   	push   %ebx
 325:	8b 5d 10             	mov    0x10(%ebp),%ebx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 32e:	85 db                	test   %ebx,%ebx
 330:	7e 14                	jle    346 <memmove+0x26>
 332:	31 d2                	xor    %edx,%edx
 334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 338:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 33c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 33f:	83 c2 01             	add    $0x1,%edx
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 342:	39 da                	cmp    %ebx,%edx
 344:	75 f2                	jne    338 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 346:	5b                   	pop    %ebx
 347:	5e                   	pop    %esi
 348:	5d                   	pop    %ebp
 349:	c3                   	ret    

0000034a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 34a:	b8 01 00 00 00       	mov    $0x1,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <exit>:
SYSCALL(exit)
 352:	b8 02 00 00 00       	mov    $0x2,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <wait>:
SYSCALL(wait)
 35a:	b8 03 00 00 00       	mov    $0x3,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <pipe>:
SYSCALL(pipe)
 362:	b8 04 00 00 00       	mov    $0x4,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <read>:
SYSCALL(read)
 36a:	b8 05 00 00 00       	mov    $0x5,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <write>:
SYSCALL(write)
 372:	b8 10 00 00 00       	mov    $0x10,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <close>:
SYSCALL(close)
 37a:	b8 15 00 00 00       	mov    $0x15,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <kill>:
SYSCALL(kill)
 382:	b8 06 00 00 00       	mov    $0x6,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <exec>:
SYSCALL(exec)
 38a:	b8 07 00 00 00       	mov    $0x7,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <open>:
SYSCALL(open)
 392:	b8 0f 00 00 00       	mov    $0xf,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <mknod>:
SYSCALL(mknod)
 39a:	b8 11 00 00 00       	mov    $0x11,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <unlink>:
SYSCALL(unlink)
 3a2:	b8 12 00 00 00       	mov    $0x12,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <fstat>:
SYSCALL(fstat)
 3aa:	b8 08 00 00 00       	mov    $0x8,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <link>:
SYSCALL(link)
 3b2:	b8 13 00 00 00       	mov    $0x13,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <mkdir>:
SYSCALL(mkdir)
 3ba:	b8 14 00 00 00       	mov    $0x14,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <chdir>:
SYSCALL(chdir)
 3c2:	b8 09 00 00 00       	mov    $0x9,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <dup>:
SYSCALL(dup)
 3ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <getpid>:
SYSCALL(getpid)
 3d2:	b8 0b 00 00 00       	mov    $0xb,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <sbrk>:
SYSCALL(sbrk)
 3da:	b8 0c 00 00 00       	mov    $0xc,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <sleep>:
SYSCALL(sleep)
 3e2:	b8 0d 00 00 00       	mov    $0xd,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <uptime>:
SYSCALL(uptime)
 3ea:	b8 0e 00 00 00       	mov    $0xe,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    
 3f2:	66 90                	xchg   %ax,%ax
 3f4:	66 90                	xchg   %ax,%ax
 3f6:	66 90                	xchg   %ax,%ax
 3f8:	66 90                	xchg   %ax,%ax
 3fa:	66 90                	xchg   %ax,%ax
 3fc:	66 90                	xchg   %ax,%ax
 3fe:	66 90                	xchg   %ax,%ax

00000400 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 400:	55                   	push   %ebp
 401:	89 e5                	mov    %esp,%ebp
 403:	57                   	push   %edi
 404:	56                   	push   %esi
 405:	53                   	push   %ebx
 406:	89 c6                	mov    %eax,%esi
 408:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 40b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 40e:	85 db                	test   %ebx,%ebx
 410:	74 7e                	je     490 <printint+0x90>
 412:	89 d0                	mov    %edx,%eax
 414:	c1 e8 1f             	shr    $0x1f,%eax
 417:	84 c0                	test   %al,%al
 419:	74 75                	je     490 <printint+0x90>
    neg = 1;
    x = -xx;
 41b:	89 d0                	mov    %edx,%eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 41d:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
    x = -xx;
 424:	f7 d8                	neg    %eax
 426:	89 75 c0             	mov    %esi,-0x40(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 429:	31 ff                	xor    %edi,%edi
 42b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 42e:	89 ce                	mov    %ecx,%esi
 430:	eb 08                	jmp    43a <printint+0x3a>
 432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 438:	89 cf                	mov    %ecx,%edi
 43a:	31 d2                	xor    %edx,%edx
 43c:	8d 4f 01             	lea    0x1(%edi),%ecx
 43f:	f7 f6                	div    %esi
 441:	0f b6 92 dc 07 00 00 	movzbl 0x7dc(%edx),%edx
  }while((x /= base) != 0);
 448:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 44a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 44d:	75 e9                	jne    438 <printint+0x38>
  if(neg)
 44f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 452:	8b 75 c0             	mov    -0x40(%ebp),%esi
 455:	85 c0                	test   %eax,%eax
 457:	74 08                	je     461 <printint+0x61>
    buf[i++] = '-';
 459:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
 45e:	8d 4f 02             	lea    0x2(%edi),%ecx
 461:	8d 7c 0d d7          	lea    -0x29(%ebp,%ecx,1),%edi
 465:	8d 76 00             	lea    0x0(%esi),%esi
 468:	0f b6 07             	movzbl (%edi),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 46b:	83 ec 04             	sub    $0x4,%esp
 46e:	83 ef 01             	sub    $0x1,%edi
 471:	6a 01                	push   $0x1
 473:	53                   	push   %ebx
 474:	56                   	push   %esi
 475:	88 45 d7             	mov    %al,-0x29(%ebp)
 478:	e8 f5 fe ff ff       	call   372 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 47d:	83 c4 10             	add    $0x10,%esp
 480:	39 df                	cmp    %ebx,%edi
 482:	75 e4                	jne    468 <printint+0x68>
    putc(fd, buf[i]);
}
 484:	8d 65 f4             	lea    -0xc(%ebp),%esp
 487:	5b                   	pop    %ebx
 488:	5e                   	pop    %esi
 489:	5f                   	pop    %edi
 48a:	5d                   	pop    %ebp
 48b:	c3                   	ret    
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 490:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 492:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 499:	eb 8b                	jmp    426 <printint+0x26>
 49b:	90                   	nop
 49c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004a0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4a6:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a9:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4ac:	8b 75 0c             	mov    0xc(%ebp),%esi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4af:	8b 7d 08             	mov    0x8(%ebp),%edi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4b5:	0f b6 1e             	movzbl (%esi),%ebx
 4b8:	83 c6 01             	add    $0x1,%esi
 4bb:	84 db                	test   %bl,%bl
 4bd:	0f 84 b0 00 00 00    	je     573 <printf+0xd3>
 4c3:	31 d2                	xor    %edx,%edx
 4c5:	eb 39                	jmp    500 <printf+0x60>
 4c7:	89 f6                	mov    %esi,%esi
 4c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4d0:	83 f8 25             	cmp    $0x25,%eax
 4d3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 4d6:	ba 25 00 00 00       	mov    $0x25,%edx
  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 4db:	74 18                	je     4f5 <printf+0x55>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4dd:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4e0:	83 ec 04             	sub    $0x4,%esp
 4e3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 4e6:	6a 01                	push   $0x1
 4e8:	50                   	push   %eax
 4e9:	57                   	push   %edi
 4ea:	e8 83 fe ff ff       	call   372 <write>
 4ef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 4f2:	83 c4 10             	add    $0x10,%esp
 4f5:	83 c6 01             	add    $0x1,%esi
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4f8:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4fc:	84 db                	test   %bl,%bl
 4fe:	74 73                	je     573 <printf+0xd3>
    c = fmt[i] & 0xff;
    if(state == 0){
 500:	85 d2                	test   %edx,%edx
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 502:	0f be cb             	movsbl %bl,%ecx
 505:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 508:	74 c6                	je     4d0 <printf+0x30>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 50a:	83 fa 25             	cmp    $0x25,%edx
 50d:	75 e6                	jne    4f5 <printf+0x55>
      if(c == 'd'){
 50f:	83 f8 64             	cmp    $0x64,%eax
 512:	0f 84 f8 00 00 00    	je     610 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 518:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 51e:	83 f9 70             	cmp    $0x70,%ecx
 521:	74 5d                	je     580 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 523:	83 f8 73             	cmp    $0x73,%eax
 526:	0f 84 84 00 00 00    	je     5b0 <printf+0x110>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 52c:	83 f8 63             	cmp    $0x63,%eax
 52f:	0f 84 ea 00 00 00    	je     61f <printf+0x17f>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 535:	83 f8 25             	cmp    $0x25,%eax
 538:	0f 84 c2 00 00 00    	je     600 <printf+0x160>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 53e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 541:	83 ec 04             	sub    $0x4,%esp
 544:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 548:	6a 01                	push   $0x1
 54a:	50                   	push   %eax
 54b:	57                   	push   %edi
 54c:	e8 21 fe ff ff       	call   372 <write>
 551:	83 c4 0c             	add    $0xc,%esp
 554:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 557:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 55a:	6a 01                	push   $0x1
 55c:	50                   	push   %eax
 55d:	57                   	push   %edi
 55e:	83 c6 01             	add    $0x1,%esi
 561:	e8 0c fe ff ff       	call   372 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 566:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 56a:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 56d:	31 d2                	xor    %edx,%edx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 56f:	84 db                	test   %bl,%bl
 571:	75 8d                	jne    500 <printf+0x60>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 573:	8d 65 f4             	lea    -0xc(%ebp),%esp
 576:	5b                   	pop    %ebx
 577:	5e                   	pop    %esi
 578:	5f                   	pop    %edi
 579:	5d                   	pop    %ebp
 57a:	c3                   	ret    
 57b:	90                   	nop
 57c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 580:	83 ec 0c             	sub    $0xc,%esp
 583:	b9 10 00 00 00       	mov    $0x10,%ecx
 588:	6a 00                	push   $0x0
 58a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 58d:	89 f8                	mov    %edi,%eax
 58f:	8b 13                	mov    (%ebx),%edx
 591:	e8 6a fe ff ff       	call   400 <printint>
        ap++;
 596:	89 d8                	mov    %ebx,%eax
 598:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 59b:	31 d2                	xor    %edx,%edx
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
 59d:	83 c0 04             	add    $0x4,%eax
 5a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5a3:	e9 4d ff ff ff       	jmp    4f5 <printf+0x55>
 5a8:	90                   	nop
 5a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 5b0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 5b3:	8b 18                	mov    (%eax),%ebx
        ap++;
 5b5:	83 c0 04             	add    $0x4,%eax
 5b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
          s = "(null)";
 5bb:	b8 d2 07 00 00       	mov    $0x7d2,%eax
 5c0:	85 db                	test   %ebx,%ebx
 5c2:	0f 44 d8             	cmove  %eax,%ebx
        while(*s != 0){
 5c5:	0f b6 03             	movzbl (%ebx),%eax
 5c8:	84 c0                	test   %al,%al
 5ca:	74 23                	je     5ef <printf+0x14f>
 5cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5d0:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5d3:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 5d6:	83 ec 04             	sub    $0x4,%esp
 5d9:	6a 01                	push   $0x1
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 5db:	83 c3 01             	add    $0x1,%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5de:	50                   	push   %eax
 5df:	57                   	push   %edi
 5e0:	e8 8d fd ff ff       	call   372 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5e5:	0f b6 03             	movzbl (%ebx),%eax
 5e8:	83 c4 10             	add    $0x10,%esp
 5eb:	84 c0                	test   %al,%al
 5ed:	75 e1                	jne    5d0 <printf+0x130>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5ef:	31 d2                	xor    %edx,%edx
 5f1:	e9 ff fe ff ff       	jmp    4f5 <printf+0x55>
 5f6:	8d 76 00             	lea    0x0(%esi),%esi
 5f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 600:	83 ec 04             	sub    $0x4,%esp
 603:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 606:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 609:	6a 01                	push   $0x1
 60b:	e9 4c ff ff ff       	jmp    55c <printf+0xbc>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 610:	83 ec 0c             	sub    $0xc,%esp
 613:	b9 0a 00 00 00       	mov    $0xa,%ecx
 618:	6a 01                	push   $0x1
 61a:	e9 6b ff ff ff       	jmp    58a <printf+0xea>
 61f:	8b 5d d0             	mov    -0x30(%ebp),%ebx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 622:	83 ec 04             	sub    $0x4,%esp
 625:	8b 03                	mov    (%ebx),%eax
 627:	6a 01                	push   $0x1
 629:	88 45 e4             	mov    %al,-0x1c(%ebp)
 62c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 62f:	50                   	push   %eax
 630:	57                   	push   %edi
 631:	e8 3c fd ff ff       	call   372 <write>
 636:	e9 5b ff ff ff       	jmp    596 <printf+0xf6>
 63b:	66 90                	xchg   %ax,%ax
 63d:	66 90                	xchg   %ax,%ax
 63f:	90                   	nop

00000640 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 640:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 641:	a1 80 0a 03 00       	mov    0x30a80,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 646:	89 e5                	mov    %esp,%ebp
 648:	57                   	push   %edi
 649:	56                   	push   %esi
 64a:	53                   	push   %ebx
 64b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64e:	8b 10                	mov    (%eax),%edx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 650:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 653:	39 c8                	cmp    %ecx,%eax
 655:	73 19                	jae    670 <free+0x30>
 657:	89 f6                	mov    %esi,%esi
 659:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 660:	39 d1                	cmp    %edx,%ecx
 662:	72 1c                	jb     680 <free+0x40>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 664:	39 d0                	cmp    %edx,%eax
 666:	73 18                	jae    680 <free+0x40>
static Header base;
static Header *freep;

void
free(void *ap)
{
 668:	89 d0                	mov    %edx,%eax
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66a:	39 c8                	cmp    %ecx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66c:	8b 10                	mov    (%eax),%edx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 66e:	72 f0                	jb     660 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 670:	39 d0                	cmp    %edx,%eax
 672:	72 f4                	jb     668 <free+0x28>
 674:	39 d1                	cmp    %edx,%ecx
 676:	73 f0                	jae    668 <free+0x28>
 678:	90                   	nop
 679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
  if(bp + bp->s.size == p->s.ptr){
 680:	8b 73 fc             	mov    -0x4(%ebx),%esi
 683:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 686:	39 d7                	cmp    %edx,%edi
 688:	74 19                	je     6a3 <free+0x63>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 68a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 68d:	8b 50 04             	mov    0x4(%eax),%edx
 690:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 693:	39 f1                	cmp    %esi,%ecx
 695:	74 23                	je     6ba <free+0x7a>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 697:	89 08                	mov    %ecx,(%eax)
  freep = p;
 699:	a3 80 0a 03 00       	mov    %eax,0x30a80
}
 69e:	5b                   	pop    %ebx
 69f:	5e                   	pop    %esi
 6a0:	5f                   	pop    %edi
 6a1:	5d                   	pop    %ebp
 6a2:	c3                   	ret    
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6a3:	03 72 04             	add    0x4(%edx),%esi
 6a6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a9:	8b 10                	mov    (%eax),%edx
 6ab:	8b 12                	mov    (%edx),%edx
 6ad:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6b0:	8b 50 04             	mov    0x4(%eax),%edx
 6b3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6b6:	39 f1                	cmp    %esi,%ecx
 6b8:	75 dd                	jne    697 <free+0x57>
    p->s.size += bp->s.size;
 6ba:	03 53 fc             	add    -0x4(%ebx),%edx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 6bd:	a3 80 0a 03 00       	mov    %eax,0x30a80
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6c2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6c5:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6c8:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6ca:	5b                   	pop    %ebx
 6cb:	5e                   	pop    %esi
 6cc:	5f                   	pop    %edi
 6cd:	5d                   	pop    %ebp
 6ce:	c3                   	ret    
 6cf:	90                   	nop

000006d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6dc:	8b 15 80 0a 03 00    	mov    0x30a80,%edx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e2:	8d 78 07             	lea    0x7(%eax),%edi
 6e5:	c1 ef 03             	shr    $0x3,%edi
 6e8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 6eb:	85 d2                	test   %edx,%edx
 6ed:	0f 84 a3 00 00 00    	je     796 <malloc+0xc6>
 6f3:	8b 02                	mov    (%edx),%eax
 6f5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6f8:	39 cf                	cmp    %ecx,%edi
 6fa:	76 74                	jbe    770 <malloc+0xa0>
 6fc:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 702:	be 00 10 00 00       	mov    $0x1000,%esi
 707:	8d 1c fd 00 00 00 00 	lea    0x0(,%edi,8),%ebx
 70e:	0f 43 f7             	cmovae %edi,%esi
 711:	ba 00 80 00 00       	mov    $0x8000,%edx
 716:	81 ff ff 0f 00 00    	cmp    $0xfff,%edi
 71c:	0f 46 da             	cmovbe %edx,%ebx
 71f:	eb 10                	jmp    731 <malloc+0x61>
 721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 728:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 72a:	8b 48 04             	mov    0x4(%eax),%ecx
 72d:	39 cf                	cmp    %ecx,%edi
 72f:	76 3f                	jbe    770 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 731:	39 05 80 0a 03 00    	cmp    %eax,0x30a80
 737:	89 c2                	mov    %eax,%edx
 739:	75 ed                	jne    728 <malloc+0x58>
  char *p;
  Header *hp;

  if(nu < 4096)
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 73b:	83 ec 0c             	sub    $0xc,%esp
 73e:	53                   	push   %ebx
 73f:	e8 96 fc ff ff       	call   3da <sbrk>
  if(p == (char*)-1)
 744:	83 c4 10             	add    $0x10,%esp
 747:	83 f8 ff             	cmp    $0xffffffff,%eax
 74a:	74 1c                	je     768 <malloc+0x98>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 74c:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 74f:	83 ec 0c             	sub    $0xc,%esp
 752:	83 c0 08             	add    $0x8,%eax
 755:	50                   	push   %eax
 756:	e8 e5 fe ff ff       	call   640 <free>
  return freep;
 75b:	8b 15 80 0a 03 00    	mov    0x30a80,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 761:	83 c4 10             	add    $0x10,%esp
 764:	85 d2                	test   %edx,%edx
 766:	75 c0                	jne    728 <malloc+0x58>
        return 0;
 768:	31 c0                	xor    %eax,%eax
 76a:	eb 1c                	jmp    788 <malloc+0xb8>
 76c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 770:	39 cf                	cmp    %ecx,%edi
 772:	74 1c                	je     790 <malloc+0xc0>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 774:	29 f9                	sub    %edi,%ecx
 776:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 779:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 77c:	89 78 04             	mov    %edi,0x4(%eax)
      }
      freep = prevp;
 77f:	89 15 80 0a 03 00    	mov    %edx,0x30a80
      return (void*)(p + 1);
 785:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 788:	8d 65 f4             	lea    -0xc(%ebp),%esp
 78b:	5b                   	pop    %ebx
 78c:	5e                   	pop    %esi
 78d:	5f                   	pop    %edi
 78e:	5d                   	pop    %ebp
 78f:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 790:	8b 08                	mov    (%eax),%ecx
 792:	89 0a                	mov    %ecx,(%edx)
 794:	eb e9                	jmp    77f <malloc+0xaf>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 796:	c7 05 80 0a 03 00 84 	movl   $0x30a84,0x30a80
 79d:	0a 03 00 
 7a0:	c7 05 84 0a 03 00 84 	movl   $0x30a84,0x30a84
 7a7:	0a 03 00 
    base.s.size = 0;
 7aa:	b8 84 0a 03 00       	mov    $0x30a84,%eax
 7af:	c7 05 88 0a 03 00 00 	movl   $0x0,0x30a88
 7b6:	00 00 00 
 7b9:	e9 3e ff ff ff       	jmp    6fc <malloc+0x2c>

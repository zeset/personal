
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc d0 b5 10 80       	mov    $0x8010b5d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c0 2e 10 80       	mov    $0x80102ec0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	83 ec 10             	sub    $0x10,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
80100046:	68 a0 70 10 80       	push   $0x801070a0
8010004b:	68 e0 b5 10 80       	push   $0x8010b5e0
80100050:	e8 cb 41 00 00       	call   80104220 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100055:	c7 05 f0 f4 10 80 e4 	movl   $0x8010f4e4,0x8010f4f0
8010005c:	f4 10 80 
  bcache.head.next = &bcache.head;
8010005f:	c7 05 f4 f4 10 80 e4 	movl   $0x8010f4e4,0x8010f4f4
80100066:	f4 10 80 
80100069:	83 c4 10             	add    $0x10,%esp
8010006c:	b9 e4 f4 10 80       	mov    $0x8010f4e4,%ecx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100071:	b8 14 b6 10 80       	mov    $0x8010b614,%eax
80100076:	eb 0a                	jmp    80100082 <binit+0x42>
80100078:	90                   	nop
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d0                	mov    %edx,%eax
    b->next = bcache.head.next;
80100082:	89 48 10             	mov    %ecx,0x10(%eax)
    b->prev = &bcache.head;
80100085:	c7 40 0c e4 f4 10 80 	movl   $0x8010f4e4,0xc(%eax)
8010008c:	89 c1                	mov    %eax,%ecx
    b->dev = -1;
8010008e:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
80100095:	8b 15 f4 f4 10 80    	mov    0x8010f4f4,%edx
8010009b:	89 42 0c             	mov    %eax,0xc(%edx)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	8d 90 18 02 00 00    	lea    0x218(%eax),%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000a4:	a3 f4 f4 10 80       	mov    %eax,0x8010f4f4

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	81 fa e4 f4 10 80    	cmp    $0x8010f4e4,%edx
801000af:	75 cf                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    
801000b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801000b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000c0 <bread>:
}

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000c0:	55                   	push   %ebp
801000c1:	89 e5                	mov    %esp,%ebp
801000c3:	57                   	push   %edi
801000c4:	56                   	push   %esi
801000c5:	53                   	push   %ebx
801000c6:	83 ec 18             	sub    $0x18,%esp
801000c9:	8b 75 08             	mov    0x8(%ebp),%esi
801000cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000cf:	68 e0 b5 10 80       	push   $0x8010b5e0
801000d4:	e8 67 41 00 00       	call   80104240 <acquire>
801000d9:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000dc:	8b 1d f4 f4 10 80    	mov    0x8010f4f4,%ebx
801000e2:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
801000e8:	75 11                	jne    801000fb <bread+0x3b>
801000ea:	eb 34                	jmp    80100120 <bread+0x60>
801000ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801000f0:	8b 5b 10             	mov    0x10(%ebx),%ebx
801000f3:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
801000f9:	74 25                	je     80100120 <bread+0x60>
    if(b->dev == dev && b->blockno == blockno){
801000fb:	3b 73 04             	cmp    0x4(%ebx),%esi
801000fe:	75 f0                	jne    801000f0 <bread+0x30>
80100100:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100103:	75 eb                	jne    801000f0 <bread+0x30>
      if(!(b->flags & B_BUSY)){
80100105:	8b 03                	mov    (%ebx),%eax
80100107:	a8 01                	test   $0x1,%al
80100109:	74 6c                	je     80100177 <bread+0xb7>
        b->flags |= B_BUSY;
        release(&bcache.lock);
        return b;
      }
      sleep(b, &bcache.lock);
8010010b:	83 ec 08             	sub    $0x8,%esp
8010010e:	68 e0 b5 10 80       	push   $0x8010b5e0
80100113:	53                   	push   %ebx
80100114:	e8 e7 3c 00 00       	call   80103e00 <sleep>
80100119:	83 c4 10             	add    $0x10,%esp
8010011c:	eb be                	jmp    801000dc <bread+0x1c>
8010011e:	66 90                	xchg   %ax,%ax
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d f0 f4 10 80    	mov    0x8010f4f0,%ebx
80100126:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x7b>
8010012e:	eb 5e                	jmp    8010018e <bread+0xce>
80100130:	8b 5b 0c             	mov    0xc(%ebx),%ebx
80100133:	81 fb e4 f4 10 80    	cmp    $0x8010f4e4,%ebx
80100139:	74 53                	je     8010018e <bread+0xce>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010013b:	f6 03 05             	testb  $0x5,(%ebx)
8010013e:	75 f0                	jne    80100130 <bread+0x70>
      b->dev = dev;
      b->blockno = blockno;
      b->flags = B_BUSY;
      release(&bcache.lock);
80100140:	83 ec 0c             	sub    $0xc,%esp
  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
      b->dev = dev;
80100143:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
80100146:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = B_BUSY;
80100149:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
      release(&bcache.lock);
8010014f:	68 e0 b5 10 80       	push   $0x8010b5e0
80100154:	e8 c7 42 00 00       	call   80104420 <release>
80100159:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if(!(b->flags & B_VALID)) {
8010015c:	f6 03 02             	testb  $0x2,(%ebx)
8010015f:	75 0c                	jne    8010016d <bread+0xad>
    iderw(b);
80100161:	83 ec 0c             	sub    $0xc,%esp
80100164:	53                   	push   %ebx
80100165:	e8 66 1f 00 00       	call   801020d0 <iderw>
8010016a:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
8010016d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100170:	89 d8                	mov    %ebx,%eax
80100172:	5b                   	pop    %ebx
80100173:	5e                   	pop    %esi
80100174:	5f                   	pop    %edi
80100175:	5d                   	pop    %ebp
80100176:	c3                   	ret    
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      if(!(b->flags & B_BUSY)){
        b->flags |= B_BUSY;
        release(&bcache.lock);
80100177:	83 ec 0c             	sub    $0xc,%esp
 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    if(b->dev == dev && b->blockno == blockno){
      if(!(b->flags & B_BUSY)){
        b->flags |= B_BUSY;
8010017a:	83 c8 01             	or     $0x1,%eax
8010017d:	89 03                	mov    %eax,(%ebx)
        release(&bcache.lock);
8010017f:	68 e0 b5 10 80       	push   $0x8010b5e0
80100184:	e8 97 42 00 00       	call   80104420 <release>
80100189:	83 c4 10             	add    $0x10,%esp
8010018c:	eb ce                	jmp    8010015c <bread+0x9c>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
8010018e:	83 ec 0c             	sub    $0xc,%esp
80100191:	68 a7 70 10 80       	push   $0x801070a7
80100196:	e8 b5 01 00 00       	call   80100350 <panic>
8010019b:	90                   	nop
8010019c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	83 ec 08             	sub    $0x8,%esp
801001a6:	8b 55 08             	mov    0x8(%ebp),%edx
  if((b->flags & B_BUSY) == 0)
801001a9:	8b 02                	mov    (%edx),%eax
801001ab:	a8 01                	test   $0x1,%al
801001ad:	74 0e                	je     801001bd <bwrite+0x1d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001af:	83 c8 04             	or     $0x4,%eax
801001b2:	89 02                	mov    %eax,(%edx)
  iderw(b);
801001b4:	89 55 08             	mov    %edx,0x8(%ebp)
}
801001b7:	c9                   	leave  
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001b8:	e9 13 1f 00 00       	jmp    801020d0 <iderw>
// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
801001bd:	83 ec 0c             	sub    $0xc,%esp
801001c0:	68 b8 70 10 80       	push   $0x801070b8
801001c5:	e8 86 01 00 00       	call   80100350 <panic>
801001ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001d0 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001d0:	55                   	push   %ebp
801001d1:	89 e5                	mov    %esp,%ebp
801001d3:	53                   	push   %ebx
801001d4:	83 ec 04             	sub    $0x4,%esp
801001d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((b->flags & B_BUSY) == 0)
801001da:	f6 03 01             	testb  $0x1,(%ebx)
801001dd:	74 5a                	je     80100239 <brelse+0x69>
    panic("brelse");

  acquire(&bcache.lock);
801001df:	83 ec 0c             	sub    $0xc,%esp
801001e2:	68 e0 b5 10 80       	push   $0x8010b5e0
801001e7:	e8 54 40 00 00       	call   80104240 <acquire>

  b->next->prev = b->prev;
801001ec:	8b 43 10             	mov    0x10(%ebx),%eax
801001ef:	8b 53 0c             	mov    0xc(%ebx),%edx
801001f2:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
801001f5:	8b 43 0c             	mov    0xc(%ebx),%eax
801001f8:	8b 53 10             	mov    0x10(%ebx),%edx
801001fb:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
801001fe:	a1 f4 f4 10 80       	mov    0x8010f4f4,%eax
  b->prev = &bcache.head;
80100203:	c7 43 0c e4 f4 10 80 	movl   $0x8010f4e4,0xc(%ebx)

  acquire(&bcache.lock);

  b->next->prev = b->prev;
  b->prev->next = b->next;
  b->next = bcache.head.next;
8010020a:	89 43 10             	mov    %eax,0x10(%ebx)
  b->prev = &bcache.head;
  bcache.head.next->prev = b;
8010020d:	a1 f4 f4 10 80       	mov    0x8010f4f4,%eax
80100212:	89 58 0c             	mov    %ebx,0xc(%eax)
  bcache.head.next = b;
80100215:	89 1d f4 f4 10 80    	mov    %ebx,0x8010f4f4

  b->flags &= ~B_BUSY;
8010021b:	83 23 fe             	andl   $0xfffffffe,(%ebx)
  wakeup(b);
8010021e:	89 1c 24             	mov    %ebx,(%esp)
80100221:	e8 7a 3d 00 00       	call   80103fa0 <wakeup>

  release(&bcache.lock);
80100226:	83 c4 10             	add    $0x10,%esp
80100229:	c7 45 08 e0 b5 10 80 	movl   $0x8010b5e0,0x8(%ebp)
}
80100230:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100233:	c9                   	leave  
  bcache.head.next = b;

  b->flags &= ~B_BUSY;
  wakeup(b);

  release(&bcache.lock);
80100234:	e9 e7 41 00 00       	jmp    80104420 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
80100239:	83 ec 0c             	sub    $0xc,%esp
8010023c:	68 bf 70 10 80       	push   $0x801070bf
80100241:	e8 0a 01 00 00       	call   80100350 <panic>
80100246:	66 90                	xchg   %ax,%ax
80100248:	66 90                	xchg   %ax,%ax
8010024a:	66 90                	xchg   %ax,%ax
8010024c:	66 90                	xchg   %ax,%ax
8010024e:	66 90                	xchg   %ax,%ax

80100250 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100250:	55                   	push   %ebp
80100251:	89 e5                	mov    %esp,%ebp
80100253:	57                   	push   %edi
80100254:	56                   	push   %esi
80100255:	53                   	push   %ebx
80100256:	83 ec 28             	sub    $0x28,%esp
80100259:	8b 7d 08             	mov    0x8(%ebp),%edi
8010025c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010025f:	57                   	push   %edi
80100260:	e8 ab 14 00 00       	call   80101710 <iunlock>
  target = n;
  acquire(&cons.lock);
80100265:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010026c:	e8 cf 3f 00 00       	call   80104240 <acquire>
  while(n > 0){
80100271:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100274:	83 c4 10             	add    $0x10,%esp
80100277:	31 c0                	xor    %eax,%eax
80100279:	85 db                	test   %ebx,%ebx
8010027b:	0f 8e 9a 00 00 00    	jle    8010031b <consoleread+0xcb>
    while(input.r == input.w){
80100281:	a1 80 f7 10 80       	mov    0x8010f780,%eax
80100286:	3b 05 84 f7 10 80    	cmp    0x8010f784,%eax
8010028c:	74 24                	je     801002b2 <consoleread+0x62>
8010028e:	eb 58                	jmp    801002e8 <consoleread+0x98>
      if(proc->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
80100290:	83 ec 08             	sub    $0x8,%esp
80100293:	68 20 a5 10 80       	push   $0x8010a520
80100298:	68 80 f7 10 80       	push   $0x8010f780
8010029d:	e8 5e 3b 00 00       	call   80103e00 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002a2:	a1 80 f7 10 80       	mov    0x8010f780,%eax
801002a7:	83 c4 10             	add    $0x10,%esp
801002aa:	3b 05 84 f7 10 80    	cmp    0x8010f784,%eax
801002b0:	75 36                	jne    801002e8 <consoleread+0x98>
      if(proc->killed){
801002b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801002b8:	8b 40 24             	mov    0x24(%eax),%eax
801002bb:	85 c0                	test   %eax,%eax
801002bd:	74 d1                	je     80100290 <consoleread+0x40>
        release(&cons.lock);
801002bf:	83 ec 0c             	sub    $0xc,%esp
801002c2:	68 20 a5 10 80       	push   $0x8010a520
801002c7:	e8 54 41 00 00       	call   80104420 <release>
        ilock(ip);
801002cc:	89 3c 24             	mov    %edi,(%esp)
801002cf:	e8 2c 13 00 00       	call   80101600 <ilock>
        return -1;
801002d4:	83 c4 10             	add    $0x10,%esp
801002d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002df:	5b                   	pop    %ebx
801002e0:	5e                   	pop    %esi
801002e1:	5f                   	pop    %edi
801002e2:	5d                   	pop    %ebp
801002e3:	c3                   	ret    
801002e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002e8:	8d 50 01             	lea    0x1(%eax),%edx
801002eb:	89 15 80 f7 10 80    	mov    %edx,0x8010f780
801002f1:	89 c2                	mov    %eax,%edx
801002f3:	83 e2 7f             	and    $0x7f,%edx
801002f6:	0f be 92 00 f7 10 80 	movsbl -0x7fef0900(%edx),%edx
    if(c == C('D')){  // EOF
801002fd:	83 fa 04             	cmp    $0x4,%edx
80100300:	74 39                	je     8010033b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100302:	83 c6 01             	add    $0x1,%esi
    --n;
80100305:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100308:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010030b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010030e:	74 35                	je     80100345 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100310:	85 db                	test   %ebx,%ebx
80100312:	0f 85 69 ff ff ff    	jne    80100281 <consoleread+0x31>
80100318:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010031b:	83 ec 0c             	sub    $0xc,%esp
8010031e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100321:	68 20 a5 10 80       	push   $0x8010a520
80100326:	e8 f5 40 00 00       	call   80104420 <release>
  ilock(ip);
8010032b:	89 3c 24             	mov    %edi,(%esp)
8010032e:	e8 cd 12 00 00       	call   80101600 <ilock>

  return target - n;
80100333:	83 c4 10             	add    $0x10,%esp
80100336:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100339:	eb a1                	jmp    801002dc <consoleread+0x8c>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010033b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010033e:	76 05                	jbe    80100345 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100340:	a3 80 f7 10 80       	mov    %eax,0x8010f780
80100345:	8b 45 10             	mov    0x10(%ebp),%eax
80100348:	29 d8                	sub    %ebx,%eax
8010034a:	eb cf                	jmp    8010031b <consoleread+0xcb>
8010034c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100350 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100350:	55                   	push   %ebp
80100351:	89 e5                	mov    %esp,%ebp
80100353:	56                   	push   %esi
80100354:	53                   	push   %ebx
80100355:	83 ec 38             	sub    $0x38,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100358:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
80100359:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
{
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
8010035f:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100366:	00 00 00 
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100369:	8d 5d d0             	lea    -0x30(%ebp),%ebx
8010036c:	8d 75 f8             	lea    -0x8(%ebp),%esi
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
8010036f:	0f b6 00             	movzbl (%eax),%eax
80100372:	50                   	push   %eax
80100373:	68 c6 70 10 80       	push   $0x801070c6
80100378:	e8 c3 02 00 00       	call   80100640 <cprintf>
  cprintf(s);
8010037d:	58                   	pop    %eax
8010037e:	ff 75 08             	pushl  0x8(%ebp)
80100381:	e8 ba 02 00 00       	call   80100640 <cprintf>
  cprintf("\n");
80100386:	c7 04 24 e6 75 10 80 	movl   $0x801075e6,(%esp)
8010038d:	e8 ae 02 00 00       	call   80100640 <cprintf>
  getcallerpcs(&s, pcs);
80100392:	5a                   	pop    %edx
80100393:	8d 45 08             	lea    0x8(%ebp),%eax
80100396:	59                   	pop    %ecx
80100397:	53                   	push   %ebx
80100398:	50                   	push   %eax
80100399:	e8 72 3f 00 00       	call   80104310 <getcallerpcs>
8010039e:	83 c4 10             	add    $0x10,%esp
801003a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003a8:	83 ec 08             	sub    $0x8,%esp
801003ab:	ff 33                	pushl  (%ebx)
801003ad:	83 c3 04             	add    $0x4,%ebx
801003b0:	68 e2 70 10 80       	push   $0x801070e2
801003b5:	e8 86 02 00 00       	call   80100640 <cprintf>
  cons.locking = 0;
  cprintf("cpu with apicid %d: panic: ", cpu->apicid);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003ba:	83 c4 10             	add    $0x10,%esp
801003bd:	39 f3                	cmp    %esi,%ebx
801003bf:	75 e7                	jne    801003a8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003c1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003c8:	00 00 00 
801003cb:	eb fe                	jmp    801003cb <panic+0x7b>
801003cd:	8d 76 00             	lea    0x0(%esi),%esi

801003d0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003d0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003d6:	85 d2                	test   %edx,%edx
801003d8:	74 06                	je     801003e0 <consputc+0x10>
801003da:	fa                   	cli    
801003db:	eb fe                	jmp    801003db <consputc+0xb>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003e0:	55                   	push   %ebp
801003e1:	89 e5                	mov    %esp,%ebp
801003e3:	57                   	push   %edi
801003e4:	56                   	push   %esi
801003e5:	53                   	push   %ebx
801003e6:	89 c3                	mov    %eax,%ebx
801003e8:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003eb:	3d 00 01 00 00       	cmp    $0x100,%eax
801003f0:	0f 84 b8 00 00 00    	je     801004ae <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
801003f6:	83 ec 0c             	sub    $0xc,%esp
801003f9:	50                   	push   %eax
801003fa:	e8 91 58 00 00       	call   80105c90 <uartputc>
801003ff:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100402:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100407:	b8 0e 00 00 00       	mov    $0xe,%eax
8010040c:	89 fa                	mov    %edi,%edx
8010040e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010040f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100414:	89 f2                	mov    %esi,%edx
80100416:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100417:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010041a:	89 fa                	mov    %edi,%edx
8010041c:	c1 e0 08             	shl    $0x8,%eax
8010041f:	89 c1                	mov    %eax,%ecx
80100421:	b8 0f 00 00 00       	mov    $0xf,%eax
80100426:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100427:	89 f2                	mov    %esi,%edx
80100429:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010042a:	0f b6 c0             	movzbl %al,%eax
8010042d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010042f:	83 fb 0a             	cmp    $0xa,%ebx
80100432:	0f 84 0b 01 00 00    	je     80100543 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100438:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010043e:	0f 84 e6 00 00 00    	je     8010052a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100444:	0f b6 d3             	movzbl %bl,%edx
80100447:	8d 78 01             	lea    0x1(%eax),%edi
8010044a:	80 ce 07             	or     $0x7,%dh
8010044d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100454:	80 

  if(pos < 0 || pos > 25*80)
80100455:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010045b:	0f 8f bc 00 00 00    	jg     8010051d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100461:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100467:	7f 6f                	jg     801004d8 <consputc+0x108>
80100469:	89 f8                	mov    %edi,%eax
8010046b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100472:	89 fb                	mov    %edi,%ebx
80100474:	c1 e8 08             	shr    $0x8,%eax
80100477:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100479:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010047e:	b8 0e 00 00 00       	mov    $0xe,%eax
80100483:	89 fa                	mov    %edi,%edx
80100485:	ee                   	out    %al,(%dx)
80100486:	ba d5 03 00 00       	mov    $0x3d5,%edx
8010048b:	89 f0                	mov    %esi,%eax
8010048d:	ee                   	out    %al,(%dx)
8010048e:	b8 0f 00 00 00       	mov    $0xf,%eax
80100493:	89 fa                	mov    %edi,%edx
80100495:	ee                   	out    %al,(%dx)
80100496:	ba d5 03 00 00       	mov    $0x3d5,%edx
8010049b:	89 d8                	mov    %ebx,%eax
8010049d:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
8010049e:	b8 20 07 00 00       	mov    $0x720,%eax
801004a3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004a9:	5b                   	pop    %ebx
801004aa:	5e                   	pop    %esi
801004ab:	5f                   	pop    %edi
801004ac:	5d                   	pop    %ebp
801004ad:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ae:	83 ec 0c             	sub    $0xc,%esp
801004b1:	6a 08                	push   $0x8
801004b3:	e8 d8 57 00 00       	call   80105c90 <uartputc>
801004b8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004bf:	e8 cc 57 00 00       	call   80105c90 <uartputc>
801004c4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004cb:	e8 c0 57 00 00       	call   80105c90 <uartputc>
801004d0:	83 c4 10             	add    $0x10,%esp
801004d3:	e9 2a ff ff ff       	jmp    80100402 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004d8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004db:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004de:	68 60 0e 00 00       	push   $0xe60
801004e3:	68 a0 80 0b 80       	push   $0x800b80a0
801004e8:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ed:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f4:	e8 27 40 00 00       	call   80104520 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004f9:	b8 80 07 00 00       	mov    $0x780,%eax
801004fe:	83 c4 0c             	add    $0xc,%esp
80100501:	29 d8                	sub    %ebx,%eax
80100503:	01 c0                	add    %eax,%eax
80100505:	50                   	push   %eax
80100506:	6a 00                	push   $0x0
80100508:	56                   	push   %esi
80100509:	e8 62 3f 00 00       	call   80104470 <memset>
8010050e:	89 f1                	mov    %esi,%ecx
80100510:	83 c4 10             	add    $0x10,%esp
80100513:	be 07 00 00 00       	mov    $0x7,%esi
80100518:	e9 5c ff ff ff       	jmp    80100479 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010051d:	83 ec 0c             	sub    $0xc,%esp
80100520:	68 e6 70 10 80       	push   $0x801070e6
80100525:	e8 26 fe ff ff       	call   80100350 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010052a:	85 c0                	test   %eax,%eax
8010052c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010052f:	0f 85 20 ff ff ff    	jne    80100455 <consputc+0x85>
80100535:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010053a:	31 db                	xor    %ebx,%ebx
8010053c:	31 f6                	xor    %esi,%esi
8010053e:	e9 36 ff ff ff       	jmp    80100479 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100543:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100548:	f7 ea                	imul   %edx
8010054a:	89 d0                	mov    %edx,%eax
8010054c:	c1 e8 05             	shr    $0x5,%eax
8010054f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100552:	c1 e0 04             	shl    $0x4,%eax
80100555:	8d 78 50             	lea    0x50(%eax),%edi
80100558:	e9 f8 fe ff ff       	jmp    80100455 <consputc+0x85>
8010055d:	8d 76 00             	lea    0x0(%esi),%esi

80100560 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100560:	55                   	push   %ebp
80100561:	89 e5                	mov    %esp,%ebp
80100563:	57                   	push   %edi
80100564:	56                   	push   %esi
80100565:	53                   	push   %ebx
80100566:	89 d6                	mov    %edx,%esi
80100568:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010056b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010056d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100570:	74 0c                	je     8010057e <printint+0x1e>
80100572:	89 c7                	mov    %eax,%edi
80100574:	c1 ef 1f             	shr    $0x1f,%edi
80100577:	85 c0                	test   %eax,%eax
80100579:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010057c:	78 51                	js     801005cf <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010057e:	31 ff                	xor    %edi,%edi
80100580:	8d 5d d7             	lea    -0x29(%ebp),%ebx
80100583:	eb 05                	jmp    8010058a <printint+0x2a>
80100585:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
80100588:	89 cf                	mov    %ecx,%edi
8010058a:	31 d2                	xor    %edx,%edx
8010058c:	8d 4f 01             	lea    0x1(%edi),%ecx
8010058f:	f7 f6                	div    %esi
80100591:	0f b6 92 14 71 10 80 	movzbl -0x7fef8eec(%edx),%edx
  }while((x /= base) != 0);
80100598:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
8010059a:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
8010059d:	75 e9                	jne    80100588 <printint+0x28>

  if(sign)
8010059f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005a2:	85 c0                	test   %eax,%eax
801005a4:	74 08                	je     801005ae <printint+0x4e>
    buf[i++] = '-';
801005a6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005ab:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ae:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005b8:	0f be 06             	movsbl (%esi),%eax
801005bb:	83 ee 01             	sub    $0x1,%esi
801005be:	e8 0d fe ff ff       	call   801003d0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c3:	39 de                	cmp    %ebx,%esi
801005c5:	75 f1                	jne    801005b8 <printint+0x58>
    consputc(buf[i]);
}
801005c7:	83 c4 2c             	add    $0x2c,%esp
801005ca:	5b                   	pop    %ebx
801005cb:	5e                   	pop    %esi
801005cc:	5f                   	pop    %edi
801005cd:	5d                   	pop    %ebp
801005ce:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005cf:	f7 d8                	neg    %eax
801005d1:	eb ab                	jmp    8010057e <printint+0x1e>
801005d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801005e0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005e0:	55                   	push   %ebp
801005e1:	89 e5                	mov    %esp,%ebp
801005e3:	57                   	push   %edi
801005e4:	56                   	push   %esi
801005e5:	53                   	push   %ebx
801005e6:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
801005e9:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005ec:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ef:	e8 1c 11 00 00       	call   80101710 <iunlock>
  acquire(&cons.lock);
801005f4:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005fb:	e8 40 3c 00 00       	call   80104240 <acquire>
80100600:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100603:	83 c4 10             	add    $0x10,%esp
80100606:	85 f6                	test   %esi,%esi
80100608:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010060b:	7e 12                	jle    8010061f <consolewrite+0x3f>
8010060d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100610:	0f b6 07             	movzbl (%edi),%eax
80100613:	83 c7 01             	add    $0x1,%edi
80100616:	e8 b5 fd ff ff       	call   801003d0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010061b:	39 df                	cmp    %ebx,%edi
8010061d:	75 f1                	jne    80100610 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010061f:	83 ec 0c             	sub    $0xc,%esp
80100622:	68 20 a5 10 80       	push   $0x8010a520
80100627:	e8 f4 3d 00 00       	call   80104420 <release>
  ilock(ip);
8010062c:	58                   	pop    %eax
8010062d:	ff 75 08             	pushl  0x8(%ebp)
80100630:	e8 cb 0f 00 00       	call   80101600 <ilock>

  return n;
}
80100635:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100638:	89 f0                	mov    %esi,%eax
8010063a:	5b                   	pop    %ebx
8010063b:	5e                   	pop    %esi
8010063c:	5f                   	pop    %edi
8010063d:	5d                   	pop    %ebp
8010063e:	c3                   	ret    
8010063f:	90                   	nop

80100640 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100640:	55                   	push   %ebp
80100641:	89 e5                	mov    %esp,%ebp
80100643:	57                   	push   %edi
80100644:	56                   	push   %esi
80100645:	53                   	push   %ebx
80100646:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100649:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010064e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100650:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100653:	0f 85 47 01 00 00    	jne    801007a0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100659:	8b 45 08             	mov    0x8(%ebp),%eax
8010065c:	85 c0                	test   %eax,%eax
8010065e:	89 c1                	mov    %eax,%ecx
80100660:	0f 84 4f 01 00 00    	je     801007b5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100666:	0f b6 00             	movzbl (%eax),%eax
80100669:	31 db                	xor    %ebx,%ebx
8010066b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010066e:	89 cf                	mov    %ecx,%edi
80100670:	85 c0                	test   %eax,%eax
80100672:	75 55                	jne    801006c9 <cprintf+0x89>
80100674:	eb 68                	jmp    801006de <cprintf+0x9e>
80100676:	8d 76 00             	lea    0x0(%esi),%esi
80100679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100680:	83 c3 01             	add    $0x1,%ebx
80100683:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
80100687:	85 d2                	test   %edx,%edx
80100689:	74 53                	je     801006de <cprintf+0x9e>
      break;
    switch(c){
8010068b:	83 fa 70             	cmp    $0x70,%edx
8010068e:	74 7a                	je     8010070a <cprintf+0xca>
80100690:	7f 6e                	jg     80100700 <cprintf+0xc0>
80100692:	83 fa 25             	cmp    $0x25,%edx
80100695:	0f 84 ad 00 00 00    	je     80100748 <cprintf+0x108>
8010069b:	83 fa 64             	cmp    $0x64,%edx
8010069e:	0f 85 84 00 00 00    	jne    80100728 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006a4:	8d 46 04             	lea    0x4(%esi),%eax
801006a7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006ac:	ba 0a 00 00 00       	mov    $0xa,%edx
801006b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b4:	8b 06                	mov    (%esi),%eax
801006b6:	e8 a5 fe ff ff       	call   80100560 <printint>
801006bb:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006be:	83 c3 01             	add    $0x1,%ebx
801006c1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006c5:	85 c0                	test   %eax,%eax
801006c7:	74 15                	je     801006de <cprintf+0x9e>
    if(c != '%'){
801006c9:	83 f8 25             	cmp    $0x25,%eax
801006cc:	74 b2                	je     80100680 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ce:	e8 fd fc ff ff       	call   801003d0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d3:	83 c3 01             	add    $0x1,%ebx
801006d6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006da:	85 c0                	test   %eax,%eax
801006dc:	75 eb                	jne    801006c9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	74 10                	je     801006f5 <cprintf+0xb5>
    release(&cons.lock);
801006e5:	83 ec 0c             	sub    $0xc,%esp
801006e8:	68 20 a5 10 80       	push   $0x8010a520
801006ed:	e8 2e 3d 00 00       	call   80104420 <release>
801006f2:	83 c4 10             	add    $0x10,%esp
}
801006f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006f8:	5b                   	pop    %ebx
801006f9:	5e                   	pop    %esi
801006fa:	5f                   	pop    %edi
801006fb:	5d                   	pop    %ebp
801006fc:	c3                   	ret    
801006fd:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 5b                	je     80100760 <cprintf+0x120>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	ba 10 00 00 00       	mov    $0x10,%edx
80100714:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100717:	8b 06                	mov    (%esi),%eax
80100719:	e8 42 fe ff ff       	call   80100560 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb 9b                	jmp    801006be <cprintf+0x7e>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 9b fc ff ff       	call   801003d0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 91 fc ff ff       	call   801003d0 <consputc>
      break;
8010073f:	e9 7a ff ff ff       	jmp    801006be <cprintf+0x7e>
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 7e fc ff ff       	call   801003d0 <consputc>
80100752:	e9 7c ff ff ff       	jmp    801006d3 <cprintf+0x93>
80100757:	89 f6                	mov    %esi,%esi
80100759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100760:	8d 46 04             	lea    0x4(%esi),%eax
80100763:	8b 36                	mov    (%esi),%esi
80100765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100768:	b8 f9 70 10 80       	mov    $0x801070f9,%eax
8010076d:	85 f6                	test   %esi,%esi
8010076f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100772:	0f be 06             	movsbl (%esi),%eax
80100775:	84 c0                	test   %al,%al
80100777:	74 16                	je     8010078f <cprintf+0x14f>
80100779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100780:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
80100783:	e8 48 fc ff ff       	call   801003d0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100788:	0f be 06             	movsbl (%esi),%eax
8010078b:	84 c0                	test   %al,%al
8010078d:	75 f1                	jne    80100780 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
8010078f:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80100792:	e9 27 ff ff ff       	jmp    801006be <cprintf+0x7e>
80100797:	89 f6                	mov    %esi,%esi
80100799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007a0:	83 ec 0c             	sub    $0xc,%esp
801007a3:	68 20 a5 10 80       	push   $0x8010a520
801007a8:	e8 93 3a 00 00       	call   80104240 <acquire>
801007ad:	83 c4 10             	add    $0x10,%esp
801007b0:	e9 a4 fe ff ff       	jmp    80100659 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 00 71 10 80       	push   $0x80107100
801007bd:	e8 8e fb ff ff       	call   80100350 <panic>
801007c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007d0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007d0:	55                   	push   %ebp
801007d1:	89 e5                	mov    %esp,%ebp
801007d3:	57                   	push   %edi
801007d4:	56                   	push   %esi
801007d5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007d6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007d8:	83 ec 18             	sub    $0x18,%esp
801007db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007de:	68 20 a5 10 80       	push   $0x8010a520
801007e3:	e8 58 3a 00 00       	call   80104240 <acquire>
  while((c = getc()) >= 0){
801007e8:	83 c4 10             	add    $0x10,%esp
801007eb:	90                   	nop
801007ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801007f0:	ff d3                	call   *%ebx
801007f2:	85 c0                	test   %eax,%eax
801007f4:	89 c7                	mov    %eax,%edi
801007f6:	78 48                	js     80100840 <consoleintr+0x70>
    switch(c){
801007f8:	83 ff 10             	cmp    $0x10,%edi
801007fb:	0f 84 3f 01 00 00    	je     80100940 <consoleintr+0x170>
80100801:	7e 5d                	jle    80100860 <consoleintr+0x90>
80100803:	83 ff 15             	cmp    $0x15,%edi
80100806:	0f 84 dc 00 00 00    	je     801008e8 <consoleintr+0x118>
8010080c:	83 ff 7f             	cmp    $0x7f,%edi
8010080f:	75 54                	jne    80100865 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100811:	a1 88 f7 10 80       	mov    0x8010f788,%eax
80100816:	3b 05 84 f7 10 80    	cmp    0x8010f784,%eax
8010081c:	74 d2                	je     801007f0 <consoleintr+0x20>
        input.e--;
8010081e:	83 e8 01             	sub    $0x1,%eax
80100821:	a3 88 f7 10 80       	mov    %eax,0x8010f788
        consputc(BACKSPACE);
80100826:	b8 00 01 00 00       	mov    $0x100,%eax
8010082b:	e8 a0 fb ff ff       	call   801003d0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	79 c0                	jns    801007f8 <consoleintr+0x28>
80100838:	90                   	nop
80100839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100840:	83 ec 0c             	sub    $0xc,%esp
80100843:	68 20 a5 10 80       	push   $0x8010a520
80100848:	e8 d3 3b 00 00       	call   80104420 <release>
  if(doprocdump) {
8010084d:	83 c4 10             	add    $0x10,%esp
80100850:	85 f6                	test   %esi,%esi
80100852:	0f 85 f8 00 00 00    	jne    80100950 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100858:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010085b:	5b                   	pop    %ebx
8010085c:	5e                   	pop    %esi
8010085d:	5f                   	pop    %edi
8010085e:	5d                   	pop    %ebp
8010085f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100860:	83 ff 08             	cmp    $0x8,%edi
80100863:	74 ac                	je     80100811 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100865:	85 ff                	test   %edi,%edi
80100867:	74 87                	je     801007f0 <consoleintr+0x20>
80100869:	a1 88 f7 10 80       	mov    0x8010f788,%eax
8010086e:	89 c2                	mov    %eax,%edx
80100870:	2b 15 80 f7 10 80    	sub    0x8010f780,%edx
80100876:	83 fa 7f             	cmp    $0x7f,%edx
80100879:	0f 87 71 ff ff ff    	ja     801007f0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010087f:	8d 50 01             	lea    0x1(%eax),%edx
80100882:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100885:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100888:	89 15 88 f7 10 80    	mov    %edx,0x8010f788
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010088e:	0f 84 c8 00 00 00    	je     8010095c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100894:	89 f9                	mov    %edi,%ecx
80100896:	88 88 00 f7 10 80    	mov    %cl,-0x7fef0900(%eax)
        consputc(c);
8010089c:	89 f8                	mov    %edi,%eax
8010089e:	e8 2d fb ff ff       	call   801003d0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008a3:	83 ff 0a             	cmp    $0xa,%edi
801008a6:	0f 84 c1 00 00 00    	je     8010096d <consoleintr+0x19d>
801008ac:	83 ff 04             	cmp    $0x4,%edi
801008af:	0f 84 b8 00 00 00    	je     8010096d <consoleintr+0x19d>
801008b5:	a1 80 f7 10 80       	mov    0x8010f780,%eax
801008ba:	83 e8 80             	sub    $0xffffff80,%eax
801008bd:	39 05 88 f7 10 80    	cmp    %eax,0x8010f788
801008c3:	0f 85 27 ff ff ff    	jne    801007f0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008c9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008cc:	a3 84 f7 10 80       	mov    %eax,0x8010f784
          wakeup(&input.r);
801008d1:	68 80 f7 10 80       	push   $0x8010f780
801008d6:	e8 c5 36 00 00       	call   80103fa0 <wakeup>
801008db:	83 c4 10             	add    $0x10,%esp
801008de:	e9 0d ff ff ff       	jmp    801007f0 <consoleintr+0x20>
801008e3:	90                   	nop
801008e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e8:	a1 88 f7 10 80       	mov    0x8010f788,%eax
801008ed:	39 05 84 f7 10 80    	cmp    %eax,0x8010f784
801008f3:	75 2b                	jne    80100920 <consoleintr+0x150>
801008f5:	e9 f6 fe ff ff       	jmp    801007f0 <consoleintr+0x20>
801008fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100900:	a3 88 f7 10 80       	mov    %eax,0x8010f788
        consputc(BACKSPACE);
80100905:	b8 00 01 00 00       	mov    $0x100,%eax
8010090a:	e8 c1 fa ff ff       	call   801003d0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010090f:	a1 88 f7 10 80       	mov    0x8010f788,%eax
80100914:	3b 05 84 f7 10 80    	cmp    0x8010f784,%eax
8010091a:	0f 84 d0 fe ff ff    	je     801007f0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100920:	83 e8 01             	sub    $0x1,%eax
80100923:	89 c2                	mov    %eax,%edx
80100925:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100928:	80 ba 00 f7 10 80 0a 	cmpb   $0xa,-0x7fef0900(%edx)
8010092f:	75 cf                	jne    80100900 <consoleintr+0x130>
80100931:	e9 ba fe ff ff       	jmp    801007f0 <consoleintr+0x20>
80100936:	8d 76 00             	lea    0x0(%esi),%esi
80100939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100940:	be 01 00 00 00       	mov    $0x1,%esi
80100945:	e9 a6 fe ff ff       	jmp    801007f0 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100950:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100953:	5b                   	pop    %ebx
80100954:	5e                   	pop    %esi
80100955:	5f                   	pop    %edi
80100956:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100957:	e9 34 37 00 00       	jmp    80104090 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010095c:	c6 80 00 f7 10 80 0a 	movb   $0xa,-0x7fef0900(%eax)
        consputc(c);
80100963:	b8 0a 00 00 00       	mov    $0xa,%eax
80100968:	e8 63 fa ff ff       	call   801003d0 <consputc>
8010096d:	a1 88 f7 10 80       	mov    0x8010f788,%eax
80100972:	e9 52 ff ff ff       	jmp    801008c9 <consoleintr+0xf9>
80100977:	89 f6                	mov    %esi,%esi
80100979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100980 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100980:	55                   	push   %ebp
80100981:	89 e5                	mov    %esp,%ebp
80100983:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100986:	68 09 71 10 80       	push   $0x80107109
8010098b:	68 20 a5 10 80       	push   $0x8010a520
80100990:	e8 8b 38 00 00       	call   80104220 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  picenable(IRQ_KBD);
80100995:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
8010099c:	c7 05 4c 01 11 80 e0 	movl   $0x801005e0,0x8011014c
801009a3:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801009a6:	c7 05 48 01 11 80 50 	movl   $0x80100250,0x80110148
801009ad:	02 10 80 
  cons.locking = 1;
801009b0:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009b7:	00 00 00 

  picenable(IRQ_KBD);
801009ba:	e8 d1 28 00 00       	call   80103290 <picenable>
  ioapicenable(IRQ_KBD, 0);
801009bf:	58                   	pop    %eax
801009c0:	5a                   	pop    %edx
801009c1:	6a 00                	push   $0x0
801009c3:	6a 01                	push   $0x1
801009c5:	e8 b6 18 00 00       	call   80102280 <ioapicenable>
}
801009ca:	83 c4 10             	add    $0x10,%esp
801009cd:	c9                   	leave  
801009ce:	c3                   	ret    
801009cf:	90                   	nop

801009d0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009d0:	55                   	push   %ebp
801009d1:	89 e5                	mov    %esp,%ebp
801009d3:	57                   	push   %edi
801009d4:	56                   	push   %esi
801009d5:	53                   	push   %ebx
801009d6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
801009dc:	e8 cf 21 00 00       	call   80102bb0 <begin_op>
  if((ip = namei(path)) == 0){
801009e1:	83 ec 0c             	sub    $0xc,%esp
801009e4:	ff 75 08             	pushl  0x8(%ebp)
801009e7:	e8 a4 14 00 00       	call   80101e90 <namei>
801009ec:	83 c4 10             	add    $0x10,%esp
801009ef:	85 c0                	test   %eax,%eax
801009f1:	0f 84 a3 01 00 00    	je     80100b9a <exec+0x1ca>
    end_op();
    return -1;
  }
  ilock(ip);
801009f7:	83 ec 0c             	sub    $0xc,%esp
801009fa:	89 c3                	mov    %eax,%ebx
801009fc:	50                   	push   %eax
801009fd:	e8 fe 0b 00 00       	call   80101600 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100a02:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a08:	6a 34                	push   $0x34
80100a0a:	6a 00                	push   $0x0
80100a0c:	50                   	push   %eax
80100a0d:	53                   	push   %ebx
80100a0e:	e8 0d 0f 00 00       	call   80101920 <readi>
80100a13:	83 c4 20             	add    $0x20,%esp
80100a16:	83 f8 33             	cmp    $0x33,%eax
80100a19:	77 25                	ja     80100a40 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a1b:	83 ec 0c             	sub    $0xc,%esp
80100a1e:	53                   	push   %ebx
80100a1f:	e8 ac 0e 00 00       	call   801018d0 <iunlockput>
    end_op();
80100a24:	e8 f7 21 00 00       	call   80102c20 <end_op>
80100a29:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a2c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a31:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a34:	5b                   	pop    %ebx
80100a35:	5e                   	pop    %esi
80100a36:	5f                   	pop    %edi
80100a37:	5d                   	pop    %ebp
80100a38:	c3                   	ret    
80100a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a40:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a47:	45 4c 46 
80100a4a:	75 cf                	jne    80100a1b <exec+0x4b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a4c:	e8 ff 5f 00 00       	call   80106a50 <setupkvm>
80100a51:	85 c0                	test   %eax,%eax
80100a53:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a59:	74 c0                	je     80100a1b <exec+0x4b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a5b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a62:	00 
80100a63:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a69:	0f 84 a1 02 00 00    	je     80100d10 <exec+0x340>
80100a6f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100a76:	00 00 00 
80100a79:	31 ff                	xor    %edi,%edi
80100a7b:	eb 18                	jmp    80100a95 <exec+0xc5>
80100a7d:	8d 76 00             	lea    0x0(%esi),%esi
80100a80:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a87:	83 c7 01             	add    $0x1,%edi
80100a8a:	83 c6 20             	add    $0x20,%esi
80100a8d:	39 f8                	cmp    %edi,%eax
80100a8f:	0f 8e ab 00 00 00    	jle    80100b40 <exec+0x170>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a95:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a9b:	6a 20                	push   $0x20
80100a9d:	56                   	push   %esi
80100a9e:	50                   	push   %eax
80100a9f:	53                   	push   %ebx
80100aa0:	e8 7b 0e 00 00       	call   80101920 <readi>
80100aa5:	83 c4 10             	add    $0x10,%esp
80100aa8:	83 f8 20             	cmp    $0x20,%eax
80100aab:	75 7b                	jne    80100b28 <exec+0x158>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100aad:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ab4:	75 ca                	jne    80100a80 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100ab6:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100abc:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ac2:	72 64                	jb     80100b28 <exec+0x158>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ac4:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100aca:	72 5c                	jb     80100b28 <exec+0x158>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100acc:	83 ec 04             	sub    $0x4,%esp
80100acf:	50                   	push   %eax
80100ad0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100ad6:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100adc:	e8 ff 61 00 00       	call   80106ce0 <allocuvm>
80100ae1:	83 c4 10             	add    $0x10,%esp
80100ae4:	85 c0                	test   %eax,%eax
80100ae6:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aec:	74 3a                	je     80100b28 <exec+0x158>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100aee:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100af4:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100af9:	75 2d                	jne    80100b28 <exec+0x158>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100afb:	83 ec 0c             	sub    $0xc,%esp
80100afe:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b04:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b0a:	53                   	push   %ebx
80100b0b:	50                   	push   %eax
80100b0c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b12:	e8 09 61 00 00       	call   80106c20 <loaduvm>
80100b17:	83 c4 20             	add    $0x20,%esp
80100b1a:	85 c0                	test   %eax,%eax
80100b1c:	0f 89 5e ff ff ff    	jns    80100a80 <exec+0xb0>
80100b22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b28:	83 ec 0c             	sub    $0xc,%esp
80100b2b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b31:	e8 da 62 00 00       	call   80106e10 <freevm>
80100b36:	83 c4 10             	add    $0x10,%esp
80100b39:	e9 dd fe ff ff       	jmp    80100a1b <exec+0x4b>
80100b3e:	66 90                	xchg   %ax,%ax
80100b40:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100b46:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100b4c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80100b52:	8d be 00 20 00 00    	lea    0x2000(%esi),%edi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b58:	83 ec 0c             	sub    $0xc,%esp
80100b5b:	53                   	push   %ebx
80100b5c:	e8 6f 0d 00 00       	call   801018d0 <iunlockput>
  end_op();
80100b61:	e8 ba 20 00 00       	call   80102c20 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b66:	83 c4 0c             	add    $0xc,%esp
80100b69:	57                   	push   %edi
80100b6a:	56                   	push   %esi
80100b6b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b71:	e8 6a 61 00 00       	call   80106ce0 <allocuvm>
80100b76:	83 c4 10             	add    $0x10,%esp
80100b79:	85 c0                	test   %eax,%eax
80100b7b:	89 c6                	mov    %eax,%esi
80100b7d:	75 2a                	jne    80100ba9 <exec+0x1d9>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b7f:	83 ec 0c             	sub    $0xc,%esp
80100b82:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b88:	e8 83 62 00 00       	call   80106e10 <freevm>
80100b8d:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b95:	e9 97 fe ff ff       	jmp    80100a31 <exec+0x61>
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
  if((ip = namei(path)) == 0){
    end_op();
80100b9a:	e8 81 20 00 00       	call   80102c20 <end_op>
    return -1;
80100b9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba4:	e9 88 fe ff ff       	jmp    80100a31 <exec+0x61>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ba9:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100baf:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bb2:	31 ff                	xor    %edi,%edi
80100bb4:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bb6:	50                   	push   %eax
80100bb7:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bbd:	e8 ce 62 00 00       	call   80106e90 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bc5:	83 c4 10             	add    $0x10,%esp
80100bc8:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100bce:	8b 00                	mov    (%eax),%eax
80100bd0:	85 c0                	test   %eax,%eax
80100bd2:	74 71                	je     80100c45 <exec+0x275>
80100bd4:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100bda:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100be0:	eb 0b                	jmp    80100bed <exec+0x21d>
80100be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(argc >= MAXARG)
80100be8:	83 ff 20             	cmp    $0x20,%edi
80100beb:	74 92                	je     80100b7f <exec+0x1af>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bed:	83 ec 0c             	sub    $0xc,%esp
80100bf0:	50                   	push   %eax
80100bf1:	e8 ba 3a 00 00       	call   801046b0 <strlen>
80100bf6:	f7 d0                	not    %eax
80100bf8:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100bfa:	58                   	pop    %eax
80100bfb:	8b 45 0c             	mov    0xc(%ebp),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bfe:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c01:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c04:	e8 a7 3a 00 00       	call   801046b0 <strlen>
80100c09:	83 c0 01             	add    $0x1,%eax
80100c0c:	50                   	push   %eax
80100c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c10:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c13:	53                   	push   %ebx
80100c14:	56                   	push   %esi
80100c15:	e8 d6 63 00 00       	call   80106ff0 <copyout>
80100c1a:	83 c4 20             	add    $0x20,%esp
80100c1d:	85 c0                	test   %eax,%eax
80100c1f:	0f 88 5a ff ff ff    	js     80100b7f <exec+0x1af>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c25:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c28:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c2f:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c32:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c38:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c3b:	85 c0                	test   %eax,%eax
80100c3d:	75 a9                	jne    80100be8 <exec+0x218>
80100c3f:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c45:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c4c:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c4e:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c55:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c59:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c60:	ff ff ff 
  ustack[1] = argc;
80100c63:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c69:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100c6b:	83 c0 0c             	add    $0xc,%eax
80100c6e:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c70:	50                   	push   %eax
80100c71:	52                   	push   %edx
80100c72:	53                   	push   %ebx
80100c73:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c79:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7f:	e8 6c 63 00 00       	call   80106ff0 <copyout>
80100c84:	83 c4 10             	add    $0x10,%esp
80100c87:	85 c0                	test   %eax,%eax
80100c89:	0f 88 f0 fe ff ff    	js     80100b7f <exec+0x1af>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c8f:	8b 45 08             	mov    0x8(%ebp),%eax
80100c92:	0f b6 10             	movzbl (%eax),%edx
80100c95:	84 d2                	test   %dl,%dl
80100c97:	74 1a                	je     80100cb3 <exec+0x2e3>
80100c99:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100c9c:	83 c0 01             	add    $0x1,%eax
80100c9f:	90                   	nop
    if(*s == '/')
      last = s+1;
80100ca0:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ca3:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ca6:	0f 44 c8             	cmove  %eax,%ecx
80100ca9:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cac:	84 d2                	test   %dl,%dl
80100cae:	75 f0                	jne    80100ca0 <exec+0x2d0>
80100cb0:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100cb3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cb9:	83 ec 04             	sub    $0x4,%esp
80100cbc:	6a 10                	push   $0x10
80100cbe:	ff 75 08             	pushl  0x8(%ebp)
80100cc1:	83 c0 6c             	add    $0x6c,%eax
80100cc4:	50                   	push   %eax
80100cc5:	e8 a6 39 00 00       	call   80104670 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100cd0:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100cd6:	8b 78 04             	mov    0x4(%eax),%edi
  proc->pgdir = pgdir;
  proc->sz = sz;
80100cd9:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
  proc->pgdir = pgdir;
80100cdb:	89 48 04             	mov    %ecx,0x4(%eax)
  proc->sz = sz;
  proc->tf->eip = elf.entry;  // main
80100cde:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ce4:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100cea:	8b 50 18             	mov    0x18(%eax),%edx
80100ced:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100cf0:	8b 50 18             	mov    0x18(%eax),%edx
80100cf3:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100cf6:	89 04 24             	mov    %eax,(%esp)
80100cf9:	e8 02 5e 00 00       	call   80106b00 <switchuvm>
  freevm(oldpgdir);
80100cfe:	89 3c 24             	mov    %edi,(%esp)
80100d01:	e8 0a 61 00 00       	call   80106e10 <freevm>
  return 0;
80100d06:	83 c4 10             	add    $0x10,%esp
80100d09:	31 c0                	xor    %eax,%eax
80100d0b:	e9 21 fd ff ff       	jmp    80100a31 <exec+0x61>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d10:	bf 00 20 00 00       	mov    $0x2000,%edi
80100d15:	31 f6                	xor    %esi,%esi
80100d17:	e9 3c fe ff ff       	jmp    80100b58 <exec+0x188>
80100d1c:	66 90                	xchg   %ax,%ax
80100d1e:	66 90                	xchg   %ax,%ax

80100d20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d20:	55                   	push   %ebp
80100d21:	89 e5                	mov    %esp,%ebp
80100d23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d26:	68 25 71 10 80       	push   $0x80107125
80100d2b:	68 a0 f7 10 80       	push   $0x8010f7a0
80100d30:	e8 eb 34 00 00       	call   80104220 <initlock>
}
80100d35:	83 c4 10             	add    $0x10,%esp
80100d38:	c9                   	leave  
80100d39:	c3                   	ret    
80100d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d44:	bb d4 f7 10 80       	mov    $0x8010f7d4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d49:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d4c:	68 a0 f7 10 80       	push   $0x8010f7a0
80100d51:	e8 ea 34 00 00       	call   80104240 <acquire>
80100d56:	83 c4 10             	add    $0x10,%esp
80100d59:	eb 10                	jmp    80100d6b <filealloc+0x2b>
80100d5b:	90                   	nop
80100d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d60:	83 c3 18             	add    $0x18,%ebx
80100d63:	81 fb 34 01 11 80    	cmp    $0x80110134,%ebx
80100d69:	74 25                	je     80100d90 <filealloc+0x50>
    if(f->ref == 0){
80100d6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d6e:	85 c0                	test   %eax,%eax
80100d70:	75 ee                	jne    80100d60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d72:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d75:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d7c:	68 a0 f7 10 80       	push   $0x8010f7a0
80100d81:	e8 9a 36 00 00       	call   80104420 <release>
      return f;
80100d86:	89 d8                	mov    %ebx,%eax
80100d88:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d8e:	c9                   	leave  
80100d8f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100d90:	83 ec 0c             	sub    $0xc,%esp
80100d93:	68 a0 f7 10 80       	push   $0x8010f7a0
80100d98:	e8 83 36 00 00       	call   80104420 <release>
  return 0;
80100d9d:	83 c4 10             	add    $0x10,%esp
80100da0:	31 c0                	xor    %eax,%eax
}
80100da2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100da5:	c9                   	leave  
80100da6:	c3                   	ret    
80100da7:	89 f6                	mov    %esi,%esi
80100da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100db0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	53                   	push   %ebx
80100db4:	83 ec 10             	sub    $0x10,%esp
80100db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dba:	68 a0 f7 10 80       	push   $0x8010f7a0
80100dbf:	e8 7c 34 00 00       	call   80104240 <acquire>
  if(f->ref < 1)
80100dc4:	8b 43 04             	mov    0x4(%ebx),%eax
80100dc7:	83 c4 10             	add    $0x10,%esp
80100dca:	85 c0                	test   %eax,%eax
80100dcc:	7e 1a                	jle    80100de8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dce:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100dd1:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100dd4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100dd7:	68 a0 f7 10 80       	push   $0x8010f7a0
80100ddc:	e8 3f 36 00 00       	call   80104420 <release>
  return f;
}
80100de1:	89 d8                	mov    %ebx,%eax
80100de3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de6:	c9                   	leave  
80100de7:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100de8:	83 ec 0c             	sub    $0xc,%esp
80100deb:	68 2c 71 10 80       	push   $0x8010712c
80100df0:	e8 5b f5 ff ff       	call   80100350 <panic>
80100df5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e00 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	57                   	push   %edi
80100e04:	56                   	push   %esi
80100e05:	53                   	push   %ebx
80100e06:	83 ec 28             	sub    $0x28,%esp
80100e09:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e0c:	68 a0 f7 10 80       	push   $0x8010f7a0
80100e11:	e8 2a 34 00 00       	call   80104240 <acquire>
  if(f->ref < 1)
80100e16:	8b 47 04             	mov    0x4(%edi),%eax
80100e19:	83 c4 10             	add    $0x10,%esp
80100e1c:	85 c0                	test   %eax,%eax
80100e1e:	0f 8e 9b 00 00 00    	jle    80100ebf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e24:	83 e8 01             	sub    $0x1,%eax
80100e27:	85 c0                	test   %eax,%eax
80100e29:	89 47 04             	mov    %eax,0x4(%edi)
80100e2c:	74 1a                	je     80100e48 <fileclose+0x48>
    release(&ftable.lock);
80100e2e:	c7 45 08 a0 f7 10 80 	movl   $0x8010f7a0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e38:	5b                   	pop    %ebx
80100e39:	5e                   	pop    %esi
80100e3a:	5f                   	pop    %edi
80100e3b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e3c:	e9 df 35 00 00       	jmp    80104420 <release>
80100e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e48:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e4c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e4e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e51:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e54:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e5a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e5d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e60:	68 a0 f7 10 80       	push   $0x8010f7a0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e65:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e68:	e8 b3 35 00 00       	call   80104420 <release>

  if(ff.type == FD_PIPE)
80100e6d:	83 c4 10             	add    $0x10,%esp
80100e70:	83 fb 01             	cmp    $0x1,%ebx
80100e73:	74 13                	je     80100e88 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e75:	83 fb 02             	cmp    $0x2,%ebx
80100e78:	74 26                	je     80100ea0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e7d:	5b                   	pop    %ebx
80100e7e:	5e                   	pop    %esi
80100e7f:	5f                   	pop    %edi
80100e80:	5d                   	pop    %ebp
80100e81:	c3                   	ret    
80100e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100e88:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100e8c:	83 ec 08             	sub    $0x8,%esp
80100e8f:	53                   	push   %ebx
80100e90:	56                   	push   %esi
80100e91:	e8 ca 25 00 00       	call   80103460 <pipeclose>
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	eb df                	jmp    80100e7a <fileclose+0x7a>
80100e9b:	90                   	nop
80100e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ea0:	e8 0b 1d 00 00       	call   80102bb0 <begin_op>
    iput(ff.ip);
80100ea5:	83 ec 0c             	sub    $0xc,%esp
80100ea8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eab:	e8 c0 08 00 00       	call   80101770 <iput>
    end_op();
80100eb0:	83 c4 10             	add    $0x10,%esp
  }
}
80100eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eb6:	5b                   	pop    %ebx
80100eb7:	5e                   	pop    %esi
80100eb8:	5f                   	pop    %edi
80100eb9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eba:	e9 61 1d 00 00       	jmp    80102c20 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100ebf:	83 ec 0c             	sub    $0xc,%esp
80100ec2:	68 34 71 10 80       	push   $0x80107134
80100ec7:	e8 84 f4 ff ff       	call   80100350 <panic>
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ed0:	55                   	push   %ebp
80100ed1:	89 e5                	mov    %esp,%ebp
80100ed3:	53                   	push   %ebx
80100ed4:	83 ec 04             	sub    $0x4,%esp
80100ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100edd:	75 31                	jne    80100f10 <filestat+0x40>
    ilock(f->ip);
80100edf:	83 ec 0c             	sub    $0xc,%esp
80100ee2:	ff 73 10             	pushl  0x10(%ebx)
80100ee5:	e8 16 07 00 00       	call   80101600 <ilock>
    stati(f->ip, st);
80100eea:	58                   	pop    %eax
80100eeb:	5a                   	pop    %edx
80100eec:	ff 75 0c             	pushl  0xc(%ebp)
80100eef:	ff 73 10             	pushl  0x10(%ebx)
80100ef2:	e8 f9 09 00 00       	call   801018f0 <stati>
    iunlock(f->ip);
80100ef7:	59                   	pop    %ecx
80100ef8:	ff 73 10             	pushl  0x10(%ebx)
80100efb:	e8 10 08 00 00       	call   80101710 <iunlock>
    return 0;
80100f00:	83 c4 10             	add    $0x10,%esp
80100f03:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f08:	c9                   	leave  
80100f09:	c3                   	ret    
80100f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f18:	c9                   	leave  
80100f19:	c3                   	ret    
80100f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f20 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	57                   	push   %edi
80100f24:	56                   	push   %esi
80100f25:	53                   	push   %ebx
80100f26:	83 ec 0c             	sub    $0xc,%esp
80100f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f2f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f32:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f36:	74 60                	je     80100f98 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f38:	8b 03                	mov    (%ebx),%eax
80100f3a:	83 f8 01             	cmp    $0x1,%eax
80100f3d:	74 41                	je     80100f80 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f3f:	83 f8 02             	cmp    $0x2,%eax
80100f42:	75 5b                	jne    80100f9f <fileread+0x7f>
    ilock(f->ip);
80100f44:	83 ec 0c             	sub    $0xc,%esp
80100f47:	ff 73 10             	pushl  0x10(%ebx)
80100f4a:	e8 b1 06 00 00       	call   80101600 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f4f:	57                   	push   %edi
80100f50:	ff 73 14             	pushl  0x14(%ebx)
80100f53:	56                   	push   %esi
80100f54:	ff 73 10             	pushl  0x10(%ebx)
80100f57:	e8 c4 09 00 00       	call   80101920 <readi>
80100f5c:	83 c4 20             	add    $0x20,%esp
80100f5f:	85 c0                	test   %eax,%eax
80100f61:	89 c6                	mov    %eax,%esi
80100f63:	7e 03                	jle    80100f68 <fileread+0x48>
      f->off += r;
80100f65:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f68:	83 ec 0c             	sub    $0xc,%esp
80100f6b:	ff 73 10             	pushl  0x10(%ebx)
80100f6e:	e8 9d 07 00 00       	call   80101710 <iunlock>
    return r;
80100f73:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f76:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7b:	5b                   	pop    %ebx
80100f7c:	5e                   	pop    %esi
80100f7d:	5f                   	pop    %edi
80100f7e:	5d                   	pop    %ebp
80100f7f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f80:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f83:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f89:	5b                   	pop    %ebx
80100f8a:	5e                   	pop    %esi
80100f8b:	5f                   	pop    %edi
80100f8c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f8d:	e9 9e 26 00 00       	jmp    80103630 <piperead>
80100f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f9d:	eb d9                	jmp    80100f78 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100f9f:	83 ec 0c             	sub    $0xc,%esp
80100fa2:	68 3e 71 10 80       	push   $0x8010713e
80100fa7:	e8 a4 f3 ff ff       	call   80100350 <panic>
80100fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fb0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fb0:	55                   	push   %ebp
80100fb1:	89 e5                	mov    %esp,%ebp
80100fb3:	57                   	push   %edi
80100fb4:	56                   	push   %esi
80100fb5:	53                   	push   %ebx
80100fb6:	83 ec 1c             	sub    $0x1c,%esp
80100fb9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fbf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fc3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fc6:	8b 45 10             	mov    0x10(%ebp),%eax
80100fc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fcc:	0f 84 aa 00 00 00    	je     8010107c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80100fd2:	8b 06                	mov    (%esi),%eax
80100fd4:	83 f8 01             	cmp    $0x1,%eax
80100fd7:	0f 84 c2 00 00 00    	je     8010109f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fdd:	83 f8 02             	cmp    $0x2,%eax
80100fe0:	0f 85 d8 00 00 00    	jne    801010be <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100fe6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fe9:	31 ff                	xor    %edi,%edi
80100feb:	85 c0                	test   %eax,%eax
80100fed:	7f 34                	jg     80101023 <filewrite+0x73>
80100fef:	e9 9c 00 00 00       	jmp    80101090 <filewrite+0xe0>
80100ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80100ff8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100ffb:	83 ec 0c             	sub    $0xc,%esp
80100ffe:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101001:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101004:	e8 07 07 00 00       	call   80101710 <iunlock>
      end_op();
80101009:	e8 12 1c 00 00       	call   80102c20 <end_op>
8010100e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101011:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101014:	39 d8                	cmp    %ebx,%eax
80101016:	0f 85 95 00 00 00    	jne    801010b1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010101c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010101e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101021:	7e 6d                	jle    80101090 <filewrite+0xe0>
      int n1 = n - i;
80101023:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101026:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010102b:	29 fb                	sub    %edi,%ebx
8010102d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101033:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101036:	e8 75 1b 00 00       	call   80102bb0 <begin_op>
      ilock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
80101041:	e8 ba 05 00 00       	call   80101600 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101046:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101049:	53                   	push   %ebx
8010104a:	ff 76 14             	pushl  0x14(%esi)
8010104d:	01 f8                	add    %edi,%eax
8010104f:	50                   	push   %eax
80101050:	ff 76 10             	pushl  0x10(%esi)
80101053:	e8 c8 09 00 00       	call   80101a20 <writei>
80101058:	83 c4 20             	add    $0x20,%esp
8010105b:	85 c0                	test   %eax,%eax
8010105d:	7f 99                	jg     80100ff8 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010105f:	83 ec 0c             	sub    $0xc,%esp
80101062:	ff 76 10             	pushl  0x10(%esi)
80101065:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101068:	e8 a3 06 00 00       	call   80101710 <iunlock>
      end_op();
8010106d:	e8 ae 1b 00 00       	call   80102c20 <end_op>

      if(r < 0)
80101072:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101075:	83 c4 10             	add    $0x10,%esp
80101078:	85 c0                	test   %eax,%eax
8010107a:	74 98                	je     80101014 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010107c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010107f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101084:	5b                   	pop    %ebx
80101085:	5e                   	pop    %esi
80101086:	5f                   	pop    %edi
80101087:	5d                   	pop    %ebp
80101088:	c3                   	ret    
80101089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101090:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101093:	75 e7                	jne    8010107c <filewrite+0xcc>
  }
  panic("filewrite");
}
80101095:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101098:	89 f8                	mov    %edi,%eax
8010109a:	5b                   	pop    %ebx
8010109b:	5e                   	pop    %esi
8010109c:	5f                   	pop    %edi
8010109d:	5d                   	pop    %ebp
8010109e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010109f:	8b 46 0c             	mov    0xc(%esi),%eax
801010a2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a8:	5b                   	pop    %ebx
801010a9:	5e                   	pop    %esi
801010aa:	5f                   	pop    %edi
801010ab:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010ac:	e9 4f 24 00 00       	jmp    80103500 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010b1:	83 ec 0c             	sub    $0xc,%esp
801010b4:	68 47 71 10 80       	push   $0x80107147
801010b9:	e8 92 f2 ff ff       	call   80100350 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010be:	83 ec 0c             	sub    $0xc,%esp
801010c1:	68 4d 71 10 80       	push   $0x8010714d
801010c6:	e8 85 f2 ff ff       	call   80100350 <panic>
801010cb:	66 90                	xchg   %ax,%ax
801010cd:	66 90                	xchg   %ax,%ax
801010cf:	90                   	nop

801010d0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010d9:	8b 0d a0 01 11 80    	mov    0x801101a0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010e2:	85 c9                	test   %ecx,%ecx
801010e4:	0f 84 85 00 00 00    	je     8010116f <balloc+0x9f>
801010ea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801010f1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801010f4:	83 ec 08             	sub    $0x8,%esp
801010f7:	89 f0                	mov    %esi,%eax
801010f9:	c1 f8 0c             	sar    $0xc,%eax
801010fc:	03 05 b8 01 11 80    	add    0x801101b8,%eax
80101102:	50                   	push   %eax
80101103:	ff 75 d8             	pushl  -0x28(%ebp)
80101106:	e8 b5 ef ff ff       	call   801000c0 <bread>
8010110b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010110e:	a1 a0 01 11 80       	mov    0x801101a0,%eax
80101113:	83 c4 10             	add    $0x10,%esp
80101116:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101119:	31 c0                	xor    %eax,%eax
8010111b:	eb 2d                	jmp    8010114a <balloc+0x7a>
8010111d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101120:	89 c1                	mov    %eax,%ecx
80101122:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101127:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010112a:	83 e1 07             	and    $0x7,%ecx
8010112d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010112f:	89 c1                	mov    %eax,%ecx
80101131:	c1 f9 03             	sar    $0x3,%ecx
80101134:	0f b6 7c 0b 18       	movzbl 0x18(%ebx,%ecx,1),%edi
80101139:	85 d7                	test   %edx,%edi
8010113b:	74 43                	je     80101180 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010113d:	83 c0 01             	add    $0x1,%eax
80101140:	83 c6 01             	add    $0x1,%esi
80101143:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101148:	74 05                	je     8010114f <balloc+0x7f>
8010114a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010114d:	72 d1                	jb     80101120 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	ff 75 e4             	pushl  -0x1c(%ebp)
80101155:	e8 76 f0 ff ff       	call   801001d0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010115a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101161:	83 c4 10             	add    $0x10,%esp
80101164:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101167:	39 05 a0 01 11 80    	cmp    %eax,0x801101a0
8010116d:	77 82                	ja     801010f1 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010116f:	83 ec 0c             	sub    $0xc,%esp
80101172:	68 57 71 10 80       	push   $0x80107157
80101177:	e8 d4 f1 ff ff       	call   80100350 <panic>
8010117c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101180:	09 fa                	or     %edi,%edx
80101182:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101185:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101188:	88 54 0f 18          	mov    %dl,0x18(%edi,%ecx,1)
        log_write(bp);
8010118c:	57                   	push   %edi
8010118d:	e8 fe 1b 00 00       	call   80102d90 <log_write>
        brelse(bp);
80101192:	89 3c 24             	mov    %edi,(%esp)
80101195:	e8 36 f0 ff ff       	call   801001d0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010119a:	58                   	pop    %eax
8010119b:	5a                   	pop    %edx
8010119c:	56                   	push   %esi
8010119d:	ff 75 d8             	pushl  -0x28(%ebp)
801011a0:	e8 1b ef ff ff       	call   801000c0 <bread>
801011a5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011a7:	8d 40 18             	lea    0x18(%eax),%eax
801011aa:	83 c4 0c             	add    $0xc,%esp
801011ad:	68 00 02 00 00       	push   $0x200
801011b2:	6a 00                	push   $0x0
801011b4:	50                   	push   %eax
801011b5:	e8 b6 32 00 00       	call   80104470 <memset>
  log_write(bp);
801011ba:	89 1c 24             	mov    %ebx,(%esp)
801011bd:	e8 ce 1b 00 00       	call   80102d90 <log_write>
  brelse(bp);
801011c2:	89 1c 24             	mov    %ebx,(%esp)
801011c5:	e8 06 f0 ff ff       	call   801001d0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011cd:	89 f0                	mov    %esi,%eax
801011cf:	5b                   	pop    %ebx
801011d0:	5e                   	pop    %esi
801011d1:	5f                   	pop    %edi
801011d2:	5d                   	pop    %ebp
801011d3:	c3                   	ret    
801011d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801011da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801011e0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801011e8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011ea:	bb f4 01 11 80       	mov    $0x801101f4,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011ef:	83 ec 28             	sub    $0x28,%esp
801011f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801011f5:	68 c0 01 11 80       	push   $0x801101c0
801011fa:	e8 41 30 00 00       	call   80104240 <acquire>
801011ff:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101202:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101205:	eb 18                	jmp    8010121f <iget+0x3f>
80101207:	89 f6                	mov    %esi,%esi
80101209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101210:	85 f6                	test   %esi,%esi
80101212:	74 44                	je     80101258 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101214:	83 c3 50             	add    $0x50,%ebx
80101217:	81 fb 94 11 11 80    	cmp    $0x80111194,%ebx
8010121d:	74 51                	je     80101270 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010121f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101222:	85 c9                	test   %ecx,%ecx
80101224:	7e ea                	jle    80101210 <iget+0x30>
80101226:	39 3b                	cmp    %edi,(%ebx)
80101228:	75 e6                	jne    80101210 <iget+0x30>
8010122a:	39 53 04             	cmp    %edx,0x4(%ebx)
8010122d:	75 e1                	jne    80101210 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
8010122f:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101232:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101235:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
80101237:	68 c0 01 11 80       	push   $0x801101c0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010123c:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010123f:	e8 dc 31 00 00       	call   80104420 <release>
      return ip;
80101244:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
80101247:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010124a:	89 f0                	mov    %esi,%eax
8010124c:	5b                   	pop    %ebx
8010124d:	5e                   	pop    %esi
8010124e:	5f                   	pop    %edi
8010124f:	5d                   	pop    %ebp
80101250:	c3                   	ret    
80101251:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101258:	85 c9                	test   %ecx,%ecx
8010125a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010125d:	83 c3 50             	add    $0x50,%ebx
80101260:	81 fb 94 11 11 80    	cmp    $0x80111194,%ebx
80101266:	75 b7                	jne    8010121f <iget+0x3f>
80101268:	90                   	nop
80101269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101270:	85 f6                	test   %esi,%esi
80101272:	74 2d                	je     801012a1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
80101274:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101277:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101279:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010127c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
80101283:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  release(&icache.lock);
8010128a:	68 c0 01 11 80       	push   $0x801101c0
8010128f:	e8 8c 31 00 00       	call   80104420 <release>

  return ip;
80101294:	83 c4 10             	add    $0x10,%esp
}
80101297:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010129a:	89 f0                	mov    %esi,%eax
8010129c:	5b                   	pop    %ebx
8010129d:	5e                   	pop    %esi
8010129e:	5f                   	pop    %edi
8010129f:	5d                   	pop    %ebp
801012a0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012a1:	83 ec 0c             	sub    $0xc,%esp
801012a4:	68 6d 71 10 80       	push   $0x8010716d
801012a9:	e8 a2 f0 ff ff       	call   80100350 <panic>
801012ae:	66 90                	xchg   %ax,%ax

801012b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	57                   	push   %edi
801012b4:	56                   	push   %esi
801012b5:	53                   	push   %ebx
801012b6:	89 c6                	mov    %eax,%esi
801012b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012bb:	83 fa 0b             	cmp    $0xb,%edx
801012be:	77 18                	ja     801012d8 <bmap+0x28>
801012c0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012c3:	8b 43 1c             	mov    0x1c(%ebx),%eax
801012c6:	85 c0                	test   %eax,%eax
801012c8:	74 6e                	je     80101338 <bmap+0x88>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012cd:	5b                   	pop    %ebx
801012ce:	5e                   	pop    %esi
801012cf:	5f                   	pop    %edi
801012d0:	5d                   	pop    %ebp
801012d1:	c3                   	ret    
801012d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012d8:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801012db:	83 fb 7f             	cmp    $0x7f,%ebx
801012de:	77 7c                	ja     8010135c <bmap+0xac>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801012e0:	8b 40 4c             	mov    0x4c(%eax),%eax
801012e3:	85 c0                	test   %eax,%eax
801012e5:	74 69                	je     80101350 <bmap+0xa0>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801012e7:	83 ec 08             	sub    $0x8,%esp
801012ea:	50                   	push   %eax
801012eb:	ff 36                	pushl  (%esi)
801012ed:	e8 ce ed ff ff       	call   801000c0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801012f2:	8d 54 98 18          	lea    0x18(%eax,%ebx,4),%edx
801012f6:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801012f9:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801012fb:	8b 1a                	mov    (%edx),%ebx
801012fd:	85 db                	test   %ebx,%ebx
801012ff:	75 1d                	jne    8010131e <bmap+0x6e>
      a[bn] = addr = balloc(ip->dev);
80101301:	8b 06                	mov    (%esi),%eax
80101303:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101306:	e8 c5 fd ff ff       	call   801010d0 <balloc>
8010130b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010130e:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101311:	89 c3                	mov    %eax,%ebx
80101313:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101315:	57                   	push   %edi
80101316:	e8 75 1a 00 00       	call   80102d90 <log_write>
8010131b:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
8010131e:	83 ec 0c             	sub    $0xc,%esp
80101321:	57                   	push   %edi
80101322:	e8 a9 ee ff ff       	call   801001d0 <brelse>
80101327:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
8010132d:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101338:	8b 06                	mov    (%esi),%eax
8010133a:	e8 91 fd ff ff       	call   801010d0 <balloc>
8010133f:	89 43 1c             	mov    %eax,0x1c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
80101342:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101345:	5b                   	pop    %ebx
80101346:	5e                   	pop    %esi
80101347:	5f                   	pop    %edi
80101348:	5d                   	pop    %ebp
80101349:	c3                   	ret    
8010134a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101350:	8b 06                	mov    (%esi),%eax
80101352:	e8 79 fd ff ff       	call   801010d0 <balloc>
80101357:	89 46 4c             	mov    %eax,0x4c(%esi)
8010135a:	eb 8b                	jmp    801012e7 <bmap+0x37>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
8010135c:	83 ec 0c             	sub    $0xc,%esp
8010135f:	68 7d 71 10 80       	push   $0x8010717d
80101364:	e8 e7 ef ff ff       	call   80100350 <panic>
80101369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101370 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	56                   	push   %esi
80101374:	53                   	push   %ebx
80101375:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101378:	83 ec 08             	sub    $0x8,%esp
8010137b:	6a 01                	push   $0x1
8010137d:	ff 75 08             	pushl  0x8(%ebp)
80101380:	e8 3b ed ff ff       	call   801000c0 <bread>
80101385:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101387:	8d 40 18             	lea    0x18(%eax),%eax
8010138a:	83 c4 0c             	add    $0xc,%esp
8010138d:	6a 1c                	push   $0x1c
8010138f:	50                   	push   %eax
80101390:	56                   	push   %esi
80101391:	e8 8a 31 00 00       	call   80104520 <memmove>
  brelse(bp);
80101396:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101399:	83 c4 10             	add    $0x10,%esp
}
8010139c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010139f:	5b                   	pop    %ebx
801013a0:	5e                   	pop    %esi
801013a1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013a2:	e9 29 ee ff ff       	jmp    801001d0 <brelse>
801013a7:	89 f6                	mov    %esi,%esi
801013a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	56                   	push   %esi
801013b4:	53                   	push   %ebx
801013b5:	89 d3                	mov    %edx,%ebx
801013b7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013b9:	83 ec 08             	sub    $0x8,%esp
801013bc:	68 a0 01 11 80       	push   $0x801101a0
801013c1:	50                   	push   %eax
801013c2:	e8 a9 ff ff ff       	call   80101370 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013c7:	58                   	pop    %eax
801013c8:	5a                   	pop    %edx
801013c9:	89 da                	mov    %ebx,%edx
801013cb:	c1 ea 0c             	shr    $0xc,%edx
801013ce:	03 15 b8 01 11 80    	add    0x801101b8,%edx
801013d4:	52                   	push   %edx
801013d5:	56                   	push   %esi
801013d6:	e8 e5 ec ff ff       	call   801000c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801013db:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801013dd:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801013e3:	ba 01 00 00 00       	mov    $0x1,%edx
801013e8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801013eb:	c1 fb 03             	sar    $0x3,%ebx
801013ee:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801013f1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801013f3:	0f b6 4c 18 18       	movzbl 0x18(%eax,%ebx,1),%ecx
801013f8:	85 d1                	test   %edx,%ecx
801013fa:	74 27                	je     80101423 <bfree+0x73>
801013fc:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801013fe:	f7 d2                	not    %edx
80101400:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101402:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101405:	21 d0                	and    %edx,%eax
80101407:	88 44 1e 18          	mov    %al,0x18(%esi,%ebx,1)
  log_write(bp);
8010140b:	56                   	push   %esi
8010140c:	e8 7f 19 00 00       	call   80102d90 <log_write>
  brelse(bp);
80101411:	89 34 24             	mov    %esi,(%esp)
80101414:	e8 b7 ed ff ff       	call   801001d0 <brelse>
}
80101419:	83 c4 10             	add    $0x10,%esp
8010141c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010141f:	5b                   	pop    %ebx
80101420:	5e                   	pop    %esi
80101421:	5d                   	pop    %ebp
80101422:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101423:	83 ec 0c             	sub    $0xc,%esp
80101426:	68 90 71 10 80       	push   $0x80107190
8010142b:	e8 20 ef ff ff       	call   80100350 <panic>

80101430 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	83 ec 10             	sub    $0x10,%esp
  initlock(&icache.lock, "icache");
80101436:	68 a3 71 10 80       	push   $0x801071a3
8010143b:	68 c0 01 11 80       	push   $0x801101c0
80101440:	e8 db 2d 00 00       	call   80104220 <initlock>
  readsb(dev, &sb);
80101445:	58                   	pop    %eax
80101446:	5a                   	pop    %edx
80101447:	68 a0 01 11 80       	push   $0x801101a0
8010144c:	ff 75 08             	pushl  0x8(%ebp)
8010144f:	e8 1c ff ff ff       	call   80101370 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101454:	ff 35 b8 01 11 80    	pushl  0x801101b8
8010145a:	ff 35 b4 01 11 80    	pushl  0x801101b4
80101460:	ff 35 b0 01 11 80    	pushl  0x801101b0
80101466:	ff 35 ac 01 11 80    	pushl  0x801101ac
8010146c:	ff 35 a8 01 11 80    	pushl  0x801101a8
80101472:	ff 35 a4 01 11 80    	pushl  0x801101a4
80101478:	ff 35 a0 01 11 80    	pushl  0x801101a0
8010147e:	68 04 72 10 80       	push   $0x80107204
80101483:	e8 b8 f1 ff ff       	call   80100640 <cprintf>
          inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101488:	83 c4 30             	add    $0x30,%esp
8010148b:	c9                   	leave  
8010148c:	c3                   	ret    
8010148d:	8d 76 00             	lea    0x0(%esi),%esi

80101490 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	57                   	push   %edi
80101494:	56                   	push   %esi
80101495:	53                   	push   %ebx
80101496:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101499:	83 3d a8 01 11 80 01 	cmpl   $0x1,0x801101a8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801014a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801014a3:	8b 75 08             	mov    0x8(%ebp),%esi
801014a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014a9:	0f 86 91 00 00 00    	jbe    80101540 <ialloc+0xb0>
801014af:	bb 01 00 00 00       	mov    $0x1,%ebx
801014b4:	eb 21                	jmp    801014d7 <ialloc+0x47>
801014b6:	8d 76 00             	lea    0x0(%esi),%esi
801014b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801014c0:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014c3:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801014c6:	57                   	push   %edi
801014c7:	e8 04 ed ff ff       	call   801001d0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014cc:	83 c4 10             	add    $0x10,%esp
801014cf:	39 1d a8 01 11 80    	cmp    %ebx,0x801101a8
801014d5:	76 69                	jbe    80101540 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801014d7:	89 d8                	mov    %ebx,%eax
801014d9:	83 ec 08             	sub    $0x8,%esp
801014dc:	c1 e8 03             	shr    $0x3,%eax
801014df:	03 05 b4 01 11 80    	add    0x801101b4,%eax
801014e5:	50                   	push   %eax
801014e6:	56                   	push   %esi
801014e7:	e8 d4 eb ff ff       	call   801000c0 <bread>
801014ec:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801014ee:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
801014f0:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
801014f3:	83 e0 07             	and    $0x7,%eax
801014f6:	c1 e0 06             	shl    $0x6,%eax
801014f9:	8d 4c 07 18          	lea    0x18(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801014fd:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101501:	75 bd                	jne    801014c0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101503:	83 ec 04             	sub    $0x4,%esp
80101506:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101509:	6a 40                	push   $0x40
8010150b:	6a 00                	push   $0x0
8010150d:	51                   	push   %ecx
8010150e:	e8 5d 2f 00 00       	call   80104470 <memset>
      dip->type = type;
80101513:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101517:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010151a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010151d:	89 3c 24             	mov    %edi,(%esp)
80101520:	e8 6b 18 00 00       	call   80102d90 <log_write>
      brelse(bp);
80101525:	89 3c 24             	mov    %edi,(%esp)
80101528:	e8 a3 ec ff ff       	call   801001d0 <brelse>
      return iget(dev, inum);
8010152d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101530:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101533:	89 da                	mov    %ebx,%edx
80101535:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101537:	5b                   	pop    %ebx
80101538:	5e                   	pop    %esi
80101539:	5f                   	pop    %edi
8010153a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010153b:	e9 a0 fc ff ff       	jmp    801011e0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101540:	83 ec 0c             	sub    $0xc,%esp
80101543:	68 aa 71 10 80       	push   $0x801071aa
80101548:	e8 03 ee ff ff       	call   80100350 <panic>
8010154d:	8d 76 00             	lea    0x0(%esi),%esi

80101550 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	56                   	push   %esi
80101554:	53                   	push   %ebx
80101555:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101558:	83 ec 08             	sub    $0x8,%esp
8010155b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010155e:	83 c3 1c             	add    $0x1c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101561:	c1 e8 03             	shr    $0x3,%eax
80101564:	03 05 b4 01 11 80    	add    0x801101b4,%eax
8010156a:	50                   	push   %eax
8010156b:	ff 73 e4             	pushl  -0x1c(%ebx)
8010156e:	e8 4d eb ff ff       	call   801000c0 <bread>
80101573:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101575:	8b 43 e8             	mov    -0x18(%ebx),%eax
  dip->type = ip->type;
80101578:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010157c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010157f:	83 e0 07             	and    $0x7,%eax
80101582:	c1 e0 06             	shl    $0x6,%eax
80101585:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
  dip->type = ip->type;
80101589:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010158c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101590:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101593:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101597:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010159b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010159f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801015a3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801015a7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801015aa:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ad:	6a 34                	push   $0x34
801015af:	53                   	push   %ebx
801015b0:	50                   	push   %eax
801015b1:	e8 6a 2f 00 00       	call   80104520 <memmove>
  log_write(bp);
801015b6:	89 34 24             	mov    %esi,(%esp)
801015b9:	e8 d2 17 00 00       	call   80102d90 <log_write>
  brelse(bp);
801015be:	89 75 08             	mov    %esi,0x8(%ebp)
801015c1:	83 c4 10             	add    $0x10,%esp
}
801015c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801015ca:	e9 01 ec ff ff       	jmp    801001d0 <brelse>
801015cf:	90                   	nop

801015d0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	53                   	push   %ebx
801015d4:	83 ec 10             	sub    $0x10,%esp
801015d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801015da:	68 c0 01 11 80       	push   $0x801101c0
801015df:	e8 5c 2c 00 00       	call   80104240 <acquire>
  ip->ref++;
801015e4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801015e8:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
801015ef:	e8 2c 2e 00 00       	call   80104420 <release>
  return ip;
}
801015f4:	89 d8                	mov    %ebx,%eax
801015f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015f9:	c9                   	leave  
801015fa:	c3                   	ret    
801015fb:	90                   	nop
801015fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101600 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101608:	85 db                	test   %ebx,%ebx
8010160a:	0f 84 f0 00 00 00    	je     80101700 <ilock+0x100>
80101610:	8b 43 08             	mov    0x8(%ebx),%eax
80101613:	85 c0                	test   %eax,%eax
80101615:	0f 8e e5 00 00 00    	jle    80101700 <ilock+0x100>
    panic("ilock");

  acquire(&icache.lock);
8010161b:	83 ec 0c             	sub    $0xc,%esp
8010161e:	68 c0 01 11 80       	push   $0x801101c0
80101623:	e8 18 2c 00 00       	call   80104240 <acquire>
  while(ip->flags & I_BUSY)
80101628:	8b 43 0c             	mov    0xc(%ebx),%eax
8010162b:	83 c4 10             	add    $0x10,%esp
8010162e:	a8 01                	test   $0x1,%al
80101630:	74 1e                	je     80101650 <ilock+0x50>
80101632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sleep(ip, &icache.lock);
80101638:	83 ec 08             	sub    $0x8,%esp
8010163b:	68 c0 01 11 80       	push   $0x801101c0
80101640:	53                   	push   %ebx
80101641:	e8 ba 27 00 00       	call   80103e00 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101646:	8b 43 0c             	mov    0xc(%ebx),%eax
80101649:	83 c4 10             	add    $0x10,%esp
8010164c:	a8 01                	test   $0x1,%al
8010164e:	75 e8                	jne    80101638 <ilock+0x38>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);
80101650:	83 ec 0c             	sub    $0xc,%esp
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101653:	83 c8 01             	or     $0x1,%eax
80101656:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&icache.lock);
80101659:	68 c0 01 11 80       	push   $0x801101c0
8010165e:	e8 bd 2d 00 00       	call   80104420 <release>

  if(!(ip->flags & I_VALID)){
80101663:	83 c4 10             	add    $0x10,%esp
80101666:	f6 43 0c 02          	testb  $0x2,0xc(%ebx)
8010166a:	74 0c                	je     80101678 <ilock+0x78>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
8010166c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010166f:	5b                   	pop    %ebx
80101670:	5e                   	pop    %esi
80101671:	5d                   	pop    %ebp
80101672:	c3                   	ret    
80101673:	90                   	nop
80101674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101678:	8b 43 04             	mov    0x4(%ebx),%eax
8010167b:	83 ec 08             	sub    $0x8,%esp
8010167e:	c1 e8 03             	shr    $0x3,%eax
80101681:	03 05 b4 01 11 80    	add    0x801101b4,%eax
80101687:	50                   	push   %eax
80101688:	ff 33                	pushl  (%ebx)
8010168a:	e8 31 ea ff ff       	call   801000c0 <bread>
8010168f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101691:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101694:	83 c4 0c             	add    $0xc,%esp
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101697:	83 e0 07             	and    $0x7,%eax
8010169a:	c1 e0 06             	shl    $0x6,%eax
8010169d:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
    ip->type = dip->type;
801016a1:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016a4:	83 c0 0c             	add    $0xc,%eax
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016a7:	66 89 53 10          	mov    %dx,0x10(%ebx)
    ip->major = dip->major;
801016ab:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016af:	66 89 53 12          	mov    %dx,0x12(%ebx)
    ip->minor = dip->minor;
801016b3:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016b7:	66 89 53 14          	mov    %dx,0x14(%ebx)
    ip->nlink = dip->nlink;
801016bb:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016bf:	66 89 53 16          	mov    %dx,0x16(%ebx)
    ip->size = dip->size;
801016c3:	8b 50 fc             	mov    -0x4(%eax),%edx
801016c6:	89 53 18             	mov    %edx,0x18(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016c9:	6a 34                	push   $0x34
801016cb:	50                   	push   %eax
801016cc:	8d 43 1c             	lea    0x1c(%ebx),%eax
801016cf:	50                   	push   %eax
801016d0:	e8 4b 2e 00 00       	call   80104520 <memmove>
    brelse(bp);
801016d5:	89 34 24             	mov    %esi,(%esp)
801016d8:	e8 f3 ea ff ff       	call   801001d0 <brelse>
    ip->flags |= I_VALID;
801016dd:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
801016e1:	83 c4 10             	add    $0x10,%esp
801016e4:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
801016e9:	75 81                	jne    8010166c <ilock+0x6c>
      panic("ilock: no type");
801016eb:	83 ec 0c             	sub    $0xc,%esp
801016ee:	68 c2 71 10 80       	push   $0x801071c2
801016f3:	e8 58 ec ff ff       	call   80100350 <panic>
801016f8:	90                   	nop
801016f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101700:	83 ec 0c             	sub    $0xc,%esp
80101703:	68 bc 71 10 80       	push   $0x801071bc
80101708:	e8 43 ec ff ff       	call   80100350 <panic>
8010170d:	8d 76 00             	lea    0x0(%esi),%esi

80101710 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	53                   	push   %ebx
80101714:	83 ec 04             	sub    $0x4,%esp
80101717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
8010171a:	85 db                	test   %ebx,%ebx
8010171c:	74 39                	je     80101757 <iunlock+0x47>
8010171e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
80101722:	74 33                	je     80101757 <iunlock+0x47>
80101724:	8b 43 08             	mov    0x8(%ebx),%eax
80101727:	85 c0                	test   %eax,%eax
80101729:	7e 2c                	jle    80101757 <iunlock+0x47>
    panic("iunlock");

  acquire(&icache.lock);
8010172b:	83 ec 0c             	sub    $0xc,%esp
8010172e:	68 c0 01 11 80       	push   $0x801101c0
80101733:	e8 08 2b 00 00       	call   80104240 <acquire>
  ip->flags &= ~I_BUSY;
80101738:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
8010173c:	89 1c 24             	mov    %ebx,(%esp)
8010173f:	e8 5c 28 00 00       	call   80103fa0 <wakeup>
  release(&icache.lock);
80101744:	83 c4 10             	add    $0x10,%esp
80101747:	c7 45 08 c0 01 11 80 	movl   $0x801101c0,0x8(%ebp)
}
8010174e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101751:	c9                   	leave  
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
80101752:	e9 c9 2c 00 00       	jmp    80104420 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 d1 71 10 80       	push   $0x801071d1
8010175f:	e8 ec eb ff ff       	call   80100350 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	57                   	push   %edi
80101774:	56                   	push   %esi
80101775:	53                   	push   %ebx
80101776:	83 ec 28             	sub    $0x28,%esp
80101779:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
8010177c:	68 c0 01 11 80       	push   $0x801101c0
80101781:	e8 ba 2a 00 00       	call   80104240 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101786:	8b 46 08             	mov    0x8(%esi),%eax
80101789:	83 c4 10             	add    $0x10,%esp
8010178c:	83 f8 01             	cmp    $0x1,%eax
8010178f:	0f 85 ab 00 00 00    	jne    80101840 <iput+0xd0>
80101795:	8b 56 0c             	mov    0xc(%esi),%edx
80101798:	f6 c2 02             	test   $0x2,%dl
8010179b:	0f 84 9f 00 00 00    	je     80101840 <iput+0xd0>
801017a1:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
801017a6:	0f 85 94 00 00 00    	jne    80101840 <iput+0xd0>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
801017ac:	f6 c2 01             	test   $0x1,%dl
801017af:	0f 85 05 01 00 00    	jne    801018ba <iput+0x14a>
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
801017b5:	83 ec 0c             	sub    $0xc,%esp
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
801017b8:	83 ca 01             	or     $0x1,%edx
801017bb:	8d 5e 1c             	lea    0x1c(%esi),%ebx
801017be:	89 56 0c             	mov    %edx,0xc(%esi)
    release(&icache.lock);
801017c1:	68 c0 01 11 80       	push   $0x801101c0
801017c6:	8d 7e 4c             	lea    0x4c(%esi),%edi
801017c9:	e8 52 2c 00 00       	call   80104420 <release>
801017ce:	83 c4 10             	add    $0x10,%esp
801017d1:	eb 0c                	jmp    801017df <iput+0x6f>
801017d3:	90                   	nop
801017d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017d8:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801017db:	39 fb                	cmp    %edi,%ebx
801017dd:	74 1b                	je     801017fa <iput+0x8a>
    if(ip->addrs[i]){
801017df:	8b 13                	mov    (%ebx),%edx
801017e1:	85 d2                	test   %edx,%edx
801017e3:	74 f3                	je     801017d8 <iput+0x68>
      bfree(ip->dev, ip->addrs[i]);
801017e5:	8b 06                	mov    (%esi),%eax
801017e7:	83 c3 04             	add    $0x4,%ebx
801017ea:	e8 c1 fb ff ff       	call   801013b0 <bfree>
      ip->addrs[i] = 0;
801017ef:	c7 43 fc 00 00 00 00 	movl   $0x0,-0x4(%ebx)
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801017f6:	39 fb                	cmp    %edi,%ebx
801017f8:	75 e5                	jne    801017df <iput+0x6f>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
801017fa:	8b 46 4c             	mov    0x4c(%esi),%eax
801017fd:	85 c0                	test   %eax,%eax
801017ff:	75 5f                	jne    80101860 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101801:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101804:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  iupdate(ip);
8010180b:	56                   	push   %esi
8010180c:	e8 3f fd ff ff       	call   80101550 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
80101811:	31 c0                	xor    %eax,%eax
80101813:	66 89 46 10          	mov    %ax,0x10(%esi)
    iupdate(ip);
80101817:	89 34 24             	mov    %esi,(%esp)
8010181a:	e8 31 fd ff ff       	call   80101550 <iupdate>
    acquire(&icache.lock);
8010181f:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
80101826:	e8 15 2a 00 00       	call   80104240 <acquire>
    ip->flags = 0;
8010182b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    wakeup(ip);
80101832:	89 34 24             	mov    %esi,(%esp)
80101835:	e8 66 27 00 00       	call   80103fa0 <wakeup>
8010183a:	8b 46 08             	mov    0x8(%esi),%eax
8010183d:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101840:	83 e8 01             	sub    $0x1,%eax
80101843:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
80101846:	c7 45 08 c0 01 11 80 	movl   $0x801101c0,0x8(%ebp)
}
8010184d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101850:	5b                   	pop    %ebx
80101851:	5e                   	pop    %esi
80101852:	5f                   	pop    %edi
80101853:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags = 0;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
80101854:	e9 c7 2b 00 00       	jmp    80104420 <release>
80101859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101860:	83 ec 08             	sub    $0x8,%esp
80101863:	50                   	push   %eax
80101864:	ff 36                	pushl  (%esi)
80101866:	e8 55 e8 ff ff       	call   801000c0 <bread>
8010186b:	83 c4 10             	add    $0x10,%esp
8010186e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101871:	8d 58 18             	lea    0x18(%eax),%ebx
80101874:	8d b8 18 02 00 00    	lea    0x218(%eax),%edi
8010187a:	eb 0b                	jmp    80101887 <iput+0x117>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101880:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101883:	39 df                	cmp    %ebx,%edi
80101885:	74 0f                	je     80101896 <iput+0x126>
      if(a[j])
80101887:	8b 13                	mov    (%ebx),%edx
80101889:	85 d2                	test   %edx,%edx
8010188b:	74 f3                	je     80101880 <iput+0x110>
        bfree(ip->dev, a[j]);
8010188d:	8b 06                	mov    (%esi),%eax
8010188f:	e8 1c fb ff ff       	call   801013b0 <bfree>
80101894:	eb ea                	jmp    80101880 <iput+0x110>
    }
    brelse(bp);
80101896:	83 ec 0c             	sub    $0xc,%esp
80101899:	ff 75 e4             	pushl  -0x1c(%ebp)
8010189c:	e8 2f e9 ff ff       	call   801001d0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018a1:	8b 56 4c             	mov    0x4c(%esi),%edx
801018a4:	8b 06                	mov    (%esi),%eax
801018a6:	e8 05 fb ff ff       	call   801013b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018ab:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018b2:	83 c4 10             	add    $0x10,%esp
801018b5:	e9 47 ff ff ff       	jmp    80101801 <iput+0x91>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
      panic("iput busy");
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	68 d9 71 10 80       	push   $0x801071d9
801018c2:	e8 89 ea ff ff       	call   80100350 <panic>
801018c7:	89 f6                	mov    %esi,%esi
801018c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801018d0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	53                   	push   %ebx
801018d4:	83 ec 10             	sub    $0x10,%esp
801018d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018da:	53                   	push   %ebx
801018db:	e8 30 fe ff ff       	call   80101710 <iunlock>
  iput(ip);
801018e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018e3:	83 c4 10             	add    $0x10,%esp
}
801018e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018e9:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
801018ea:	e9 81 fe ff ff       	jmp    80101770 <iput>
801018ef:	90                   	nop

801018f0 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	8b 55 08             	mov    0x8(%ebp),%edx
801018f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801018f9:	8b 0a                	mov    (%edx),%ecx
801018fb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801018fe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101901:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101904:	0f b7 4a 10          	movzwl 0x10(%edx),%ecx
80101908:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010190b:	0f b7 4a 16          	movzwl 0x16(%edx),%ecx
8010190f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101913:	8b 52 18             	mov    0x18(%edx),%edx
80101916:	89 50 10             	mov    %edx,0x10(%eax)
}
80101919:	5d                   	pop    %ebp
8010191a:	c3                   	ret    
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	56                   	push   %esi
80101925:	53                   	push   %ebx
80101926:	83 ec 1c             	sub    $0x1c,%esp
80101929:	8b 45 08             	mov    0x8(%ebp),%eax
8010192c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010192f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101932:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101937:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010193a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010193d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101940:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101943:	0f 84 a7 00 00 00    	je     801019f0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101949:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010194c:	8b 40 18             	mov    0x18(%eax),%eax
8010194f:	39 f0                	cmp    %esi,%eax
80101951:	0f 82 c1 00 00 00    	jb     80101a18 <readi+0xf8>
80101957:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010195a:	89 fa                	mov    %edi,%edx
8010195c:	01 f2                	add    %esi,%edx
8010195e:	0f 82 b4 00 00 00    	jb     80101a18 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101964:	89 c1                	mov    %eax,%ecx
80101966:	29 f1                	sub    %esi,%ecx
80101968:	39 d0                	cmp    %edx,%eax
8010196a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010196d:	31 ff                	xor    %edi,%edi
8010196f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101971:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101974:	74 6d                	je     801019e3 <readi+0xc3>
80101976:	8d 76 00             	lea    0x0(%esi),%esi
80101979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101980:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101983:	89 f2                	mov    %esi,%edx
80101985:	c1 ea 09             	shr    $0x9,%edx
80101988:	89 d8                	mov    %ebx,%eax
8010198a:	e8 21 f9 ff ff       	call   801012b0 <bmap>
8010198f:	83 ec 08             	sub    $0x8,%esp
80101992:	50                   	push   %eax
80101993:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101995:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010199a:	e8 21 e7 ff ff       	call   801000c0 <bread>
8010199f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019a4:	89 f1                	mov    %esi,%ecx
801019a6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019ac:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801019af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019b2:	29 cb                	sub    %ecx,%ebx
801019b4:	29 f8                	sub    %edi,%eax
801019b6:	39 c3                	cmp    %eax,%ebx
801019b8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019bb:	8d 44 0a 18          	lea    0x18(%edx,%ecx,1),%eax
801019bf:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c0:	01 df                	add    %ebx,%edi
801019c2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019c4:	50                   	push   %eax
801019c5:	ff 75 e0             	pushl  -0x20(%ebp)
801019c8:	e8 53 2b 00 00       	call   80104520 <memmove>
    brelse(bp);
801019cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019d0:	89 14 24             	mov    %edx,(%esp)
801019d3:	e8 f8 e7 ff ff       	call   801001d0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019db:	83 c4 10             	add    $0x10,%esp
801019de:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019e1:	77 9d                	ja     80101980 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801019e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019e9:	5b                   	pop    %ebx
801019ea:	5e                   	pop    %esi
801019eb:	5f                   	pop    %edi
801019ec:	5d                   	pop    %ebp
801019ed:	c3                   	ret    
801019ee:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801019f0:	0f bf 40 12          	movswl 0x12(%eax),%eax
801019f4:	66 83 f8 09          	cmp    $0x9,%ax
801019f8:	77 1e                	ja     80101a18 <readi+0xf8>
801019fa:	8b 04 c5 40 01 11 80 	mov    -0x7feefec0(,%eax,8),%eax
80101a01:	85 c0                	test   %eax,%eax
80101a03:	74 13                	je     80101a18 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a05:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a0b:	5b                   	pop    %ebx
80101a0c:	5e                   	pop    %esi
80101a0d:	5f                   	pop    %edi
80101a0e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a0f:	ff e0                	jmp    *%eax
80101a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a1d:	eb c7                	jmp    801019e6 <readi+0xc6>
80101a1f:	90                   	nop

80101a20 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	57                   	push   %edi
80101a24:	56                   	push   %esi
80101a25:	53                   	push   %ebx
80101a26:	83 ec 1c             	sub    $0x1c,%esp
80101a29:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a32:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a37:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a40:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a43:	0f 84 b7 00 00 00    	je     80101b00 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a4c:	39 70 18             	cmp    %esi,0x18(%eax)
80101a4f:	0f 82 eb 00 00 00    	jb     80101b40 <writei+0x120>
80101a55:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a58:	89 f8                	mov    %edi,%eax
80101a5a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a5c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a61:	0f 87 d9 00 00 00    	ja     80101b40 <writei+0x120>
80101a67:	39 c6                	cmp    %eax,%esi
80101a69:	0f 87 d1 00 00 00    	ja     80101b40 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a6f:	85 ff                	test   %edi,%edi
80101a71:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a78:	74 78                	je     80101af2 <writei+0xd2>
80101a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a80:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a83:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a85:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a8a:	c1 ea 09             	shr    $0x9,%edx
80101a8d:	89 f8                	mov    %edi,%eax
80101a8f:	e8 1c f8 ff ff       	call   801012b0 <bmap>
80101a94:	83 ec 08             	sub    $0x8,%esp
80101a97:	50                   	push   %eax
80101a98:	ff 37                	pushl  (%edi)
80101a9a:	e8 21 e6 ff ff       	call   801000c0 <bread>
80101a9f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101aa4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101aa7:	89 f1                	mov    %esi,%ecx
80101aa9:	83 c4 0c             	add    $0xc,%esp
80101aac:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ab2:	29 cb                	sub    %ecx,%ebx
80101ab4:	39 c3                	cmp    %eax,%ebx
80101ab6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ab9:	8d 44 0f 18          	lea    0x18(%edi,%ecx,1),%eax
80101abd:	53                   	push   %ebx
80101abe:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ac3:	50                   	push   %eax
80101ac4:	e8 57 2a 00 00       	call   80104520 <memmove>
    log_write(bp);
80101ac9:	89 3c 24             	mov    %edi,(%esp)
80101acc:	e8 bf 12 00 00       	call   80102d90 <log_write>
    brelse(bp);
80101ad1:	89 3c 24             	mov    %edi,(%esp)
80101ad4:	e8 f7 e6 ff ff       	call   801001d0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ad9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101adc:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101adf:	83 c4 10             	add    $0x10,%esp
80101ae2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ae5:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101ae8:	77 96                	ja     80101a80 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101aea:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aed:	3b 70 18             	cmp    0x18(%eax),%esi
80101af0:	77 36                	ja     80101b28 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101af2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101af5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101af8:	5b                   	pop    %ebx
80101af9:	5e                   	pop    %esi
80101afa:	5f                   	pop    %edi
80101afb:	5d                   	pop    %ebp
80101afc:	c3                   	ret    
80101afd:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b00:	0f bf 40 12          	movswl 0x12(%eax),%eax
80101b04:	66 83 f8 09          	cmp    $0x9,%ax
80101b08:	77 36                	ja     80101b40 <writei+0x120>
80101b0a:	8b 04 c5 44 01 11 80 	mov    -0x7feefebc(,%eax,8),%eax
80101b11:	85 c0                	test   %eax,%eax
80101b13:	74 2b                	je     80101b40 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b15:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b1b:	5b                   	pop    %ebx
80101b1c:	5e                   	pop    %esi
80101b1d:	5f                   	pop    %edi
80101b1e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b1f:	ff e0                	jmp    *%eax
80101b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b28:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b2b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b2e:	89 70 18             	mov    %esi,0x18(%eax)
    iupdate(ip);
80101b31:	50                   	push   %eax
80101b32:	e8 19 fa ff ff       	call   80101550 <iupdate>
80101b37:	83 c4 10             	add    $0x10,%esp
80101b3a:	eb b6                	jmp    80101af2 <writei+0xd2>
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b45:	eb ae                	jmp    80101af5 <writei+0xd5>
80101b47:	89 f6                	mov    %esi,%esi
80101b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b50 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b56:	6a 0e                	push   $0xe
80101b58:	ff 75 0c             	pushl  0xc(%ebp)
80101b5b:	ff 75 08             	pushl  0x8(%ebp)
80101b5e:	e8 3d 2a 00 00       	call   801045a0 <strncmp>
}
80101b63:	c9                   	leave  
80101b64:	c3                   	ret    
80101b65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b70 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	57                   	push   %edi
80101b74:	56                   	push   %esi
80101b75:	53                   	push   %ebx
80101b76:	83 ec 1c             	sub    $0x1c,%esp
80101b79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b7c:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80101b81:	0f 85 80 00 00 00    	jne    80101c07 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101b87:	8b 53 18             	mov    0x18(%ebx),%edx
80101b8a:	31 ff                	xor    %edi,%edi
80101b8c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101b8f:	85 d2                	test   %edx,%edx
80101b91:	75 0d                	jne    80101ba0 <dirlookup+0x30>
80101b93:	eb 5b                	jmp    80101bf0 <dirlookup+0x80>
80101b95:	8d 76 00             	lea    0x0(%esi),%esi
80101b98:	83 c7 10             	add    $0x10,%edi
80101b9b:	39 7b 18             	cmp    %edi,0x18(%ebx)
80101b9e:	76 50                	jbe    80101bf0 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ba0:	6a 10                	push   $0x10
80101ba2:	57                   	push   %edi
80101ba3:	56                   	push   %esi
80101ba4:	53                   	push   %ebx
80101ba5:	e8 76 fd ff ff       	call   80101920 <readi>
80101baa:	83 c4 10             	add    $0x10,%esp
80101bad:	83 f8 10             	cmp    $0x10,%eax
80101bb0:	75 48                	jne    80101bfa <dirlookup+0x8a>
      panic("dirlink read");
    if(de.inum == 0)
80101bb2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bb7:	74 df                	je     80101b98 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101bb9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bbc:	83 ec 04             	sub    $0x4,%esp
80101bbf:	6a 0e                	push   $0xe
80101bc1:	50                   	push   %eax
80101bc2:	ff 75 0c             	pushl  0xc(%ebp)
80101bc5:	e8 d6 29 00 00       	call   801045a0 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bca:	83 c4 10             	add    $0x10,%esp
80101bcd:	85 c0                	test   %eax,%eax
80101bcf:	75 c7                	jne    80101b98 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101bd1:	8b 45 10             	mov    0x10(%ebp),%eax
80101bd4:	85 c0                	test   %eax,%eax
80101bd6:	74 05                	je     80101bdd <dirlookup+0x6d>
        *poff = off;
80101bd8:	8b 45 10             	mov    0x10(%ebp),%eax
80101bdb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101bdd:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101be1:	8b 03                	mov    (%ebx),%eax
80101be3:	e8 f8 f5 ff ff       	call   801011e0 <iget>
    }
  }

  return 0;
}
80101be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101beb:	5b                   	pop    %ebx
80101bec:	5e                   	pop    %esi
80101bed:	5f                   	pop    %edi
80101bee:	5d                   	pop    %ebp
80101bef:	c3                   	ret    
80101bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101bf3:	31 c0                	xor    %eax,%eax
}
80101bf5:	5b                   	pop    %ebx
80101bf6:	5e                   	pop    %esi
80101bf7:	5f                   	pop    %edi
80101bf8:	5d                   	pop    %ebp
80101bf9:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101bfa:	83 ec 0c             	sub    $0xc,%esp
80101bfd:	68 f5 71 10 80       	push   $0x801071f5
80101c02:	e8 49 e7 ff ff       	call   80100350 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c07:	83 ec 0c             	sub    $0xc,%esp
80101c0a:	68 e3 71 10 80       	push   $0x801071e3
80101c0f:	e8 3c e7 ff ff       	call   80100350 <panic>
80101c14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c20 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	57                   	push   %edi
80101c24:	56                   	push   %esi
80101c25:	53                   	push   %ebx
80101c26:	89 cf                	mov    %ecx,%edi
80101c28:	89 c3                	mov    %eax,%ebx
80101c2a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c2d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c30:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c33:	0f 84 53 01 00 00    	je     80101d8c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c3f:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101c42:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c45:	68 c0 01 11 80       	push   $0x801101c0
80101c4a:	e8 f1 25 00 00       	call   80104240 <acquire>
  ip->ref++;
80101c4f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c53:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
80101c5a:	e8 c1 27 00 00       	call   80104420 <release>
80101c5f:	83 c4 10             	add    $0x10,%esp
80101c62:	eb 07                	jmp    80101c6b <namex+0x4b>
80101c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c68:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c6b:	0f b6 03             	movzbl (%ebx),%eax
80101c6e:	3c 2f                	cmp    $0x2f,%al
80101c70:	74 f6                	je     80101c68 <namex+0x48>
    path++;
  if(*path == 0)
80101c72:	84 c0                	test   %al,%al
80101c74:	0f 84 e3 00 00 00    	je     80101d5d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c7a:	0f b6 03             	movzbl (%ebx),%eax
80101c7d:	89 da                	mov    %ebx,%edx
80101c7f:	84 c0                	test   %al,%al
80101c81:	0f 84 ac 00 00 00    	je     80101d33 <namex+0x113>
80101c87:	3c 2f                	cmp    $0x2f,%al
80101c89:	75 09                	jne    80101c94 <namex+0x74>
80101c8b:	e9 a3 00 00 00       	jmp    80101d33 <namex+0x113>
80101c90:	84 c0                	test   %al,%al
80101c92:	74 0a                	je     80101c9e <namex+0x7e>
    path++;
80101c94:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c97:	0f b6 02             	movzbl (%edx),%eax
80101c9a:	3c 2f                	cmp    $0x2f,%al
80101c9c:	75 f2                	jne    80101c90 <namex+0x70>
80101c9e:	89 d1                	mov    %edx,%ecx
80101ca0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101ca2:	83 f9 0d             	cmp    $0xd,%ecx
80101ca5:	0f 8e 8d 00 00 00    	jle    80101d38 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cab:	83 ec 04             	sub    $0x4,%esp
80101cae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cb1:	6a 0e                	push   $0xe
80101cb3:	53                   	push   %ebx
80101cb4:	57                   	push   %edi
80101cb5:	e8 66 28 00 00       	call   80104520 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101cbd:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cc0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cc2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cc5:	75 11                	jne    80101cd8 <namex+0xb8>
80101cc7:	89 f6                	mov    %esi,%esi
80101cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101cd0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cd3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101cd6:	74 f8                	je     80101cd0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101cd8:	83 ec 0c             	sub    $0xc,%esp
80101cdb:	56                   	push   %esi
80101cdc:	e8 1f f9 ff ff       	call   80101600 <ilock>
    if(ip->type != T_DIR){
80101ce1:	83 c4 10             	add    $0x10,%esp
80101ce4:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
80101ce9:	0f 85 7f 00 00 00    	jne    80101d6e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101cef:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101cf2:	85 d2                	test   %edx,%edx
80101cf4:	74 09                	je     80101cff <namex+0xdf>
80101cf6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101cf9:	0f 84 a3 00 00 00    	je     80101da2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101cff:	83 ec 04             	sub    $0x4,%esp
80101d02:	6a 00                	push   $0x0
80101d04:	57                   	push   %edi
80101d05:	56                   	push   %esi
80101d06:	e8 65 fe ff ff       	call   80101b70 <dirlookup>
80101d0b:	83 c4 10             	add    $0x10,%esp
80101d0e:	85 c0                	test   %eax,%eax
80101d10:	74 5c                	je     80101d6e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d12:	83 ec 0c             	sub    $0xc,%esp
80101d15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d18:	56                   	push   %esi
80101d19:	e8 f2 f9 ff ff       	call   80101710 <iunlock>
  iput(ip);
80101d1e:	89 34 24             	mov    %esi,(%esp)
80101d21:	e8 4a fa ff ff       	call   80101770 <iput>
80101d26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d29:	83 c4 10             	add    $0x10,%esp
80101d2c:	89 c6                	mov    %eax,%esi
80101d2e:	e9 38 ff ff ff       	jmp    80101c6b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d33:	31 c9                	xor    %ecx,%ecx
80101d35:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d38:	83 ec 04             	sub    $0x4,%esp
80101d3b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d3e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d41:	51                   	push   %ecx
80101d42:	53                   	push   %ebx
80101d43:	57                   	push   %edi
80101d44:	e8 d7 27 00 00       	call   80104520 <memmove>
    name[len] = 0;
80101d49:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d4f:	83 c4 10             	add    $0x10,%esp
80101d52:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d56:	89 d3                	mov    %edx,%ebx
80101d58:	e9 65 ff ff ff       	jmp    80101cc2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d60:	85 c0                	test   %eax,%eax
80101d62:	75 54                	jne    80101db8 <namex+0x198>
80101d64:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d69:	5b                   	pop    %ebx
80101d6a:	5e                   	pop    %esi
80101d6b:	5f                   	pop    %edi
80101d6c:	5d                   	pop    %ebp
80101d6d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d6e:	83 ec 0c             	sub    $0xc,%esp
80101d71:	56                   	push   %esi
80101d72:	e8 99 f9 ff ff       	call   80101710 <iunlock>
  iput(ip);
80101d77:	89 34 24             	mov    %esi,(%esp)
80101d7a:	e8 f1 f9 ff ff       	call   80101770 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d7f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d82:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d85:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d87:	5b                   	pop    %ebx
80101d88:	5e                   	pop    %esi
80101d89:	5f                   	pop    %edi
80101d8a:	5d                   	pop    %ebp
80101d8b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101d8c:	ba 01 00 00 00       	mov    $0x1,%edx
80101d91:	b8 01 00 00 00       	mov    $0x1,%eax
80101d96:	e8 45 f4 ff ff       	call   801011e0 <iget>
80101d9b:	89 c6                	mov    %eax,%esi
80101d9d:	e9 c9 fe ff ff       	jmp    80101c6b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101da2:	83 ec 0c             	sub    $0xc,%esp
80101da5:	56                   	push   %esi
80101da6:	e8 65 f9 ff ff       	call   80101710 <iunlock>
      return ip;
80101dab:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101db1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101db3:	5b                   	pop    %ebx
80101db4:	5e                   	pop    %esi
80101db5:	5f                   	pop    %edi
80101db6:	5d                   	pop    %ebp
80101db7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101db8:	83 ec 0c             	sub    $0xc,%esp
80101dbb:	56                   	push   %esi
80101dbc:	e8 af f9 ff ff       	call   80101770 <iput>
    return 0;
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	31 c0                	xor    %eax,%eax
80101dc6:	eb 9e                	jmp    80101d66 <namex+0x146>
80101dc8:	90                   	nop
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101dd0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	57                   	push   %edi
80101dd4:	56                   	push   %esi
80101dd5:	53                   	push   %ebx
80101dd6:	83 ec 20             	sub    $0x20,%esp
80101dd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ddc:	6a 00                	push   $0x0
80101dde:	ff 75 0c             	pushl  0xc(%ebp)
80101de1:	53                   	push   %ebx
80101de2:	e8 89 fd ff ff       	call   80101b70 <dirlookup>
80101de7:	83 c4 10             	add    $0x10,%esp
80101dea:	85 c0                	test   %eax,%eax
80101dec:	75 67                	jne    80101e55 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101dee:	8b 7b 18             	mov    0x18(%ebx),%edi
80101df1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101df4:	85 ff                	test   %edi,%edi
80101df6:	74 29                	je     80101e21 <dirlink+0x51>
80101df8:	31 ff                	xor    %edi,%edi
80101dfa:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101dfd:	eb 09                	jmp    80101e08 <dirlink+0x38>
80101dff:	90                   	nop
80101e00:	83 c7 10             	add    $0x10,%edi
80101e03:	39 7b 18             	cmp    %edi,0x18(%ebx)
80101e06:	76 19                	jbe    80101e21 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e08:	6a 10                	push   $0x10
80101e0a:	57                   	push   %edi
80101e0b:	56                   	push   %esi
80101e0c:	53                   	push   %ebx
80101e0d:	e8 0e fb ff ff       	call   80101920 <readi>
80101e12:	83 c4 10             	add    $0x10,%esp
80101e15:	83 f8 10             	cmp    $0x10,%eax
80101e18:	75 4e                	jne    80101e68 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e1f:	75 df                	jne    80101e00 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e21:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e24:	83 ec 04             	sub    $0x4,%esp
80101e27:	6a 0e                	push   $0xe
80101e29:	ff 75 0c             	pushl  0xc(%ebp)
80101e2c:	50                   	push   %eax
80101e2d:	e8 de 27 00 00       	call   80104610 <strncpy>
  de.inum = inum;
80101e32:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e35:	6a 10                	push   $0x10
80101e37:	57                   	push   %edi
80101e38:	56                   	push   %esi
80101e39:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e3a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e3e:	e8 dd fb ff ff       	call   80101a20 <writei>
80101e43:	83 c4 20             	add    $0x20,%esp
80101e46:	83 f8 10             	cmp    $0x10,%eax
80101e49:	75 2a                	jne    80101e75 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e4b:	31 c0                	xor    %eax,%eax
}
80101e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e50:	5b                   	pop    %ebx
80101e51:	5e                   	pop    %esi
80101e52:	5f                   	pop    %edi
80101e53:	5d                   	pop    %ebp
80101e54:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e55:	83 ec 0c             	sub    $0xc,%esp
80101e58:	50                   	push   %eax
80101e59:	e8 12 f9 ff ff       	call   80101770 <iput>
    return -1;
80101e5e:	83 c4 10             	add    $0x10,%esp
80101e61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e66:	eb e5                	jmp    80101e4d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e68:	83 ec 0c             	sub    $0xc,%esp
80101e6b:	68 f5 71 10 80       	push   $0x801071f5
80101e70:	e8 db e4 ff ff       	call   80100350 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101e75:	83 ec 0c             	sub    $0xc,%esp
80101e78:	68 ee 77 10 80       	push   $0x801077ee
80101e7d:	e8 ce e4 ff ff       	call   80100350 <panic>
80101e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e90 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101e90:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e91:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101e93:	89 e5                	mov    %esp,%ebp
80101e95:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e98:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101e9e:	e8 7d fd ff ff       	call   80101c20 <namex>
}
80101ea3:	c9                   	leave  
80101ea4:	c3                   	ret    
80101ea5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101eb0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101eb0:	55                   	push   %ebp
  return namex(path, 1, name);
80101eb1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101eb6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101eb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101ebb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ebe:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101ebf:	e9 5c fd ff ff       	jmp    80101c20 <namex>
80101ec4:	66 90                	xchg   %ax,%ax
80101ec6:	66 90                	xchg   %ax,%ax
80101ec8:	66 90                	xchg   %ax,%ax
80101eca:	66 90                	xchg   %ax,%ax
80101ecc:	66 90                	xchg   %ax,%ax
80101ece:	66 90                	xchg   %ax,%ax

80101ed0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ed0:	55                   	push   %ebp
  if(b == 0)
80101ed1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ed3:	89 e5                	mov    %esp,%ebp
80101ed5:	56                   	push   %esi
80101ed6:	53                   	push   %ebx
  if(b == 0)
80101ed7:	0f 84 ad 00 00 00    	je     80101f8a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101edd:	8b 58 08             	mov    0x8(%eax),%ebx
80101ee0:	89 c1                	mov    %eax,%ecx
80101ee2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101ee8:	0f 87 8f 00 00 00    	ja     80101f7d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101eee:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ef3:	90                   	nop
80101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ef9:	83 e0 c0             	and    $0xffffffc0,%eax
80101efc:	3c 40                	cmp    $0x40,%al
80101efe:	75 f8                	jne    80101ef8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f00:	31 f6                	xor    %esi,%esi
80101f02:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f07:	89 f0                	mov    %esi,%eax
80101f09:	ee                   	out    %al,(%dx)
80101f0a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f0f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f14:	ee                   	out    %al,(%dx)
80101f15:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f1a:	89 d8                	mov    %ebx,%eax
80101f1c:	ee                   	out    %al,(%dx)
80101f1d:	89 d8                	mov    %ebx,%eax
80101f1f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f24:	c1 f8 08             	sar    $0x8,%eax
80101f27:	ee                   	out    %al,(%dx)
80101f28:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f2d:	89 f0                	mov    %esi,%eax
80101f2f:	ee                   	out    %al,(%dx)
80101f30:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f34:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f39:	83 e0 01             	and    $0x1,%eax
80101f3c:	c1 e0 04             	shl    $0x4,%eax
80101f3f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f42:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f43:	f6 01 04             	testb  $0x4,(%ecx)
80101f46:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f4b:	75 13                	jne    80101f60 <idestart+0x90>
80101f4d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f52:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f53:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f56:	5b                   	pop    %ebx
80101f57:	5e                   	pop    %esi
80101f58:	5d                   	pop    %ebp
80101f59:	c3                   	ret    
80101f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f60:	b8 30 00 00 00       	mov    $0x30,%eax
80101f65:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f66:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f6b:	8d 71 18             	lea    0x18(%ecx),%esi
80101f6e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f73:	fc                   	cld    
80101f74:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f79:	5b                   	pop    %ebx
80101f7a:	5e                   	pop    %esi
80101f7b:	5d                   	pop    %ebp
80101f7c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101f7d:	83 ec 0c             	sub    $0xc,%esp
80101f80:	68 69 72 10 80       	push   $0x80107269
80101f85:	e8 c6 e3 ff ff       	call   80100350 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101f8a:	83 ec 0c             	sub    $0xc,%esp
80101f8d:	68 60 72 10 80       	push   $0x80107260
80101f92:	e8 b9 e3 ff ff       	call   80100350 <panic>
80101f97:	89 f6                	mov    %esi,%esi
80101f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fa0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fa0:	55                   	push   %ebp
80101fa1:	89 e5                	mov    %esp,%ebp
80101fa3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101fa6:	68 7b 72 10 80       	push   $0x8010727b
80101fab:	68 80 a5 10 80       	push   $0x8010a580
80101fb0:	e8 6b 22 00 00       	call   80104220 <initlock>
  picenable(IRQ_IDE);
80101fb5:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80101fbc:	e8 cf 12 00 00       	call   80103290 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fc1:	58                   	pop    %eax
80101fc2:	a1 20 19 11 80       	mov    0x80111920,%eax
80101fc7:	5a                   	pop    %edx
80101fc8:	83 e8 01             	sub    $0x1,%eax
80101fcb:	50                   	push   %eax
80101fcc:	6a 0e                	push   $0xe
80101fce:	e8 ad 02 00 00       	call   80102280 <ioapicenable>
80101fd3:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fd6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fdb:	90                   	nop
80101fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fe0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fe1:	83 e0 c0             	and    $0xffffffc0,%eax
80101fe4:	3c 40                	cmp    $0x40,%al
80101fe6:	75 f8                	jne    80101fe0 <ideinit+0x40>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fe8:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fed:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101ff2:	ee                   	out    %al,(%dx)
80101ff3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ff8:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ffd:	eb 06                	jmp    80102005 <ideinit+0x65>
80101fff:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102000:	83 e9 01             	sub    $0x1,%ecx
80102003:	74 0f                	je     80102014 <ideinit+0x74>
80102005:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102006:	84 c0                	test   %al,%al
80102008:	74 f6                	je     80102000 <ideinit+0x60>
      havedisk1 = 1;
8010200a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102011:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102014:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102019:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010201e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010201f:	c9                   	leave  
80102020:	c3                   	ret    
80102021:	eb 0d                	jmp    80102030 <ideintr>
80102023:	90                   	nop
80102024:	90                   	nop
80102025:	90                   	nop
80102026:	90                   	nop
80102027:	90                   	nop
80102028:	90                   	nop
80102029:	90                   	nop
8010202a:	90                   	nop
8010202b:	90                   	nop
8010202c:	90                   	nop
8010202d:	90                   	nop
8010202e:	90                   	nop
8010202f:	90                   	nop

80102030 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	57                   	push   %edi
80102034:	56                   	push   %esi
80102035:	53                   	push   %ebx
80102036:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102039:	68 80 a5 10 80       	push   $0x8010a580
8010203e:	e8 fd 21 00 00       	call   80104240 <acquire>
  if((b = idequeue) == 0){
80102043:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102049:	83 c4 10             	add    $0x10,%esp
8010204c:	85 db                	test   %ebx,%ebx
8010204e:	74 34                	je     80102084 <ideintr+0x54>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
80102050:	8b 43 14             	mov    0x14(%ebx),%eax
80102053:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102058:	8b 33                	mov    (%ebx),%esi
8010205a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102060:	74 3e                	je     801020a0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102062:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102065:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102068:	83 ce 02             	or     $0x2,%esi
8010206b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010206d:	53                   	push   %ebx
8010206e:	e8 2d 1f 00 00       	call   80103fa0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102073:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102078:	83 c4 10             	add    $0x10,%esp
8010207b:	85 c0                	test   %eax,%eax
8010207d:	74 05                	je     80102084 <ideintr+0x54>
    idestart(idequeue);
8010207f:	e8 4c fe ff ff       	call   80101ed0 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
80102084:	83 ec 0c             	sub    $0xc,%esp
80102087:	68 80 a5 10 80       	push   $0x8010a580
8010208c:	e8 8f 23 00 00       	call   80104420 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102091:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102094:	5b                   	pop    %ebx
80102095:	5e                   	pop    %esi
80102096:	5f                   	pop    %edi
80102097:	5d                   	pop    %ebp
80102098:	c3                   	ret    
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020a0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020a5:	8d 76 00             	lea    0x0(%esi),%esi
801020a8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020a9:	89 c1                	mov    %eax,%ecx
801020ab:	83 e1 c0             	and    $0xffffffc0,%ecx
801020ae:	80 f9 40             	cmp    $0x40,%cl
801020b1:	75 f5                	jne    801020a8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020b3:	a8 21                	test   $0x21,%al
801020b5:	75 ab                	jne    80102062 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020b7:	8d 7b 18             	lea    0x18(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020ba:	b9 80 00 00 00       	mov    $0x80,%ecx
801020bf:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020c4:	fc                   	cld    
801020c5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020c7:	8b 33                	mov    (%ebx),%esi
801020c9:	eb 97                	jmp    80102062 <ideintr+0x32>
801020cb:	90                   	nop
801020cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	53                   	push   %ebx
801020d4:	83 ec 04             	sub    $0x4,%esp
801020d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801020da:	8b 03                	mov    (%ebx),%eax
801020dc:	a8 01                	test   $0x1,%al
801020de:	0f 84 a7 00 00 00    	je     8010218b <iderw+0xbb>
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801020e4:	83 e0 06             	and    $0x6,%eax
801020e7:	83 f8 02             	cmp    $0x2,%eax
801020ea:	0f 84 b5 00 00 00    	je     801021a5 <iderw+0xd5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801020f0:	8b 53 04             	mov    0x4(%ebx),%edx
801020f3:	85 d2                	test   %edx,%edx
801020f5:	74 0d                	je     80102104 <iderw+0x34>
801020f7:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801020fc:	85 c0                	test   %eax,%eax
801020fe:	0f 84 94 00 00 00    	je     80102198 <iderw+0xc8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102104:	83 ec 0c             	sub    $0xc,%esp
80102107:	68 80 a5 10 80       	push   $0x8010a580
8010210c:	e8 2f 21 00 00       	call   80104240 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102111:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102117:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
8010211a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102121:	85 d2                	test   %edx,%edx
80102123:	75 0d                	jne    80102132 <iderw+0x62>
80102125:	eb 54                	jmp    8010217b <iderw+0xab>
80102127:	89 f6                	mov    %esi,%esi
80102129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102130:	89 c2                	mov    %eax,%edx
80102132:	8b 42 14             	mov    0x14(%edx),%eax
80102135:	85 c0                	test   %eax,%eax
80102137:	75 f7                	jne    80102130 <iderw+0x60>
80102139:	83 c2 14             	add    $0x14,%edx
    ;
  *pp = b;
8010213c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010213e:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
80102144:	74 3c                	je     80102182 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102146:	8b 03                	mov    (%ebx),%eax
80102148:	83 e0 06             	and    $0x6,%eax
8010214b:	83 f8 02             	cmp    $0x2,%eax
8010214e:	74 1b                	je     8010216b <iderw+0x9b>
    sleep(b, &idelock);
80102150:	83 ec 08             	sub    $0x8,%esp
80102153:	68 80 a5 10 80       	push   $0x8010a580
80102158:	53                   	push   %ebx
80102159:	e8 a2 1c 00 00       	call   80103e00 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010215e:	8b 03                	mov    (%ebx),%eax
80102160:	83 c4 10             	add    $0x10,%esp
80102163:	83 e0 06             	and    $0x6,%eax
80102166:	83 f8 02             	cmp    $0x2,%eax
80102169:	75 e5                	jne    80102150 <iderw+0x80>
    sleep(b, &idelock);
  }

  release(&idelock);
8010216b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102172:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102175:	c9                   	leave  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
80102176:	e9 a5 22 00 00       	jmp    80104420 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102180:	eb ba                	jmp    8010213c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102182:	89 d8                	mov    %ebx,%eax
80102184:	e8 47 fd ff ff       	call   80101ed0 <idestart>
80102189:	eb bb                	jmp    80102146 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("iderw: buf not busy");
8010218b:	83 ec 0c             	sub    $0xc,%esp
8010218e:	68 7f 72 10 80       	push   $0x8010727f
80102193:	e8 b8 e1 ff ff       	call   80100350 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 a8 72 10 80       	push   $0x801072a8
801021a0:	e8 ab e1 ff ff       	call   80100350 <panic>
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 93 72 10 80       	push   $0x80107293
801021ad:	e8 9e e1 ff ff       	call   80100350 <panic>
801021b2:	66 90                	xchg   %ax,%ax
801021b4:	66 90                	xchg   %ax,%ax
801021b6:	66 90                	xchg   %ax,%ax
801021b8:	66 90                	xchg   %ax,%ax
801021ba:	66 90                	xchg   %ax,%ax
801021bc:	66 90                	xchg   %ax,%ax
801021be:	66 90                	xchg   %ax,%ax

801021c0 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
801021c0:	a1 24 13 11 80       	mov    0x80111324,%eax
801021c5:	85 c0                	test   %eax,%eax
801021c7:	0f 84 a8 00 00 00    	je     80102275 <ioapicinit+0xb5>
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021cd:	55                   	push   %ebp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021ce:	c7 05 94 11 11 80 00 	movl   $0xfec00000,0x80111194
801021d5:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021d8:	89 e5                	mov    %esp,%ebp
801021da:	56                   	push   %esi
801021db:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021dc:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021e3:	00 00 00 
  return ioapic->data;
801021e6:	8b 15 94 11 11 80    	mov    0x80111194,%edx
801021ec:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021ef:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801021f5:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801021fb:	0f b6 15 20 13 11 80 	movzbl 0x80111320,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102202:	89 f0                	mov    %esi,%eax
80102204:	c1 e8 10             	shr    $0x10,%eax
80102207:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010220a:	8b 41 10             	mov    0x10(%ecx),%eax
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010220d:	c1 e8 18             	shr    $0x18,%eax
80102210:	39 d0                	cmp    %edx,%eax
80102212:	74 16                	je     8010222a <ioapicinit+0x6a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102214:	83 ec 0c             	sub    $0xc,%esp
80102217:	68 c8 72 10 80       	push   $0x801072c8
8010221c:	e8 1f e4 ff ff       	call   80100640 <cprintf>
80102221:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
80102227:	83 c4 10             	add    $0x10,%esp
8010222a:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010222d:	ba 10 00 00 00       	mov    $0x10,%edx
80102232:	b8 20 00 00 00       	mov    $0x20,%eax
80102237:	89 f6                	mov    %esi,%esi
80102239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102240:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102242:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102248:	89 c3                	mov    %eax,%ebx
8010224a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102250:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102253:	89 59 10             	mov    %ebx,0x10(%ecx)
80102256:	8d 5a 01             	lea    0x1(%edx),%ebx
80102259:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010225c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010225e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102260:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
80102266:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010226d:	75 d1                	jne    80102240 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010226f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102272:	5b                   	pop    %ebx
80102273:	5e                   	pop    %esi
80102274:	5d                   	pop    %ebp
80102275:	f3 c3                	repz ret 
80102277:	89 f6                	mov    %esi,%esi
80102279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102280 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
80102280:	8b 15 24 13 11 80    	mov    0x80111324,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102286:	55                   	push   %ebp
80102287:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102289:	85 d2                	test   %edx,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
8010228b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
8010228e:	74 2b                	je     801022bb <ioapicenable+0x3b>
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102290:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102296:	8d 50 20             	lea    0x20(%eax),%edx
80102299:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010229d:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
8010229f:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022a5:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022a8:	89 51 10             	mov    %edx,0x10(%ecx)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022ab:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022ae:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022b0:	a1 94 11 11 80       	mov    0x80111194,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022b5:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022b8:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022bb:	5d                   	pop    %ebp
801022bc:	c3                   	ret    
801022bd:	66 90                	xchg   %ax,%ax
801022bf:	90                   	nop

801022c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	53                   	push   %ebx
801022c4:	83 ec 04             	sub    $0x4,%esp
801022c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022d0:	75 70                	jne    80102342 <kfree+0x82>
801022d2:	81 fb 08 41 11 80    	cmp    $0x80114108,%ebx
801022d8:	72 68                	jb     80102342 <kfree+0x82>
801022da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801022e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801022e5:	77 5b                	ja     80102342 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801022e7:	83 ec 04             	sub    $0x4,%esp
801022ea:	68 00 10 00 00       	push   $0x1000
801022ef:	6a 01                	push   $0x1
801022f1:	53                   	push   %ebx
801022f2:	e8 79 21 00 00       	call   80104470 <memset>

  if(kmem.use_lock)
801022f7:	8b 15 d4 11 11 80    	mov    0x801111d4,%edx
801022fd:	83 c4 10             	add    $0x10,%esp
80102300:	85 d2                	test   %edx,%edx
80102302:	75 2c                	jne    80102330 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102304:	a1 d8 11 11 80       	mov    0x801111d8,%eax
80102309:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010230b:	a1 d4 11 11 80       	mov    0x801111d4,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102310:	89 1d d8 11 11 80    	mov    %ebx,0x801111d8
  if(kmem.use_lock)
80102316:	85 c0                	test   %eax,%eax
80102318:	75 06                	jne    80102320 <kfree+0x60>
    release(&kmem.lock);
}
8010231a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010231d:	c9                   	leave  
8010231e:	c3                   	ret    
8010231f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102320:	c7 45 08 a0 11 11 80 	movl   $0x801111a0,0x8(%ebp)
}
80102327:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010232a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010232b:	e9 f0 20 00 00       	jmp    80104420 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102330:	83 ec 0c             	sub    $0xc,%esp
80102333:	68 a0 11 11 80       	push   $0x801111a0
80102338:	e8 03 1f 00 00       	call   80104240 <acquire>
8010233d:	83 c4 10             	add    $0x10,%esp
80102340:	eb c2                	jmp    80102304 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102342:	83 ec 0c             	sub    $0xc,%esp
80102345:	68 fa 72 10 80       	push   $0x801072fa
8010234a:	e8 01 e0 ff ff       	call   80100350 <panic>
8010234f:	90                   	nop

80102350 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	56                   	push   %esi
80102354:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102355:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102358:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010235b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102361:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102367:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010236d:	39 de                	cmp    %ebx,%esi
8010236f:	72 23                	jb     80102394 <freerange+0x44>
80102371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102378:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010237e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102381:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102387:	50                   	push   %eax
80102388:	e8 33 ff ff ff       	call   801022c0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010238d:	83 c4 10             	add    $0x10,%esp
80102390:	39 f3                	cmp    %esi,%ebx
80102392:	76 e4                	jbe    80102378 <freerange+0x28>
    kfree(p);
}
80102394:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102397:	5b                   	pop    %ebx
80102398:	5e                   	pop    %esi
80102399:	5d                   	pop    %ebp
8010239a:	c3                   	ret    
8010239b:	90                   	nop
8010239c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023a0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
801023a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023a8:	83 ec 08             	sub    $0x8,%esp
801023ab:	68 00 73 10 80       	push   $0x80107300
801023b0:	68 a0 11 11 80       	push   $0x801111a0
801023b5:	e8 66 1e 00 00       	call   80104220 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023bd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023c0:	c7 05 d4 11 11 80 00 	movl   $0x0,0x801111d4
801023c7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ca:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023dc:	39 de                	cmp    %ebx,%esi
801023de:	72 1c                	jb     801023fc <kinit1+0x5c>
    kfree(p);
801023e0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023e6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023ef:	50                   	push   %eax
801023f0:	e8 cb fe ff ff       	call   801022c0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f5:	83 c4 10             	add    $0x10,%esp
801023f8:	39 de                	cmp    %ebx,%esi
801023fa:	73 e4                	jae    801023e0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801023fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023ff:	5b                   	pop    %ebx
80102400:	5e                   	pop    %esi
80102401:	5d                   	pop    %ebp
80102402:	c3                   	ret    
80102403:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102410 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102415:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102418:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010241b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102421:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102427:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010242d:	39 de                	cmp    %ebx,%esi
8010242f:	72 23                	jb     80102454 <kinit2+0x44>
80102431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102438:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010243e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102441:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102447:	50                   	push   %eax
80102448:	e8 73 fe ff ff       	call   801022c0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010244d:	83 c4 10             	add    $0x10,%esp
80102450:	39 de                	cmp    %ebx,%esi
80102452:	73 e4                	jae    80102438 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102454:	c7 05 d4 11 11 80 01 	movl   $0x1,0x801111d4
8010245b:	00 00 00 
}
8010245e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102461:	5b                   	pop    %ebx
80102462:	5e                   	pop    %esi
80102463:	5d                   	pop    %ebp
80102464:	c3                   	ret    
80102465:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102470 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102470:	55                   	push   %ebp
80102471:	89 e5                	mov    %esp,%ebp
80102473:	53                   	push   %ebx
80102474:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102477:	a1 d4 11 11 80       	mov    0x801111d4,%eax
8010247c:	85 c0                	test   %eax,%eax
8010247e:	75 30                	jne    801024b0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102480:	8b 1d d8 11 11 80    	mov    0x801111d8,%ebx
  if(r)
80102486:	85 db                	test   %ebx,%ebx
80102488:	74 1c                	je     801024a6 <kalloc+0x36>
    kmem.freelist = r->next;
8010248a:	8b 13                	mov    (%ebx),%edx
8010248c:	89 15 d8 11 11 80    	mov    %edx,0x801111d8
  if(kmem.use_lock)
80102492:	85 c0                	test   %eax,%eax
80102494:	74 10                	je     801024a6 <kalloc+0x36>
    release(&kmem.lock);
80102496:	83 ec 0c             	sub    $0xc,%esp
80102499:	68 a0 11 11 80       	push   $0x801111a0
8010249e:	e8 7d 1f 00 00       	call   80104420 <release>
801024a3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024a6:	89 d8                	mov    %ebx,%eax
801024a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024ab:	c9                   	leave  
801024ac:	c3                   	ret    
801024ad:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024b0:	83 ec 0c             	sub    $0xc,%esp
801024b3:	68 a0 11 11 80       	push   $0x801111a0
801024b8:	e8 83 1d 00 00       	call   80104240 <acquire>
  r = kmem.freelist;
801024bd:	8b 1d d8 11 11 80    	mov    0x801111d8,%ebx
  if(r)
801024c3:	83 c4 10             	add    $0x10,%esp
801024c6:	a1 d4 11 11 80       	mov    0x801111d4,%eax
801024cb:	85 db                	test   %ebx,%ebx
801024cd:	75 bb                	jne    8010248a <kalloc+0x1a>
801024cf:	eb c1                	jmp    80102492 <kalloc+0x22>
801024d1:	66 90                	xchg   %ax,%ax
801024d3:	66 90                	xchg   %ax,%ax
801024d5:	66 90                	xchg   %ax,%ax
801024d7:	66 90                	xchg   %ax,%ax
801024d9:	66 90                	xchg   %ax,%ax
801024db:	66 90                	xchg   %ax,%ax
801024dd:	66 90                	xchg   %ax,%ax
801024df:	90                   	nop

801024e0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801024e0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024e1:	ba 64 00 00 00       	mov    $0x64,%edx
801024e6:	89 e5                	mov    %esp,%ebp
801024e8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024e9:	a8 01                	test   $0x1,%al
801024eb:	0f 84 af 00 00 00    	je     801025a0 <kbdgetc+0xc0>
801024f1:	ba 60 00 00 00       	mov    $0x60,%edx
801024f6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801024f7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801024fa:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102500:	74 7e                	je     80102580 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102502:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102504:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010250a:	79 24                	jns    80102530 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010250c:	f6 c1 40             	test   $0x40,%cl
8010250f:	75 05                	jne    80102516 <kbdgetc+0x36>
80102511:	89 c2                	mov    %eax,%edx
80102513:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102516:	0f b6 82 40 74 10 80 	movzbl -0x7fef8bc0(%edx),%eax
8010251d:	83 c8 40             	or     $0x40,%eax
80102520:	0f b6 c0             	movzbl %al,%eax
80102523:	f7 d0                	not    %eax
80102525:	21 c8                	and    %ecx,%eax
80102527:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010252c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010252e:	5d                   	pop    %ebp
8010252f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102530:	f6 c1 40             	test   $0x40,%cl
80102533:	74 09                	je     8010253e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102535:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102538:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010253b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010253e:	0f b6 82 40 74 10 80 	movzbl -0x7fef8bc0(%edx),%eax
80102545:	09 c1                	or     %eax,%ecx
80102547:	0f b6 82 40 73 10 80 	movzbl -0x7fef8cc0(%edx),%eax
8010254e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102550:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102552:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102558:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010255b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010255e:	8b 04 85 20 73 10 80 	mov    -0x7fef8ce0(,%eax,4),%eax
80102565:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102569:	74 c3                	je     8010252e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010256b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010256e:	83 fa 19             	cmp    $0x19,%edx
80102571:	77 1d                	ja     80102590 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102573:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102576:	5d                   	pop    %ebp
80102577:	c3                   	ret    
80102578:	90                   	nop
80102579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102580:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102582:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102589:	5d                   	pop    %ebp
8010258a:	c3                   	ret    
8010258b:	90                   	nop
8010258c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102590:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102593:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102596:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102597:	83 f9 19             	cmp    $0x19,%ecx
8010259a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010259d:	c3                   	ret    
8010259e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025a5:	5d                   	pop    %ebp
801025a6:	c3                   	ret    
801025a7:	89 f6                	mov    %esi,%esi
801025a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025b0 <kbdintr>:

void
kbdintr(void)
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025b6:	68 e0 24 10 80       	push   $0x801024e0
801025bb:	e8 10 e2 ff ff       	call   801007d0 <consoleintr>
}
801025c0:	83 c4 10             	add    $0x10,%esp
801025c3:	c9                   	leave  
801025c4:	c3                   	ret    
801025c5:	66 90                	xchg   %ax,%ax
801025c7:	66 90                	xchg   %ax,%ax
801025c9:	66 90                	xchg   %ax,%ax
801025cb:	66 90                	xchg   %ax,%ax
801025cd:	66 90                	xchg   %ax,%ax
801025cf:	90                   	nop

801025d0 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
801025d0:	a1 dc 11 11 80       	mov    0x801111dc,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
801025d5:	55                   	push   %ebp
801025d6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801025d8:	85 c0                	test   %eax,%eax
801025da:	0f 84 c8 00 00 00    	je     801026a8 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025e0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801025e7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025ea:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025ed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801025f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025f7:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025fa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102601:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102604:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102607:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010260e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102611:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102614:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010261b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010261e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102621:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102628:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010262b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010262e:	8b 50 30             	mov    0x30(%eax),%edx
80102631:	c1 ea 10             	shr    $0x10,%edx
80102634:	80 fa 03             	cmp    $0x3,%dl
80102637:	77 77                	ja     801026b0 <lapicinit+0xe0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102639:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102640:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102643:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102646:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010264d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102650:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102653:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010265a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010265d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102660:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102667:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010266a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010266d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102674:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102677:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102681:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102684:	8b 50 20             	mov    0x20(%eax),%edx
80102687:	89 f6                	mov    %esi,%esi
80102689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102690:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102696:	80 e6 10             	and    $0x10,%dh
80102699:	75 f5                	jne    80102690 <lapicinit+0xc0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026a2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026a8:	5d                   	pop    %ebp
801026a9:	c3                   	ret    
801026aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026b7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ba:	8b 50 20             	mov    0x20(%eax),%edx
801026bd:	e9 77 ff ff ff       	jmp    80102639 <lapicinit+0x69>
801026c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026d0 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	56                   	push   %esi
801026d4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801026d5:	9c                   	pushf  
801026d6:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801026d7:	f6 c4 02             	test   $0x2,%ah
801026da:	74 12                	je     801026ee <cpunum+0x1e>
    static int n;
    if(n++ == 0)
801026dc:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
801026e1:	8d 50 01             	lea    0x1(%eax),%edx
801026e4:	85 c0                	test   %eax,%eax
801026e6:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
801026ec:	74 4d                	je     8010273b <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
801026ee:	a1 dc 11 11 80       	mov    0x801111dc,%eax
801026f3:	85 c0                	test   %eax,%eax
801026f5:	74 60                	je     80102757 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
801026f7:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
801026fa:	8b 35 20 19 11 80    	mov    0x80111920,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
80102700:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
80102703:	85 f6                	test   %esi,%esi
80102705:	7e 59                	jle    80102760 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102707:	0f b6 05 40 13 11 80 	movzbl 0x80111340,%eax
8010270e:	39 c3                	cmp    %eax,%ebx
80102710:	74 45                	je     80102757 <cpunum+0x87>
80102712:	ba fc 13 11 80       	mov    $0x801113fc,%edx
80102717:	31 c0                	xor    %eax,%eax
80102719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
80102720:	83 c0 01             	add    $0x1,%eax
80102723:	39 f0                	cmp    %esi,%eax
80102725:	74 39                	je     80102760 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102727:	0f b6 0a             	movzbl (%edx),%ecx
8010272a:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80102730:	39 cb                	cmp    %ecx,%ebx
80102732:	75 ec                	jne    80102720 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
80102734:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102737:	5b                   	pop    %ebx
80102738:	5e                   	pop    %esi
80102739:	5d                   	pop    %ebp
8010273a:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
8010273b:	83 ec 08             	sub    $0x8,%esp
8010273e:	ff 75 04             	pushl  0x4(%ebp)
80102741:	68 40 75 10 80       	push   $0x80107540
80102746:	e8 f5 de ff ff       	call   80100640 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
8010274b:	a1 dc 11 11 80       	mov    0x801111dc,%eax
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
80102750:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if (!lapic)
80102753:	85 c0                	test   %eax,%eax
80102755:	75 a0                	jne    801026f7 <cpunum+0x27>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
80102757:	8d 65 f8             	lea    -0x8(%ebp),%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
8010275a:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
8010275c:	5b                   	pop    %ebx
8010275d:	5e                   	pop    %esi
8010275e:	5d                   	pop    %ebp
8010275f:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102760:	83 ec 0c             	sub    $0xc,%esp
80102763:	68 6c 75 10 80       	push   $0x8010756c
80102768:	e8 e3 db ff ff       	call   80100350 <panic>
8010276d:	8d 76 00             	lea    0x0(%esi),%esi

80102770 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102770:	a1 dc 11 11 80       	mov    0x801111dc,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0d                	je     80102789 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102783:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102786:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102789:	5d                   	pop    %ebp
8010278a:	c3                   	ret    
8010278b:	90                   	nop
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
}
80102793:	5d                   	pop    %ebp
80102794:	c3                   	ret    
80102795:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027a0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027a0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027a1:	ba 70 00 00 00       	mov    $0x70,%edx
801027a6:	b8 0f 00 00 00       	mov    $0xf,%eax
801027ab:	89 e5                	mov    %esp,%ebp
801027ad:	53                   	push   %ebx
801027ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801027b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801027b4:	ee                   	out    %al,(%dx)
801027b5:	ba 71 00 00 00       	mov    $0x71,%edx
801027ba:	b8 0a 00 00 00       	mov    $0xa,%eax
801027bf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027c0:	31 c0                	xor    %eax,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027c2:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027c5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027cb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027cd:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801027d0:	c1 e8 04             	shr    $0x4,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027d3:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027d5:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801027d8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027de:	a1 dc 11 11 80       	mov    0x801111dc,%eax
801027e3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027e9:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027ec:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801027f3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f6:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102800:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102803:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102806:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010280c:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010280f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102815:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102818:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010281e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102821:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102827:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010282a:	5b                   	pop    %ebx
8010282b:	5d                   	pop    %ebp
8010282c:	c3                   	ret    
8010282d:	8d 76 00             	lea    0x0(%esi),%esi

80102830 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102830:	55                   	push   %ebp
80102831:	ba 70 00 00 00       	mov    $0x70,%edx
80102836:	b8 0b 00 00 00       	mov    $0xb,%eax
8010283b:	89 e5                	mov    %esp,%ebp
8010283d:	57                   	push   %edi
8010283e:	56                   	push   %esi
8010283f:	53                   	push   %ebx
80102840:	83 ec 4c             	sub    $0x4c,%esp
80102843:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102844:	ba 71 00 00 00       	mov    $0x71,%edx
80102849:	ec                   	in     (%dx),%al
8010284a:	83 e0 04             	and    $0x4,%eax
8010284d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102850:	31 db                	xor    %ebx,%ebx
80102852:	88 45 b7             	mov    %al,-0x49(%ebp)
80102855:	bf 70 00 00 00       	mov    $0x70,%edi
8010285a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102860:	89 d8                	mov    %ebx,%eax
80102862:	89 fa                	mov    %edi,%edx
80102864:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102865:	b9 71 00 00 00       	mov    $0x71,%ecx
8010286a:	89 ca                	mov    %ecx,%edx
8010286c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010286d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102870:	89 fa                	mov    %edi,%edx
80102872:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102875:	b8 02 00 00 00       	mov    $0x2,%eax
8010287a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287b:	89 ca                	mov    %ecx,%edx
8010287d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010287e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102881:	89 fa                	mov    %edi,%edx
80102883:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102886:	b8 04 00 00 00       	mov    $0x4,%eax
8010288b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288c:	89 ca                	mov    %ecx,%edx
8010288e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010288f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102892:	89 fa                	mov    %edi,%edx
80102894:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102897:	b8 07 00 00 00       	mov    $0x7,%eax
8010289c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289d:	89 ca                	mov    %ecx,%edx
8010289f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028a0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a3:	89 fa                	mov    %edi,%edx
801028a5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801028a8:	b8 08 00 00 00       	mov    $0x8,%eax
801028ad:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ae:	89 ca                	mov    %ecx,%edx
801028b0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028b1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b4:	89 fa                	mov    %edi,%edx
801028b6:	89 45 c8             	mov    %eax,-0x38(%ebp)
801028b9:	b8 09 00 00 00       	mov    $0x9,%eax
801028be:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028bf:	89 ca                	mov    %ecx,%edx
801028c1:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028c2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c5:	89 fa                	mov    %edi,%edx
801028c7:	89 45 cc             	mov    %eax,-0x34(%ebp)
801028ca:	b8 0a 00 00 00       	mov    $0xa,%eax
801028cf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d0:	89 ca                	mov    %ecx,%edx
801028d2:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028d3:	84 c0                	test   %al,%al
801028d5:	78 89                	js     80102860 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028d7:	89 d8                	mov    %ebx,%eax
801028d9:	89 fa                	mov    %edi,%edx
801028db:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028dc:	89 ca                	mov    %ecx,%edx
801028de:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801028df:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e2:	89 fa                	mov    %edi,%edx
801028e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801028e7:	b8 02 00 00 00       	mov    $0x2,%eax
801028ec:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ed:	89 ca                	mov    %ecx,%edx
801028ef:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801028f0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f3:	89 fa                	mov    %edi,%edx
801028f5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801028f8:	b8 04 00 00 00       	mov    $0x4,%eax
801028fd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fe:	89 ca                	mov    %ecx,%edx
80102900:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102901:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102904:	89 fa                	mov    %edi,%edx
80102906:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102909:	b8 07 00 00 00       	mov    $0x7,%eax
8010290e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290f:	89 ca                	mov    %ecx,%edx
80102911:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102912:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102915:	89 fa                	mov    %edi,%edx
80102917:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010291a:	b8 08 00 00 00       	mov    $0x8,%eax
8010291f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102920:	89 ca                	mov    %ecx,%edx
80102922:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102923:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102926:	89 fa                	mov    %edi,%edx
80102928:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010292b:	b8 09 00 00 00       	mov    $0x9,%eax
80102930:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102931:	89 ca                	mov    %ecx,%edx
80102933:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102934:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102937:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
8010293a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010293d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102940:	6a 18                	push   $0x18
80102942:	56                   	push   %esi
80102943:	50                   	push   %eax
80102944:	e8 77 1b 00 00       	call   801044c0 <memcmp>
80102949:	83 c4 10             	add    $0x10,%esp
8010294c:	85 c0                	test   %eax,%eax
8010294e:	0f 85 0c ff ff ff    	jne    80102860 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102954:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102958:	75 78                	jne    801029d2 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010295a:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010295d:	89 c2                	mov    %eax,%edx
8010295f:	83 e0 0f             	and    $0xf,%eax
80102962:	c1 ea 04             	shr    $0x4,%edx
80102965:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102968:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010296e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102971:	89 c2                	mov    %eax,%edx
80102973:	83 e0 0f             	and    $0xf,%eax
80102976:	c1 ea 04             	shr    $0x4,%edx
80102979:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010297c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010297f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102982:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102985:	89 c2                	mov    %eax,%edx
80102987:	83 e0 0f             	and    $0xf,%eax
8010298a:	c1 ea 04             	shr    $0x4,%edx
8010298d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102990:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102993:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102996:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102999:	89 c2                	mov    %eax,%edx
8010299b:	83 e0 0f             	and    $0xf,%eax
8010299e:	c1 ea 04             	shr    $0x4,%edx
801029a1:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029a4:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029a7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801029aa:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029ad:	89 c2                	mov    %eax,%edx
801029af:	83 e0 0f             	and    $0xf,%eax
801029b2:	c1 ea 04             	shr    $0x4,%edx
801029b5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029b8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029bb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801029be:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029c1:	89 c2                	mov    %eax,%edx
801029c3:	83 e0 0f             	and    $0xf,%eax
801029c6:	c1 ea 04             	shr    $0x4,%edx
801029c9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029cc:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029cf:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801029d2:	8b 75 08             	mov    0x8(%ebp),%esi
801029d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029d8:	89 06                	mov    %eax,(%esi)
801029da:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029dd:	89 46 04             	mov    %eax,0x4(%esi)
801029e0:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029e3:	89 46 08             	mov    %eax,0x8(%esi)
801029e6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801029e9:	89 46 0c             	mov    %eax,0xc(%esi)
801029ec:	8b 45 c8             	mov    -0x38(%ebp),%eax
801029ef:	89 46 10             	mov    %eax,0x10(%esi)
801029f2:	8b 45 cc             	mov    -0x34(%ebp),%eax
801029f5:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801029f8:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801029ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a02:	5b                   	pop    %ebx
80102a03:	5e                   	pop    %esi
80102a04:	5f                   	pop    %edi
80102a05:	5d                   	pop    %ebp
80102a06:	c3                   	ret    
80102a07:	66 90                	xchg   %ax,%ax
80102a09:	66 90                	xchg   %ax,%ax
80102a0b:	66 90                	xchg   %ax,%ax
80102a0d:	66 90                	xchg   %ax,%ax
80102a0f:	90                   	nop

80102a10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a10:	8b 0d 28 12 11 80    	mov    0x80111228,%ecx
80102a16:	85 c9                	test   %ecx,%ecx
80102a18:	0f 8e 85 00 00 00    	jle    80102aa3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102a1e:	55                   	push   %ebp
80102a1f:	89 e5                	mov    %esp,%ebp
80102a21:	57                   	push   %edi
80102a22:	56                   	push   %esi
80102a23:	53                   	push   %ebx
80102a24:	31 db                	xor    %ebx,%ebx
80102a26:	83 ec 0c             	sub    $0xc,%esp
80102a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102a30:	a1 14 12 11 80       	mov    0x80111214,%eax
80102a35:	83 ec 08             	sub    $0x8,%esp
80102a38:	01 d8                	add    %ebx,%eax
80102a3a:	83 c0 01             	add    $0x1,%eax
80102a3d:	50                   	push   %eax
80102a3e:	ff 35 24 12 11 80    	pushl  0x80111224
80102a44:	e8 77 d6 ff ff       	call   801000c0 <bread>
80102a49:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a4b:	58                   	pop    %eax
80102a4c:	5a                   	pop    %edx
80102a4d:	ff 34 9d 2c 12 11 80 	pushl  -0x7feeedd4(,%ebx,4)
80102a54:	ff 35 24 12 11 80    	pushl  0x80111224
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a5a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102a5d:	e8 5e d6 ff ff       	call   801000c0 <bread>
80102a62:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a64:	8d 47 18             	lea    0x18(%edi),%eax
80102a67:	83 c4 0c             	add    $0xc,%esp
80102a6a:	68 00 02 00 00       	push   $0x200
80102a6f:	50                   	push   %eax
80102a70:	8d 46 18             	lea    0x18(%esi),%eax
80102a73:	50                   	push   %eax
80102a74:	e8 a7 1a 00 00       	call   80104520 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a79:	89 34 24             	mov    %esi,(%esp)
80102a7c:	e8 1f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a81:	89 3c 24             	mov    %edi,(%esp)
80102a84:	e8 47 d7 ff ff       	call   801001d0 <brelse>
    brelse(dbuf);
80102a89:	89 34 24             	mov    %esi,(%esp)
80102a8c:	e8 3f d7 ff ff       	call   801001d0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a91:	83 c4 10             	add    $0x10,%esp
80102a94:	39 1d 28 12 11 80    	cmp    %ebx,0x80111228
80102a9a:	7f 94                	jg     80102a30 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a9f:	5b                   	pop    %ebx
80102aa0:	5e                   	pop    %esi
80102aa1:	5f                   	pop    %edi
80102aa2:	5d                   	pop    %ebp
80102aa3:	f3 c3                	repz ret 
80102aa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ab0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	53                   	push   %ebx
80102ab4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ab7:	ff 35 14 12 11 80    	pushl  0x80111214
80102abd:	ff 35 24 12 11 80    	pushl  0x80111224
80102ac3:	e8 f8 d5 ff ff       	call   801000c0 <bread>
80102ac8:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102aca:	a1 28 12 11 80       	mov    0x80111228,%eax
  for (i = 0; i < log.lh.n; i++) {
80102acf:	83 c4 10             	add    $0x10,%esp
80102ad2:	31 d2                	xor    %edx,%edx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102ad4:	89 43 18             	mov    %eax,0x18(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102ad7:	a1 28 12 11 80       	mov    0x80111228,%eax
80102adc:	85 c0                	test   %eax,%eax
80102ade:	7e 16                	jle    80102af6 <write_head+0x46>
    hb->block[i] = log.lh.block[i];
80102ae0:	8b 0c 95 2c 12 11 80 	mov    -0x7feeedd4(,%edx,4),%ecx
80102ae7:	89 4c 93 1c          	mov    %ecx,0x1c(%ebx,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102aeb:	83 c2 01             	add    $0x1,%edx
80102aee:	39 15 28 12 11 80    	cmp    %edx,0x80111228
80102af4:	7f ea                	jg     80102ae0 <write_head+0x30>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102af6:	83 ec 0c             	sub    $0xc,%esp
80102af9:	53                   	push   %ebx
80102afa:	e8 a1 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aff:	89 1c 24             	mov    %ebx,(%esp)
80102b02:	e8 c9 d6 ff ff       	call   801001d0 <brelse>
}
80102b07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b0a:	c9                   	leave  
80102b0b:	c3                   	ret    
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b10 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	53                   	push   %ebx
80102b14:	83 ec 2c             	sub    $0x2c,%esp
80102b17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102b1a:	68 7c 75 10 80       	push   $0x8010757c
80102b1f:	68 e0 11 11 80       	push   $0x801111e0
80102b24:	e8 f7 16 00 00       	call   80104220 <initlock>
  readsb(dev, &sb);
80102b29:	58                   	pop    %eax
80102b2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b2d:	5a                   	pop    %edx
80102b2e:	50                   	push   %eax
80102b2f:	53                   	push   %ebx
80102b30:	e8 3b e8 ff ff       	call   80101370 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b35:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b38:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b3b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102b3c:	89 1d 24 12 11 80    	mov    %ebx,0x80111224

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102b42:	89 15 18 12 11 80    	mov    %edx,0x80111218
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102b48:	a3 14 12 11 80       	mov    %eax,0x80111214

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b4d:	5a                   	pop    %edx
80102b4e:	50                   	push   %eax
80102b4f:	53                   	push   %ebx
80102b50:	e8 6b d5 ff ff       	call   801000c0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b55:	8b 48 18             	mov    0x18(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b58:	83 c4 10             	add    $0x10,%esp
80102b5b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102b5d:	89 0d 28 12 11 80    	mov    %ecx,0x80111228
  for (i = 0; i < log.lh.n; i++) {
80102b63:	7e 1c                	jle    80102b81 <initlog+0x71>
80102b65:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b6c:	31 d2                	xor    %edx,%edx
80102b6e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b70:	8b 4c 10 1c          	mov    0x1c(%eax,%edx,1),%ecx
80102b74:	83 c2 04             	add    $0x4,%edx
80102b77:	89 8a 28 12 11 80    	mov    %ecx,-0x7feeedd8(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b7d:	39 da                	cmp    %ebx,%edx
80102b7f:	75 ef                	jne    80102b70 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b81:	83 ec 0c             	sub    $0xc,%esp
80102b84:	50                   	push   %eax
80102b85:	e8 46 d6 ff ff       	call   801001d0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b8a:	e8 81 fe ff ff       	call   80102a10 <install_trans>
  log.lh.n = 0;
80102b8f:	c7 05 28 12 11 80 00 	movl   $0x0,0x80111228
80102b96:	00 00 00 
  write_head(); // clear the log
80102b99:	e8 12 ff ff ff       	call   80102ab0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ba1:	c9                   	leave  
80102ba2:	c3                   	ret    
80102ba3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bb0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102bb6:	68 e0 11 11 80       	push   $0x801111e0
80102bbb:	e8 80 16 00 00       	call   80104240 <acquire>
80102bc0:	83 c4 10             	add    $0x10,%esp
80102bc3:	eb 18                	jmp    80102bdd <begin_op+0x2d>
80102bc5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102bc8:	83 ec 08             	sub    $0x8,%esp
80102bcb:	68 e0 11 11 80       	push   $0x801111e0
80102bd0:	68 e0 11 11 80       	push   $0x801111e0
80102bd5:	e8 26 12 00 00       	call   80103e00 <sleep>
80102bda:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102bdd:	a1 20 12 11 80       	mov    0x80111220,%eax
80102be2:	85 c0                	test   %eax,%eax
80102be4:	75 e2                	jne    80102bc8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102be6:	a1 1c 12 11 80       	mov    0x8011121c,%eax
80102beb:	8b 15 28 12 11 80    	mov    0x80111228,%edx
80102bf1:	83 c0 01             	add    $0x1,%eax
80102bf4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102bf7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102bfa:	83 fa 1e             	cmp    $0x1e,%edx
80102bfd:	7f c9                	jg     80102bc8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102bff:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102c02:	a3 1c 12 11 80       	mov    %eax,0x8011121c
      release(&log.lock);
80102c07:	68 e0 11 11 80       	push   $0x801111e0
80102c0c:	e8 0f 18 00 00       	call   80104420 <release>
      break;
    }
  }
}
80102c11:	83 c4 10             	add    $0x10,%esp
80102c14:	c9                   	leave  
80102c15:	c3                   	ret    
80102c16:	8d 76 00             	lea    0x0(%esi),%esi
80102c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	57                   	push   %edi
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c29:	68 e0 11 11 80       	push   $0x801111e0
80102c2e:	e8 0d 16 00 00       	call   80104240 <acquire>
  log.outstanding -= 1;
80102c33:	a1 1c 12 11 80       	mov    0x8011121c,%eax
  if(log.committing)
80102c38:	8b 1d 20 12 11 80    	mov    0x80111220,%ebx
80102c3e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c41:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102c44:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102c46:	a3 1c 12 11 80       	mov    %eax,0x8011121c
  if(log.committing)
80102c4b:	0f 85 23 01 00 00    	jne    80102d74 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102c51:	85 c0                	test   %eax,%eax
80102c53:	0f 85 f7 00 00 00    	jne    80102d50 <end_op+0x130>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c59:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102c5c:	c7 05 20 12 11 80 01 	movl   $0x1,0x80111220
80102c63:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c66:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102c68:	68 e0 11 11 80       	push   $0x801111e0
80102c6d:	e8 ae 17 00 00       	call   80104420 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c72:	8b 0d 28 12 11 80    	mov    0x80111228,%ecx
80102c78:	83 c4 10             	add    $0x10,%esp
80102c7b:	85 c9                	test   %ecx,%ecx
80102c7d:	0f 8e 8a 00 00 00    	jle    80102d0d <end_op+0xed>
80102c83:	90                   	nop
80102c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c88:	a1 14 12 11 80       	mov    0x80111214,%eax
80102c8d:	83 ec 08             	sub    $0x8,%esp
80102c90:	01 d8                	add    %ebx,%eax
80102c92:	83 c0 01             	add    $0x1,%eax
80102c95:	50                   	push   %eax
80102c96:	ff 35 24 12 11 80    	pushl  0x80111224
80102c9c:	e8 1f d4 ff ff       	call   801000c0 <bread>
80102ca1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ca3:	58                   	pop    %eax
80102ca4:	5a                   	pop    %edx
80102ca5:	ff 34 9d 2c 12 11 80 	pushl  -0x7feeedd4(,%ebx,4)
80102cac:	ff 35 24 12 11 80    	pushl  0x80111224
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cb2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102cb5:	e8 06 d4 ff ff       	call   801000c0 <bread>
80102cba:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102cbc:	8d 40 18             	lea    0x18(%eax),%eax
80102cbf:	83 c4 0c             	add    $0xc,%esp
80102cc2:	68 00 02 00 00       	push   $0x200
80102cc7:	50                   	push   %eax
80102cc8:	8d 46 18             	lea    0x18(%esi),%eax
80102ccb:	50                   	push   %eax
80102ccc:	e8 4f 18 00 00       	call   80104520 <memmove>
    bwrite(to);  // write the log
80102cd1:	89 34 24             	mov    %esi,(%esp)
80102cd4:	e8 c7 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102cd9:	89 3c 24             	mov    %edi,(%esp)
80102cdc:	e8 ef d4 ff ff       	call   801001d0 <brelse>
    brelse(to);
80102ce1:	89 34 24             	mov    %esi,(%esp)
80102ce4:	e8 e7 d4 ff ff       	call   801001d0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ce9:	83 c4 10             	add    $0x10,%esp
80102cec:	3b 1d 28 12 11 80    	cmp    0x80111228,%ebx
80102cf2:	7c 94                	jl     80102c88 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102cf4:	e8 b7 fd ff ff       	call   80102ab0 <write_head>
    install_trans(); // Now install writes to home locations
80102cf9:	e8 12 fd ff ff       	call   80102a10 <install_trans>
    log.lh.n = 0;
80102cfe:	c7 05 28 12 11 80 00 	movl   $0x0,0x80111228
80102d05:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d08:	e8 a3 fd ff ff       	call   80102ab0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102d0d:	83 ec 0c             	sub    $0xc,%esp
80102d10:	68 e0 11 11 80       	push   $0x801111e0
80102d15:	e8 26 15 00 00       	call   80104240 <acquire>
    log.committing = 0;
    wakeup(&log);
80102d1a:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102d21:	c7 05 20 12 11 80 00 	movl   $0x0,0x80111220
80102d28:	00 00 00 
    wakeup(&log);
80102d2b:	e8 70 12 00 00       	call   80103fa0 <wakeup>
    release(&log.lock);
80102d30:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102d37:	e8 e4 16 00 00       	call   80104420 <release>
80102d3c:	83 c4 10             	add    $0x10,%esp
  }
}
80102d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d42:	5b                   	pop    %ebx
80102d43:	5e                   	pop    %esi
80102d44:	5f                   	pop    %edi
80102d45:	5d                   	pop    %ebp
80102d46:	c3                   	ret    
80102d47:	89 f6                	mov    %esi,%esi
80102d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80102d50:	83 ec 0c             	sub    $0xc,%esp
80102d53:	68 e0 11 11 80       	push   $0x801111e0
80102d58:	e8 43 12 00 00       	call   80103fa0 <wakeup>
  }
  release(&log.lock);
80102d5d:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102d64:	e8 b7 16 00 00       	call   80104420 <release>
80102d69:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d6f:	5b                   	pop    %ebx
80102d70:	5e                   	pop    %esi
80102d71:	5f                   	pop    %edi
80102d72:	5d                   	pop    %ebp
80102d73:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d74:	83 ec 0c             	sub    $0xc,%esp
80102d77:	68 80 75 10 80       	push   $0x80107580
80102d7c:	e8 cf d5 ff ff       	call   80100350 <panic>
80102d81:	eb 0d                	jmp    80102d90 <log_write>
80102d83:	90                   	nop
80102d84:	90                   	nop
80102d85:	90                   	nop
80102d86:	90                   	nop
80102d87:	90                   	nop
80102d88:	90                   	nop
80102d89:	90                   	nop
80102d8a:	90                   	nop
80102d8b:	90                   	nop
80102d8c:	90                   	nop
80102d8d:	90                   	nop
80102d8e:	90                   	nop
80102d8f:	90                   	nop

80102d90 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d97:	8b 15 28 12 11 80    	mov    0x80111228,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102da0:	83 fa 1d             	cmp    $0x1d,%edx
80102da3:	0f 8f 97 00 00 00    	jg     80102e40 <log_write+0xb0>
80102da9:	a1 18 12 11 80       	mov    0x80111218,%eax
80102dae:	83 e8 01             	sub    $0x1,%eax
80102db1:	39 c2                	cmp    %eax,%edx
80102db3:	0f 8d 87 00 00 00    	jge    80102e40 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102db9:	a1 1c 12 11 80       	mov    0x8011121c,%eax
80102dbe:	85 c0                	test   %eax,%eax
80102dc0:	0f 8e 87 00 00 00    	jle    80102e4d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102dc6:	83 ec 0c             	sub    $0xc,%esp
80102dc9:	68 e0 11 11 80       	push   $0x801111e0
80102dce:	e8 6d 14 00 00       	call   80104240 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102dd3:	8b 15 28 12 11 80    	mov    0x80111228,%edx
80102dd9:	83 c4 10             	add    $0x10,%esp
80102ddc:	83 fa 00             	cmp    $0x0,%edx
80102ddf:	7e 50                	jle    80102e31 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102de1:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102de4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102de6:	3b 0d 2c 12 11 80    	cmp    0x8011122c,%ecx
80102dec:	75 0b                	jne    80102df9 <log_write+0x69>
80102dee:	eb 38                	jmp    80102e28 <log_write+0x98>
80102df0:	39 0c 85 2c 12 11 80 	cmp    %ecx,-0x7feeedd4(,%eax,4)
80102df7:	74 2f                	je     80102e28 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102df9:	83 c0 01             	add    $0x1,%eax
80102dfc:	39 d0                	cmp    %edx,%eax
80102dfe:	75 f0                	jne    80102df0 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e00:	89 0c 95 2c 12 11 80 	mov    %ecx,-0x7feeedd4(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e07:	83 c2 01             	add    $0x1,%edx
80102e0a:	89 15 28 12 11 80    	mov    %edx,0x80111228
  b->flags |= B_DIRTY; // prevent eviction
80102e10:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e13:	c7 45 08 e0 11 11 80 	movl   $0x801111e0,0x8(%ebp)
}
80102e1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e1d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102e1e:	e9 fd 15 00 00       	jmp    80104420 <release>
80102e23:	90                   	nop
80102e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e28:	89 0c 85 2c 12 11 80 	mov    %ecx,-0x7feeedd4(,%eax,4)
80102e2f:	eb df                	jmp    80102e10 <log_write+0x80>
80102e31:	8b 43 08             	mov    0x8(%ebx),%eax
80102e34:	a3 2c 12 11 80       	mov    %eax,0x8011122c
  if (i == log.lh.n)
80102e39:	75 d5                	jne    80102e10 <log_write+0x80>
80102e3b:	eb ca                	jmp    80102e07 <log_write+0x77>
80102e3d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102e40:	83 ec 0c             	sub    $0xc,%esp
80102e43:	68 8f 75 10 80       	push   $0x8010758f
80102e48:	e8 03 d5 ff ff       	call   80100350 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102e4d:	83 ec 0c             	sub    $0xc,%esp
80102e50:	68 a5 75 10 80       	push   $0x801075a5
80102e55:	e8 f6 d4 ff ff       	call   80100350 <panic>
80102e5a:	66 90                	xchg   %ax,%ax
80102e5c:	66 90                	xchg   %ax,%ax
80102e5e:	66 90                	xchg   %ax,%ax

80102e60 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e60:	55                   	push   %ebp
80102e61:	89 e5                	mov    %esp,%ebp
80102e63:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102e66:	e8 65 f8 ff ff       	call   801026d0 <cpunum>
80102e6b:	83 ec 08             	sub    $0x8,%esp
80102e6e:	50                   	push   %eax
80102e6f:	68 c0 75 10 80       	push   $0x801075c0
80102e74:	e8 c7 d7 ff ff       	call   80100640 <cprintf>
  idtinit();       // load idt register
80102e79:	e8 52 2a 00 00       	call   801058d0 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102e7e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e85:	b8 01 00 00 00       	mov    $0x1,%eax
80102e8a:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102e91:	e8 8a 0c 00 00       	call   80103b20 <scheduler>
80102e96:	8d 76 00             	lea    0x0(%esi),%esi
80102e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ea0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102ea6:	e8 35 3c 00 00       	call   80106ae0 <switchkvm>
  seginit();
80102eab:	e8 50 3a 00 00       	call   80106900 <seginit>
  lapicinit();
80102eb0:	e8 1b f7 ff ff       	call   801025d0 <lapicinit>
  mpmain();
80102eb5:	e8 a6 ff ff ff       	call   80102e60 <mpmain>
80102eba:	66 90                	xchg   %ax,%ax
80102ebc:	66 90                	xchg   %ax,%ax
80102ebe:	66 90                	xchg   %ax,%ax

80102ec0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102ec0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102ec4:	83 e4 f0             	and    $0xfffffff0,%esp
80102ec7:	ff 71 fc             	pushl  -0x4(%ecx)
80102eca:	55                   	push   %ebp
80102ecb:	89 e5                	mov    %esp,%ebp
80102ecd:	53                   	push   %ebx
80102ece:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102ecf:	83 ec 08             	sub    $0x8,%esp
80102ed2:	68 00 00 40 80       	push   $0x80400000
80102ed7:	68 08 41 11 80       	push   $0x80114108
80102edc:	e8 bf f4 ff ff       	call   801023a0 <kinit1>
  kvmalloc();      // kernel page table
80102ee1:	e8 da 3b 00 00       	call   80106ac0 <kvmalloc>
  mpinit();        // detect other processors
80102ee6:	e8 c5 01 00 00       	call   801030b0 <mpinit>
  lapicinit();     // interrupt controller
80102eeb:	e8 e0 f6 ff ff       	call   801025d0 <lapicinit>
  seginit();       // segment descriptors
80102ef0:	e8 0b 3a 00 00       	call   80106900 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80102ef5:	e8 d6 f7 ff ff       	call   801026d0 <cpunum>
80102efa:	59                   	pop    %ecx
80102efb:	5b                   	pop    %ebx
80102efc:	50                   	push   %eax
80102efd:	68 d1 75 10 80       	push   $0x801075d1
80102f02:	e8 39 d7 ff ff       	call   80100640 <cprintf>
  picinit();       // another interrupt controller
80102f07:	e8 b4 03 00 00       	call   801032c0 <picinit>
  ioapicinit();    // another interrupt controller
80102f0c:	e8 af f2 ff ff       	call   801021c0 <ioapicinit>
  consoleinit();   // console hardware
80102f11:	e8 6a da ff ff       	call   80100980 <consoleinit>
  uartinit();      // serial port
80102f16:	e8 b5 2c 00 00       	call   80105bd0 <uartinit>
  pinit();         // process table
80102f1b:	e8 10 09 00 00       	call   80103830 <pinit>
  tvinit();        // trap vectors
80102f20:	e8 0b 29 00 00       	call   80105830 <tvinit>
  binit();         // buffer cache
80102f25:	e8 16 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f2a:	e8 f1 dd ff ff       	call   80100d20 <fileinit>
  ideinit();       // disk
80102f2f:	e8 6c f0 ff ff       	call   80101fa0 <ideinit>
  if(!ismp)
80102f34:	a1 24 13 11 80       	mov    0x80111324,%eax
80102f39:	83 c4 10             	add    $0x10,%esp
80102f3c:	85 c0                	test   %eax,%eax
80102f3e:	0f 84 dc 00 00 00    	je     80103020 <main+0x160>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f44:	83 ec 04             	sub    $0x4,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80102f47:	bb 40 13 11 80       	mov    $0x80111340,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f4c:	68 8a 00 00 00       	push   $0x8a
80102f51:	68 8c a4 10 80       	push   $0x8010a48c
80102f56:	68 00 70 00 80       	push   $0x80007000
80102f5b:	e8 c0 15 00 00       	call   80104520 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102f60:	69 05 20 19 11 80 bc 	imul   $0xbc,0x80111920,%eax
80102f67:	00 00 00 
80102f6a:	83 c4 10             	add    $0x10,%esp
80102f6d:	05 40 13 11 80       	add    $0x80111340,%eax
80102f72:	39 d8                	cmp    %ebx,%eax
80102f74:	76 7d                	jbe    80102ff3 <main+0x133>
80102f76:	8d 76 00             	lea    0x0(%esi),%esi
80102f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == cpus+cpunum())  // We've started already.
80102f80:	e8 4b f7 ff ff       	call   801026d0 <cpunum>
80102f85:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80102f8b:	05 40 13 11 80       	add    $0x80111340,%eax
80102f90:	39 c3                	cmp    %eax,%ebx
80102f92:	74 46                	je     80102fda <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f94:	e8 d7 f4 ff ff       	call   80102470 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f99:	83 ec 08             	sub    $0x8,%esp

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f9c:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102fa1:	c7 05 f8 6f 00 80 a0 	movl   $0x80102ea0,0x80006ff8
80102fa8:	2e 10 80 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fab:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102fb0:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102fb7:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102fba:	68 00 70 00 00       	push   $0x7000
80102fbf:	0f b6 03             	movzbl (%ebx),%eax
80102fc2:	50                   	push   %eax
80102fc3:	e8 d8 f7 ff ff       	call   801027a0 <lapicstartap>
80102fc8:	83 c4 10             	add    $0x10,%esp
80102fcb:	90                   	nop
80102fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102fd0:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
80102fd6:	85 c0                	test   %eax,%eax
80102fd8:	74 f6                	je     80102fd0 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102fda:	69 05 20 19 11 80 bc 	imul   $0xbc,0x80111920,%eax
80102fe1:	00 00 00 
80102fe4:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
80102fea:	05 40 13 11 80       	add    $0x80111340,%eax
80102fef:	39 c3                	cmp    %eax,%ebx
80102ff1:	72 8d                	jb     80102f80 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102ff3:	83 ec 08             	sub    $0x8,%esp
80102ff6:	68 00 00 00 8e       	push   $0x8e000000
80102ffb:	68 00 00 40 80       	push   $0x80400000
80103000:	e8 0b f4 ff ff       	call   80102410 <kinit2>
  userinit();      // first user process
80103005:	e8 46 08 00 00       	call   80103850 <userinit>
  initlock(&semlock, "sem");
8010300a:	58                   	pop    %eax
8010300b:	5a                   	pop    %edx
8010300c:	68 e8 75 10 80       	push   $0x801075e8
80103011:	68 80 38 11 80       	push   $0x80113880
80103016:	e8 05 12 00 00       	call   80104220 <initlock>
  mpmain();        // finish this processor's setup
8010301b:	e8 40 fe ff ff       	call   80102e60 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
80103020:	e8 ab 27 00 00       	call   801057d0 <timerinit>
80103025:	e9 1a ff ff ff       	jmp    80102f44 <main+0x84>
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	57                   	push   %edi
80103034:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103035:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010303b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010303c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010303f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103042:	39 de                	cmp    %ebx,%esi
80103044:	73 48                	jae    8010308e <mpsearch1+0x5e>
80103046:	8d 76 00             	lea    0x0(%esi),%esi
80103049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103050:	83 ec 04             	sub    $0x4,%esp
80103053:	8d 7e 10             	lea    0x10(%esi),%edi
80103056:	6a 04                	push   $0x4
80103058:	68 ec 75 10 80       	push   $0x801075ec
8010305d:	56                   	push   %esi
8010305e:	e8 5d 14 00 00       	call   801044c0 <memcmp>
80103063:	83 c4 10             	add    $0x10,%esp
80103066:	85 c0                	test   %eax,%eax
80103068:	75 1e                	jne    80103088 <mpsearch1+0x58>
8010306a:	8d 7e 10             	lea    0x10(%esi),%edi
8010306d:	89 f2                	mov    %esi,%edx
8010306f:	31 c9                	xor    %ecx,%ecx
80103071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103078:	0f b6 02             	movzbl (%edx),%eax
8010307b:	83 c2 01             	add    $0x1,%edx
8010307e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103080:	39 fa                	cmp    %edi,%edx
80103082:	75 f4                	jne    80103078 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103084:	84 c9                	test   %cl,%cl
80103086:	74 10                	je     80103098 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103088:	39 fb                	cmp    %edi,%ebx
8010308a:	89 fe                	mov    %edi,%esi
8010308c:	77 c2                	ja     80103050 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010308e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103091:	31 c0                	xor    %eax,%eax
}
80103093:	5b                   	pop    %ebx
80103094:	5e                   	pop    %esi
80103095:	5f                   	pop    %edi
80103096:	5d                   	pop    %ebp
80103097:	c3                   	ret    
80103098:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010309b:	89 f0                	mov    %esi,%eax
8010309d:	5b                   	pop    %ebx
8010309e:	5e                   	pop    %esi
8010309f:	5f                   	pop    %edi
801030a0:	5d                   	pop    %ebp
801030a1:	c3                   	ret    
801030a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030b0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801030b0:	55                   	push   %ebp
801030b1:	89 e5                	mov    %esp,%ebp
801030b3:	57                   	push   %edi
801030b4:	56                   	push   %esi
801030b5:	53                   	push   %ebx
801030b6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801030b9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030c0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030c7:	c1 e0 08             	shl    $0x8,%eax
801030ca:	09 d0                	or     %edx,%eax
801030cc:	c1 e0 04             	shl    $0x4,%eax
801030cf:	85 c0                	test   %eax,%eax
801030d1:	75 1b                	jne    801030ee <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801030d3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030da:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801030e1:	c1 e0 08             	shl    $0x8,%eax
801030e4:	09 d0                	or     %edx,%eax
801030e6:	c1 e0 0a             	shl    $0xa,%eax
801030e9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801030ee:	ba 00 04 00 00       	mov    $0x400,%edx
801030f3:	e8 38 ff ff ff       	call   80103030 <mpsearch1>
801030f8:	85 c0                	test   %eax,%eax
801030fa:	89 c6                	mov    %eax,%esi
801030fc:	0f 84 66 01 00 00    	je     80103268 <mpinit+0x1b8>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103102:	8b 5e 04             	mov    0x4(%esi),%ebx
80103105:	85 db                	test   %ebx,%ebx
80103107:	0f 84 d6 00 00 00    	je     801031e3 <mpinit+0x133>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010310d:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103113:	83 ec 04             	sub    $0x4,%esp
80103116:	6a 04                	push   $0x4
80103118:	68 f1 75 10 80       	push   $0x801075f1
8010311d:	50                   	push   %eax
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010311e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103121:	e8 9a 13 00 00       	call   801044c0 <memcmp>
80103126:	83 c4 10             	add    $0x10,%esp
80103129:	85 c0                	test   %eax,%eax
8010312b:	0f 85 b2 00 00 00    	jne    801031e3 <mpinit+0x133>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103131:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103138:	3c 01                	cmp    $0x1,%al
8010313a:	74 08                	je     80103144 <mpinit+0x94>
8010313c:	3c 04                	cmp    $0x4,%al
8010313e:	0f 85 9f 00 00 00    	jne    801031e3 <mpinit+0x133>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103144:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010314b:	85 ff                	test   %edi,%edi
8010314d:	74 1e                	je     8010316d <mpinit+0xbd>
8010314f:	31 d2                	xor    %edx,%edx
80103151:	31 c0                	xor    %eax,%eax
80103153:	90                   	nop
80103154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103158:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010315f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103160:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103163:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103165:	39 c7                	cmp    %eax,%edi
80103167:	75 ef                	jne    80103158 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103169:	84 d2                	test   %dl,%dl
8010316b:	75 76                	jne    801031e3 <mpinit+0x133>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
8010316d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103170:	85 ff                	test   %edi,%edi
80103172:	74 6f                	je     801031e3 <mpinit+0x133>
    return;
  ismp = 1;
80103174:	c7 05 24 13 11 80 01 	movl   $0x1,0x80111324
8010317b:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010317e:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103184:	a3 dc 11 11 80       	mov    %eax,0x801111dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103189:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
80103190:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103196:	01 f9                	add    %edi,%ecx
80103198:	39 c8                	cmp    %ecx,%eax
8010319a:	0f 83 a0 00 00 00    	jae    80103240 <mpinit+0x190>
    switch(*p){
801031a0:	80 38 04             	cmpb   $0x4,(%eax)
801031a3:	0f 87 87 00 00 00    	ja     80103230 <mpinit+0x180>
801031a9:	0f b6 10             	movzbl (%eax),%edx
801031ac:	ff 24 95 f8 75 10 80 	jmp    *-0x7fef8a08(,%edx,4)
801031b3:	90                   	nop
801031b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801031b8:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031bb:	39 c1                	cmp    %eax,%ecx
801031bd:	77 e1                	ja     801031a0 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
801031bf:	a1 24 13 11 80       	mov    0x80111324,%eax
801031c4:	85 c0                	test   %eax,%eax
801031c6:	75 78                	jne    80103240 <mpinit+0x190>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801031c8:	c7 05 20 19 11 80 01 	movl   $0x1,0x80111920
801031cf:	00 00 00 
    lapic = 0;
801031d2:	c7 05 dc 11 11 80 00 	movl   $0x0,0x801111dc
801031d9:	00 00 00 
    ioapicid = 0;
801031dc:	c6 05 20 13 11 80 00 	movb   $0x0,0x80111320
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801031e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031e6:	5b                   	pop    %ebx
801031e7:	5e                   	pop    %esi
801031e8:	5f                   	pop    %edi
801031e9:	5d                   	pop    %ebp
801031ea:	c3                   	ret    
801031eb:	90                   	nop
801031ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801031f0:	8b 15 20 19 11 80    	mov    0x80111920,%edx
801031f6:	83 fa 07             	cmp    $0x7,%edx
801031f9:	7f 19                	jg     80103214 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801031fb:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
801031ff:	69 fa bc 00 00 00    	imul   $0xbc,%edx,%edi
        ncpu++;
80103205:	83 c2 01             	add    $0x1,%edx
80103208:	89 15 20 19 11 80    	mov    %edx,0x80111920
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010320e:	88 9f 40 13 11 80    	mov    %bl,-0x7feeecc0(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
80103214:	83 c0 14             	add    $0x14,%eax
      continue;
80103217:	eb a2                	jmp    801031bb <mpinit+0x10b>
80103219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103220:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103224:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103227:	88 15 20 13 11 80    	mov    %dl,0x80111320
      p += sizeof(struct mpioapic);
      continue;
8010322d:	eb 8c                	jmp    801031bb <mpinit+0x10b>
8010322f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103230:	c7 05 24 13 11 80 00 	movl   $0x0,0x80111324
80103237:	00 00 00 
      break;
8010323a:	e9 7c ff ff ff       	jmp    801031bb <mpinit+0x10b>
8010323f:	90                   	nop
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
80103240:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103244:	74 9d                	je     801031e3 <mpinit+0x133>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103246:	ba 22 00 00 00       	mov    $0x22,%edx
8010324b:	b8 70 00 00 00       	mov    $0x70,%eax
80103250:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103251:	ba 23 00 00 00       	mov    $0x23,%edx
80103256:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103257:	83 c8 01             	or     $0x1,%eax
8010325a:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010325b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010325e:	5b                   	pop    %ebx
8010325f:	5e                   	pop    %esi
80103260:	5f                   	pop    %edi
80103261:	5d                   	pop    %ebp
80103262:	c3                   	ret    
80103263:	90                   	nop
80103264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103268:	ba 00 00 01 00       	mov    $0x10000,%edx
8010326d:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103272:	e8 b9 fd ff ff       	call   80103030 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103277:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103279:	89 c6                	mov    %eax,%esi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010327b:	0f 85 81 fe ff ff    	jne    80103102 <mpinit+0x52>
80103281:	e9 5d ff ff ff       	jmp    801031e3 <mpinit+0x133>
80103286:	66 90                	xchg   %ax,%ax
80103288:	66 90                	xchg   %ax,%ax
8010328a:	66 90                	xchg   %ax,%ax
8010328c:	66 90                	xchg   %ax,%ax
8010328e:	66 90                	xchg   %ax,%ax

80103290 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103290:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103291:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103296:	ba 21 00 00 00       	mov    $0x21,%edx
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
8010329b:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
8010329d:	8b 4d 08             	mov    0x8(%ebp),%ecx
801032a0:	d3 c0                	rol    %cl,%eax
801032a2:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
801032a9:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
801032af:	ee                   	out    %al,(%dx)
801032b0:	ba a1 00 00 00       	mov    $0xa1,%edx
801032b5:	66 c1 e8 08          	shr    $0x8,%ax
801032b9:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
801032ba:	5d                   	pop    %ebp
801032bb:	c3                   	ret    
801032bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032c0 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
801032c0:	55                   	push   %ebp
801032c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032c6:	89 e5                	mov    %esp,%ebp
801032c8:	57                   	push   %edi
801032c9:	56                   	push   %esi
801032ca:	53                   	push   %ebx
801032cb:	bb 21 00 00 00       	mov    $0x21,%ebx
801032d0:	89 da                	mov    %ebx,%edx
801032d2:	ee                   	out    %al,(%dx)
801032d3:	b9 a1 00 00 00       	mov    $0xa1,%ecx
801032d8:	89 ca                	mov    %ecx,%edx
801032da:	ee                   	out    %al,(%dx)
801032db:	bf 11 00 00 00       	mov    $0x11,%edi
801032e0:	be 20 00 00 00       	mov    $0x20,%esi
801032e5:	89 f8                	mov    %edi,%eax
801032e7:	89 f2                	mov    %esi,%edx
801032e9:	ee                   	out    %al,(%dx)
801032ea:	b8 20 00 00 00       	mov    $0x20,%eax
801032ef:	89 da                	mov    %ebx,%edx
801032f1:	ee                   	out    %al,(%dx)
801032f2:	b8 04 00 00 00       	mov    $0x4,%eax
801032f7:	ee                   	out    %al,(%dx)
801032f8:	b8 03 00 00 00       	mov    $0x3,%eax
801032fd:	ee                   	out    %al,(%dx)
801032fe:	bb a0 00 00 00       	mov    $0xa0,%ebx
80103303:	89 f8                	mov    %edi,%eax
80103305:	89 da                	mov    %ebx,%edx
80103307:	ee                   	out    %al,(%dx)
80103308:	b8 28 00 00 00       	mov    $0x28,%eax
8010330d:	89 ca                	mov    %ecx,%edx
8010330f:	ee                   	out    %al,(%dx)
80103310:	b8 02 00 00 00       	mov    $0x2,%eax
80103315:	ee                   	out    %al,(%dx)
80103316:	b8 03 00 00 00       	mov    $0x3,%eax
8010331b:	ee                   	out    %al,(%dx)
8010331c:	bf 68 00 00 00       	mov    $0x68,%edi
80103321:	89 f2                	mov    %esi,%edx
80103323:	89 f8                	mov    %edi,%eax
80103325:	ee                   	out    %al,(%dx)
80103326:	b9 0a 00 00 00       	mov    $0xa,%ecx
8010332b:	89 c8                	mov    %ecx,%eax
8010332d:	ee                   	out    %al,(%dx)
8010332e:	89 f8                	mov    %edi,%eax
80103330:	89 da                	mov    %ebx,%edx
80103332:	ee                   	out    %al,(%dx)
80103333:	89 c8                	mov    %ecx,%eax
80103335:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
80103336:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
8010333d:	66 83 f8 ff          	cmp    $0xffff,%ax
80103341:	74 10                	je     80103353 <picinit+0x93>
80103343:	ba 21 00 00 00       	mov    $0x21,%edx
80103348:	ee                   	out    %al,(%dx)
80103349:	ba a1 00 00 00       	mov    $0xa1,%edx
8010334e:	66 c1 e8 08          	shr    $0x8,%ax
80103352:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
80103353:	5b                   	pop    %ebx
80103354:	5e                   	pop    %esi
80103355:	5f                   	pop    %edi
80103356:	5d                   	pop    %ebp
80103357:	c3                   	ret    
80103358:	66 90                	xchg   %ax,%ax
8010335a:	66 90                	xchg   %ax,%ax
8010335c:	66 90                	xchg   %ax,%ax
8010335e:	66 90                	xchg   %ax,%ax

80103360 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	57                   	push   %edi
80103364:	56                   	push   %esi
80103365:	53                   	push   %ebx
80103366:	83 ec 0c             	sub    $0xc,%esp
80103369:	8b 75 08             	mov    0x8(%ebp),%esi
8010336c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010336f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103375:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010337b:	e8 c0 d9 ff ff       	call   80100d40 <filealloc>
80103380:	85 c0                	test   %eax,%eax
80103382:	89 06                	mov    %eax,(%esi)
80103384:	0f 84 a8 00 00 00    	je     80103432 <pipealloc+0xd2>
8010338a:	e8 b1 d9 ff ff       	call   80100d40 <filealloc>
8010338f:	85 c0                	test   %eax,%eax
80103391:	89 03                	mov    %eax,(%ebx)
80103393:	0f 84 87 00 00 00    	je     80103420 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103399:	e8 d2 f0 ff ff       	call   80102470 <kalloc>
8010339e:	85 c0                	test   %eax,%eax
801033a0:	89 c7                	mov    %eax,%edi
801033a2:	0f 84 b0 00 00 00    	je     80103458 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801033a8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
801033ab:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801033b2:	00 00 00 
  p->writeopen = 1;
801033b5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801033bc:	00 00 00 
  p->nwrite = 0;
801033bf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801033c6:	00 00 00 
  p->nread = 0;
801033c9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801033d0:	00 00 00 
  initlock(&p->lock, "pipe");
801033d3:	68 0c 76 10 80       	push   $0x8010760c
801033d8:	50                   	push   %eax
801033d9:	e8 42 0e 00 00       	call   80104220 <initlock>
  (*f0)->type = FD_PIPE;
801033de:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801033e0:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
801033e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801033e9:	8b 06                	mov    (%esi),%eax
801033eb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801033ef:	8b 06                	mov    (%esi),%eax
801033f1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033f5:	8b 06                	mov    (%esi),%eax
801033f7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033fa:	8b 03                	mov    (%ebx),%eax
801033fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103402:	8b 03                	mov    (%ebx),%eax
80103404:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103408:	8b 03                	mov    (%ebx),%eax
8010340a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010340e:	8b 03                	mov    (%ebx),%eax
80103410:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103413:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103416:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103418:	5b                   	pop    %ebx
80103419:	5e                   	pop    %esi
8010341a:	5f                   	pop    %edi
8010341b:	5d                   	pop    %ebp
8010341c:	c3                   	ret    
8010341d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103420:	8b 06                	mov    (%esi),%eax
80103422:	85 c0                	test   %eax,%eax
80103424:	74 1e                	je     80103444 <pipealloc+0xe4>
    fileclose(*f0);
80103426:	83 ec 0c             	sub    $0xc,%esp
80103429:	50                   	push   %eax
8010342a:	e8 d1 d9 ff ff       	call   80100e00 <fileclose>
8010342f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103432:	8b 03                	mov    (%ebx),%eax
80103434:	85 c0                	test   %eax,%eax
80103436:	74 0c                	je     80103444 <pipealloc+0xe4>
    fileclose(*f1);
80103438:	83 ec 0c             	sub    $0xc,%esp
8010343b:	50                   	push   %eax
8010343c:	e8 bf d9 ff ff       	call   80100e00 <fileclose>
80103441:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103444:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103447:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010344c:	5b                   	pop    %ebx
8010344d:	5e                   	pop    %esi
8010344e:	5f                   	pop    %edi
8010344f:	5d                   	pop    %ebp
80103450:	c3                   	ret    
80103451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103458:	8b 06                	mov    (%esi),%eax
8010345a:	85 c0                	test   %eax,%eax
8010345c:	75 c8                	jne    80103426 <pipealloc+0xc6>
8010345e:	eb d2                	jmp    80103432 <pipealloc+0xd2>

80103460 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	56                   	push   %esi
80103464:	53                   	push   %ebx
80103465:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103468:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010346b:	83 ec 0c             	sub    $0xc,%esp
8010346e:	53                   	push   %ebx
8010346f:	e8 cc 0d 00 00       	call   80104240 <acquire>
  if(writable){
80103474:	83 c4 10             	add    $0x10,%esp
80103477:	85 f6                	test   %esi,%esi
80103479:	74 45                	je     801034c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010347b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103481:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103484:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010348b:	00 00 00 
    wakeup(&p->nread);
8010348e:	50                   	push   %eax
8010348f:	e8 0c 0b 00 00       	call   80103fa0 <wakeup>
80103494:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103497:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010349d:	85 d2                	test   %edx,%edx
8010349f:	75 0a                	jne    801034ab <pipeclose+0x4b>
801034a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801034a7:	85 c0                	test   %eax,%eax
801034a9:	74 35                	je     801034e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801034ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034b1:	5b                   	pop    %ebx
801034b2:	5e                   	pop    %esi
801034b3:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801034b4:	e9 67 0f 00 00       	jmp    80104420 <release>
801034b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801034c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801034c6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801034c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801034d0:	00 00 00 
    wakeup(&p->nwrite);
801034d3:	50                   	push   %eax
801034d4:	e8 c7 0a 00 00       	call   80103fa0 <wakeup>
801034d9:	83 c4 10             	add    $0x10,%esp
801034dc:	eb b9                	jmp    80103497 <pipeclose+0x37>
801034de:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801034e0:	83 ec 0c             	sub    $0xc,%esp
801034e3:	53                   	push   %ebx
801034e4:	e8 37 0f 00 00       	call   80104420 <release>
    kfree((char*)p);
801034e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801034ec:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
801034ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034f2:	5b                   	pop    %ebx
801034f3:	5e                   	pop    %esi
801034f4:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801034f5:	e9 c6 ed ff ff       	jmp    801022c0 <kfree>
801034fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103500 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	57                   	push   %edi
80103504:	56                   	push   %esi
80103505:	53                   	push   %ebx
80103506:	83 ec 28             	sub    $0x28,%esp
80103509:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010350c:	57                   	push   %edi
8010350d:	e8 2e 0d 00 00       	call   80104240 <acquire>
  for(i = 0; i < n; i++){
80103512:	8b 45 10             	mov    0x10(%ebp),%eax
80103515:	83 c4 10             	add    $0x10,%esp
80103518:	85 c0                	test   %eax,%eax
8010351a:	0f 8e c6 00 00 00    	jle    801035e6 <pipewrite+0xe6>
80103520:	8b 45 0c             	mov    0xc(%ebp),%eax
80103523:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
80103529:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
8010352f:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
80103535:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103538:	03 45 10             	add    0x10(%ebp),%eax
8010353b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010353e:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103544:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010354a:	39 d1                	cmp    %edx,%ecx
8010354c:	0f 85 cf 00 00 00    	jne    80103621 <pipewrite+0x121>
      if(p->readopen == 0 || proc->killed){
80103552:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
80103558:	85 d2                	test   %edx,%edx
8010355a:	0f 84 a8 00 00 00    	je     80103608 <pipewrite+0x108>
80103560:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103567:	8b 42 24             	mov    0x24(%edx),%eax
8010356a:	85 c0                	test   %eax,%eax
8010356c:	74 25                	je     80103593 <pipewrite+0x93>
8010356e:	e9 95 00 00 00       	jmp    80103608 <pipewrite+0x108>
80103573:	90                   	nop
80103574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103578:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
8010357e:	85 c0                	test   %eax,%eax
80103580:	0f 84 82 00 00 00    	je     80103608 <pipewrite+0x108>
80103586:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010358c:	8b 40 24             	mov    0x24(%eax),%eax
8010358f:	85 c0                	test   %eax,%eax
80103591:	75 75                	jne    80103608 <pipewrite+0x108>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103593:	83 ec 0c             	sub    $0xc,%esp
80103596:	56                   	push   %esi
80103597:	e8 04 0a 00 00       	call   80103fa0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010359c:	59                   	pop    %ecx
8010359d:	58                   	pop    %eax
8010359e:	57                   	push   %edi
8010359f:	53                   	push   %ebx
801035a0:	e8 5b 08 00 00       	call   80103e00 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035a5:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801035ab:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
801035b1:	83 c4 10             	add    $0x10,%esp
801035b4:	05 00 02 00 00       	add    $0x200,%eax
801035b9:	39 c2                	cmp    %eax,%edx
801035bb:	74 bb                	je     80103578 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035c0:	8d 4a 01             	lea    0x1(%edx),%ecx
801035c3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801035c7:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801035cd:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
801035d3:	0f b6 00             	movzbl (%eax),%eax
801035d6:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
801035da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801035dd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
801035e0:	0f 85 58 ff ff ff    	jne    8010353e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801035e6:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
801035ec:	83 ec 0c             	sub    $0xc,%esp
801035ef:	52                   	push   %edx
801035f0:	e8 ab 09 00 00       	call   80103fa0 <wakeup>
  release(&p->lock);
801035f5:	89 3c 24             	mov    %edi,(%esp)
801035f8:	e8 23 0e 00 00       	call   80104420 <release>
  return n;
801035fd:	83 c4 10             	add    $0x10,%esp
80103600:	8b 45 10             	mov    0x10(%ebp),%eax
80103603:	eb 14                	jmp    80103619 <pipewrite+0x119>
80103605:	8d 76 00             	lea    0x0(%esi),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103608:	83 ec 0c             	sub    $0xc,%esp
8010360b:	57                   	push   %edi
8010360c:	e8 0f 0e 00 00       	call   80104420 <release>
        return -1;
80103611:	83 c4 10             	add    $0x10,%esp
80103614:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103619:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010361c:	5b                   	pop    %ebx
8010361d:	5e                   	pop    %esi
8010361e:	5f                   	pop    %edi
8010361f:	5d                   	pop    %ebp
80103620:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103621:	89 ca                	mov    %ecx,%edx
80103623:	eb 98                	jmp    801035bd <pipewrite+0xbd>
80103625:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103630 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	57                   	push   %edi
80103634:	56                   	push   %esi
80103635:	53                   	push   %ebx
80103636:	83 ec 18             	sub    $0x18,%esp
80103639:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010363c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010363f:	53                   	push   %ebx
80103640:	e8 fb 0b 00 00       	call   80104240 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103645:	83 c4 10             	add    $0x10,%esp
80103648:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010364e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103654:	75 6a                	jne    801036c0 <piperead+0x90>
80103656:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010365c:	85 f6                	test   %esi,%esi
8010365e:	0f 84 cc 00 00 00    	je     80103730 <piperead+0x100>
80103664:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010366a:	eb 2d                	jmp    80103699 <piperead+0x69>
8010366c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103670:	83 ec 08             	sub    $0x8,%esp
80103673:	53                   	push   %ebx
80103674:	56                   	push   %esi
80103675:	e8 86 07 00 00       	call   80103e00 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010367a:	83 c4 10             	add    $0x10,%esp
8010367d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103683:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103689:	75 35                	jne    801036c0 <piperead+0x90>
8010368b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103691:	85 d2                	test   %edx,%edx
80103693:	0f 84 97 00 00 00    	je     80103730 <piperead+0x100>
    if(proc->killed){
80103699:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801036a0:	8b 4a 24             	mov    0x24(%edx),%ecx
801036a3:	85 c9                	test   %ecx,%ecx
801036a5:	74 c9                	je     80103670 <piperead+0x40>
      release(&p->lock);
801036a7:	83 ec 0c             	sub    $0xc,%esp
801036aa:	53                   	push   %ebx
801036ab:	e8 70 0d 00 00       	call   80104420 <release>
      return -1;
801036b0:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036b3:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
801036b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801036bb:	5b                   	pop    %ebx
801036bc:	5e                   	pop    %esi
801036bd:	5f                   	pop    %edi
801036be:	5d                   	pop    %ebp
801036bf:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036c0:	8b 45 10             	mov    0x10(%ebp),%eax
801036c3:	85 c0                	test   %eax,%eax
801036c5:	7e 69                	jle    80103730 <piperead+0x100>
    if(p->nread == p->nwrite)
801036c7:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801036cd:	31 c9                	xor    %ecx,%ecx
801036cf:	eb 15                	jmp    801036e6 <piperead+0xb6>
801036d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036d8:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801036de:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
801036e4:	74 5a                	je     80103740 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801036e6:	8d 72 01             	lea    0x1(%edx),%esi
801036e9:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036ef:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
801036f5:	0f b6 54 13 34       	movzbl 0x34(%ebx,%edx,1),%edx
801036fa:	88 14 0f             	mov    %dl,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036fd:	83 c1 01             	add    $0x1,%ecx
80103700:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103703:	75 d3                	jne    801036d8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103705:	8d 93 38 02 00 00    	lea    0x238(%ebx),%edx
8010370b:	83 ec 0c             	sub    $0xc,%esp
8010370e:	52                   	push   %edx
8010370f:	e8 8c 08 00 00       	call   80103fa0 <wakeup>
  release(&p->lock);
80103714:	89 1c 24             	mov    %ebx,(%esp)
80103717:	e8 04 0d 00 00       	call   80104420 <release>
  return i;
8010371c:	8b 45 10             	mov    0x10(%ebp),%eax
8010371f:	83 c4 10             	add    $0x10,%esp
}
80103722:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103725:	5b                   	pop    %ebx
80103726:	5e                   	pop    %esi
80103727:	5f                   	pop    %edi
80103728:	5d                   	pop    %ebp
80103729:	c3                   	ret    
8010372a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103730:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103737:	eb cc                	jmp    80103705 <piperead+0xd5>
80103739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103740:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103743:	eb c0                	jmp    80103705 <piperead+0xd5>
80103745:	66 90                	xchg   %ax,%ax
80103747:	66 90                	xchg   %ax,%ax
80103749:	66 90                	xchg   %ax,%ax
8010374b:	66 90                	xchg   %ax,%ax
8010374d:	66 90                	xchg   %ax,%ax
8010374f:	90                   	nop

80103750 <allocproc>:
// state required to run in the kernel.
// Otherwise return 0.
// Must hold ptable.lock.
static struct proc*
allocproc(void)
{
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103754:	bb 74 19 11 80       	mov    $0x80111974,%ebx
// state required to run in the kernel.
// Otherwise return 0.
// Must hold ptable.lock.
static struct proc*
allocproc(void)
{
80103759:	83 ec 04             	sub    $0x4,%esp
8010375c:	eb 0d                	jmp    8010376b <allocproc+0x1b>
8010375e:	66 90                	xchg   %ax,%ax
  struct proc *p;
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103760:	83 c3 7c             	add    $0x7c,%ebx
80103763:	81 fb 74 38 11 80    	cmp    $0x80113874,%ebx
80103769:	74 65                	je     801037d0 <allocproc+0x80>
    if(p->state == UNUSED)
8010376b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010376e:	85 c0                	test   %eax,%eax
80103770:	75 ee                	jne    80103760 <allocproc+0x10>
      goto found;
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103772:	a1 08 a0 10 80       	mov    0x8010a008,%eax
    if(p->state == UNUSED)
      goto found;
  return 0;

found:
  p->state = EMBRYO;
80103777:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
8010377e:	8d 50 01             	lea    0x1(%eax),%edx
80103781:	89 43 10             	mov    %eax,0x10(%ebx)
80103784:	89 15 08 a0 10 80    	mov    %edx,0x8010a008

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010378a:	e8 e1 ec ff ff       	call   80102470 <kalloc>
8010378f:	85 c0                	test   %eax,%eax
80103791:	89 43 08             	mov    %eax,0x8(%ebx)
80103794:	74 41                	je     801037d7 <allocproc+0x87>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103796:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010379c:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010379f:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801037a4:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801037a7:	c7 40 14 1e 58 10 80 	movl   $0x8010581e,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801037ae:	6a 14                	push   $0x14
801037b0:	6a 00                	push   $0x0
801037b2:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801037b3:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801037b6:	e8 b5 0c 00 00       	call   80104470 <memset>
  p->context->eip = (uint)forkret;
801037bb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801037be:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
801037c1:	c7 40 10 e0 37 10 80 	movl   $0x801037e0,0x10(%eax)

  return p;
801037c8:	89 d8                	mov    %ebx,%eax
}
801037ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037cd:	c9                   	leave  
801037ce:	c3                   	ret    
801037cf:	90                   	nop
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  return 0;
801037d0:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801037d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037d5:	c9                   	leave  
801037d6:	c3                   	ret    
  p->state = EMBRYO;
  p->pid = nextpid++;

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801037d7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801037de:	eb ea                	jmp    801037ca <allocproc+0x7a>

801037e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801037e6:	68 40 19 11 80       	push   $0x80111940
801037eb:	e8 30 0c 00 00       	call   80104420 <release>

  if (first) {
801037f0:	a1 04 a0 10 80       	mov    0x8010a004,%eax
801037f5:	83 c4 10             	add    $0x10,%esp
801037f8:	85 c0                	test   %eax,%eax
801037fa:	75 04                	jne    80103800 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801037fc:	c9                   	leave  
801037fd:	c3                   	ret    
801037fe:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103800:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103803:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
8010380a:	00 00 00 
    iinit(ROOTDEV);
8010380d:	6a 01                	push   $0x1
8010380f:	e8 1c dc ff ff       	call   80101430 <iinit>
    initlog(ROOTDEV);
80103814:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010381b:	e8 f0 f2 ff ff       	call   80102b10 <initlog>
80103820:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103823:	c9                   	leave  
80103824:	c3                   	ret    
80103825:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103830 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103836:	68 11 76 10 80       	push   $0x80107611
8010383b:	68 40 19 11 80       	push   $0x80111940
80103840:	e8 db 09 00 00       	call   80104220 <initlock>
}
80103845:	83 c4 10             	add    $0x10,%esp
80103848:	c9                   	leave  
80103849:	c3                   	ret    
8010384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103850 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	53                   	push   %ebx
80103854:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  acquire(&ptable.lock);
80103857:	68 40 19 11 80       	push   $0x80111940
8010385c:	e8 df 09 00 00       	call   80104240 <acquire>

  p = allocproc();
80103861:	e8 ea fe ff ff       	call   80103750 <allocproc>
80103866:	89 c3                	mov    %eax,%ebx

  // release the lock in case namei() sleeps.
  // the lock isn't needed because no other
  // thread will look at an EMBRYO proc.
  release(&ptable.lock);
80103868:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
8010386f:	e8 ac 0b 00 00       	call   80104420 <release>
  
  initproc = p;
80103874:	89 1d bc a5 10 80    	mov    %ebx,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
8010387a:	e8 d1 31 00 00       	call   80106a50 <setupkvm>
8010387f:	83 c4 10             	add    $0x10,%esp
80103882:	85 c0                	test   %eax,%eax
80103884:	89 43 04             	mov    %eax,0x4(%ebx)
80103887:	0f 84 bd 00 00 00    	je     8010394a <userinit+0xfa>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010388d:	83 ec 04             	sub    $0x4,%esp
80103890:	68 2c 00 00 00       	push   $0x2c
80103895:	68 60 a4 10 80       	push   $0x8010a460
8010389a:	50                   	push   %eax
8010389b:	e8 00 33 00 00       	call   80106ba0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
801038a0:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
801038a3:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038a9:	6a 4c                	push   $0x4c
801038ab:	6a 00                	push   $0x0
801038ad:	ff 73 18             	pushl  0x18(%ebx)
801038b0:	e8 bb 0b 00 00       	call   80104470 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038b5:	8b 43 18             	mov    0x18(%ebx),%eax
801038b8:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038bd:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
801038c2:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038c5:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038c9:	8b 43 18             	mov    0x18(%ebx),%eax
801038cc:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801038d0:	8b 43 18             	mov    0x18(%ebx),%eax
801038d3:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038d7:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801038db:	8b 43 18             	mov    0x18(%ebx),%eax
801038de:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038e2:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801038e6:	8b 43 18             	mov    0x18(%ebx),%eax
801038e9:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801038f0:	8b 43 18             	mov    0x18(%ebx),%eax
801038f3:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801038fa:	8b 43 18             	mov    0x18(%ebx),%eax
801038fd:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103904:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103907:	6a 10                	push   $0x10
80103909:	68 31 76 10 80       	push   $0x80107631
8010390e:	50                   	push   %eax
8010390f:	e8 5c 0d 00 00       	call   80104670 <safestrcpy>
  p->cwd = namei("/");
80103914:	c7 04 24 3a 76 10 80 	movl   $0x8010763a,(%esp)
8010391b:	e8 70 e5 ff ff       	call   80101e90 <namei>
80103920:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103923:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
8010392a:	e8 11 09 00 00       	call   80104240 <acquire>

  p->state = RUNNABLE;
8010392f:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103936:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
8010393d:	e8 de 0a 00 00       	call   80104420 <release>
}
80103942:	83 c4 10             	add    $0x10,%esp
80103945:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103948:	c9                   	leave  
80103949:	c3                   	ret    
  // thread will look at an EMBRYO proc.
  release(&ptable.lock);
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
8010394a:	83 ec 0c             	sub    $0xc,%esp
8010394d:	68 18 76 10 80       	push   $0x80107618
80103952:	e8 f9 c9 ff ff       	call   80100350 <panic>
80103957:	89 f6                	mov    %esi,%esi
80103959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103960 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	83 ec 08             	sub    $0x8,%esp
  uint sz;

  sz = proc->sz;
80103966:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
8010396d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
80103970:	8b 02                	mov    (%edx),%eax
  if(n > 0){
80103972:	83 f9 00             	cmp    $0x0,%ecx
80103975:	7e 39                	jle    801039b0 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80103977:	83 ec 04             	sub    $0x4,%esp
8010397a:	01 c1                	add    %eax,%ecx
8010397c:	51                   	push   %ecx
8010397d:	50                   	push   %eax
8010397e:	ff 72 04             	pushl  0x4(%edx)
80103981:	e8 5a 33 00 00       	call   80106ce0 <allocuvm>
80103986:	83 c4 10             	add    $0x10,%esp
80103989:	85 c0                	test   %eax,%eax
8010398b:	74 3b                	je     801039c8 <growproc+0x68>
8010398d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
80103994:	89 02                	mov    %eax,(%edx)
  switchuvm(proc);
80103996:	83 ec 0c             	sub    $0xc,%esp
80103999:	65 ff 35 04 00 00 00 	pushl  %gs:0x4
801039a0:	e8 5b 31 00 00       	call   80106b00 <switchuvm>
  return 0;
801039a5:	83 c4 10             	add    $0x10,%esp
801039a8:	31 c0                	xor    %eax,%eax
}
801039aa:	c9                   	leave  
801039ab:	c3                   	ret    
801039ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801039b0:	74 e2                	je     80103994 <growproc+0x34>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801039b2:	83 ec 04             	sub    $0x4,%esp
801039b5:	01 c1                	add    %eax,%ecx
801039b7:	51                   	push   %ecx
801039b8:	50                   	push   %eax
801039b9:	ff 72 04             	pushl  0x4(%edx)
801039bc:	e8 1f 34 00 00       	call   80106de0 <deallocuvm>
801039c1:	83 c4 10             	add    $0x10,%esp
801039c4:	85 c0                	test   %eax,%eax
801039c6:	75 c5                	jne    8010398d <growproc+0x2d>
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
801039c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
801039cd:	c9                   	leave  
801039ce:	c3                   	ret    
801039cf:	90                   	nop

801039d0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801039d0:	55                   	push   %ebp
801039d1:	89 e5                	mov    %esp,%ebp
801039d3:	57                   	push   %edi
801039d4:	56                   	push   %esi
801039d5:	53                   	push   %ebx
801039d6:	83 ec 18             	sub    $0x18,%esp
  int i, pid;
  struct proc *np;

  acquire(&ptable.lock);
801039d9:	68 40 19 11 80       	push   $0x80111940
801039de:	e8 5d 08 00 00       	call   80104240 <acquire>

  // Allocate process.
  if((np = allocproc()) == 0){
801039e3:	e8 68 fd ff ff       	call   80103750 <allocproc>
801039e8:	83 c4 10             	add    $0x10,%esp
801039eb:	85 c0                	test   %eax,%eax
801039ed:	0f 84 e1 00 00 00    	je     80103ad4 <fork+0x104>
    release(&ptable.lock);
    return -1;
  }

  release(&ptable.lock);
801039f3:	83 ec 0c             	sub    $0xc,%esp
801039f6:	89 c3                	mov    %eax,%ebx
801039f8:	68 40 19 11 80       	push   $0x80111940
801039fd:	e8 1e 0a 00 00       	call   80104420 <release>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103a02:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a08:	5a                   	pop    %edx
80103a09:	59                   	pop    %ecx
80103a0a:	ff 30                	pushl  (%eax)
80103a0c:	ff 70 04             	pushl  0x4(%eax)
80103a0f:	e8 ac 34 00 00       	call   80106ec0 <copyuvm>
80103a14:	83 c4 10             	add    $0x10,%esp
80103a17:	85 c0                	test   %eax,%eax
80103a19:	89 43 04             	mov    %eax,0x4(%ebx)
80103a1c:	0f 84 c9 00 00 00    	je     80103aeb <fork+0x11b>
    np->kstack = 0;
    np->state = UNUSED;
    release(&ptable.lock);
    return -1;
  }
  np->sz = proc->sz;
80103a22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
80103a28:	8b 7b 18             	mov    0x18(%ebx),%edi
80103a2b:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->kstack = 0;
    np->state = UNUSED;
    release(&ptable.lock);
    return -1;
  }
  np->sz = proc->sz;
80103a30:	8b 00                	mov    (%eax),%eax
80103a32:	89 03                	mov    %eax,(%ebx)
  np->parent = proc;
80103a34:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a3a:	89 43 14             	mov    %eax,0x14(%ebx)
  *np->tf = *proc->tf;
80103a3d:	8b 70 18             	mov    0x18(%eax),%esi
80103a40:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a42:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103a44:	8b 43 18             	mov    0x18(%ebx),%eax
80103a47:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103a4e:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103a55:	8d 76 00             	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
80103a58:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103a5c:	85 c0                	test   %eax,%eax
80103a5e:	74 17                	je     80103a77 <fork+0xa7>
      np->ofile[i] = filedup(proc->ofile[i]);
80103a60:	83 ec 0c             	sub    $0xc,%esp
80103a63:	50                   	push   %eax
80103a64:	e8 47 d3 ff ff       	call   80100db0 <filedup>
80103a69:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
80103a6d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103a74:	83 c4 10             	add    $0x10,%esp
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a77:	83 c6 01             	add    $0x1,%esi
80103a7a:	83 fe 10             	cmp    $0x10,%esi
80103a7d:	75 d9                	jne    80103a58 <fork+0x88>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80103a7f:	83 ec 0c             	sub    $0xc,%esp
80103a82:	ff 72 68             	pushl  0x68(%edx)
80103a85:	e8 46 db ff ff       	call   801015d0 <idup>
80103a8a:	89 43 68             	mov    %eax,0x68(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103a8d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103a93:	83 c4 0c             	add    $0xc,%esp
80103a96:	6a 10                	push   $0x10
80103a98:	83 c0 6c             	add    $0x6c,%eax
80103a9b:	50                   	push   %eax
80103a9c:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103a9f:	50                   	push   %eax
80103aa0:	e8 cb 0b 00 00       	call   80104670 <safestrcpy>

  pid = np->pid;
80103aa5:	8b 73 10             	mov    0x10(%ebx),%esi

  acquire(&ptable.lock);
80103aa8:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80103aaf:	e8 8c 07 00 00       	call   80104240 <acquire>

  np->state = RUNNABLE;
80103ab4:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
80103abb:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80103ac2:	e8 59 09 00 00       	call   80104420 <release>

  return pid;
80103ac7:	83 c4 10             	add    $0x10,%esp
80103aca:	89 f0                	mov    %esi,%eax
}
80103acc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103acf:	5b                   	pop    %ebx
80103ad0:	5e                   	pop    %esi
80103ad1:	5f                   	pop    %edi
80103ad2:	5d                   	pop    %ebp
80103ad3:	c3                   	ret    

  acquire(&ptable.lock);

  // Allocate process.
  if((np = allocproc()) == 0){
    release(&ptable.lock);
80103ad4:	83 ec 0c             	sub    $0xc,%esp
80103ad7:	68 40 19 11 80       	push   $0x80111940
80103adc:	e8 3f 09 00 00       	call   80104420 <release>
    return -1;
80103ae1:	83 c4 10             	add    $0x10,%esp
80103ae4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ae9:	eb e1                	jmp    80103acc <fork+0xfc>

  release(&ptable.lock);

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103aeb:	83 ec 0c             	sub    $0xc,%esp
80103aee:	ff 73 08             	pushl  0x8(%ebx)
80103af1:	e8 ca e7 ff ff       	call   801022c0 <kfree>
    np->kstack = 0;
80103af6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103afd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    release(&ptable.lock);
80103b04:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80103b0b:	e8 10 09 00 00       	call   80104420 <release>
    return -1;
80103b10:	83 c4 10             	add    $0x10,%esp
80103b13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b18:	eb b2                	jmp    80103acc <fork+0xfc>
80103b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b20 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103b20:	55                   	push   %ebp
80103b21:	89 e5                	mov    %esp,%ebp
80103b23:	53                   	push   %ebx
80103b24:	83 ec 04             	sub    $0x4,%esp
80103b27:	89 f6                	mov    %esi,%esi
80103b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103b30:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b31:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b34:	bb 74 19 11 80       	mov    $0x80111974,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b39:	68 40 19 11 80       	push   $0x80111940
80103b3e:	e8 fd 06 00 00       	call   80104240 <acquire>
80103b43:	83 c4 10             	add    $0x10,%esp
80103b46:	eb 13                	jmp    80103b5b <scheduler+0x3b>
80103b48:	90                   	nop
80103b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b50:	83 c3 7c             	add    $0x7c,%ebx
80103b53:	81 fb 74 38 11 80    	cmp    $0x80113874,%ebx
80103b59:	74 55                	je     80103bb0 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103b5b:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b5f:	75 ef                	jne    80103b50 <scheduler+0x30>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103b61:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80103b64:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
      switchuvm(p);
80103b6b:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b6c:	83 c3 7c             	add    $0x7c,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103b6f:	e8 8c 2f 00 00       	call   80106b00 <switchuvm>
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103b74:	58                   	pop    %eax
80103b75:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103b7b:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)
      swtch(&cpu->scheduler, p->context);
80103b82:	5a                   	pop    %edx
80103b83:	ff 73 a0             	pushl  -0x60(%ebx)
80103b86:	83 c0 04             	add    $0x4,%eax
80103b89:	50                   	push   %eax
80103b8a:	e8 3c 0b 00 00       	call   801046cb <swtch>
      switchkvm();
80103b8f:	e8 4c 2f 00 00       	call   80106ae0 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103b94:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b97:	81 fb 74 38 11 80    	cmp    $0x80113874,%ebx
      swtch(&cpu->scheduler, p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103b9d:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103ba4:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ba8:	75 b1                	jne    80103b5b <scheduler+0x3b>
80103baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80103bb0:	83 ec 0c             	sub    $0xc,%esp
80103bb3:	68 40 19 11 80       	push   $0x80111940
80103bb8:	e8 63 08 00 00       	call   80104420 <release>

  }
80103bbd:	83 c4 10             	add    $0x10,%esp
80103bc0:	e9 6b ff ff ff       	jmp    80103b30 <scheduler+0x10>
80103bc5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bd0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	53                   	push   %ebx
80103bd4:	83 ec 10             	sub    $0x10,%esp
  int intena;

  if(!holding(&ptable.lock))
80103bd7:	68 40 19 11 80       	push   $0x80111940
80103bdc:	e8 8f 07 00 00       	call   80104370 <holding>
80103be1:	83 c4 10             	add    $0x10,%esp
80103be4:	85 c0                	test   %eax,%eax
80103be6:	74 4c                	je     80103c34 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80103be8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103bef:	83 ba ac 00 00 00 01 	cmpl   $0x1,0xac(%edx)
80103bf6:	75 63                	jne    80103c5b <sched+0x8b>
    panic("sched locks");
  if(proc->state == RUNNING)
80103bf8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103bfe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80103c02:	74 4a                	je     80103c4e <sched+0x7e>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c04:	9c                   	pushf  
80103c05:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103c06:	80 e5 02             	and    $0x2,%ch
80103c09:	75 36                	jne    80103c41 <sched+0x71>
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
80103c0b:	83 ec 08             	sub    $0x8,%esp
80103c0e:	83 c0 1c             	add    $0x1c,%eax
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
80103c11:	8b 9a b0 00 00 00    	mov    0xb0(%edx),%ebx
  swtch(&proc->context, cpu->scheduler);
80103c17:	ff 72 04             	pushl  0x4(%edx)
80103c1a:	50                   	push   %eax
80103c1b:	e8 ab 0a 00 00       	call   801046cb <swtch>
  cpu->intena = intena;
80103c20:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
}
80103c26:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
80103c29:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103c2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c32:	c9                   	leave  
80103c33:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103c34:	83 ec 0c             	sub    $0xc,%esp
80103c37:	68 3c 76 10 80       	push   $0x8010763c
80103c3c:	e8 0f c7 ff ff       	call   80100350 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103c41:	83 ec 0c             	sub    $0xc,%esp
80103c44:	68 68 76 10 80       	push   $0x80107668
80103c49:	e8 02 c7 ff ff       	call   80100350 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103c4e:	83 ec 0c             	sub    $0xc,%esp
80103c51:	68 5a 76 10 80       	push   $0x8010765a
80103c56:	e8 f5 c6 ff ff       	call   80100350 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103c5b:	83 ec 0c             	sub    $0xc,%esp
80103c5e:	68 4e 76 10 80       	push   $0x8010764e
80103c63:	e8 e8 c6 ff ff       	call   80100350 <panic>
80103c68:	90                   	nop
80103c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c70 <exit>:
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
80103c70:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103c77:	3b 15 bc a5 10 80    	cmp    0x8010a5bc,%edx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103c7d:	55                   	push   %ebp
80103c7e:	89 e5                	mov    %esp,%ebp
80103c80:	56                   	push   %esi
80103c81:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
80103c82:	0f 84 1f 01 00 00    	je     80103da7 <exit+0x137>
80103c88:	31 db                	xor    %ebx,%ebx
80103c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103c90:	8d 73 08             	lea    0x8(%ebx),%esi
80103c93:	8b 44 b2 08          	mov    0x8(%edx,%esi,4),%eax
80103c97:	85 c0                	test   %eax,%eax
80103c99:	74 1b                	je     80103cb6 <exit+0x46>
      fileclose(proc->ofile[fd]);
80103c9b:	83 ec 0c             	sub    $0xc,%esp
80103c9e:	50                   	push   %eax
80103c9f:	e8 5c d1 ff ff       	call   80100e00 <fileclose>
      proc->ofile[fd] = 0;
80103ca4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103cab:	83 c4 10             	add    $0x10,%esp
80103cae:	c7 44 b2 08 00 00 00 	movl   $0x0,0x8(%edx,%esi,4)
80103cb5:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103cb6:	83 c3 01             	add    $0x1,%ebx
80103cb9:	83 fb 10             	cmp    $0x10,%ebx
80103cbc:	75 d2                	jne    80103c90 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80103cbe:	e8 ed ee ff ff       	call   80102bb0 <begin_op>
  iput(proc->cwd);
80103cc3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103cc9:	83 ec 0c             	sub    $0xc,%esp
80103ccc:	ff 70 68             	pushl  0x68(%eax)
80103ccf:	e8 9c da ff ff       	call   80101770 <iput>
  end_op();
80103cd4:	e8 47 ef ff ff       	call   80102c20 <end_op>
  proc->cwd = 0;
80103cd9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103cdf:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80103ce6:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80103ced:	e8 4e 05 00 00       	call   80104240 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103cf2:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80103cf9:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cfc:	b8 74 19 11 80       	mov    $0x80111974,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103d01:	8b 51 14             	mov    0x14(%ecx),%edx
80103d04:	eb 14                	jmp    80103d1a <exit+0xaa>
80103d06:	8d 76 00             	lea    0x0(%esi),%esi
80103d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d10:	83 c0 7c             	add    $0x7c,%eax
80103d13:	3d 74 38 11 80       	cmp    $0x80113874,%eax
80103d18:	74 1c                	je     80103d36 <exit+0xc6>
    if(p->state == SLEEPING && p->chan == chan)
80103d1a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d1e:	75 f0                	jne    80103d10 <exit+0xa0>
80103d20:	3b 50 20             	cmp    0x20(%eax),%edx
80103d23:	75 eb                	jne    80103d10 <exit+0xa0>
      p->state = RUNNABLE;
80103d25:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d2c:	83 c0 7c             	add    $0x7c,%eax
80103d2f:	3d 74 38 11 80       	cmp    $0x80113874,%eax
80103d34:	75 e4                	jne    80103d1a <exit+0xaa>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103d36:	8b 1d bc a5 10 80    	mov    0x8010a5bc,%ebx
80103d3c:	ba 74 19 11 80       	mov    $0x80111974,%edx
80103d41:	eb 10                	jmp    80103d53 <exit+0xe3>
80103d43:	90                   	nop
80103d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d48:	83 c2 7c             	add    $0x7c,%edx
80103d4b:	81 fa 74 38 11 80    	cmp    $0x80113874,%edx
80103d51:	74 3b                	je     80103d8e <exit+0x11e>
    if(p->parent == proc){
80103d53:	3b 4a 14             	cmp    0x14(%edx),%ecx
80103d56:	75 f0                	jne    80103d48 <exit+0xd8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103d58:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103d5c:	89 5a 14             	mov    %ebx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d5f:	75 e7                	jne    80103d48 <exit+0xd8>
80103d61:	b8 74 19 11 80       	mov    $0x80111974,%eax
80103d66:	eb 12                	jmp    80103d7a <exit+0x10a>
80103d68:	90                   	nop
80103d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d70:	83 c0 7c             	add    $0x7c,%eax
80103d73:	3d 74 38 11 80       	cmp    $0x80113874,%eax
80103d78:	74 ce                	je     80103d48 <exit+0xd8>
    if(p->state == SLEEPING && p->chan == chan)
80103d7a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d7e:	75 f0                	jne    80103d70 <exit+0x100>
80103d80:	3b 58 20             	cmp    0x20(%eax),%ebx
80103d83:	75 eb                	jne    80103d70 <exit+0x100>
      p->state = RUNNABLE;
80103d85:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d8c:	eb e2                	jmp    80103d70 <exit+0x100>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80103d8e:	c7 41 0c 05 00 00 00 	movl   $0x5,0xc(%ecx)
  sched();
80103d95:	e8 36 fe ff ff       	call   80103bd0 <sched>
  panic("zombie exit");
80103d9a:	83 ec 0c             	sub    $0xc,%esp
80103d9d:	68 89 76 10 80       	push   $0x80107689
80103da2:	e8 a9 c5 ff ff       	call   80100350 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
80103da7:	83 ec 0c             	sub    $0xc,%esp
80103daa:	68 7c 76 10 80       	push   $0x8010767c
80103daf:	e8 9c c5 ff ff       	call   80100350 <panic>
80103db4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103dba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103dc0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103dc6:	68 40 19 11 80       	push   $0x80111940
80103dcb:	e8 70 04 00 00       	call   80104240 <acquire>
  proc->state = RUNNABLE;
80103dd0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103dd6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103ddd:	e8 ee fd ff ff       	call   80103bd0 <sched>
  release(&ptable.lock);
80103de2:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80103de9:	e8 32 06 00 00       	call   80104420 <release>
}
80103dee:	83 c4 10             	add    $0x10,%esp
80103df1:	c9                   	leave  
80103df2:	c3                   	ret    
80103df3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e00 <sleep>:
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
80103e00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103e06:	55                   	push   %ebp
80103e07:	89 e5                	mov    %esp,%ebp
80103e09:	56                   	push   %esi
80103e0a:	53                   	push   %ebx
  if(proc == 0)
80103e0b:	85 c0                	test   %eax,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103e0d:	8b 75 08             	mov    0x8(%ebp),%esi
80103e10:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103e13:	0f 84 97 00 00 00    	je     80103eb0 <sleep+0xb0>
    panic("sleep");

  if(lk == 0)
80103e19:	85 db                	test   %ebx,%ebx
80103e1b:	0f 84 82 00 00 00    	je     80103ea3 <sleep+0xa3>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e21:	81 fb 40 19 11 80    	cmp    $0x80111940,%ebx
80103e27:	74 57                	je     80103e80 <sleep+0x80>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e29:	83 ec 0c             	sub    $0xc,%esp
80103e2c:	68 40 19 11 80       	push   $0x80111940
80103e31:	e8 0a 04 00 00       	call   80104240 <acquire>
    release(lk);
80103e36:	89 1c 24             	mov    %ebx,(%esp)
80103e39:	e8 e2 05 00 00       	call   80104420 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80103e3e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e44:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103e47:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103e4e:	e8 7d fd ff ff       	call   80103bd0 <sched>

  // Tidy up.
  proc->chan = 0;
80103e53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e59:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103e60:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80103e67:	e8 b4 05 00 00       	call   80104420 <release>
    acquire(lk);
80103e6c:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103e6f:	83 c4 10             	add    $0x10,%esp
  }
}
80103e72:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e75:	5b                   	pop    %ebx
80103e76:	5e                   	pop    %esi
80103e77:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103e78:	e9 c3 03 00 00       	jmp    80104240 <acquire>
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103e80:	89 70 20             	mov    %esi,0x20(%eax)
  proc->state = SLEEPING;
80103e83:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103e8a:	e8 41 fd ff ff       	call   80103bd0 <sched>

  // Tidy up.
  proc->chan = 0;
80103e8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e95:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103e9c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e9f:	5b                   	pop    %ebx
80103ea0:	5e                   	pop    %esi
80103ea1:	5d                   	pop    %ebp
80103ea2:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103ea3:	83 ec 0c             	sub    $0xc,%esp
80103ea6:	68 9b 76 10 80       	push   $0x8010769b
80103eab:	e8 a0 c4 ff ff       	call   80100350 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80103eb0:	83 ec 0c             	sub    $0xc,%esp
80103eb3:	68 95 76 10 80       	push   $0x80107695
80103eb8:	e8 93 c4 ff ff       	call   80100350 <panic>
80103ebd:	8d 76 00             	lea    0x0(%esi),%esi

80103ec0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	56                   	push   %esi
80103ec4:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103ec5:	83 ec 0c             	sub    $0xc,%esp
80103ec8:	68 40 19 11 80       	push   $0x80111940
80103ecd:	e8 6e 03 00 00       	call   80104240 <acquire>
80103ed2:	83 c4 10             	add    $0x10,%esp
80103ed5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103edb:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103edd:	bb 74 19 11 80       	mov    $0x80111974,%ebx
80103ee2:	eb 0f                	jmp    80103ef3 <wait+0x33>
80103ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ee8:	83 c3 7c             	add    $0x7c,%ebx
80103eeb:	81 fb 74 38 11 80    	cmp    $0x80113874,%ebx
80103ef1:	74 1d                	je     80103f10 <wait+0x50>
      if(p->parent != proc)
80103ef3:	3b 43 14             	cmp    0x14(%ebx),%eax
80103ef6:	75 f0                	jne    80103ee8 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103ef8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103efc:	74 30                	je     80103f2e <wait+0x6e>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103efe:	83 c3 7c             	add    $0x7c,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80103f01:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f06:	81 fb 74 38 11 80    	cmp    $0x80113874,%ebx
80103f0c:	75 e5                	jne    80103ef3 <wait+0x33>
80103f0e:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80103f10:	85 d2                	test   %edx,%edx
80103f12:	74 70                	je     80103f84 <wait+0xc4>
80103f14:	8b 50 24             	mov    0x24(%eax),%edx
80103f17:	85 d2                	test   %edx,%edx
80103f19:	75 69                	jne    80103f84 <wait+0xc4>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80103f1b:	83 ec 08             	sub    $0x8,%esp
80103f1e:	68 40 19 11 80       	push   $0x80111940
80103f23:	50                   	push   %eax
80103f24:	e8 d7 fe ff ff       	call   80103e00 <sleep>
  }
80103f29:	83 c4 10             	add    $0x10,%esp
80103f2c:	eb a7                	jmp    80103ed5 <wait+0x15>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103f2e:	83 ec 0c             	sub    $0xc,%esp
80103f31:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103f34:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f37:	e8 84 e3 ff ff       	call   801022c0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103f3c:	59                   	pop    %ecx
80103f3d:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103f40:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f47:	e8 c4 2e 00 00       	call   80106e10 <freevm>
        p->pid = 0;
80103f4c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f53:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f5a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f5e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f65:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f6c:	c7 04 24 40 19 11 80 	movl   $0x80111940,(%esp)
80103f73:	e8 a8 04 00 00       	call   80104420 <release>
        return pid;
80103f78:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103f7e:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f80:	5b                   	pop    %ebx
80103f81:	5e                   	pop    %esi
80103f82:	5d                   	pop    %ebp
80103f83:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
80103f84:	83 ec 0c             	sub    $0xc,%esp
80103f87:	68 40 19 11 80       	push   $0x80111940
80103f8c:	e8 8f 04 00 00       	call   80104420 <release>
      return -1;
80103f91:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f94:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
80103f97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f9c:	5b                   	pop    %ebx
80103f9d:	5e                   	pop    %esi
80103f9e:	5d                   	pop    %ebp
80103f9f:	c3                   	ret    

80103fa0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	53                   	push   %ebx
80103fa4:	83 ec 10             	sub    $0x10,%esp
80103fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103faa:	68 40 19 11 80       	push   $0x80111940
80103faf:	e8 8c 02 00 00       	call   80104240 <acquire>
80103fb4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fb7:	b8 74 19 11 80       	mov    $0x80111974,%eax
80103fbc:	eb 0c                	jmp    80103fca <wakeup+0x2a>
80103fbe:	66 90                	xchg   %ax,%ax
80103fc0:	83 c0 7c             	add    $0x7c,%eax
80103fc3:	3d 74 38 11 80       	cmp    $0x80113874,%eax
80103fc8:	74 1c                	je     80103fe6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103fca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fce:	75 f0                	jne    80103fc0 <wakeup+0x20>
80103fd0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103fd3:	75 eb                	jne    80103fc0 <wakeup+0x20>
      p->state = RUNNABLE;
80103fd5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fdc:	83 c0 7c             	add    $0x7c,%eax
80103fdf:	3d 74 38 11 80       	cmp    $0x80113874,%eax
80103fe4:	75 e4                	jne    80103fca <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103fe6:	c7 45 08 40 19 11 80 	movl   $0x80111940,0x8(%ebp)
}
80103fed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ff0:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ff1:	e9 2a 04 00 00       	jmp    80104420 <release>
80103ff6:	8d 76 00             	lea    0x0(%esi),%esi
80103ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104000 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	53                   	push   %ebx
80104004:	83 ec 10             	sub    $0x10,%esp
80104007:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010400a:	68 40 19 11 80       	push   $0x80111940
8010400f:	e8 2c 02 00 00       	call   80104240 <acquire>
80104014:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104017:	b8 74 19 11 80       	mov    $0x80111974,%eax
8010401c:	eb 0c                	jmp    8010402a <kill+0x2a>
8010401e:	66 90                	xchg   %ax,%ax
80104020:	83 c0 7c             	add    $0x7c,%eax
80104023:	3d 74 38 11 80       	cmp    $0x80113874,%eax
80104028:	74 3e                	je     80104068 <kill+0x68>
    if(p->pid == pid){
8010402a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010402d:	75 f1                	jne    80104020 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010402f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104033:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010403a:	74 1c                	je     80104058 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010403c:	83 ec 0c             	sub    $0xc,%esp
8010403f:	68 40 19 11 80       	push   $0x80111940
80104044:	e8 d7 03 00 00       	call   80104420 <release>
      return 0;
80104049:	83 c4 10             	add    $0x10,%esp
8010404c:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010404e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104051:	c9                   	leave  
80104052:	c3                   	ret    
80104053:	90                   	nop
80104054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104058:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010405f:	eb db                	jmp    8010403c <kill+0x3c>
80104061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104068:	83 ec 0c             	sub    $0xc,%esp
8010406b:	68 40 19 11 80       	push   $0x80111940
80104070:	e8 ab 03 00 00       	call   80104420 <release>
  return -1;
80104075:	83 c4 10             	add    $0x10,%esp
80104078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010407d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104080:	c9                   	leave  
80104081:	c3                   	ret    
80104082:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104090 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	57                   	push   %edi
80104094:	56                   	push   %esi
80104095:	53                   	push   %ebx
80104096:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104099:	bb e0 19 11 80       	mov    $0x801119e0,%ebx
8010409e:	83 ec 3c             	sub    $0x3c,%esp
801040a1:	eb 24                	jmp    801040c7 <procdump+0x37>
801040a3:	90                   	nop
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801040a8:	83 ec 0c             	sub    $0xc,%esp
801040ab:	68 e6 75 10 80       	push   $0x801075e6
801040b0:	e8 8b c5 ff ff       	call   80100640 <cprintf>
801040b5:	83 c4 10             	add    $0x10,%esp
801040b8:	83 c3 7c             	add    $0x7c,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040bb:	81 fb e0 38 11 80    	cmp    $0x801138e0,%ebx
801040c1:	0f 84 81 00 00 00    	je     80104148 <procdump+0xb8>
    if(p->state == UNUSED)
801040c7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801040ca:	85 c0                	test   %eax,%eax
801040cc:	74 ea                	je     801040b8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040ce:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801040d1:	ba ac 76 10 80       	mov    $0x801076ac,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040d6:	77 11                	ja     801040e9 <procdump+0x59>
801040d8:	8b 14 85 e4 76 10 80 	mov    -0x7fef891c(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801040df:	b8 ac 76 10 80       	mov    $0x801076ac,%eax
801040e4:	85 d2                	test   %edx,%edx
801040e6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040e9:	53                   	push   %ebx
801040ea:	52                   	push   %edx
801040eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801040ee:	68 b0 76 10 80       	push   $0x801076b0
801040f3:	e8 48 c5 ff ff       	call   80100640 <cprintf>
    if(p->state == SLEEPING){
801040f8:	83 c4 10             	add    $0x10,%esp
801040fb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801040ff:	75 a7                	jne    801040a8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104101:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104104:	83 ec 08             	sub    $0x8,%esp
80104107:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010410a:	50                   	push   %eax
8010410b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010410e:	8b 40 0c             	mov    0xc(%eax),%eax
80104111:	83 c0 08             	add    $0x8,%eax
80104114:	50                   	push   %eax
80104115:	e8 f6 01 00 00       	call   80104310 <getcallerpcs>
8010411a:	83 c4 10             	add    $0x10,%esp
8010411d:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104120:	8b 17                	mov    (%edi),%edx
80104122:	85 d2                	test   %edx,%edx
80104124:	74 82                	je     801040a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104126:	83 ec 08             	sub    $0x8,%esp
80104129:	83 c7 04             	add    $0x4,%edi
8010412c:	52                   	push   %edx
8010412d:	68 e2 70 10 80       	push   $0x801070e2
80104132:	e8 09 c5 ff ff       	call   80100640 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104137:	83 c4 10             	add    $0x10,%esp
8010413a:	39 f7                	cmp    %esi,%edi
8010413c:	75 e2                	jne    80104120 <procdump+0x90>
8010413e:	e9 65 ff ff ff       	jmp    801040a8 <procdump+0x18>
80104143:	90                   	nop
80104144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104148:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010414b:	5b                   	pop    %ebx
8010414c:	5e                   	pop    %esi
8010414d:	5f                   	pop    %edi
8010414e:	5d                   	pop    %ebp
8010414f:	c3                   	ret    

80104150 <sem_init>:
#include "spinlock.h"

struct spinlock semlock;

void sem_init(int semaphore,int value)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
  total_sem[semaphore] = value;
80104153:	8b 55 0c             	mov    0xc(%ebp),%edx
80104156:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104159:	5d                   	pop    %ebp

struct spinlock semlock;

void sem_init(int semaphore,int value)
{
  total_sem[semaphore] = value;
8010415a:	89 14 85 c0 12 11 80 	mov    %edx,-0x7feeed40(,%eax,4)
}
80104161:	c3                   	ret    
80104162:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104170 <sem_release>:

void sem_release(int semaphore){
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
  total_sem[semaphore] = 0;
80104173:	8b 45 08             	mov    0x8(%ebp),%eax
}
80104176:	5d                   	pop    %ebp
{
  total_sem[semaphore] = value;
}

void sem_release(int semaphore){
  total_sem[semaphore] = 0;
80104177:	c7 04 85 c0 12 11 80 	movl   $0x0,-0x7feeed40(,%eax,4)
8010417e:	00 00 00 00 
}
80104182:	c3                   	ret    
80104183:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104190 <sem_down>:

void sem_down(int semaphore){
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	56                   	push   %esi
80104194:	53                   	push   %ebx
80104195:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while(total_sem[semaphore] == 0){
80104198:	8b 04 9d c0 12 11 80 	mov    -0x7feeed40(,%ebx,4),%eax
8010419f:	85 c0                	test   %eax,%eax
801041a1:	75 29                	jne    801041cc <sem_down+0x3c>
801041a3:	8d 34 9d c0 12 11 80 	lea    -0x7feeed40(,%ebx,4),%esi
801041aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sleep(&total_sem[semaphore],&semlock);
801041b0:	83 ec 08             	sub    $0x8,%esp
801041b3:	68 80 38 11 80       	push   $0x80113880
801041b8:	56                   	push   %esi
801041b9:	e8 42 fc ff ff       	call   80103e00 <sleep>
void sem_release(int semaphore){
  total_sem[semaphore] = 0;
}

void sem_down(int semaphore){
  while(total_sem[semaphore] == 0){
801041be:	8b 04 9d c0 12 11 80 	mov    -0x7feeed40(,%ebx,4),%eax
801041c5:	83 c4 10             	add    $0x10,%esp
801041c8:	85 c0                	test   %eax,%eax
801041ca:	74 e4                	je     801041b0 <sem_down+0x20>
    sleep(&total_sem[semaphore],&semlock);
  }
  total_sem[semaphore]--;
801041cc:	83 e8 01             	sub    $0x1,%eax
801041cf:	89 04 9d c0 12 11 80 	mov    %eax,-0x7feeed40(,%ebx,4)
}
801041d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041d9:	5b                   	pop    %ebx
801041da:	5e                   	pop    %esi
801041db:	5d                   	pop    %ebp
801041dc:	c3                   	ret    
801041dd:	8d 76 00             	lea    0x0(%esi),%esi

801041e0 <sem_up>:

void sem_up(int semaphore){
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	53                   	push   %ebx
801041e4:	83 ec 04             	sub    $0x4,%esp
801041e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(total_sem[semaphore] == 0){
801041ea:	8b 04 9d c0 12 11 80 	mov    -0x7feeed40(,%ebx,4),%eax
801041f1:	85 c0                	test   %eax,%eax
801041f3:	75 1a                	jne    8010420f <sem_up+0x2f>
    wakeup(&total_sem[semaphore]);
801041f5:	8d 04 9d c0 12 11 80 	lea    -0x7feeed40(,%ebx,4),%eax
801041fc:	83 ec 0c             	sub    $0xc,%esp
801041ff:	50                   	push   %eax
80104200:	e8 9b fd ff ff       	call   80103fa0 <wakeup>
80104205:	8b 04 9d c0 12 11 80 	mov    -0x7feeed40(,%ebx,4),%eax
8010420c:	83 c4 10             	add    $0x10,%esp
  }
  total_sem[semaphore]++;
8010420f:	83 c0 01             	add    $0x1,%eax
80104212:	89 04 9d c0 12 11 80 	mov    %eax,-0x7feeed40(,%ebx,4)
}
80104219:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010421c:	c9                   	leave  
8010421d:	c3                   	ret    
8010421e:	66 90                	xchg   %ax,%ax

80104220 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104226:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104229:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010422f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104232:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104239:	5d                   	pop    %ebp
8010423a:	c3                   	ret    
8010423b:	90                   	nop
8010423c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104240 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 04             	sub    $0x4,%esp
80104247:	9c                   	pushf  
80104248:	5a                   	pop    %edx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104249:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
8010424a:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
80104251:	8b 81 ac 00 00 00    	mov    0xac(%ecx),%eax
80104257:	85 c0                	test   %eax,%eax
80104259:	75 0c                	jne    80104267 <acquire+0x27>
    cpu->intena = eflags & FL_IF;
8010425b:	81 e2 00 02 00 00    	and    $0x200,%edx
80104261:	89 91 b0 00 00 00    	mov    %edx,0xb0(%ecx)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
80104267:	8b 55 08             	mov    0x8(%ebp),%edx

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
    cpu->intena = eflags & FL_IF;
  cpu->ncli += 1;
8010426a:	83 c0 01             	add    $0x1,%eax
8010426d:	89 81 ac 00 00 00    	mov    %eax,0xac(%ecx)

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104273:	8b 02                	mov    (%edx),%eax
80104275:	85 c0                	test   %eax,%eax
80104277:	74 05                	je     8010427e <acquire+0x3e>
80104279:	39 4a 08             	cmp    %ecx,0x8(%edx)
8010427c:	74 7a                	je     801042f8 <acquire+0xb8>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010427e:	b9 01 00 00 00       	mov    $0x1,%ecx
80104283:	90                   	nop
80104284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104288:	89 c8                	mov    %ecx,%eax
8010428a:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
8010428d:	85 c0                	test   %eax,%eax
8010428f:	75 f7                	jne    80104288 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104291:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104296:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104299:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010429f:	89 ea                	mov    %ebp,%edx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801042a1:	89 41 08             	mov    %eax,0x8(%ecx)
  getcallerpcs(&lk, lk->pcs);
801042a4:	83 c1 0c             	add    $0xc,%ecx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042a7:	31 c0                	xor    %eax,%eax
801042a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801042b0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801042b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801042bc:	77 1a                	ja     801042d8 <acquire+0x98>
      break;
    pcs[i] = ebp[1];     // saved %eip
801042be:	8b 5a 04             	mov    0x4(%edx),%ebx
801042c1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042c4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801042c7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042c9:	83 f8 0a             	cmp    $0xa,%eax
801042cc:	75 e2                	jne    801042b0 <acquire+0x70>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
  getcallerpcs(&lk, lk->pcs);
}
801042ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042d1:	c9                   	leave  
801042d2:	c3                   	ret    
801042d3:	90                   	nop
801042d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801042d8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042df:	83 c0 01             	add    $0x1,%eax
801042e2:	83 f8 0a             	cmp    $0xa,%eax
801042e5:	74 e7                	je     801042ce <acquire+0x8e>
    pcs[i] = 0;
801042e7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042ee:	83 c0 01             	add    $0x1,%eax
801042f1:	83 f8 0a             	cmp    $0xa,%eax
801042f4:	75 e2                	jne    801042d8 <acquire+0x98>
801042f6:	eb d6                	jmp    801042ce <acquire+0x8e>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
801042f8:	83 ec 0c             	sub    $0xc,%esp
801042fb:	68 fc 76 10 80       	push   $0x801076fc
80104300:	e8 4b c0 ff ff       	call   80100350 <panic>
80104305:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104310 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104314:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010431a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010431d:	31 c0                	xor    %eax,%eax
8010431f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104320:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104326:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010432c:	77 1a                	ja     80104348 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010432e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104331:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104334:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104337:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104339:	83 f8 0a             	cmp    $0xa,%eax
8010433c:	75 e2                	jne    80104320 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010433e:	5b                   	pop    %ebx
8010433f:	5d                   	pop    %ebp
80104340:	c3                   	ret    
80104341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104348:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010434f:	83 c0 01             	add    $0x1,%eax
80104352:	83 f8 0a             	cmp    $0xa,%eax
80104355:	74 e7                	je     8010433e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104357:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010435e:	83 c0 01             	add    $0x1,%eax
80104361:	83 f8 0a             	cmp    $0xa,%eax
80104364:	75 e2                	jne    80104348 <getcallerpcs+0x38>
80104366:	eb d6                	jmp    8010433e <getcallerpcs+0x2e>
80104368:	90                   	nop
80104369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104370 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
80104376:	8b 02                	mov    (%edx),%eax
80104378:	85 c0                	test   %eax,%eax
8010437a:	74 14                	je     80104390 <holding+0x20>
8010437c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104382:	39 42 08             	cmp    %eax,0x8(%edx)
}
80104385:	5d                   	pop    %ebp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104386:	0f 94 c0             	sete   %al
80104389:	0f b6 c0             	movzbl %al,%eax
}
8010438c:	c3                   	ret    
8010438d:	8d 76 00             	lea    0x0(%esi),%esi
80104390:	31 c0                	xor    %eax,%eax
80104392:	5d                   	pop    %ebp
80104393:	c3                   	ret    
80104394:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010439a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801043a0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043a3:	9c                   	pushf  
801043a4:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
801043a5:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801043a6:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801043ad:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
801043b3:	85 c0                	test   %eax,%eax
801043b5:	75 0c                	jne    801043c3 <pushcli+0x23>
    cpu->intena = eflags & FL_IF;
801043b7:	81 e1 00 02 00 00    	and    $0x200,%ecx
801043bd:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
  cpu->ncli += 1;
801043c3:	83 c0 01             	add    $0x1,%eax
801043c6:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
}
801043cc:	5d                   	pop    %ebp
801043cd:	c3                   	ret    
801043ce:	66 90                	xchg   %ax,%ax

801043d0 <popcli>:

void
popcli(void)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801043d6:	9c                   	pushf  
801043d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801043d8:	f6 c4 02             	test   $0x2,%ah
801043db:	75 2c                	jne    80104409 <popcli+0x39>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
801043dd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801043e4:	83 aa ac 00 00 00 01 	subl   $0x1,0xac(%edx)
801043eb:	78 0f                	js     801043fc <popcli+0x2c>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
801043ed:	75 0b                	jne    801043fa <popcli+0x2a>
801043ef:	8b 82 b0 00 00 00    	mov    0xb0(%edx),%eax
801043f5:	85 c0                	test   %eax,%eax
801043f7:	74 01                	je     801043fa <popcli+0x2a>
}

static inline void
sti(void)
{
  asm volatile("sti");
801043f9:	fb                   	sti    
    sti();
}
801043fa:	c9                   	leave  
801043fb:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
801043fc:	83 ec 0c             	sub    $0xc,%esp
801043ff:	68 1b 77 10 80       	push   $0x8010771b
80104404:	e8 47 bf ff ff       	call   80100350 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104409:	83 ec 0c             	sub    $0xc,%esp
8010440c:	68 04 77 10 80       	push   $0x80107704
80104411:	e8 3a bf ff ff       	call   80100350 <panic>
80104416:	8d 76 00             	lea    0x0(%esi),%esi
80104419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104420 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	83 ec 08             	sub    $0x8,%esp
80104426:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104429:	8b 10                	mov    (%eax),%edx
8010442b:	85 d2                	test   %edx,%edx
8010442d:	74 0c                	je     8010443b <release+0x1b>
8010442f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104436:	39 50 08             	cmp    %edx,0x8(%eax)
80104439:	74 15                	je     80104450 <release+0x30>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010443b:	83 ec 0c             	sub    $0xc,%esp
8010443e:	68 22 77 10 80       	push   $0x80107722
80104443:	e8 08 bf ff ff       	call   80100350 <panic>
80104448:	90                   	nop
80104449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  lk->pcs[0] = 0;
80104450:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80104457:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both to not re-order.
  __sync_synchronize();
8010445e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104463:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
80104469:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
8010446a:	e9 61 ff ff ff       	jmp    801043d0 <popcli>
8010446f:	90                   	nop

80104470 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	57                   	push   %edi
80104474:	53                   	push   %ebx
80104475:	8b 55 08             	mov    0x8(%ebp),%edx
80104478:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010447b:	f6 c2 03             	test   $0x3,%dl
8010447e:	75 05                	jne    80104485 <memset+0x15>
80104480:	f6 c1 03             	test   $0x3,%cl
80104483:	74 13                	je     80104498 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104485:	89 d7                	mov    %edx,%edi
80104487:	8b 45 0c             	mov    0xc(%ebp),%eax
8010448a:	fc                   	cld    
8010448b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010448d:	5b                   	pop    %ebx
8010448e:	89 d0                	mov    %edx,%eax
80104490:	5f                   	pop    %edi
80104491:	5d                   	pop    %ebp
80104492:	c3                   	ret    
80104493:	90                   	nop
80104494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104498:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010449c:	c1 e9 02             	shr    $0x2,%ecx
8010449f:	89 fb                	mov    %edi,%ebx
801044a1:	89 f8                	mov    %edi,%eax
801044a3:	c1 e3 18             	shl    $0x18,%ebx
801044a6:	c1 e0 10             	shl    $0x10,%eax
801044a9:	09 d8                	or     %ebx,%eax
801044ab:	09 f8                	or     %edi,%eax
801044ad:	c1 e7 08             	shl    $0x8,%edi
801044b0:	09 f8                	or     %edi,%eax
801044b2:	89 d7                	mov    %edx,%edi
801044b4:	fc                   	cld    
801044b5:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801044b7:	5b                   	pop    %ebx
801044b8:	89 d0                	mov    %edx,%eax
801044ba:	5f                   	pop    %edi
801044bb:	5d                   	pop    %ebp
801044bc:	c3                   	ret    
801044bd:	8d 76 00             	lea    0x0(%esi),%esi

801044c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	57                   	push   %edi
801044c4:	56                   	push   %esi
801044c5:	8b 45 10             	mov    0x10(%ebp),%eax
801044c8:	53                   	push   %ebx
801044c9:	8b 75 0c             	mov    0xc(%ebp),%esi
801044cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801044cf:	85 c0                	test   %eax,%eax
801044d1:	74 29                	je     801044fc <memcmp+0x3c>
    if(*s1 != *s2)
801044d3:	0f b6 13             	movzbl (%ebx),%edx
801044d6:	0f b6 0e             	movzbl (%esi),%ecx
801044d9:	38 d1                	cmp    %dl,%cl
801044db:	75 2b                	jne    80104508 <memcmp+0x48>
801044dd:	8d 78 ff             	lea    -0x1(%eax),%edi
801044e0:	31 c0                	xor    %eax,%eax
801044e2:	eb 14                	jmp    801044f8 <memcmp+0x38>
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
801044ed:	83 c0 01             	add    $0x1,%eax
801044f0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801044f4:	38 ca                	cmp    %cl,%dl
801044f6:	75 10                	jne    80104508 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801044f8:	39 f8                	cmp    %edi,%eax
801044fa:	75 ec                	jne    801044e8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801044fc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801044fd:	31 c0                	xor    %eax,%eax
}
801044ff:	5e                   	pop    %esi
80104500:	5f                   	pop    %edi
80104501:	5d                   	pop    %ebp
80104502:	c3                   	ret    
80104503:	90                   	nop
80104504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104508:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010450b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010450c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010450e:	5e                   	pop    %esi
8010450f:	5f                   	pop    %edi
80104510:	5d                   	pop    %ebp
80104511:	c3                   	ret    
80104512:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104520 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104520:	55                   	push   %ebp
80104521:	89 e5                	mov    %esp,%ebp
80104523:	56                   	push   %esi
80104524:	53                   	push   %ebx
80104525:	8b 45 08             	mov    0x8(%ebp),%eax
80104528:	8b 75 0c             	mov    0xc(%ebp),%esi
8010452b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010452e:	39 c6                	cmp    %eax,%esi
80104530:	73 2e                	jae    80104560 <memmove+0x40>
80104532:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104535:	39 c8                	cmp    %ecx,%eax
80104537:	73 27                	jae    80104560 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104539:	85 db                	test   %ebx,%ebx
8010453b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010453e:	74 17                	je     80104557 <memmove+0x37>
      *--d = *--s;
80104540:	29 d9                	sub    %ebx,%ecx
80104542:	89 cb                	mov    %ecx,%ebx
80104544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104548:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010454c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010454f:	83 ea 01             	sub    $0x1,%edx
80104552:	83 fa ff             	cmp    $0xffffffff,%edx
80104555:	75 f1                	jne    80104548 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104557:	5b                   	pop    %ebx
80104558:	5e                   	pop    %esi
80104559:	5d                   	pop    %ebp
8010455a:	c3                   	ret    
8010455b:	90                   	nop
8010455c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104560:	31 d2                	xor    %edx,%edx
80104562:	85 db                	test   %ebx,%ebx
80104564:	74 f1                	je     80104557 <memmove+0x37>
80104566:	8d 76 00             	lea    0x0(%esi),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104570:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104574:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104577:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010457a:	39 d3                	cmp    %edx,%ebx
8010457c:	75 f2                	jne    80104570 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010457e:	5b                   	pop    %ebx
8010457f:	5e                   	pop    %esi
80104580:	5d                   	pop    %ebp
80104581:	c3                   	ret    
80104582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104593:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104594:	eb 8a                	jmp    80104520 <memmove>
80104596:	8d 76 00             	lea    0x0(%esi),%esi
80104599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045a0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	57                   	push   %edi
801045a4:	56                   	push   %esi
801045a5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045a8:	53                   	push   %ebx
801045a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801045ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801045af:	85 c9                	test   %ecx,%ecx
801045b1:	74 37                	je     801045ea <strncmp+0x4a>
801045b3:	0f b6 17             	movzbl (%edi),%edx
801045b6:	0f b6 1e             	movzbl (%esi),%ebx
801045b9:	84 d2                	test   %dl,%dl
801045bb:	74 3f                	je     801045fc <strncmp+0x5c>
801045bd:	38 d3                	cmp    %dl,%bl
801045bf:	75 3b                	jne    801045fc <strncmp+0x5c>
801045c1:	8d 47 01             	lea    0x1(%edi),%eax
801045c4:	01 cf                	add    %ecx,%edi
801045c6:	eb 1b                	jmp    801045e3 <strncmp+0x43>
801045c8:	90                   	nop
801045c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045d0:	0f b6 10             	movzbl (%eax),%edx
801045d3:	84 d2                	test   %dl,%dl
801045d5:	74 21                	je     801045f8 <strncmp+0x58>
801045d7:	0f b6 19             	movzbl (%ecx),%ebx
801045da:	83 c0 01             	add    $0x1,%eax
801045dd:	89 ce                	mov    %ecx,%esi
801045df:	38 da                	cmp    %bl,%dl
801045e1:	75 19                	jne    801045fc <strncmp+0x5c>
801045e3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
801045e5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801045e8:	75 e6                	jne    801045d0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801045ea:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801045eb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801045ed:	5e                   	pop    %esi
801045ee:	5f                   	pop    %edi
801045ef:	5d                   	pop    %ebp
801045f0:	c3                   	ret    
801045f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045f8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801045fc:	0f b6 c2             	movzbl %dl,%eax
801045ff:	29 d8                	sub    %ebx,%eax
}
80104601:	5b                   	pop    %ebx
80104602:	5e                   	pop    %esi
80104603:	5f                   	pop    %edi
80104604:	5d                   	pop    %ebp
80104605:	c3                   	ret    
80104606:	8d 76 00             	lea    0x0(%esi),%esi
80104609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104610 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	56                   	push   %esi
80104614:	53                   	push   %ebx
80104615:	8b 45 08             	mov    0x8(%ebp),%eax
80104618:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010461b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010461e:	89 c2                	mov    %eax,%edx
80104620:	eb 19                	jmp    8010463b <strncpy+0x2b>
80104622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104628:	83 c3 01             	add    $0x1,%ebx
8010462b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010462f:	83 c2 01             	add    $0x1,%edx
80104632:	84 c9                	test   %cl,%cl
80104634:	88 4a ff             	mov    %cl,-0x1(%edx)
80104637:	74 09                	je     80104642 <strncpy+0x32>
80104639:	89 f1                	mov    %esi,%ecx
8010463b:	85 c9                	test   %ecx,%ecx
8010463d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104640:	7f e6                	jg     80104628 <strncpy+0x18>
    ;
  while(n-- > 0)
80104642:	31 c9                	xor    %ecx,%ecx
80104644:	85 f6                	test   %esi,%esi
80104646:	7e 17                	jle    8010465f <strncpy+0x4f>
80104648:	90                   	nop
80104649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104650:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104654:	89 f3                	mov    %esi,%ebx
80104656:	83 c1 01             	add    $0x1,%ecx
80104659:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010465b:	85 db                	test   %ebx,%ebx
8010465d:	7f f1                	jg     80104650 <strncpy+0x40>
    *s++ = 0;
  return os;
}
8010465f:	5b                   	pop    %ebx
80104660:	5e                   	pop    %esi
80104661:	5d                   	pop    %ebp
80104662:	c3                   	ret    
80104663:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104670 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104678:	8b 45 08             	mov    0x8(%ebp),%eax
8010467b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010467e:	85 c9                	test   %ecx,%ecx
80104680:	7e 26                	jle    801046a8 <safestrcpy+0x38>
80104682:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104686:	89 c1                	mov    %eax,%ecx
80104688:	eb 17                	jmp    801046a1 <safestrcpy+0x31>
8010468a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104690:	83 c2 01             	add    $0x1,%edx
80104693:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104697:	83 c1 01             	add    $0x1,%ecx
8010469a:	84 db                	test   %bl,%bl
8010469c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010469f:	74 04                	je     801046a5 <safestrcpy+0x35>
801046a1:	39 f2                	cmp    %esi,%edx
801046a3:	75 eb                	jne    80104690 <safestrcpy+0x20>
    ;
  *s = 0;
801046a5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801046a8:	5b                   	pop    %ebx
801046a9:	5e                   	pop    %esi
801046aa:	5d                   	pop    %ebp
801046ab:	c3                   	ret    
801046ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046b0 <strlen>:

int
strlen(const char *s)
{
801046b0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801046b1:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
801046b3:	89 e5                	mov    %esp,%ebp
801046b5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
801046b8:	80 3a 00             	cmpb   $0x0,(%edx)
801046bb:	74 0c                	je     801046c9 <strlen+0x19>
801046bd:	8d 76 00             	lea    0x0(%esi),%esi
801046c0:	83 c0 01             	add    $0x1,%eax
801046c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801046c7:	75 f7                	jne    801046c0 <strlen+0x10>
    ;
  return n;
}
801046c9:	5d                   	pop    %ebp
801046ca:	c3                   	ret    

801046cb <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801046cb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801046cf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801046d3:	55                   	push   %ebp
  pushl %ebx
801046d4:	53                   	push   %ebx
  pushl %esi
801046d5:	56                   	push   %esi
  pushl %edi
801046d6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801046d7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801046d9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801046db:	5f                   	pop    %edi
  popl %esi
801046dc:	5e                   	pop    %esi
  popl %ebx
801046dd:	5b                   	pop    %ebx
  popl %ebp
801046de:	5d                   	pop    %ebp
  ret
801046df:	c3                   	ret    

801046e0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801046e0:	55                   	push   %ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801046e1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801046e8:	89 e5                	mov    %esp,%ebp
801046ea:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
801046ed:	8b 12                	mov    (%edx),%edx
801046ef:	39 c2                	cmp    %eax,%edx
801046f1:	76 15                	jbe    80104708 <fetchint+0x28>
801046f3:	8d 48 04             	lea    0x4(%eax),%ecx
801046f6:	39 ca                	cmp    %ecx,%edx
801046f8:	72 0e                	jb     80104708 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
801046fa:	8b 10                	mov    (%eax),%edx
801046fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801046ff:	89 10                	mov    %edx,(%eax)
  return 0;
80104701:	31 c0                	xor    %eax,%eax
}
80104703:	5d                   	pop    %ebp
80104704:	c3                   	ret    
80104705:	8d 76 00             	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104708:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
8010470d:	5d                   	pop    %ebp
8010470e:	c3                   	ret    
8010470f:	90                   	nop

80104710 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104710:	55                   	push   %ebp
  char *s, *ep;

  if(addr >= proc->sz)
80104711:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104717:	89 e5                	mov    %esp,%ebp
80104719:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
8010471c:	39 08                	cmp    %ecx,(%eax)
8010471e:	76 2c                	jbe    8010474c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104720:	8b 55 0c             	mov    0xc(%ebp),%edx
80104723:	89 c8                	mov    %ecx,%eax
80104725:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
80104727:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010472e:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104730:	39 d1                	cmp    %edx,%ecx
80104732:	73 18                	jae    8010474c <fetchstr+0x3c>
    if(*s == 0)
80104734:	80 39 00             	cmpb   $0x0,(%ecx)
80104737:	75 0c                	jne    80104745 <fetchstr+0x35>
80104739:	eb 1d                	jmp    80104758 <fetchstr+0x48>
8010473b:	90                   	nop
8010473c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104740:	80 38 00             	cmpb   $0x0,(%eax)
80104743:	74 13                	je     80104758 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80104745:	83 c0 01             	add    $0x1,%eax
80104748:	39 c2                	cmp    %eax,%edx
8010474a:	77 f4                	ja     80104740 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
8010474c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
80104751:	5d                   	pop    %ebp
80104752:	c3                   	ret    
80104753:	90                   	nop
80104754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
80104758:	29 c8                	sub    %ecx,%eax
  return -1;
}
8010475a:	5d                   	pop    %ebp
8010475b:	c3                   	ret    
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104760 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104760:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104767:	55                   	push   %ebp
80104768:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010476a:	8b 42 18             	mov    0x18(%edx),%eax
8010476d:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104770:	8b 12                	mov    (%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104772:	8b 40 44             	mov    0x44(%eax),%eax
80104775:	8d 04 88             	lea    (%eax,%ecx,4),%eax
80104778:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010477b:	39 d1                	cmp    %edx,%ecx
8010477d:	73 19                	jae    80104798 <argint+0x38>
8010477f:	8d 48 08             	lea    0x8(%eax),%ecx
80104782:	39 ca                	cmp    %ecx,%edx
80104784:	72 12                	jb     80104798 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
80104786:	8b 50 04             	mov    0x4(%eax),%edx
80104789:	8b 45 0c             	mov    0xc(%ebp),%eax
8010478c:	89 10                	mov    %edx,(%eax)
  return 0;
8010478e:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104790:	5d                   	pop    %ebp
80104791:	c3                   	ret    
80104792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104798:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
8010479d:	5d                   	pop    %ebp
8010479e:	c3                   	ret    
8010479f:	90                   	nop

801047a0 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801047a6:	55                   	push   %ebp
801047a7:	89 e5                	mov    %esp,%ebp
801047a9:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047aa:	8b 50 18             	mov    0x18(%eax),%edx
801047ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
801047b0:	8b 52 44             	mov    0x44(%edx),%edx
801047b3:	8d 0c 8a             	lea    (%edx,%ecx,4),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801047b6:	8b 10                	mov    (%eax),%edx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
801047b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047bd:	8d 59 04             	lea    0x4(%ecx),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801047c0:	39 d3                	cmp    %edx,%ebx
801047c2:	73 1e                	jae    801047e2 <argptr+0x42>
801047c4:	8d 59 08             	lea    0x8(%ecx),%ebx
801047c7:	39 da                	cmp    %ebx,%edx
801047c9:	72 17                	jb     801047e2 <argptr+0x42>
    return -1;
  *ip = *(int*)(addr);
801047cb:	8b 49 04             	mov    0x4(%ecx),%ecx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
801047ce:	39 d1                	cmp    %edx,%ecx
801047d0:	73 10                	jae    801047e2 <argptr+0x42>
801047d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
801047d5:	01 cb                	add    %ecx,%ebx
801047d7:	39 d3                	cmp    %edx,%ebx
801047d9:	77 07                	ja     801047e2 <argptr+0x42>
    return -1;
  *pp = (char*)i;
801047db:	8b 45 0c             	mov    0xc(%ebp),%eax
801047de:	89 08                	mov    %ecx,(%eax)
  return 0;
801047e0:	31 c0                	xor    %eax,%eax
}
801047e2:	5b                   	pop    %ebx
801047e3:	5d                   	pop    %ebp
801047e4:	c3                   	ret    
801047e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047f0 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801047f6:	55                   	push   %ebp
801047f7:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047f9:	8b 50 18             	mov    0x18(%eax),%edx
801047fc:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801047ff:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104801:	8b 52 44             	mov    0x44(%edx),%edx
80104804:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104807:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010480a:	39 c1                	cmp    %eax,%ecx
8010480c:	73 07                	jae    80104815 <argstr+0x25>
8010480e:	8d 4a 08             	lea    0x8(%edx),%ecx
80104811:	39 c8                	cmp    %ecx,%eax
80104813:	73 0b                	jae    80104820 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
8010481a:	5d                   	pop    %ebp
8010481b:	c3                   	ret    
8010481c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
80104820:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
80104823:	39 c1                	cmp    %eax,%ecx
80104825:	73 ee                	jae    80104815 <argstr+0x25>
    return -1;
  *pp = (char*)addr;
80104827:	8b 55 0c             	mov    0xc(%ebp),%edx
8010482a:	89 c8                	mov    %ecx,%eax
8010482c:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
8010482e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104835:	8b 12                	mov    (%edx),%edx
  for(s = *pp; s < ep; s++)
80104837:	39 d1                	cmp    %edx,%ecx
80104839:	73 da                	jae    80104815 <argstr+0x25>
    if(*s == 0)
8010483b:	80 39 00             	cmpb   $0x0,(%ecx)
8010483e:	75 0d                	jne    8010484d <argstr+0x5d>
80104840:	eb 1e                	jmp    80104860 <argstr+0x70>
80104842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104848:	80 38 00             	cmpb   $0x0,(%eax)
8010484b:	74 13                	je     80104860 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
8010484d:	83 c0 01             	add    $0x1,%eax
80104850:	39 c2                	cmp    %eax,%edx
80104852:	77 f4                	ja     80104848 <argstr+0x58>
80104854:	eb bf                	jmp    80104815 <argstr+0x25>
80104856:	8d 76 00             	lea    0x0(%esi),%esi
80104859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(*s == 0)
      return s - *pp;
80104860:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104862:	5d                   	pop    %ebp
80104863:	c3                   	ret    
80104864:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010486a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104870 <syscall>:
[SYS_sem_down] sys_sem_down,
};

void
syscall(void)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	53                   	push   %ebx
80104874:	83 ec 04             	sub    $0x4,%esp
  int num;

  num = proc->tf->eax;
80104877:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010487e:	8b 5a 18             	mov    0x18(%edx),%ebx
80104881:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104884:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104887:	83 f9 18             	cmp    $0x18,%ecx
8010488a:	77 1c                	ja     801048a8 <syscall+0x38>
8010488c:	8b 0c 85 60 77 10 80 	mov    -0x7fef88a0(,%eax,4),%ecx
80104893:	85 c9                	test   %ecx,%ecx
80104895:	74 11                	je     801048a8 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
80104897:	ff d1                	call   *%ecx
80104899:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
8010489c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010489f:	c9                   	leave  
801048a0:	c3                   	ret    
801048a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801048a8:	50                   	push   %eax
            proc->pid, proc->name, num);
801048a9:	8d 42 6c             	lea    0x6c(%edx),%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801048ac:	50                   	push   %eax
801048ad:	ff 72 10             	pushl  0x10(%edx)
801048b0:	68 2a 77 10 80       	push   $0x8010772a
801048b5:	e8 86 bd ff ff       	call   80100640 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801048ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c0:	83 c4 10             	add    $0x10,%esp
801048c3:	8b 40 18             	mov    0x18(%eax),%eax
801048c6:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801048cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048d0:	c9                   	leave  
801048d1:	c3                   	ret    
801048d2:	66 90                	xchg   %ax,%ax
801048d4:	66 90                	xchg   %ax,%ax
801048d6:	66 90                	xchg   %ax,%ax
801048d8:	66 90                	xchg   %ax,%ax
801048da:	66 90                	xchg   %ax,%ax
801048dc:	66 90                	xchg   %ax,%ax
801048de:	66 90                	xchg   %ax,%ax

801048e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	57                   	push   %edi
801048e4:	56                   	push   %esi
801048e5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048e6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048e9:	83 ec 44             	sub    $0x44,%esp
801048ec:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801048ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048f2:	56                   	push   %esi
801048f3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048f4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801048f7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048fa:	e8 b1 d5 ff ff       	call   80101eb0 <nameiparent>
801048ff:	83 c4 10             	add    $0x10,%esp
80104902:	85 c0                	test   %eax,%eax
80104904:	0f 84 f6 00 00 00    	je     80104a00 <create+0x120>
    return 0;
  ilock(dp);
8010490a:	83 ec 0c             	sub    $0xc,%esp
8010490d:	89 c7                	mov    %eax,%edi
8010490f:	50                   	push   %eax
80104910:	e8 eb cc ff ff       	call   80101600 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104915:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104918:	83 c4 0c             	add    $0xc,%esp
8010491b:	50                   	push   %eax
8010491c:	56                   	push   %esi
8010491d:	57                   	push   %edi
8010491e:	e8 4d d2 ff ff       	call   80101b70 <dirlookup>
80104923:	83 c4 10             	add    $0x10,%esp
80104926:	85 c0                	test   %eax,%eax
80104928:	89 c3                	mov    %eax,%ebx
8010492a:	74 54                	je     80104980 <create+0xa0>
    iunlockput(dp);
8010492c:	83 ec 0c             	sub    $0xc,%esp
8010492f:	57                   	push   %edi
80104930:	e8 9b cf ff ff       	call   801018d0 <iunlockput>
    ilock(ip);
80104935:	89 1c 24             	mov    %ebx,(%esp)
80104938:	e8 c3 cc ff ff       	call   80101600 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010493d:	83 c4 10             	add    $0x10,%esp
80104940:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104945:	75 19                	jne    80104960 <create+0x80>
80104947:	66 83 7b 10 02       	cmpw   $0x2,0x10(%ebx)
8010494c:	89 d8                	mov    %ebx,%eax
8010494e:	75 10                	jne    80104960 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104950:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104953:	5b                   	pop    %ebx
80104954:	5e                   	pop    %esi
80104955:	5f                   	pop    %edi
80104956:	5d                   	pop    %ebp
80104957:	c3                   	ret    
80104958:	90                   	nop
80104959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104960:	83 ec 0c             	sub    $0xc,%esp
80104963:	53                   	push   %ebx
80104964:	e8 67 cf ff ff       	call   801018d0 <iunlockput>
    return 0;
80104969:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010496c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010496f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104971:	5b                   	pop    %ebx
80104972:	5e                   	pop    %esi
80104973:	5f                   	pop    %edi
80104974:	5d                   	pop    %ebp
80104975:	c3                   	ret    
80104976:	8d 76 00             	lea    0x0(%esi),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104980:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104984:	83 ec 08             	sub    $0x8,%esp
80104987:	50                   	push   %eax
80104988:	ff 37                	pushl  (%edi)
8010498a:	e8 01 cb ff ff       	call   80101490 <ialloc>
8010498f:	83 c4 10             	add    $0x10,%esp
80104992:	85 c0                	test   %eax,%eax
80104994:	89 c3                	mov    %eax,%ebx
80104996:	0f 84 cc 00 00 00    	je     80104a68 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010499c:	83 ec 0c             	sub    $0xc,%esp
8010499f:	50                   	push   %eax
801049a0:	e8 5b cc ff ff       	call   80101600 <ilock>
  ip->major = major;
801049a5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801049a9:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
801049ad:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801049b1:	66 89 43 14          	mov    %ax,0x14(%ebx)
  ip->nlink = 1;
801049b5:	b8 01 00 00 00       	mov    $0x1,%eax
801049ba:	66 89 43 16          	mov    %ax,0x16(%ebx)
  iupdate(ip);
801049be:	89 1c 24             	mov    %ebx,(%esp)
801049c1:	e8 8a cb ff ff       	call   80101550 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801049c6:	83 c4 10             	add    $0x10,%esp
801049c9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801049ce:	74 40                	je     80104a10 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801049d0:	83 ec 04             	sub    $0x4,%esp
801049d3:	ff 73 04             	pushl  0x4(%ebx)
801049d6:	56                   	push   %esi
801049d7:	57                   	push   %edi
801049d8:	e8 f3 d3 ff ff       	call   80101dd0 <dirlink>
801049dd:	83 c4 10             	add    $0x10,%esp
801049e0:	85 c0                	test   %eax,%eax
801049e2:	78 77                	js     80104a5b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
801049e4:	83 ec 0c             	sub    $0xc,%esp
801049e7:	57                   	push   %edi
801049e8:	e8 e3 ce ff ff       	call   801018d0 <iunlockput>

  return ip;
801049ed:	83 c4 10             	add    $0x10,%esp
}
801049f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801049f3:	89 d8                	mov    %ebx,%eax
}
801049f5:	5b                   	pop    %ebx
801049f6:	5e                   	pop    %esi
801049f7:	5f                   	pop    %edi
801049f8:	5d                   	pop    %ebp
801049f9:	c3                   	ret    
801049fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104a00:	31 c0                	xor    %eax,%eax
80104a02:	e9 49 ff ff ff       	jmp    80104950 <create+0x70>
80104a07:	89 f6                	mov    %esi,%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104a10:	66 83 47 16 01       	addw   $0x1,0x16(%edi)
    iupdate(dp);
80104a15:	83 ec 0c             	sub    $0xc,%esp
80104a18:	57                   	push   %edi
80104a19:	e8 32 cb ff ff       	call   80101550 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a1e:	83 c4 0c             	add    $0xc,%esp
80104a21:	ff 73 04             	pushl  0x4(%ebx)
80104a24:	68 e4 77 10 80       	push   $0x801077e4
80104a29:	53                   	push   %ebx
80104a2a:	e8 a1 d3 ff ff       	call   80101dd0 <dirlink>
80104a2f:	83 c4 10             	add    $0x10,%esp
80104a32:	85 c0                	test   %eax,%eax
80104a34:	78 18                	js     80104a4e <create+0x16e>
80104a36:	83 ec 04             	sub    $0x4,%esp
80104a39:	ff 77 04             	pushl  0x4(%edi)
80104a3c:	68 e3 77 10 80       	push   $0x801077e3
80104a41:	53                   	push   %ebx
80104a42:	e8 89 d3 ff ff       	call   80101dd0 <dirlink>
80104a47:	83 c4 10             	add    $0x10,%esp
80104a4a:	85 c0                	test   %eax,%eax
80104a4c:	79 82                	jns    801049d0 <create+0xf0>
      panic("create dots");
80104a4e:	83 ec 0c             	sub    $0xc,%esp
80104a51:	68 d7 77 10 80       	push   $0x801077d7
80104a56:	e8 f5 b8 ff ff       	call   80100350 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104a5b:	83 ec 0c             	sub    $0xc,%esp
80104a5e:	68 e6 77 10 80       	push   $0x801077e6
80104a63:	e8 e8 b8 ff ff       	call   80100350 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104a68:	83 ec 0c             	sub    $0xc,%esp
80104a6b:	68 c8 77 10 80       	push   $0x801077c8
80104a70:	e8 db b8 ff ff       	call   80100350 <panic>
80104a75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a80 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	56                   	push   %esi
80104a84:	53                   	push   %ebx
80104a85:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104a87:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104a8a:	89 d3                	mov    %edx,%ebx
80104a8c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104a8f:	50                   	push   %eax
80104a90:	6a 00                	push   $0x0
80104a92:	e8 c9 fc ff ff       	call   80104760 <argint>
80104a97:	83 c4 10             	add    $0x10,%esp
80104a9a:	85 c0                	test   %eax,%eax
80104a9c:	78 3a                	js     80104ad8 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa1:	83 f8 0f             	cmp    $0xf,%eax
80104aa4:	77 32                	ja     80104ad8 <argfd.constprop.0+0x58>
80104aa6:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104aad:	8b 54 82 28          	mov    0x28(%edx,%eax,4),%edx
80104ab1:	85 d2                	test   %edx,%edx
80104ab3:	74 23                	je     80104ad8 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80104ab5:	85 f6                	test   %esi,%esi
80104ab7:	74 02                	je     80104abb <argfd.constprop.0+0x3b>
    *pfd = fd;
80104ab9:	89 06                	mov    %eax,(%esi)
  if(pf)
80104abb:	85 db                	test   %ebx,%ebx
80104abd:	74 11                	je     80104ad0 <argfd.constprop.0+0x50>
    *pf = f;
80104abf:	89 13                	mov    %edx,(%ebx)
  return 0;
80104ac1:	31 c0                	xor    %eax,%eax
}
80104ac3:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ac6:	5b                   	pop    %ebx
80104ac7:	5e                   	pop    %esi
80104ac8:	5d                   	pop    %ebp
80104ac9:	c3                   	ret    
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104ad0:	31 c0                	xor    %eax,%eax
80104ad2:	eb ef                	jmp    80104ac3 <argfd.constprop.0+0x43>
80104ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104ad8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104add:	eb e4                	jmp    80104ac3 <argfd.constprop.0+0x43>
80104adf:	90                   	nop

80104ae0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104ae0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ae1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104ae3:	89 e5                	mov    %esp,%ebp
80104ae5:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ae6:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104ae9:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104aec:	e8 8f ff ff ff       	call   80104a80 <argfd.constprop.0>
80104af1:	85 c0                	test   %eax,%eax
80104af3:	78 1b                	js     80104b10 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104af5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104af8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104afe:	31 db                	xor    %ebx,%ebx
    if(proc->ofile[fd] == 0){
80104b00:	8b 4c 98 28          	mov    0x28(%eax,%ebx,4),%ecx
80104b04:	85 c9                	test   %ecx,%ecx
80104b06:	74 18                	je     80104b20 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104b08:	83 c3 01             	add    $0x1,%ebx
80104b0b:	83 fb 10             	cmp    $0x10,%ebx
80104b0e:	75 f0                	jne    80104b00 <sys_dup+0x20>
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b18:	c9                   	leave  
80104b19:	c3                   	ret    
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104b20:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104b23:	89 54 98 28          	mov    %edx,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104b27:	52                   	push   %edx
80104b28:	e8 83 c2 ff ff       	call   80100db0 <filedup>
  return fd;
80104b2d:	89 d8                	mov    %ebx,%eax
80104b2f:	83 c4 10             	add    $0x10,%esp
}
80104b32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b35:	c9                   	leave  
80104b36:	c3                   	ret    
80104b37:	89 f6                	mov    %esi,%esi
80104b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b40 <sys_read>:

int
sys_read(void)
{
80104b40:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b41:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104b43:	89 e5                	mov    %esp,%ebp
80104b45:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b48:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b4b:	e8 30 ff ff ff       	call   80104a80 <argfd.constprop.0>
80104b50:	85 c0                	test   %eax,%eax
80104b52:	78 4c                	js     80104ba0 <sys_read+0x60>
80104b54:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b57:	83 ec 08             	sub    $0x8,%esp
80104b5a:	50                   	push   %eax
80104b5b:	6a 02                	push   $0x2
80104b5d:	e8 fe fb ff ff       	call   80104760 <argint>
80104b62:	83 c4 10             	add    $0x10,%esp
80104b65:	85 c0                	test   %eax,%eax
80104b67:	78 37                	js     80104ba0 <sys_read+0x60>
80104b69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b6c:	83 ec 04             	sub    $0x4,%esp
80104b6f:	ff 75 f0             	pushl  -0x10(%ebp)
80104b72:	50                   	push   %eax
80104b73:	6a 01                	push   $0x1
80104b75:	e8 26 fc ff ff       	call   801047a0 <argptr>
80104b7a:	83 c4 10             	add    $0x10,%esp
80104b7d:	85 c0                	test   %eax,%eax
80104b7f:	78 1f                	js     80104ba0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104b81:	83 ec 04             	sub    $0x4,%esp
80104b84:	ff 75 f0             	pushl  -0x10(%ebp)
80104b87:	ff 75 f4             	pushl  -0xc(%ebp)
80104b8a:	ff 75 ec             	pushl  -0x14(%ebp)
80104b8d:	e8 8e c3 ff ff       	call   80100f20 <fileread>
80104b92:	83 c4 10             	add    $0x10,%esp
}
80104b95:	c9                   	leave  
80104b96:	c3                   	ret    
80104b97:	89 f6                	mov    %esi,%esi
80104b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104ba5:	c9                   	leave  
80104ba6:	c3                   	ret    
80104ba7:	89 f6                	mov    %esi,%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bb0 <sys_write>:

int
sys_write(void)
{
80104bb0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bb1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104bb3:	89 e5                	mov    %esp,%ebp
80104bb5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bb8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104bbb:	e8 c0 fe ff ff       	call   80104a80 <argfd.constprop.0>
80104bc0:	85 c0                	test   %eax,%eax
80104bc2:	78 4c                	js     80104c10 <sys_write+0x60>
80104bc4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bc7:	83 ec 08             	sub    $0x8,%esp
80104bca:	50                   	push   %eax
80104bcb:	6a 02                	push   $0x2
80104bcd:	e8 8e fb ff ff       	call   80104760 <argint>
80104bd2:	83 c4 10             	add    $0x10,%esp
80104bd5:	85 c0                	test   %eax,%eax
80104bd7:	78 37                	js     80104c10 <sys_write+0x60>
80104bd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bdc:	83 ec 04             	sub    $0x4,%esp
80104bdf:	ff 75 f0             	pushl  -0x10(%ebp)
80104be2:	50                   	push   %eax
80104be3:	6a 01                	push   $0x1
80104be5:	e8 b6 fb ff ff       	call   801047a0 <argptr>
80104bea:	83 c4 10             	add    $0x10,%esp
80104bed:	85 c0                	test   %eax,%eax
80104bef:	78 1f                	js     80104c10 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104bf1:	83 ec 04             	sub    $0x4,%esp
80104bf4:	ff 75 f0             	pushl  -0x10(%ebp)
80104bf7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bfa:	ff 75 ec             	pushl  -0x14(%ebp)
80104bfd:	e8 ae c3 ff ff       	call   80100fb0 <filewrite>
80104c02:	83 c4 10             	add    $0x10,%esp
}
80104c05:	c9                   	leave  
80104c06:	c3                   	ret    
80104c07:	89 f6                	mov    %esi,%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104c15:	c9                   	leave  
80104c16:	c3                   	ret    
80104c17:	89 f6                	mov    %esi,%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c20 <sys_close>:

int
sys_close(void)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104c26:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c29:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c2c:	e8 4f fe ff ff       	call   80104a80 <argfd.constprop.0>
80104c31:	85 c0                	test   %eax,%eax
80104c33:	78 2b                	js     80104c60 <sys_close+0x40>
    return -1;
  proc->ofile[fd] = 0;
80104c35:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  fileclose(f);
80104c3e:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  proc->ofile[fd] = 0;
80104c41:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104c48:	00 
  fileclose(f);
80104c49:	ff 75 f4             	pushl  -0xc(%ebp)
80104c4c:	e8 af c1 ff ff       	call   80100e00 <fileclose>
  return 0;
80104c51:	83 c4 10             	add    $0x10,%esp
80104c54:	31 c0                	xor    %eax,%eax
}
80104c56:	c9                   	leave  
80104c57:	c3                   	ret    
80104c58:	90                   	nop
80104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104c60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104c65:	c9                   	leave  
80104c66:	c3                   	ret    
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c70 <sys_fstat>:

int
sys_fstat(void)
{
80104c70:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c71:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104c73:	89 e5                	mov    %esp,%ebp
80104c75:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c78:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104c7b:	e8 00 fe ff ff       	call   80104a80 <argfd.constprop.0>
80104c80:	85 c0                	test   %eax,%eax
80104c82:	78 2c                	js     80104cb0 <sys_fstat+0x40>
80104c84:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c87:	83 ec 04             	sub    $0x4,%esp
80104c8a:	6a 14                	push   $0x14
80104c8c:	50                   	push   %eax
80104c8d:	6a 01                	push   $0x1
80104c8f:	e8 0c fb ff ff       	call   801047a0 <argptr>
80104c94:	83 c4 10             	add    $0x10,%esp
80104c97:	85 c0                	test   %eax,%eax
80104c99:	78 15                	js     80104cb0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104c9b:	83 ec 08             	sub    $0x8,%esp
80104c9e:	ff 75 f4             	pushl  -0xc(%ebp)
80104ca1:	ff 75 f0             	pushl  -0x10(%ebp)
80104ca4:	e8 27 c2 ff ff       	call   80100ed0 <filestat>
80104ca9:	83 c4 10             	add    $0x10,%esp
}
80104cac:	c9                   	leave  
80104cad:	c3                   	ret    
80104cae:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104cb5:	c9                   	leave  
80104cb6:	c3                   	ret    
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	57                   	push   %edi
80104cc4:	56                   	push   %esi
80104cc5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104cc6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104cc9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104ccc:	50                   	push   %eax
80104ccd:	6a 00                	push   $0x0
80104ccf:	e8 1c fb ff ff       	call   801047f0 <argstr>
80104cd4:	83 c4 10             	add    $0x10,%esp
80104cd7:	85 c0                	test   %eax,%eax
80104cd9:	0f 88 fb 00 00 00    	js     80104dda <sys_link+0x11a>
80104cdf:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ce2:	83 ec 08             	sub    $0x8,%esp
80104ce5:	50                   	push   %eax
80104ce6:	6a 01                	push   $0x1
80104ce8:	e8 03 fb ff ff       	call   801047f0 <argstr>
80104ced:	83 c4 10             	add    $0x10,%esp
80104cf0:	85 c0                	test   %eax,%eax
80104cf2:	0f 88 e2 00 00 00    	js     80104dda <sys_link+0x11a>
    return -1;

  begin_op();
80104cf8:	e8 b3 de ff ff       	call   80102bb0 <begin_op>
  if((ip = namei(old)) == 0){
80104cfd:	83 ec 0c             	sub    $0xc,%esp
80104d00:	ff 75 d4             	pushl  -0x2c(%ebp)
80104d03:	e8 88 d1 ff ff       	call   80101e90 <namei>
80104d08:	83 c4 10             	add    $0x10,%esp
80104d0b:	85 c0                	test   %eax,%eax
80104d0d:	89 c3                	mov    %eax,%ebx
80104d0f:	0f 84 f3 00 00 00    	je     80104e08 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104d15:	83 ec 0c             	sub    $0xc,%esp
80104d18:	50                   	push   %eax
80104d19:	e8 e2 c8 ff ff       	call   80101600 <ilock>
  if(ip->type == T_DIR){
80104d1e:	83 c4 10             	add    $0x10,%esp
80104d21:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80104d26:	0f 84 c4 00 00 00    	je     80104df0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104d2c:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
80104d31:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104d34:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104d37:	53                   	push   %ebx
80104d38:	e8 13 c8 ff ff       	call   80101550 <iupdate>
  iunlock(ip);
80104d3d:	89 1c 24             	mov    %ebx,(%esp)
80104d40:	e8 cb c9 ff ff       	call   80101710 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104d45:	58                   	pop    %eax
80104d46:	5a                   	pop    %edx
80104d47:	57                   	push   %edi
80104d48:	ff 75 d0             	pushl  -0x30(%ebp)
80104d4b:	e8 60 d1 ff ff       	call   80101eb0 <nameiparent>
80104d50:	83 c4 10             	add    $0x10,%esp
80104d53:	85 c0                	test   %eax,%eax
80104d55:	89 c6                	mov    %eax,%esi
80104d57:	74 5b                	je     80104db4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104d59:	83 ec 0c             	sub    $0xc,%esp
80104d5c:	50                   	push   %eax
80104d5d:	e8 9e c8 ff ff       	call   80101600 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104d62:	83 c4 10             	add    $0x10,%esp
80104d65:	8b 03                	mov    (%ebx),%eax
80104d67:	39 06                	cmp    %eax,(%esi)
80104d69:	75 3d                	jne    80104da8 <sys_link+0xe8>
80104d6b:	83 ec 04             	sub    $0x4,%esp
80104d6e:	ff 73 04             	pushl  0x4(%ebx)
80104d71:	57                   	push   %edi
80104d72:	56                   	push   %esi
80104d73:	e8 58 d0 ff ff       	call   80101dd0 <dirlink>
80104d78:	83 c4 10             	add    $0x10,%esp
80104d7b:	85 c0                	test   %eax,%eax
80104d7d:	78 29                	js     80104da8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104d7f:	83 ec 0c             	sub    $0xc,%esp
80104d82:	56                   	push   %esi
80104d83:	e8 48 cb ff ff       	call   801018d0 <iunlockput>
  iput(ip);
80104d88:	89 1c 24             	mov    %ebx,(%esp)
80104d8b:	e8 e0 c9 ff ff       	call   80101770 <iput>

  end_op();
80104d90:	e8 8b de ff ff       	call   80102c20 <end_op>

  return 0;
80104d95:	83 c4 10             	add    $0x10,%esp
80104d98:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104d9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d9d:	5b                   	pop    %ebx
80104d9e:	5e                   	pop    %esi
80104d9f:	5f                   	pop    %edi
80104da0:	5d                   	pop    %ebp
80104da1:	c3                   	ret    
80104da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104da8:	83 ec 0c             	sub    $0xc,%esp
80104dab:	56                   	push   %esi
80104dac:	e8 1f cb ff ff       	call   801018d0 <iunlockput>
    goto bad;
80104db1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104db4:	83 ec 0c             	sub    $0xc,%esp
80104db7:	53                   	push   %ebx
80104db8:	e8 43 c8 ff ff       	call   80101600 <ilock>
  ip->nlink--;
80104dbd:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
80104dc2:	89 1c 24             	mov    %ebx,(%esp)
80104dc5:	e8 86 c7 ff ff       	call   80101550 <iupdate>
  iunlockput(ip);
80104dca:	89 1c 24             	mov    %ebx,(%esp)
80104dcd:	e8 fe ca ff ff       	call   801018d0 <iunlockput>
  end_op();
80104dd2:	e8 49 de ff ff       	call   80102c20 <end_op>
  return -1;
80104dd7:	83 c4 10             	add    $0x10,%esp
}
80104dda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104ddd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104de2:	5b                   	pop    %ebx
80104de3:	5e                   	pop    %esi
80104de4:	5f                   	pop    %edi
80104de5:	5d                   	pop    %ebp
80104de6:	c3                   	ret    
80104de7:	89 f6                	mov    %esi,%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104df0:	83 ec 0c             	sub    $0xc,%esp
80104df3:	53                   	push   %ebx
80104df4:	e8 d7 ca ff ff       	call   801018d0 <iunlockput>
    end_op();
80104df9:	e8 22 de ff ff       	call   80102c20 <end_op>
    return -1;
80104dfe:	83 c4 10             	add    $0x10,%esp
80104e01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e06:	eb 92                	jmp    80104d9a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104e08:	e8 13 de ff ff       	call   80102c20 <end_op>
    return -1;
80104e0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e12:	eb 86                	jmp    80104d9a <sys_link+0xda>
80104e14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e20 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	57                   	push   %edi
80104e24:	56                   	push   %esi
80104e25:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e26:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e29:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e2c:	50                   	push   %eax
80104e2d:	6a 00                	push   $0x0
80104e2f:	e8 bc f9 ff ff       	call   801047f0 <argstr>
80104e34:	83 c4 10             	add    $0x10,%esp
80104e37:	85 c0                	test   %eax,%eax
80104e39:	0f 88 82 01 00 00    	js     80104fc1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104e3f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104e42:	e8 69 dd ff ff       	call   80102bb0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104e47:	83 ec 08             	sub    $0x8,%esp
80104e4a:	53                   	push   %ebx
80104e4b:	ff 75 c0             	pushl  -0x40(%ebp)
80104e4e:	e8 5d d0 ff ff       	call   80101eb0 <nameiparent>
80104e53:	83 c4 10             	add    $0x10,%esp
80104e56:	85 c0                	test   %eax,%eax
80104e58:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104e5b:	0f 84 6a 01 00 00    	je     80104fcb <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104e61:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104e64:	83 ec 0c             	sub    $0xc,%esp
80104e67:	56                   	push   %esi
80104e68:	e8 93 c7 ff ff       	call   80101600 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104e6d:	58                   	pop    %eax
80104e6e:	5a                   	pop    %edx
80104e6f:	68 e4 77 10 80       	push   $0x801077e4
80104e74:	53                   	push   %ebx
80104e75:	e8 d6 cc ff ff       	call   80101b50 <namecmp>
80104e7a:	83 c4 10             	add    $0x10,%esp
80104e7d:	85 c0                	test   %eax,%eax
80104e7f:	0f 84 fc 00 00 00    	je     80104f81 <sys_unlink+0x161>
80104e85:	83 ec 08             	sub    $0x8,%esp
80104e88:	68 e3 77 10 80       	push   $0x801077e3
80104e8d:	53                   	push   %ebx
80104e8e:	e8 bd cc ff ff       	call   80101b50 <namecmp>
80104e93:	83 c4 10             	add    $0x10,%esp
80104e96:	85 c0                	test   %eax,%eax
80104e98:	0f 84 e3 00 00 00    	je     80104f81 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104e9e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ea1:	83 ec 04             	sub    $0x4,%esp
80104ea4:	50                   	push   %eax
80104ea5:	53                   	push   %ebx
80104ea6:	56                   	push   %esi
80104ea7:	e8 c4 cc ff ff       	call   80101b70 <dirlookup>
80104eac:	83 c4 10             	add    $0x10,%esp
80104eaf:	85 c0                	test   %eax,%eax
80104eb1:	89 c3                	mov    %eax,%ebx
80104eb3:	0f 84 c8 00 00 00    	je     80104f81 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104eb9:	83 ec 0c             	sub    $0xc,%esp
80104ebc:	50                   	push   %eax
80104ebd:	e8 3e c7 ff ff       	call   80101600 <ilock>

  if(ip->nlink < 1)
80104ec2:	83 c4 10             	add    $0x10,%esp
80104ec5:	66 83 7b 16 00       	cmpw   $0x0,0x16(%ebx)
80104eca:	0f 8e 24 01 00 00    	jle    80104ff4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104ed0:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80104ed5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104ed8:	74 66                	je     80104f40 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104eda:	83 ec 04             	sub    $0x4,%esp
80104edd:	6a 10                	push   $0x10
80104edf:	6a 00                	push   $0x0
80104ee1:	56                   	push   %esi
80104ee2:	e8 89 f5 ff ff       	call   80104470 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ee7:	6a 10                	push   $0x10
80104ee9:	ff 75 c4             	pushl  -0x3c(%ebp)
80104eec:	56                   	push   %esi
80104eed:	ff 75 b4             	pushl  -0x4c(%ebp)
80104ef0:	e8 2b cb ff ff       	call   80101a20 <writei>
80104ef5:	83 c4 20             	add    $0x20,%esp
80104ef8:	83 f8 10             	cmp    $0x10,%eax
80104efb:	0f 85 e6 00 00 00    	jne    80104fe7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104f01:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80104f06:	0f 84 9c 00 00 00    	je     80104fa8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104f0c:	83 ec 0c             	sub    $0xc,%esp
80104f0f:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f12:	e8 b9 c9 ff ff       	call   801018d0 <iunlockput>

  ip->nlink--;
80104f17:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
80104f1c:	89 1c 24             	mov    %ebx,(%esp)
80104f1f:	e8 2c c6 ff ff       	call   80101550 <iupdate>
  iunlockput(ip);
80104f24:	89 1c 24             	mov    %ebx,(%esp)
80104f27:	e8 a4 c9 ff ff       	call   801018d0 <iunlockput>

  end_op();
80104f2c:	e8 ef dc ff ff       	call   80102c20 <end_op>

  return 0;
80104f31:	83 c4 10             	add    $0x10,%esp
80104f34:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104f36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f39:	5b                   	pop    %ebx
80104f3a:	5e                   	pop    %esi
80104f3b:	5f                   	pop    %edi
80104f3c:	5d                   	pop    %ebp
80104f3d:	c3                   	ret    
80104f3e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104f40:	83 7b 18 20          	cmpl   $0x20,0x18(%ebx)
80104f44:	76 94                	jbe    80104eda <sys_unlink+0xba>
80104f46:	bf 20 00 00 00       	mov    $0x20,%edi
80104f4b:	eb 0f                	jmp    80104f5c <sys_unlink+0x13c>
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi
80104f50:	83 c7 10             	add    $0x10,%edi
80104f53:	3b 7b 18             	cmp    0x18(%ebx),%edi
80104f56:	0f 83 7e ff ff ff    	jae    80104eda <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f5c:	6a 10                	push   $0x10
80104f5e:	57                   	push   %edi
80104f5f:	56                   	push   %esi
80104f60:	53                   	push   %ebx
80104f61:	e8 ba c9 ff ff       	call   80101920 <readi>
80104f66:	83 c4 10             	add    $0x10,%esp
80104f69:	83 f8 10             	cmp    $0x10,%eax
80104f6c:	75 6c                	jne    80104fda <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104f6e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104f73:	74 db                	je     80104f50 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104f75:	83 ec 0c             	sub    $0xc,%esp
80104f78:	53                   	push   %ebx
80104f79:	e8 52 c9 ff ff       	call   801018d0 <iunlockput>
    goto bad;
80104f7e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104f81:	83 ec 0c             	sub    $0xc,%esp
80104f84:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f87:	e8 44 c9 ff ff       	call   801018d0 <iunlockput>
  end_op();
80104f8c:	e8 8f dc ff ff       	call   80102c20 <end_op>
  return -1;
80104f91:	83 c4 10             	add    $0x10,%esp
}
80104f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104f97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f9c:	5b                   	pop    %ebx
80104f9d:	5e                   	pop    %esi
80104f9e:	5f                   	pop    %edi
80104f9f:	5d                   	pop    %ebp
80104fa0:	c3                   	ret    
80104fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104fa8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80104fab:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104fae:	66 83 68 16 01       	subw   $0x1,0x16(%eax)
    iupdate(dp);
80104fb3:	50                   	push   %eax
80104fb4:	e8 97 c5 ff ff       	call   80101550 <iupdate>
80104fb9:	83 c4 10             	add    $0x10,%esp
80104fbc:	e9 4b ff ff ff       	jmp    80104f0c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80104fc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fc6:	e9 6b ff ff ff       	jmp    80104f36 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80104fcb:	e8 50 dc ff ff       	call   80102c20 <end_op>
    return -1;
80104fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd5:	e9 5c ff ff ff       	jmp    80104f36 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104fda:	83 ec 0c             	sub    $0xc,%esp
80104fdd:	68 08 78 10 80       	push   $0x80107808
80104fe2:	e8 69 b3 ff ff       	call   80100350 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104fe7:	83 ec 0c             	sub    $0xc,%esp
80104fea:	68 1a 78 10 80       	push   $0x8010781a
80104fef:	e8 5c b3 ff ff       	call   80100350 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104ff4:	83 ec 0c             	sub    $0xc,%esp
80104ff7:	68 f6 77 10 80       	push   $0x801077f6
80104ffc:	e8 4f b3 ff ff       	call   80100350 <panic>
80105001:	eb 0d                	jmp    80105010 <sys_open>
80105003:	90                   	nop
80105004:	90                   	nop
80105005:	90                   	nop
80105006:	90                   	nop
80105007:	90                   	nop
80105008:	90                   	nop
80105009:	90                   	nop
8010500a:	90                   	nop
8010500b:	90                   	nop
8010500c:	90                   	nop
8010500d:	90                   	nop
8010500e:	90                   	nop
8010500f:	90                   	nop

80105010 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	57                   	push   %edi
80105014:	56                   	push   %esi
80105015:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105016:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105019:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010501c:	50                   	push   %eax
8010501d:	6a 00                	push   $0x0
8010501f:	e8 cc f7 ff ff       	call   801047f0 <argstr>
80105024:	83 c4 10             	add    $0x10,%esp
80105027:	85 c0                	test   %eax,%eax
80105029:	0f 88 9e 00 00 00    	js     801050cd <sys_open+0xbd>
8010502f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105032:	83 ec 08             	sub    $0x8,%esp
80105035:	50                   	push   %eax
80105036:	6a 01                	push   $0x1
80105038:	e8 23 f7 ff ff       	call   80104760 <argint>
8010503d:	83 c4 10             	add    $0x10,%esp
80105040:	85 c0                	test   %eax,%eax
80105042:	0f 88 85 00 00 00    	js     801050cd <sys_open+0xbd>
    return -1;

  begin_op();
80105048:	e8 63 db ff ff       	call   80102bb0 <begin_op>

  if(omode & O_CREATE){
8010504d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105051:	0f 85 89 00 00 00    	jne    801050e0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105057:	83 ec 0c             	sub    $0xc,%esp
8010505a:	ff 75 e0             	pushl  -0x20(%ebp)
8010505d:	e8 2e ce ff ff       	call   80101e90 <namei>
80105062:	83 c4 10             	add    $0x10,%esp
80105065:	85 c0                	test   %eax,%eax
80105067:	89 c7                	mov    %eax,%edi
80105069:	0f 84 8e 00 00 00    	je     801050fd <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010506f:	83 ec 0c             	sub    $0xc,%esp
80105072:	50                   	push   %eax
80105073:	e8 88 c5 ff ff       	call   80101600 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105078:	83 c4 10             	add    $0x10,%esp
8010507b:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
80105080:	0f 84 d2 00 00 00    	je     80105158 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105086:	e8 b5 bc ff ff       	call   80100d40 <filealloc>
8010508b:	85 c0                	test   %eax,%eax
8010508d:	89 c6                	mov    %eax,%esi
8010508f:	74 2b                	je     801050bc <sys_open+0xac>
80105091:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105098:	31 db                	xor    %ebx,%ebx
8010509a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801050a0:	8b 44 9a 28          	mov    0x28(%edx,%ebx,4),%eax
801050a4:	85 c0                	test   %eax,%eax
801050a6:	74 68                	je     80105110 <sys_open+0x100>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801050a8:	83 c3 01             	add    $0x1,%ebx
801050ab:	83 fb 10             	cmp    $0x10,%ebx
801050ae:	75 f0                	jne    801050a0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801050b0:	83 ec 0c             	sub    $0xc,%esp
801050b3:	56                   	push   %esi
801050b4:	e8 47 bd ff ff       	call   80100e00 <fileclose>
801050b9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801050bc:	83 ec 0c             	sub    $0xc,%esp
801050bf:	57                   	push   %edi
801050c0:	e8 0b c8 ff ff       	call   801018d0 <iunlockput>
    end_op();
801050c5:	e8 56 db ff ff       	call   80102c20 <end_op>
    return -1;
801050ca:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801050cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801050d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801050d5:	5b                   	pop    %ebx
801050d6:	5e                   	pop    %esi
801050d7:	5f                   	pop    %edi
801050d8:	5d                   	pop    %ebp
801050d9:	c3                   	ret    
801050da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801050e0:	83 ec 0c             	sub    $0xc,%esp
801050e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050e6:	31 c9                	xor    %ecx,%ecx
801050e8:	6a 00                	push   $0x0
801050ea:	ba 02 00 00 00       	mov    $0x2,%edx
801050ef:	e8 ec f7 ff ff       	call   801048e0 <create>
    if(ip == 0){
801050f4:	83 c4 10             	add    $0x10,%esp
801050f7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801050f9:	89 c7                	mov    %eax,%edi
    if(ip == 0){
801050fb:	75 89                	jne    80105086 <sys_open+0x76>
      end_op();
801050fd:	e8 1e db ff ff       	call   80102c20 <end_op>
      return -1;
80105102:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105107:	eb 43                	jmp    8010514c <sys_open+0x13c>
80105109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105110:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105113:	89 74 9a 28          	mov    %esi,0x28(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105117:	57                   	push   %edi
80105118:	e8 f3 c5 ff ff       	call   80101710 <iunlock>
  end_op();
8010511d:	e8 fe da ff ff       	call   80102c20 <end_op>

  f->type = FD_INODE;
80105122:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105128:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010512b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010512e:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
80105131:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
80105138:	89 d0                	mov    %edx,%eax
8010513a:	83 e0 01             	and    $0x1,%eax
8010513d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105140:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105143:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105146:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
8010514a:	89 d8                	mov    %ebx,%eax
}
8010514c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010514f:	5b                   	pop    %ebx
80105150:	5e                   	pop    %esi
80105151:	5f                   	pop    %edi
80105152:	5d                   	pop    %ebp
80105153:	c3                   	ret    
80105154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105158:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010515b:	85 d2                	test   %edx,%edx
8010515d:	0f 84 23 ff ff ff    	je     80105086 <sys_open+0x76>
80105163:	e9 54 ff ff ff       	jmp    801050bc <sys_open+0xac>
80105168:	90                   	nop
80105169:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105170 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105176:	e8 35 da ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010517b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010517e:	83 ec 08             	sub    $0x8,%esp
80105181:	50                   	push   %eax
80105182:	6a 00                	push   $0x0
80105184:	e8 67 f6 ff ff       	call   801047f0 <argstr>
80105189:	83 c4 10             	add    $0x10,%esp
8010518c:	85 c0                	test   %eax,%eax
8010518e:	78 30                	js     801051c0 <sys_mkdir+0x50>
80105190:	83 ec 0c             	sub    $0xc,%esp
80105193:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105196:	31 c9                	xor    %ecx,%ecx
80105198:	6a 00                	push   $0x0
8010519a:	ba 01 00 00 00       	mov    $0x1,%edx
8010519f:	e8 3c f7 ff ff       	call   801048e0 <create>
801051a4:	83 c4 10             	add    $0x10,%esp
801051a7:	85 c0                	test   %eax,%eax
801051a9:	74 15                	je     801051c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801051ab:	83 ec 0c             	sub    $0xc,%esp
801051ae:	50                   	push   %eax
801051af:	e8 1c c7 ff ff       	call   801018d0 <iunlockput>
  end_op();
801051b4:	e8 67 da ff ff       	call   80102c20 <end_op>
  return 0;
801051b9:	83 c4 10             	add    $0x10,%esp
801051bc:	31 c0                	xor    %eax,%eax
}
801051be:	c9                   	leave  
801051bf:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801051c0:	e8 5b da ff ff       	call   80102c20 <end_op>
    return -1;
801051c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801051ca:	c9                   	leave  
801051cb:	c3                   	ret    
801051cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051d0 <sys_mknod>:

int
sys_mknod(void)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801051d6:	e8 d5 d9 ff ff       	call   80102bb0 <begin_op>
  if((argstr(0, &path)) < 0 ||
801051db:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051de:	83 ec 08             	sub    $0x8,%esp
801051e1:	50                   	push   %eax
801051e2:	6a 00                	push   $0x0
801051e4:	e8 07 f6 ff ff       	call   801047f0 <argstr>
801051e9:	83 c4 10             	add    $0x10,%esp
801051ec:	85 c0                	test   %eax,%eax
801051ee:	78 60                	js     80105250 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801051f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051f3:	83 ec 08             	sub    $0x8,%esp
801051f6:	50                   	push   %eax
801051f7:	6a 01                	push   $0x1
801051f9:	e8 62 f5 ff ff       	call   80104760 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801051fe:	83 c4 10             	add    $0x10,%esp
80105201:	85 c0                	test   %eax,%eax
80105203:	78 4b                	js     80105250 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105205:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105208:	83 ec 08             	sub    $0x8,%esp
8010520b:	50                   	push   %eax
8010520c:	6a 02                	push   $0x2
8010520e:	e8 4d f5 ff ff       	call   80104760 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105213:	83 c4 10             	add    $0x10,%esp
80105216:	85 c0                	test   %eax,%eax
80105218:	78 36                	js     80105250 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010521a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010521e:	83 ec 0c             	sub    $0xc,%esp
80105221:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105225:	ba 03 00 00 00       	mov    $0x3,%edx
8010522a:	50                   	push   %eax
8010522b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010522e:	e8 ad f6 ff ff       	call   801048e0 <create>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	85 c0                	test   %eax,%eax
80105238:	74 16                	je     80105250 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010523a:	83 ec 0c             	sub    $0xc,%esp
8010523d:	50                   	push   %eax
8010523e:	e8 8d c6 ff ff       	call   801018d0 <iunlockput>
  end_op();
80105243:	e8 d8 d9 ff ff       	call   80102c20 <end_op>
  return 0;
80105248:	83 c4 10             	add    $0x10,%esp
8010524b:	31 c0                	xor    %eax,%eax
}
8010524d:	c9                   	leave  
8010524e:	c3                   	ret    
8010524f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105250:	e8 cb d9 ff ff       	call   80102c20 <end_op>
    return -1;
80105255:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010525a:	c9                   	leave  
8010525b:	c3                   	ret    
8010525c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105260 <sys_chdir>:

int
sys_chdir(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	53                   	push   %ebx
80105264:	83 ec 14             	sub    $0x14,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105267:	e8 44 d9 ff ff       	call   80102bb0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010526c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010526f:	83 ec 08             	sub    $0x8,%esp
80105272:	50                   	push   %eax
80105273:	6a 00                	push   $0x0
80105275:	e8 76 f5 ff ff       	call   801047f0 <argstr>
8010527a:	83 c4 10             	add    $0x10,%esp
8010527d:	85 c0                	test   %eax,%eax
8010527f:	78 7f                	js     80105300 <sys_chdir+0xa0>
80105281:	83 ec 0c             	sub    $0xc,%esp
80105284:	ff 75 f4             	pushl  -0xc(%ebp)
80105287:	e8 04 cc ff ff       	call   80101e90 <namei>
8010528c:	83 c4 10             	add    $0x10,%esp
8010528f:	85 c0                	test   %eax,%eax
80105291:	89 c3                	mov    %eax,%ebx
80105293:	74 6b                	je     80105300 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105295:	83 ec 0c             	sub    $0xc,%esp
80105298:	50                   	push   %eax
80105299:	e8 62 c3 ff ff       	call   80101600 <ilock>
  if(ip->type != T_DIR){
8010529e:	83 c4 10             	add    $0x10,%esp
801052a1:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
801052a6:	75 38                	jne    801052e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801052a8:	83 ec 0c             	sub    $0xc,%esp
801052ab:	53                   	push   %ebx
801052ac:	e8 5f c4 ff ff       	call   80101710 <iunlock>
  iput(proc->cwd);
801052b1:	58                   	pop    %eax
801052b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052b8:	ff 70 68             	pushl  0x68(%eax)
801052bb:	e8 b0 c4 ff ff       	call   80101770 <iput>
  end_op();
801052c0:	e8 5b d9 ff ff       	call   80102c20 <end_op>
  proc->cwd = ip;
801052c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return 0;
801052cb:	83 c4 10             	add    $0x10,%esp
    return -1;
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
801052ce:	89 58 68             	mov    %ebx,0x68(%eax)
  return 0;
801052d1:	31 c0                	xor    %eax,%eax
}
801052d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052d6:	c9                   	leave  
801052d7:	c3                   	ret    
801052d8:	90                   	nop
801052d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801052e0:	83 ec 0c             	sub    $0xc,%esp
801052e3:	53                   	push   %ebx
801052e4:	e8 e7 c5 ff ff       	call   801018d0 <iunlockput>
    end_op();
801052e9:	e8 32 d9 ff ff       	call   80102c20 <end_op>
    return -1;
801052ee:	83 c4 10             	add    $0x10,%esp
801052f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052f6:	eb db                	jmp    801052d3 <sys_chdir+0x73>
801052f8:	90                   	nop
801052f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105300:	e8 1b d9 ff ff       	call   80102c20 <end_op>
    return -1;
80105305:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010530a:	eb c7                	jmp    801052d3 <sys_chdir+0x73>
8010530c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105310 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105310:	55                   	push   %ebp
80105311:	89 e5                	mov    %esp,%ebp
80105313:	57                   	push   %edi
80105314:	56                   	push   %esi
80105315:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105316:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010531c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105322:	50                   	push   %eax
80105323:	6a 00                	push   $0x0
80105325:	e8 c6 f4 ff ff       	call   801047f0 <argstr>
8010532a:	83 c4 10             	add    $0x10,%esp
8010532d:	85 c0                	test   %eax,%eax
8010532f:	78 7f                	js     801053b0 <sys_exec+0xa0>
80105331:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105337:	83 ec 08             	sub    $0x8,%esp
8010533a:	50                   	push   %eax
8010533b:	6a 01                	push   $0x1
8010533d:	e8 1e f4 ff ff       	call   80104760 <argint>
80105342:	83 c4 10             	add    $0x10,%esp
80105345:	85 c0                	test   %eax,%eax
80105347:	78 67                	js     801053b0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105349:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010534f:	83 ec 04             	sub    $0x4,%esp
80105352:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105358:	68 80 00 00 00       	push   $0x80
8010535d:	6a 00                	push   $0x0
8010535f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105365:	50                   	push   %eax
80105366:	31 db                	xor    %ebx,%ebx
80105368:	e8 03 f1 ff ff       	call   80104470 <memset>
8010536d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105370:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105376:	83 ec 08             	sub    $0x8,%esp
80105379:	57                   	push   %edi
8010537a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010537d:	50                   	push   %eax
8010537e:	e8 5d f3 ff ff       	call   801046e0 <fetchint>
80105383:	83 c4 10             	add    $0x10,%esp
80105386:	85 c0                	test   %eax,%eax
80105388:	78 26                	js     801053b0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010538a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105390:	85 c0                	test   %eax,%eax
80105392:	74 2c                	je     801053c0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105394:	83 ec 08             	sub    $0x8,%esp
80105397:	56                   	push   %esi
80105398:	50                   	push   %eax
80105399:	e8 72 f3 ff ff       	call   80104710 <fetchstr>
8010539e:	83 c4 10             	add    $0x10,%esp
801053a1:	85 c0                	test   %eax,%eax
801053a3:	78 0b                	js     801053b0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801053a5:	83 c3 01             	add    $0x1,%ebx
801053a8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801053ab:	83 fb 20             	cmp    $0x20,%ebx
801053ae:	75 c0                	jne    80105370 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801053b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801053b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801053b8:	5b                   	pop    %ebx
801053b9:	5e                   	pop    %esi
801053ba:	5f                   	pop    %edi
801053bb:	5d                   	pop    %ebp
801053bc:	c3                   	ret    
801053bd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801053c0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801053c6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801053c9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801053d0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801053d4:	50                   	push   %eax
801053d5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801053db:	e8 f0 b5 ff ff       	call   801009d0 <exec>
801053e0:	83 c4 10             	add    $0x10,%esp
}
801053e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053e6:	5b                   	pop    %ebx
801053e7:	5e                   	pop    %esi
801053e8:	5f                   	pop    %edi
801053e9:	5d                   	pop    %ebp
801053ea:	c3                   	ret    
801053eb:	90                   	nop
801053ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053f0 <sys_pipe>:

int
sys_pipe(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	57                   	push   %edi
801053f4:	56                   	push   %esi
801053f5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801053f6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
801053f9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801053fc:	6a 08                	push   $0x8
801053fe:	50                   	push   %eax
801053ff:	6a 00                	push   $0x0
80105401:	e8 9a f3 ff ff       	call   801047a0 <argptr>
80105406:	83 c4 10             	add    $0x10,%esp
80105409:	85 c0                	test   %eax,%eax
8010540b:	78 48                	js     80105455 <sys_pipe+0x65>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010540d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105410:	83 ec 08             	sub    $0x8,%esp
80105413:	50                   	push   %eax
80105414:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105417:	50                   	push   %eax
80105418:	e8 43 df ff ff       	call   80103360 <pipealloc>
8010541d:	83 c4 10             	add    $0x10,%esp
80105420:	85 c0                	test   %eax,%eax
80105422:	78 31                	js     80105455 <sys_pipe+0x65>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105424:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80105427:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010542e:	31 c0                	xor    %eax,%eax
    if(proc->ofile[fd] == 0){
80105430:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80105434:	85 d2                	test   %edx,%edx
80105436:	74 28                	je     80105460 <sys_pipe+0x70>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105438:	83 c0 01             	add    $0x1,%eax
8010543b:	83 f8 10             	cmp    $0x10,%eax
8010543e:	75 f0                	jne    80105430 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
80105440:	83 ec 0c             	sub    $0xc,%esp
80105443:	53                   	push   %ebx
80105444:	e8 b7 b9 ff ff       	call   80100e00 <fileclose>
    fileclose(wf);
80105449:	58                   	pop    %eax
8010544a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010544d:	e8 ae b9 ff ff       	call   80100e00 <fileclose>
    return -1;
80105452:	83 c4 10             	add    $0x10,%esp
80105455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010545a:	eb 45                	jmp    801054a1 <sys_pipe+0xb1>
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105460:	8d 34 81             	lea    (%ecx,%eax,4),%esi
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105463:	8b 7d e4             	mov    -0x1c(%ebp),%edi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105466:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105468:	89 5e 28             	mov    %ebx,0x28(%esi)
8010546b:	90                   	nop
8010546c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105470:	83 7c 91 28 00       	cmpl   $0x0,0x28(%ecx,%edx,4)
80105475:	74 19                	je     80105490 <sys_pipe+0xa0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105477:	83 c2 01             	add    $0x1,%edx
8010547a:	83 fa 10             	cmp    $0x10,%edx
8010547d:	75 f1                	jne    80105470 <sys_pipe+0x80>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
8010547f:	c7 46 28 00 00 00 00 	movl   $0x0,0x28(%esi)
80105486:	eb b8                	jmp    80105440 <sys_pipe+0x50>
80105488:	90                   	nop
80105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105490:	89 7c 91 28          	mov    %edi,0x28(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105494:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105497:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
80105499:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010549c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010549f:	31 c0                	xor    %eax,%eax
}
801054a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054a4:	5b                   	pop    %ebx
801054a5:	5e                   	pop    %esi
801054a6:	5f                   	pop    %edi
801054a7:	5d                   	pop    %ebp
801054a8:	c3                   	ret    
801054a9:	66 90                	xchg   %ax,%ax
801054ab:	66 90                	xchg   %ax,%ax
801054ad:	66 90                	xchg   %ax,%ax
801054af:	90                   	nop

801054b0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801054b3:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
801054b4:	e9 17 e5 ff ff       	jmp    801039d0 <fork>
801054b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054c0 <sys_exit>:
}

int
sys_exit(void)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	83 ec 08             	sub    $0x8,%esp
  exit();
801054c6:	e8 a5 e7 ff ff       	call   80103c70 <exit>
  return 0;  // not reached
}
801054cb:	31 c0                	xor    %eax,%eax
801054cd:	c9                   	leave  
801054ce:	c3                   	ret    
801054cf:	90                   	nop

801054d0 <sys_wait>:

int
sys_wait(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801054d3:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
801054d4:	e9 e7 e9 ff ff       	jmp    80103ec0 <wait>
801054d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054e0 <sys_kill>:
}

int
sys_kill(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801054e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054e9:	50                   	push   %eax
801054ea:	6a 00                	push   $0x0
801054ec:	e8 6f f2 ff ff       	call   80104760 <argint>
801054f1:	83 c4 10             	add    $0x10,%esp
801054f4:	85 c0                	test   %eax,%eax
801054f6:	78 18                	js     80105510 <sys_kill+0x30>
    return -1;
  return kill(pid);
801054f8:	83 ec 0c             	sub    $0xc,%esp
801054fb:	ff 75 f4             	pushl  -0xc(%ebp)
801054fe:	e8 fd ea ff ff       	call   80104000 <kill>
80105503:	83 c4 10             	add    $0x10,%esp
}
80105506:	c9                   	leave  
80105507:	c3                   	ret    
80105508:	90                   	nop
80105509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105515:	c9                   	leave  
80105516:	c3                   	ret    
80105517:	89 f6                	mov    %esi,%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105520 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
80105520:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
80105526:	55                   	push   %ebp
80105527:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80105529:	8b 40 10             	mov    0x10(%eax),%eax
}
8010552c:	5d                   	pop    %ebp
8010552d:	c3                   	ret    
8010552e:	66 90                	xchg   %ax,%ax

80105530 <sys_sbrk>:

int
sys_sbrk(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105534:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return proc->pid;
}

int
sys_sbrk(void)
{
80105537:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010553a:	50                   	push   %eax
8010553b:	6a 00                	push   $0x0
8010553d:	e8 1e f2 ff ff       	call   80104760 <argint>
80105542:	83 c4 10             	add    $0x10,%esp
80105545:	85 c0                	test   %eax,%eax
80105547:	78 27                	js     80105570 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
80105549:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
8010554f:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
80105552:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105554:	ff 75 f4             	pushl  -0xc(%ebp)
80105557:	e8 04 e4 ff ff       	call   80103960 <growproc>
8010555c:	83 c4 10             	add    $0x10,%esp
8010555f:	85 c0                	test   %eax,%eax
80105561:	78 0d                	js     80105570 <sys_sbrk+0x40>
    return -1;
  return addr;
80105563:	89 d8                	mov    %ebx,%eax
}
80105565:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105568:	c9                   	leave  
80105569:	c3                   	ret    
8010556a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105575:	eb ee                	jmp    80105565 <sys_sbrk+0x35>
80105577:	89 f6                	mov    %esi,%esi
80105579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105580 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105584:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105587:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010558a:	50                   	push   %eax
8010558b:	6a 00                	push   $0x0
8010558d:	e8 ce f1 ff ff       	call   80104760 <argint>
80105592:	83 c4 10             	add    $0x10,%esp
80105595:	85 c0                	test   %eax,%eax
80105597:	0f 88 8a 00 00 00    	js     80105627 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010559d:	83 ec 0c             	sub    $0xc,%esp
801055a0:	68 c0 38 11 80       	push   $0x801138c0
801055a5:	e8 96 ec ff ff       	call   80104240 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801055aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055ad:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
801055b0:	8b 1d 00 41 11 80    	mov    0x80114100,%ebx
  while(ticks - ticks0 < n){
801055b6:	85 d2                	test   %edx,%edx
801055b8:	75 27                	jne    801055e1 <sys_sleep+0x61>
801055ba:	eb 54                	jmp    80105610 <sys_sleep+0x90>
801055bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801055c0:	83 ec 08             	sub    $0x8,%esp
801055c3:	68 c0 38 11 80       	push   $0x801138c0
801055c8:	68 00 41 11 80       	push   $0x80114100
801055cd:	e8 2e e8 ff ff       	call   80103e00 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801055d2:	a1 00 41 11 80       	mov    0x80114100,%eax
801055d7:	83 c4 10             	add    $0x10,%esp
801055da:	29 d8                	sub    %ebx,%eax
801055dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801055df:	73 2f                	jae    80105610 <sys_sleep+0x90>
    if(proc->killed){
801055e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055e7:	8b 40 24             	mov    0x24(%eax),%eax
801055ea:	85 c0                	test   %eax,%eax
801055ec:	74 d2                	je     801055c0 <sys_sleep+0x40>
      release(&tickslock);
801055ee:	83 ec 0c             	sub    $0xc,%esp
801055f1:	68 c0 38 11 80       	push   $0x801138c0
801055f6:	e8 25 ee ff ff       	call   80104420 <release>
      return -1;
801055fb:	83 c4 10             	add    $0x10,%esp
801055fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105603:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105606:	c9                   	leave  
80105607:	c3                   	ret    
80105608:	90                   	nop
80105609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	68 c0 38 11 80       	push   $0x801138c0
80105618:	e8 03 ee ff ff       	call   80104420 <release>
  return 0;
8010561d:	83 c4 10             	add    $0x10,%esp
80105620:	31 c0                	xor    %eax,%eax
}
80105622:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105625:	c9                   	leave  
80105626:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
80105627:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010562c:	eb d5                	jmp    80105603 <sys_sleep+0x83>
8010562e:	66 90                	xchg   %ax,%ax

80105630 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	53                   	push   %ebx
80105634:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105637:	68 c0 38 11 80       	push   $0x801138c0
8010563c:	e8 ff eb ff ff       	call   80104240 <acquire>
  xticks = ticks;
80105641:	8b 1d 00 41 11 80    	mov    0x80114100,%ebx
  release(&tickslock);
80105647:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
8010564e:	e8 cd ed ff ff       	call   80104420 <release>
  return xticks;
}
80105653:	89 d8                	mov    %ebx,%eax
80105655:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105658:	c9                   	leave  
80105659:	c3                   	ret    
8010565a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105660 <sys_sem_init>:

int
sys_sem_init(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	83 ec 20             	sub    $0x20,%esp
  int semaphore,value;
  if(argint(0,&semaphore) < 0 || argint(1,&value) < 0){
80105666:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105669:	50                   	push   %eax
8010566a:	6a 00                	push   $0x0
8010566c:	e8 ef f0 ff ff       	call   80104760 <argint>
80105671:	83 c4 10             	add    $0x10,%esp
80105674:	85 c0                	test   %eax,%eax
80105676:	78 58                	js     801056d0 <sys_sem_init+0x70>
80105678:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010567b:	83 ec 08             	sub    $0x8,%esp
8010567e:	50                   	push   %eax
8010567f:	6a 01                	push   $0x1
80105681:	e8 da f0 ff ff       	call   80104760 <argint>
80105686:	83 c4 10             	add    $0x10,%esp
80105689:	85 c0                	test   %eax,%eax
8010568b:	78 43                	js     801056d0 <sys_sem_init+0x70>
    return -1;
  }
  acquire(&semlock);
8010568d:	83 ec 0c             	sub    $0xc,%esp
80105690:	68 80 38 11 80       	push   $0x80113880
80105695:	e8 a6 eb ff ff       	call   80104240 <acquire>
  if(semaphore>=0 && semaphore<MAX_SEM){
8010569a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	83 f8 13             	cmp    $0x13,%eax
801056a3:	77 14                	ja     801056b9 <sys_sem_init+0x59>
    if(value >=0){
801056a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801056a8:	85 d2                	test   %edx,%edx
801056aa:	78 0d                	js     801056b9 <sys_sem_init+0x59>
      sem_init(semaphore,value);
801056ac:	83 ec 08             	sub    $0x8,%esp
801056af:	52                   	push   %edx
801056b0:	50                   	push   %eax
801056b1:	e8 9a ea ff ff       	call   80104150 <sem_init>
801056b6:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&semlock);
801056b9:	83 ec 0c             	sub    $0xc,%esp
801056bc:	68 80 38 11 80       	push   $0x80113880
801056c1:	e8 5a ed ff ff       	call   80104420 <release>
  return 0;
801056c6:	83 c4 10             	add    $0x10,%esp
801056c9:	31 c0                	xor    %eax,%eax
}
801056cb:	c9                   	leave  
801056cc:	c3                   	ret    
801056cd:	8d 76 00             	lea    0x0(%esi),%esi
int
sys_sem_init(void)
{
  int semaphore,value;
  if(argint(0,&semaphore) < 0 || argint(1,&value) < 0){
    return -1;
801056d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      sem_init(semaphore,value);
    }
  }
  release(&semlock);
  return 0;
}
801056d5:	c9                   	leave  
801056d6:	c3                   	ret    
801056d7:	89 f6                	mov    %esi,%esi
801056d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056e0 <sys_sem_release>:

int
sys_sem_release(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	83 ec 20             	sub    $0x20,%esp
  int semaphore;
  if(argint(0,&semaphore) < 0){
801056e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056e9:	50                   	push   %eax
801056ea:	6a 00                	push   $0x0
801056ec:	e8 6f f0 ff ff       	call   80104760 <argint>
801056f1:	83 c4 10             	add    $0x10,%esp
801056f4:	85 c0                	test   %eax,%eax
801056f6:	78 30                	js     80105728 <sys_sem_release+0x48>
    return -1;
  }
  acquire(&semlock);
801056f8:	83 ec 0c             	sub    $0xc,%esp
801056fb:	68 80 38 11 80       	push   $0x80113880
80105700:	e8 3b eb ff ff       	call   80104240 <acquire>
  sem_release(semaphore);
80105705:	58                   	pop    %eax
80105706:	ff 75 f4             	pushl  -0xc(%ebp)
80105709:	e8 62 ea ff ff       	call   80104170 <sem_release>
  release(&semlock);
8010570e:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80105715:	e8 06 ed ff ff       	call   80104420 <release>
  return 0;
8010571a:	83 c4 10             	add    $0x10,%esp
8010571d:	31 c0                	xor    %eax,%eax
}
8010571f:	c9                   	leave  
80105720:	c3                   	ret    
80105721:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
int
sys_sem_release(void)
{
  int semaphore;
  if(argint(0,&semaphore) < 0){
    return -1;
80105728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  acquire(&semlock);
  sem_release(semaphore);
  release(&semlock);
  return 0;
}
8010572d:	c9                   	leave  
8010572e:	c3                   	ret    
8010572f:	90                   	nop

80105730 <sys_sem_up>:

int
sys_sem_up(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 20             	sub    $0x20,%esp
  int semaphore;
  if(argint(0,&semaphore) < 0){
80105736:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105739:	50                   	push   %eax
8010573a:	6a 00                	push   $0x0
8010573c:	e8 1f f0 ff ff       	call   80104760 <argint>
80105741:	83 c4 10             	add    $0x10,%esp
80105744:	85 c0                	test   %eax,%eax
80105746:	78 30                	js     80105778 <sys_sem_up+0x48>
    return -1;
  }
  acquire(&semlock);
80105748:	83 ec 0c             	sub    $0xc,%esp
8010574b:	68 80 38 11 80       	push   $0x80113880
80105750:	e8 eb ea ff ff       	call   80104240 <acquire>
  sem_up(semaphore);
80105755:	58                   	pop    %eax
80105756:	ff 75 f4             	pushl  -0xc(%ebp)
80105759:	e8 82 ea ff ff       	call   801041e0 <sem_up>
  release(&semlock);
8010575e:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
80105765:	e8 b6 ec ff ff       	call   80104420 <release>
  return 0;
8010576a:	83 c4 10             	add    $0x10,%esp
8010576d:	31 c0                	xor    %eax,%eax
}
8010576f:	c9                   	leave  
80105770:	c3                   	ret    
80105771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
int
sys_sem_up(void)
{
  int semaphore;
  if(argint(0,&semaphore) < 0){
    return -1;
80105778:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  acquire(&semlock);
  sem_up(semaphore);
  release(&semlock);
  return 0;
}
8010577d:	c9                   	leave  
8010577e:	c3                   	ret    
8010577f:	90                   	nop

80105780 <sys_sem_down>:

int
sys_sem_down(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	83 ec 20             	sub    $0x20,%esp
  int semaphore;
  if(argint(0,&semaphore) < 0){
80105786:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105789:	50                   	push   %eax
8010578a:	6a 00                	push   $0x0
8010578c:	e8 cf ef ff ff       	call   80104760 <argint>
80105791:	83 c4 10             	add    $0x10,%esp
80105794:	85 c0                	test   %eax,%eax
80105796:	78 30                	js     801057c8 <sys_sem_down+0x48>
    return -1;
  }
  acquire(&semlock);
80105798:	83 ec 0c             	sub    $0xc,%esp
8010579b:	68 80 38 11 80       	push   $0x80113880
801057a0:	e8 9b ea ff ff       	call   80104240 <acquire>
  sem_down(semaphore);
801057a5:	58                   	pop    %eax
801057a6:	ff 75 f4             	pushl  -0xc(%ebp)
801057a9:	e8 e2 e9 ff ff       	call   80104190 <sem_down>
  release(&semlock);
801057ae:	c7 04 24 80 38 11 80 	movl   $0x80113880,(%esp)
801057b5:	e8 66 ec ff ff       	call   80104420 <release>
  return 0;
801057ba:	83 c4 10             	add    $0x10,%esp
801057bd:	31 c0                	xor    %eax,%eax
}
801057bf:	c9                   	leave  
801057c0:	c3                   	ret    
801057c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
int
sys_sem_down(void)
{
  int semaphore;
  if(argint(0,&semaphore) < 0){
    return -1;
801057c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  acquire(&semlock);
  sem_down(semaphore);
  release(&semlock);
  return 0;
}
801057cd:	c9                   	leave  
801057ce:	c3                   	ret    
801057cf:	90                   	nop

801057d0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801057d0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801057d1:	ba 43 00 00 00       	mov    $0x43,%edx
801057d6:	b8 34 00 00 00       	mov    $0x34,%eax
801057db:	89 e5                	mov    %esp,%ebp
801057dd:	83 ec 14             	sub    $0x14,%esp
801057e0:	ee                   	out    %al,(%dx)
801057e1:	ba 40 00 00 00       	mov    $0x40,%edx
801057e6:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
801057eb:	ee                   	out    %al,(%dx)
801057ec:	b8 2e 00 00 00       	mov    $0x2e,%eax
801057f1:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
801057f2:	6a 00                	push   $0x0
801057f4:	e8 97 da ff ff       	call   80103290 <picenable>
}
801057f9:	83 c4 10             	add    $0x10,%esp
801057fc:	c9                   	leave  
801057fd:	c3                   	ret    

801057fe <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801057fe:	1e                   	push   %ds
  pushl %es
801057ff:	06                   	push   %es
  pushl %fs
80105800:	0f a0                	push   %fs
  pushl %gs
80105802:	0f a8                	push   %gs
  pushal
80105804:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105805:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105809:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010580b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010580d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105811:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105813:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105815:	54                   	push   %esp
  call trap
80105816:	e8 e5 00 00 00       	call   80105900 <trap>
  addl $4, %esp
8010581b:	83 c4 04             	add    $0x4,%esp

8010581e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010581e:	61                   	popa   
  popl %gs
8010581f:	0f a9                	pop    %gs
  popl %fs
80105821:	0f a1                	pop    %fs
  popl %es
80105823:	07                   	pop    %es
  popl %ds
80105824:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105825:	83 c4 08             	add    $0x8,%esp
  iret
80105828:	cf                   	iret   
80105829:	66 90                	xchg   %ax,%ax
8010582b:	66 90                	xchg   %ax,%ax
8010582d:	66 90                	xchg   %ax,%ax
8010582f:	90                   	nop

80105830 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105830:	31 c0                	xor    %eax,%eax
80105832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105838:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
8010583f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105844:	c6 04 c5 04 39 11 80 	movb   $0x0,-0x7feec6fc(,%eax,8)
8010584b:	00 
8010584c:	66 89 0c c5 02 39 11 	mov    %cx,-0x7feec6fe(,%eax,8)
80105853:	80 
80105854:	c6 04 c5 05 39 11 80 	movb   $0x8e,-0x7feec6fb(,%eax,8)
8010585b:	8e 
8010585c:	66 89 14 c5 00 39 11 	mov    %dx,-0x7feec700(,%eax,8)
80105863:	80 
80105864:	c1 ea 10             	shr    $0x10,%edx
80105867:	66 89 14 c5 06 39 11 	mov    %dx,-0x7feec6fa(,%eax,8)
8010586e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010586f:	83 c0 01             	add    $0x1,%eax
80105872:	3d 00 01 00 00       	cmp    $0x100,%eax
80105877:	75 bf                	jne    80105838 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105879:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010587a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010587f:	89 e5                	mov    %esp,%ebp
80105881:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105884:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
80105889:	68 29 78 10 80       	push   $0x80107829
8010588e:	68 c0 38 11 80       	push   $0x801138c0
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105893:	66 89 15 02 3b 11 80 	mov    %dx,0x80113b02
8010589a:	c6 05 04 3b 11 80 00 	movb   $0x0,0x80113b04
801058a1:	66 a3 00 3b 11 80    	mov    %ax,0x80113b00
801058a7:	c1 e8 10             	shr    $0x10,%eax
801058aa:	c6 05 05 3b 11 80 ef 	movb   $0xef,0x80113b05
801058b1:	66 a3 06 3b 11 80    	mov    %ax,0x80113b06

  initlock(&tickslock, "time");
801058b7:	e8 64 e9 ff ff       	call   80104220 <initlock>
}
801058bc:	83 c4 10             	add    $0x10,%esp
801058bf:	c9                   	leave  
801058c0:	c3                   	ret    
801058c1:	eb 0d                	jmp    801058d0 <idtinit>
801058c3:	90                   	nop
801058c4:	90                   	nop
801058c5:	90                   	nop
801058c6:	90                   	nop
801058c7:	90                   	nop
801058c8:	90                   	nop
801058c9:	90                   	nop
801058ca:	90                   	nop
801058cb:	90                   	nop
801058cc:	90                   	nop
801058cd:	90                   	nop
801058ce:	90                   	nop
801058cf:	90                   	nop

801058d0 <idtinit>:

void
idtinit(void)
{
801058d0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801058d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801058d6:	89 e5                	mov    %esp,%ebp
801058d8:	83 ec 10             	sub    $0x10,%esp
801058db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801058df:	b8 00 39 11 80       	mov    $0x80113900,%eax
801058e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801058e8:	c1 e8 10             	shr    $0x10,%eax
801058eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801058ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801058f2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801058f5:	c9                   	leave  
801058f6:	c3                   	ret    
801058f7:	89 f6                	mov    %esi,%esi
801058f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105900 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	57                   	push   %edi
80105904:	56                   	push   %esi
80105905:	53                   	push   %ebx
80105906:	83 ec 0c             	sub    $0xc,%esp
80105909:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010590c:	8b 43 30             	mov    0x30(%ebx),%eax
8010590f:	83 f8 40             	cmp    $0x40,%eax
80105912:	0f 84 f8 00 00 00    	je     80105a10 <trap+0x110>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105918:	83 e8 20             	sub    $0x20,%eax
8010591b:	83 f8 1f             	cmp    $0x1f,%eax
8010591e:	77 68                	ja     80105988 <trap+0x88>
80105920:	ff 24 85 d0 78 10 80 	jmp    *-0x7fef8730(,%eax,4)
80105927:	89 f6                	mov    %esi,%esi
80105929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105930:	e8 9b cd ff ff       	call   801026d0 <cpunum>
80105935:	85 c0                	test   %eax,%eax
80105937:	0f 84 b3 01 00 00    	je     80105af0 <trap+0x1f0>
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
8010593d:	e8 2e ce ff ff       	call   80102770 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105942:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105948:	85 c0                	test   %eax,%eax
8010594a:	74 2d                	je     80105979 <trap+0x79>
8010594c:	8b 50 24             	mov    0x24(%eax),%edx
8010594f:	85 d2                	test   %edx,%edx
80105951:	0f 85 86 00 00 00    	jne    801059dd <trap+0xdd>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105957:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
8010595b:	0f 84 ef 00 00 00    	je     80105a50 <trap+0x150>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105961:	8b 40 24             	mov    0x24(%eax),%eax
80105964:	85 c0                	test   %eax,%eax
80105966:	74 11                	je     80105979 <trap+0x79>
80105968:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010596c:	83 e0 03             	and    $0x3,%eax
8010596f:	66 83 f8 03          	cmp    $0x3,%ax
80105973:	0f 84 c1 00 00 00    	je     80105a3a <trap+0x13a>
    exit();
}
80105979:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010597c:	5b                   	pop    %ebx
8010597d:	5e                   	pop    %esi
8010597e:	5f                   	pop    %edi
8010597f:	5d                   	pop    %ebp
80105980:	c3                   	ret    
80105981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80105988:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
8010598f:	85 c9                	test   %ecx,%ecx
80105991:	0f 84 8d 01 00 00    	je     80105b24 <trap+0x224>
80105997:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010599b:	0f 84 83 01 00 00    	je     80105b24 <trap+0x224>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801059a1:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801059a4:	8b 73 38             	mov    0x38(%ebx),%esi
801059a7:	e8 24 cd ff ff       	call   801026d0 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
801059ac:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801059b3:	57                   	push   %edi
801059b4:	56                   	push   %esi
801059b5:	50                   	push   %eax
801059b6:	ff 73 34             	pushl  0x34(%ebx)
801059b9:	ff 73 30             	pushl  0x30(%ebx)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
801059bc:	8d 42 6c             	lea    0x6c(%edx),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801059bf:	50                   	push   %eax
801059c0:	ff 72 10             	pushl  0x10(%edx)
801059c3:	68 8c 78 10 80       	push   $0x8010788c
801059c8:	e8 73 ac ff ff       	call   80100640 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
801059cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059d3:	83 c4 20             	add    $0x20,%esp
801059d6:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801059dd:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
801059e1:	83 e2 03             	and    $0x3,%edx
801059e4:	66 83 fa 03          	cmp    $0x3,%dx
801059e8:	0f 85 69 ff ff ff    	jne    80105957 <trap+0x57>
    exit();
801059ee:	e8 7d e2 ff ff       	call   80103c70 <exit>
801059f3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
801059f9:	85 c0                	test   %eax,%eax
801059fb:	0f 85 56 ff ff ff    	jne    80105957 <trap+0x57>
80105a01:	e9 73 ff ff ff       	jmp    80105979 <trap+0x79>
80105a06:	8d 76 00             	lea    0x0(%esi),%esi
80105a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80105a10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a16:	8b 70 24             	mov    0x24(%eax),%esi
80105a19:	85 f6                	test   %esi,%esi
80105a1b:	0f 85 bf 00 00 00    	jne    80105ae0 <trap+0x1e0>
      exit();
    proc->tf = tf;
80105a21:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105a24:	e8 47 ee ff ff       	call   80104870 <syscall>
    if(proc->killed)
80105a29:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a2f:	8b 58 24             	mov    0x24(%eax),%ebx
80105a32:	85 db                	test   %ebx,%ebx
80105a34:	0f 84 3f ff ff ff    	je     80105979 <trap+0x79>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105a3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a3d:	5b                   	pop    %ebx
80105a3e:	5e                   	pop    %esi
80105a3f:	5f                   	pop    %edi
80105a40:	5d                   	pop    %ebp
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
80105a41:	e9 2a e2 ff ff       	jmp    80103c70 <exit>
80105a46:	8d 76 00             	lea    0x0(%esi),%esi
80105a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105a50:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105a54:	0f 85 07 ff ff ff    	jne    80105961 <trap+0x61>
    yield();
80105a5a:	e8 61 e3 ff ff       	call   80103dc0 <yield>
80105a5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105a65:	85 c0                	test   %eax,%eax
80105a67:	0f 85 f4 fe ff ff    	jne    80105961 <trap+0x61>
80105a6d:	e9 07 ff ff ff       	jmp    80105979 <trap+0x79>
80105a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105a78:	e8 33 cb ff ff       	call   801025b0 <kbdintr>
    lapiceoi();
80105a7d:	e8 ee cc ff ff       	call   80102770 <lapiceoi>
    break;
80105a82:	e9 bb fe ff ff       	jmp    80105942 <trap+0x42>
80105a87:	89 f6                	mov    %esi,%esi
80105a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105a90:	e8 2b 02 00 00       	call   80105cc0 <uartintr>
80105a95:	e9 a3 fe ff ff       	jmp    8010593d <trap+0x3d>
80105a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105aa0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105aa4:	8b 7b 38             	mov    0x38(%ebx),%edi
80105aa7:	e8 24 cc ff ff       	call   801026d0 <cpunum>
80105aac:	57                   	push   %edi
80105aad:	56                   	push   %esi
80105aae:	50                   	push   %eax
80105aaf:	68 34 78 10 80       	push   $0x80107834
80105ab4:	e8 87 ab ff ff       	call   80100640 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
80105ab9:	e8 b2 cc ff ff       	call   80102770 <lapiceoi>
    break;
80105abe:	83 c4 10             	add    $0x10,%esp
80105ac1:	e9 7c fe ff ff       	jmp    80105942 <trap+0x42>
80105ac6:	8d 76 00             	lea    0x0(%esi),%esi
80105ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105ad0:	e8 5b c5 ff ff       	call   80102030 <ideintr>
    lapiceoi();
80105ad5:	e8 96 cc ff ff       	call   80102770 <lapiceoi>
    break;
80105ada:	e9 63 fe ff ff       	jmp    80105942 <trap+0x42>
80105adf:	90                   	nop
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
80105ae0:	e8 8b e1 ff ff       	call   80103c70 <exit>
80105ae5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105aeb:	e9 31 ff ff ff       	jmp    80105a21 <trap+0x121>
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
80105af0:	83 ec 0c             	sub    $0xc,%esp
80105af3:	68 c0 38 11 80       	push   $0x801138c0
80105af8:	e8 43 e7 ff ff       	call   80104240 <acquire>
      ticks++;
      wakeup(&ticks);
80105afd:	c7 04 24 00 41 11 80 	movl   $0x80114100,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
80105b04:	83 05 00 41 11 80 01 	addl   $0x1,0x80114100
      wakeup(&ticks);
80105b0b:	e8 90 e4 ff ff       	call   80103fa0 <wakeup>
      release(&tickslock);
80105b10:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80105b17:	e8 04 e9 ff ff       	call   80104420 <release>
80105b1c:	83 c4 10             	add    $0x10,%esp
80105b1f:	e9 19 fe ff ff       	jmp    8010593d <trap+0x3d>
80105b24:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105b27:	8b 73 38             	mov    0x38(%ebx),%esi
80105b2a:	e8 a1 cb ff ff       	call   801026d0 <cpunum>
80105b2f:	83 ec 0c             	sub    $0xc,%esp
80105b32:	57                   	push   %edi
80105b33:	56                   	push   %esi
80105b34:	50                   	push   %eax
80105b35:	ff 73 30             	pushl  0x30(%ebx)
80105b38:	68 58 78 10 80       	push   $0x80107858
80105b3d:	e8 fe aa ff ff       	call   80100640 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80105b42:	83 c4 14             	add    $0x14,%esp
80105b45:	68 2e 78 10 80       	push   $0x8010782e
80105b4a:	e8 01 a8 ff ff       	call   80100350 <panic>
80105b4f:	90                   	nop

80105b50 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105b50:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105b55:	55                   	push   %ebp
80105b56:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105b58:	85 c0                	test   %eax,%eax
80105b5a:	74 1c                	je     80105b78 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b5c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b61:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105b62:	a8 01                	test   $0x1,%al
80105b64:	74 12                	je     80105b78 <uartgetc+0x28>
80105b66:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b6b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105b6c:	0f b6 c0             	movzbl %al,%eax
}
80105b6f:	5d                   	pop    %ebp
80105b70:	c3                   	ret    
80105b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105b7d:	5d                   	pop    %ebp
80105b7e:	c3                   	ret    
80105b7f:	90                   	nop

80105b80 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	57                   	push   %edi
80105b84:	56                   	push   %esi
80105b85:	53                   	push   %ebx
80105b86:	89 c7                	mov    %eax,%edi
80105b88:	bb 80 00 00 00       	mov    $0x80,%ebx
80105b8d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105b92:	83 ec 0c             	sub    $0xc,%esp
80105b95:	eb 1b                	jmp    80105bb2 <uartputc.part.0+0x32>
80105b97:	89 f6                	mov    %esi,%esi
80105b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105ba0:	83 ec 0c             	sub    $0xc,%esp
80105ba3:	6a 0a                	push   $0xa
80105ba5:	e8 e6 cb ff ff       	call   80102790 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105baa:	83 c4 10             	add    $0x10,%esp
80105bad:	83 eb 01             	sub    $0x1,%ebx
80105bb0:	74 07                	je     80105bb9 <uartputc.part.0+0x39>
80105bb2:	89 f2                	mov    %esi,%edx
80105bb4:	ec                   	in     (%dx),%al
80105bb5:	a8 20                	test   $0x20,%al
80105bb7:	74 e7                	je     80105ba0 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105bb9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bbe:	89 f8                	mov    %edi,%eax
80105bc0:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bc4:	5b                   	pop    %ebx
80105bc5:	5e                   	pop    %esi
80105bc6:	5f                   	pop    %edi
80105bc7:	5d                   	pop    %ebp
80105bc8:	c3                   	ret    
80105bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105bd0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	31 c9                	xor    %ecx,%ecx
80105bd3:	89 c8                	mov    %ecx,%eax
80105bd5:	89 e5                	mov    %esp,%ebp
80105bd7:	57                   	push   %edi
80105bd8:	56                   	push   %esi
80105bd9:	53                   	push   %ebx
80105bda:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105bdf:	89 da                	mov    %ebx,%edx
80105be1:	83 ec 0c             	sub    $0xc,%esp
80105be4:	ee                   	out    %al,(%dx)
80105be5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105bea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105bef:	89 fa                	mov    %edi,%edx
80105bf1:	ee                   	out    %al,(%dx)
80105bf2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105bf7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bfc:	ee                   	out    %al,(%dx)
80105bfd:	be f9 03 00 00       	mov    $0x3f9,%esi
80105c02:	89 c8                	mov    %ecx,%eax
80105c04:	89 f2                	mov    %esi,%edx
80105c06:	ee                   	out    %al,(%dx)
80105c07:	b8 03 00 00 00       	mov    $0x3,%eax
80105c0c:	89 fa                	mov    %edi,%edx
80105c0e:	ee                   	out    %al,(%dx)
80105c0f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105c14:	89 c8                	mov    %ecx,%eax
80105c16:	ee                   	out    %al,(%dx)
80105c17:	b8 01 00 00 00       	mov    $0x1,%eax
80105c1c:	89 f2                	mov    %esi,%edx
80105c1e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c1f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c24:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105c25:	3c ff                	cmp    $0xff,%al
80105c27:	74 5a                	je     80105c83 <uartinit+0xb3>
    return;
  uart = 1;
80105c29:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105c30:	00 00 00 
80105c33:	89 da                	mov    %ebx,%edx
80105c35:	ec                   	in     (%dx),%al
80105c36:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c3b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105c3c:	83 ec 0c             	sub    $0xc,%esp
80105c3f:	6a 04                	push   $0x4
80105c41:	e8 4a d6 ff ff       	call   80103290 <picenable>
  ioapicenable(IRQ_COM1, 0);
80105c46:	59                   	pop    %ecx
80105c47:	5b                   	pop    %ebx
80105c48:	6a 00                	push   $0x0
80105c4a:	6a 04                	push   $0x4
80105c4c:	bb 50 79 10 80       	mov    $0x80107950,%ebx
80105c51:	e8 2a c6 ff ff       	call   80102280 <ioapicenable>
80105c56:	83 c4 10             	add    $0x10,%esp
80105c59:	b8 78 00 00 00       	mov    $0x78,%eax
80105c5e:	eb 0a                	jmp    80105c6a <uartinit+0x9a>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105c60:	83 c3 01             	add    $0x1,%ebx
80105c63:	0f be 03             	movsbl (%ebx),%eax
80105c66:	84 c0                	test   %al,%al
80105c68:	74 19                	je     80105c83 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105c6a:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80105c70:	85 d2                	test   %edx,%edx
80105c72:	74 ec                	je     80105c60 <uartinit+0x90>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105c74:	83 c3 01             	add    $0x1,%ebx
80105c77:	e8 04 ff ff ff       	call   80105b80 <uartputc.part.0>
80105c7c:	0f be 03             	movsbl (%ebx),%eax
80105c7f:	84 c0                	test   %al,%al
80105c81:	75 e7                	jne    80105c6a <uartinit+0x9a>
    uartputc(*p);
}
80105c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c86:	5b                   	pop    %ebx
80105c87:	5e                   	pop    %esi
80105c88:	5f                   	pop    %edi
80105c89:	5d                   	pop    %ebp
80105c8a:	c3                   	ret    
80105c8b:	90                   	nop
80105c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c90 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105c90:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105c96:	55                   	push   %ebp
80105c97:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105c99:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105c9e:	74 10                	je     80105cb0 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105ca0:	5d                   	pop    %ebp
80105ca1:	e9 da fe ff ff       	jmp    80105b80 <uartputc.part.0>
80105ca6:	8d 76 00             	lea    0x0(%esi),%esi
80105ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105cb0:	5d                   	pop    %ebp
80105cb1:	c3                   	ret    
80105cb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105cc0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105cc6:	68 50 5b 10 80       	push   $0x80105b50
80105ccb:	e8 00 ab ff ff       	call   801007d0 <consoleintr>
}
80105cd0:	83 c4 10             	add    $0x10,%esp
80105cd3:	c9                   	leave  
80105cd4:	c3                   	ret    

80105cd5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105cd5:	6a 00                	push   $0x0
  pushl $0
80105cd7:	6a 00                	push   $0x0
  jmp alltraps
80105cd9:	e9 20 fb ff ff       	jmp    801057fe <alltraps>

80105cde <vector1>:
.globl vector1
vector1:
  pushl $0
80105cde:	6a 00                	push   $0x0
  pushl $1
80105ce0:	6a 01                	push   $0x1
  jmp alltraps
80105ce2:	e9 17 fb ff ff       	jmp    801057fe <alltraps>

80105ce7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105ce7:	6a 00                	push   $0x0
  pushl $2
80105ce9:	6a 02                	push   $0x2
  jmp alltraps
80105ceb:	e9 0e fb ff ff       	jmp    801057fe <alltraps>

80105cf0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105cf0:	6a 00                	push   $0x0
  pushl $3
80105cf2:	6a 03                	push   $0x3
  jmp alltraps
80105cf4:	e9 05 fb ff ff       	jmp    801057fe <alltraps>

80105cf9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105cf9:	6a 00                	push   $0x0
  pushl $4
80105cfb:	6a 04                	push   $0x4
  jmp alltraps
80105cfd:	e9 fc fa ff ff       	jmp    801057fe <alltraps>

80105d02 <vector5>:
.globl vector5
vector5:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $5
80105d04:	6a 05                	push   $0x5
  jmp alltraps
80105d06:	e9 f3 fa ff ff       	jmp    801057fe <alltraps>

80105d0b <vector6>:
.globl vector6
vector6:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $6
80105d0d:	6a 06                	push   $0x6
  jmp alltraps
80105d0f:	e9 ea fa ff ff       	jmp    801057fe <alltraps>

80105d14 <vector7>:
.globl vector7
vector7:
  pushl $0
80105d14:	6a 00                	push   $0x0
  pushl $7
80105d16:	6a 07                	push   $0x7
  jmp alltraps
80105d18:	e9 e1 fa ff ff       	jmp    801057fe <alltraps>

80105d1d <vector8>:
.globl vector8
vector8:
  pushl $8
80105d1d:	6a 08                	push   $0x8
  jmp alltraps
80105d1f:	e9 da fa ff ff       	jmp    801057fe <alltraps>

80105d24 <vector9>:
.globl vector9
vector9:
  pushl $0
80105d24:	6a 00                	push   $0x0
  pushl $9
80105d26:	6a 09                	push   $0x9
  jmp alltraps
80105d28:	e9 d1 fa ff ff       	jmp    801057fe <alltraps>

80105d2d <vector10>:
.globl vector10
vector10:
  pushl $10
80105d2d:	6a 0a                	push   $0xa
  jmp alltraps
80105d2f:	e9 ca fa ff ff       	jmp    801057fe <alltraps>

80105d34 <vector11>:
.globl vector11
vector11:
  pushl $11
80105d34:	6a 0b                	push   $0xb
  jmp alltraps
80105d36:	e9 c3 fa ff ff       	jmp    801057fe <alltraps>

80105d3b <vector12>:
.globl vector12
vector12:
  pushl $12
80105d3b:	6a 0c                	push   $0xc
  jmp alltraps
80105d3d:	e9 bc fa ff ff       	jmp    801057fe <alltraps>

80105d42 <vector13>:
.globl vector13
vector13:
  pushl $13
80105d42:	6a 0d                	push   $0xd
  jmp alltraps
80105d44:	e9 b5 fa ff ff       	jmp    801057fe <alltraps>

80105d49 <vector14>:
.globl vector14
vector14:
  pushl $14
80105d49:	6a 0e                	push   $0xe
  jmp alltraps
80105d4b:	e9 ae fa ff ff       	jmp    801057fe <alltraps>

80105d50 <vector15>:
.globl vector15
vector15:
  pushl $0
80105d50:	6a 00                	push   $0x0
  pushl $15
80105d52:	6a 0f                	push   $0xf
  jmp alltraps
80105d54:	e9 a5 fa ff ff       	jmp    801057fe <alltraps>

80105d59 <vector16>:
.globl vector16
vector16:
  pushl $0
80105d59:	6a 00                	push   $0x0
  pushl $16
80105d5b:	6a 10                	push   $0x10
  jmp alltraps
80105d5d:	e9 9c fa ff ff       	jmp    801057fe <alltraps>

80105d62 <vector17>:
.globl vector17
vector17:
  pushl $17
80105d62:	6a 11                	push   $0x11
  jmp alltraps
80105d64:	e9 95 fa ff ff       	jmp    801057fe <alltraps>

80105d69 <vector18>:
.globl vector18
vector18:
  pushl $0
80105d69:	6a 00                	push   $0x0
  pushl $18
80105d6b:	6a 12                	push   $0x12
  jmp alltraps
80105d6d:	e9 8c fa ff ff       	jmp    801057fe <alltraps>

80105d72 <vector19>:
.globl vector19
vector19:
  pushl $0
80105d72:	6a 00                	push   $0x0
  pushl $19
80105d74:	6a 13                	push   $0x13
  jmp alltraps
80105d76:	e9 83 fa ff ff       	jmp    801057fe <alltraps>

80105d7b <vector20>:
.globl vector20
vector20:
  pushl $0
80105d7b:	6a 00                	push   $0x0
  pushl $20
80105d7d:	6a 14                	push   $0x14
  jmp alltraps
80105d7f:	e9 7a fa ff ff       	jmp    801057fe <alltraps>

80105d84 <vector21>:
.globl vector21
vector21:
  pushl $0
80105d84:	6a 00                	push   $0x0
  pushl $21
80105d86:	6a 15                	push   $0x15
  jmp alltraps
80105d88:	e9 71 fa ff ff       	jmp    801057fe <alltraps>

80105d8d <vector22>:
.globl vector22
vector22:
  pushl $0
80105d8d:	6a 00                	push   $0x0
  pushl $22
80105d8f:	6a 16                	push   $0x16
  jmp alltraps
80105d91:	e9 68 fa ff ff       	jmp    801057fe <alltraps>

80105d96 <vector23>:
.globl vector23
vector23:
  pushl $0
80105d96:	6a 00                	push   $0x0
  pushl $23
80105d98:	6a 17                	push   $0x17
  jmp alltraps
80105d9a:	e9 5f fa ff ff       	jmp    801057fe <alltraps>

80105d9f <vector24>:
.globl vector24
vector24:
  pushl $0
80105d9f:	6a 00                	push   $0x0
  pushl $24
80105da1:	6a 18                	push   $0x18
  jmp alltraps
80105da3:	e9 56 fa ff ff       	jmp    801057fe <alltraps>

80105da8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105da8:	6a 00                	push   $0x0
  pushl $25
80105daa:	6a 19                	push   $0x19
  jmp alltraps
80105dac:	e9 4d fa ff ff       	jmp    801057fe <alltraps>

80105db1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105db1:	6a 00                	push   $0x0
  pushl $26
80105db3:	6a 1a                	push   $0x1a
  jmp alltraps
80105db5:	e9 44 fa ff ff       	jmp    801057fe <alltraps>

80105dba <vector27>:
.globl vector27
vector27:
  pushl $0
80105dba:	6a 00                	push   $0x0
  pushl $27
80105dbc:	6a 1b                	push   $0x1b
  jmp alltraps
80105dbe:	e9 3b fa ff ff       	jmp    801057fe <alltraps>

80105dc3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105dc3:	6a 00                	push   $0x0
  pushl $28
80105dc5:	6a 1c                	push   $0x1c
  jmp alltraps
80105dc7:	e9 32 fa ff ff       	jmp    801057fe <alltraps>

80105dcc <vector29>:
.globl vector29
vector29:
  pushl $0
80105dcc:	6a 00                	push   $0x0
  pushl $29
80105dce:	6a 1d                	push   $0x1d
  jmp alltraps
80105dd0:	e9 29 fa ff ff       	jmp    801057fe <alltraps>

80105dd5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105dd5:	6a 00                	push   $0x0
  pushl $30
80105dd7:	6a 1e                	push   $0x1e
  jmp alltraps
80105dd9:	e9 20 fa ff ff       	jmp    801057fe <alltraps>

80105dde <vector31>:
.globl vector31
vector31:
  pushl $0
80105dde:	6a 00                	push   $0x0
  pushl $31
80105de0:	6a 1f                	push   $0x1f
  jmp alltraps
80105de2:	e9 17 fa ff ff       	jmp    801057fe <alltraps>

80105de7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105de7:	6a 00                	push   $0x0
  pushl $32
80105de9:	6a 20                	push   $0x20
  jmp alltraps
80105deb:	e9 0e fa ff ff       	jmp    801057fe <alltraps>

80105df0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105df0:	6a 00                	push   $0x0
  pushl $33
80105df2:	6a 21                	push   $0x21
  jmp alltraps
80105df4:	e9 05 fa ff ff       	jmp    801057fe <alltraps>

80105df9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105df9:	6a 00                	push   $0x0
  pushl $34
80105dfb:	6a 22                	push   $0x22
  jmp alltraps
80105dfd:	e9 fc f9 ff ff       	jmp    801057fe <alltraps>

80105e02 <vector35>:
.globl vector35
vector35:
  pushl $0
80105e02:	6a 00                	push   $0x0
  pushl $35
80105e04:	6a 23                	push   $0x23
  jmp alltraps
80105e06:	e9 f3 f9 ff ff       	jmp    801057fe <alltraps>

80105e0b <vector36>:
.globl vector36
vector36:
  pushl $0
80105e0b:	6a 00                	push   $0x0
  pushl $36
80105e0d:	6a 24                	push   $0x24
  jmp alltraps
80105e0f:	e9 ea f9 ff ff       	jmp    801057fe <alltraps>

80105e14 <vector37>:
.globl vector37
vector37:
  pushl $0
80105e14:	6a 00                	push   $0x0
  pushl $37
80105e16:	6a 25                	push   $0x25
  jmp alltraps
80105e18:	e9 e1 f9 ff ff       	jmp    801057fe <alltraps>

80105e1d <vector38>:
.globl vector38
vector38:
  pushl $0
80105e1d:	6a 00                	push   $0x0
  pushl $38
80105e1f:	6a 26                	push   $0x26
  jmp alltraps
80105e21:	e9 d8 f9 ff ff       	jmp    801057fe <alltraps>

80105e26 <vector39>:
.globl vector39
vector39:
  pushl $0
80105e26:	6a 00                	push   $0x0
  pushl $39
80105e28:	6a 27                	push   $0x27
  jmp alltraps
80105e2a:	e9 cf f9 ff ff       	jmp    801057fe <alltraps>

80105e2f <vector40>:
.globl vector40
vector40:
  pushl $0
80105e2f:	6a 00                	push   $0x0
  pushl $40
80105e31:	6a 28                	push   $0x28
  jmp alltraps
80105e33:	e9 c6 f9 ff ff       	jmp    801057fe <alltraps>

80105e38 <vector41>:
.globl vector41
vector41:
  pushl $0
80105e38:	6a 00                	push   $0x0
  pushl $41
80105e3a:	6a 29                	push   $0x29
  jmp alltraps
80105e3c:	e9 bd f9 ff ff       	jmp    801057fe <alltraps>

80105e41 <vector42>:
.globl vector42
vector42:
  pushl $0
80105e41:	6a 00                	push   $0x0
  pushl $42
80105e43:	6a 2a                	push   $0x2a
  jmp alltraps
80105e45:	e9 b4 f9 ff ff       	jmp    801057fe <alltraps>

80105e4a <vector43>:
.globl vector43
vector43:
  pushl $0
80105e4a:	6a 00                	push   $0x0
  pushl $43
80105e4c:	6a 2b                	push   $0x2b
  jmp alltraps
80105e4e:	e9 ab f9 ff ff       	jmp    801057fe <alltraps>

80105e53 <vector44>:
.globl vector44
vector44:
  pushl $0
80105e53:	6a 00                	push   $0x0
  pushl $44
80105e55:	6a 2c                	push   $0x2c
  jmp alltraps
80105e57:	e9 a2 f9 ff ff       	jmp    801057fe <alltraps>

80105e5c <vector45>:
.globl vector45
vector45:
  pushl $0
80105e5c:	6a 00                	push   $0x0
  pushl $45
80105e5e:	6a 2d                	push   $0x2d
  jmp alltraps
80105e60:	e9 99 f9 ff ff       	jmp    801057fe <alltraps>

80105e65 <vector46>:
.globl vector46
vector46:
  pushl $0
80105e65:	6a 00                	push   $0x0
  pushl $46
80105e67:	6a 2e                	push   $0x2e
  jmp alltraps
80105e69:	e9 90 f9 ff ff       	jmp    801057fe <alltraps>

80105e6e <vector47>:
.globl vector47
vector47:
  pushl $0
80105e6e:	6a 00                	push   $0x0
  pushl $47
80105e70:	6a 2f                	push   $0x2f
  jmp alltraps
80105e72:	e9 87 f9 ff ff       	jmp    801057fe <alltraps>

80105e77 <vector48>:
.globl vector48
vector48:
  pushl $0
80105e77:	6a 00                	push   $0x0
  pushl $48
80105e79:	6a 30                	push   $0x30
  jmp alltraps
80105e7b:	e9 7e f9 ff ff       	jmp    801057fe <alltraps>

80105e80 <vector49>:
.globl vector49
vector49:
  pushl $0
80105e80:	6a 00                	push   $0x0
  pushl $49
80105e82:	6a 31                	push   $0x31
  jmp alltraps
80105e84:	e9 75 f9 ff ff       	jmp    801057fe <alltraps>

80105e89 <vector50>:
.globl vector50
vector50:
  pushl $0
80105e89:	6a 00                	push   $0x0
  pushl $50
80105e8b:	6a 32                	push   $0x32
  jmp alltraps
80105e8d:	e9 6c f9 ff ff       	jmp    801057fe <alltraps>

80105e92 <vector51>:
.globl vector51
vector51:
  pushl $0
80105e92:	6a 00                	push   $0x0
  pushl $51
80105e94:	6a 33                	push   $0x33
  jmp alltraps
80105e96:	e9 63 f9 ff ff       	jmp    801057fe <alltraps>

80105e9b <vector52>:
.globl vector52
vector52:
  pushl $0
80105e9b:	6a 00                	push   $0x0
  pushl $52
80105e9d:	6a 34                	push   $0x34
  jmp alltraps
80105e9f:	e9 5a f9 ff ff       	jmp    801057fe <alltraps>

80105ea4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105ea4:	6a 00                	push   $0x0
  pushl $53
80105ea6:	6a 35                	push   $0x35
  jmp alltraps
80105ea8:	e9 51 f9 ff ff       	jmp    801057fe <alltraps>

80105ead <vector54>:
.globl vector54
vector54:
  pushl $0
80105ead:	6a 00                	push   $0x0
  pushl $54
80105eaf:	6a 36                	push   $0x36
  jmp alltraps
80105eb1:	e9 48 f9 ff ff       	jmp    801057fe <alltraps>

80105eb6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105eb6:	6a 00                	push   $0x0
  pushl $55
80105eb8:	6a 37                	push   $0x37
  jmp alltraps
80105eba:	e9 3f f9 ff ff       	jmp    801057fe <alltraps>

80105ebf <vector56>:
.globl vector56
vector56:
  pushl $0
80105ebf:	6a 00                	push   $0x0
  pushl $56
80105ec1:	6a 38                	push   $0x38
  jmp alltraps
80105ec3:	e9 36 f9 ff ff       	jmp    801057fe <alltraps>

80105ec8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105ec8:	6a 00                	push   $0x0
  pushl $57
80105eca:	6a 39                	push   $0x39
  jmp alltraps
80105ecc:	e9 2d f9 ff ff       	jmp    801057fe <alltraps>

80105ed1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105ed1:	6a 00                	push   $0x0
  pushl $58
80105ed3:	6a 3a                	push   $0x3a
  jmp alltraps
80105ed5:	e9 24 f9 ff ff       	jmp    801057fe <alltraps>

80105eda <vector59>:
.globl vector59
vector59:
  pushl $0
80105eda:	6a 00                	push   $0x0
  pushl $59
80105edc:	6a 3b                	push   $0x3b
  jmp alltraps
80105ede:	e9 1b f9 ff ff       	jmp    801057fe <alltraps>

80105ee3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ee3:	6a 00                	push   $0x0
  pushl $60
80105ee5:	6a 3c                	push   $0x3c
  jmp alltraps
80105ee7:	e9 12 f9 ff ff       	jmp    801057fe <alltraps>

80105eec <vector61>:
.globl vector61
vector61:
  pushl $0
80105eec:	6a 00                	push   $0x0
  pushl $61
80105eee:	6a 3d                	push   $0x3d
  jmp alltraps
80105ef0:	e9 09 f9 ff ff       	jmp    801057fe <alltraps>

80105ef5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ef5:	6a 00                	push   $0x0
  pushl $62
80105ef7:	6a 3e                	push   $0x3e
  jmp alltraps
80105ef9:	e9 00 f9 ff ff       	jmp    801057fe <alltraps>

80105efe <vector63>:
.globl vector63
vector63:
  pushl $0
80105efe:	6a 00                	push   $0x0
  pushl $63
80105f00:	6a 3f                	push   $0x3f
  jmp alltraps
80105f02:	e9 f7 f8 ff ff       	jmp    801057fe <alltraps>

80105f07 <vector64>:
.globl vector64
vector64:
  pushl $0
80105f07:	6a 00                	push   $0x0
  pushl $64
80105f09:	6a 40                	push   $0x40
  jmp alltraps
80105f0b:	e9 ee f8 ff ff       	jmp    801057fe <alltraps>

80105f10 <vector65>:
.globl vector65
vector65:
  pushl $0
80105f10:	6a 00                	push   $0x0
  pushl $65
80105f12:	6a 41                	push   $0x41
  jmp alltraps
80105f14:	e9 e5 f8 ff ff       	jmp    801057fe <alltraps>

80105f19 <vector66>:
.globl vector66
vector66:
  pushl $0
80105f19:	6a 00                	push   $0x0
  pushl $66
80105f1b:	6a 42                	push   $0x42
  jmp alltraps
80105f1d:	e9 dc f8 ff ff       	jmp    801057fe <alltraps>

80105f22 <vector67>:
.globl vector67
vector67:
  pushl $0
80105f22:	6a 00                	push   $0x0
  pushl $67
80105f24:	6a 43                	push   $0x43
  jmp alltraps
80105f26:	e9 d3 f8 ff ff       	jmp    801057fe <alltraps>

80105f2b <vector68>:
.globl vector68
vector68:
  pushl $0
80105f2b:	6a 00                	push   $0x0
  pushl $68
80105f2d:	6a 44                	push   $0x44
  jmp alltraps
80105f2f:	e9 ca f8 ff ff       	jmp    801057fe <alltraps>

80105f34 <vector69>:
.globl vector69
vector69:
  pushl $0
80105f34:	6a 00                	push   $0x0
  pushl $69
80105f36:	6a 45                	push   $0x45
  jmp alltraps
80105f38:	e9 c1 f8 ff ff       	jmp    801057fe <alltraps>

80105f3d <vector70>:
.globl vector70
vector70:
  pushl $0
80105f3d:	6a 00                	push   $0x0
  pushl $70
80105f3f:	6a 46                	push   $0x46
  jmp alltraps
80105f41:	e9 b8 f8 ff ff       	jmp    801057fe <alltraps>

80105f46 <vector71>:
.globl vector71
vector71:
  pushl $0
80105f46:	6a 00                	push   $0x0
  pushl $71
80105f48:	6a 47                	push   $0x47
  jmp alltraps
80105f4a:	e9 af f8 ff ff       	jmp    801057fe <alltraps>

80105f4f <vector72>:
.globl vector72
vector72:
  pushl $0
80105f4f:	6a 00                	push   $0x0
  pushl $72
80105f51:	6a 48                	push   $0x48
  jmp alltraps
80105f53:	e9 a6 f8 ff ff       	jmp    801057fe <alltraps>

80105f58 <vector73>:
.globl vector73
vector73:
  pushl $0
80105f58:	6a 00                	push   $0x0
  pushl $73
80105f5a:	6a 49                	push   $0x49
  jmp alltraps
80105f5c:	e9 9d f8 ff ff       	jmp    801057fe <alltraps>

80105f61 <vector74>:
.globl vector74
vector74:
  pushl $0
80105f61:	6a 00                	push   $0x0
  pushl $74
80105f63:	6a 4a                	push   $0x4a
  jmp alltraps
80105f65:	e9 94 f8 ff ff       	jmp    801057fe <alltraps>

80105f6a <vector75>:
.globl vector75
vector75:
  pushl $0
80105f6a:	6a 00                	push   $0x0
  pushl $75
80105f6c:	6a 4b                	push   $0x4b
  jmp alltraps
80105f6e:	e9 8b f8 ff ff       	jmp    801057fe <alltraps>

80105f73 <vector76>:
.globl vector76
vector76:
  pushl $0
80105f73:	6a 00                	push   $0x0
  pushl $76
80105f75:	6a 4c                	push   $0x4c
  jmp alltraps
80105f77:	e9 82 f8 ff ff       	jmp    801057fe <alltraps>

80105f7c <vector77>:
.globl vector77
vector77:
  pushl $0
80105f7c:	6a 00                	push   $0x0
  pushl $77
80105f7e:	6a 4d                	push   $0x4d
  jmp alltraps
80105f80:	e9 79 f8 ff ff       	jmp    801057fe <alltraps>

80105f85 <vector78>:
.globl vector78
vector78:
  pushl $0
80105f85:	6a 00                	push   $0x0
  pushl $78
80105f87:	6a 4e                	push   $0x4e
  jmp alltraps
80105f89:	e9 70 f8 ff ff       	jmp    801057fe <alltraps>

80105f8e <vector79>:
.globl vector79
vector79:
  pushl $0
80105f8e:	6a 00                	push   $0x0
  pushl $79
80105f90:	6a 4f                	push   $0x4f
  jmp alltraps
80105f92:	e9 67 f8 ff ff       	jmp    801057fe <alltraps>

80105f97 <vector80>:
.globl vector80
vector80:
  pushl $0
80105f97:	6a 00                	push   $0x0
  pushl $80
80105f99:	6a 50                	push   $0x50
  jmp alltraps
80105f9b:	e9 5e f8 ff ff       	jmp    801057fe <alltraps>

80105fa0 <vector81>:
.globl vector81
vector81:
  pushl $0
80105fa0:	6a 00                	push   $0x0
  pushl $81
80105fa2:	6a 51                	push   $0x51
  jmp alltraps
80105fa4:	e9 55 f8 ff ff       	jmp    801057fe <alltraps>

80105fa9 <vector82>:
.globl vector82
vector82:
  pushl $0
80105fa9:	6a 00                	push   $0x0
  pushl $82
80105fab:	6a 52                	push   $0x52
  jmp alltraps
80105fad:	e9 4c f8 ff ff       	jmp    801057fe <alltraps>

80105fb2 <vector83>:
.globl vector83
vector83:
  pushl $0
80105fb2:	6a 00                	push   $0x0
  pushl $83
80105fb4:	6a 53                	push   $0x53
  jmp alltraps
80105fb6:	e9 43 f8 ff ff       	jmp    801057fe <alltraps>

80105fbb <vector84>:
.globl vector84
vector84:
  pushl $0
80105fbb:	6a 00                	push   $0x0
  pushl $84
80105fbd:	6a 54                	push   $0x54
  jmp alltraps
80105fbf:	e9 3a f8 ff ff       	jmp    801057fe <alltraps>

80105fc4 <vector85>:
.globl vector85
vector85:
  pushl $0
80105fc4:	6a 00                	push   $0x0
  pushl $85
80105fc6:	6a 55                	push   $0x55
  jmp alltraps
80105fc8:	e9 31 f8 ff ff       	jmp    801057fe <alltraps>

80105fcd <vector86>:
.globl vector86
vector86:
  pushl $0
80105fcd:	6a 00                	push   $0x0
  pushl $86
80105fcf:	6a 56                	push   $0x56
  jmp alltraps
80105fd1:	e9 28 f8 ff ff       	jmp    801057fe <alltraps>

80105fd6 <vector87>:
.globl vector87
vector87:
  pushl $0
80105fd6:	6a 00                	push   $0x0
  pushl $87
80105fd8:	6a 57                	push   $0x57
  jmp alltraps
80105fda:	e9 1f f8 ff ff       	jmp    801057fe <alltraps>

80105fdf <vector88>:
.globl vector88
vector88:
  pushl $0
80105fdf:	6a 00                	push   $0x0
  pushl $88
80105fe1:	6a 58                	push   $0x58
  jmp alltraps
80105fe3:	e9 16 f8 ff ff       	jmp    801057fe <alltraps>

80105fe8 <vector89>:
.globl vector89
vector89:
  pushl $0
80105fe8:	6a 00                	push   $0x0
  pushl $89
80105fea:	6a 59                	push   $0x59
  jmp alltraps
80105fec:	e9 0d f8 ff ff       	jmp    801057fe <alltraps>

80105ff1 <vector90>:
.globl vector90
vector90:
  pushl $0
80105ff1:	6a 00                	push   $0x0
  pushl $90
80105ff3:	6a 5a                	push   $0x5a
  jmp alltraps
80105ff5:	e9 04 f8 ff ff       	jmp    801057fe <alltraps>

80105ffa <vector91>:
.globl vector91
vector91:
  pushl $0
80105ffa:	6a 00                	push   $0x0
  pushl $91
80105ffc:	6a 5b                	push   $0x5b
  jmp alltraps
80105ffe:	e9 fb f7 ff ff       	jmp    801057fe <alltraps>

80106003 <vector92>:
.globl vector92
vector92:
  pushl $0
80106003:	6a 00                	push   $0x0
  pushl $92
80106005:	6a 5c                	push   $0x5c
  jmp alltraps
80106007:	e9 f2 f7 ff ff       	jmp    801057fe <alltraps>

8010600c <vector93>:
.globl vector93
vector93:
  pushl $0
8010600c:	6a 00                	push   $0x0
  pushl $93
8010600e:	6a 5d                	push   $0x5d
  jmp alltraps
80106010:	e9 e9 f7 ff ff       	jmp    801057fe <alltraps>

80106015 <vector94>:
.globl vector94
vector94:
  pushl $0
80106015:	6a 00                	push   $0x0
  pushl $94
80106017:	6a 5e                	push   $0x5e
  jmp alltraps
80106019:	e9 e0 f7 ff ff       	jmp    801057fe <alltraps>

8010601e <vector95>:
.globl vector95
vector95:
  pushl $0
8010601e:	6a 00                	push   $0x0
  pushl $95
80106020:	6a 5f                	push   $0x5f
  jmp alltraps
80106022:	e9 d7 f7 ff ff       	jmp    801057fe <alltraps>

80106027 <vector96>:
.globl vector96
vector96:
  pushl $0
80106027:	6a 00                	push   $0x0
  pushl $96
80106029:	6a 60                	push   $0x60
  jmp alltraps
8010602b:	e9 ce f7 ff ff       	jmp    801057fe <alltraps>

80106030 <vector97>:
.globl vector97
vector97:
  pushl $0
80106030:	6a 00                	push   $0x0
  pushl $97
80106032:	6a 61                	push   $0x61
  jmp alltraps
80106034:	e9 c5 f7 ff ff       	jmp    801057fe <alltraps>

80106039 <vector98>:
.globl vector98
vector98:
  pushl $0
80106039:	6a 00                	push   $0x0
  pushl $98
8010603b:	6a 62                	push   $0x62
  jmp alltraps
8010603d:	e9 bc f7 ff ff       	jmp    801057fe <alltraps>

80106042 <vector99>:
.globl vector99
vector99:
  pushl $0
80106042:	6a 00                	push   $0x0
  pushl $99
80106044:	6a 63                	push   $0x63
  jmp alltraps
80106046:	e9 b3 f7 ff ff       	jmp    801057fe <alltraps>

8010604b <vector100>:
.globl vector100
vector100:
  pushl $0
8010604b:	6a 00                	push   $0x0
  pushl $100
8010604d:	6a 64                	push   $0x64
  jmp alltraps
8010604f:	e9 aa f7 ff ff       	jmp    801057fe <alltraps>

80106054 <vector101>:
.globl vector101
vector101:
  pushl $0
80106054:	6a 00                	push   $0x0
  pushl $101
80106056:	6a 65                	push   $0x65
  jmp alltraps
80106058:	e9 a1 f7 ff ff       	jmp    801057fe <alltraps>

8010605d <vector102>:
.globl vector102
vector102:
  pushl $0
8010605d:	6a 00                	push   $0x0
  pushl $102
8010605f:	6a 66                	push   $0x66
  jmp alltraps
80106061:	e9 98 f7 ff ff       	jmp    801057fe <alltraps>

80106066 <vector103>:
.globl vector103
vector103:
  pushl $0
80106066:	6a 00                	push   $0x0
  pushl $103
80106068:	6a 67                	push   $0x67
  jmp alltraps
8010606a:	e9 8f f7 ff ff       	jmp    801057fe <alltraps>

8010606f <vector104>:
.globl vector104
vector104:
  pushl $0
8010606f:	6a 00                	push   $0x0
  pushl $104
80106071:	6a 68                	push   $0x68
  jmp alltraps
80106073:	e9 86 f7 ff ff       	jmp    801057fe <alltraps>

80106078 <vector105>:
.globl vector105
vector105:
  pushl $0
80106078:	6a 00                	push   $0x0
  pushl $105
8010607a:	6a 69                	push   $0x69
  jmp alltraps
8010607c:	e9 7d f7 ff ff       	jmp    801057fe <alltraps>

80106081 <vector106>:
.globl vector106
vector106:
  pushl $0
80106081:	6a 00                	push   $0x0
  pushl $106
80106083:	6a 6a                	push   $0x6a
  jmp alltraps
80106085:	e9 74 f7 ff ff       	jmp    801057fe <alltraps>

8010608a <vector107>:
.globl vector107
vector107:
  pushl $0
8010608a:	6a 00                	push   $0x0
  pushl $107
8010608c:	6a 6b                	push   $0x6b
  jmp alltraps
8010608e:	e9 6b f7 ff ff       	jmp    801057fe <alltraps>

80106093 <vector108>:
.globl vector108
vector108:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $108
80106095:	6a 6c                	push   $0x6c
  jmp alltraps
80106097:	e9 62 f7 ff ff       	jmp    801057fe <alltraps>

8010609c <vector109>:
.globl vector109
vector109:
  pushl $0
8010609c:	6a 00                	push   $0x0
  pushl $109
8010609e:	6a 6d                	push   $0x6d
  jmp alltraps
801060a0:	e9 59 f7 ff ff       	jmp    801057fe <alltraps>

801060a5 <vector110>:
.globl vector110
vector110:
  pushl $0
801060a5:	6a 00                	push   $0x0
  pushl $110
801060a7:	6a 6e                	push   $0x6e
  jmp alltraps
801060a9:	e9 50 f7 ff ff       	jmp    801057fe <alltraps>

801060ae <vector111>:
.globl vector111
vector111:
  pushl $0
801060ae:	6a 00                	push   $0x0
  pushl $111
801060b0:	6a 6f                	push   $0x6f
  jmp alltraps
801060b2:	e9 47 f7 ff ff       	jmp    801057fe <alltraps>

801060b7 <vector112>:
.globl vector112
vector112:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $112
801060b9:	6a 70                	push   $0x70
  jmp alltraps
801060bb:	e9 3e f7 ff ff       	jmp    801057fe <alltraps>

801060c0 <vector113>:
.globl vector113
vector113:
  pushl $0
801060c0:	6a 00                	push   $0x0
  pushl $113
801060c2:	6a 71                	push   $0x71
  jmp alltraps
801060c4:	e9 35 f7 ff ff       	jmp    801057fe <alltraps>

801060c9 <vector114>:
.globl vector114
vector114:
  pushl $0
801060c9:	6a 00                	push   $0x0
  pushl $114
801060cb:	6a 72                	push   $0x72
  jmp alltraps
801060cd:	e9 2c f7 ff ff       	jmp    801057fe <alltraps>

801060d2 <vector115>:
.globl vector115
vector115:
  pushl $0
801060d2:	6a 00                	push   $0x0
  pushl $115
801060d4:	6a 73                	push   $0x73
  jmp alltraps
801060d6:	e9 23 f7 ff ff       	jmp    801057fe <alltraps>

801060db <vector116>:
.globl vector116
vector116:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $116
801060dd:	6a 74                	push   $0x74
  jmp alltraps
801060df:	e9 1a f7 ff ff       	jmp    801057fe <alltraps>

801060e4 <vector117>:
.globl vector117
vector117:
  pushl $0
801060e4:	6a 00                	push   $0x0
  pushl $117
801060e6:	6a 75                	push   $0x75
  jmp alltraps
801060e8:	e9 11 f7 ff ff       	jmp    801057fe <alltraps>

801060ed <vector118>:
.globl vector118
vector118:
  pushl $0
801060ed:	6a 00                	push   $0x0
  pushl $118
801060ef:	6a 76                	push   $0x76
  jmp alltraps
801060f1:	e9 08 f7 ff ff       	jmp    801057fe <alltraps>

801060f6 <vector119>:
.globl vector119
vector119:
  pushl $0
801060f6:	6a 00                	push   $0x0
  pushl $119
801060f8:	6a 77                	push   $0x77
  jmp alltraps
801060fa:	e9 ff f6 ff ff       	jmp    801057fe <alltraps>

801060ff <vector120>:
.globl vector120
vector120:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $120
80106101:	6a 78                	push   $0x78
  jmp alltraps
80106103:	e9 f6 f6 ff ff       	jmp    801057fe <alltraps>

80106108 <vector121>:
.globl vector121
vector121:
  pushl $0
80106108:	6a 00                	push   $0x0
  pushl $121
8010610a:	6a 79                	push   $0x79
  jmp alltraps
8010610c:	e9 ed f6 ff ff       	jmp    801057fe <alltraps>

80106111 <vector122>:
.globl vector122
vector122:
  pushl $0
80106111:	6a 00                	push   $0x0
  pushl $122
80106113:	6a 7a                	push   $0x7a
  jmp alltraps
80106115:	e9 e4 f6 ff ff       	jmp    801057fe <alltraps>

8010611a <vector123>:
.globl vector123
vector123:
  pushl $0
8010611a:	6a 00                	push   $0x0
  pushl $123
8010611c:	6a 7b                	push   $0x7b
  jmp alltraps
8010611e:	e9 db f6 ff ff       	jmp    801057fe <alltraps>

80106123 <vector124>:
.globl vector124
vector124:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $124
80106125:	6a 7c                	push   $0x7c
  jmp alltraps
80106127:	e9 d2 f6 ff ff       	jmp    801057fe <alltraps>

8010612c <vector125>:
.globl vector125
vector125:
  pushl $0
8010612c:	6a 00                	push   $0x0
  pushl $125
8010612e:	6a 7d                	push   $0x7d
  jmp alltraps
80106130:	e9 c9 f6 ff ff       	jmp    801057fe <alltraps>

80106135 <vector126>:
.globl vector126
vector126:
  pushl $0
80106135:	6a 00                	push   $0x0
  pushl $126
80106137:	6a 7e                	push   $0x7e
  jmp alltraps
80106139:	e9 c0 f6 ff ff       	jmp    801057fe <alltraps>

8010613e <vector127>:
.globl vector127
vector127:
  pushl $0
8010613e:	6a 00                	push   $0x0
  pushl $127
80106140:	6a 7f                	push   $0x7f
  jmp alltraps
80106142:	e9 b7 f6 ff ff       	jmp    801057fe <alltraps>

80106147 <vector128>:
.globl vector128
vector128:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $128
80106149:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010614e:	e9 ab f6 ff ff       	jmp    801057fe <alltraps>

80106153 <vector129>:
.globl vector129
vector129:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $129
80106155:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010615a:	e9 9f f6 ff ff       	jmp    801057fe <alltraps>

8010615f <vector130>:
.globl vector130
vector130:
  pushl $0
8010615f:	6a 00                	push   $0x0
  pushl $130
80106161:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106166:	e9 93 f6 ff ff       	jmp    801057fe <alltraps>

8010616b <vector131>:
.globl vector131
vector131:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $131
8010616d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106172:	e9 87 f6 ff ff       	jmp    801057fe <alltraps>

80106177 <vector132>:
.globl vector132
vector132:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $132
80106179:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010617e:	e9 7b f6 ff ff       	jmp    801057fe <alltraps>

80106183 <vector133>:
.globl vector133
vector133:
  pushl $0
80106183:	6a 00                	push   $0x0
  pushl $133
80106185:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010618a:	e9 6f f6 ff ff       	jmp    801057fe <alltraps>

8010618f <vector134>:
.globl vector134
vector134:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $134
80106191:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106196:	e9 63 f6 ff ff       	jmp    801057fe <alltraps>

8010619b <vector135>:
.globl vector135
vector135:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $135
8010619d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801061a2:	e9 57 f6 ff ff       	jmp    801057fe <alltraps>

801061a7 <vector136>:
.globl vector136
vector136:
  pushl $0
801061a7:	6a 00                	push   $0x0
  pushl $136
801061a9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801061ae:	e9 4b f6 ff ff       	jmp    801057fe <alltraps>

801061b3 <vector137>:
.globl vector137
vector137:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $137
801061b5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801061ba:	e9 3f f6 ff ff       	jmp    801057fe <alltraps>

801061bf <vector138>:
.globl vector138
vector138:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $138
801061c1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801061c6:	e9 33 f6 ff ff       	jmp    801057fe <alltraps>

801061cb <vector139>:
.globl vector139
vector139:
  pushl $0
801061cb:	6a 00                	push   $0x0
  pushl $139
801061cd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801061d2:	e9 27 f6 ff ff       	jmp    801057fe <alltraps>

801061d7 <vector140>:
.globl vector140
vector140:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $140
801061d9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801061de:	e9 1b f6 ff ff       	jmp    801057fe <alltraps>

801061e3 <vector141>:
.globl vector141
vector141:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $141
801061e5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801061ea:	e9 0f f6 ff ff       	jmp    801057fe <alltraps>

801061ef <vector142>:
.globl vector142
vector142:
  pushl $0
801061ef:	6a 00                	push   $0x0
  pushl $142
801061f1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801061f6:	e9 03 f6 ff ff       	jmp    801057fe <alltraps>

801061fb <vector143>:
.globl vector143
vector143:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $143
801061fd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106202:	e9 f7 f5 ff ff       	jmp    801057fe <alltraps>

80106207 <vector144>:
.globl vector144
vector144:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $144
80106209:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010620e:	e9 eb f5 ff ff       	jmp    801057fe <alltraps>

80106213 <vector145>:
.globl vector145
vector145:
  pushl $0
80106213:	6a 00                	push   $0x0
  pushl $145
80106215:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010621a:	e9 df f5 ff ff       	jmp    801057fe <alltraps>

8010621f <vector146>:
.globl vector146
vector146:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $146
80106221:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106226:	e9 d3 f5 ff ff       	jmp    801057fe <alltraps>

8010622b <vector147>:
.globl vector147
vector147:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $147
8010622d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106232:	e9 c7 f5 ff ff       	jmp    801057fe <alltraps>

80106237 <vector148>:
.globl vector148
vector148:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $148
80106239:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010623e:	e9 bb f5 ff ff       	jmp    801057fe <alltraps>

80106243 <vector149>:
.globl vector149
vector149:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $149
80106245:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010624a:	e9 af f5 ff ff       	jmp    801057fe <alltraps>

8010624f <vector150>:
.globl vector150
vector150:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $150
80106251:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106256:	e9 a3 f5 ff ff       	jmp    801057fe <alltraps>

8010625b <vector151>:
.globl vector151
vector151:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $151
8010625d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106262:	e9 97 f5 ff ff       	jmp    801057fe <alltraps>

80106267 <vector152>:
.globl vector152
vector152:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $152
80106269:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010626e:	e9 8b f5 ff ff       	jmp    801057fe <alltraps>

80106273 <vector153>:
.globl vector153
vector153:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $153
80106275:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010627a:	e9 7f f5 ff ff       	jmp    801057fe <alltraps>

8010627f <vector154>:
.globl vector154
vector154:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $154
80106281:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106286:	e9 73 f5 ff ff       	jmp    801057fe <alltraps>

8010628b <vector155>:
.globl vector155
vector155:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $155
8010628d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106292:	e9 67 f5 ff ff       	jmp    801057fe <alltraps>

80106297 <vector156>:
.globl vector156
vector156:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $156
80106299:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010629e:	e9 5b f5 ff ff       	jmp    801057fe <alltraps>

801062a3 <vector157>:
.globl vector157
vector157:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $157
801062a5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801062aa:	e9 4f f5 ff ff       	jmp    801057fe <alltraps>

801062af <vector158>:
.globl vector158
vector158:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $158
801062b1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801062b6:	e9 43 f5 ff ff       	jmp    801057fe <alltraps>

801062bb <vector159>:
.globl vector159
vector159:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $159
801062bd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801062c2:	e9 37 f5 ff ff       	jmp    801057fe <alltraps>

801062c7 <vector160>:
.globl vector160
vector160:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $160
801062c9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801062ce:	e9 2b f5 ff ff       	jmp    801057fe <alltraps>

801062d3 <vector161>:
.globl vector161
vector161:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $161
801062d5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801062da:	e9 1f f5 ff ff       	jmp    801057fe <alltraps>

801062df <vector162>:
.globl vector162
vector162:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $162
801062e1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801062e6:	e9 13 f5 ff ff       	jmp    801057fe <alltraps>

801062eb <vector163>:
.globl vector163
vector163:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $163
801062ed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801062f2:	e9 07 f5 ff ff       	jmp    801057fe <alltraps>

801062f7 <vector164>:
.globl vector164
vector164:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $164
801062f9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801062fe:	e9 fb f4 ff ff       	jmp    801057fe <alltraps>

80106303 <vector165>:
.globl vector165
vector165:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $165
80106305:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010630a:	e9 ef f4 ff ff       	jmp    801057fe <alltraps>

8010630f <vector166>:
.globl vector166
vector166:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $166
80106311:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106316:	e9 e3 f4 ff ff       	jmp    801057fe <alltraps>

8010631b <vector167>:
.globl vector167
vector167:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $167
8010631d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106322:	e9 d7 f4 ff ff       	jmp    801057fe <alltraps>

80106327 <vector168>:
.globl vector168
vector168:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $168
80106329:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010632e:	e9 cb f4 ff ff       	jmp    801057fe <alltraps>

80106333 <vector169>:
.globl vector169
vector169:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $169
80106335:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010633a:	e9 bf f4 ff ff       	jmp    801057fe <alltraps>

8010633f <vector170>:
.globl vector170
vector170:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $170
80106341:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106346:	e9 b3 f4 ff ff       	jmp    801057fe <alltraps>

8010634b <vector171>:
.globl vector171
vector171:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $171
8010634d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106352:	e9 a7 f4 ff ff       	jmp    801057fe <alltraps>

80106357 <vector172>:
.globl vector172
vector172:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $172
80106359:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010635e:	e9 9b f4 ff ff       	jmp    801057fe <alltraps>

80106363 <vector173>:
.globl vector173
vector173:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $173
80106365:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010636a:	e9 8f f4 ff ff       	jmp    801057fe <alltraps>

8010636f <vector174>:
.globl vector174
vector174:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $174
80106371:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106376:	e9 83 f4 ff ff       	jmp    801057fe <alltraps>

8010637b <vector175>:
.globl vector175
vector175:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $175
8010637d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106382:	e9 77 f4 ff ff       	jmp    801057fe <alltraps>

80106387 <vector176>:
.globl vector176
vector176:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $176
80106389:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010638e:	e9 6b f4 ff ff       	jmp    801057fe <alltraps>

80106393 <vector177>:
.globl vector177
vector177:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $177
80106395:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010639a:	e9 5f f4 ff ff       	jmp    801057fe <alltraps>

8010639f <vector178>:
.globl vector178
vector178:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $178
801063a1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801063a6:	e9 53 f4 ff ff       	jmp    801057fe <alltraps>

801063ab <vector179>:
.globl vector179
vector179:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $179
801063ad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801063b2:	e9 47 f4 ff ff       	jmp    801057fe <alltraps>

801063b7 <vector180>:
.globl vector180
vector180:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $180
801063b9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801063be:	e9 3b f4 ff ff       	jmp    801057fe <alltraps>

801063c3 <vector181>:
.globl vector181
vector181:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $181
801063c5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801063ca:	e9 2f f4 ff ff       	jmp    801057fe <alltraps>

801063cf <vector182>:
.globl vector182
vector182:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $182
801063d1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801063d6:	e9 23 f4 ff ff       	jmp    801057fe <alltraps>

801063db <vector183>:
.globl vector183
vector183:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $183
801063dd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801063e2:	e9 17 f4 ff ff       	jmp    801057fe <alltraps>

801063e7 <vector184>:
.globl vector184
vector184:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $184
801063e9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801063ee:	e9 0b f4 ff ff       	jmp    801057fe <alltraps>

801063f3 <vector185>:
.globl vector185
vector185:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $185
801063f5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801063fa:	e9 ff f3 ff ff       	jmp    801057fe <alltraps>

801063ff <vector186>:
.globl vector186
vector186:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $186
80106401:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106406:	e9 f3 f3 ff ff       	jmp    801057fe <alltraps>

8010640b <vector187>:
.globl vector187
vector187:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $187
8010640d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106412:	e9 e7 f3 ff ff       	jmp    801057fe <alltraps>

80106417 <vector188>:
.globl vector188
vector188:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $188
80106419:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010641e:	e9 db f3 ff ff       	jmp    801057fe <alltraps>

80106423 <vector189>:
.globl vector189
vector189:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $189
80106425:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010642a:	e9 cf f3 ff ff       	jmp    801057fe <alltraps>

8010642f <vector190>:
.globl vector190
vector190:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $190
80106431:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106436:	e9 c3 f3 ff ff       	jmp    801057fe <alltraps>

8010643b <vector191>:
.globl vector191
vector191:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $191
8010643d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106442:	e9 b7 f3 ff ff       	jmp    801057fe <alltraps>

80106447 <vector192>:
.globl vector192
vector192:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $192
80106449:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010644e:	e9 ab f3 ff ff       	jmp    801057fe <alltraps>

80106453 <vector193>:
.globl vector193
vector193:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $193
80106455:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010645a:	e9 9f f3 ff ff       	jmp    801057fe <alltraps>

8010645f <vector194>:
.globl vector194
vector194:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $194
80106461:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106466:	e9 93 f3 ff ff       	jmp    801057fe <alltraps>

8010646b <vector195>:
.globl vector195
vector195:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $195
8010646d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106472:	e9 87 f3 ff ff       	jmp    801057fe <alltraps>

80106477 <vector196>:
.globl vector196
vector196:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $196
80106479:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010647e:	e9 7b f3 ff ff       	jmp    801057fe <alltraps>

80106483 <vector197>:
.globl vector197
vector197:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $197
80106485:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010648a:	e9 6f f3 ff ff       	jmp    801057fe <alltraps>

8010648f <vector198>:
.globl vector198
vector198:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $198
80106491:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106496:	e9 63 f3 ff ff       	jmp    801057fe <alltraps>

8010649b <vector199>:
.globl vector199
vector199:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $199
8010649d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801064a2:	e9 57 f3 ff ff       	jmp    801057fe <alltraps>

801064a7 <vector200>:
.globl vector200
vector200:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $200
801064a9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801064ae:	e9 4b f3 ff ff       	jmp    801057fe <alltraps>

801064b3 <vector201>:
.globl vector201
vector201:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $201
801064b5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801064ba:	e9 3f f3 ff ff       	jmp    801057fe <alltraps>

801064bf <vector202>:
.globl vector202
vector202:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $202
801064c1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801064c6:	e9 33 f3 ff ff       	jmp    801057fe <alltraps>

801064cb <vector203>:
.globl vector203
vector203:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $203
801064cd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801064d2:	e9 27 f3 ff ff       	jmp    801057fe <alltraps>

801064d7 <vector204>:
.globl vector204
vector204:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $204
801064d9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801064de:	e9 1b f3 ff ff       	jmp    801057fe <alltraps>

801064e3 <vector205>:
.globl vector205
vector205:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $205
801064e5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801064ea:	e9 0f f3 ff ff       	jmp    801057fe <alltraps>

801064ef <vector206>:
.globl vector206
vector206:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $206
801064f1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801064f6:	e9 03 f3 ff ff       	jmp    801057fe <alltraps>

801064fb <vector207>:
.globl vector207
vector207:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $207
801064fd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106502:	e9 f7 f2 ff ff       	jmp    801057fe <alltraps>

80106507 <vector208>:
.globl vector208
vector208:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $208
80106509:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010650e:	e9 eb f2 ff ff       	jmp    801057fe <alltraps>

80106513 <vector209>:
.globl vector209
vector209:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $209
80106515:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010651a:	e9 df f2 ff ff       	jmp    801057fe <alltraps>

8010651f <vector210>:
.globl vector210
vector210:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $210
80106521:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106526:	e9 d3 f2 ff ff       	jmp    801057fe <alltraps>

8010652b <vector211>:
.globl vector211
vector211:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $211
8010652d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106532:	e9 c7 f2 ff ff       	jmp    801057fe <alltraps>

80106537 <vector212>:
.globl vector212
vector212:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $212
80106539:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010653e:	e9 bb f2 ff ff       	jmp    801057fe <alltraps>

80106543 <vector213>:
.globl vector213
vector213:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $213
80106545:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010654a:	e9 af f2 ff ff       	jmp    801057fe <alltraps>

8010654f <vector214>:
.globl vector214
vector214:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $214
80106551:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106556:	e9 a3 f2 ff ff       	jmp    801057fe <alltraps>

8010655b <vector215>:
.globl vector215
vector215:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $215
8010655d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106562:	e9 97 f2 ff ff       	jmp    801057fe <alltraps>

80106567 <vector216>:
.globl vector216
vector216:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $216
80106569:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010656e:	e9 8b f2 ff ff       	jmp    801057fe <alltraps>

80106573 <vector217>:
.globl vector217
vector217:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $217
80106575:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010657a:	e9 7f f2 ff ff       	jmp    801057fe <alltraps>

8010657f <vector218>:
.globl vector218
vector218:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $218
80106581:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106586:	e9 73 f2 ff ff       	jmp    801057fe <alltraps>

8010658b <vector219>:
.globl vector219
vector219:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $219
8010658d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106592:	e9 67 f2 ff ff       	jmp    801057fe <alltraps>

80106597 <vector220>:
.globl vector220
vector220:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $220
80106599:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010659e:	e9 5b f2 ff ff       	jmp    801057fe <alltraps>

801065a3 <vector221>:
.globl vector221
vector221:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $221
801065a5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801065aa:	e9 4f f2 ff ff       	jmp    801057fe <alltraps>

801065af <vector222>:
.globl vector222
vector222:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $222
801065b1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801065b6:	e9 43 f2 ff ff       	jmp    801057fe <alltraps>

801065bb <vector223>:
.globl vector223
vector223:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $223
801065bd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801065c2:	e9 37 f2 ff ff       	jmp    801057fe <alltraps>

801065c7 <vector224>:
.globl vector224
vector224:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $224
801065c9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801065ce:	e9 2b f2 ff ff       	jmp    801057fe <alltraps>

801065d3 <vector225>:
.globl vector225
vector225:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $225
801065d5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801065da:	e9 1f f2 ff ff       	jmp    801057fe <alltraps>

801065df <vector226>:
.globl vector226
vector226:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $226
801065e1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801065e6:	e9 13 f2 ff ff       	jmp    801057fe <alltraps>

801065eb <vector227>:
.globl vector227
vector227:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $227
801065ed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801065f2:	e9 07 f2 ff ff       	jmp    801057fe <alltraps>

801065f7 <vector228>:
.globl vector228
vector228:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $228
801065f9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801065fe:	e9 fb f1 ff ff       	jmp    801057fe <alltraps>

80106603 <vector229>:
.globl vector229
vector229:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $229
80106605:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010660a:	e9 ef f1 ff ff       	jmp    801057fe <alltraps>

8010660f <vector230>:
.globl vector230
vector230:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $230
80106611:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106616:	e9 e3 f1 ff ff       	jmp    801057fe <alltraps>

8010661b <vector231>:
.globl vector231
vector231:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $231
8010661d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106622:	e9 d7 f1 ff ff       	jmp    801057fe <alltraps>

80106627 <vector232>:
.globl vector232
vector232:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $232
80106629:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010662e:	e9 cb f1 ff ff       	jmp    801057fe <alltraps>

80106633 <vector233>:
.globl vector233
vector233:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $233
80106635:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010663a:	e9 bf f1 ff ff       	jmp    801057fe <alltraps>

8010663f <vector234>:
.globl vector234
vector234:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $234
80106641:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106646:	e9 b3 f1 ff ff       	jmp    801057fe <alltraps>

8010664b <vector235>:
.globl vector235
vector235:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $235
8010664d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106652:	e9 a7 f1 ff ff       	jmp    801057fe <alltraps>

80106657 <vector236>:
.globl vector236
vector236:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $236
80106659:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010665e:	e9 9b f1 ff ff       	jmp    801057fe <alltraps>

80106663 <vector237>:
.globl vector237
vector237:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $237
80106665:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010666a:	e9 8f f1 ff ff       	jmp    801057fe <alltraps>

8010666f <vector238>:
.globl vector238
vector238:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $238
80106671:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106676:	e9 83 f1 ff ff       	jmp    801057fe <alltraps>

8010667b <vector239>:
.globl vector239
vector239:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $239
8010667d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106682:	e9 77 f1 ff ff       	jmp    801057fe <alltraps>

80106687 <vector240>:
.globl vector240
vector240:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $240
80106689:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010668e:	e9 6b f1 ff ff       	jmp    801057fe <alltraps>

80106693 <vector241>:
.globl vector241
vector241:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $241
80106695:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010669a:	e9 5f f1 ff ff       	jmp    801057fe <alltraps>

8010669f <vector242>:
.globl vector242
vector242:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $242
801066a1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801066a6:	e9 53 f1 ff ff       	jmp    801057fe <alltraps>

801066ab <vector243>:
.globl vector243
vector243:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $243
801066ad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801066b2:	e9 47 f1 ff ff       	jmp    801057fe <alltraps>

801066b7 <vector244>:
.globl vector244
vector244:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $244
801066b9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801066be:	e9 3b f1 ff ff       	jmp    801057fe <alltraps>

801066c3 <vector245>:
.globl vector245
vector245:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $245
801066c5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801066ca:	e9 2f f1 ff ff       	jmp    801057fe <alltraps>

801066cf <vector246>:
.globl vector246
vector246:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $246
801066d1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801066d6:	e9 23 f1 ff ff       	jmp    801057fe <alltraps>

801066db <vector247>:
.globl vector247
vector247:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $247
801066dd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801066e2:	e9 17 f1 ff ff       	jmp    801057fe <alltraps>

801066e7 <vector248>:
.globl vector248
vector248:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $248
801066e9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801066ee:	e9 0b f1 ff ff       	jmp    801057fe <alltraps>

801066f3 <vector249>:
.globl vector249
vector249:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $249
801066f5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801066fa:	e9 ff f0 ff ff       	jmp    801057fe <alltraps>

801066ff <vector250>:
.globl vector250
vector250:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $250
80106701:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106706:	e9 f3 f0 ff ff       	jmp    801057fe <alltraps>

8010670b <vector251>:
.globl vector251
vector251:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $251
8010670d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106712:	e9 e7 f0 ff ff       	jmp    801057fe <alltraps>

80106717 <vector252>:
.globl vector252
vector252:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $252
80106719:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010671e:	e9 db f0 ff ff       	jmp    801057fe <alltraps>

80106723 <vector253>:
.globl vector253
vector253:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $253
80106725:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010672a:	e9 cf f0 ff ff       	jmp    801057fe <alltraps>

8010672f <vector254>:
.globl vector254
vector254:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $254
80106731:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106736:	e9 c3 f0 ff ff       	jmp    801057fe <alltraps>

8010673b <vector255>:
.globl vector255
vector255:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $255
8010673d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106742:	e9 b7 f0 ff ff       	jmp    801057fe <alltraps>
80106747:	66 90                	xchg   %ax,%ax
80106749:	66 90                	xchg   %ax,%ax
8010674b:	66 90                	xchg   %ax,%ax
8010674d:	66 90                	xchg   %ax,%ax
8010674f:	90                   	nop

80106750 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	57                   	push   %edi
80106754:	56                   	push   %esi
80106755:	53                   	push   %ebx
80106756:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106758:	c1 ea 16             	shr    $0x16,%edx
8010675b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010675e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106761:	8b 07                	mov    (%edi),%eax
80106763:	a8 01                	test   $0x1,%al
80106765:	74 29                	je     80106790 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106767:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010676c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106772:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106775:	c1 eb 0a             	shr    $0xa,%ebx
80106778:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010677e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106781:	5b                   	pop    %ebx
80106782:	5e                   	pop    %esi
80106783:	5f                   	pop    %edi
80106784:	5d                   	pop    %ebp
80106785:	c3                   	ret    
80106786:	8d 76 00             	lea    0x0(%esi),%esi
80106789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106790:	85 c9                	test   %ecx,%ecx
80106792:	74 2c                	je     801067c0 <walkpgdir+0x70>
80106794:	e8 d7 bc ff ff       	call   80102470 <kalloc>
80106799:	85 c0                	test   %eax,%eax
8010679b:	89 c6                	mov    %eax,%esi
8010679d:	74 21                	je     801067c0 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010679f:	83 ec 04             	sub    $0x4,%esp
801067a2:	68 00 10 00 00       	push   $0x1000
801067a7:	6a 00                	push   $0x0
801067a9:	50                   	push   %eax
801067aa:	e8 c1 dc ff ff       	call   80104470 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801067af:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801067b5:	83 c4 10             	add    $0x10,%esp
801067b8:	83 c8 07             	or     $0x7,%eax
801067bb:	89 07                	mov    %eax,(%edi)
801067bd:	eb b3                	jmp    80106772 <walkpgdir+0x22>
801067bf:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
801067c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801067c3:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801067c5:	5b                   	pop    %ebx
801067c6:	5e                   	pop    %esi
801067c7:	5f                   	pop    %edi
801067c8:	5d                   	pop    %ebp
801067c9:	c3                   	ret    
801067ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801067d0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801067d0:	55                   	push   %ebp
801067d1:	89 e5                	mov    %esp,%ebp
801067d3:	57                   	push   %edi
801067d4:	56                   	push   %esi
801067d5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801067d6:	89 d3                	mov    %edx,%ebx
801067d8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801067de:	83 ec 1c             	sub    $0x1c,%esp
801067e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067e4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801067e8:	8b 7d 08             	mov    0x8(%ebp),%edi
801067eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801067f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801067f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801067f6:	29 df                	sub    %ebx,%edi
801067f8:	83 c8 01             	or     $0x1,%eax
801067fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
801067fe:	eb 15                	jmp    80106815 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106800:	f6 00 01             	testb  $0x1,(%eax)
80106803:	75 45                	jne    8010684a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106805:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106808:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010680b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010680d:	74 31                	je     80106840 <mappages+0x70>
      break;
    a += PGSIZE;
8010680f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106815:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106818:	b9 01 00 00 00       	mov    $0x1,%ecx
8010681d:	89 da                	mov    %ebx,%edx
8010681f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106822:	e8 29 ff ff ff       	call   80106750 <walkpgdir>
80106827:	85 c0                	test   %eax,%eax
80106829:	75 d5                	jne    80106800 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010682b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010682e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106833:	5b                   	pop    %ebx
80106834:	5e                   	pop    %esi
80106835:	5f                   	pop    %edi
80106836:	5d                   	pop    %ebp
80106837:	c3                   	ret    
80106838:	90                   	nop
80106839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106840:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106843:	31 c0                	xor    %eax,%eax
}
80106845:	5b                   	pop    %ebx
80106846:	5e                   	pop    %esi
80106847:	5f                   	pop    %edi
80106848:	5d                   	pop    %ebp
80106849:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010684a:	83 ec 0c             	sub    $0xc,%esp
8010684d:	68 58 79 10 80       	push   $0x80107958
80106852:	e8 f9 9a ff ff       	call   80100350 <panic>
80106857:	89 f6                	mov    %esi,%esi
80106859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106860 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	57                   	push   %edi
80106864:	56                   	push   %esi
80106865:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106866:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010686c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010686e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106874:	83 ec 1c             	sub    $0x1c,%esp
80106877:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010687a:	39 d3                	cmp    %edx,%ebx
8010687c:	73 60                	jae    801068de <deallocuvm.part.0+0x7e>
8010687e:	89 d6                	mov    %edx,%esi
80106880:	eb 3d                	jmp    801068bf <deallocuvm.part.0+0x5f>
80106882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
80106888:	8b 10                	mov    (%eax),%edx
8010688a:	f6 c2 01             	test   $0x1,%dl
8010688d:	74 26                	je     801068b5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010688f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106895:	74 52                	je     801068e9 <deallocuvm.part.0+0x89>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106897:	83 ec 0c             	sub    $0xc,%esp
8010689a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801068a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068a3:	52                   	push   %edx
801068a4:	e8 17 ba ff ff       	call   801022c0 <kfree>
      *pte = 0;
801068a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068ac:	83 c4 10             	add    $0x10,%esp
801068af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801068b5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068bb:	39 f3                	cmp    %esi,%ebx
801068bd:	73 1f                	jae    801068de <deallocuvm.part.0+0x7e>
    pte = walkpgdir(pgdir, (char*)a, 0);
801068bf:	31 c9                	xor    %ecx,%ecx
801068c1:	89 da                	mov    %ebx,%edx
801068c3:	89 f8                	mov    %edi,%eax
801068c5:	e8 86 fe ff ff       	call   80106750 <walkpgdir>
    if(!pte)
801068ca:	85 c0                	test   %eax,%eax
801068cc:	75 ba                	jne    80106888 <deallocuvm.part.0+0x28>
      a += (NPTENTRIES - 1) * PGSIZE;
801068ce:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801068d4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068da:	39 f3                	cmp    %esi,%ebx
801068dc:	72 e1                	jb     801068bf <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801068de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801068e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068e4:	5b                   	pop    %ebx
801068e5:	5e                   	pop    %esi
801068e6:	5f                   	pop    %edi
801068e7:	5d                   	pop    %ebp
801068e8:	c3                   	ret    
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801068e9:	83 ec 0c             	sub    $0xc,%esp
801068ec:	68 fa 72 10 80       	push   $0x801072fa
801068f1:	e8 5a 9a ff ff       	call   80100350 <panic>
801068f6:	8d 76 00             	lea    0x0(%esi),%esi
801068f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106900 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	53                   	push   %ebx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106904:	31 db                	xor    %ebx,%ebx

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106906:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106909:	e8 c2 bd ff ff       	call   801026d0 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010690e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80106914:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80106919:	8d 90 40 13 11 80    	lea    -0x7feeecc0(%eax),%edx
8010691f:	c6 80 bd 13 11 80 9a 	movb   $0x9a,-0x7feeec43(%eax)
80106926:	c6 80 be 13 11 80 cf 	movb   $0xcf,-0x7feeec42(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010692d:	c6 80 c5 13 11 80 92 	movb   $0x92,-0x7feeec3b(%eax)
80106934:	c6 80 c6 13 11 80 cf 	movb   $0xcf,-0x7feeec3a(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010693b:	66 89 4a 78          	mov    %cx,0x78(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010693f:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106944:	66 89 5a 7a          	mov    %bx,0x7a(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106948:	66 89 8a 80 00 00 00 	mov    %cx,0x80(%edx)
8010694f:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106951:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106956:	66 89 9a 82 00 00 00 	mov    %bx,0x82(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010695d:	66 89 8a 90 00 00 00 	mov    %cx,0x90(%edx)
80106964:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106966:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010696b:	66 89 9a 92 00 00 00 	mov    %bx,0x92(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106972:	31 db                	xor    %ebx,%ebx
80106974:	66 89 8a 98 00 00 00 	mov    %cx,0x98(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010697b:	8d 88 f4 13 11 80    	lea    -0x7feeec0c(%eax),%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106981:	66 89 9a 9a 00 00 00 	mov    %bx,0x9a(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106988:	31 db                	xor    %ebx,%ebx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010698a:	c6 80 d5 13 11 80 fa 	movb   $0xfa,-0x7feeec2b(%eax)
80106991:	c6 80 d6 13 11 80 cf 	movb   $0xcf,-0x7feeec2a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106998:	66 89 9a 88 00 00 00 	mov    %bx,0x88(%edx)
8010699f:	66 89 8a 8a 00 00 00 	mov    %cx,0x8a(%edx)
801069a6:	89 cb                	mov    %ecx,%ebx
801069a8:	c1 e9 18             	shr    $0x18,%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801069ab:	c6 80 dd 13 11 80 f2 	movb   $0xf2,-0x7feeec23(%eax)
801069b2:	c6 80 de 13 11 80 cf 	movb   $0xcf,-0x7feeec22(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801069b9:	88 8a 8f 00 00 00    	mov    %cl,0x8f(%edx)
801069bf:	c6 80 cd 13 11 80 92 	movb   $0x92,-0x7feeec33(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801069c6:	b9 37 00 00 00       	mov    $0x37,%ecx
801069cb:	c6 80 ce 13 11 80 c0 	movb   $0xc0,-0x7feeec32(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801069d2:	05 b0 13 11 80       	add    $0x801113b0,%eax
801069d7:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801069db:	c1 eb 10             	shr    $0x10,%ebx
  pd[1] = (uint)p;
801069de:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801069e2:	c1 e8 10             	shr    $0x10,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801069e5:	c6 42 7c 00          	movb   $0x0,0x7c(%edx)
801069e9:	c6 42 7f 00          	movb   $0x0,0x7f(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801069ed:	c6 82 84 00 00 00 00 	movb   $0x0,0x84(%edx)
801069f4:	c6 82 87 00 00 00 00 	movb   $0x0,0x87(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801069fb:	c6 82 94 00 00 00 00 	movb   $0x0,0x94(%edx)
80106a02:	c6 82 97 00 00 00 00 	movb   $0x0,0x97(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a09:	c6 82 9c 00 00 00 00 	movb   $0x0,0x9c(%edx)
80106a10:	c6 82 9f 00 00 00 00 	movb   $0x0,0x9f(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106a17:	88 9a 8c 00 00 00    	mov    %bl,0x8c(%edx)
80106a1d:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106a21:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106a24:	0f 01 10             	lgdtl  (%eax)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
80106a27:	b8 18 00 00 00       	mov    $0x18,%eax
80106a2c:	8e e8                	mov    %eax,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
80106a2e:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80106a35:	00 00 00 00 

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106a39:	65 89 15 00 00 00 00 	mov    %edx,%gs:0x0
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
}
80106a40:	83 c4 14             	add    $0x14,%esp
80106a43:	5b                   	pop    %ebx
80106a44:	5d                   	pop    %ebp
80106a45:	c3                   	ret    
80106a46:	8d 76 00             	lea    0x0(%esi),%esi
80106a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a50 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	56                   	push   %esi
80106a54:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106a55:	e8 16 ba ff ff       	call   80102470 <kalloc>
80106a5a:	85 c0                	test   %eax,%eax
80106a5c:	74 52                	je     80106ab0 <setupkvm+0x60>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106a5e:	83 ec 04             	sub    $0x4,%esp
80106a61:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a63:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106a68:	68 00 10 00 00       	push   $0x1000
80106a6d:	6a 00                	push   $0x0
80106a6f:	50                   	push   %eax
80106a70:	e8 fb d9 ff ff       	call   80104470 <memset>
80106a75:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106a78:	8b 43 04             	mov    0x4(%ebx),%eax
80106a7b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106a7e:	83 ec 08             	sub    $0x8,%esp
80106a81:	8b 13                	mov    (%ebx),%edx
80106a83:	ff 73 0c             	pushl  0xc(%ebx)
80106a86:	50                   	push   %eax
80106a87:	29 c1                	sub    %eax,%ecx
80106a89:	89 f0                	mov    %esi,%eax
80106a8b:	e8 40 fd ff ff       	call   801067d0 <mappages>
80106a90:	83 c4 10             	add    $0x10,%esp
80106a93:	85 c0                	test   %eax,%eax
80106a95:	78 19                	js     80106ab0 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106a97:	83 c3 10             	add    $0x10,%ebx
80106a9a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106aa0:	75 d6                	jne    80106a78 <setupkvm+0x28>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106aa2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106aa5:	89 f0                	mov    %esi,%eax
80106aa7:	5b                   	pop    %ebx
80106aa8:	5e                   	pop    %esi
80106aa9:	5d                   	pop    %ebp
80106aaa:	c3                   	ret    
80106aab:	90                   	nop
80106aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ab0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106ab3:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
80106ab5:	5b                   	pop    %ebx
80106ab6:	5e                   	pop    %esi
80106ab7:	5d                   	pop    %ebp
80106ab8:	c3                   	ret    
80106ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ac0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106ac6:	e8 85 ff ff ff       	call   80106a50 <setupkvm>
80106acb:	a3 04 41 11 80       	mov    %eax,0x80114104
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ad0:	05 00 00 00 80       	add    $0x80000000,%eax
80106ad5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106ad8:	c9                   	leave  
80106ad9:	c3                   	ret    
80106ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ae0 <switchkvm>:
80106ae0:	a1 04 41 11 80       	mov    0x80114104,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106ae5:	55                   	push   %ebp
80106ae6:	89 e5                	mov    %esp,%ebp
80106ae8:	05 00 00 00 80       	add    $0x80000000,%eax
80106aed:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106af0:	5d                   	pop    %ebp
80106af1:	c3                   	ret    
80106af2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b00 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106b00:	55                   	push   %ebp
80106b01:	89 e5                	mov    %esp,%ebp
80106b03:	53                   	push   %ebx
80106b04:	83 ec 04             	sub    $0x4,%esp
80106b07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80106b0a:	e8 91 d8 ff ff       	call   801043a0 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106b0f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106b15:	b9 67 00 00 00       	mov    $0x67,%ecx
80106b1a:	8d 50 08             	lea    0x8(%eax),%edx
80106b1d:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106b24:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80106b2b:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106b32:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80106b39:	89 d1                	mov    %edx,%ecx
80106b3b:	c1 ea 18             	shr    $0x18,%edx
80106b3e:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106b44:	ba 10 00 00 00       	mov    $0x10,%edx
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106b49:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106b4c:	66 89 50 10          	mov    %dx,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106b50:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106b57:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106b5d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106b62:	8b 52 08             	mov    0x8(%edx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106b65:	66 89 48 6e          	mov    %cx,0x6e(%eax)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106b69:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106b6f:	89 50 0c             	mov    %edx,0xc(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106b72:	b8 30 00 00 00       	mov    $0x30,%eax
80106b77:	0f 00 d8             	ltr    %ax
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
80106b7a:	8b 43 04             	mov    0x4(%ebx),%eax
80106b7d:	85 c0                	test   %eax,%eax
80106b7f:	74 11                	je     80106b92 <switchuvm+0x92>
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106b81:	05 00 00 00 80       	add    $0x80000000,%eax
80106b86:	0f 22 d8             	mov    %eax,%cr3
    panic("switchuvm: no pgdir");
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106b89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106b8c:	c9                   	leave  
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106b8d:	e9 3e d8 ff ff       	jmp    801043d0 <popcli>
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106b92:	83 ec 0c             	sub    $0xc,%esp
80106b95:	68 5e 79 10 80       	push   $0x8010795e
80106b9a:	e8 b1 97 ff ff       	call   80100350 <panic>
80106b9f:	90                   	nop

80106ba0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ba0:	55                   	push   %ebp
80106ba1:	89 e5                	mov    %esp,%ebp
80106ba3:	57                   	push   %edi
80106ba4:	56                   	push   %esi
80106ba5:	53                   	push   %ebx
80106ba6:	83 ec 1c             	sub    $0x1c,%esp
80106ba9:	8b 75 10             	mov    0x10(%ebp),%esi
80106bac:	8b 45 08             	mov    0x8(%ebp),%eax
80106baf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106bb2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106bb8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106bbb:	77 49                	ja     80106c06 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106bbd:	e8 ae b8 ff ff       	call   80102470 <kalloc>
  memset(mem, 0, PGSIZE);
80106bc2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106bc5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106bc7:	68 00 10 00 00       	push   $0x1000
80106bcc:	6a 00                	push   $0x0
80106bce:	50                   	push   %eax
80106bcf:	e8 9c d8 ff ff       	call   80104470 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106bd4:	58                   	pop    %eax
80106bd5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106bdb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106be0:	5a                   	pop    %edx
80106be1:	6a 06                	push   $0x6
80106be3:	50                   	push   %eax
80106be4:	31 d2                	xor    %edx,%edx
80106be6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106be9:	e8 e2 fb ff ff       	call   801067d0 <mappages>
  memmove(mem, init, sz);
80106bee:	89 75 10             	mov    %esi,0x10(%ebp)
80106bf1:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106bf4:	83 c4 10             	add    $0x10,%esp
80106bf7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106bfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bfd:	5b                   	pop    %ebx
80106bfe:	5e                   	pop    %esi
80106bff:	5f                   	pop    %edi
80106c00:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106c01:	e9 1a d9 ff ff       	jmp    80104520 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106c06:	83 ec 0c             	sub    $0xc,%esp
80106c09:	68 72 79 10 80       	push   $0x80107972
80106c0e:	e8 3d 97 ff ff       	call   80100350 <panic>
80106c13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c20 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	57                   	push   %edi
80106c24:	56                   	push   %esi
80106c25:	53                   	push   %ebx
80106c26:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106c29:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106c30:	0f 85 91 00 00 00    	jne    80106cc7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106c36:	8b 75 18             	mov    0x18(%ebp),%esi
80106c39:	31 db                	xor    %ebx,%ebx
80106c3b:	85 f6                	test   %esi,%esi
80106c3d:	75 1a                	jne    80106c59 <loaduvm+0x39>
80106c3f:	eb 6f                	jmp    80106cb0 <loaduvm+0x90>
80106c41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c48:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c4e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106c54:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106c57:	76 57                	jbe    80106cb0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106c59:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c5c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c5f:	31 c9                	xor    %ecx,%ecx
80106c61:	01 da                	add    %ebx,%edx
80106c63:	e8 e8 fa ff ff       	call   80106750 <walkpgdir>
80106c68:	85 c0                	test   %eax,%eax
80106c6a:	74 4e                	je     80106cba <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106c6c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c6e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106c71:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106c76:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106c7b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106c81:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106c84:	01 d9                	add    %ebx,%ecx
80106c86:	05 00 00 00 80       	add    $0x80000000,%eax
80106c8b:	57                   	push   %edi
80106c8c:	51                   	push   %ecx
80106c8d:	50                   	push   %eax
80106c8e:	ff 75 10             	pushl  0x10(%ebp)
80106c91:	e8 8a ac ff ff       	call   80101920 <readi>
80106c96:	83 c4 10             	add    $0x10,%esp
80106c99:	39 c7                	cmp    %eax,%edi
80106c9b:	74 ab                	je     80106c48 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106c9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106ca5:	5b                   	pop    %ebx
80106ca6:	5e                   	pop    %esi
80106ca7:	5f                   	pop    %edi
80106ca8:	5d                   	pop    %ebp
80106ca9:	c3                   	ret    
80106caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106cb3:	31 c0                	xor    %eax,%eax
}
80106cb5:	5b                   	pop    %ebx
80106cb6:	5e                   	pop    %esi
80106cb7:	5f                   	pop    %edi
80106cb8:	5d                   	pop    %ebp
80106cb9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106cba:	83 ec 0c             	sub    $0xc,%esp
80106cbd:	68 8c 79 10 80       	push   $0x8010798c
80106cc2:	e8 89 96 ff ff       	call   80100350 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106cc7:	83 ec 0c             	sub    $0xc,%esp
80106cca:	68 30 7a 10 80       	push   $0x80107a30
80106ccf:	e8 7c 96 ff ff       	call   80100350 <panic>
80106cd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106cda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ce0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	57                   	push   %edi
80106ce4:	56                   	push   %esi
80106ce5:	53                   	push   %ebx
80106ce6:	83 ec 0c             	sub    $0xc,%esp
80106ce9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106cec:	85 ff                	test   %edi,%edi
80106cee:	0f 88 ca 00 00 00    	js     80106dbe <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106cf4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106cfa:	0f 82 82 00 00 00    	jb     80106d82 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106d00:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106d06:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106d0c:	39 df                	cmp    %ebx,%edi
80106d0e:	77 43                	ja     80106d53 <allocuvm+0x73>
80106d10:	e9 bb 00 00 00       	jmp    80106dd0 <allocuvm+0xf0>
80106d15:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106d18:	83 ec 04             	sub    $0x4,%esp
80106d1b:	68 00 10 00 00       	push   $0x1000
80106d20:	6a 00                	push   $0x0
80106d22:	50                   	push   %eax
80106d23:	e8 48 d7 ff ff       	call   80104470 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d28:	58                   	pop    %eax
80106d29:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106d2f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d34:	5a                   	pop    %edx
80106d35:	6a 06                	push   $0x6
80106d37:	50                   	push   %eax
80106d38:	89 da                	mov    %ebx,%edx
80106d3a:	8b 45 08             	mov    0x8(%ebp),%eax
80106d3d:	e8 8e fa ff ff       	call   801067d0 <mappages>
80106d42:	83 c4 10             	add    $0x10,%esp
80106d45:	85 c0                	test   %eax,%eax
80106d47:	78 47                	js     80106d90 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106d49:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d4f:	39 df                	cmp    %ebx,%edi
80106d51:	76 7d                	jbe    80106dd0 <allocuvm+0xf0>
    mem = kalloc();
80106d53:	e8 18 b7 ff ff       	call   80102470 <kalloc>
    if(mem == 0){
80106d58:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106d5a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106d5c:	75 ba                	jne    80106d18 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106d5e:	83 ec 0c             	sub    $0xc,%esp
80106d61:	68 aa 79 10 80       	push   $0x801079aa
80106d66:	e8 d5 98 ff ff       	call   80100640 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d6b:	83 c4 10             	add    $0x10,%esp
80106d6e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106d71:	76 4b                	jbe    80106dbe <allocuvm+0xde>
80106d73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d76:	8b 45 08             	mov    0x8(%ebp),%eax
80106d79:	89 fa                	mov    %edi,%edx
80106d7b:	e8 e0 fa ff ff       	call   80106860 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106d80:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106d82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d85:	5b                   	pop    %ebx
80106d86:	5e                   	pop    %esi
80106d87:	5f                   	pop    %edi
80106d88:	5d                   	pop    %ebp
80106d89:	c3                   	ret    
80106d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106d90:	83 ec 0c             	sub    $0xc,%esp
80106d93:	68 c2 79 10 80       	push   $0x801079c2
80106d98:	e8 a3 98 ff ff       	call   80100640 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d9d:	83 c4 10             	add    $0x10,%esp
80106da0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106da3:	76 0d                	jbe    80106db2 <allocuvm+0xd2>
80106da5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106da8:	8b 45 08             	mov    0x8(%ebp),%eax
80106dab:	89 fa                	mov    %edi,%edx
80106dad:	e8 ae fa ff ff       	call   80106860 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106db2:	83 ec 0c             	sub    $0xc,%esp
80106db5:	56                   	push   %esi
80106db6:	e8 05 b5 ff ff       	call   801022c0 <kfree>
      return 0;
80106dbb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106dbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106dc1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106dc3:	5b                   	pop    %ebx
80106dc4:	5e                   	pop    %esi
80106dc5:	5f                   	pop    %edi
80106dc6:	5d                   	pop    %ebp
80106dc7:	c3                   	ret    
80106dc8:	90                   	nop
80106dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106dd3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106dd5:	5b                   	pop    %ebx
80106dd6:	5e                   	pop    %esi
80106dd7:	5f                   	pop    %edi
80106dd8:	5d                   	pop    %ebp
80106dd9:	c3                   	ret    
80106dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106de0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106de6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106de9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106dec:	39 d1                	cmp    %edx,%ecx
80106dee:	73 10                	jae    80106e00 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106df0:	5d                   	pop    %ebp
80106df1:	e9 6a fa ff ff       	jmp    80106860 <deallocuvm.part.0>
80106df6:	8d 76 00             	lea    0x0(%esi),%esi
80106df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106e00:	89 d0                	mov    %edx,%eax
80106e02:	5d                   	pop    %ebp
80106e03:	c3                   	ret    
80106e04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e10 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	57                   	push   %edi
80106e14:	56                   	push   %esi
80106e15:	53                   	push   %ebx
80106e16:	83 ec 0c             	sub    $0xc,%esp
80106e19:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106e1c:	85 f6                	test   %esi,%esi
80106e1e:	74 59                	je     80106e79 <freevm+0x69>
80106e20:	31 c9                	xor    %ecx,%ecx
80106e22:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e27:	89 f0                	mov    %esi,%eax
80106e29:	e8 32 fa ff ff       	call   80106860 <deallocuvm.part.0>
80106e2e:	89 f3                	mov    %esi,%ebx
80106e30:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106e36:	eb 0f                	jmp    80106e47 <freevm+0x37>
80106e38:	90                   	nop
80106e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e40:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e43:	39 fb                	cmp    %edi,%ebx
80106e45:	74 23                	je     80106e6a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106e47:	8b 03                	mov    (%ebx),%eax
80106e49:	a8 01                	test   $0x1,%al
80106e4b:	74 f3                	je     80106e40 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106e4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106e52:	83 ec 0c             	sub    $0xc,%esp
80106e55:	83 c3 04             	add    $0x4,%ebx
80106e58:	05 00 00 00 80       	add    $0x80000000,%eax
80106e5d:	50                   	push   %eax
80106e5e:	e8 5d b4 ff ff       	call   801022c0 <kfree>
80106e63:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106e66:	39 fb                	cmp    %edi,%ebx
80106e68:	75 dd                	jne    80106e47 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106e6a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e70:	5b                   	pop    %ebx
80106e71:	5e                   	pop    %esi
80106e72:	5f                   	pop    %edi
80106e73:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106e74:	e9 47 b4 ff ff       	jmp    801022c0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106e79:	83 ec 0c             	sub    $0xc,%esp
80106e7c:	68 de 79 10 80       	push   $0x801079de
80106e81:	e8 ca 94 ff ff       	call   80100350 <panic>
80106e86:	8d 76 00             	lea    0x0(%esi),%esi
80106e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e90 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e90:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e91:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e93:	89 e5                	mov    %esp,%ebp
80106e95:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e98:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e9e:	e8 ad f8 ff ff       	call   80106750 <walkpgdir>
  if(pte == 0)
80106ea3:	85 c0                	test   %eax,%eax
80106ea5:	74 05                	je     80106eac <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106ea7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106eaa:	c9                   	leave  
80106eab:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106eac:	83 ec 0c             	sub    $0xc,%esp
80106eaf:	68 ef 79 10 80       	push   $0x801079ef
80106eb4:	e8 97 94 ff ff       	call   80100350 <panic>
80106eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ec0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	57                   	push   %edi
80106ec4:	56                   	push   %esi
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106ec9:	e8 82 fb ff ff       	call   80106a50 <setupkvm>
80106ece:	85 c0                	test   %eax,%eax
80106ed0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ed3:	0f 84 b2 00 00 00    	je     80106f8b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ed9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106edc:	85 c9                	test   %ecx,%ecx
80106ede:	0f 84 9c 00 00 00    	je     80106f80 <copyuvm+0xc0>
80106ee4:	31 f6                	xor    %esi,%esi
80106ee6:	eb 4a                	jmp    80106f32 <copyuvm+0x72>
80106ee8:	90                   	nop
80106ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106ef0:	83 ec 04             	sub    $0x4,%esp
80106ef3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106ef9:	68 00 10 00 00       	push   $0x1000
80106efe:	57                   	push   %edi
80106eff:	50                   	push   %eax
80106f00:	e8 1b d6 ff ff       	call   80104520 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106f05:	58                   	pop    %eax
80106f06:	5a                   	pop    %edx
80106f07:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80106f0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f10:	ff 75 e4             	pushl  -0x1c(%ebp)
80106f13:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f18:	52                   	push   %edx
80106f19:	89 f2                	mov    %esi,%edx
80106f1b:	e8 b0 f8 ff ff       	call   801067d0 <mappages>
80106f20:	83 c4 10             	add    $0x10,%esp
80106f23:	85 c0                	test   %eax,%eax
80106f25:	78 3e                	js     80106f65 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f27:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f2d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106f30:	76 4e                	jbe    80106f80 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106f32:	8b 45 08             	mov    0x8(%ebp),%eax
80106f35:	31 c9                	xor    %ecx,%ecx
80106f37:	89 f2                	mov    %esi,%edx
80106f39:	e8 12 f8 ff ff       	call   80106750 <walkpgdir>
80106f3e:	85 c0                	test   %eax,%eax
80106f40:	74 5a                	je     80106f9c <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106f42:	8b 18                	mov    (%eax),%ebx
80106f44:	f6 c3 01             	test   $0x1,%bl
80106f47:	74 46                	je     80106f8f <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106f49:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106f4b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106f51:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106f54:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106f5a:	e8 11 b5 ff ff       	call   80102470 <kalloc>
80106f5f:	85 c0                	test   %eax,%eax
80106f61:	89 c3                	mov    %eax,%ebx
80106f63:	75 8b                	jne    80106ef0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106f65:	83 ec 0c             	sub    $0xc,%esp
80106f68:	ff 75 e0             	pushl  -0x20(%ebp)
80106f6b:	e8 a0 fe ff ff       	call   80106e10 <freevm>
  return 0;
80106f70:	83 c4 10             	add    $0x10,%esp
80106f73:	31 c0                	xor    %eax,%eax
}
80106f75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f78:	5b                   	pop    %ebx
80106f79:	5e                   	pop    %esi
80106f7a:	5f                   	pop    %edi
80106f7b:	5d                   	pop    %ebp
80106f7c:	c3                   	ret    
80106f7d:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f86:	5b                   	pop    %ebx
80106f87:	5e                   	pop    %esi
80106f88:	5f                   	pop    %edi
80106f89:	5d                   	pop    %ebp
80106f8a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106f8b:	31 c0                	xor    %eax,%eax
80106f8d:	eb e6                	jmp    80106f75 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106f8f:	83 ec 0c             	sub    $0xc,%esp
80106f92:	68 13 7a 10 80       	push   $0x80107a13
80106f97:	e8 b4 93 ff ff       	call   80100350 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106f9c:	83 ec 0c             	sub    $0xc,%esp
80106f9f:	68 f9 79 10 80       	push   $0x801079f9
80106fa4:	e8 a7 93 ff ff       	call   80100350 <panic>
80106fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fb0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106fb0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106fb1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106fb3:	89 e5                	mov    %esp,%ebp
80106fb5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106fb8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fbb:	8b 45 08             	mov    0x8(%ebp),%eax
80106fbe:	e8 8d f7 ff ff       	call   80106750 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106fc3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106fc5:	89 c2                	mov    %eax,%edx
80106fc7:	83 e2 05             	and    $0x5,%edx
80106fca:	83 fa 05             	cmp    $0x5,%edx
80106fcd:	75 11                	jne    80106fe0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106fcf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80106fd4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106fd5:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106fda:	c3                   	ret    
80106fdb:	90                   	nop
80106fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106fe0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106fe2:	c9                   	leave  
80106fe3:	c3                   	ret    
80106fe4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ff0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	53                   	push   %ebx
80106ff6:	83 ec 1c             	sub    $0x1c,%esp
80106ff9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106ffc:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fff:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107002:	85 db                	test   %ebx,%ebx
80107004:	75 40                	jne    80107046 <copyout+0x56>
80107006:	eb 70                	jmp    80107078 <copyout+0x88>
80107008:	90                   	nop
80107009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107010:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107013:	89 f1                	mov    %esi,%ecx
80107015:	29 d1                	sub    %edx,%ecx
80107017:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010701d:	39 d9                	cmp    %ebx,%ecx
8010701f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107022:	29 f2                	sub    %esi,%edx
80107024:	83 ec 04             	sub    $0x4,%esp
80107027:	01 d0                	add    %edx,%eax
80107029:	51                   	push   %ecx
8010702a:	57                   	push   %edi
8010702b:	50                   	push   %eax
8010702c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010702f:	e8 ec d4 ff ff       	call   80104520 <memmove>
    len -= n;
    buf += n;
80107034:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107037:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010703a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107040:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107042:	29 cb                	sub    %ecx,%ebx
80107044:	74 32                	je     80107078 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107046:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107048:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010704b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010704e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107054:	56                   	push   %esi
80107055:	ff 75 08             	pushl  0x8(%ebp)
80107058:	e8 53 ff ff ff       	call   80106fb0 <uva2ka>
    if(pa0 == 0)
8010705d:	83 c4 10             	add    $0x10,%esp
80107060:	85 c0                	test   %eax,%eax
80107062:	75 ac                	jne    80107010 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107064:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107067:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010706c:	5b                   	pop    %ebx
8010706d:	5e                   	pop    %esi
8010706e:	5f                   	pop    %edi
8010706f:	5d                   	pop    %ebp
80107070:	c3                   	ret    
80107071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107078:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010707b:	31 c0                	xor    %eax,%eax
}
8010707d:	5b                   	pop    %ebx
8010707e:	5e                   	pop    %esi
8010707f:	5f                   	pop    %edi
80107080:	5d                   	pop    %ebp
80107081:	c3                   	ret    


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
8010002d:	b8 d0 2f 10 80       	mov    $0x80102fd0,%eax
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
80100046:	68 a0 6f 10 80       	push   $0x80106fa0
8010004b:	68 e0 b5 10 80       	push   $0x8010b5e0
80100050:	e8 3b 42 00 00       	call   80104290 <initlock>

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
801000d4:	e8 d7 41 00 00       	call   801042b0 <acquire>
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
80100114:	e8 f7 3d 00 00       	call   80103f10 <sleep>
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
80100154:	e8 37 43 00 00       	call   80104490 <release>
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
80100165:	e8 76 20 00 00       	call   801021e0 <iderw>
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
80100184:	e8 07 43 00 00       	call   80104490 <release>
80100189:	83 c4 10             	add    $0x10,%esp
8010018c:	eb ce                	jmp    8010015c <bread+0x9c>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
8010018e:	83 ec 0c             	sub    $0xc,%esp
80100191:	68 a7 6f 10 80       	push   $0x80106fa7
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
801001b8:	e9 23 20 00 00       	jmp    801021e0 <iderw>
// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("bwrite");
801001bd:	83 ec 0c             	sub    $0xc,%esp
801001c0:	68 b8 6f 10 80       	push   $0x80106fb8
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
801001e7:	e8 c4 40 00 00       	call   801042b0 <acquire>

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
80100221:	e8 aa 3e 00 00       	call   801040d0 <wakeup>

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
80100234:	e9 57 42 00 00       	jmp    80104490 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if((b->flags & B_BUSY) == 0)
    panic("brelse");
80100239:	83 ec 0c             	sub    $0xc,%esp
8010023c:	68 bf 6f 10 80       	push   $0x80106fbf
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
80100260:	e8 bb 15 00 00       	call   80101820 <iunlock>
  target = n;
  acquire(&cons.lock);
80100265:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010026c:	e8 3f 40 00 00       	call   801042b0 <acquire>
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
8010029d:	e8 6e 3c 00 00       	call   80103f10 <sleep>

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
801002b8:	8b 40 28             	mov    0x28(%eax),%eax
801002bb:	85 c0                	test   %eax,%eax
801002bd:	74 d1                	je     80100290 <consoleread+0x40>
        release(&cons.lock);
801002bf:	83 ec 0c             	sub    $0xc,%esp
801002c2:	68 20 a5 10 80       	push   $0x8010a520
801002c7:	e8 c4 41 00 00       	call   80104490 <release>
        ilock(ip);
801002cc:	89 3c 24             	mov    %edi,(%esp)
801002cf:	e8 3c 14 00 00       	call   80101710 <ilock>
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
80100326:	e8 65 41 00 00       	call   80104490 <release>
  ilock(ip);
8010032b:	89 3c 24             	mov    %edi,(%esp)
8010032e:	e8 dd 13 00 00       	call   80101710 <ilock>

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
80100373:	68 c6 6f 10 80       	push   $0x80106fc6
80100378:	e8 c3 02 00 00       	call   80100640 <cprintf>
  cprintf(s);
8010037d:	58                   	pop    %eax
8010037e:	ff 75 08             	pushl  0x8(%ebp)
80100381:	e8 ba 02 00 00       	call   80100640 <cprintf>
  cprintf("\n");
80100386:	c7 04 24 e6 74 10 80 	movl   $0x801074e6,(%esp)
8010038d:	e8 ae 02 00 00       	call   80100640 <cprintf>
  getcallerpcs(&s, pcs);
80100392:	5a                   	pop    %edx
80100393:	8d 45 08             	lea    0x8(%ebp),%eax
80100396:	59                   	pop    %ecx
80100397:	53                   	push   %ebx
80100398:	50                   	push   %eax
80100399:	e8 e2 3f 00 00       	call   80104380 <getcallerpcs>
8010039e:	83 c4 10             	add    $0x10,%esp
801003a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003a8:	83 ec 08             	sub    $0x8,%esp
801003ab:	ff 33                	pushl  (%ebx)
801003ad:	83 c3 04             	add    $0x4,%ebx
801003b0:	68 e2 6f 10 80       	push   $0x80106fe2
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
801003fa:	e8 a1 57 00 00       	call   80105ba0 <uartputc>
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
801004b3:	e8 e8 56 00 00       	call   80105ba0 <uartputc>
801004b8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004bf:	e8 dc 56 00 00       	call   80105ba0 <uartputc>
801004c4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004cb:	e8 d0 56 00 00       	call   80105ba0 <uartputc>
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
801004f4:	e8 97 40 00 00       	call   80104590 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004f9:	b8 80 07 00 00       	mov    $0x780,%eax
801004fe:	83 c4 0c             	add    $0xc,%esp
80100501:	29 d8                	sub    %ebx,%eax
80100503:	01 c0                	add    %eax,%eax
80100505:	50                   	push   %eax
80100506:	6a 00                	push   $0x0
80100508:	56                   	push   %esi
80100509:	e8 d2 3f 00 00       	call   801044e0 <memset>
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
80100520:	68 e6 6f 10 80       	push   $0x80106fe6
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
80100591:	0f b6 92 14 70 10 80 	movzbl -0x7fef8fec(%edx),%edx
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
801005ef:	e8 2c 12 00 00       	call   80101820 <iunlock>
  acquire(&cons.lock);
801005f4:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005fb:	e8 b0 3c 00 00       	call   801042b0 <acquire>
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
80100627:	e8 64 3e 00 00       	call   80104490 <release>
  ilock(ip);
8010062c:	58                   	pop    %eax
8010062d:	ff 75 08             	pushl  0x8(%ebp)
80100630:	e8 db 10 00 00       	call   80101710 <ilock>

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
801006ed:	e8 9e 3d 00 00       	call   80104490 <release>
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
80100768:	b8 f9 6f 10 80       	mov    $0x80106ff9,%eax
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
801007a8:	e8 03 3b 00 00       	call   801042b0 <acquire>
801007ad:	83 c4 10             	add    $0x10,%esp
801007b0:	e9 a4 fe ff ff       	jmp    80100659 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 00 70 10 80       	push   $0x80107000
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
801007e3:	e8 c8 3a 00 00       	call   801042b0 <acquire>
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
80100848:	e8 43 3c 00 00       	call   80104490 <release>
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
801008d6:	e8 f5 37 00 00       	call   801040d0 <wakeup>
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
80100957:	e9 64 38 00 00       	jmp    801041c0 <procdump>
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
80100986:	68 09 70 10 80       	push   $0x80107009
8010098b:	68 20 a5 10 80       	push   $0x8010a520
80100990:	e8 fb 38 00 00       	call   80104290 <initlock>

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
801009ba:	e8 d1 29 00 00       	call   80103390 <picenable>
  ioapicenable(IRQ_KBD, 0);
801009bf:	58                   	pop    %eax
801009c0:	5a                   	pop    %edx
801009c1:	6a 00                	push   $0x0
801009c3:	6a 01                	push   $0x1
801009c5:	e8 c6 19 00 00       	call   80102390 <ioapicenable>
}
801009ca:	83 c4 10             	add    $0x10,%esp
801009cd:	c9                   	leave  
801009ce:	c3                   	ret    
801009cf:	90                   	nop

801009d0 <cbuffer_init>:

void cbuffer_init(struct cbuffer * cb,
                  const unsigned int size,
                  const unsigned int esize,
                  void * store)
{
801009d0:	55                   	push   %ebp
801009d1:	89 e5                	mov    %esp,%ebp
801009d3:	8b 45 08             	mov    0x8(%ebp),%eax
	cb->size = size;
801009d6:	8b 55 0c             	mov    0xc(%ebp),%edx
801009d9:	89 10                	mov    %edx,(%eax)
	cb->elemsize = esize;
801009db:	8b 55 10             	mov    0x10(%ebp),%edx
	cb->start = 0;
801009de:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	cb->count = 0;
801009e5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
                  const unsigned int size,
                  const unsigned int esize,
                  void * store)
{
	cb->size = size;
	cb->elemsize = esize;
801009ec:	89 50 04             	mov    %edx,0x4(%eax)
	cb->start = 0;
	cb->count = 0;
	cb->data = store;
801009ef:	8b 55 14             	mov    0x14(%ebp),%edx
801009f2:	89 50 10             	mov    %edx,0x10(%eax)
}
801009f5:	5d                   	pop    %ebp
801009f6:	c3                   	ret    
801009f7:	89 f6                	mov    %esi,%esi
801009f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100a00 <cbuffer_is_full>:


int cbuffer_is_full(const struct cbuffer * cb)
{
80100a00:	55                   	push   %ebp
80100a01:	89 e5                	mov    %esp,%ebp
80100a03:	8b 45 08             	mov    0x8(%ebp),%eax
	return cb->count == cb->size;
}
80100a06:	5d                   	pop    %ebp
}


int cbuffer_is_full(const struct cbuffer * cb)
{
	return cb->count == cb->size;
80100a07:	8b 10                	mov    (%eax),%edx
80100a09:	39 50 0c             	cmp    %edx,0xc(%eax)
80100a0c:	0f 94 c0             	sete   %al
80100a0f:	0f b6 c0             	movzbl %al,%eax
}
80100a12:	c3                   	ret    
80100a13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100a20 <cbuffer_is_empty>:

 
int cbuffer_is_empty(const struct cbuffer * cb)
{
80100a20:	55                   	push   %ebp
80100a21:	89 e5                	mov    %esp,%ebp
	return cb->count == 0;
80100a23:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100a26:	5d                   	pop    %ebp
}

 
int cbuffer_is_empty(const struct cbuffer * cb)
{
	return cb->count == 0;
80100a27:	8b 40 0c             	mov    0xc(%eax),%eax
80100a2a:	85 c0                	test   %eax,%eax
80100a2c:	0f 94 c0             	sete   %al
80100a2f:	0f b6 c0             	movzbl %al,%eax
}
80100a32:	c3                   	ret    
80100a33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100a40 <cbuffer_write>:

 
void cbuffer_write(struct cbuffer * cb, void * elem)
{
80100a40:	55                   	push   %ebp
	int end = (cb->start + cb->count) % cb->size;
	memmove(&cb->data[end * cb->elemsize], elem, cb->elemsize);
80100a41:	31 d2                	xor    %edx,%edx
	return cb->count == 0;
}

 
void cbuffer_write(struct cbuffer * cb, void * elem)
{
80100a43:	89 e5                	mov    %esp,%ebp
80100a45:	53                   	push   %ebx
80100a46:	83 ec 08             	sub    $0x8,%esp
80100a49:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int end = (cb->start + cb->count) % cb->size;
	memmove(&cb->data[end * cb->elemsize], elem, cb->elemsize);
80100a4c:	8b 4b 04             	mov    0x4(%ebx),%ecx
80100a4f:	51                   	push   %ecx
80100a50:	ff 75 0c             	pushl  0xc(%ebp)
80100a53:	8b 43 0c             	mov    0xc(%ebx),%eax
80100a56:	03 43 08             	add    0x8(%ebx),%eax
80100a59:	f7 33                	divl   (%ebx)
80100a5b:	0f af ca             	imul   %edx,%ecx
80100a5e:	8b 53 10             	mov    0x10(%ebx),%edx
80100a61:	01 ca                	add    %ecx,%edx
80100a63:	52                   	push   %edx
80100a64:	e8 27 3b 00 00       	call   80104590 <memmove>
	if (cb->count == cb->size) {
80100a69:	8b 4b 0c             	mov    0xc(%ebx),%ecx
80100a6c:	83 c4 10             	add    $0x10,%esp
80100a6f:	3b 0b                	cmp    (%ebx),%ecx
80100a71:	74 0d                	je     80100a80 <cbuffer_write+0x40>
		cb->start = (cb->start + 1) % cb->size; /* full, overwrite */
	} else {
		++cb->count;
80100a73:	83 c1 01             	add    $0x1,%ecx
80100a76:	89 4b 0c             	mov    %ecx,0xc(%ebx)
	}
}
80100a79:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100a7c:	c9                   	leave  
80100a7d:	c3                   	ret    
80100a7e:	66 90                	xchg   %ax,%ax
void cbuffer_write(struct cbuffer * cb, void * elem)
{
	int end = (cb->start + cb->count) % cb->size;
	memmove(&cb->data[end * cb->elemsize], elem, cb->elemsize);
	if (cb->count == cb->size) {
		cb->start = (cb->start + 1) % cb->size; /* full, overwrite */
80100a80:	8b 43 08             	mov    0x8(%ebx),%eax
80100a83:	31 d2                	xor    %edx,%edx
80100a85:	83 c0 01             	add    $0x1,%eax
80100a88:	f7 f1                	div    %ecx
80100a8a:	89 53 08             	mov    %edx,0x8(%ebx)
	} else {
		++cb->count;
	}
}
80100a8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100a90:	c9                   	leave  
80100a91:	c3                   	ret    
80100a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100aa0 <cbuffer_read>:


void cbuffer_read(struct cbuffer * cb, void * elem)
{
80100aa0:	55                   	push   %ebp
80100aa1:	89 e5                	mov    %esp,%ebp
80100aa3:	53                   	push   %ebx
80100aa4:	83 ec 08             	sub    $0x8,%esp
80100aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	memmove(elem, &cb->data[cb->start * cb->elemsize], cb->elemsize);
80100aaa:	8b 43 04             	mov    0x4(%ebx),%eax
80100aad:	50                   	push   %eax
80100aae:	0f af 43 08          	imul   0x8(%ebx),%eax
80100ab2:	03 43 10             	add    0x10(%ebx),%eax
80100ab5:	50                   	push   %eax
80100ab6:	ff 75 0c             	pushl  0xc(%ebp)
80100ab9:	e8 d2 3a 00 00       	call   80104590 <memmove>
	cb->start = (cb->start + 1) % cb->size;
80100abe:	8b 43 08             	mov    0x8(%ebx),%eax
80100ac1:	31 d2                	xor    %edx,%edx
	--cb->count;
80100ac3:	83 6b 0c 01          	subl   $0x1,0xc(%ebx)
}
80100ac7:	83 c4 10             	add    $0x10,%esp


void cbuffer_read(struct cbuffer * cb, void * elem)
{
	memmove(elem, &cb->data[cb->start * cb->elemsize], cb->elemsize);
	cb->start = (cb->start + 1) % cb->size;
80100aca:	83 c0 01             	add    $0x1,%eax
80100acd:	f7 33                	divl   (%ebx)
80100acf:	89 53 08             	mov    %edx,0x8(%ebx)
	--cb->count;
}
80100ad2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ad5:	c9                   	leave  
80100ad6:	c3                   	ret    
80100ad7:	66 90                	xchg   %ax,%ax
80100ad9:	66 90                	xchg   %ax,%ax
80100adb:	66 90                	xchg   %ax,%ax
80100add:	66 90                	xchg   %ax,%ax
80100adf:	90                   	nop

80100ae0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100ae0:	55                   	push   %ebp
80100ae1:	89 e5                	mov    %esp,%ebp
80100ae3:	57                   	push   %edi
80100ae4:	56                   	push   %esi
80100ae5:	53                   	push   %ebx
80100ae6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100aec:	e8 cf 21 00 00       	call   80102cc0 <begin_op>
  if((ip = namei(path)) == 0){
80100af1:	83 ec 0c             	sub    $0xc,%esp
80100af4:	ff 75 08             	pushl  0x8(%ebp)
80100af7:	e8 a4 14 00 00       	call   80101fa0 <namei>
80100afc:	83 c4 10             	add    $0x10,%esp
80100aff:	85 c0                	test   %eax,%eax
80100b01:	0f 84 a3 01 00 00    	je     80100caa <exec+0x1ca>
    end_op();
    return -1;
  }
  ilock(ip);
80100b07:	83 ec 0c             	sub    $0xc,%esp
80100b0a:	89 c3                	mov    %eax,%ebx
80100b0c:	50                   	push   %eax
80100b0d:	e8 fe 0b 00 00       	call   80101710 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b12:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b18:	6a 34                	push   $0x34
80100b1a:	6a 00                	push   $0x0
80100b1c:	50                   	push   %eax
80100b1d:	53                   	push   %ebx
80100b1e:	e8 0d 0f 00 00       	call   80101a30 <readi>
80100b23:	83 c4 20             	add    $0x20,%esp
80100b26:	83 f8 33             	cmp    $0x33,%eax
80100b29:	77 25                	ja     80100b50 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b2b:	83 ec 0c             	sub    $0xc,%esp
80100b2e:	53                   	push   %ebx
80100b2f:	e8 ac 0e 00 00       	call   801019e0 <iunlockput>
    end_op();
80100b34:	e8 f7 21 00 00       	call   80102d30 <end_op>
80100b39:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b41:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b44:	5b                   	pop    %ebx
80100b45:	5e                   	pop    %esi
80100b46:	5f                   	pop    %edi
80100b47:	5d                   	pop    %ebp
80100b48:	c3                   	ret    
80100b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b50:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b57:	45 4c 46 
80100b5a:	75 cf                	jne    80100b2b <exec+0x4b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b5c:	e8 ff 5d 00 00       	call   80106960 <setupkvm>
80100b61:	85 c0                	test   %eax,%eax
80100b63:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b69:	74 c0                	je     80100b2b <exec+0x4b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b6b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b72:	00 
80100b73:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b79:	0f 84 9c 02 00 00    	je     80100e1b <exec+0x33b>
80100b7f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b86:	00 00 00 
80100b89:	31 ff                	xor    %edi,%edi
80100b8b:	eb 18                	jmp    80100ba5 <exec+0xc5>
80100b8d:	8d 76 00             	lea    0x0(%esi),%esi
80100b90:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b97:	83 c7 01             	add    $0x1,%edi
80100b9a:	83 c6 20             	add    $0x20,%esi
80100b9d:	39 f8                	cmp    %edi,%eax
80100b9f:	0f 8e ab 00 00 00    	jle    80100c50 <exec+0x170>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ba5:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bab:	6a 20                	push   $0x20
80100bad:	56                   	push   %esi
80100bae:	50                   	push   %eax
80100baf:	53                   	push   %ebx
80100bb0:	e8 7b 0e 00 00       	call   80101a30 <readi>
80100bb5:	83 c4 10             	add    $0x10,%esp
80100bb8:	83 f8 20             	cmp    $0x20,%eax
80100bbb:	75 7b                	jne    80100c38 <exec+0x158>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bbd:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bc4:	75 ca                	jne    80100b90 <exec+0xb0>
      continue;
    if(ph.memsz < ph.filesz)
80100bc6:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bcc:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bd2:	72 64                	jb     80100c38 <exec+0x158>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100bd4:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100bda:	72 5c                	jb     80100c38 <exec+0x158>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bdc:	83 ec 04             	sub    $0x4,%esp
80100bdf:	50                   	push   %eax
80100be0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100be6:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bec:	e8 ff 5f 00 00       	call   80106bf0 <allocuvm>
80100bf1:	83 c4 10             	add    $0x10,%esp
80100bf4:	85 c0                	test   %eax,%eax
80100bf6:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100bfc:	74 3a                	je     80100c38 <exec+0x158>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100bfe:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c04:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c09:	75 2d                	jne    80100c38 <exec+0x158>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c0b:	83 ec 0c             	sub    $0xc,%esp
80100c0e:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100c14:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100c1a:	53                   	push   %ebx
80100c1b:	50                   	push   %eax
80100c1c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c22:	e8 09 5f 00 00       	call   80106b30 <loaduvm>
80100c27:	83 c4 20             	add    $0x20,%esp
80100c2a:	85 c0                	test   %eax,%eax
80100c2c:	0f 89 5e ff ff ff    	jns    80100b90 <exec+0xb0>
80100c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c38:	83 ec 0c             	sub    $0xc,%esp
80100c3b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c41:	e8 da 60 00 00       	call   80106d20 <freevm>
80100c46:	83 c4 10             	add    $0x10,%esp
80100c49:	e9 dd fe ff ff       	jmp    80100b2b <exec+0x4b>
80100c4e:	66 90                	xchg   %ax,%ax
80100c50:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c56:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100c5c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80100c62:	8d be 00 20 00 00    	lea    0x2000(%esi),%edi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c68:	83 ec 0c             	sub    $0xc,%esp
80100c6b:	53                   	push   %ebx
80100c6c:	e8 6f 0d 00 00       	call   801019e0 <iunlockput>
  end_op();
80100c71:	e8 ba 20 00 00       	call   80102d30 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c76:	83 c4 0c             	add    $0xc,%esp
80100c79:	57                   	push   %edi
80100c7a:	56                   	push   %esi
80100c7b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c81:	e8 6a 5f 00 00       	call   80106bf0 <allocuvm>
80100c86:	83 c4 10             	add    $0x10,%esp
80100c89:	85 c0                	test   %eax,%eax
80100c8b:	89 c6                	mov    %eax,%esi
80100c8d:	75 2a                	jne    80100cb9 <exec+0x1d9>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c8f:	83 ec 0c             	sub    $0xc,%esp
80100c92:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c98:	e8 83 60 00 00       	call   80106d20 <freevm>
80100c9d:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ca5:	e9 97 fe ff ff       	jmp    80100b41 <exec+0x61>
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
  if((ip = namei(path)) == 0){
    end_op();
80100caa:	e8 81 20 00 00       	call   80102d30 <end_op>
    return -1;
80100caf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cb4:	e9 88 fe ff ff       	jmp    80100b41 <exec+0x61>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cb9:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100cbf:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cc2:	31 ff                	xor    %edi,%edi
80100cc4:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cc6:	50                   	push   %eax
80100cc7:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ccd:	e8 ce 60 00 00       	call   80106da0 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cd5:	83 c4 10             	add    $0x10,%esp
80100cd8:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100cde:	8b 00                	mov    (%eax),%eax
80100ce0:	85 c0                	test   %eax,%eax
80100ce2:	74 71                	je     80100d55 <exec+0x275>
80100ce4:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100cea:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100cf0:	eb 0b                	jmp    80100cfd <exec+0x21d>
80100cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(argc >= MAXARG)
80100cf8:	83 ff 20             	cmp    $0x20,%edi
80100cfb:	74 92                	je     80100c8f <exec+0x1af>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cfd:	83 ec 0c             	sub    $0xc,%esp
80100d00:	50                   	push   %eax
80100d01:	e8 1a 3a 00 00       	call   80104720 <strlen>
80100d06:	f7 d0                	not    %eax
80100d08:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d0a:	58                   	pop    %eax
80100d0b:	8b 45 0c             	mov    0xc(%ebp),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d0e:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d11:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d14:	e8 07 3a 00 00       	call   80104720 <strlen>
80100d19:	83 c0 01             	add    $0x1,%eax
80100d1c:	50                   	push   %eax
80100d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d20:	ff 34 b8             	pushl  (%eax,%edi,4)
80100d23:	53                   	push   %ebx
80100d24:	56                   	push   %esi
80100d25:	e8 d6 61 00 00       	call   80106f00 <copyout>
80100d2a:	83 c4 20             	add    $0x20,%esp
80100d2d:	85 c0                	test   %eax,%eax
80100d2f:	0f 88 5a ff ff ff    	js     80100c8f <exec+0x1af>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d35:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100d38:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d3f:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100d42:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d48:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100d4b:	85 c0                	test   %eax,%eax
80100d4d:	75 a9                	jne    80100cf8 <exec+0x218>
80100d4f:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d55:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d5c:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100d5e:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d65:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100d69:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d70:	ff ff ff 
  ustack[1] = argc;
80100d73:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d79:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100d7b:	83 c0 0c             	add    $0xc,%eax
80100d7e:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d80:	50                   	push   %eax
80100d81:	52                   	push   %edx
80100d82:	53                   	push   %ebx
80100d83:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d89:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d8f:	e8 6c 61 00 00       	call   80106f00 <copyout>
80100d94:	83 c4 10             	add    $0x10,%esp
80100d97:	85 c0                	test   %eax,%eax
80100d99:	0f 88 f0 fe ff ff    	js     80100c8f <exec+0x1af>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d9f:	8b 45 08             	mov    0x8(%ebp),%eax
80100da2:	0f b6 10             	movzbl (%eax),%edx
80100da5:	84 d2                	test   %dl,%dl
80100da7:	74 1a                	je     80100dc3 <exec+0x2e3>
80100da9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100dac:	83 c0 01             	add    $0x1,%eax
80100daf:	90                   	nop
    if(*s == '/')
      last = s+1;
80100db0:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100db3:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100db6:	0f 44 c8             	cmove  %eax,%ecx
80100db9:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100dbc:	84 d2                	test   %dl,%dl
80100dbe:	75 f0                	jne    80100db0 <exec+0x2d0>
80100dc0:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100dc3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100dc9:	83 ec 04             	sub    $0x4,%esp
80100dcc:	6a 10                	push   $0x10
80100dce:	ff 75 08             	pushl  0x8(%ebp)
80100dd1:	83 c0 70             	add    $0x70,%eax
80100dd4:	50                   	push   %eax
80100dd5:	e8 06 39 00 00       	call   801046e0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100dda:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  proc->pgdir = pgdir;
80100de0:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100de6:	8b 78 08             	mov    0x8(%eax),%edi
  proc->pgdir = pgdir;
  proc->sz = sz;
80100de9:	89 70 04             	mov    %esi,0x4(%eax)
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));

  // Commit to the user image.
  oldpgdir = proc->pgdir;
  proc->pgdir = pgdir;
80100dec:	89 48 08             	mov    %ecx,0x8(%eax)
  proc->sz = sz;
  proc->tf->eip = elf.entry;  // main
80100def:	8b 50 1c             	mov    0x1c(%eax),%edx
80100df2:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
80100df8:	89 4a 38             	mov    %ecx,0x38(%edx)
  proc->tf->esp = sp;
80100dfb:	8b 50 1c             	mov    0x1c(%eax),%edx
80100dfe:	89 5a 44             	mov    %ebx,0x44(%edx)
  switchuvm(proc);
80100e01:	89 04 24             	mov    %eax,(%esp)
80100e04:	e8 07 5c 00 00       	call   80106a10 <switchuvm>
  freevm(oldpgdir);
80100e09:	89 3c 24             	mov    %edi,(%esp)
80100e0c:	e8 0f 5f 00 00       	call   80106d20 <freevm>
  return 0;
80100e11:	83 c4 10             	add    $0x10,%esp
80100e14:	31 c0                	xor    %eax,%eax
80100e16:	e9 26 fd ff ff       	jmp    80100b41 <exec+0x61>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e1b:	bf 00 20 00 00       	mov    $0x2000,%edi
80100e20:	31 f6                	xor    %esi,%esi
80100e22:	e9 41 fe ff ff       	jmp    80100c68 <exec+0x188>
80100e27:	66 90                	xchg   %ax,%ax
80100e29:	66 90                	xchg   %ax,%ax
80100e2b:	66 90                	xchg   %ax,%ax
80100e2d:	66 90                	xchg   %ax,%ax
80100e2f:	90                   	nop

80100e30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e36:	68 25 70 10 80       	push   $0x80107025
80100e3b:	68 a0 f7 10 80       	push   $0x8010f7a0
80100e40:	e8 4b 34 00 00       	call   80104290 <initlock>
}
80100e45:	83 c4 10             	add    $0x10,%esp
80100e48:	c9                   	leave  
80100e49:	c3                   	ret    
80100e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e50:	55                   	push   %ebp
80100e51:	89 e5                	mov    %esp,%ebp
80100e53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e54:	bb d4 f7 10 80       	mov    $0x8010f7d4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e59:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100e5c:	68 a0 f7 10 80       	push   $0x8010f7a0
80100e61:	e8 4a 34 00 00       	call   801042b0 <acquire>
80100e66:	83 c4 10             	add    $0x10,%esp
80100e69:	eb 10                	jmp    80100e7b <filealloc+0x2b>
80100e6b:	90                   	nop
80100e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e70:	83 c3 18             	add    $0x18,%ebx
80100e73:	81 fb 34 01 11 80    	cmp    $0x80110134,%ebx
80100e79:	74 25                	je     80100ea0 <filealloc+0x50>
    if(f->ref == 0){
80100e7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e7e:	85 c0                	test   %eax,%eax
80100e80:	75 ee                	jne    80100e70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e82:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100e85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e8c:	68 a0 f7 10 80       	push   $0x8010f7a0
80100e91:	e8 fa 35 00 00       	call   80104490 <release>
      return f;
80100e96:	89 d8                	mov    %ebx,%eax
80100e98:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9e:	c9                   	leave  
80100e9f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100ea0:	83 ec 0c             	sub    $0xc,%esp
80100ea3:	68 a0 f7 10 80       	push   $0x8010f7a0
80100ea8:	e8 e3 35 00 00       	call   80104490 <release>
  return 0;
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	31 c0                	xor    %eax,%eax
}
80100eb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb5:	c9                   	leave  
80100eb6:	c3                   	ret    
80100eb7:	89 f6                	mov    %esi,%esi
80100eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ec0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 10             	sub    $0x10,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eca:	68 a0 f7 10 80       	push   $0x8010f7a0
80100ecf:	e8 dc 33 00 00       	call   801042b0 <acquire>
  if(f->ref < 1)
80100ed4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed7:	83 c4 10             	add    $0x10,%esp
80100eda:	85 c0                	test   %eax,%eax
80100edc:	7e 1a                	jle    80100ef8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ede:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ee1:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100ee4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ee7:	68 a0 f7 10 80       	push   $0x8010f7a0
80100eec:	e8 9f 35 00 00       	call   80104490 <release>
  return f;
}
80100ef1:	89 d8                	mov    %ebx,%eax
80100ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef6:	c9                   	leave  
80100ef7:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100ef8:	83 ec 0c             	sub    $0xc,%esp
80100efb:	68 2c 70 10 80       	push   $0x8010702c
80100f00:	e8 4b f4 ff ff       	call   80100350 <panic>
80100f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f10 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 28             	sub    $0x28,%esp
80100f19:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100f1c:	68 a0 f7 10 80       	push   $0x8010f7a0
80100f21:	e8 8a 33 00 00       	call   801042b0 <acquire>
  if(f->ref < 1)
80100f26:	8b 47 04             	mov    0x4(%edi),%eax
80100f29:	83 c4 10             	add    $0x10,%esp
80100f2c:	85 c0                	test   %eax,%eax
80100f2e:	0f 8e 9b 00 00 00    	jle    80100fcf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f34:	83 e8 01             	sub    $0x1,%eax
80100f37:	85 c0                	test   %eax,%eax
80100f39:	89 47 04             	mov    %eax,0x4(%edi)
80100f3c:	74 1a                	je     80100f58 <fileclose+0x48>
    release(&ftable.lock);
80100f3e:	c7 45 08 a0 f7 10 80 	movl   $0x8010f7a0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f48:	5b                   	pop    %ebx
80100f49:	5e                   	pop    %esi
80100f4a:	5f                   	pop    %edi
80100f4b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100f4c:	e9 3f 35 00 00       	jmp    80104490 <release>
80100f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100f58:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100f5c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f5e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f61:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100f64:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f6a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f6d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f70:	68 a0 f7 10 80       	push   $0x8010f7a0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f75:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f78:	e8 13 35 00 00       	call   80104490 <release>

  if(ff.type == FD_PIPE)
80100f7d:	83 c4 10             	add    $0x10,%esp
80100f80:	83 fb 01             	cmp    $0x1,%ebx
80100f83:	74 13                	je     80100f98 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f85:	83 fb 02             	cmp    $0x2,%ebx
80100f88:	74 26                	je     80100fb0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8d:	5b                   	pop    %ebx
80100f8e:	5e                   	pop    %esi
80100f8f:	5f                   	pop    %edi
80100f90:	5d                   	pop    %ebp
80100f91:	c3                   	ret    
80100f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100f98:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f9c:	83 ec 08             	sub    $0x8,%esp
80100f9f:	53                   	push   %ebx
80100fa0:	56                   	push   %esi
80100fa1:	e8 ba 25 00 00       	call   80103560 <pipeclose>
80100fa6:	83 c4 10             	add    $0x10,%esp
80100fa9:	eb df                	jmp    80100f8a <fileclose+0x7a>
80100fab:	90                   	nop
80100fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100fb0:	e8 0b 1d 00 00       	call   80102cc0 <begin_op>
    iput(ff.ip);
80100fb5:	83 ec 0c             	sub    $0xc,%esp
80100fb8:	ff 75 e0             	pushl  -0x20(%ebp)
80100fbb:	e8 c0 08 00 00       	call   80101880 <iput>
    end_op();
80100fc0:	83 c4 10             	add    $0x10,%esp
  }
}
80100fc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc6:	5b                   	pop    %ebx
80100fc7:	5e                   	pop    %esi
80100fc8:	5f                   	pop    %edi
80100fc9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100fca:	e9 61 1d 00 00       	jmp    80102d30 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 34 70 10 80       	push   $0x80107034
80100fd7:	e8 74 f3 ff ff       	call   80100350 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	53                   	push   %ebx
80100fe4:	83 ec 04             	sub    $0x4,%esp
80100fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fea:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fed:	75 31                	jne    80101020 <filestat+0x40>
    ilock(f->ip);
80100fef:	83 ec 0c             	sub    $0xc,%esp
80100ff2:	ff 73 10             	pushl  0x10(%ebx)
80100ff5:	e8 16 07 00 00       	call   80101710 <ilock>
    stati(f->ip, st);
80100ffa:	58                   	pop    %eax
80100ffb:	5a                   	pop    %edx
80100ffc:	ff 75 0c             	pushl  0xc(%ebp)
80100fff:	ff 73 10             	pushl  0x10(%ebx)
80101002:	e8 f9 09 00 00       	call   80101a00 <stati>
    iunlock(f->ip);
80101007:	59                   	pop    %ecx
80101008:	ff 73 10             	pushl  0x10(%ebx)
8010100b:	e8 10 08 00 00       	call   80101820 <iunlock>
    return 0;
80101010:	83 c4 10             	add    $0x10,%esp
80101013:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101015:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80101020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101028:	c9                   	leave  
80101029:	c3                   	ret    
8010102a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101030 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101030:	55                   	push   %ebp
80101031:	89 e5                	mov    %esp,%ebp
80101033:	57                   	push   %edi
80101034:	56                   	push   %esi
80101035:	53                   	push   %ebx
80101036:	83 ec 0c             	sub    $0xc,%esp
80101039:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010103c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010103f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101042:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101046:	74 60                	je     801010a8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101048:	8b 03                	mov    (%ebx),%eax
8010104a:	83 f8 01             	cmp    $0x1,%eax
8010104d:	74 41                	je     80101090 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010104f:	83 f8 02             	cmp    $0x2,%eax
80101052:	75 5b                	jne    801010af <fileread+0x7f>
    ilock(f->ip);
80101054:	83 ec 0c             	sub    $0xc,%esp
80101057:	ff 73 10             	pushl  0x10(%ebx)
8010105a:	e8 b1 06 00 00       	call   80101710 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010105f:	57                   	push   %edi
80101060:	ff 73 14             	pushl  0x14(%ebx)
80101063:	56                   	push   %esi
80101064:	ff 73 10             	pushl  0x10(%ebx)
80101067:	e8 c4 09 00 00       	call   80101a30 <readi>
8010106c:	83 c4 20             	add    $0x20,%esp
8010106f:	85 c0                	test   %eax,%eax
80101071:	89 c6                	mov    %eax,%esi
80101073:	7e 03                	jle    80101078 <fileread+0x48>
      f->off += r;
80101075:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101078:	83 ec 0c             	sub    $0xc,%esp
8010107b:	ff 73 10             	pushl  0x10(%ebx)
8010107e:	e8 9d 07 00 00       	call   80101820 <iunlock>
    return r;
80101083:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101086:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101088:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010108b:	5b                   	pop    %ebx
8010108c:	5e                   	pop    %esi
8010108d:	5f                   	pop    %edi
8010108e:	5d                   	pop    %ebp
8010108f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80101090:	8b 43 0c             	mov    0xc(%ebx),%eax
80101093:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101096:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101099:	5b                   	pop    %ebx
8010109a:	5e                   	pop    %esi
8010109b:	5f                   	pop    %edi
8010109c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
8010109d:	e9 8e 26 00 00       	jmp    80103730 <piperead>
801010a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
801010a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010ad:	eb d9                	jmp    80101088 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
801010af:	83 ec 0c             	sub    $0xc,%esp
801010b2:	68 3e 70 10 80       	push   $0x8010703e
801010b7:	e8 94 f2 ff ff       	call   80100350 <panic>
801010bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010c0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	57                   	push   %edi
801010c4:	56                   	push   %esi
801010c5:	53                   	push   %ebx
801010c6:	83 ec 1c             	sub    $0x1c,%esp
801010c9:	8b 75 08             	mov    0x8(%ebp),%esi
801010cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801010cf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010d6:	8b 45 10             	mov    0x10(%ebp),%eax
801010d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
801010dc:	0f 84 aa 00 00 00    	je     8010118c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801010e2:	8b 06                	mov    (%esi),%eax
801010e4:	83 f8 01             	cmp    $0x1,%eax
801010e7:	0f 84 c2 00 00 00    	je     801011af <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ed:	83 f8 02             	cmp    $0x2,%eax
801010f0:	0f 85 d8 00 00 00    	jne    801011ce <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010f9:	31 ff                	xor    %edi,%edi
801010fb:	85 c0                	test   %eax,%eax
801010fd:	7f 34                	jg     80101133 <filewrite+0x73>
801010ff:	e9 9c 00 00 00       	jmp    801011a0 <filewrite+0xe0>
80101104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101108:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010110b:	83 ec 0c             	sub    $0xc,%esp
8010110e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101111:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101114:	e8 07 07 00 00       	call   80101820 <iunlock>
      end_op();
80101119:	e8 12 1c 00 00       	call   80102d30 <end_op>
8010111e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101121:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101124:	39 d8                	cmp    %ebx,%eax
80101126:	0f 85 95 00 00 00    	jne    801011c1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010112c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010112e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101131:	7e 6d                	jle    801011a0 <filewrite+0xe0>
      int n1 = n - i;
80101133:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101136:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010113b:	29 fb                	sub    %edi,%ebx
8010113d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101143:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101146:	e8 75 1b 00 00       	call   80102cc0 <begin_op>
      ilock(f->ip);
8010114b:	83 ec 0c             	sub    $0xc,%esp
8010114e:	ff 76 10             	pushl  0x10(%esi)
80101151:	e8 ba 05 00 00       	call   80101710 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101156:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101159:	53                   	push   %ebx
8010115a:	ff 76 14             	pushl  0x14(%esi)
8010115d:	01 f8                	add    %edi,%eax
8010115f:	50                   	push   %eax
80101160:	ff 76 10             	pushl  0x10(%esi)
80101163:	e8 c8 09 00 00       	call   80101b30 <writei>
80101168:	83 c4 20             	add    $0x20,%esp
8010116b:	85 c0                	test   %eax,%eax
8010116d:	7f 99                	jg     80101108 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010116f:	83 ec 0c             	sub    $0xc,%esp
80101172:	ff 76 10             	pushl  0x10(%esi)
80101175:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101178:	e8 a3 06 00 00       	call   80101820 <iunlock>
      end_op();
8010117d:	e8 ae 1b 00 00       	call   80102d30 <end_op>

      if(r < 0)
80101182:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101185:	83 c4 10             	add    $0x10,%esp
80101188:	85 c0                	test   %eax,%eax
8010118a:	74 98                	je     80101124 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010118c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010118f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101194:	5b                   	pop    %ebx
80101195:	5e                   	pop    %esi
80101196:	5f                   	pop    %edi
80101197:	5d                   	pop    %ebp
80101198:	c3                   	ret    
80101199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801011a0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801011a3:	75 e7                	jne    8010118c <filewrite+0xcc>
  }
  panic("filewrite");
}
801011a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a8:	89 f8                	mov    %edi,%eax
801011aa:	5b                   	pop    %ebx
801011ab:	5e                   	pop    %esi
801011ac:	5f                   	pop    %edi
801011ad:	5d                   	pop    %ebp
801011ae:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801011af:	8b 46 0c             	mov    0xc(%esi),%eax
801011b2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801011b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011b8:	5b                   	pop    %ebx
801011b9:	5e                   	pop    %esi
801011ba:	5f                   	pop    %edi
801011bb:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801011bc:	e9 3f 24 00 00       	jmp    80103600 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801011c1:	83 ec 0c             	sub    $0xc,%esp
801011c4:	68 47 70 10 80       	push   $0x80107047
801011c9:	e8 82 f1 ff ff       	call   80100350 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801011ce:	83 ec 0c             	sub    $0xc,%esp
801011d1:	68 4d 70 10 80       	push   $0x8010704d
801011d6:	e8 75 f1 ff ff       	call   80100350 <panic>
801011db:	66 90                	xchg   %ax,%ax
801011dd:	66 90                	xchg   %ax,%ax
801011df:	90                   	nop

801011e0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011e9:	8b 0d a0 01 11 80    	mov    0x801101a0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011ef:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011f2:	85 c9                	test   %ecx,%ecx
801011f4:	0f 84 85 00 00 00    	je     8010127f <balloc+0x9f>
801011fa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101201:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101204:	83 ec 08             	sub    $0x8,%esp
80101207:	89 f0                	mov    %esi,%eax
80101209:	c1 f8 0c             	sar    $0xc,%eax
8010120c:	03 05 b8 01 11 80    	add    0x801101b8,%eax
80101212:	50                   	push   %eax
80101213:	ff 75 d8             	pushl  -0x28(%ebp)
80101216:	e8 a5 ee ff ff       	call   801000c0 <bread>
8010121b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010121e:	a1 a0 01 11 80       	mov    0x801101a0,%eax
80101223:	83 c4 10             	add    $0x10,%esp
80101226:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101229:	31 c0                	xor    %eax,%eax
8010122b:	eb 2d                	jmp    8010125a <balloc+0x7a>
8010122d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101230:	89 c1                	mov    %eax,%ecx
80101232:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101237:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010123a:	83 e1 07             	and    $0x7,%ecx
8010123d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010123f:	89 c1                	mov    %eax,%ecx
80101241:	c1 f9 03             	sar    $0x3,%ecx
80101244:	0f b6 7c 0b 18       	movzbl 0x18(%ebx,%ecx,1),%edi
80101249:	85 d7                	test   %edx,%edi
8010124b:	74 43                	je     80101290 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010124d:	83 c0 01             	add    $0x1,%eax
80101250:	83 c6 01             	add    $0x1,%esi
80101253:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101258:	74 05                	je     8010125f <balloc+0x7f>
8010125a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010125d:	72 d1                	jb     80101230 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010125f:	83 ec 0c             	sub    $0xc,%esp
80101262:	ff 75 e4             	pushl  -0x1c(%ebp)
80101265:	e8 66 ef ff ff       	call   801001d0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010126a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101271:	83 c4 10             	add    $0x10,%esp
80101274:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101277:	39 05 a0 01 11 80    	cmp    %eax,0x801101a0
8010127d:	77 82                	ja     80101201 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010127f:	83 ec 0c             	sub    $0xc,%esp
80101282:	68 57 70 10 80       	push   $0x80107057
80101287:	e8 c4 f0 ff ff       	call   80100350 <panic>
8010128c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101290:	09 fa                	or     %edi,%edx
80101292:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101295:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101298:	88 54 0f 18          	mov    %dl,0x18(%edi,%ecx,1)
        log_write(bp);
8010129c:	57                   	push   %edi
8010129d:	e8 fe 1b 00 00       	call   80102ea0 <log_write>
        brelse(bp);
801012a2:	89 3c 24             	mov    %edi,(%esp)
801012a5:	e8 26 ef ff ff       	call   801001d0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801012aa:	58                   	pop    %eax
801012ab:	5a                   	pop    %edx
801012ac:	56                   	push   %esi
801012ad:	ff 75 d8             	pushl  -0x28(%ebp)
801012b0:	e8 0b ee ff ff       	call   801000c0 <bread>
801012b5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012b7:	8d 40 18             	lea    0x18(%eax),%eax
801012ba:	83 c4 0c             	add    $0xc,%esp
801012bd:	68 00 02 00 00       	push   $0x200
801012c2:	6a 00                	push   $0x0
801012c4:	50                   	push   %eax
801012c5:	e8 16 32 00 00       	call   801044e0 <memset>
  log_write(bp);
801012ca:	89 1c 24             	mov    %ebx,(%esp)
801012cd:	e8 ce 1b 00 00       	call   80102ea0 <log_write>
  brelse(bp);
801012d2:	89 1c 24             	mov    %ebx,(%esp)
801012d5:	e8 f6 ee ff ff       	call   801001d0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801012da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012dd:	89 f0                	mov    %esi,%eax
801012df:	5b                   	pop    %ebx
801012e0:	5e                   	pop    %esi
801012e1:	5f                   	pop    %edi
801012e2:	5d                   	pop    %ebp
801012e3:	c3                   	ret    
801012e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012f0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012f8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fa:	bb f4 01 11 80       	mov    $0x801101f4,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012ff:	83 ec 28             	sub    $0x28,%esp
80101302:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101305:	68 c0 01 11 80       	push   $0x801101c0
8010130a:	e8 a1 2f 00 00       	call   801042b0 <acquire>
8010130f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101312:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101315:	eb 18                	jmp    8010132f <iget+0x3f>
80101317:	89 f6                	mov    %esi,%esi
80101319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101320:	85 f6                	test   %esi,%esi
80101322:	74 44                	je     80101368 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101324:	83 c3 50             	add    $0x50,%ebx
80101327:	81 fb 94 11 11 80    	cmp    $0x80111194,%ebx
8010132d:	74 51                	je     80101380 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010132f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101332:	85 c9                	test   %ecx,%ecx
80101334:	7e ea                	jle    80101320 <iget+0x30>
80101336:	39 3b                	cmp    %edi,(%ebx)
80101338:	75 e6                	jne    80101320 <iget+0x30>
8010133a:	39 53 04             	cmp    %edx,0x4(%ebx)
8010133d:	75 e1                	jne    80101320 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
8010133f:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101342:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101345:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
80101347:	68 c0 01 11 80       	push   $0x801101c0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010134c:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010134f:	e8 3c 31 00 00       	call   80104490 <release>
      return ip;
80101354:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);

  return ip;
}
80101357:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135a:	89 f0                	mov    %esi,%eax
8010135c:	5b                   	pop    %ebx
8010135d:	5e                   	pop    %esi
8010135e:	5f                   	pop    %edi
8010135f:	5d                   	pop    %ebp
80101360:	c3                   	ret    
80101361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101368:	85 c9                	test   %ecx,%ecx
8010136a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136d:	83 c3 50             	add    $0x50,%ebx
80101370:	81 fb 94 11 11 80    	cmp    $0x80111194,%ebx
80101376:	75 b7                	jne    8010132f <iget+0x3f>
80101378:	90                   	nop
80101379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101380:	85 f6                	test   %esi,%esi
80101382:	74 2d                	je     801013b1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->flags = 0;
  release(&icache.lock);
80101384:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101387:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101389:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010138c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->flags = 0;
80101393:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
  release(&icache.lock);
8010139a:	68 c0 01 11 80       	push   $0x801101c0
8010139f:	e8 ec 30 00 00       	call   80104490 <release>

  return ip;
801013a4:	83 c4 10             	add    $0x10,%esp
}
801013a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013aa:	89 f0                	mov    %esi,%eax
801013ac:	5b                   	pop    %ebx
801013ad:	5e                   	pop    %esi
801013ae:	5f                   	pop    %edi
801013af:	5d                   	pop    %ebp
801013b0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801013b1:	83 ec 0c             	sub    $0xc,%esp
801013b4:	68 6d 70 10 80       	push   $0x8010706d
801013b9:	e8 92 ef ff ff       	call   80100350 <panic>
801013be:	66 90                	xchg   %ax,%ax

801013c0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	57                   	push   %edi
801013c4:	56                   	push   %esi
801013c5:	53                   	push   %ebx
801013c6:	89 c6                	mov    %eax,%esi
801013c8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013cb:	83 fa 0b             	cmp    $0xb,%edx
801013ce:	77 18                	ja     801013e8 <bmap+0x28>
801013d0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801013d3:	8b 43 1c             	mov    0x1c(%ebx),%eax
801013d6:	85 c0                	test   %eax,%eax
801013d8:	74 6e                	je     80101448 <bmap+0x88>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013dd:	5b                   	pop    %ebx
801013de:	5e                   	pop    %esi
801013df:	5f                   	pop    %edi
801013e0:	5d                   	pop    %ebp
801013e1:	c3                   	ret    
801013e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801013e8:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801013eb:	83 fb 7f             	cmp    $0x7f,%ebx
801013ee:	77 7c                	ja     8010146c <bmap+0xac>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013f0:	8b 40 4c             	mov    0x4c(%eax),%eax
801013f3:	85 c0                	test   %eax,%eax
801013f5:	74 69                	je     80101460 <bmap+0xa0>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013f7:	83 ec 08             	sub    $0x8,%esp
801013fa:	50                   	push   %eax
801013fb:	ff 36                	pushl  (%esi)
801013fd:	e8 be ec ff ff       	call   801000c0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101402:	8d 54 98 18          	lea    0x18(%eax,%ebx,4),%edx
80101406:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101409:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010140b:	8b 1a                	mov    (%edx),%ebx
8010140d:	85 db                	test   %ebx,%ebx
8010140f:	75 1d                	jne    8010142e <bmap+0x6e>
      a[bn] = addr = balloc(ip->dev);
80101411:	8b 06                	mov    (%esi),%eax
80101413:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101416:	e8 c5 fd ff ff       	call   801011e0 <balloc>
8010141b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010141e:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101421:	89 c3                	mov    %eax,%ebx
80101423:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101425:	57                   	push   %edi
80101426:	e8 75 1a 00 00       	call   80102ea0 <log_write>
8010142b:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
8010142e:	83 ec 0c             	sub    $0xc,%esp
80101431:	57                   	push   %edi
80101432:	e8 99 ed ff ff       	call   801001d0 <brelse>
80101437:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
8010143a:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
8010143d:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010143f:	5b                   	pop    %ebx
80101440:	5e                   	pop    %esi
80101441:	5f                   	pop    %edi
80101442:	5d                   	pop    %ebp
80101443:	c3                   	ret    
80101444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101448:	8b 06                	mov    (%esi),%eax
8010144a:	e8 91 fd ff ff       	call   801011e0 <balloc>
8010144f:	89 43 1c             	mov    %eax,0x1c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
80101452:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101455:	5b                   	pop    %ebx
80101456:	5e                   	pop    %esi
80101457:	5f                   	pop    %edi
80101458:	5d                   	pop    %ebp
80101459:	c3                   	ret    
8010145a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101460:	8b 06                	mov    (%esi),%eax
80101462:	e8 79 fd ff ff       	call   801011e0 <balloc>
80101467:	89 46 4c             	mov    %eax,0x4c(%esi)
8010146a:	eb 8b                	jmp    801013f7 <bmap+0x37>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
8010146c:	83 ec 0c             	sub    $0xc,%esp
8010146f:	68 7d 70 10 80       	push   $0x8010707d
80101474:	e8 d7 ee ff ff       	call   80100350 <panic>
80101479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101480 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	56                   	push   %esi
80101484:	53                   	push   %ebx
80101485:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101488:	83 ec 08             	sub    $0x8,%esp
8010148b:	6a 01                	push   $0x1
8010148d:	ff 75 08             	pushl  0x8(%ebp)
80101490:	e8 2b ec ff ff       	call   801000c0 <bread>
80101495:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101497:	8d 40 18             	lea    0x18(%eax),%eax
8010149a:	83 c4 0c             	add    $0xc,%esp
8010149d:	6a 1c                	push   $0x1c
8010149f:	50                   	push   %eax
801014a0:	56                   	push   %esi
801014a1:	e8 ea 30 00 00       	call   80104590 <memmove>
  brelse(bp);
801014a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014a9:	83 c4 10             	add    $0x10,%esp
}
801014ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014af:	5b                   	pop    %ebx
801014b0:	5e                   	pop    %esi
801014b1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801014b2:	e9 19 ed ff ff       	jmp    801001d0 <brelse>
801014b7:	89 f6                	mov    %esi,%esi
801014b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	56                   	push   %esi
801014c4:	53                   	push   %ebx
801014c5:	89 d3                	mov    %edx,%ebx
801014c7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801014c9:	83 ec 08             	sub    $0x8,%esp
801014cc:	68 a0 01 11 80       	push   $0x801101a0
801014d1:	50                   	push   %eax
801014d2:	e8 a9 ff ff ff       	call   80101480 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014d7:	58                   	pop    %eax
801014d8:	5a                   	pop    %edx
801014d9:	89 da                	mov    %ebx,%edx
801014db:	c1 ea 0c             	shr    $0xc,%edx
801014de:	03 15 b8 01 11 80    	add    0x801101b8,%edx
801014e4:	52                   	push   %edx
801014e5:	56                   	push   %esi
801014e6:	e8 d5 eb ff ff       	call   801000c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801014eb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014ed:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801014f3:	ba 01 00 00 00       	mov    $0x1,%edx
801014f8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014fb:	c1 fb 03             	sar    $0x3,%ebx
801014fe:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101501:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101503:	0f b6 4c 18 18       	movzbl 0x18(%eax,%ebx,1),%ecx
80101508:	85 d1                	test   %edx,%ecx
8010150a:	74 27                	je     80101533 <bfree+0x73>
8010150c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010150e:	f7 d2                	not    %edx
80101510:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101512:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101515:	21 d0                	and    %edx,%eax
80101517:	88 44 1e 18          	mov    %al,0x18(%esi,%ebx,1)
  log_write(bp);
8010151b:	56                   	push   %esi
8010151c:	e8 7f 19 00 00       	call   80102ea0 <log_write>
  brelse(bp);
80101521:	89 34 24             	mov    %esi,(%esp)
80101524:	e8 a7 ec ff ff       	call   801001d0 <brelse>
}
80101529:	83 c4 10             	add    $0x10,%esp
8010152c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010152f:	5b                   	pop    %ebx
80101530:	5e                   	pop    %esi
80101531:	5d                   	pop    %ebp
80101532:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101533:	83 ec 0c             	sub    $0xc,%esp
80101536:	68 90 70 10 80       	push   $0x80107090
8010153b:	e8 10 ee ff ff       	call   80100350 <panic>

80101540 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	83 ec 10             	sub    $0x10,%esp
  initlock(&icache.lock, "icache");
80101546:	68 a3 70 10 80       	push   $0x801070a3
8010154b:	68 c0 01 11 80       	push   $0x801101c0
80101550:	e8 3b 2d 00 00       	call   80104290 <initlock>
  readsb(dev, &sb);
80101555:	58                   	pop    %eax
80101556:	5a                   	pop    %edx
80101557:	68 a0 01 11 80       	push   $0x801101a0
8010155c:	ff 75 08             	pushl  0x8(%ebp)
8010155f:	e8 1c ff ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101564:	ff 35 b8 01 11 80    	pushl  0x801101b8
8010156a:	ff 35 b4 01 11 80    	pushl  0x801101b4
80101570:	ff 35 b0 01 11 80    	pushl  0x801101b0
80101576:	ff 35 ac 01 11 80    	pushl  0x801101ac
8010157c:	ff 35 a8 01 11 80    	pushl  0x801101a8
80101582:	ff 35 a4 01 11 80    	pushl  0x801101a4
80101588:	ff 35 a0 01 11 80    	pushl  0x801101a0
8010158e:	68 04 71 10 80       	push   $0x80107104
80101593:	e8 a8 f0 ff ff       	call   80100640 <cprintf>
          inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
80101598:	83 c4 30             	add    $0x30,%esp
8010159b:	c9                   	leave  
8010159c:	c3                   	ret    
8010159d:	8d 76 00             	lea    0x0(%esi),%esi

801015a0 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	57                   	push   %edi
801015a4:	56                   	push   %esi
801015a5:	53                   	push   %ebx
801015a6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015a9:	83 3d a8 01 11 80 01 	cmpl   $0x1,0x801101a8
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801015b3:	8b 75 08             	mov    0x8(%ebp),%esi
801015b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015b9:	0f 86 91 00 00 00    	jbe    80101650 <ialloc+0xb0>
801015bf:	bb 01 00 00 00       	mov    $0x1,%ebx
801015c4:	eb 21                	jmp    801015e7 <ialloc+0x47>
801015c6:	8d 76 00             	lea    0x0(%esi),%esi
801015c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801015d0:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015d3:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801015d6:	57                   	push   %edi
801015d7:	e8 f4 eb ff ff       	call   801001d0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015dc:	83 c4 10             	add    $0x10,%esp
801015df:	39 1d a8 01 11 80    	cmp    %ebx,0x801101a8
801015e5:	76 69                	jbe    80101650 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015e7:	89 d8                	mov    %ebx,%eax
801015e9:	83 ec 08             	sub    $0x8,%esp
801015ec:	c1 e8 03             	shr    $0x3,%eax
801015ef:	03 05 b4 01 11 80    	add    0x801101b4,%eax
801015f5:	50                   	push   %eax
801015f6:	56                   	push   %esi
801015f7:	e8 c4 ea ff ff       	call   801000c0 <bread>
801015fc:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
801015fe:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101600:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101603:	83 e0 07             	and    $0x7,%eax
80101606:	c1 e0 06             	shl    $0x6,%eax
80101609:	8d 4c 07 18          	lea    0x18(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010160d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101611:	75 bd                	jne    801015d0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101613:	83 ec 04             	sub    $0x4,%esp
80101616:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101619:	6a 40                	push   $0x40
8010161b:	6a 00                	push   $0x0
8010161d:	51                   	push   %ecx
8010161e:	e8 bd 2e 00 00       	call   801044e0 <memset>
      dip->type = type;
80101623:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101627:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010162a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010162d:	89 3c 24             	mov    %edi,(%esp)
80101630:	e8 6b 18 00 00       	call   80102ea0 <log_write>
      brelse(bp);
80101635:	89 3c 24             	mov    %edi,(%esp)
80101638:	e8 93 eb ff ff       	call   801001d0 <brelse>
      return iget(dev, inum);
8010163d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101640:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101643:	89 da                	mov    %ebx,%edx
80101645:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5f                   	pop    %edi
8010164a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010164b:	e9 a0 fc ff ff       	jmp    801012f0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101650:	83 ec 0c             	sub    $0xc,%esp
80101653:	68 aa 70 10 80       	push   $0x801070aa
80101658:	e8 f3 ec ff ff       	call   80100350 <panic>
8010165d:	8d 76 00             	lea    0x0(%esi),%esi

80101660 <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	56                   	push   %esi
80101664:	53                   	push   %ebx
80101665:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101668:	83 ec 08             	sub    $0x8,%esp
8010166b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166e:	83 c3 1c             	add    $0x1c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101671:	c1 e8 03             	shr    $0x3,%eax
80101674:	03 05 b4 01 11 80    	add    0x801101b4,%eax
8010167a:	50                   	push   %eax
8010167b:	ff 73 e4             	pushl  -0x1c(%ebx)
8010167e:	e8 3d ea ff ff       	call   801000c0 <bread>
80101683:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101685:	8b 43 e8             	mov    -0x18(%ebx),%eax
  dip->type = ip->type;
80101688:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010168c:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010168f:	83 e0 07             	and    $0x7,%eax
80101692:	c1 e0 06             	shl    $0x6,%eax
80101695:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
  dip->type = ip->type;
80101699:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010169c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016a0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801016a3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016a7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ab:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016af:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016b3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016b7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016ba:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bd:	6a 34                	push   $0x34
801016bf:	53                   	push   %ebx
801016c0:	50                   	push   %eax
801016c1:	e8 ca 2e 00 00       	call   80104590 <memmove>
  log_write(bp);
801016c6:	89 34 24             	mov    %esi,(%esp)
801016c9:	e8 d2 17 00 00       	call   80102ea0 <log_write>
  brelse(bp);
801016ce:	89 75 08             	mov    %esi,0x8(%ebp)
801016d1:	83 c4 10             	add    $0x10,%esp
}
801016d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016d7:	5b                   	pop    %ebx
801016d8:	5e                   	pop    %esi
801016d9:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801016da:	e9 f1 ea ff ff       	jmp    801001d0 <brelse>
801016df:	90                   	nop

801016e0 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	53                   	push   %ebx
801016e4:	83 ec 10             	sub    $0x10,%esp
801016e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016ea:	68 c0 01 11 80       	push   $0x801101c0
801016ef:	e8 bc 2b 00 00       	call   801042b0 <acquire>
  ip->ref++;
801016f4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016f8:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
801016ff:	e8 8c 2d 00 00       	call   80104490 <release>
  return ip;
}
80101704:	89 d8                	mov    %ebx,%eax
80101706:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101709:	c9                   	leave  
8010170a:	c3                   	ret    
8010170b:	90                   	nop
8010170c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101710 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	56                   	push   %esi
80101714:	53                   	push   %ebx
80101715:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101718:	85 db                	test   %ebx,%ebx
8010171a:	0f 84 f0 00 00 00    	je     80101810 <ilock+0x100>
80101720:	8b 43 08             	mov    0x8(%ebx),%eax
80101723:	85 c0                	test   %eax,%eax
80101725:	0f 8e e5 00 00 00    	jle    80101810 <ilock+0x100>
    panic("ilock");

  acquire(&icache.lock);
8010172b:	83 ec 0c             	sub    $0xc,%esp
8010172e:	68 c0 01 11 80       	push   $0x801101c0
80101733:	e8 78 2b 00 00       	call   801042b0 <acquire>
  while(ip->flags & I_BUSY)
80101738:	8b 43 0c             	mov    0xc(%ebx),%eax
8010173b:	83 c4 10             	add    $0x10,%esp
8010173e:	a8 01                	test   $0x1,%al
80101740:	74 1e                	je     80101760 <ilock+0x50>
80101742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sleep(ip, &icache.lock);
80101748:	83 ec 08             	sub    $0x8,%esp
8010174b:	68 c0 01 11 80       	push   $0x801101c0
80101750:	53                   	push   %ebx
80101751:	e8 ba 27 00 00       	call   80103f10 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101756:	8b 43 0c             	mov    0xc(%ebx),%eax
80101759:	83 c4 10             	add    $0x10,%esp
8010175c:	a8 01                	test   $0x1,%al
8010175e:	75 e8                	jne    80101748 <ilock+0x38>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);
80101760:	83 ec 0c             	sub    $0xc,%esp
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101763:	83 c8 01             	or     $0x1,%eax
80101766:	89 43 0c             	mov    %eax,0xc(%ebx)
  release(&icache.lock);
80101769:	68 c0 01 11 80       	push   $0x801101c0
8010176e:	e8 1d 2d 00 00       	call   80104490 <release>

  if(!(ip->flags & I_VALID)){
80101773:	83 c4 10             	add    $0x10,%esp
80101776:	f6 43 0c 02          	testb  $0x2,0xc(%ebx)
8010177a:	74 0c                	je     80101788 <ilock+0x78>
    brelse(bp);
    ip->flags |= I_VALID;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
8010177c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010177f:	5b                   	pop    %ebx
80101780:	5e                   	pop    %esi
80101781:	5d                   	pop    %ebp
80101782:	c3                   	ret    
80101783:	90                   	nop
80101784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101788:	8b 43 04             	mov    0x4(%ebx),%eax
8010178b:	83 ec 08             	sub    $0x8,%esp
8010178e:	c1 e8 03             	shr    $0x3,%eax
80101791:	03 05 b4 01 11 80    	add    0x801101b4,%eax
80101797:	50                   	push   %eax
80101798:	ff 33                	pushl  (%ebx)
8010179a:	e8 21 e9 ff ff       	call   801000c0 <bread>
8010179f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017a1:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017a4:	83 c4 0c             	add    $0xc,%esp
  ip->flags |= I_BUSY;
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017a7:	83 e0 07             	and    $0x7,%eax
801017aa:	c1 e0 06             	shl    $0x6,%eax
801017ad:	8d 44 06 18          	lea    0x18(%esi,%eax,1),%eax
    ip->type = dip->type;
801017b1:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b4:	83 c0 0c             	add    $0xc,%eax
  release(&icache.lock);

  if(!(ip->flags & I_VALID)){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801017b7:	66 89 53 10          	mov    %dx,0x10(%ebx)
    ip->major = dip->major;
801017bb:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017bf:	66 89 53 12          	mov    %dx,0x12(%ebx)
    ip->minor = dip->minor;
801017c3:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017c7:	66 89 53 14          	mov    %dx,0x14(%ebx)
    ip->nlink = dip->nlink;
801017cb:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017cf:	66 89 53 16          	mov    %dx,0x16(%ebx)
    ip->size = dip->size;
801017d3:	8b 50 fc             	mov    -0x4(%eax),%edx
801017d6:	89 53 18             	mov    %edx,0x18(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d9:	6a 34                	push   $0x34
801017db:	50                   	push   %eax
801017dc:	8d 43 1c             	lea    0x1c(%ebx),%eax
801017df:	50                   	push   %eax
801017e0:	e8 ab 2d 00 00       	call   80104590 <memmove>
    brelse(bp);
801017e5:	89 34 24             	mov    %esi,(%esp)
801017e8:	e8 e3 e9 ff ff       	call   801001d0 <brelse>
    ip->flags |= I_VALID;
801017ed:	83 4b 0c 02          	orl    $0x2,0xc(%ebx)
    if(ip->type == 0)
801017f1:	83 c4 10             	add    $0x10,%esp
801017f4:	66 83 7b 10 00       	cmpw   $0x0,0x10(%ebx)
801017f9:	75 81                	jne    8010177c <ilock+0x6c>
      panic("ilock: no type");
801017fb:	83 ec 0c             	sub    $0xc,%esp
801017fe:	68 c2 70 10 80       	push   $0x801070c2
80101803:	e8 48 eb ff ff       	call   80100350 <panic>
80101808:	90                   	nop
80101809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101810:	83 ec 0c             	sub    $0xc,%esp
80101813:	68 bc 70 10 80       	push   $0x801070bc
80101818:	e8 33 eb ff ff       	call   80100350 <panic>
8010181d:	8d 76 00             	lea    0x0(%esi),%esi

80101820 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	53                   	push   %ebx
80101824:	83 ec 04             	sub    $0x4,%esp
80101827:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
8010182a:	85 db                	test   %ebx,%ebx
8010182c:	74 39                	je     80101867 <iunlock+0x47>
8010182e:	f6 43 0c 01          	testb  $0x1,0xc(%ebx)
80101832:	74 33                	je     80101867 <iunlock+0x47>
80101834:	8b 43 08             	mov    0x8(%ebx),%eax
80101837:	85 c0                	test   %eax,%eax
80101839:	7e 2c                	jle    80101867 <iunlock+0x47>
    panic("iunlock");

  acquire(&icache.lock);
8010183b:	83 ec 0c             	sub    $0xc,%esp
8010183e:	68 c0 01 11 80       	push   $0x801101c0
80101843:	e8 68 2a 00 00       	call   801042b0 <acquire>
  ip->flags &= ~I_BUSY;
80101848:	83 63 0c fe          	andl   $0xfffffffe,0xc(%ebx)
  wakeup(ip);
8010184c:	89 1c 24             	mov    %ebx,(%esp)
8010184f:	e8 7c 28 00 00       	call   801040d0 <wakeup>
  release(&icache.lock);
80101854:	83 c4 10             	add    $0x10,%esp
80101857:	c7 45 08 c0 01 11 80 	movl   $0x801101c0,0x8(%ebp)
}
8010185e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101861:	c9                   	leave  
    panic("iunlock");

  acquire(&icache.lock);
  ip->flags &= ~I_BUSY;
  wakeup(ip);
  release(&icache.lock);
80101862:	e9 29 2c 00 00       	jmp    80104490 <release>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
    panic("iunlock");
80101867:	83 ec 0c             	sub    $0xc,%esp
8010186a:	68 d1 70 10 80       	push   $0x801070d1
8010186f:	e8 dc ea ff ff       	call   80100350 <panic>
80101874:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010187a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101880 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101880:	55                   	push   %ebp
80101881:	89 e5                	mov    %esp,%ebp
80101883:	57                   	push   %edi
80101884:	56                   	push   %esi
80101885:	53                   	push   %ebx
80101886:	83 ec 28             	sub    $0x28,%esp
80101889:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&icache.lock);
8010188c:	68 c0 01 11 80       	push   $0x801101c0
80101891:	e8 1a 2a 00 00       	call   801042b0 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101896:	8b 46 08             	mov    0x8(%esi),%eax
80101899:	83 c4 10             	add    $0x10,%esp
8010189c:	83 f8 01             	cmp    $0x1,%eax
8010189f:	0f 85 ab 00 00 00    	jne    80101950 <iput+0xd0>
801018a5:	8b 56 0c             	mov    0xc(%esi),%edx
801018a8:	f6 c2 02             	test   $0x2,%dl
801018ab:	0f 84 9f 00 00 00    	je     80101950 <iput+0xd0>
801018b1:	66 83 7e 16 00       	cmpw   $0x0,0x16(%esi)
801018b6:	0f 85 94 00 00 00    	jne    80101950 <iput+0xd0>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
801018bc:	f6 c2 01             	test   $0x1,%dl
801018bf:	0f 85 05 01 00 00    	jne    801019ca <iput+0x14a>
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
801018c5:	83 ec 0c             	sub    $0xc,%esp
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
801018c8:	83 ca 01             	or     $0x1,%edx
801018cb:	8d 5e 1c             	lea    0x1c(%esi),%ebx
801018ce:	89 56 0c             	mov    %edx,0xc(%esi)
    release(&icache.lock);
801018d1:	68 c0 01 11 80       	push   $0x801101c0
801018d6:	8d 7e 4c             	lea    0x4c(%esi),%edi
801018d9:	e8 b2 2b 00 00       	call   80104490 <release>
801018de:	83 c4 10             	add    $0x10,%esp
801018e1:	eb 0c                	jmp    801018ef <iput+0x6f>
801018e3:	90                   	nop
801018e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018e8:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018eb:	39 fb                	cmp    %edi,%ebx
801018ed:	74 1b                	je     8010190a <iput+0x8a>
    if(ip->addrs[i]){
801018ef:	8b 13                	mov    (%ebx),%edx
801018f1:	85 d2                	test   %edx,%edx
801018f3:	74 f3                	je     801018e8 <iput+0x68>
      bfree(ip->dev, ip->addrs[i]);
801018f5:	8b 06                	mov    (%esi),%eax
801018f7:	83 c3 04             	add    $0x4,%ebx
801018fa:	e8 c1 fb ff ff       	call   801014c0 <bfree>
      ip->addrs[i] = 0;
801018ff:	c7 43 fc 00 00 00 00 	movl   $0x0,-0x4(%ebx)
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101906:	39 fb                	cmp    %edi,%ebx
80101908:	75 e5                	jne    801018ef <iput+0x6f>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
8010190a:	8b 46 4c             	mov    0x4c(%esi),%eax
8010190d:	85 c0                	test   %eax,%eax
8010190f:	75 5f                	jne    80101970 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101911:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101914:	c7 46 18 00 00 00 00 	movl   $0x0,0x18(%esi)
  iupdate(ip);
8010191b:	56                   	push   %esi
8010191c:	e8 3f fd ff ff       	call   80101660 <iupdate>
    if(ip->flags & I_BUSY)
      panic("iput busy");
    ip->flags |= I_BUSY;
    release(&icache.lock);
    itrunc(ip);
    ip->type = 0;
80101921:	31 c0                	xor    %eax,%eax
80101923:	66 89 46 10          	mov    %ax,0x10(%esi)
    iupdate(ip);
80101927:	89 34 24             	mov    %esi,(%esp)
8010192a:	e8 31 fd ff ff       	call   80101660 <iupdate>
    acquire(&icache.lock);
8010192f:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
80101936:	e8 75 29 00 00       	call   801042b0 <acquire>
    ip->flags = 0;
8010193b:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
    wakeup(ip);
80101942:	89 34 24             	mov    %esi,(%esp)
80101945:	e8 86 27 00 00       	call   801040d0 <wakeup>
8010194a:	8b 46 08             	mov    0x8(%esi),%eax
8010194d:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101950:	83 e8 01             	sub    $0x1,%eax
80101953:	89 46 08             	mov    %eax,0x8(%esi)
  release(&icache.lock);
80101956:	c7 45 08 c0 01 11 80 	movl   $0x801101c0,0x8(%ebp)
}
8010195d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101960:	5b                   	pop    %ebx
80101961:	5e                   	pop    %esi
80101962:	5f                   	pop    %edi
80101963:	5d                   	pop    %ebp
    acquire(&icache.lock);
    ip->flags = 0;
    wakeup(ip);
  }
  ip->ref--;
  release(&icache.lock);
80101964:	e9 27 2b 00 00       	jmp    80104490 <release>
80101969:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101970:	83 ec 08             	sub    $0x8,%esp
80101973:	50                   	push   %eax
80101974:	ff 36                	pushl  (%esi)
80101976:	e8 45 e7 ff ff       	call   801000c0 <bread>
8010197b:	83 c4 10             	add    $0x10,%esp
8010197e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101981:	8d 58 18             	lea    0x18(%eax),%ebx
80101984:	8d b8 18 02 00 00    	lea    0x218(%eax),%edi
8010198a:	eb 0b                	jmp    80101997 <iput+0x117>
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101990:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101993:	39 df                	cmp    %ebx,%edi
80101995:	74 0f                	je     801019a6 <iput+0x126>
      if(a[j])
80101997:	8b 13                	mov    (%ebx),%edx
80101999:	85 d2                	test   %edx,%edx
8010199b:	74 f3                	je     80101990 <iput+0x110>
        bfree(ip->dev, a[j]);
8010199d:	8b 06                	mov    (%esi),%eax
8010199f:	e8 1c fb ff ff       	call   801014c0 <bfree>
801019a4:	eb ea                	jmp    80101990 <iput+0x110>
    }
    brelse(bp);
801019a6:	83 ec 0c             	sub    $0xc,%esp
801019a9:	ff 75 e4             	pushl  -0x1c(%ebp)
801019ac:	e8 1f e8 ff ff       	call   801001d0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019b1:	8b 56 4c             	mov    0x4c(%esi),%edx
801019b4:	8b 06                	mov    (%esi),%eax
801019b6:	e8 05 fb ff ff       	call   801014c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801019c2:	83 c4 10             	add    $0x10,%esp
801019c5:	e9 47 ff ff ff       	jmp    80101911 <iput+0x91>
{
  acquire(&icache.lock);
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
      panic("iput busy");
801019ca:	83 ec 0c             	sub    $0xc,%esp
801019cd:	68 d9 70 10 80       	push   $0x801070d9
801019d2:	e8 79 e9 ff ff       	call   80100350 <panic>
801019d7:	89 f6                	mov    %esi,%esi
801019d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801019e0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801019e0:	55                   	push   %ebp
801019e1:	89 e5                	mov    %esp,%ebp
801019e3:	53                   	push   %ebx
801019e4:	83 ec 10             	sub    $0x10,%esp
801019e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019ea:	53                   	push   %ebx
801019eb:	e8 30 fe ff ff       	call   80101820 <iunlock>
  iput(ip);
801019f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019f3:	83 c4 10             	add    $0x10,%esp
}
801019f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019f9:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
801019fa:	e9 81 fe ff ff       	jmp    80101880 <iput>
801019ff:	90                   	nop

80101a00 <stati>:
}

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101a00:	55                   	push   %ebp
80101a01:	89 e5                	mov    %esp,%ebp
80101a03:	8b 55 08             	mov    0x8(%ebp),%edx
80101a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a09:	8b 0a                	mov    (%edx),%ecx
80101a0b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a0e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a11:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a14:	0f b7 4a 10          	movzwl 0x10(%edx),%ecx
80101a18:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a1b:	0f b7 4a 16          	movzwl 0x16(%edx),%ecx
80101a1f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a23:	8b 52 18             	mov    0x18(%edx),%edx
80101a26:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a29:	5d                   	pop    %ebp
80101a2a:	c3                   	ret    
80101a2b:	90                   	nop
80101a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a30 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a30:	55                   	push   %ebp
80101a31:	89 e5                	mov    %esp,%ebp
80101a33:	57                   	push   %edi
80101a34:	56                   	push   %esi
80101a35:	53                   	push   %ebx
80101a36:	83 ec 1c             	sub    $0x1c,%esp
80101a39:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a3f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a42:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a47:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a4a:	8b 7d 14             	mov    0x14(%ebp),%edi
80101a4d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a50:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a53:	0f 84 a7 00 00 00    	je     80101b00 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a5c:	8b 40 18             	mov    0x18(%eax),%eax
80101a5f:	39 f0                	cmp    %esi,%eax
80101a61:	0f 82 c1 00 00 00    	jb     80101b28 <readi+0xf8>
80101a67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a6a:	89 fa                	mov    %edi,%edx
80101a6c:	01 f2                	add    %esi,%edx
80101a6e:	0f 82 b4 00 00 00    	jb     80101b28 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a74:	89 c1                	mov    %eax,%ecx
80101a76:	29 f1                	sub    %esi,%ecx
80101a78:	39 d0                	cmp    %edx,%eax
80101a7a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a7d:	31 ff                	xor    %edi,%edi
80101a7f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a84:	74 6d                	je     80101af3 <readi+0xc3>
80101a86:	8d 76 00             	lea    0x0(%esi),%esi
80101a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a90:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a93:	89 f2                	mov    %esi,%edx
80101a95:	c1 ea 09             	shr    $0x9,%edx
80101a98:	89 d8                	mov    %ebx,%eax
80101a9a:	e8 21 f9 ff ff       	call   801013c0 <bmap>
80101a9f:	83 ec 08             	sub    $0x8,%esp
80101aa2:	50                   	push   %eax
80101aa3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aaa:	e8 11 e6 ff ff       	call   801000c0 <bread>
80101aaf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ab4:	89 f1                	mov    %esi,%ecx
80101ab6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101abc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101abf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101ac2:	29 cb                	sub    %ecx,%ebx
80101ac4:	29 f8                	sub    %edi,%eax
80101ac6:	39 c3                	cmp    %eax,%ebx
80101ac8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101acb:	8d 44 0a 18          	lea    0x18(%edx,%ecx,1),%eax
80101acf:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ad0:	01 df                	add    %ebx,%edi
80101ad2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101ad4:	50                   	push   %eax
80101ad5:	ff 75 e0             	pushl  -0x20(%ebp)
80101ad8:	e8 b3 2a 00 00       	call   80104590 <memmove>
    brelse(bp);
80101add:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101ae0:	89 14 24             	mov    %edx,(%esp)
80101ae3:	e8 e8 e6 ff ff       	call   801001d0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ae8:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aeb:	83 c4 10             	add    $0x10,%esp
80101aee:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101af1:	77 9d                	ja     80101a90 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101af3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101af6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101af9:	5b                   	pop    %ebx
80101afa:	5e                   	pop    %esi
80101afb:	5f                   	pop    %edi
80101afc:	5d                   	pop    %ebp
80101afd:	c3                   	ret    
80101afe:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b00:	0f bf 40 12          	movswl 0x12(%eax),%eax
80101b04:	66 83 f8 09          	cmp    $0x9,%ax
80101b08:	77 1e                	ja     80101b28 <readi+0xf8>
80101b0a:	8b 04 c5 40 01 11 80 	mov    -0x7feefec0(,%eax,8),%eax
80101b11:	85 c0                	test   %eax,%eax
80101b13:	74 13                	je     80101b28 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101b15:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
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
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101b1f:	ff e0                	jmp    *%eax
80101b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101b28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b2d:	eb c7                	jmp    80101af6 <readi+0xc6>
80101b2f:	90                   	nop

80101b30 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b30:	55                   	push   %ebp
80101b31:	89 e5                	mov    %esp,%ebp
80101b33:	57                   	push   %edi
80101b34:	56                   	push   %esi
80101b35:	53                   	push   %ebx
80101b36:	83 ec 1c             	sub    $0x1c,%esp
80101b39:	8b 45 08             	mov    0x8(%ebp),%eax
80101b3c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b3f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b42:	66 83 78 10 03       	cmpw   $0x3,0x10(%eax)

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b47:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b4d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b50:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b53:	0f 84 b7 00 00 00    	je     80101c10 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5c:	39 70 18             	cmp    %esi,0x18(%eax)
80101b5f:	0f 82 eb 00 00 00    	jb     80101c50 <writei+0x120>
80101b65:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b68:	89 f8                	mov    %edi,%eax
80101b6a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b6c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b71:	0f 87 d9 00 00 00    	ja     80101c50 <writei+0x120>
80101b77:	39 c6                	cmp    %eax,%esi
80101b79:	0f 87 d1 00 00 00    	ja     80101c50 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b7f:	85 ff                	test   %edi,%edi
80101b81:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b88:	74 78                	je     80101c02 <writei+0xd2>
80101b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b90:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b93:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b95:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b9a:	c1 ea 09             	shr    $0x9,%edx
80101b9d:	89 f8                	mov    %edi,%eax
80101b9f:	e8 1c f8 ff ff       	call   801013c0 <bmap>
80101ba4:	83 ec 08             	sub    $0x8,%esp
80101ba7:	50                   	push   %eax
80101ba8:	ff 37                	pushl  (%edi)
80101baa:	e8 11 e5 ff ff       	call   801000c0 <bread>
80101baf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101bb1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101bb4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101bb7:	89 f1                	mov    %esi,%ecx
80101bb9:	83 c4 0c             	add    $0xc,%esp
80101bbc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101bc2:	29 cb                	sub    %ecx,%ebx
80101bc4:	39 c3                	cmp    %eax,%ebx
80101bc6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bc9:	8d 44 0f 18          	lea    0x18(%edi,%ecx,1),%eax
80101bcd:	53                   	push   %ebx
80101bce:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bd1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101bd3:	50                   	push   %eax
80101bd4:	e8 b7 29 00 00       	call   80104590 <memmove>
    log_write(bp);
80101bd9:	89 3c 24             	mov    %edi,(%esp)
80101bdc:	e8 bf 12 00 00       	call   80102ea0 <log_write>
    brelse(bp);
80101be1:	89 3c 24             	mov    %edi,(%esp)
80101be4:	e8 e7 e5 ff ff       	call   801001d0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101be9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bec:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bef:	83 c4 10             	add    $0x10,%esp
80101bf2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101bf5:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101bf8:	77 96                	ja     80101b90 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101bfa:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bfd:	3b 70 18             	cmp    0x18(%eax),%esi
80101c00:	77 36                	ja     80101c38 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c02:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c08:	5b                   	pop    %ebx
80101c09:	5e                   	pop    %esi
80101c0a:	5f                   	pop    %edi
80101c0b:	5d                   	pop    %ebp
80101c0c:	c3                   	ret    
80101c0d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c10:	0f bf 40 12          	movswl 0x12(%eax),%eax
80101c14:	66 83 f8 09          	cmp    $0x9,%ax
80101c18:	77 36                	ja     80101c50 <writei+0x120>
80101c1a:	8b 04 c5 44 01 11 80 	mov    -0x7feefebc(,%eax,8),%eax
80101c21:	85 c0                	test   %eax,%eax
80101c23:	74 2b                	je     80101c50 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101c25:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101c28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c2b:	5b                   	pop    %ebx
80101c2c:	5e                   	pop    %esi
80101c2d:	5f                   	pop    %edi
80101c2e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101c2f:	ff e0                	jmp    *%eax
80101c31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101c38:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c3b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101c3e:	89 70 18             	mov    %esi,0x18(%eax)
    iupdate(ip);
80101c41:	50                   	push   %eax
80101c42:	e8 19 fa ff ff       	call   80101660 <iupdate>
80101c47:	83 c4 10             	add    $0x10,%esp
80101c4a:	eb b6                	jmp    80101c02 <writei+0xd2>
80101c4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c55:	eb ae                	jmp    80101c05 <writei+0xd5>
80101c57:	89 f6                	mov    %esi,%esi
80101c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c60 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c66:	6a 0e                	push   $0xe
80101c68:	ff 75 0c             	pushl  0xc(%ebp)
80101c6b:	ff 75 08             	pushl  0x8(%ebp)
80101c6e:	e8 9d 29 00 00       	call   80104610 <strncmp>
}
80101c73:	c9                   	leave  
80101c74:	c3                   	ret    
80101c75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c80 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c80:	55                   	push   %ebp
80101c81:	89 e5                	mov    %esp,%ebp
80101c83:	57                   	push   %edi
80101c84:	56                   	push   %esi
80101c85:	53                   	push   %ebx
80101c86:	83 ec 1c             	sub    $0x1c,%esp
80101c89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c8c:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80101c91:	0f 85 80 00 00 00    	jne    80101d17 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c97:	8b 53 18             	mov    0x18(%ebx),%edx
80101c9a:	31 ff                	xor    %edi,%edi
80101c9c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c9f:	85 d2                	test   %edx,%edx
80101ca1:	75 0d                	jne    80101cb0 <dirlookup+0x30>
80101ca3:	eb 5b                	jmp    80101d00 <dirlookup+0x80>
80101ca5:	8d 76 00             	lea    0x0(%esi),%esi
80101ca8:	83 c7 10             	add    $0x10,%edi
80101cab:	39 7b 18             	cmp    %edi,0x18(%ebx)
80101cae:	76 50                	jbe    80101d00 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cb0:	6a 10                	push   $0x10
80101cb2:	57                   	push   %edi
80101cb3:	56                   	push   %esi
80101cb4:	53                   	push   %ebx
80101cb5:	e8 76 fd ff ff       	call   80101a30 <readi>
80101cba:	83 c4 10             	add    $0x10,%esp
80101cbd:	83 f8 10             	cmp    $0x10,%eax
80101cc0:	75 48                	jne    80101d0a <dirlookup+0x8a>
      panic("dirlink read");
    if(de.inum == 0)
80101cc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cc7:	74 df                	je     80101ca8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101cc9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ccc:	83 ec 04             	sub    $0x4,%esp
80101ccf:	6a 0e                	push   $0xe
80101cd1:	50                   	push   %eax
80101cd2:	ff 75 0c             	pushl  0xc(%ebp)
80101cd5:	e8 36 29 00 00       	call   80104610 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101cda:	83 c4 10             	add    $0x10,%esp
80101cdd:	85 c0                	test   %eax,%eax
80101cdf:	75 c7                	jne    80101ca8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101ce1:	8b 45 10             	mov    0x10(%ebp),%eax
80101ce4:	85 c0                	test   %eax,%eax
80101ce6:	74 05                	je     80101ced <dirlookup+0x6d>
        *poff = off;
80101ce8:	8b 45 10             	mov    0x10(%ebp),%eax
80101ceb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101ced:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101cf1:	8b 03                	mov    (%ebx),%eax
80101cf3:	e8 f8 f5 ff ff       	call   801012f0 <iget>
    }
  }

  return 0;
}
80101cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cfb:	5b                   	pop    %ebx
80101cfc:	5e                   	pop    %esi
80101cfd:	5f                   	pop    %edi
80101cfe:	5d                   	pop    %ebp
80101cff:	c3                   	ret    
80101d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101d03:	31 c0                	xor    %eax,%eax
}
80101d05:	5b                   	pop    %ebx
80101d06:	5e                   	pop    %esi
80101d07:	5f                   	pop    %edi
80101d08:	5d                   	pop    %ebp
80101d09:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101d0a:	83 ec 0c             	sub    $0xc,%esp
80101d0d:	68 f5 70 10 80       	push   $0x801070f5
80101d12:	e8 39 e6 ff ff       	call   80100350 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101d17:	83 ec 0c             	sub    $0xc,%esp
80101d1a:	68 e3 70 10 80       	push   $0x801070e3
80101d1f:	e8 2c e6 ff ff       	call   80100350 <panic>
80101d24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101d30 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d30:	55                   	push   %ebp
80101d31:	89 e5                	mov    %esp,%ebp
80101d33:	57                   	push   %edi
80101d34:	56                   	push   %esi
80101d35:	53                   	push   %ebx
80101d36:	89 cf                	mov    %ecx,%edi
80101d38:	89 c3                	mov    %eax,%ebx
80101d3a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d3d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d40:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101d43:	0f 84 53 01 00 00    	je     80101e9c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101d49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101d4f:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80101d52:	8b 70 6c             	mov    0x6c(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101d55:	68 c0 01 11 80       	push   $0x801101c0
80101d5a:	e8 51 25 00 00       	call   801042b0 <acquire>
  ip->ref++;
80101d5f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d63:	c7 04 24 c0 01 11 80 	movl   $0x801101c0,(%esp)
80101d6a:	e8 21 27 00 00       	call   80104490 <release>
80101d6f:	83 c4 10             	add    $0x10,%esp
80101d72:	eb 07                	jmp    80101d7b <namex+0x4b>
80101d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101d78:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101d7b:	0f b6 03             	movzbl (%ebx),%eax
80101d7e:	3c 2f                	cmp    $0x2f,%al
80101d80:	74 f6                	je     80101d78 <namex+0x48>
    path++;
  if(*path == 0)
80101d82:	84 c0                	test   %al,%al
80101d84:	0f 84 e3 00 00 00    	je     80101e6d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d8a:	0f b6 03             	movzbl (%ebx),%eax
80101d8d:	89 da                	mov    %ebx,%edx
80101d8f:	84 c0                	test   %al,%al
80101d91:	0f 84 ac 00 00 00    	je     80101e43 <namex+0x113>
80101d97:	3c 2f                	cmp    $0x2f,%al
80101d99:	75 09                	jne    80101da4 <namex+0x74>
80101d9b:	e9 a3 00 00 00       	jmp    80101e43 <namex+0x113>
80101da0:	84 c0                	test   %al,%al
80101da2:	74 0a                	je     80101dae <namex+0x7e>
    path++;
80101da4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101da7:	0f b6 02             	movzbl (%edx),%eax
80101daa:	3c 2f                	cmp    $0x2f,%al
80101dac:	75 f2                	jne    80101da0 <namex+0x70>
80101dae:	89 d1                	mov    %edx,%ecx
80101db0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101db2:	83 f9 0d             	cmp    $0xd,%ecx
80101db5:	0f 8e 8d 00 00 00    	jle    80101e48 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101dbb:	83 ec 04             	sub    $0x4,%esp
80101dbe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101dc1:	6a 0e                	push   $0xe
80101dc3:	53                   	push   %ebx
80101dc4:	57                   	push   %edi
80101dc5:	e8 c6 27 00 00       	call   80104590 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101dca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101dcd:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101dd0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101dd2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101dd5:	75 11                	jne    80101de8 <namex+0xb8>
80101dd7:	89 f6                	mov    %esi,%esi
80101dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101de0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101de3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101de6:	74 f8                	je     80101de0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101de8:	83 ec 0c             	sub    $0xc,%esp
80101deb:	56                   	push   %esi
80101dec:	e8 1f f9 ff ff       	call   80101710 <ilock>
    if(ip->type != T_DIR){
80101df1:	83 c4 10             	add    $0x10,%esp
80101df4:	66 83 7e 10 01       	cmpw   $0x1,0x10(%esi)
80101df9:	0f 85 7f 00 00 00    	jne    80101e7e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dff:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e02:	85 d2                	test   %edx,%edx
80101e04:	74 09                	je     80101e0f <namex+0xdf>
80101e06:	80 3b 00             	cmpb   $0x0,(%ebx)
80101e09:	0f 84 a3 00 00 00    	je     80101eb2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e0f:	83 ec 04             	sub    $0x4,%esp
80101e12:	6a 00                	push   $0x0
80101e14:	57                   	push   %edi
80101e15:	56                   	push   %esi
80101e16:	e8 65 fe ff ff       	call   80101c80 <dirlookup>
80101e1b:	83 c4 10             	add    $0x10,%esp
80101e1e:	85 c0                	test   %eax,%eax
80101e20:	74 5c                	je     80101e7e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e22:	83 ec 0c             	sub    $0xc,%esp
80101e25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e28:	56                   	push   %esi
80101e29:	e8 f2 f9 ff ff       	call   80101820 <iunlock>
  iput(ip);
80101e2e:	89 34 24             	mov    %esi,(%esp)
80101e31:	e8 4a fa ff ff       	call   80101880 <iput>
80101e36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	89 c6                	mov    %eax,%esi
80101e3e:	e9 38 ff ff ff       	jmp    80101d7b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101e43:	31 c9                	xor    %ecx,%ecx
80101e45:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101e48:	83 ec 04             	sub    $0x4,%esp
80101e4b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e4e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e51:	51                   	push   %ecx
80101e52:	53                   	push   %ebx
80101e53:	57                   	push   %edi
80101e54:	e8 37 27 00 00       	call   80104590 <memmove>
    name[len] = 0;
80101e59:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e5f:	83 c4 10             	add    $0x10,%esp
80101e62:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e66:	89 d3                	mov    %edx,%ebx
80101e68:	e9 65 ff ff ff       	jmp    80101dd2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e70:	85 c0                	test   %eax,%eax
80101e72:	75 54                	jne    80101ec8 <namex+0x198>
80101e74:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101e76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e79:	5b                   	pop    %ebx
80101e7a:	5e                   	pop    %esi
80101e7b:	5f                   	pop    %edi
80101e7c:	5d                   	pop    %ebp
80101e7d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e7e:	83 ec 0c             	sub    $0xc,%esp
80101e81:	56                   	push   %esi
80101e82:	e8 99 f9 ff ff       	call   80101820 <iunlock>
  iput(ip);
80101e87:	89 34 24             	mov    %esi,(%esp)
80101e8a:	e8 f1 f9 ff ff       	call   80101880 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e8f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e92:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e95:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e97:	5b                   	pop    %ebx
80101e98:	5e                   	pop    %esi
80101e99:	5f                   	pop    %edi
80101e9a:	5d                   	pop    %ebp
80101e9b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e9c:	ba 01 00 00 00       	mov    $0x1,%edx
80101ea1:	b8 01 00 00 00       	mov    $0x1,%eax
80101ea6:	e8 45 f4 ff ff       	call   801012f0 <iget>
80101eab:	89 c6                	mov    %eax,%esi
80101ead:	e9 c9 fe ff ff       	jmp    80101d7b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101eb2:	83 ec 0c             	sub    $0xc,%esp
80101eb5:	56                   	push   %esi
80101eb6:	e8 65 f9 ff ff       	call   80101820 <iunlock>
      return ip;
80101ebb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ebe:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101ec1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101ec3:	5b                   	pop    %ebx
80101ec4:	5e                   	pop    %esi
80101ec5:	5f                   	pop    %edi
80101ec6:	5d                   	pop    %ebp
80101ec7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	56                   	push   %esi
80101ecc:	e8 af f9 ff ff       	call   80101880 <iput>
    return 0;
80101ed1:	83 c4 10             	add    $0x10,%esp
80101ed4:	31 c0                	xor    %eax,%eax
80101ed6:	eb 9e                	jmp    80101e76 <namex+0x146>
80101ed8:	90                   	nop
80101ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ee0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101ee0:	55                   	push   %ebp
80101ee1:	89 e5                	mov    %esp,%ebp
80101ee3:	57                   	push   %edi
80101ee4:	56                   	push   %esi
80101ee5:	53                   	push   %ebx
80101ee6:	83 ec 20             	sub    $0x20,%esp
80101ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101eec:	6a 00                	push   $0x0
80101eee:	ff 75 0c             	pushl  0xc(%ebp)
80101ef1:	53                   	push   %ebx
80101ef2:	e8 89 fd ff ff       	call   80101c80 <dirlookup>
80101ef7:	83 c4 10             	add    $0x10,%esp
80101efa:	85 c0                	test   %eax,%eax
80101efc:	75 67                	jne    80101f65 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101efe:	8b 7b 18             	mov    0x18(%ebx),%edi
80101f01:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f04:	85 ff                	test   %edi,%edi
80101f06:	74 29                	je     80101f31 <dirlink+0x51>
80101f08:	31 ff                	xor    %edi,%edi
80101f0a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f0d:	eb 09                	jmp    80101f18 <dirlink+0x38>
80101f0f:	90                   	nop
80101f10:	83 c7 10             	add    $0x10,%edi
80101f13:	39 7b 18             	cmp    %edi,0x18(%ebx)
80101f16:	76 19                	jbe    80101f31 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f18:	6a 10                	push   $0x10
80101f1a:	57                   	push   %edi
80101f1b:	56                   	push   %esi
80101f1c:	53                   	push   %ebx
80101f1d:	e8 0e fb ff ff       	call   80101a30 <readi>
80101f22:	83 c4 10             	add    $0x10,%esp
80101f25:	83 f8 10             	cmp    $0x10,%eax
80101f28:	75 4e                	jne    80101f78 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101f2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f2f:	75 df                	jne    80101f10 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101f31:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f34:	83 ec 04             	sub    $0x4,%esp
80101f37:	6a 0e                	push   $0xe
80101f39:	ff 75 0c             	pushl  0xc(%ebp)
80101f3c:	50                   	push   %eax
80101f3d:	e8 3e 27 00 00       	call   80104680 <strncpy>
  de.inum = inum;
80101f42:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f45:	6a 10                	push   $0x10
80101f47:	57                   	push   %edi
80101f48:	56                   	push   %esi
80101f49:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101f4a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f4e:	e8 dd fb ff ff       	call   80101b30 <writei>
80101f53:	83 c4 20             	add    $0x20,%esp
80101f56:	83 f8 10             	cmp    $0x10,%eax
80101f59:	75 2a                	jne    80101f85 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101f5b:	31 c0                	xor    %eax,%eax
}
80101f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f60:	5b                   	pop    %ebx
80101f61:	5e                   	pop    %esi
80101f62:	5f                   	pop    %edi
80101f63:	5d                   	pop    %ebp
80101f64:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101f65:	83 ec 0c             	sub    $0xc,%esp
80101f68:	50                   	push   %eax
80101f69:	e8 12 f9 ff ff       	call   80101880 <iput>
    return -1;
80101f6e:	83 c4 10             	add    $0x10,%esp
80101f71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f76:	eb e5                	jmp    80101f5d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101f78:	83 ec 0c             	sub    $0xc,%esp
80101f7b:	68 f5 70 10 80       	push   $0x801070f5
80101f80:	e8 cb e3 ff ff       	call   80100350 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f85:	83 ec 0c             	sub    $0xc,%esp
80101f88:	68 de 76 10 80       	push   $0x801076de
80101f8d:	e8 be e3 ff ff       	call   80100350 <panic>
80101f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fa0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101fa0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fa1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101fa3:	89 e5                	mov    %esp,%ebp
80101fa5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fae:	e8 7d fd ff ff       	call   80101d30 <namex>
}
80101fb3:	c9                   	leave  
80101fb4:	c3                   	ret    
80101fb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fc0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fc0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fc1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101fc6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101fcb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fce:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101fcf:	e9 5c fd ff ff       	jmp    80101d30 <namex>
80101fd4:	66 90                	xchg   %ax,%ax
80101fd6:	66 90                	xchg   %ax,%ax
80101fd8:	66 90                	xchg   %ax,%ax
80101fda:	66 90                	xchg   %ax,%ax
80101fdc:	66 90                	xchg   %ax,%ax
80101fde:	66 90                	xchg   %ax,%ax

80101fe0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101fe0:	55                   	push   %ebp
  if(b == 0)
80101fe1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101fe3:	89 e5                	mov    %esp,%ebp
80101fe5:	56                   	push   %esi
80101fe6:	53                   	push   %ebx
  if(b == 0)
80101fe7:	0f 84 ad 00 00 00    	je     8010209a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fed:	8b 58 08             	mov    0x8(%eax),%ebx
80101ff0:	89 c1                	mov    %eax,%ecx
80101ff2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101ff8:	0f 87 8f 00 00 00    	ja     8010208d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ffe:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102003:	90                   	nop
80102004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102008:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102009:	83 e0 c0             	and    $0xffffffc0,%eax
8010200c:	3c 40                	cmp    $0x40,%al
8010200e:	75 f8                	jne    80102008 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102010:	31 f6                	xor    %esi,%esi
80102012:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102017:	89 f0                	mov    %esi,%eax
80102019:	ee                   	out    %al,(%dx)
8010201a:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010201f:	b8 01 00 00 00       	mov    $0x1,%eax
80102024:	ee                   	out    %al,(%dx)
80102025:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010202a:	89 d8                	mov    %ebx,%eax
8010202c:	ee                   	out    %al,(%dx)
8010202d:	89 d8                	mov    %ebx,%eax
8010202f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102034:	c1 f8 08             	sar    $0x8,%eax
80102037:	ee                   	out    %al,(%dx)
80102038:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010203d:	89 f0                	mov    %esi,%eax
8010203f:	ee                   	out    %al,(%dx)
80102040:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80102044:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102049:	83 e0 01             	and    $0x1,%eax
8010204c:	c1 e0 04             	shl    $0x4,%eax
8010204f:	83 c8 e0             	or     $0xffffffe0,%eax
80102052:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80102053:	f6 01 04             	testb  $0x4,(%ecx)
80102056:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010205b:	75 13                	jne    80102070 <idestart+0x90>
8010205d:	b8 20 00 00 00       	mov    $0x20,%eax
80102062:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102063:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102066:	5b                   	pop    %ebx
80102067:	5e                   	pop    %esi
80102068:	5d                   	pop    %ebp
80102069:	c3                   	ret    
8010206a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102070:	b8 30 00 00 00       	mov    $0x30,%eax
80102075:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102076:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010207b:	8d 71 18             	lea    0x18(%ecx),%esi
8010207e:	b9 80 00 00 00       	mov    $0x80,%ecx
80102083:	fc                   	cld    
80102084:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102086:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102089:	5b                   	pop    %ebx
8010208a:	5e                   	pop    %esi
8010208b:	5d                   	pop    %ebp
8010208c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010208d:	83 ec 0c             	sub    $0xc,%esp
80102090:	68 69 71 10 80       	push   $0x80107169
80102095:	e8 b6 e2 ff ff       	call   80100350 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010209a:	83 ec 0c             	sub    $0xc,%esp
8010209d:	68 60 71 10 80       	push   $0x80107160
801020a2:	e8 a9 e2 ff ff       	call   80100350 <panic>
801020a7:	89 f6                	mov    %esi,%esi
801020a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020b0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
801020b6:	68 7b 71 10 80       	push   $0x8010717b
801020bb:	68 80 a5 10 80       	push   $0x8010a580
801020c0:	e8 cb 21 00 00       	call   80104290 <initlock>
  picenable(IRQ_IDE);
801020c5:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801020cc:	e8 bf 12 00 00       	call   80103390 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
801020d1:	58                   	pop    %eax
801020d2:	a1 c0 18 11 80       	mov    0x801118c0,%eax
801020d7:	5a                   	pop    %edx
801020d8:	83 e8 01             	sub    $0x1,%eax
801020db:	50                   	push   %eax
801020dc:	6a 0e                	push   $0xe
801020de:	e8 ad 02 00 00       	call   80102390 <ioapicenable>
801020e3:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e6:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020eb:	90                   	nop
801020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020f0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f1:	83 e0 c0             	and    $0xffffffc0,%eax
801020f4:	3c 40                	cmp    $0x40,%al
801020f6:	75 f8                	jne    801020f0 <ideinit+0x40>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020f8:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020fd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102102:	ee                   	out    %al,(%dx)
80102103:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102108:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010210d:	eb 06                	jmp    80102115 <ideinit+0x65>
8010210f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102110:	83 e9 01             	sub    $0x1,%ecx
80102113:	74 0f                	je     80102124 <ideinit+0x74>
80102115:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102116:	84 c0                	test   %al,%al
80102118:	74 f6                	je     80102110 <ideinit+0x60>
      havedisk1 = 1;
8010211a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102121:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102124:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102129:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010212e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010212f:	c9                   	leave  
80102130:	c3                   	ret    
80102131:	eb 0d                	jmp    80102140 <ideintr>
80102133:	90                   	nop
80102134:	90                   	nop
80102135:	90                   	nop
80102136:	90                   	nop
80102137:	90                   	nop
80102138:	90                   	nop
80102139:	90                   	nop
8010213a:	90                   	nop
8010213b:	90                   	nop
8010213c:	90                   	nop
8010213d:	90                   	nop
8010213e:	90                   	nop
8010213f:	90                   	nop

80102140 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	57                   	push   %edi
80102144:	56                   	push   %esi
80102145:	53                   	push   %ebx
80102146:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102149:	68 80 a5 10 80       	push   $0x8010a580
8010214e:	e8 5d 21 00 00       	call   801042b0 <acquire>
  if((b = idequeue) == 0){
80102153:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102159:	83 c4 10             	add    $0x10,%esp
8010215c:	85 db                	test   %ebx,%ebx
8010215e:	74 34                	je     80102194 <ideintr+0x54>
    release(&idelock);
    // cprintf("spurious IDE interrupt\n");
    return;
  }
  idequeue = b->qnext;
80102160:	8b 43 14             	mov    0x14(%ebx),%eax
80102163:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102168:	8b 33                	mov    (%ebx),%esi
8010216a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102170:	74 3e                	je     801021b0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102172:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102175:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102178:	83 ce 02             	or     $0x2,%esi
8010217b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010217d:	53                   	push   %ebx
8010217e:	e8 4d 1f 00 00       	call   801040d0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102183:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102188:	83 c4 10             	add    $0x10,%esp
8010218b:	85 c0                	test   %eax,%eax
8010218d:	74 05                	je     80102194 <ideintr+0x54>
    idestart(idequeue);
8010218f:	e8 4c fe ff ff       	call   80101fe0 <idestart>
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
  if((b = idequeue) == 0){
    release(&idelock);
80102194:	83 ec 0c             	sub    $0xc,%esp
80102197:	68 80 a5 10 80       	push   $0x8010a580
8010219c:	e8 ef 22 00 00       	call   80104490 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801021a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021a4:	5b                   	pop    %ebx
801021a5:	5e                   	pop    %esi
801021a6:	5f                   	pop    %edi
801021a7:	5d                   	pop    %ebp
801021a8:	c3                   	ret    
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021b0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021b5:	8d 76 00             	lea    0x0(%esi),%esi
801021b8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021b9:	89 c1                	mov    %eax,%ecx
801021bb:	83 e1 c0             	and    $0xffffffc0,%ecx
801021be:	80 f9 40             	cmp    $0x40,%cl
801021c1:	75 f5                	jne    801021b8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801021c3:	a8 21                	test   $0x21,%al
801021c5:	75 ab                	jne    80102172 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801021c7:	8d 7b 18             	lea    0x18(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801021ca:	b9 80 00 00 00       	mov    $0x80,%ecx
801021cf:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021d4:	fc                   	cld    
801021d5:	f3 6d                	rep insl (%dx),%es:(%edi)
801021d7:	8b 33                	mov    (%ebx),%esi
801021d9:	eb 97                	jmp    80102172 <ideintr+0x32>
801021db:	90                   	nop
801021dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801021e0:	55                   	push   %ebp
801021e1:	89 e5                	mov    %esp,%ebp
801021e3:	53                   	push   %ebx
801021e4:	83 ec 04             	sub    $0x4,%esp
801021e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801021ea:	8b 03                	mov    (%ebx),%eax
801021ec:	a8 01                	test   $0x1,%al
801021ee:	0f 84 a7 00 00 00    	je     8010229b <iderw+0xbb>
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801021f4:	83 e0 06             	and    $0x6,%eax
801021f7:	83 f8 02             	cmp    $0x2,%eax
801021fa:	0f 84 b5 00 00 00    	je     801022b5 <iderw+0xd5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102200:	8b 53 04             	mov    0x4(%ebx),%edx
80102203:	85 d2                	test   %edx,%edx
80102205:	74 0d                	je     80102214 <iderw+0x34>
80102207:	a1 60 a5 10 80       	mov    0x8010a560,%eax
8010220c:	85 c0                	test   %eax,%eax
8010220e:	0f 84 94 00 00 00    	je     801022a8 <iderw+0xc8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102214:	83 ec 0c             	sub    $0xc,%esp
80102217:	68 80 a5 10 80       	push   $0x8010a580
8010221c:	e8 8f 20 00 00       	call   801042b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102221:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102227:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
8010222a:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102231:	85 d2                	test   %edx,%edx
80102233:	75 0d                	jne    80102242 <iderw+0x62>
80102235:	eb 54                	jmp    8010228b <iderw+0xab>
80102237:	89 f6                	mov    %esi,%esi
80102239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102240:	89 c2                	mov    %eax,%edx
80102242:	8b 42 14             	mov    0x14(%edx),%eax
80102245:	85 c0                	test   %eax,%eax
80102247:	75 f7                	jne    80102240 <iderw+0x60>
80102249:	83 c2 14             	add    $0x14,%edx
    ;
  *pp = b;
8010224c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010224e:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
80102254:	74 3c                	je     80102292 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102256:	8b 03                	mov    (%ebx),%eax
80102258:	83 e0 06             	and    $0x6,%eax
8010225b:	83 f8 02             	cmp    $0x2,%eax
8010225e:	74 1b                	je     8010227b <iderw+0x9b>
    sleep(b, &idelock);
80102260:	83 ec 08             	sub    $0x8,%esp
80102263:	68 80 a5 10 80       	push   $0x8010a580
80102268:	53                   	push   %ebx
80102269:	e8 a2 1c 00 00       	call   80103f10 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010226e:	8b 03                	mov    (%ebx),%eax
80102270:	83 c4 10             	add    $0x10,%esp
80102273:	83 e0 06             	and    $0x6,%eax
80102276:	83 f8 02             	cmp    $0x2,%eax
80102279:	75 e5                	jne    80102260 <iderw+0x80>
    sleep(b, &idelock);
  }

  release(&idelock);
8010227b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102282:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102285:	c9                   	leave  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }

  release(&idelock);
80102286:	e9 05 22 00 00       	jmp    80104490 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010228b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102290:	eb ba                	jmp    8010224c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102292:	89 d8                	mov    %ebx,%eax
80102294:	e8 47 fd ff ff       	call   80101fe0 <idestart>
80102299:	eb bb                	jmp    80102256 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("iderw: buf not busy");
8010229b:	83 ec 0c             	sub    $0xc,%esp
8010229e:	68 7f 71 10 80       	push   $0x8010717f
801022a3:	e8 a8 e0 ff ff       	call   80100350 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801022a8:	83 ec 0c             	sub    $0xc,%esp
801022ab:	68 a8 71 10 80       	push   $0x801071a8
801022b0:	e8 9b e0 ff ff       	call   80100350 <panic>
  struct buf **pp;

  if(!(b->flags & B_BUSY))
    panic("iderw: buf not busy");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801022b5:	83 ec 0c             	sub    $0xc,%esp
801022b8:	68 93 71 10 80       	push   $0x80107193
801022bd:	e8 8e e0 ff ff       	call   80100350 <panic>
801022c2:	66 90                	xchg   %ax,%ax
801022c4:	66 90                	xchg   %ax,%ax
801022c6:	66 90                	xchg   %ax,%ax
801022c8:	66 90                	xchg   %ax,%ax
801022ca:	66 90                	xchg   %ax,%ax
801022cc:	66 90                	xchg   %ax,%ax
801022ce:	66 90                	xchg   %ax,%ax

801022d0 <ioapicinit>:
void
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
801022d0:	a1 c4 12 11 80       	mov    0x801112c4,%eax
801022d5:	85 c0                	test   %eax,%eax
801022d7:	0f 84 a8 00 00 00    	je     80102385 <ioapicinit+0xb5>
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022dd:	55                   	push   %ebp
  int i, id, maxintr;

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801022de:	c7 05 94 11 11 80 00 	movl   $0xfec00000,0x80111194
801022e5:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022e8:	89 e5                	mov    %esp,%ebp
801022ea:	56                   	push   %esi
801022eb:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801022ec:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801022f3:	00 00 00 
  return ioapic->data;
801022f6:	8b 15 94 11 11 80    	mov    0x80111194,%edx
801022fc:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801022ff:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102305:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010230b:	0f b6 15 c0 12 11 80 	movzbl 0x801112c0,%edx

  if(!ismp)
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102312:	89 f0                	mov    %esi,%eax
80102314:	c1 e8 10             	shr    $0x10,%eax
80102317:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010231a:	8b 41 10             	mov    0x10(%ecx),%eax
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010231d:	c1 e8 18             	shr    $0x18,%eax
80102320:	39 d0                	cmp    %edx,%eax
80102322:	74 16                	je     8010233a <ioapicinit+0x6a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102324:	83 ec 0c             	sub    $0xc,%esp
80102327:	68 c8 71 10 80       	push   $0x801071c8
8010232c:	e8 0f e3 ff ff       	call   80100640 <cprintf>
80102331:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
80102337:	83 c4 10             	add    $0x10,%esp
8010233a:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
8010233d:	ba 10 00 00 00       	mov    $0x10,%edx
80102342:	b8 20 00 00 00       	mov    $0x20,%eax
80102347:	89 f6                	mov    %esi,%esi
80102349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102350:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102352:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102358:	89 c3                	mov    %eax,%ebx
8010235a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102360:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102363:	89 59 10             	mov    %ebx,0x10(%ecx)
80102366:	8d 5a 01             	lea    0x1(%edx),%ebx
80102369:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010236c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010236e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102370:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
80102376:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010237d:	75 d1                	jne    80102350 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010237f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102382:	5b                   	pop    %ebx
80102383:	5e                   	pop    %esi
80102384:	5d                   	pop    %ebp
80102385:	f3 c3                	repz ret 
80102387:	89 f6                	mov    %esi,%esi
80102389:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102390 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
80102390:	8b 15 c4 12 11 80    	mov    0x801112c4,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102396:	55                   	push   %ebp
80102397:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102399:	85 d2                	test   %edx,%edx
  }
}

void
ioapicenable(int irq, int cpunum)
{
8010239b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!ismp)
8010239e:	74 2b                	je     801023cb <ioapicenable+0x3b>
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801023a0:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801023a6:	8d 50 20             	lea    0x20(%eax),%edx
801023a9:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801023ad:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023af:	8b 0d 94 11 11 80    	mov    0x80111194,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801023b5:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801023b8:	89 51 10             	mov    %edx,0x10(%ecx)

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023bb:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801023be:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023c0:	a1 94 11 11 80       	mov    0x80111194,%eax

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023c5:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801023c8:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801023cb:	5d                   	pop    %ebp
801023cc:	c3                   	ret    
801023cd:	66 90                	xchg   %ax,%ax
801023cf:	90                   	nop

801023d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801023d0:	55                   	push   %ebp
801023d1:	89 e5                	mov    %esp,%ebp
801023d3:	53                   	push   %ebx
801023d4:	83 ec 04             	sub    $0x4,%esp
801023d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801023da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801023e0:	75 70                	jne    80102452 <kfree+0x82>
801023e2:	81 fb 68 41 11 80    	cmp    $0x80114168,%ebx
801023e8:	72 68                	jb     80102452 <kfree+0x82>
801023ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801023f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801023f5:	77 5b                	ja     80102452 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801023f7:	83 ec 04             	sub    $0x4,%esp
801023fa:	68 00 10 00 00       	push   $0x1000
801023ff:	6a 01                	push   $0x1
80102401:	53                   	push   %ebx
80102402:	e8 d9 20 00 00       	call   801044e0 <memset>

  if(kmem.use_lock)
80102407:	8b 15 d4 11 11 80    	mov    0x801111d4,%edx
8010240d:	83 c4 10             	add    $0x10,%esp
80102410:	85 d2                	test   %edx,%edx
80102412:	75 2c                	jne    80102440 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102414:	a1 d8 11 11 80       	mov    0x801111d8,%eax
80102419:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010241b:	a1 d4 11 11 80       	mov    0x801111d4,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102420:	89 1d d8 11 11 80    	mov    %ebx,0x801111d8
  if(kmem.use_lock)
80102426:	85 c0                	test   %eax,%eax
80102428:	75 06                	jne    80102430 <kfree+0x60>
    release(&kmem.lock);
}
8010242a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010242d:	c9                   	leave  
8010242e:	c3                   	ret    
8010242f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102430:	c7 45 08 a0 11 11 80 	movl   $0x801111a0,0x8(%ebp)
}
80102437:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010243a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010243b:	e9 50 20 00 00       	jmp    80104490 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102440:	83 ec 0c             	sub    $0xc,%esp
80102443:	68 a0 11 11 80       	push   $0x801111a0
80102448:	e8 63 1e 00 00       	call   801042b0 <acquire>
8010244d:	83 c4 10             	add    $0x10,%esp
80102450:	eb c2                	jmp    80102414 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102452:	83 ec 0c             	sub    $0xc,%esp
80102455:	68 fa 71 10 80       	push   $0x801071fa
8010245a:	e8 f1 de ff ff       	call   80100350 <panic>
8010245f:	90                   	nop

80102460 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102465:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102468:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010246b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102471:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102477:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010247d:	39 de                	cmp    %ebx,%esi
8010247f:	72 23                	jb     801024a4 <freerange+0x44>
80102481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102488:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010248e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102491:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102497:	50                   	push   %eax
80102498:	e8 33 ff ff ff       	call   801023d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249d:	83 c4 10             	add    $0x10,%esp
801024a0:	39 f3                	cmp    %esi,%ebx
801024a2:	76 e4                	jbe    80102488 <freerange+0x28>
    kfree(p);
}
801024a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024a7:	5b                   	pop    %ebx
801024a8:	5e                   	pop    %esi
801024a9:	5d                   	pop    %ebp
801024aa:	c3                   	ret    
801024ab:	90                   	nop
801024ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024b0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	56                   	push   %esi
801024b4:	53                   	push   %ebx
801024b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024b8:	83 ec 08             	sub    $0x8,%esp
801024bb:	68 00 72 10 80       	push   $0x80107200
801024c0:	68 a0 11 11 80       	push   $0x801111a0
801024c5:	e8 c6 1d 00 00       	call   80104290 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024cd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801024d0:	c7 05 d4 11 11 80 00 	movl   $0x0,0x801111d4
801024d7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024da:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024e0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024e6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024ec:	39 de                	cmp    %ebx,%esi
801024ee:	72 1c                	jb     8010250c <kinit1+0x5c>
    kfree(p);
801024f0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024f6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024ff:	50                   	push   %eax
80102500:	e8 cb fe ff ff       	call   801023d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102505:	83 c4 10             	add    $0x10,%esp
80102508:	39 de                	cmp    %ebx,%esi
8010250a:	73 e4                	jae    801024f0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010250c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010250f:	5b                   	pop    %ebx
80102510:	5e                   	pop    %esi
80102511:	5d                   	pop    %ebp
80102512:	c3                   	ret    
80102513:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102520 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	56                   	push   %esi
80102524:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102525:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102528:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010252b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102531:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102537:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010253d:	39 de                	cmp    %ebx,%esi
8010253f:	72 23                	jb     80102564 <kinit2+0x44>
80102541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102548:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010254e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102551:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102557:	50                   	push   %eax
80102558:	e8 73 fe ff ff       	call   801023d0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	39 de                	cmp    %ebx,%esi
80102562:	73 e4                	jae    80102548 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102564:	c7 05 d4 11 11 80 01 	movl   $0x1,0x801111d4
8010256b:	00 00 00 
}
8010256e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102571:	5b                   	pop    %ebx
80102572:	5e                   	pop    %esi
80102573:	5d                   	pop    %ebp
80102574:	c3                   	ret    
80102575:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102580 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	53                   	push   %ebx
80102584:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102587:	a1 d4 11 11 80       	mov    0x801111d4,%eax
8010258c:	85 c0                	test   %eax,%eax
8010258e:	75 30                	jne    801025c0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102590:	8b 1d d8 11 11 80    	mov    0x801111d8,%ebx
  if(r)
80102596:	85 db                	test   %ebx,%ebx
80102598:	74 1c                	je     801025b6 <kalloc+0x36>
    kmem.freelist = r->next;
8010259a:	8b 13                	mov    (%ebx),%edx
8010259c:	89 15 d8 11 11 80    	mov    %edx,0x801111d8
  if(kmem.use_lock)
801025a2:	85 c0                	test   %eax,%eax
801025a4:	74 10                	je     801025b6 <kalloc+0x36>
    release(&kmem.lock);
801025a6:	83 ec 0c             	sub    $0xc,%esp
801025a9:	68 a0 11 11 80       	push   $0x801111a0
801025ae:	e8 dd 1e 00 00       	call   80104490 <release>
801025b3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801025b6:	89 d8                	mov    %ebx,%eax
801025b8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025bb:	c9                   	leave  
801025bc:	c3                   	ret    
801025bd:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801025c0:	83 ec 0c             	sub    $0xc,%esp
801025c3:	68 a0 11 11 80       	push   $0x801111a0
801025c8:	e8 e3 1c 00 00       	call   801042b0 <acquire>
  r = kmem.freelist;
801025cd:	8b 1d d8 11 11 80    	mov    0x801111d8,%ebx
  if(r)
801025d3:	83 c4 10             	add    $0x10,%esp
801025d6:	a1 d4 11 11 80       	mov    0x801111d4,%eax
801025db:	85 db                	test   %ebx,%ebx
801025dd:	75 bb                	jne    8010259a <kalloc+0x1a>
801025df:	eb c1                	jmp    801025a2 <kalloc+0x22>
801025e1:	66 90                	xchg   %ax,%ax
801025e3:	66 90                	xchg   %ax,%ax
801025e5:	66 90                	xchg   %ax,%ax
801025e7:	66 90                	xchg   %ax,%ax
801025e9:	66 90                	xchg   %ax,%ax
801025eb:	66 90                	xchg   %ax,%ax
801025ed:	66 90                	xchg   %ax,%ax
801025ef:	90                   	nop

801025f0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801025f0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025f1:	ba 64 00 00 00       	mov    $0x64,%edx
801025f6:	89 e5                	mov    %esp,%ebp
801025f8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801025f9:	a8 01                	test   $0x1,%al
801025fb:	0f 84 af 00 00 00    	je     801026b0 <kbdgetc+0xc0>
80102601:	ba 60 00 00 00       	mov    $0x60,%edx
80102606:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102607:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010260a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102610:	74 7e                	je     80102690 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102612:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102614:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010261a:	79 24                	jns    80102640 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010261c:	f6 c1 40             	test   $0x40,%cl
8010261f:	75 05                	jne    80102626 <kbdgetc+0x36>
80102621:	89 c2                	mov    %eax,%edx
80102623:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102626:	0f b6 82 40 73 10 80 	movzbl -0x7fef8cc0(%edx),%eax
8010262d:	83 c8 40             	or     $0x40,%eax
80102630:	0f b6 c0             	movzbl %al,%eax
80102633:	f7 d0                	not    %eax
80102635:	21 c8                	and    %ecx,%eax
80102637:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010263c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010263e:	5d                   	pop    %ebp
8010263f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102640:	f6 c1 40             	test   $0x40,%cl
80102643:	74 09                	je     8010264e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102645:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102648:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010264b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010264e:	0f b6 82 40 73 10 80 	movzbl -0x7fef8cc0(%edx),%eax
80102655:	09 c1                	or     %eax,%ecx
80102657:	0f b6 82 40 72 10 80 	movzbl -0x7fef8dc0(%edx),%eax
8010265e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102660:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102662:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102668:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010266b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010266e:	8b 04 85 20 72 10 80 	mov    -0x7fef8de0(,%eax,4),%eax
80102675:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102679:	74 c3                	je     8010263e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010267b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010267e:	83 fa 19             	cmp    $0x19,%edx
80102681:	77 1d                	ja     801026a0 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102683:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102686:	5d                   	pop    %ebp
80102687:	c3                   	ret    
80102688:	90                   	nop
80102689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102690:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102692:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102699:	5d                   	pop    %ebp
8010269a:	c3                   	ret    
8010269b:	90                   	nop
8010269c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801026a0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801026a3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801026a6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801026a7:	83 f9 19             	cmp    $0x19,%ecx
801026aa:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801026ad:	c3                   	ret    
801026ae:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801026b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801026b5:	5d                   	pop    %ebp
801026b6:	c3                   	ret    
801026b7:	89 f6                	mov    %esi,%esi
801026b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026c0 <kbdintr>:

void
kbdintr(void)
{
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801026c6:	68 f0 25 10 80       	push   $0x801025f0
801026cb:	e8 00 e1 ff ff       	call   801007d0 <consoleintr>
}
801026d0:	83 c4 10             	add    $0x10,%esp
801026d3:	c9                   	leave  
801026d4:	c3                   	ret    
801026d5:	66 90                	xchg   %ax,%ax
801026d7:	66 90                	xchg   %ax,%ax
801026d9:	66 90                	xchg   %ax,%ax
801026db:	66 90                	xchg   %ax,%ax
801026dd:	66 90                	xchg   %ax,%ax
801026df:	90                   	nop

801026e0 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
  if(!lapic)
801026e0:	a1 dc 11 11 80       	mov    0x801111dc,%eax
}
//PAGEBREAK!

void
lapicinit(void)
{
801026e5:	55                   	push   %ebp
801026e6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026e8:	85 c0                	test   %eax,%eax
801026ea:	0f 84 c8 00 00 00    	je     801027b8 <lapicinit+0xd8>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026f7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fa:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026fd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102704:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102707:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010270a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102711:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102714:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102717:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010271e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102721:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102724:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010272b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010272e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102731:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102738:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010273b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010273e:	8b 50 30             	mov    0x30(%eax),%edx
80102741:	c1 ea 10             	shr    $0x10,%edx
80102744:	80 fa 03             	cmp    $0x3,%dl
80102747:	77 77                	ja     801027c0 <lapicinit+0xe0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102749:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102750:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102753:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102756:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010275d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102760:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102763:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010276a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010276d:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102770:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102777:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010277a:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102784:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102787:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010278a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102791:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102794:	8b 50 20             	mov    0x20(%eax),%edx
80102797:	89 f6                	mov    %esi,%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801027a0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801027a6:	80 e6 10             	and    $0x10,%dh
801027a9:	75 f5                	jne    801027a0 <lapicinit+0xc0>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027ab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801027b2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801027b8:	5d                   	pop    %ebp
801027b9:	c3                   	ret    
801027ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027c0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801027c7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ca:	8b 50 20             	mov    0x20(%eax),%edx
801027cd:	e9 77 ff ff ff       	jmp    80102749 <lapicinit+0x69>
801027d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027e0 <cpunum>:
  lapicw(TPR, 0);
}

int
cpunum(void)
{
801027e0:	55                   	push   %ebp
801027e1:	89 e5                	mov    %esp,%ebp
801027e3:	56                   	push   %esi
801027e4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801027e5:	9c                   	pushf  
801027e6:	58                   	pop    %eax
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
801027e7:	f6 c4 02             	test   $0x2,%ah
801027ea:	74 12                	je     801027fe <cpunum+0x1e>
    static int n;
    if(n++ == 0)
801027ec:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
801027f1:	8d 50 01             	lea    0x1(%eax),%edx
801027f4:	85 c0                	test   %eax,%eax
801027f6:	89 15 b8 a5 10 80    	mov    %edx,0x8010a5b8
801027fc:	74 4d                	je     8010284b <cpunum+0x6b>
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
801027fe:	a1 dc 11 11 80       	mov    0x801111dc,%eax
80102803:	85 c0                	test   %eax,%eax
80102805:	74 60                	je     80102867 <cpunum+0x87>
    return 0;

  apicid = lapic[ID] >> 24;
80102807:	8b 58 20             	mov    0x20(%eax),%ebx
  for (i = 0; i < ncpu; ++i) {
8010280a:	8b 35 c0 18 11 80    	mov    0x801118c0,%esi
  }

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
80102810:	c1 eb 18             	shr    $0x18,%ebx
  for (i = 0; i < ncpu; ++i) {
80102813:	85 f6                	test   %esi,%esi
80102815:	7e 59                	jle    80102870 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102817:	0f b6 05 e0 12 11 80 	movzbl 0x801112e0,%eax
8010281e:	39 c3                	cmp    %eax,%ebx
80102820:	74 45                	je     80102867 <cpunum+0x87>
80102822:	ba 9c 13 11 80       	mov    $0x8011139c,%edx
80102827:	31 c0                	xor    %eax,%eax
80102829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  if (!lapic)
    return 0;

  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
80102830:	83 c0 01             	add    $0x1,%eax
80102833:	39 f0                	cmp    %esi,%eax
80102835:	74 39                	je     80102870 <cpunum+0x90>
    if (cpus[i].apicid == apicid)
80102837:	0f b6 0a             	movzbl (%edx),%ecx
8010283a:	81 c2 bc 00 00 00    	add    $0xbc,%edx
80102840:	39 cb                	cmp    %ecx,%ebx
80102842:	75 ec                	jne    80102830 <cpunum+0x50>
      return i;
  }
  panic("unknown apicid\n");
}
80102844:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102847:	5b                   	pop    %ebx
80102848:	5e                   	pop    %esi
80102849:	5d                   	pop    %ebp
8010284a:	c3                   	ret    
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
8010284b:	83 ec 08             	sub    $0x8,%esp
8010284e:	ff 75 04             	pushl  0x4(%ebp)
80102851:	68 40 74 10 80       	push   $0x80107440
80102856:	e8 e5 dd ff ff       	call   80100640 <cprintf>
        __builtin_return_address(0));
  }

  if (!lapic)
8010285b:	a1 dc 11 11 80       	mov    0x801111dc,%eax
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
    static int n;
    if(n++ == 0)
      cprintf("cpu called from %x with interrupts enabled\n",
80102860:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if (!lapic)
80102863:	85 c0                	test   %eax,%eax
80102865:	75 a0                	jne    80102807 <cpunum+0x27>
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
80102867:	8d 65 f8             	lea    -0x8(%ebp),%esp
      cprintf("cpu called from %x with interrupts enabled\n",
        __builtin_return_address(0));
  }

  if (!lapic)
    return 0;
8010286a:	31 c0                	xor    %eax,%eax
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
}
8010286c:	5b                   	pop    %ebx
8010286d:	5e                   	pop    %esi
8010286e:	5d                   	pop    %ebp
8010286f:	c3                   	ret    
  apicid = lapic[ID] >> 24;
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return i;
  }
  panic("unknown apicid\n");
80102870:	83 ec 0c             	sub    $0xc,%esp
80102873:	68 6c 74 10 80       	push   $0x8010746c
80102878:	e8 d3 da ff ff       	call   80100350 <panic>
8010287d:	8d 76 00             	lea    0x0(%esi),%esi

80102880 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102880:	a1 dc 11 11 80       	mov    0x801111dc,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102885:	55                   	push   %ebp
80102886:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102888:	85 c0                	test   %eax,%eax
8010288a:	74 0d                	je     80102899 <lapiceoi+0x19>
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010288c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102893:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102896:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102899:	5d                   	pop    %ebp
8010289a:	c3                   	ret    
8010289b:	90                   	nop
8010289c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801028a0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801028a0:	55                   	push   %ebp
801028a1:	89 e5                	mov    %esp,%ebp
}
801028a3:	5d                   	pop    %ebp
801028a4:	c3                   	ret    
801028a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028b0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801028b0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b1:	ba 70 00 00 00       	mov    $0x70,%edx
801028b6:	b8 0f 00 00 00       	mov    $0xf,%eax
801028bb:	89 e5                	mov    %esp,%ebp
801028bd:	53                   	push   %ebx
801028be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801028c4:	ee                   	out    %al,(%dx)
801028c5:	ba 71 00 00 00       	mov    $0x71,%edx
801028ca:	b8 0a 00 00 00       	mov    $0xa,%eax
801028cf:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801028d0:	31 c0                	xor    %eax,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028d2:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801028d5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801028db:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028dd:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801028e0:	c1 e8 04             	shr    $0x4,%eax
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028e3:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801028e5:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
801028e8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028ee:	a1 dc 11 11 80       	mov    0x801111dc,%eax
801028f3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028f9:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
801028fc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102903:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102906:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102909:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102910:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102913:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102916:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010291c:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010291f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102925:	8b 58 20             	mov    0x20(%eax),%ebx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102928:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010292e:	8b 50 20             	mov    0x20(%eax),%edx
volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102931:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102937:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010293a:	5b                   	pop    %ebx
8010293b:	5d                   	pop    %ebp
8010293c:	c3                   	ret    
8010293d:	8d 76 00             	lea    0x0(%esi),%esi

80102940 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102940:	55                   	push   %ebp
80102941:	ba 70 00 00 00       	mov    $0x70,%edx
80102946:	b8 0b 00 00 00       	mov    $0xb,%eax
8010294b:	89 e5                	mov    %esp,%ebp
8010294d:	57                   	push   %edi
8010294e:	56                   	push   %esi
8010294f:	53                   	push   %ebx
80102950:	83 ec 4c             	sub    $0x4c,%esp
80102953:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102954:	ba 71 00 00 00       	mov    $0x71,%edx
80102959:	ec                   	in     (%dx),%al
8010295a:	83 e0 04             	and    $0x4,%eax
8010295d:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102960:	31 db                	xor    %ebx,%ebx
80102962:	88 45 b7             	mov    %al,-0x49(%ebp)
80102965:	bf 70 00 00 00       	mov    $0x70,%edi
8010296a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102970:	89 d8                	mov    %ebx,%eax
80102972:	89 fa                	mov    %edi,%edx
80102974:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102975:	b9 71 00 00 00       	mov    $0x71,%ecx
8010297a:	89 ca                	mov    %ecx,%edx
8010297c:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010297d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102980:	89 fa                	mov    %edi,%edx
80102982:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102985:	b8 02 00 00 00       	mov    $0x2,%eax
8010298a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010298b:	89 ca                	mov    %ecx,%edx
8010298d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010298e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102991:	89 fa                	mov    %edi,%edx
80102993:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102996:	b8 04 00 00 00       	mov    $0x4,%eax
8010299b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010299c:	89 ca                	mov    %ecx,%edx
8010299e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010299f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a2:	89 fa                	mov    %edi,%edx
801029a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
801029a7:	b8 07 00 00 00       	mov    $0x7,%eax
801029ac:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ad:	89 ca                	mov    %ecx,%edx
801029af:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801029b0:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b3:	89 fa                	mov    %edi,%edx
801029b5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801029b8:	b8 08 00 00 00       	mov    $0x8,%eax
801029bd:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029be:	89 ca                	mov    %ecx,%edx
801029c0:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801029c1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c4:	89 fa                	mov    %edi,%edx
801029c6:	89 45 c8             	mov    %eax,-0x38(%ebp)
801029c9:	b8 09 00 00 00       	mov    $0x9,%eax
801029ce:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029cf:	89 ca                	mov    %ecx,%edx
801029d1:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801029d2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d5:	89 fa                	mov    %edi,%edx
801029d7:	89 45 cc             	mov    %eax,-0x34(%ebp)
801029da:	b8 0a 00 00 00       	mov    $0xa,%eax
801029df:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029e0:	89 ca                	mov    %ecx,%edx
801029e2:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801029e3:	84 c0                	test   %al,%al
801029e5:	78 89                	js     80102970 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e7:	89 d8                	mov    %ebx,%eax
801029e9:	89 fa                	mov    %edi,%edx
801029eb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ec:	89 ca                	mov    %ecx,%edx
801029ee:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801029ef:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f2:	89 fa                	mov    %edi,%edx
801029f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801029f7:	b8 02 00 00 00       	mov    $0x2,%eax
801029fc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029fd:	89 ca                	mov    %ecx,%edx
801029ff:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102a00:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a03:	89 fa                	mov    %edi,%edx
80102a05:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a08:	b8 04 00 00 00       	mov    $0x4,%eax
80102a0d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0e:	89 ca                	mov    %ecx,%edx
80102a10:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102a11:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a14:	89 fa                	mov    %edi,%edx
80102a16:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102a19:	b8 07 00 00 00       	mov    $0x7,%eax
80102a1e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1f:	89 ca                	mov    %ecx,%edx
80102a21:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102a22:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a25:	89 fa                	mov    %edi,%edx
80102a27:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102a2a:	b8 08 00 00 00       	mov    $0x8,%eax
80102a2f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a30:	89 ca                	mov    %ecx,%edx
80102a32:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102a33:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a36:	89 fa                	mov    %edi,%edx
80102a38:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a3b:	b8 09 00 00 00       	mov    $0x9,%eax
80102a40:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a41:	89 ca                	mov    %ecx,%edx
80102a43:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102a44:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a47:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
80102a4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a4d:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a50:	6a 18                	push   $0x18
80102a52:	56                   	push   %esi
80102a53:	50                   	push   %eax
80102a54:	e8 d7 1a 00 00       	call   80104530 <memcmp>
80102a59:	83 c4 10             	add    $0x10,%esp
80102a5c:	85 c0                	test   %eax,%eax
80102a5e:	0f 85 0c ff ff ff    	jne    80102970 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102a64:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102a68:	75 78                	jne    80102ae2 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a6a:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a6d:	89 c2                	mov    %eax,%edx
80102a6f:	83 e0 0f             	and    $0xf,%eax
80102a72:	c1 ea 04             	shr    $0x4,%edx
80102a75:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a78:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a7b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a7e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a81:	89 c2                	mov    %eax,%edx
80102a83:	83 e0 0f             	and    $0xf,%eax
80102a86:	c1 ea 04             	shr    $0x4,%edx
80102a89:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a8c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a8f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a92:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a95:	89 c2                	mov    %eax,%edx
80102a97:	83 e0 0f             	and    $0xf,%eax
80102a9a:	c1 ea 04             	shr    $0x4,%edx
80102a9d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aa0:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102aa3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102aa6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102aa9:	89 c2                	mov    %eax,%edx
80102aab:	83 e0 0f             	and    $0xf,%eax
80102aae:	c1 ea 04             	shr    $0x4,%edx
80102ab1:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ab4:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ab7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102aba:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102abd:	89 c2                	mov    %eax,%edx
80102abf:	83 e0 0f             	and    $0xf,%eax
80102ac2:	c1 ea 04             	shr    $0x4,%edx
80102ac5:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ac8:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102acb:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102ace:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ad1:	89 c2                	mov    %eax,%edx
80102ad3:	83 e0 0f             	and    $0xf,%eax
80102ad6:	c1 ea 04             	shr    $0x4,%edx
80102ad9:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102adc:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102adf:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ae2:	8b 75 08             	mov    0x8(%ebp),%esi
80102ae5:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ae8:	89 06                	mov    %eax,(%esi)
80102aea:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102aed:	89 46 04             	mov    %eax,0x4(%esi)
80102af0:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102af3:	89 46 08             	mov    %eax,0x8(%esi)
80102af6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102af9:	89 46 0c             	mov    %eax,0xc(%esi)
80102afc:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102aff:	89 46 10             	mov    %eax,0x10(%esi)
80102b02:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b05:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b08:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102b0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b12:	5b                   	pop    %ebx
80102b13:	5e                   	pop    %esi
80102b14:	5f                   	pop    %edi
80102b15:	5d                   	pop    %ebp
80102b16:	c3                   	ret    
80102b17:	66 90                	xchg   %ax,%ax
80102b19:	66 90                	xchg   %ax,%ax
80102b1b:	66 90                	xchg   %ax,%ax
80102b1d:	66 90                	xchg   %ax,%ax
80102b1f:	90                   	nop

80102b20 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b20:	8b 0d 28 12 11 80    	mov    0x80111228,%ecx
80102b26:	85 c9                	test   %ecx,%ecx
80102b28:	0f 8e 85 00 00 00    	jle    80102bb3 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102b2e:	55                   	push   %ebp
80102b2f:	89 e5                	mov    %esp,%ebp
80102b31:	57                   	push   %edi
80102b32:	56                   	push   %esi
80102b33:	53                   	push   %ebx
80102b34:	31 db                	xor    %ebx,%ebx
80102b36:	83 ec 0c             	sub    $0xc,%esp
80102b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b40:	a1 14 12 11 80       	mov    0x80111214,%eax
80102b45:	83 ec 08             	sub    $0x8,%esp
80102b48:	01 d8                	add    %ebx,%eax
80102b4a:	83 c0 01             	add    $0x1,%eax
80102b4d:	50                   	push   %eax
80102b4e:	ff 35 24 12 11 80    	pushl  0x80111224
80102b54:	e8 67 d5 ff ff       	call   801000c0 <bread>
80102b59:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b5b:	58                   	pop    %eax
80102b5c:	5a                   	pop    %edx
80102b5d:	ff 34 9d 2c 12 11 80 	pushl  -0x7feeedd4(,%ebx,4)
80102b64:	ff 35 24 12 11 80    	pushl  0x80111224
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b6a:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b6d:	e8 4e d5 ff ff       	call   801000c0 <bread>
80102b72:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b74:	8d 47 18             	lea    0x18(%edi),%eax
80102b77:	83 c4 0c             	add    $0xc,%esp
80102b7a:	68 00 02 00 00       	push   $0x200
80102b7f:	50                   	push   %eax
80102b80:	8d 46 18             	lea    0x18(%esi),%eax
80102b83:	50                   	push   %eax
80102b84:	e8 07 1a 00 00       	call   80104590 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b89:	89 34 24             	mov    %esi,(%esp)
80102b8c:	e8 0f d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102b91:	89 3c 24             	mov    %edi,(%esp)
80102b94:	e8 37 d6 ff ff       	call   801001d0 <brelse>
    brelse(dbuf);
80102b99:	89 34 24             	mov    %esi,(%esp)
80102b9c:	e8 2f d6 ff ff       	call   801001d0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ba1:	83 c4 10             	add    $0x10,%esp
80102ba4:	39 1d 28 12 11 80    	cmp    %ebx,0x80111228
80102baa:	7f 94                	jg     80102b40 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102bac:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102baf:	5b                   	pop    %ebx
80102bb0:	5e                   	pop    %esi
80102bb1:	5f                   	pop    %edi
80102bb2:	5d                   	pop    %ebp
80102bb3:	f3 c3                	repz ret 
80102bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bc0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	53                   	push   %ebx
80102bc4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102bc7:	ff 35 14 12 11 80    	pushl  0x80111214
80102bcd:	ff 35 24 12 11 80    	pushl  0x80111224
80102bd3:	e8 e8 d4 ff ff       	call   801000c0 <bread>
80102bd8:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102bda:	a1 28 12 11 80       	mov    0x80111228,%eax
  for (i = 0; i < log.lh.n; i++) {
80102bdf:	83 c4 10             	add    $0x10,%esp
80102be2:	31 d2                	xor    %edx,%edx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102be4:	89 43 18             	mov    %eax,0x18(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102be7:	a1 28 12 11 80       	mov    0x80111228,%eax
80102bec:	85 c0                	test   %eax,%eax
80102bee:	7e 16                	jle    80102c06 <write_head+0x46>
    hb->block[i] = log.lh.block[i];
80102bf0:	8b 0c 95 2c 12 11 80 	mov    -0x7feeedd4(,%edx,4),%ecx
80102bf7:	89 4c 93 1c          	mov    %ecx,0x1c(%ebx,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102bfb:	83 c2 01             	add    $0x1,%edx
80102bfe:	39 15 28 12 11 80    	cmp    %edx,0x80111228
80102c04:	7f ea                	jg     80102bf0 <write_head+0x30>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102c06:	83 ec 0c             	sub    $0xc,%esp
80102c09:	53                   	push   %ebx
80102c0a:	e8 91 d5 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102c0f:	89 1c 24             	mov    %ebx,(%esp)
80102c12:	e8 b9 d5 ff ff       	call   801001d0 <brelse>
}
80102c17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c1a:	c9                   	leave  
80102c1b:	c3                   	ret    
80102c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102c20 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	53                   	push   %ebx
80102c24:	83 ec 2c             	sub    $0x2c,%esp
80102c27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102c2a:	68 7c 74 10 80       	push   $0x8010747c
80102c2f:	68 e0 11 11 80       	push   $0x801111e0
80102c34:	e8 57 16 00 00       	call   80104290 <initlock>
  readsb(dev, &sb);
80102c39:	58                   	pop    %eax
80102c3a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c3d:	5a                   	pop    %edx
80102c3e:	50                   	push   %eax
80102c3f:	53                   	push   %ebx
80102c40:	e8 3b e8 ff ff       	call   80101480 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102c45:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102c48:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102c4b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102c4c:	89 1d 24 12 11 80    	mov    %ebx,0x80111224

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102c52:	89 15 18 12 11 80    	mov    %edx,0x80111218
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102c58:	a3 14 12 11 80       	mov    %eax,0x80111214

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102c5d:	5a                   	pop    %edx
80102c5e:	50                   	push   %eax
80102c5f:	53                   	push   %ebx
80102c60:	e8 5b d4 ff ff       	call   801000c0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102c65:	8b 48 18             	mov    0x18(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102c68:	83 c4 10             	add    $0x10,%esp
80102c6b:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102c6d:	89 0d 28 12 11 80    	mov    %ecx,0x80111228
  for (i = 0; i < log.lh.n; i++) {
80102c73:	7e 1c                	jle    80102c91 <initlog+0x71>
80102c75:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102c7c:	31 d2                	xor    %edx,%edx
80102c7e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102c80:	8b 4c 10 1c          	mov    0x1c(%eax,%edx,1),%ecx
80102c84:	83 c2 04             	add    $0x4,%edx
80102c87:	89 8a 28 12 11 80    	mov    %ecx,-0x7feeedd8(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102c8d:	39 da                	cmp    %ebx,%edx
80102c8f:	75 ef                	jne    80102c80 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102c91:	83 ec 0c             	sub    $0xc,%esp
80102c94:	50                   	push   %eax
80102c95:	e8 36 d5 ff ff       	call   801001d0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102c9a:	e8 81 fe ff ff       	call   80102b20 <install_trans>
  log.lh.n = 0;
80102c9f:	c7 05 28 12 11 80 00 	movl   $0x0,0x80111228
80102ca6:	00 00 00 
  write_head(); // clear the log
80102ca9:	e8 12 ff ff ff       	call   80102bc0 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102cae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cb1:	c9                   	leave  
80102cb2:	c3                   	ret    
80102cb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cc0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102cc6:	68 e0 11 11 80       	push   $0x801111e0
80102ccb:	e8 e0 15 00 00       	call   801042b0 <acquire>
80102cd0:	83 c4 10             	add    $0x10,%esp
80102cd3:	eb 18                	jmp    80102ced <begin_op+0x2d>
80102cd5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102cd8:	83 ec 08             	sub    $0x8,%esp
80102cdb:	68 e0 11 11 80       	push   $0x801111e0
80102ce0:	68 e0 11 11 80       	push   $0x801111e0
80102ce5:	e8 26 12 00 00       	call   80103f10 <sleep>
80102cea:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102ced:	a1 20 12 11 80       	mov    0x80111220,%eax
80102cf2:	85 c0                	test   %eax,%eax
80102cf4:	75 e2                	jne    80102cd8 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102cf6:	a1 1c 12 11 80       	mov    0x8011121c,%eax
80102cfb:	8b 15 28 12 11 80    	mov    0x80111228,%edx
80102d01:	83 c0 01             	add    $0x1,%eax
80102d04:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d07:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d0a:	83 fa 1e             	cmp    $0x1e,%edx
80102d0d:	7f c9                	jg     80102cd8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d0f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102d12:	a3 1c 12 11 80       	mov    %eax,0x8011121c
      release(&log.lock);
80102d17:	68 e0 11 11 80       	push   $0x801111e0
80102d1c:	e8 6f 17 00 00       	call   80104490 <release>
      break;
    }
  }
}
80102d21:	83 c4 10             	add    $0x10,%esp
80102d24:	c9                   	leave  
80102d25:	c3                   	ret    
80102d26:	8d 76 00             	lea    0x0(%esi),%esi
80102d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d30 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	57                   	push   %edi
80102d34:	56                   	push   %esi
80102d35:	53                   	push   %ebx
80102d36:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d39:	68 e0 11 11 80       	push   $0x801111e0
80102d3e:	e8 6d 15 00 00       	call   801042b0 <acquire>
  log.outstanding -= 1;
80102d43:	a1 1c 12 11 80       	mov    0x8011121c,%eax
  if(log.committing)
80102d48:	8b 1d 20 12 11 80    	mov    0x80111220,%ebx
80102d4e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102d51:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102d54:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102d56:	a3 1c 12 11 80       	mov    %eax,0x8011121c
  if(log.committing)
80102d5b:	0f 85 23 01 00 00    	jne    80102e84 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102d61:	85 c0                	test   %eax,%eax
80102d63:	0f 85 f7 00 00 00    	jne    80102e60 <end_op+0x130>
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102d69:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102d6c:	c7 05 20 12 11 80 01 	movl   $0x1,0x80111220
80102d73:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d76:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
  }
  release(&log.lock);
80102d78:	68 e0 11 11 80       	push   $0x801111e0
80102d7d:	e8 0e 17 00 00       	call   80104490 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d82:	8b 0d 28 12 11 80    	mov    0x80111228,%ecx
80102d88:	83 c4 10             	add    $0x10,%esp
80102d8b:	85 c9                	test   %ecx,%ecx
80102d8d:	0f 8e 8a 00 00 00    	jle    80102e1d <end_op+0xed>
80102d93:	90                   	nop
80102d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102d98:	a1 14 12 11 80       	mov    0x80111214,%eax
80102d9d:	83 ec 08             	sub    $0x8,%esp
80102da0:	01 d8                	add    %ebx,%eax
80102da2:	83 c0 01             	add    $0x1,%eax
80102da5:	50                   	push   %eax
80102da6:	ff 35 24 12 11 80    	pushl  0x80111224
80102dac:	e8 0f d3 ff ff       	call   801000c0 <bread>
80102db1:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102db3:	58                   	pop    %eax
80102db4:	5a                   	pop    %edx
80102db5:	ff 34 9d 2c 12 11 80 	pushl  -0x7feeedd4(,%ebx,4)
80102dbc:	ff 35 24 12 11 80    	pushl  0x80111224
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102dc2:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dc5:	e8 f6 d2 ff ff       	call   801000c0 <bread>
80102dca:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102dcc:	8d 40 18             	lea    0x18(%eax),%eax
80102dcf:	83 c4 0c             	add    $0xc,%esp
80102dd2:	68 00 02 00 00       	push   $0x200
80102dd7:	50                   	push   %eax
80102dd8:	8d 46 18             	lea    0x18(%esi),%eax
80102ddb:	50                   	push   %eax
80102ddc:	e8 af 17 00 00       	call   80104590 <memmove>
    bwrite(to);  // write the log
80102de1:	89 34 24             	mov    %esi,(%esp)
80102de4:	e8 b7 d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102de9:	89 3c 24             	mov    %edi,(%esp)
80102dec:	e8 df d3 ff ff       	call   801001d0 <brelse>
    brelse(to);
80102df1:	89 34 24             	mov    %esi,(%esp)
80102df4:	e8 d7 d3 ff ff       	call   801001d0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102df9:	83 c4 10             	add    $0x10,%esp
80102dfc:	3b 1d 28 12 11 80    	cmp    0x80111228,%ebx
80102e02:	7c 94                	jl     80102d98 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e04:	e8 b7 fd ff ff       	call   80102bc0 <write_head>
    install_trans(); // Now install writes to home locations
80102e09:	e8 12 fd ff ff       	call   80102b20 <install_trans>
    log.lh.n = 0;
80102e0e:	c7 05 28 12 11 80 00 	movl   $0x0,0x80111228
80102e15:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e18:	e8 a3 fd ff ff       	call   80102bc0 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102e1d:	83 ec 0c             	sub    $0xc,%esp
80102e20:	68 e0 11 11 80       	push   $0x801111e0
80102e25:	e8 86 14 00 00       	call   801042b0 <acquire>
    log.committing = 0;
    wakeup(&log);
80102e2a:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102e31:	c7 05 20 12 11 80 00 	movl   $0x0,0x80111220
80102e38:	00 00 00 
    wakeup(&log);
80102e3b:	e8 90 12 00 00       	call   801040d0 <wakeup>
    release(&log.lock);
80102e40:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102e47:	e8 44 16 00 00       	call   80104490 <release>
80102e4c:	83 c4 10             	add    $0x10,%esp
  }
}
80102e4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e52:	5b                   	pop    %ebx
80102e53:	5e                   	pop    %esi
80102e54:	5f                   	pop    %edi
80102e55:	5d                   	pop    %ebp
80102e56:	c3                   	ret    
80102e57:	89 f6                	mov    %esi,%esi
80102e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80102e60:	83 ec 0c             	sub    $0xc,%esp
80102e63:	68 e0 11 11 80       	push   $0x801111e0
80102e68:	e8 63 12 00 00       	call   801040d0 <wakeup>
  }
  release(&log.lock);
80102e6d:	c7 04 24 e0 11 11 80 	movl   $0x801111e0,(%esp)
80102e74:	e8 17 16 00 00       	call   80104490 <release>
80102e79:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e7f:	5b                   	pop    %ebx
80102e80:	5e                   	pop    %esi
80102e81:	5f                   	pop    %edi
80102e82:	5d                   	pop    %ebp
80102e83:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102e84:	83 ec 0c             	sub    $0xc,%esp
80102e87:	68 80 74 10 80       	push   $0x80107480
80102e8c:	e8 bf d4 ff ff       	call   80100350 <panic>
80102e91:	eb 0d                	jmp    80102ea0 <log_write>
80102e93:	90                   	nop
80102e94:	90                   	nop
80102e95:	90                   	nop
80102e96:	90                   	nop
80102e97:	90                   	nop
80102e98:	90                   	nop
80102e99:	90                   	nop
80102e9a:	90                   	nop
80102e9b:	90                   	nop
80102e9c:	90                   	nop
80102e9d:	90                   	nop
80102e9e:	90                   	nop
80102e9f:	90                   	nop

80102ea0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	53                   	push   %ebx
80102ea4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ea7:	8b 15 28 12 11 80    	mov    0x80111228,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ead:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102eb0:	83 fa 1d             	cmp    $0x1d,%edx
80102eb3:	0f 8f 97 00 00 00    	jg     80102f50 <log_write+0xb0>
80102eb9:	a1 18 12 11 80       	mov    0x80111218,%eax
80102ebe:	83 e8 01             	sub    $0x1,%eax
80102ec1:	39 c2                	cmp    %eax,%edx
80102ec3:	0f 8d 87 00 00 00    	jge    80102f50 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ec9:	a1 1c 12 11 80       	mov    0x8011121c,%eax
80102ece:	85 c0                	test   %eax,%eax
80102ed0:	0f 8e 87 00 00 00    	jle    80102f5d <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102ed6:	83 ec 0c             	sub    $0xc,%esp
80102ed9:	68 e0 11 11 80       	push   $0x801111e0
80102ede:	e8 cd 13 00 00       	call   801042b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102ee3:	8b 15 28 12 11 80    	mov    0x80111228,%edx
80102ee9:	83 c4 10             	add    $0x10,%esp
80102eec:	83 fa 00             	cmp    $0x0,%edx
80102eef:	7e 50                	jle    80102f41 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ef1:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102ef4:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ef6:	3b 0d 2c 12 11 80    	cmp    0x8011122c,%ecx
80102efc:	75 0b                	jne    80102f09 <log_write+0x69>
80102efe:	eb 38                	jmp    80102f38 <log_write+0x98>
80102f00:	39 0c 85 2c 12 11 80 	cmp    %ecx,-0x7feeedd4(,%eax,4)
80102f07:	74 2f                	je     80102f38 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102f09:	83 c0 01             	add    $0x1,%eax
80102f0c:	39 d0                	cmp    %edx,%eax
80102f0e:	75 f0                	jne    80102f00 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102f10:	89 0c 95 2c 12 11 80 	mov    %ecx,-0x7feeedd4(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f17:	83 c2 01             	add    $0x1,%edx
80102f1a:	89 15 28 12 11 80    	mov    %edx,0x80111228
  b->flags |= B_DIRTY; // prevent eviction
80102f20:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102f23:	c7 45 08 e0 11 11 80 	movl   $0x801111e0,0x8(%ebp)
}
80102f2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f2d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102f2e:	e9 5d 15 00 00       	jmp    80104490 <release>
80102f33:	90                   	nop
80102f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102f38:	89 0c 85 2c 12 11 80 	mov    %ecx,-0x7feeedd4(,%eax,4)
80102f3f:	eb df                	jmp    80102f20 <log_write+0x80>
80102f41:	8b 43 08             	mov    0x8(%ebx),%eax
80102f44:	a3 2c 12 11 80       	mov    %eax,0x8011122c
  if (i == log.lh.n)
80102f49:	75 d5                	jne    80102f20 <log_write+0x80>
80102f4b:	eb ca                	jmp    80102f17 <log_write+0x77>
80102f4d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102f50:	83 ec 0c             	sub    $0xc,%esp
80102f53:	68 8f 74 10 80       	push   $0x8010748f
80102f58:	e8 f3 d3 ff ff       	call   80100350 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102f5d:	83 ec 0c             	sub    $0xc,%esp
80102f60:	68 a5 74 10 80       	push   $0x801074a5
80102f65:	e8 e6 d3 ff ff       	call   80100350 <panic>
80102f6a:	66 90                	xchg   %ax,%ax
80102f6c:	66 90                	xchg   %ax,%ax
80102f6e:	66 90                	xchg   %ax,%ax

80102f70 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102f70:	55                   	push   %ebp
80102f71:	89 e5                	mov    %esp,%ebp
80102f73:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpunum());
80102f76:	e8 65 f8 ff ff       	call   801027e0 <cpunum>
80102f7b:	83 ec 08             	sub    $0x8,%esp
80102f7e:	50                   	push   %eax
80102f7f:	68 c0 74 10 80       	push   $0x801074c0
80102f84:	e8 b7 d6 ff ff       	call   80100640 <cprintf>
  idtinit();       // load idt register
80102f89:	e8 52 28 00 00       	call   801057e0 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80102f8e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f95:	b8 01 00 00 00       	mov    $0x1,%eax
80102f9a:	f0 87 82 a8 00 00 00 	lock xchg %eax,0xa8(%edx)
  scheduler();     // start running processes
80102fa1:	e8 8a 0c 00 00       	call   80103c30 <scheduler>
80102fa6:	8d 76 00             	lea    0x0(%esi),%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fb0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102fb6:	e8 35 3a 00 00       	call   801069f0 <switchkvm>
  seginit();
80102fbb:	e8 50 38 00 00       	call   80106810 <seginit>
  lapicinit();
80102fc0:	e8 1b f7 ff ff       	call   801026e0 <lapicinit>
  mpmain();
80102fc5:	e8 a6 ff ff ff       	call   80102f70 <mpmain>
80102fca:	66 90                	xchg   %ax,%ax
80102fcc:	66 90                	xchg   %ax,%ax
80102fce:	66 90                	xchg   %ax,%ax

80102fd0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102fd0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102fd4:	83 e4 f0             	and    $0xfffffff0,%esp
80102fd7:	ff 71 fc             	pushl  -0x4(%ecx)
80102fda:	55                   	push   %ebp
80102fdb:	89 e5                	mov    %esp,%ebp
80102fdd:	53                   	push   %ebx
80102fde:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102fdf:	83 ec 08             	sub    $0x8,%esp
80102fe2:	68 00 00 40 80       	push   $0x80400000
80102fe7:	68 68 41 11 80       	push   $0x80114168
80102fec:	e8 bf f4 ff ff       	call   801024b0 <kinit1>
  kvmalloc();      // kernel page table
80102ff1:	e8 da 39 00 00       	call   801069d0 <kvmalloc>
  mpinit();        // detect other processors
80102ff6:	e8 b5 01 00 00       	call   801031b0 <mpinit>
  lapicinit();     // interrupt controller
80102ffb:	e8 e0 f6 ff ff       	call   801026e0 <lapicinit>
  seginit();       // segment descriptors
80103000:	e8 0b 38 00 00       	call   80106810 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpunum());
80103005:	e8 d6 f7 ff ff       	call   801027e0 <cpunum>
8010300a:	5a                   	pop    %edx
8010300b:	59                   	pop    %ecx
8010300c:	50                   	push   %eax
8010300d:	68 d1 74 10 80       	push   $0x801074d1
80103012:	e8 29 d6 ff ff       	call   80100640 <cprintf>
  picinit();       // another interrupt controller
80103017:	e8 a4 03 00 00       	call   801033c0 <picinit>
  ioapicinit();    // another interrupt controller
8010301c:	e8 af f2 ff ff       	call   801022d0 <ioapicinit>
  consoleinit();   // console hardware
80103021:	e8 5a d9 ff ff       	call   80100980 <consoleinit>
  uartinit();      // serial port
80103026:	e8 b5 2a 00 00       	call   80105ae0 <uartinit>
  pinit();         // process table
8010302b:	e8 10 09 00 00       	call   80103940 <pinit>
  tvinit();        // trap vectors
80103030:	e8 0b 27 00 00       	call   80105740 <tvinit>
  binit();         // buffer cache
80103035:	e8 06 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010303a:	e8 f1 dd ff ff       	call   80100e30 <fileinit>
  ideinit();       // disk
8010303f:	e8 6c f0 ff ff       	call   801020b0 <ideinit>
  if(!ismp)
80103044:	8b 1d c4 12 11 80    	mov    0x801112c4,%ebx
8010304a:	83 c4 10             	add    $0x10,%esp
8010304d:	85 db                	test   %ebx,%ebx
8010304f:	0f 84 ca 00 00 00    	je     8010311f <main+0x14f>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103055:	83 ec 04             	sub    $0x4,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103058:	bb e0 12 11 80       	mov    $0x801112e0,%ebx

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010305d:	68 8a 00 00 00       	push   $0x8a
80103062:	68 8c a4 10 80       	push   $0x8010a48c
80103067:	68 00 70 00 80       	push   $0x80007000
8010306c:	e8 1f 15 00 00       	call   80104590 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103071:	69 05 c0 18 11 80 bc 	imul   $0xbc,0x801118c0,%eax
80103078:	00 00 00 
8010307b:	83 c4 10             	add    $0x10,%esp
8010307e:	05 e0 12 11 80       	add    $0x801112e0,%eax
80103083:	39 d8                	cmp    %ebx,%eax
80103085:	76 7c                	jbe    80103103 <main+0x133>
80103087:	89 f6                	mov    %esi,%esi
80103089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == cpus+cpunum())  // We've started already.
80103090:	e8 4b f7 ff ff       	call   801027e0 <cpunum>
80103095:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010309b:	05 e0 12 11 80       	add    $0x801112e0,%eax
801030a0:	39 c3                	cmp    %eax,%ebx
801030a2:	74 46                	je     801030ea <main+0x11a>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030a4:	e8 d7 f4 ff ff       	call   80102580 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801030a9:	83 ec 08             	sub    $0x8,%esp

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
801030ac:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
801030b1:	c7 05 f8 6f 00 80 b0 	movl   $0x80102fb0,0x80006ff8
801030b8:	2f 10 80 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
801030bb:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801030c0:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
801030c7:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
801030ca:	68 00 70 00 00       	push   $0x7000
801030cf:	0f b6 03             	movzbl (%ebx),%eax
801030d2:	50                   	push   %eax
801030d3:	e8 d8 f7 ff ff       	call   801028b0 <lapicstartap>
801030d8:	83 c4 10             	add    $0x10,%esp
801030db:	90                   	nop
801030dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801030e0:	8b 83 a8 00 00 00    	mov    0xa8(%ebx),%eax
801030e6:	85 c0                	test   %eax,%eax
801030e8:	74 f6                	je     801030e0 <main+0x110>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801030ea:	69 05 c0 18 11 80 bc 	imul   $0xbc,0x801118c0,%eax
801030f1:	00 00 00 
801030f4:	81 c3 bc 00 00 00    	add    $0xbc,%ebx
801030fa:	05 e0 12 11 80       	add    $0x801112e0,%eax
801030ff:	39 c3                	cmp    %eax,%ebx
80103101:	72 8d                	jb     80103090 <main+0xc0>
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103103:	83 ec 08             	sub    $0x8,%esp
80103106:	68 00 00 00 8e       	push   $0x8e000000
8010310b:	68 00 00 40 80       	push   $0x80400000
80103110:	e8 0b f4 ff ff       	call   80102520 <kinit2>
  userinit();      // first user process
80103115:	e8 46 08 00 00       	call   80103960 <userinit>
  mpmain();        // finish this processor's setup
8010311a:	e8 51 fe ff ff       	call   80102f70 <mpmain>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk
  if(!ismp)
    timerinit();   // uniprocessor timer
8010311f:	e8 bc 25 00 00       	call   801056e0 <timerinit>
80103124:	e9 2c ff ff ff       	jmp    80103055 <main+0x85>
80103129:	66 90                	xchg   %ax,%ax
8010312b:	66 90                	xchg   %ax,%ax
8010312d:	66 90                	xchg   %ax,%ax
8010312f:	90                   	nop

80103130 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103130:	55                   	push   %ebp
80103131:	89 e5                	mov    %esp,%ebp
80103133:	57                   	push   %edi
80103134:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103135:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010313b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010313c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010313f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103142:	39 de                	cmp    %ebx,%esi
80103144:	73 48                	jae    8010318e <mpsearch1+0x5e>
80103146:	8d 76 00             	lea    0x0(%esi),%esi
80103149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103150:	83 ec 04             	sub    $0x4,%esp
80103153:	8d 7e 10             	lea    0x10(%esi),%edi
80103156:	6a 04                	push   $0x4
80103158:	68 e8 74 10 80       	push   $0x801074e8
8010315d:	56                   	push   %esi
8010315e:	e8 cd 13 00 00       	call   80104530 <memcmp>
80103163:	83 c4 10             	add    $0x10,%esp
80103166:	85 c0                	test   %eax,%eax
80103168:	75 1e                	jne    80103188 <mpsearch1+0x58>
8010316a:	8d 7e 10             	lea    0x10(%esi),%edi
8010316d:	89 f2                	mov    %esi,%edx
8010316f:	31 c9                	xor    %ecx,%ecx
80103171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103178:	0f b6 02             	movzbl (%edx),%eax
8010317b:	83 c2 01             	add    $0x1,%edx
8010317e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103180:	39 fa                	cmp    %edi,%edx
80103182:	75 f4                	jne    80103178 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103184:	84 c9                	test   %cl,%cl
80103186:	74 10                	je     80103198 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103188:	39 fb                	cmp    %edi,%ebx
8010318a:	89 fe                	mov    %edi,%esi
8010318c:	77 c2                	ja     80103150 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
8010318e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103191:	31 c0                	xor    %eax,%eax
}
80103193:	5b                   	pop    %ebx
80103194:	5e                   	pop    %esi
80103195:	5f                   	pop    %edi
80103196:	5d                   	pop    %ebp
80103197:	c3                   	ret    
80103198:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010319b:	89 f0                	mov    %esi,%eax
8010319d:	5b                   	pop    %ebx
8010319e:	5e                   	pop    %esi
8010319f:	5f                   	pop    %edi
801031a0:	5d                   	pop    %ebp
801031a1:	c3                   	ret    
801031a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801031b0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	57                   	push   %edi
801031b4:	56                   	push   %esi
801031b5:	53                   	push   %ebx
801031b6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031b9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801031c0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801031c7:	c1 e0 08             	shl    $0x8,%eax
801031ca:	09 d0                	or     %edx,%eax
801031cc:	c1 e0 04             	shl    $0x4,%eax
801031cf:	85 c0                	test   %eax,%eax
801031d1:	75 1b                	jne    801031ee <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801031d3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801031da:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801031e1:	c1 e0 08             	shl    $0x8,%eax
801031e4:	09 d0                	or     %edx,%eax
801031e6:	c1 e0 0a             	shl    $0xa,%eax
801031e9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
801031ee:	ba 00 04 00 00       	mov    $0x400,%edx
801031f3:	e8 38 ff ff ff       	call   80103130 <mpsearch1>
801031f8:	85 c0                	test   %eax,%eax
801031fa:	89 c6                	mov    %eax,%esi
801031fc:	0f 84 66 01 00 00    	je     80103368 <mpinit+0x1b8>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103202:	8b 5e 04             	mov    0x4(%esi),%ebx
80103205:	85 db                	test   %ebx,%ebx
80103207:	0f 84 d6 00 00 00    	je     801032e3 <mpinit+0x133>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010320d:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103213:	83 ec 04             	sub    $0x4,%esp
80103216:	6a 04                	push   $0x4
80103218:	68 ed 74 10 80       	push   $0x801074ed
8010321d:	50                   	push   %eax
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010321e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103221:	e8 0a 13 00 00       	call   80104530 <memcmp>
80103226:	83 c4 10             	add    $0x10,%esp
80103229:	85 c0                	test   %eax,%eax
8010322b:	0f 85 b2 00 00 00    	jne    801032e3 <mpinit+0x133>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103231:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103238:	3c 01                	cmp    $0x1,%al
8010323a:	74 08                	je     80103244 <mpinit+0x94>
8010323c:	3c 04                	cmp    $0x4,%al
8010323e:	0f 85 9f 00 00 00    	jne    801032e3 <mpinit+0x133>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103244:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010324b:	85 ff                	test   %edi,%edi
8010324d:	74 1e                	je     8010326d <mpinit+0xbd>
8010324f:	31 d2                	xor    %edx,%edx
80103251:	31 c0                	xor    %eax,%eax
80103253:	90                   	nop
80103254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103258:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010325f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103260:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103263:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103265:	39 c7                	cmp    %eax,%edi
80103267:	75 ef                	jne    80103258 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103269:	84 d2                	test   %dl,%dl
8010326b:	75 76                	jne    801032e3 <mpinit+0x133>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
8010326d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103270:	85 ff                	test   %edi,%edi
80103272:	74 6f                	je     801032e3 <mpinit+0x133>
    return;
  ismp = 1;
80103274:	c7 05 c4 12 11 80 01 	movl   $0x1,0x801112c4
8010327b:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010327e:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103284:	a3 dc 11 11 80       	mov    %eax,0x801111dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103289:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
80103290:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103296:	01 f9                	add    %edi,%ecx
80103298:	39 c8                	cmp    %ecx,%eax
8010329a:	0f 83 a0 00 00 00    	jae    80103340 <mpinit+0x190>
    switch(*p){
801032a0:	80 38 04             	cmpb   $0x4,(%eax)
801032a3:	0f 87 87 00 00 00    	ja     80103330 <mpinit+0x180>
801032a9:	0f b6 10             	movzbl (%eax),%edx
801032ac:	ff 24 95 f4 74 10 80 	jmp    *-0x7fef8b0c(,%edx,4)
801032b3:	90                   	nop
801032b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801032b8:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032bb:	39 c1                	cmp    %eax,%ecx
801032bd:	77 e1                	ja     801032a0 <mpinit+0xf0>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp){
801032bf:	a1 c4 12 11 80       	mov    0x801112c4,%eax
801032c4:	85 c0                	test   %eax,%eax
801032c6:	75 78                	jne    80103340 <mpinit+0x190>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801032c8:	c7 05 c0 18 11 80 01 	movl   $0x1,0x801118c0
801032cf:	00 00 00 
    lapic = 0;
801032d2:	c7 05 dc 11 11 80 00 	movl   $0x0,0x801111dc
801032d9:	00 00 00 
    ioapicid = 0;
801032dc:	c6 05 c0 12 11 80 00 	movb   $0x0,0x801112c0
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801032e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032e6:	5b                   	pop    %ebx
801032e7:	5e                   	pop    %esi
801032e8:	5f                   	pop    %edi
801032e9:	5d                   	pop    %ebp
801032ea:	c3                   	ret    
801032eb:	90                   	nop
801032ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801032f0:	8b 15 c0 18 11 80    	mov    0x801118c0,%edx
801032f6:	83 fa 07             	cmp    $0x7,%edx
801032f9:	7f 19                	jg     80103314 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801032fb:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
801032ff:	69 fa bc 00 00 00    	imul   $0xbc,%edx,%edi
        ncpu++;
80103305:	83 c2 01             	add    $0x1,%edx
80103308:	89 15 c0 18 11 80    	mov    %edx,0x801118c0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010330e:	88 9f e0 12 11 80    	mov    %bl,-0x7feeed20(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
80103314:	83 c0 14             	add    $0x14,%eax
      continue;
80103317:	eb a2                	jmp    801032bb <mpinit+0x10b>
80103319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103320:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
80103324:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103327:	88 15 c0 12 11 80    	mov    %dl,0x801112c0
      p += sizeof(struct mpioapic);
      continue;
8010332d:	eb 8c                	jmp    801032bb <mpinit+0x10b>
8010332f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103330:	c7 05 c4 12 11 80 00 	movl   $0x0,0x801112c4
80103337:	00 00 00 
      break;
8010333a:	e9 7c ff ff ff       	jmp    801032bb <mpinit+0x10b>
8010333f:	90                   	nop
    lapic = 0;
    ioapicid = 0;
    return;
  }

  if(mp->imcrp){
80103340:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103344:	74 9d                	je     801032e3 <mpinit+0x133>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103346:	ba 22 00 00 00       	mov    $0x22,%edx
8010334b:	b8 70 00 00 00       	mov    $0x70,%eax
80103350:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103351:	ba 23 00 00 00       	mov    $0x23,%edx
80103356:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103357:	83 c8 01             	or     $0x1,%eax
8010335a:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010335b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010335e:	5b                   	pop    %ebx
8010335f:	5e                   	pop    %esi
80103360:	5f                   	pop    %edi
80103361:	5d                   	pop    %ebp
80103362:	c3                   	ret    
80103363:	90                   	nop
80103364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103368:	ba 00 00 01 00       	mov    $0x10000,%edx
8010336d:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103372:	e8 b9 fd ff ff       	call   80103130 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103377:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103379:	89 c6                	mov    %eax,%esi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010337b:	0f 85 81 fe ff ff    	jne    80103202 <mpinit+0x52>
80103381:	e9 5d ff ff ff       	jmp    801032e3 <mpinit+0x133>
80103386:	66 90                	xchg   %ax,%ax
80103388:	66 90                	xchg   %ax,%ax
8010338a:	66 90                	xchg   %ax,%ax
8010338c:	66 90                	xchg   %ax,%ax
8010338e:	66 90                	xchg   %ax,%ax

80103390 <picenable>:
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
80103390:	55                   	push   %ebp
  picsetmask(irqmask & ~(1<<irq));
80103391:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103396:	ba 21 00 00 00       	mov    $0x21,%edx
  outb(IO_PIC2+1, mask >> 8);
}

void
picenable(int irq)
{
8010339b:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
8010339d:	8b 4d 08             	mov    0x8(%ebp),%ecx
801033a0:	d3 c0                	rol    %cl,%eax
801033a2:	66 23 05 00 a0 10 80 	and    0x8010a000,%ax
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
  irqmask = mask;
801033a9:	66 a3 00 a0 10 80    	mov    %ax,0x8010a000
801033af:	ee                   	out    %al,(%dx)
801033b0:	ba a1 00 00 00       	mov    $0xa1,%edx
801033b5:	66 c1 e8 08          	shr    $0x8,%ax
801033b9:	ee                   	out    %al,(%dx)

void
picenable(int irq)
{
  picsetmask(irqmask & ~(1<<irq));
}
801033ba:	5d                   	pop    %ebp
801033bb:	c3                   	ret    
801033bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033c0 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
801033c0:	55                   	push   %ebp
801033c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033c6:	89 e5                	mov    %esp,%ebp
801033c8:	57                   	push   %edi
801033c9:	56                   	push   %esi
801033ca:	53                   	push   %ebx
801033cb:	bb 21 00 00 00       	mov    $0x21,%ebx
801033d0:	89 da                	mov    %ebx,%edx
801033d2:	ee                   	out    %al,(%dx)
801033d3:	b9 a1 00 00 00       	mov    $0xa1,%ecx
801033d8:	89 ca                	mov    %ecx,%edx
801033da:	ee                   	out    %al,(%dx)
801033db:	bf 11 00 00 00       	mov    $0x11,%edi
801033e0:	be 20 00 00 00       	mov    $0x20,%esi
801033e5:	89 f8                	mov    %edi,%eax
801033e7:	89 f2                	mov    %esi,%edx
801033e9:	ee                   	out    %al,(%dx)
801033ea:	b8 20 00 00 00       	mov    $0x20,%eax
801033ef:	89 da                	mov    %ebx,%edx
801033f1:	ee                   	out    %al,(%dx)
801033f2:	b8 04 00 00 00       	mov    $0x4,%eax
801033f7:	ee                   	out    %al,(%dx)
801033f8:	b8 03 00 00 00       	mov    $0x3,%eax
801033fd:	ee                   	out    %al,(%dx)
801033fe:	bb a0 00 00 00       	mov    $0xa0,%ebx
80103403:	89 f8                	mov    %edi,%eax
80103405:	89 da                	mov    %ebx,%edx
80103407:	ee                   	out    %al,(%dx)
80103408:	b8 28 00 00 00       	mov    $0x28,%eax
8010340d:	89 ca                	mov    %ecx,%edx
8010340f:	ee                   	out    %al,(%dx)
80103410:	b8 02 00 00 00       	mov    $0x2,%eax
80103415:	ee                   	out    %al,(%dx)
80103416:	b8 03 00 00 00       	mov    $0x3,%eax
8010341b:	ee                   	out    %al,(%dx)
8010341c:	bf 68 00 00 00       	mov    $0x68,%edi
80103421:	89 f2                	mov    %esi,%edx
80103423:	89 f8                	mov    %edi,%eax
80103425:	ee                   	out    %al,(%dx)
80103426:	b9 0a 00 00 00       	mov    $0xa,%ecx
8010342b:	89 c8                	mov    %ecx,%eax
8010342d:	ee                   	out    %al,(%dx)
8010342e:	89 f8                	mov    %edi,%eax
80103430:	89 da                	mov    %ebx,%edx
80103432:	ee                   	out    %al,(%dx)
80103433:	89 c8                	mov    %ecx,%eax
80103435:	ee                   	out    %al,(%dx)
  outb(IO_PIC1, 0x0a);             // read IRR by default

  outb(IO_PIC2, 0x68);             // OCW3
  outb(IO_PIC2, 0x0a);             // OCW3

  if(irqmask != 0xFFFF)
80103436:	0f b7 05 00 a0 10 80 	movzwl 0x8010a000,%eax
8010343d:	66 83 f8 ff          	cmp    $0xffff,%ax
80103441:	74 10                	je     80103453 <picinit+0x93>
80103443:	ba 21 00 00 00       	mov    $0x21,%edx
80103448:	ee                   	out    %al,(%dx)
80103449:	ba a1 00 00 00       	mov    $0xa1,%edx
8010344e:	66 c1 e8 08          	shr    $0x8,%ax
80103452:	ee                   	out    %al,(%dx)
    picsetmask(irqmask);
}
80103453:	5b                   	pop    %ebx
80103454:	5e                   	pop    %esi
80103455:	5f                   	pop    %edi
80103456:	5d                   	pop    %ebp
80103457:	c3                   	ret    
80103458:	66 90                	xchg   %ax,%ax
8010345a:	66 90                	xchg   %ax,%ax
8010345c:	66 90                	xchg   %ax,%ax
8010345e:	66 90                	xchg   %ax,%ax

80103460 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 0c             	sub    $0xc,%esp
80103469:	8b 75 08             	mov    0x8(%ebp),%esi
8010346c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010346f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103475:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010347b:	e8 d0 d9 ff ff       	call   80100e50 <filealloc>
80103480:	85 c0                	test   %eax,%eax
80103482:	89 06                	mov    %eax,(%esi)
80103484:	0f 84 a8 00 00 00    	je     80103532 <pipealloc+0xd2>
8010348a:	e8 c1 d9 ff ff       	call   80100e50 <filealloc>
8010348f:	85 c0                	test   %eax,%eax
80103491:	89 03                	mov    %eax,(%ebx)
80103493:	0f 84 87 00 00 00    	je     80103520 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103499:	e8 e2 f0 ff ff       	call   80102580 <kalloc>
8010349e:	85 c0                	test   %eax,%eax
801034a0:	89 c7                	mov    %eax,%edi
801034a2:	0f 84 b0 00 00 00    	je     80103558 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034a8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
801034ab:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034b2:	00 00 00 
  p->writeopen = 1;
801034b5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034bc:	00 00 00 
  p->nwrite = 0;
801034bf:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034c6:	00 00 00 
  p->nread = 0;
801034c9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034d0:	00 00 00 
  initlock(&p->lock, "pipe");
801034d3:	68 08 75 10 80       	push   $0x80107508
801034d8:	50                   	push   %eax
801034d9:	e8 b2 0d 00 00       	call   80104290 <initlock>
  (*f0)->type = FD_PIPE;
801034de:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034e0:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
801034e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034e9:	8b 06                	mov    (%esi),%eax
801034eb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034ef:	8b 06                	mov    (%esi),%eax
801034f1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034f5:	8b 06                	mov    (%esi),%eax
801034f7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034fa:	8b 03                	mov    (%ebx),%eax
801034fc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103502:	8b 03                	mov    (%ebx),%eax
80103504:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103508:	8b 03                	mov    (%ebx),%eax
8010350a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010350e:	8b 03                	mov    (%ebx),%eax
80103510:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103513:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103516:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103518:	5b                   	pop    %ebx
80103519:	5e                   	pop    %esi
8010351a:	5f                   	pop    %edi
8010351b:	5d                   	pop    %ebp
8010351c:	c3                   	ret    
8010351d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103520:	8b 06                	mov    (%esi),%eax
80103522:	85 c0                	test   %eax,%eax
80103524:	74 1e                	je     80103544 <pipealloc+0xe4>
    fileclose(*f0);
80103526:	83 ec 0c             	sub    $0xc,%esp
80103529:	50                   	push   %eax
8010352a:	e8 e1 d9 ff ff       	call   80100f10 <fileclose>
8010352f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103532:	8b 03                	mov    (%ebx),%eax
80103534:	85 c0                	test   %eax,%eax
80103536:	74 0c                	je     80103544 <pipealloc+0xe4>
    fileclose(*f1);
80103538:	83 ec 0c             	sub    $0xc,%esp
8010353b:	50                   	push   %eax
8010353c:	e8 cf d9 ff ff       	call   80100f10 <fileclose>
80103541:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103544:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103547:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010354c:	5b                   	pop    %ebx
8010354d:	5e                   	pop    %esi
8010354e:	5f                   	pop    %edi
8010354f:	5d                   	pop    %ebp
80103550:	c3                   	ret    
80103551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103558:	8b 06                	mov    (%esi),%eax
8010355a:	85 c0                	test   %eax,%eax
8010355c:	75 c8                	jne    80103526 <pipealloc+0xc6>
8010355e:	eb d2                	jmp    80103532 <pipealloc+0xd2>

80103560 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	56                   	push   %esi
80103564:	53                   	push   %ebx
80103565:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103568:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010356b:	83 ec 0c             	sub    $0xc,%esp
8010356e:	53                   	push   %ebx
8010356f:	e8 3c 0d 00 00       	call   801042b0 <acquire>
  if(writable){
80103574:	83 c4 10             	add    $0x10,%esp
80103577:	85 f6                	test   %esi,%esi
80103579:	74 45                	je     801035c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010357b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103581:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103584:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010358b:	00 00 00 
    wakeup(&p->nread);
8010358e:	50                   	push   %eax
8010358f:	e8 3c 0b 00 00       	call   801040d0 <wakeup>
80103594:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103597:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010359d:	85 d2                	test   %edx,%edx
8010359f:	75 0a                	jne    801035ab <pipeclose+0x4b>
801035a1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035a7:	85 c0                	test   %eax,%eax
801035a9:	74 35                	je     801035e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b1:	5b                   	pop    %ebx
801035b2:	5e                   	pop    %esi
801035b3:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035b4:	e9 d7 0e 00 00       	jmp    80104490 <release>
801035b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801035c0:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801035c6:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801035c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035d0:	00 00 00 
    wakeup(&p->nwrite);
801035d3:	50                   	push   %eax
801035d4:	e8 f7 0a 00 00       	call   801040d0 <wakeup>
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	eb b9                	jmp    80103597 <pipeclose+0x37>
801035de:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801035e0:	83 ec 0c             	sub    $0xc,%esp
801035e3:	53                   	push   %ebx
801035e4:	e8 a7 0e 00 00       	call   80104490 <release>
    kfree((char*)p);
801035e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ec:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
801035ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035f2:	5b                   	pop    %ebx
801035f3:	5e                   	pop    %esi
801035f4:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801035f5:	e9 d6 ed ff ff       	jmp    801023d0 <kfree>
801035fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103600 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103600:	55                   	push   %ebp
80103601:	89 e5                	mov    %esp,%ebp
80103603:	57                   	push   %edi
80103604:	56                   	push   %esi
80103605:	53                   	push   %ebx
80103606:	83 ec 28             	sub    $0x28,%esp
80103609:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i;

  acquire(&p->lock);
8010360c:	57                   	push   %edi
8010360d:	e8 9e 0c 00 00       	call   801042b0 <acquire>
  for(i = 0; i < n; i++){
80103612:	8b 45 10             	mov    0x10(%ebp),%eax
80103615:	83 c4 10             	add    $0x10,%esp
80103618:	85 c0                	test   %eax,%eax
8010361a:	0f 8e c6 00 00 00    	jle    801036e6 <pipewrite+0xe6>
80103620:	8b 45 0c             	mov    0xc(%ebp),%eax
80103623:	8b 8f 38 02 00 00    	mov    0x238(%edi),%ecx
80103629:	8d b7 34 02 00 00    	lea    0x234(%edi),%esi
8010362f:	8d 9f 38 02 00 00    	lea    0x238(%edi),%ebx
80103635:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103638:	03 45 10             	add    0x10(%ebp),%eax
8010363b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010363e:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
80103644:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010364a:	39 d1                	cmp    %edx,%ecx
8010364c:	0f 85 cf 00 00 00    	jne    80103721 <pipewrite+0x121>
      if(p->readopen == 0 || proc->killed){
80103652:	8b 97 3c 02 00 00    	mov    0x23c(%edi),%edx
80103658:	85 d2                	test   %edx,%edx
8010365a:	0f 84 a8 00 00 00    	je     80103708 <pipewrite+0x108>
80103660:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103667:	8b 42 28             	mov    0x28(%edx),%eax
8010366a:	85 c0                	test   %eax,%eax
8010366c:	74 25                	je     80103693 <pipewrite+0x93>
8010366e:	e9 95 00 00 00       	jmp    80103708 <pipewrite+0x108>
80103673:	90                   	nop
80103674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103678:	8b 87 3c 02 00 00    	mov    0x23c(%edi),%eax
8010367e:	85 c0                	test   %eax,%eax
80103680:	0f 84 82 00 00 00    	je     80103708 <pipewrite+0x108>
80103686:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010368c:	8b 40 28             	mov    0x28(%eax),%eax
8010368f:	85 c0                	test   %eax,%eax
80103691:	75 75                	jne    80103708 <pipewrite+0x108>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103693:	83 ec 0c             	sub    $0xc,%esp
80103696:	56                   	push   %esi
80103697:	e8 34 0a 00 00       	call   801040d0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010369c:	59                   	pop    %ecx
8010369d:	58                   	pop    %eax
8010369e:	57                   	push   %edi
8010369f:	53                   	push   %ebx
801036a0:	e8 6b 08 00 00       	call   80103f10 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036a5:	8b 87 34 02 00 00    	mov    0x234(%edi),%eax
801036ab:	8b 97 38 02 00 00    	mov    0x238(%edi),%edx
801036b1:	83 c4 10             	add    $0x10,%esp
801036b4:	05 00 02 00 00       	add    $0x200,%eax
801036b9:	39 c2                	cmp    %eax,%edx
801036bb:	74 bb                	je     80103678 <pipewrite+0x78>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801036c0:	8d 4a 01             	lea    0x1(%edx),%ecx
801036c3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801036c7:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036cd:	89 8f 38 02 00 00    	mov    %ecx,0x238(%edi)
801036d3:	0f b6 00             	movzbl (%eax),%eax
801036d6:	88 44 17 34          	mov    %al,0x34(%edi,%edx,1)
801036da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801036dd:	3b 45 e0             	cmp    -0x20(%ebp),%eax
801036e0:	0f 85 58 ff ff ff    	jne    8010363e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036e6:	8d 97 34 02 00 00    	lea    0x234(%edi),%edx
801036ec:	83 ec 0c             	sub    $0xc,%esp
801036ef:	52                   	push   %edx
801036f0:	e8 db 09 00 00       	call   801040d0 <wakeup>
  release(&p->lock);
801036f5:	89 3c 24             	mov    %edi,(%esp)
801036f8:	e8 93 0d 00 00       	call   80104490 <release>
  return n;
801036fd:	83 c4 10             	add    $0x10,%esp
80103700:	8b 45 10             	mov    0x10(%ebp),%eax
80103703:	eb 14                	jmp    80103719 <pipewrite+0x119>
80103705:	8d 76 00             	lea    0x0(%esi),%esi

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
        release(&p->lock);
80103708:	83 ec 0c             	sub    $0xc,%esp
8010370b:	57                   	push   %edi
8010370c:	e8 7f 0d 00 00       	call   80104490 <release>
        return -1;
80103711:	83 c4 10             	add    $0x10,%esp
80103714:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103719:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010371c:	5b                   	pop    %ebx
8010371d:	5e                   	pop    %esi
8010371e:	5f                   	pop    %edi
8010371f:	5d                   	pop    %ebp
80103720:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103721:	89 ca                	mov    %ecx,%edx
80103723:	eb 98                	jmp    801036bd <pipewrite+0xbd>
80103725:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103730 <piperead>:
  return n;
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	57                   	push   %edi
80103734:	56                   	push   %esi
80103735:	53                   	push   %ebx
80103736:	83 ec 18             	sub    $0x18,%esp
80103739:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010373c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010373f:	53                   	push   %ebx
80103740:	e8 6b 0b 00 00       	call   801042b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103745:	83 c4 10             	add    $0x10,%esp
80103748:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010374e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103754:	75 6a                	jne    801037c0 <piperead+0x90>
80103756:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010375c:	85 f6                	test   %esi,%esi
8010375e:	0f 84 cc 00 00 00    	je     80103830 <piperead+0x100>
80103764:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010376a:	eb 2d                	jmp    80103799 <piperead+0x69>
8010376c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103770:	83 ec 08             	sub    $0x8,%esp
80103773:	53                   	push   %ebx
80103774:	56                   	push   %esi
80103775:	e8 96 07 00 00       	call   80103f10 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010377a:	83 c4 10             	add    $0x10,%esp
8010377d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103783:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103789:	75 35                	jne    801037c0 <piperead+0x90>
8010378b:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
80103791:	85 d2                	test   %edx,%edx
80103793:	0f 84 97 00 00 00    	je     80103830 <piperead+0x100>
    if(proc->killed){
80103799:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801037a0:	8b 4a 28             	mov    0x28(%edx),%ecx
801037a3:	85 c9                	test   %ecx,%ecx
801037a5:	74 c9                	je     80103770 <piperead+0x40>
      release(&p->lock);
801037a7:	83 ec 0c             	sub    $0xc,%esp
801037aa:	53                   	push   %ebx
801037ab:	e8 e0 0c 00 00       	call   80104490 <release>
      return -1;
801037b0:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801037b3:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(proc->killed){
      release(&p->lock);
      return -1;
801037b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801037bb:	5b                   	pop    %ebx
801037bc:	5e                   	pop    %esi
801037bd:	5f                   	pop    %edi
801037be:	5d                   	pop    %ebp
801037bf:	c3                   	ret    
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037c0:	8b 45 10             	mov    0x10(%ebp),%eax
801037c3:	85 c0                	test   %eax,%eax
801037c5:	7e 69                	jle    80103830 <piperead+0x100>
    if(p->nread == p->nwrite)
801037c7:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801037cd:	31 c9                	xor    %ecx,%ecx
801037cf:	eb 15                	jmp    801037e6 <piperead+0xb6>
801037d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037d8:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
801037de:	3b 93 38 02 00 00    	cmp    0x238(%ebx),%edx
801037e4:	74 5a                	je     80103840 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037e6:	8d 72 01             	lea    0x1(%edx),%esi
801037e9:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037ef:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
801037f5:	0f b6 54 13 34       	movzbl 0x34(%ebx,%edx,1),%edx
801037fa:	88 14 0f             	mov    %dl,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037fd:	83 c1 01             	add    $0x1,%ecx
80103800:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103803:	75 d3                	jne    801037d8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103805:	8d 93 38 02 00 00    	lea    0x238(%ebx),%edx
8010380b:	83 ec 0c             	sub    $0xc,%esp
8010380e:	52                   	push   %edx
8010380f:	e8 bc 08 00 00       	call   801040d0 <wakeup>
  release(&p->lock);
80103814:	89 1c 24             	mov    %ebx,(%esp)
80103817:	e8 74 0c 00 00       	call   80104490 <release>
  return i;
8010381c:	8b 45 10             	mov    0x10(%ebp),%eax
8010381f:	83 c4 10             	add    $0x10,%esp
}
80103822:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103825:	5b                   	pop    %ebx
80103826:	5e                   	pop    %esi
80103827:	5f                   	pop    %edi
80103828:	5d                   	pop    %ebp
80103829:	c3                   	ret    
8010382a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103830:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103837:	eb cc                	jmp    80103805 <piperead+0xd5>
80103839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103840:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103843:	eb c0                	jmp    80103805 <piperead+0xd5>
80103845:	66 90                	xchg   %ax,%ax
80103847:	66 90                	xchg   %ax,%ax
80103849:	66 90                	xchg   %ax,%ax
8010384b:	66 90                	xchg   %ax,%ax
8010384d:	66 90                	xchg   %ax,%ax
8010384f:	90                   	nop

80103850 <allocproc>:
// state required to run in the kernel.
// Otherwise return 0.
// Must hold ptable.lock.
static struct proc*
allocproc(void)
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103854:	bb 14 19 11 80       	mov    $0x80111914,%ebx
// state required to run in the kernel.
// Otherwise return 0.
// Must hold ptable.lock.
static struct proc*
allocproc(void)
{
80103859:	83 ec 04             	sub    $0x4,%esp
8010385c:	eb 0d                	jmp    8010386b <allocproc+0x1b>
8010385e:	66 90                	xchg   %ax,%ax
  struct proc *p;
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103860:	83 eb 80             	sub    $0xffffff80,%ebx
80103863:	81 fb 14 39 11 80    	cmp    $0x80113914,%ebx
80103869:	74 6d                	je     801038d8 <allocproc+0x88>
    if(p->state == UNUSED)
8010386b:	8b 43 10             	mov    0x10(%ebx),%eax
8010386e:	85 c0                	test   %eax,%eax
80103870:	75 ee                	jne    80103860 <allocproc+0x10>
  return 0;

found:
  p->state = EMBRYO;
  p->priority = 0;
  p->pid = nextpid++;
80103872:	a1 08 a0 10 80       	mov    0x8010a008,%eax
    if(p->state == UNUSED)
      goto found;
  return 0;

found:
  p->state = EMBRYO;
80103877:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->priority = 0;
8010387e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  p->pid = nextpid++;
80103884:	8d 50 01             	lea    0x1(%eax),%edx
80103887:	89 43 14             	mov    %eax,0x14(%ebx)
8010388a:	89 15 08 a0 10 80    	mov    %edx,0x8010a008

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103890:	e8 eb ec ff ff       	call   80102580 <kalloc>
80103895:	85 c0                	test   %eax,%eax
80103897:	89 43 0c             	mov    %eax,0xc(%ebx)
8010389a:	74 43                	je     801038df <allocproc+0x8f>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010389c:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038a2:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801038a5:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801038aa:	89 53 1c             	mov    %edx,0x1c(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801038ad:	c7 40 14 2e 57 10 80 	movl   $0x8010572e,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038b4:	6a 14                	push   $0x14
801038b6:	6a 00                	push   $0x0
801038b8:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801038b9:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038bc:	e8 1f 0c 00 00       	call   801044e0 <memset>
  p->context->eip = (uint)forkret;
801038c1:	8b 43 20             	mov    0x20(%ebx),%eax

  return p;
801038c4:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
801038c7:	c7 40 10 f0 38 10 80 	movl   $0x801038f0,0x10(%eax)

  return p;
801038ce:	89 d8                	mov    %ebx,%eax
}
801038d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038d3:	c9                   	leave  
801038d4:	c3                   	ret    
801038d5:	8d 76 00             	lea    0x0(%esi),%esi
  char *sp;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  return 0;
801038d8:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
801038da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038dd:	c9                   	leave  
801038de:	c3                   	ret    
  p->priority = 0;
  p->pid = nextpid++;

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801038df:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
801038e6:	eb e8                	jmp    801038d0 <allocproc+0x80>
801038e8:	90                   	nop
801038e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038f6:	68 e0 18 11 80       	push   $0x801118e0
801038fb:	e8 90 0b 00 00       	call   80104490 <release>

  if (first) {
80103900:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	85 c0                	test   %eax,%eax
8010390a:	75 04                	jne    80103910 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010390c:	c9                   	leave  
8010390d:	c3                   	ret    
8010390e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103910:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103913:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
8010391a:	00 00 00 
    iinit(ROOTDEV);
8010391d:	6a 01                	push   $0x1
8010391f:	e8 1c dc ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
80103924:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010392b:	e8 f0 f2 ff ff       	call   80102c20 <initlog>
80103930:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103933:	c9                   	leave  
80103934:	c3                   	ret    
80103935:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103940 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103946:	68 0d 75 10 80       	push   $0x8010750d
8010394b:	68 e0 18 11 80       	push   $0x801118e0
80103950:	e8 3b 09 00 00       	call   80104290 <initlock>
}
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	c9                   	leave  
80103959:	c3                   	ret    
8010395a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103960 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	53                   	push   %ebx
80103964:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  acquire(&ptable.lock);
80103967:	68 e0 18 11 80       	push   $0x801118e0
8010396c:	e8 3f 09 00 00       	call   801042b0 <acquire>

  p = allocproc();
80103971:	e8 da fe ff ff       	call   80103850 <allocproc>
80103976:	89 c3                	mov    %eax,%ebx

  // release the lock in case namei() sleeps.
  // the lock isn't needed because no other
  // thread will look at an EMBRYO proc.
  release(&ptable.lock);
80103978:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
8010397f:	e8 0c 0b 00 00       	call   80104490 <release>
  
  initproc = p;
80103984:	89 1d bc a5 10 80    	mov    %ebx,0x8010a5bc
  if((p->pgdir = setupkvm()) == 0)
8010398a:	e8 d1 2f 00 00       	call   80106960 <setupkvm>
8010398f:	83 c4 10             	add    $0x10,%esp
80103992:	85 c0                	test   %eax,%eax
80103994:	89 43 08             	mov    %eax,0x8(%ebx)
80103997:	0f 84 be 00 00 00    	je     80103a5b <userinit+0xfb>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010399d:	83 ec 04             	sub    $0x4,%esp
801039a0:	68 2c 00 00 00       	push   $0x2c
801039a5:	68 60 a4 10 80       	push   $0x8010a460
801039aa:	50                   	push   %eax
801039ab:	e8 00 31 00 00       	call   80106ab0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
801039b0:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
801039b3:	c7 43 04 00 10 00 00 	movl   $0x1000,0x4(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801039ba:	6a 4c                	push   $0x4c
801039bc:	6a 00                	push   $0x0
801039be:	ff 73 1c             	pushl  0x1c(%ebx)
801039c1:	e8 1a 0b 00 00       	call   801044e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039c6:	8b 43 1c             	mov    0x1c(%ebx),%eax
801039c9:	ba 23 00 00 00       	mov    $0x23,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039ce:	b9 2b 00 00 00       	mov    $0x2b,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
801039d3:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801039d6:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801039da:	8b 43 1c             	mov    0x1c(%ebx),%eax
801039dd:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801039e1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801039e4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039e8:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801039ec:	8b 43 1c             	mov    0x1c(%ebx),%eax
801039ef:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801039f3:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801039f7:	8b 43 1c             	mov    0x1c(%ebx),%eax
801039fa:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a01:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a04:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a0b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a0e:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a15:	8d 43 70             	lea    0x70(%ebx),%eax
80103a18:	6a 10                	push   $0x10
80103a1a:	68 2d 75 10 80       	push   $0x8010752d
80103a1f:	50                   	push   %eax
80103a20:	e8 bb 0c 00 00       	call   801046e0 <safestrcpy>
  p->cwd = namei("/");
80103a25:	c7 04 24 36 75 10 80 	movl   $0x80107536,(%esp)
80103a2c:	e8 6f e5 ff ff       	call   80101fa0 <namei>
80103a31:	89 43 6c             	mov    %eax,0x6c(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103a34:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103a3b:	e8 70 08 00 00       	call   801042b0 <acquire>

  p->state = RUNNABLE;
80103a40:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)

  release(&ptable.lock);
80103a47:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103a4e:	e8 3d 0a 00 00       	call   80104490 <release>
}
80103a53:	83 c4 10             	add    $0x10,%esp
80103a56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a59:	c9                   	leave  
80103a5a:	c3                   	ret    
  // thread will look at an EMBRYO proc.
  release(&ptable.lock);
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103a5b:	83 ec 0c             	sub    $0xc,%esp
80103a5e:	68 14 75 10 80       	push   $0x80107514
80103a63:	e8 e8 c8 ff ff       	call   80100350 <panic>
80103a68:	90                   	nop
80103a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a70 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	83 ec 08             	sub    $0x8,%esp
  uint sz;

  sz = proc->sz;
80103a76:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103a7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint sz;

  sz = proc->sz;
80103a80:	8b 42 04             	mov    0x4(%edx),%eax
  if(n > 0){
80103a83:	83 f9 00             	cmp    $0x0,%ecx
80103a86:	7e 38                	jle    80103ac0 <growproc+0x50>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80103a88:	83 ec 04             	sub    $0x4,%esp
80103a8b:	01 c1                	add    %eax,%ecx
80103a8d:	51                   	push   %ecx
80103a8e:	50                   	push   %eax
80103a8f:	ff 72 08             	pushl  0x8(%edx)
80103a92:	e8 59 31 00 00       	call   80106bf0 <allocuvm>
80103a97:	83 c4 10             	add    $0x10,%esp
80103a9a:	85 c0                	test   %eax,%eax
80103a9c:	74 3a                	je     80103ad8 <growproc+0x68>
80103a9e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
80103aa5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
80103aa8:	89 42 04             	mov    %eax,0x4(%edx)
  switchuvm(proc);
80103aab:	52                   	push   %edx
80103aac:	e8 5f 2f 00 00       	call   80106a10 <switchuvm>
  return 0;
80103ab1:	83 c4 10             	add    $0x10,%esp
80103ab4:	31 c0                	xor    %eax,%eax
}
80103ab6:	c9                   	leave  
80103ab7:	c3                   	ret    
80103ab8:	90                   	nop
80103ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103ac0:	74 e3                	je     80103aa5 <growproc+0x35>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80103ac2:	83 ec 04             	sub    $0x4,%esp
80103ac5:	01 c1                	add    %eax,%ecx
80103ac7:	51                   	push   %ecx
80103ac8:	50                   	push   %eax
80103ac9:	ff 72 08             	pushl  0x8(%edx)
80103acc:	e8 1f 32 00 00       	call   80106cf0 <deallocuvm>
80103ad1:	83 c4 10             	add    $0x10,%esp
80103ad4:	85 c0                	test   %eax,%eax
80103ad6:	75 c6                	jne    80103a9e <growproc+0x2e>
  uint sz;

  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
80103ad8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}
80103add:	c9                   	leave  
80103ade:	c3                   	ret    
80103adf:	90                   	nop

80103ae0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	57                   	push   %edi
80103ae4:	56                   	push   %esi
80103ae5:	53                   	push   %ebx
80103ae6:	83 ec 18             	sub    $0x18,%esp
  int i, pid;
  struct proc *np;

  acquire(&ptable.lock);
80103ae9:	68 e0 18 11 80       	push   $0x801118e0
80103aee:	e8 bd 07 00 00       	call   801042b0 <acquire>

  // Allocate process.
  if((np = allocproc()) == 0){
80103af3:	e8 58 fd ff ff       	call   80103850 <allocproc>
80103af8:	83 c4 10             	add    $0x10,%esp
80103afb:	85 c0                	test   %eax,%eax
80103afd:	0f 84 e1 00 00 00    	je     80103be4 <fork+0x104>
    release(&ptable.lock);
    return -1;
  }

  release(&ptable.lock);
80103b03:	83 ec 0c             	sub    $0xc,%esp
80103b06:	89 c3                	mov    %eax,%ebx
80103b08:	68 e0 18 11 80       	push   $0x801118e0
80103b0d:	e8 7e 09 00 00       	call   80104490 <release>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80103b12:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103b18:	5a                   	pop    %edx
80103b19:	59                   	pop    %ecx
80103b1a:	ff 70 04             	pushl  0x4(%eax)
80103b1d:	ff 70 08             	pushl  0x8(%eax)
80103b20:	e8 ab 32 00 00       	call   80106dd0 <copyuvm>
80103b25:	83 c4 10             	add    $0x10,%esp
80103b28:	85 c0                	test   %eax,%eax
80103b2a:	89 43 08             	mov    %eax,0x8(%ebx)
80103b2d:	0f 84 c8 00 00 00    	je     80103bfb <fork+0x11b>
    np->kstack = 0;
    np->state = UNUSED;
    release(&ptable.lock);
    return -1;
  }
  np->sz = proc->sz;
80103b33:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  np->parent = proc;
  *np->tf = *proc->tf;
80103b39:	8b 7b 1c             	mov    0x1c(%ebx),%edi
80103b3c:	b9 13 00 00 00       	mov    $0x13,%ecx
    np->kstack = 0;
    np->state = UNUSED;
    release(&ptable.lock);
    return -1;
  }
  np->sz = proc->sz;
80103b41:	8b 50 04             	mov    0x4(%eax),%edx
  np->parent = proc;
80103b44:	89 43 18             	mov    %eax,0x18(%ebx)
    np->kstack = 0;
    np->state = UNUSED;
    release(&ptable.lock);
    return -1;
  }
  np->sz = proc->sz;
80103b47:	89 53 04             	mov    %edx,0x4(%ebx)
  np->parent = proc;
  *np->tf = *proc->tf;
80103b4a:	8b 70 1c             	mov    0x1c(%eax),%esi
80103b4d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103b4f:	31 f6                	xor    %esi,%esi
  np->sz = proc->sz;
  np->parent = proc;
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103b51:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103b54:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103b5b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
80103b68:	8b 44 b2 2c          	mov    0x2c(%edx,%esi,4),%eax
80103b6c:	85 c0                	test   %eax,%eax
80103b6e:	74 17                	je     80103b87 <fork+0xa7>
      np->ofile[i] = filedup(proc->ofile[i]);
80103b70:	83 ec 0c             	sub    $0xc,%esp
80103b73:	50                   	push   %eax
80103b74:	e8 47 d3 ff ff       	call   80100ec0 <filedup>
80103b79:	89 44 b3 2c          	mov    %eax,0x2c(%ebx,%esi,4)
80103b7d:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103b84:	83 c4 10             	add    $0x10,%esp
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103b87:	83 c6 01             	add    $0x1,%esi
80103b8a:	83 fe 10             	cmp    $0x10,%esi
80103b8d:	75 d9                	jne    80103b68 <fork+0x88>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80103b8f:	83 ec 0c             	sub    $0xc,%esp
80103b92:	ff 72 6c             	pushl  0x6c(%edx)
80103b95:	e8 46 db ff ff       	call   801016e0 <idup>
80103b9a:	89 43 6c             	mov    %eax,0x6c(%ebx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80103b9d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ba3:	83 c4 0c             	add    $0xc,%esp
80103ba6:	6a 10                	push   $0x10
80103ba8:	83 c0 70             	add    $0x70,%eax
80103bab:	50                   	push   %eax
80103bac:	8d 43 70             	lea    0x70(%ebx),%eax
80103baf:	50                   	push   %eax
80103bb0:	e8 2b 0b 00 00       	call   801046e0 <safestrcpy>

  pid = np->pid;
80103bb5:	8b 73 14             	mov    0x14(%ebx),%esi

  acquire(&ptable.lock);
80103bb8:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103bbf:	e8 ec 06 00 00       	call   801042b0 <acquire>

  np->state = RUNNABLE;
80103bc4:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)

  release(&ptable.lock);
80103bcb:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103bd2:	e8 b9 08 00 00       	call   80104490 <release>

  return pid;
80103bd7:	83 c4 10             	add    $0x10,%esp
80103bda:	89 f0                	mov    %esi,%eax
}
80103bdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bdf:	5b                   	pop    %ebx
80103be0:	5e                   	pop    %esi
80103be1:	5f                   	pop    %edi
80103be2:	5d                   	pop    %ebp
80103be3:	c3                   	ret    

  acquire(&ptable.lock);

  // Allocate process.
  if((np = allocproc()) == 0){
    release(&ptable.lock);
80103be4:	83 ec 0c             	sub    $0xc,%esp
80103be7:	68 e0 18 11 80       	push   $0x801118e0
80103bec:	e8 9f 08 00 00       	call   80104490 <release>
    return -1;
80103bf1:	83 c4 10             	add    $0x10,%esp
80103bf4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bf9:	eb e1                	jmp    80103bdc <fork+0xfc>

  release(&ptable.lock);

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
80103bfb:	83 ec 0c             	sub    $0xc,%esp
80103bfe:	ff 73 0c             	pushl  0xc(%ebx)
80103c01:	e8 ca e7 ff ff       	call   801023d0 <kfree>
    np->kstack = 0;
80103c06:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    np->state = UNUSED;
80103c0d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    release(&ptable.lock);
80103c14:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103c1b:	e8 70 08 00 00       	call   80104490 <release>
    return -1;
80103c20:	83 c4 10             	add    $0x10,%esp
80103c23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c28:	eb b2                	jmp    80103bdc <fork+0xfc>
80103c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c30 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	53                   	push   %ebx
80103c34:	83 ec 04             	sub    $0x4,%esp
80103c37:	89 f6                	mov    %esi,%esi
80103c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103c40:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103c41:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c44:	bb 14 19 11 80       	mov    $0x80111914,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103c49:	68 e0 18 11 80       	push   $0x801118e0
80103c4e:	e8 5d 06 00 00       	call   801042b0 <acquire>
80103c53:	83 c4 10             	add    $0x10,%esp
80103c56:	eb 13                	jmp    80103c6b <scheduler+0x3b>
80103c58:	90                   	nop
80103c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c60:	83 eb 80             	sub    $0xffffff80,%ebx
80103c63:	81 fb 14 39 11 80    	cmp    $0x80113914,%ebx
80103c69:	74 55                	je     80103cc0 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103c6b:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
80103c6f:	75 ef                	jne    80103c60 <scheduler+0x30>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103c71:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80103c74:	65 89 1d 04 00 00 00 	mov    %ebx,%gs:0x4
      switchuvm(p);
80103c7b:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c7c:	83 eb 80             	sub    $0xffffff80,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
80103c7f:	e8 8c 2d 00 00       	call   80106a10 <switchuvm>
      p->state = RUNNING;
      swtch(&cpu->scheduler, p->context);
80103c84:	58                   	pop    %eax
80103c85:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103c8b:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)
      swtch(&cpu->scheduler, p->context);
80103c92:	5a                   	pop    %edx
80103c93:	ff 73 a0             	pushl  -0x60(%ebx)
80103c96:	83 c0 04             	add    $0x4,%eax
80103c99:	50                   	push   %eax
80103c9a:	e8 9c 0a 00 00       	call   8010473b <swtch>
      switchkvm();
80103c9f:	e8 4c 2d 00 00       	call   801069f0 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103ca4:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ca7:	81 fb 14 39 11 80    	cmp    $0x80113914,%ebx
      swtch(&cpu->scheduler, p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80103cad:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80103cb4:	00 00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb8:	75 b1                	jne    80103c6b <scheduler+0x3b>
80103cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
80103cc0:	83 ec 0c             	sub    $0xc,%esp
80103cc3:	68 e0 18 11 80       	push   $0x801118e0
80103cc8:	e8 c3 07 00 00       	call   80104490 <release>

  }
80103ccd:	83 c4 10             	add    $0x10,%esp
80103cd0:	e9 6b ff ff ff       	jmp    80103c40 <scheduler+0x10>
80103cd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ce0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	53                   	push   %ebx
80103ce4:	83 ec 10             	sub    $0x10,%esp
  int intena;

  if(!holding(&ptable.lock))
80103ce7:	68 e0 18 11 80       	push   $0x801118e0
80103cec:	e8 ef 06 00 00       	call   801043e0 <holding>
80103cf1:	83 c4 10             	add    $0x10,%esp
80103cf4:	85 c0                	test   %eax,%eax
80103cf6:	74 4c                	je     80103d44 <sched+0x64>
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
80103cf8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80103cff:	83 ba ac 00 00 00 01 	cmpl   $0x1,0xac(%edx)
80103d06:	75 63                	jne    80103d6b <sched+0x8b>
    panic("sched locks");
  if(proc->state == RUNNING)
80103d08:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103d0e:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80103d12:	74 4a                	je     80103d5e <sched+0x7e>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103d14:	9c                   	pushf  
80103d15:	59                   	pop    %ecx
    panic("sched running");
  if(readeflags()&FL_IF)
80103d16:	80 e5 02             	and    $0x2,%ch
80103d19:	75 36                	jne    80103d51 <sched+0x71>
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
80103d1b:	83 ec 08             	sub    $0x8,%esp
80103d1e:	83 c0 20             	add    $0x20,%eax
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
80103d21:	8b 9a b0 00 00 00    	mov    0xb0(%edx),%ebx
  swtch(&proc->context, cpu->scheduler);
80103d27:	ff 72 04             	pushl  0x4(%edx)
80103d2a:	50                   	push   %eax
80103d2b:	e8 0b 0a 00 00       	call   8010473b <swtch>
  cpu->intena = intena;
80103d30:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
}
80103d36:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
80103d39:	89 98 b0 00 00 00    	mov    %ebx,0xb0(%eax)
}
80103d3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d42:	c9                   	leave  
80103d43:	c3                   	ret    
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103d44:	83 ec 0c             	sub    $0xc,%esp
80103d47:	68 38 75 10 80       	push   $0x80107538
80103d4c:	e8 ff c5 ff ff       	call   80100350 <panic>
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103d51:	83 ec 0c             	sub    $0xc,%esp
80103d54:	68 64 75 10 80       	push   $0x80107564
80103d59:	e8 f2 c5 ff ff       	call   80100350 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
80103d5e:	83 ec 0c             	sub    $0xc,%esp
80103d61:	68 56 75 10 80       	push   $0x80107556
80103d66:	e8 e5 c5 ff ff       	call   80100350 <panic>
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
80103d6b:	83 ec 0c             	sub    $0xc,%esp
80103d6e:	68 4a 75 10 80       	push   $0x8010754a
80103d73:	e8 d8 c5 ff ff       	call   80100350 <panic>
80103d78:	90                   	nop
80103d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d80 <exit>:
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
80103d80:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103d87:	3b 15 bc a5 10 80    	cmp    0x8010a5bc,%edx
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103d8d:	55                   	push   %ebp
80103d8e:	89 e5                	mov    %esp,%ebp
80103d90:	56                   	push   %esi
80103d91:	53                   	push   %ebx
  struct proc *p;
  int fd;

  if(proc == initproc)
80103d92:	0f 84 1f 01 00 00    	je     80103eb7 <exit+0x137>
80103d98:	31 db                	xor    %ebx,%ebx
80103d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
80103da0:	8d 73 08             	lea    0x8(%ebx),%esi
80103da3:	8b 44 b2 0c          	mov    0xc(%edx,%esi,4),%eax
80103da7:	85 c0                	test   %eax,%eax
80103da9:	74 1b                	je     80103dc6 <exit+0x46>
      fileclose(proc->ofile[fd]);
80103dab:	83 ec 0c             	sub    $0xc,%esp
80103dae:	50                   	push   %eax
80103daf:	e8 5c d1 ff ff       	call   80100f10 <fileclose>
      proc->ofile[fd] = 0;
80103db4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80103dbb:	83 c4 10             	add    $0x10,%esp
80103dbe:	c7 44 b2 0c 00 00 00 	movl   $0x0,0xc(%edx,%esi,4)
80103dc5:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103dc6:	83 c3 01             	add    $0x1,%ebx
80103dc9:	83 fb 10             	cmp    $0x10,%ebx
80103dcc:	75 d2                	jne    80103da0 <exit+0x20>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80103dce:	e8 ed ee ff ff       	call   80102cc0 <begin_op>
  iput(proc->cwd);
80103dd3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103dd9:	83 ec 0c             	sub    $0xc,%esp
80103ddc:	ff 70 6c             	pushl  0x6c(%eax)
80103ddf:	e8 9c da ff ff       	call   80101880 <iput>
  end_op();
80103de4:	e8 47 ef ff ff       	call   80102d30 <end_op>
  proc->cwd = 0;
80103de9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103def:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)

  acquire(&ptable.lock);
80103df6:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103dfd:	e8 ae 04 00 00       	call   801042b0 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103e02:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
80103e09:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e0c:	b8 14 19 11 80       	mov    $0x80111914,%eax
  proc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80103e11:	8b 51 18             	mov    0x18(%ecx),%edx
80103e14:	eb 14                	jmp    80103e2a <exit+0xaa>
80103e16:	8d 76 00             	lea    0x0(%esi),%esi
80103e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e20:	83 e8 80             	sub    $0xffffff80,%eax
80103e23:	3d 14 39 11 80       	cmp    $0x80113914,%eax
80103e28:	74 1c                	je     80103e46 <exit+0xc6>
    if(p->state == SLEEPING && p->chan == chan)
80103e2a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80103e2e:	75 f0                	jne    80103e20 <exit+0xa0>
80103e30:	3b 50 24             	cmp    0x24(%eax),%edx
80103e33:	75 eb                	jne    80103e20 <exit+0xa0>
      p->state = RUNNABLE;
80103e35:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e3c:	83 e8 80             	sub    $0xffffff80,%eax
80103e3f:	3d 14 39 11 80       	cmp    $0x80113914,%eax
80103e44:	75 e4                	jne    80103e2a <exit+0xaa>
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103e46:	8b 1d bc a5 10 80    	mov    0x8010a5bc,%ebx
80103e4c:	ba 14 19 11 80       	mov    $0x80111914,%edx
80103e51:	eb 10                	jmp    80103e63 <exit+0xe3>
80103e53:	90                   	nop
80103e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e58:	83 ea 80             	sub    $0xffffff80,%edx
80103e5b:	81 fa 14 39 11 80    	cmp    $0x80113914,%edx
80103e61:	74 3b                	je     80103e9e <exit+0x11e>
    if(p->parent == proc){
80103e63:	3b 4a 18             	cmp    0x18(%edx),%ecx
80103e66:	75 f0                	jne    80103e58 <exit+0xd8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103e68:	83 7a 10 05          	cmpl   $0x5,0x10(%edx)
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == proc){
      p->parent = initproc;
80103e6c:	89 5a 18             	mov    %ebx,0x18(%edx)
      if(p->state == ZOMBIE)
80103e6f:	75 e7                	jne    80103e58 <exit+0xd8>
80103e71:	b8 14 19 11 80       	mov    $0x80111914,%eax
80103e76:	eb 12                	jmp    80103e8a <exit+0x10a>
80103e78:	90                   	nop
80103e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e80:	83 e8 80             	sub    $0xffffff80,%eax
80103e83:	3d 14 39 11 80       	cmp    $0x80113914,%eax
80103e88:	74 ce                	je     80103e58 <exit+0xd8>
    if(p->state == SLEEPING && p->chan == chan)
80103e8a:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
80103e8e:	75 f0                	jne    80103e80 <exit+0x100>
80103e90:	3b 58 24             	cmp    0x24(%eax),%ebx
80103e93:	75 eb                	jne    80103e80 <exit+0x100>
      p->state = RUNNABLE;
80103e95:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
80103e9c:	eb e2                	jmp    80103e80 <exit+0x100>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80103e9e:	c7 41 10 05 00 00 00 	movl   $0x5,0x10(%ecx)
  sched();
80103ea5:	e8 36 fe ff ff       	call   80103ce0 <sched>
  panic("zombie exit");
80103eaa:	83 ec 0c             	sub    $0xc,%esp
80103ead:	68 85 75 10 80       	push   $0x80107585
80103eb2:	e8 99 c4 ff ff       	call   80100350 <panic>
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");
80103eb7:	83 ec 0c             	sub    $0xc,%esp
80103eba:	68 78 75 10 80       	push   $0x80107578
80103ebf:	e8 8c c4 ff ff       	call   80100350 <panic>
80103ec4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103eca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ed0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ed6:	68 e0 18 11 80       	push   $0x801118e0
80103edb:	e8 d0 03 00 00       	call   801042b0 <acquire>
  proc->state = RUNNABLE;
80103ee0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103ee6:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  proc->priority = 1;
80103eed:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  sched();
80103ef3:	e8 e8 fd ff ff       	call   80103ce0 <sched>
  release(&ptable.lock);
80103ef8:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103eff:	e8 8c 05 00 00       	call   80104490 <release>
}
80103f04:	83 c4 10             	add    $0x10,%esp
80103f07:	c9                   	leave  
80103f08:	c3                   	ret    
80103f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f10 <sleep>:
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
80103f10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103f16:	55                   	push   %ebp
80103f17:	89 e5                	mov    %esp,%ebp
80103f19:	56                   	push   %esi
80103f1a:	53                   	push   %ebx
  if(proc == 0)
80103f1b:	85 c0                	test   %eax,%eax

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103f1d:	8b 75 08             	mov    0x8(%ebp),%esi
80103f20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(proc == 0)
80103f23:	0f 84 a5 00 00 00    	je     80103fce <sleep+0xbe>
    panic("sleep");

  if(lk == 0)
80103f29:	85 db                	test   %ebx,%ebx
80103f2b:	0f 84 90 00 00 00    	je     80103fc1 <sleep+0xb1>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f31:	81 fb e0 18 11 80    	cmp    $0x801118e0,%ebx
80103f37:	74 5f                	je     80103f98 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f39:	83 ec 0c             	sub    $0xc,%esp
80103f3c:	68 e0 18 11 80       	push   $0x801118e0
80103f41:	e8 6a 03 00 00       	call   801042b0 <acquire>
    release(lk);
80103f46:	89 1c 24             	mov    %ebx,(%esp)
80103f49:	e8 42 05 00 00       	call   80104490 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80103f4e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f54:	89 70 24             	mov    %esi,0x24(%eax)
  proc->state = SLEEPING;
80103f57:	c7 40 10 02 00 00 00 	movl   $0x2,0x10(%eax)
  proc->priority = 0;
80103f5e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  sched();
80103f64:	e8 77 fd ff ff       	call   80103ce0 <sched>

  // Tidy up.
  proc->chan = 0;
80103f69:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f6f:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103f76:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80103f7d:	e8 0e 05 00 00       	call   80104490 <release>
    acquire(lk);
80103f82:	89 5d 08             	mov    %ebx,0x8(%ebp)
80103f85:	83 c4 10             	add    $0x10,%esp
  }
}
80103f88:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f8b:	5b                   	pop    %ebx
80103f8c:	5e                   	pop    %esi
80103f8d:	5d                   	pop    %ebp
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103f8e:	e9 1d 03 00 00       	jmp    801042b0 <acquire>
80103f93:	90                   	nop
80103f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
80103f98:	89 70 24             	mov    %esi,0x24(%eax)
  proc->state = SLEEPING;
80103f9b:	c7 40 10 02 00 00 00 	movl   $0x2,0x10(%eax)
  proc->priority = 0;
80103fa2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  sched();
80103fa8:	e8 33 fd ff ff       	call   80103ce0 <sched>

  // Tidy up.
  proc->chan = 0;
80103fad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103fb3:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103fba:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fbd:	5b                   	pop    %ebx
80103fbe:	5e                   	pop    %esi
80103fbf:	5d                   	pop    %ebp
80103fc0:	c3                   	ret    
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103fc1:	83 ec 0c             	sub    $0xc,%esp
80103fc4:	68 97 75 10 80       	push   $0x80107597
80103fc9:	e8 82 c3 ff ff       	call   80100350 <panic>
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");
80103fce:	83 ec 0c             	sub    $0xc,%esp
80103fd1:	68 91 75 10 80       	push   $0x80107591
80103fd6:	e8 75 c3 ff ff       	call   80100350 <panic>
80103fdb:	90                   	nop
80103fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103fe0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	56                   	push   %esi
80103fe4:	53                   	push   %ebx
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80103fe5:	83 ec 0c             	sub    $0xc,%esp
80103fe8:	68 e0 18 11 80       	push   $0x801118e0
80103fed:	e8 be 02 00 00       	call   801042b0 <acquire>
80103ff2:	83 c4 10             	add    $0x10,%esp
80103ff5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103ffb:	31 d2                	xor    %edx,%edx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ffd:	bb 14 19 11 80       	mov    $0x80111914,%ebx
80104002:	eb 0f                	jmp    80104013 <wait+0x33>
80104004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104008:	83 eb 80             	sub    $0xffffff80,%ebx
8010400b:	81 fb 14 39 11 80    	cmp    $0x80113914,%ebx
80104011:	74 1d                	je     80104030 <wait+0x50>
      if(p->parent != proc)
80104013:	3b 43 18             	cmp    0x18(%ebx),%eax
80104016:	75 f0                	jne    80104008 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80104018:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
8010401c:	74 30                	je     8010404e <wait+0x6e>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010401e:	83 eb 80             	sub    $0xffffff80,%ebx
      if(p->parent != proc)
        continue;
      havekids = 1;
80104021:	ba 01 00 00 00       	mov    $0x1,%edx

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104026:	81 fb 14 39 11 80    	cmp    $0x80113914,%ebx
8010402c:	75 e5                	jne    80104013 <wait+0x33>
8010402e:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104030:	85 d2                	test   %edx,%edx
80104032:	74 76                	je     801040aa <wait+0xca>
80104034:	8b 50 28             	mov    0x28(%eax),%edx
80104037:	85 d2                	test   %edx,%edx
80104039:	75 6f                	jne    801040aa <wait+0xca>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
8010403b:	83 ec 08             	sub    $0x8,%esp
8010403e:	68 e0 18 11 80       	push   $0x801118e0
80104043:	50                   	push   %eax
80104044:	e8 c7 fe ff ff       	call   80103f10 <sleep>
  }
80104049:	83 c4 10             	add    $0x10,%esp
8010404c:	eb a7                	jmp    80103ff5 <wait+0x15>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
8010404e:	83 ec 0c             	sub    $0xc,%esp
80104051:	ff 73 0c             	pushl  0xc(%ebx)
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80104054:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
80104057:	e8 74 e3 ff ff       	call   801023d0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
8010405c:	59                   	pop    %ecx
8010405d:	ff 73 08             	pushl  0x8(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80104060:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
80104067:	e8 b4 2c 00 00       	call   80106d20 <freevm>
        p->pid = 0;
8010406c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
80104073:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
8010407a:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
8010407e:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80104085:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
	p->priority = 0;
8010408c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
        release(&ptable.lock);
80104092:	c7 04 24 e0 18 11 80 	movl   $0x801118e0,(%esp)
80104099:	e8 f2 03 00 00       	call   80104490 <release>
        return pid;
8010409e:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
801040a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
	p->priority = 0;
        release(&ptable.lock);
        return pid;
801040a4:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
801040a6:	5b                   	pop    %ebx
801040a7:	5e                   	pop    %esi
801040a8:	5d                   	pop    %ebp
801040a9:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
801040aa:	83 ec 0c             	sub    $0xc,%esp
801040ad:	68 e0 18 11 80       	push   $0x801118e0
801040b2:	e8 d9 03 00 00       	call   80104490 <release>
      return -1;
801040b7:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
801040ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
801040bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}
801040c2:	5b                   	pop    %ebx
801040c3:	5e                   	pop    %esi
801040c4:	5d                   	pop    %ebp
801040c5:	c3                   	ret    
801040c6:	8d 76 00             	lea    0x0(%esi),%esi
801040c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040d0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	53                   	push   %ebx
801040d4:	83 ec 10             	sub    $0x10,%esp
801040d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801040da:	68 e0 18 11 80       	push   $0x801118e0
801040df:	e8 cc 01 00 00       	call   801042b0 <acquire>
801040e4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040e7:	b8 14 19 11 80       	mov    $0x80111914,%eax
801040ec:	eb 0c                	jmp    801040fa <wakeup+0x2a>
801040ee:	66 90                	xchg   %ax,%ax
801040f0:	83 e8 80             	sub    $0xffffff80,%eax
801040f3:	3d 14 39 11 80       	cmp    $0x80113914,%eax
801040f8:	74 1c                	je     80104116 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801040fa:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801040fe:	75 f0                	jne    801040f0 <wakeup+0x20>
80104100:	3b 58 24             	cmp    0x24(%eax),%ebx
80104103:	75 eb                	jne    801040f0 <wakeup+0x20>
      p->state = RUNNABLE;
80104105:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010410c:	83 e8 80             	sub    $0xffffff80,%eax
8010410f:	3d 14 39 11 80       	cmp    $0x80113914,%eax
80104114:	75 e4                	jne    801040fa <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104116:	c7 45 08 e0 18 11 80 	movl   $0x801118e0,0x8(%ebp)
}
8010411d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104120:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104121:	e9 6a 03 00 00       	jmp    80104490 <release>
80104126:	8d 76 00             	lea    0x0(%esi),%esi
80104129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104130 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 10             	sub    $0x10,%esp
80104137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010413a:	68 e0 18 11 80       	push   $0x801118e0
8010413f:	e8 6c 01 00 00       	call   801042b0 <acquire>
80104144:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104147:	b8 14 19 11 80       	mov    $0x80111914,%eax
8010414c:	eb 0c                	jmp    8010415a <kill+0x2a>
8010414e:	66 90                	xchg   %ax,%ax
80104150:	83 e8 80             	sub    $0xffffff80,%eax
80104153:	3d 14 39 11 80       	cmp    $0x80113914,%eax
80104158:	74 3e                	je     80104198 <kill+0x68>
    if(p->pid == pid){
8010415a:	39 58 14             	cmp    %ebx,0x14(%eax)
8010415d:	75 f1                	jne    80104150 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010415f:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104163:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010416a:	74 1c                	je     80104188 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010416c:	83 ec 0c             	sub    $0xc,%esp
8010416f:	68 e0 18 11 80       	push   $0x801118e0
80104174:	e8 17 03 00 00       	call   80104490 <release>
      return 0;
80104179:	83 c4 10             	add    $0x10,%esp
8010417c:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010417e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104181:	c9                   	leave  
80104182:	c3                   	ret    
80104183:	90                   	nop
80104184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104188:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
8010418f:	eb db                	jmp    8010416c <kill+0x3c>
80104191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	68 e0 18 11 80       	push   $0x801118e0
801041a0:	e8 eb 02 00 00       	call   80104490 <release>
  return -1;
801041a5:	83 c4 10             	add    $0x10,%esp
801041a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041b0:	c9                   	leave  
801041b1:	c3                   	ret    
801041b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	57                   	push   %edi
801041c4:	56                   	push   %esi
801041c5:	53                   	push   %ebx
801041c6:	8d 75 e8             	lea    -0x18(%ebp),%esi
801041c9:	bb 84 19 11 80       	mov    $0x80111984,%ebx
801041ce:	83 ec 3c             	sub    $0x3c,%esp
801041d1:	eb 24                	jmp    801041f7 <procdump+0x37>
801041d3:	90                   	nop
801041d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801041d8:	83 ec 0c             	sub    $0xc,%esp
801041db:	68 e6 74 10 80       	push   $0x801074e6
801041e0:	e8 5b c4 ff ff       	call   80100640 <cprintf>
801041e5:	83 c4 10             	add    $0x10,%esp
801041e8:	83 eb 80             	sub    $0xffffff80,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801041eb:	81 fb 84 39 11 80    	cmp    $0x80113984,%ebx
801041f1:	0f 84 89 00 00 00    	je     80104280 <procdump+0xc0>
    if(p->state == UNUSED)
801041f7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801041fa:	85 c0                	test   %eax,%eax
801041fc:	74 ea                	je     801041e8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801041fe:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104201:	ba a8 75 10 80       	mov    $0x801075a8,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104206:	77 11                	ja     80104219 <procdump+0x59>
80104208:	8b 14 85 e4 75 10 80 	mov    -0x7fef8a1c(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
8010420f:	b8 a8 75 10 80       	mov    $0x801075a8,%eax
80104214:	85 d2                	test   %edx,%edx
80104216:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %d %s %s",p->priority, p->pid, state, p->name);
80104219:	83 ec 0c             	sub    $0xc,%esp
8010421c:	53                   	push   %ebx
8010421d:	52                   	push   %edx
8010421e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104221:	ff 73 90             	pushl  -0x70(%ebx)
80104224:	68 ac 75 10 80       	push   $0x801075ac
80104229:	e8 12 c4 ff ff       	call   80100640 <cprintf>
    if(p->state == SLEEPING){
8010422e:	83 c4 20             	add    $0x20,%esp
80104231:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104235:	75 a1                	jne    801041d8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104237:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010423a:	83 ec 08             	sub    $0x8,%esp
8010423d:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104240:	50                   	push   %eax
80104241:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104244:	8b 40 0c             	mov    0xc(%eax),%eax
80104247:	83 c0 08             	add    $0x8,%eax
8010424a:	50                   	push   %eax
8010424b:	e8 30 01 00 00       	call   80104380 <getcallerpcs>
80104250:	83 c4 10             	add    $0x10,%esp
80104253:	90                   	nop
80104254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104258:	8b 17                	mov    (%edi),%edx
8010425a:	85 d2                	test   %edx,%edx
8010425c:	0f 84 76 ff ff ff    	je     801041d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104262:	83 ec 08             	sub    $0x8,%esp
80104265:	83 c7 04             	add    $0x4,%edi
80104268:	52                   	push   %edx
80104269:	68 e2 6f 10 80       	push   $0x80106fe2
8010426e:	e8 cd c3 ff ff       	call   80100640 <cprintf>
    else
      state = "???";
    cprintf("%d %d %s %s",p->priority, p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104273:	83 c4 10             	add    $0x10,%esp
80104276:	39 f7                	cmp    %esi,%edi
80104278:	75 de                	jne    80104258 <procdump+0x98>
8010427a:	e9 59 ff ff ff       	jmp    801041d8 <procdump+0x18>
8010427f:	90                   	nop
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104280:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104283:	5b                   	pop    %ebx
80104284:	5e                   	pop    %esi
80104285:	5f                   	pop    %edi
80104286:	5d                   	pop    %ebp
80104287:	c3                   	ret    
80104288:	66 90                	xchg   %ax,%ax
8010428a:	66 90                	xchg   %ax,%ax
8010428c:	66 90                	xchg   %ax,%ax
8010428e:	66 90                	xchg   %ax,%ax

80104290 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104296:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104299:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010429f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801042a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801042a9:	5d                   	pop    %ebp
801042aa:	c3                   	ret    
801042ab:	90                   	nop
801042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042b0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	53                   	push   %ebx
801042b4:	83 ec 04             	sub    $0x4,%esp
801042b7:	9c                   	pushf  
801042b8:	5a                   	pop    %edx
}

static inline void
cli(void)
{
  asm volatile("cli");
801042b9:	fa                   	cli    
{
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
801042ba:	65 8b 0d 00 00 00 00 	mov    %gs:0x0,%ecx
801042c1:	8b 81 ac 00 00 00    	mov    0xac(%ecx),%eax
801042c7:	85 c0                	test   %eax,%eax
801042c9:	75 0c                	jne    801042d7 <acquire+0x27>
    cpu->intena = eflags & FL_IF;
801042cb:	81 e2 00 02 00 00    	and    $0x200,%edx
801042d1:	89 91 b0 00 00 00    	mov    %edx,0xb0(%ecx)
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
801042d7:	8b 55 08             	mov    0x8(%ebp),%edx

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
    cpu->intena = eflags & FL_IF;
  cpu->ncli += 1;
801042da:	83 c0 01             	add    $0x1,%eax
801042dd:	89 81 ac 00 00 00    	mov    %eax,0xac(%ecx)

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
801042e3:	8b 02                	mov    (%edx),%eax
801042e5:	85 c0                	test   %eax,%eax
801042e7:	74 05                	je     801042ee <acquire+0x3e>
801042e9:	39 4a 08             	cmp    %ecx,0x8(%edx)
801042ec:	74 7a                	je     80104368 <acquire+0xb8>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801042ee:	b9 01 00 00 00       	mov    $0x1,%ecx
801042f3:	90                   	nop
801042f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042f8:	89 c8                	mov    %ecx,%eax
801042fa:	f0 87 02             	lock xchg %eax,(%edx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801042fd:	85 c0                	test   %eax,%eax
801042ff:	75 f7                	jne    801042f8 <acquire+0x48>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
80104301:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104306:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104309:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010430f:	89 ea                	mov    %ebp,%edx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104311:	89 41 08             	mov    %eax,0x8(%ecx)
  getcallerpcs(&lk, lk->pcs);
80104314:	83 c1 0c             	add    $0xc,%ecx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104317:	31 c0                	xor    %eax,%eax
80104319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104320:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104326:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010432c:	77 1a                	ja     80104348 <acquire+0x98>
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
8010433c:	75 e2                	jne    80104320 <acquire+0x70>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
  getcallerpcs(&lk, lk->pcs);
}
8010433e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104341:	c9                   	leave  
80104342:	c3                   	ret    
80104343:	90                   	nop
80104344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
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
80104355:	74 e7                	je     8010433e <acquire+0x8e>
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
80104364:	75 e2                	jne    80104348 <acquire+0x98>
80104366:	eb d6                	jmp    8010433e <acquire+0x8e>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104368:	83 ec 0c             	sub    $0xc,%esp
8010436b:	68 fc 75 10 80       	push   $0x801075fc
80104370:	e8 db bf ff ff       	call   80100350 <panic>
80104375:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104380 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104384:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104387:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010438a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010438d:	31 c0                	xor    %eax,%eax
8010438f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104390:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104396:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010439c:	77 1a                	ja     801043b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010439e:	8b 5a 04             	mov    0x4(%edx),%ebx
801043a1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043a4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801043a7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043a9:	83 f8 0a             	cmp    $0xa,%eax
801043ac:	75 e2                	jne    80104390 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801043ae:	5b                   	pop    %ebx
801043af:	5d                   	pop    %ebp
801043b0:	c3                   	ret    
801043b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801043b8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801043bf:	83 c0 01             	add    $0x1,%eax
801043c2:	83 f8 0a             	cmp    $0xa,%eax
801043c5:	74 e7                	je     801043ae <getcallerpcs+0x2e>
    pcs[i] = 0;
801043c7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801043ce:	83 c0 01             	add    $0x1,%eax
801043d1:	83 f8 0a             	cmp    $0xa,%eax
801043d4:	75 e2                	jne    801043b8 <getcallerpcs+0x38>
801043d6:	eb d6                	jmp    801043ae <getcallerpcs+0x2e>
801043d8:	90                   	nop
801043d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801043e0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == cpu;
801043e6:	8b 02                	mov    (%edx),%eax
801043e8:	85 c0                	test   %eax,%eax
801043ea:	74 14                	je     80104400 <holding+0x20>
801043ec:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801043f2:	39 42 08             	cmp    %eax,0x8(%edx)
}
801043f5:	5d                   	pop    %ebp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
801043f6:	0f 94 c0             	sete   %al
801043f9:	0f b6 c0             	movzbl %al,%eax
}
801043fc:	c3                   	ret    
801043fd:	8d 76 00             	lea    0x0(%esi),%esi
80104400:	31 c0                	xor    %eax,%eax
80104402:	5d                   	pop    %ebp
80104403:	c3                   	ret    
80104404:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010440a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104410 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104413:	9c                   	pushf  
80104414:	59                   	pop    %ecx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104415:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(cpu->ncli == 0)
80104416:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010441d:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80104423:	85 c0                	test   %eax,%eax
80104425:	75 0c                	jne    80104433 <pushcli+0x23>
    cpu->intena = eflags & FL_IF;
80104427:	81 e1 00 02 00 00    	and    $0x200,%ecx
8010442d:	89 8a b0 00 00 00    	mov    %ecx,0xb0(%edx)
  cpu->ncli += 1;
80104433:	83 c0 01             	add    $0x1,%eax
80104436:	89 82 ac 00 00 00    	mov    %eax,0xac(%edx)
}
8010443c:	5d                   	pop    %ebp
8010443d:	c3                   	ret    
8010443e:	66 90                	xchg   %ax,%ax

80104440 <popcli>:

void
popcli(void)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104446:	9c                   	pushf  
80104447:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104448:	f6 c4 02             	test   $0x2,%ah
8010444b:	75 2c                	jne    80104479 <popcli+0x39>
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
8010444d:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104454:	83 aa ac 00 00 00 01 	subl   $0x1,0xac(%edx)
8010445b:	78 0f                	js     8010446c <popcli+0x2c>
    panic("popcli");
  if(cpu->ncli == 0 && cpu->intena)
8010445d:	75 0b                	jne    8010446a <popcli+0x2a>
8010445f:	8b 82 b0 00 00 00    	mov    0xb0(%edx),%eax
80104465:	85 c0                	test   %eax,%eax
80104467:	74 01                	je     8010446a <popcli+0x2a>
}

static inline void
sti(void)
{
  asm volatile("sti");
80104469:	fb                   	sti    
    sti();
}
8010446a:	c9                   	leave  
8010446b:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--cpu->ncli < 0)
    panic("popcli");
8010446c:	83 ec 0c             	sub    $0xc,%esp
8010446f:	68 1b 76 10 80       	push   $0x8010761b
80104474:	e8 d7 be ff ff       	call   80100350 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
80104479:	83 ec 0c             	sub    $0xc,%esp
8010447c:	68 04 76 10 80       	push   $0x80107604
80104481:	e8 ca be ff ff       	call   80100350 <panic>
80104486:	8d 76 00             	lea    0x0(%esi),%esi
80104489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104490 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	83 ec 08             	sub    $0x8,%esp
80104496:	8b 45 08             	mov    0x8(%ebp),%eax

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == cpu;
80104499:	8b 10                	mov    (%eax),%edx
8010449b:	85 d2                	test   %edx,%edx
8010449d:	74 0c                	je     801044ab <release+0x1b>
8010449f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801044a6:	39 50 08             	cmp    %edx,0x8(%eax)
801044a9:	74 15                	je     801044c0 <release+0x30>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
801044ab:	83 ec 0c             	sub    $0xc,%esp
801044ae:	68 22 76 10 80       	push   $0x80107622
801044b3:	e8 98 be ff ff       	call   80100350 <panic>
801044b8:	90                   	nop
801044b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  lk->pcs[0] = 0;
801044c0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801044c7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both to not re-order.
  __sync_synchronize();
801044ce:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801044d3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
}
801044d9:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801044da:	e9 61 ff ff ff       	jmp    80104440 <popcli>
801044df:	90                   	nop

801044e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	57                   	push   %edi
801044e4:	53                   	push   %ebx
801044e5:	8b 55 08             	mov    0x8(%ebp),%edx
801044e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801044eb:	f6 c2 03             	test   $0x3,%dl
801044ee:	75 05                	jne    801044f5 <memset+0x15>
801044f0:	f6 c1 03             	test   $0x3,%cl
801044f3:	74 13                	je     80104508 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801044f5:	89 d7                	mov    %edx,%edi
801044f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801044fa:	fc                   	cld    
801044fb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801044fd:	5b                   	pop    %ebx
801044fe:	89 d0                	mov    %edx,%eax
80104500:	5f                   	pop    %edi
80104501:	5d                   	pop    %ebp
80104502:	c3                   	ret    
80104503:	90                   	nop
80104504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104508:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010450c:	c1 e9 02             	shr    $0x2,%ecx
8010450f:	89 fb                	mov    %edi,%ebx
80104511:	89 f8                	mov    %edi,%eax
80104513:	c1 e3 18             	shl    $0x18,%ebx
80104516:	c1 e0 10             	shl    $0x10,%eax
80104519:	09 d8                	or     %ebx,%eax
8010451b:	09 f8                	or     %edi,%eax
8010451d:	c1 e7 08             	shl    $0x8,%edi
80104520:	09 f8                	or     %edi,%eax
80104522:	89 d7                	mov    %edx,%edi
80104524:	fc                   	cld    
80104525:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104527:	5b                   	pop    %ebx
80104528:	89 d0                	mov    %edx,%eax
8010452a:	5f                   	pop    %edi
8010452b:	5d                   	pop    %ebp
8010452c:	c3                   	ret    
8010452d:	8d 76 00             	lea    0x0(%esi),%esi

80104530 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	57                   	push   %edi
80104534:	56                   	push   %esi
80104535:	8b 45 10             	mov    0x10(%ebp),%eax
80104538:	53                   	push   %ebx
80104539:	8b 75 0c             	mov    0xc(%ebp),%esi
8010453c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010453f:	85 c0                	test   %eax,%eax
80104541:	74 29                	je     8010456c <memcmp+0x3c>
    if(*s1 != *s2)
80104543:	0f b6 13             	movzbl (%ebx),%edx
80104546:	0f b6 0e             	movzbl (%esi),%ecx
80104549:	38 d1                	cmp    %dl,%cl
8010454b:	75 2b                	jne    80104578 <memcmp+0x48>
8010454d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104550:	31 c0                	xor    %eax,%eax
80104552:	eb 14                	jmp    80104568 <memcmp+0x38>
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104558:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010455d:	83 c0 01             	add    $0x1,%eax
80104560:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104564:	38 ca                	cmp    %cl,%dl
80104566:	75 10                	jne    80104578 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104568:	39 f8                	cmp    %edi,%eax
8010456a:	75 ec                	jne    80104558 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010456c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010456d:	31 c0                	xor    %eax,%eax
}
8010456f:	5e                   	pop    %esi
80104570:	5f                   	pop    %edi
80104571:	5d                   	pop    %ebp
80104572:	c3                   	ret    
80104573:	90                   	nop
80104574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104578:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010457b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010457c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010457e:	5e                   	pop    %esi
8010457f:	5f                   	pop    %edi
80104580:	5d                   	pop    %ebp
80104581:	c3                   	ret    
80104582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	53                   	push   %ebx
80104595:	8b 45 08             	mov    0x8(%ebp),%eax
80104598:	8b 75 0c             	mov    0xc(%ebp),%esi
8010459b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010459e:	39 c6                	cmp    %eax,%esi
801045a0:	73 2e                	jae    801045d0 <memmove+0x40>
801045a2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801045a5:	39 c8                	cmp    %ecx,%eax
801045a7:	73 27                	jae    801045d0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
801045a9:	85 db                	test   %ebx,%ebx
801045ab:	8d 53 ff             	lea    -0x1(%ebx),%edx
801045ae:	74 17                	je     801045c7 <memmove+0x37>
      *--d = *--s;
801045b0:	29 d9                	sub    %ebx,%ecx
801045b2:	89 cb                	mov    %ecx,%ebx
801045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045b8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801045bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801045bf:	83 ea 01             	sub    $0x1,%edx
801045c2:	83 fa ff             	cmp    $0xffffffff,%edx
801045c5:	75 f1                	jne    801045b8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801045c7:	5b                   	pop    %ebx
801045c8:	5e                   	pop    %esi
801045c9:	5d                   	pop    %ebp
801045ca:	c3                   	ret    
801045cb:	90                   	nop
801045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801045d0:	31 d2                	xor    %edx,%edx
801045d2:	85 db                	test   %ebx,%ebx
801045d4:	74 f1                	je     801045c7 <memmove+0x37>
801045d6:	8d 76 00             	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
801045e0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801045e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801045e7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801045ea:	39 d3                	cmp    %edx,%ebx
801045ec:	75 f2                	jne    801045e0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801045ee:	5b                   	pop    %ebx
801045ef:	5e                   	pop    %esi
801045f0:	5d                   	pop    %ebp
801045f1:	c3                   	ret    
801045f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104600 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104603:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104604:	eb 8a                	jmp    80104590 <memmove>
80104606:	8d 76 00             	lea    0x0(%esi),%esi
80104609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104610 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	57                   	push   %edi
80104614:	56                   	push   %esi
80104615:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104618:	53                   	push   %ebx
80104619:	8b 7d 08             	mov    0x8(%ebp),%edi
8010461c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010461f:	85 c9                	test   %ecx,%ecx
80104621:	74 37                	je     8010465a <strncmp+0x4a>
80104623:	0f b6 17             	movzbl (%edi),%edx
80104626:	0f b6 1e             	movzbl (%esi),%ebx
80104629:	84 d2                	test   %dl,%dl
8010462b:	74 3f                	je     8010466c <strncmp+0x5c>
8010462d:	38 d3                	cmp    %dl,%bl
8010462f:	75 3b                	jne    8010466c <strncmp+0x5c>
80104631:	8d 47 01             	lea    0x1(%edi),%eax
80104634:	01 cf                	add    %ecx,%edi
80104636:	eb 1b                	jmp    80104653 <strncmp+0x43>
80104638:	90                   	nop
80104639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104640:	0f b6 10             	movzbl (%eax),%edx
80104643:	84 d2                	test   %dl,%dl
80104645:	74 21                	je     80104668 <strncmp+0x58>
80104647:	0f b6 19             	movzbl (%ecx),%ebx
8010464a:	83 c0 01             	add    $0x1,%eax
8010464d:	89 ce                	mov    %ecx,%esi
8010464f:	38 da                	cmp    %bl,%dl
80104651:	75 19                	jne    8010466c <strncmp+0x5c>
80104653:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104655:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104658:	75 e6                	jne    80104640 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010465a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010465b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010465d:	5e                   	pop    %esi
8010465e:	5f                   	pop    %edi
8010465f:	5d                   	pop    %ebp
80104660:	c3                   	ret    
80104661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104668:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010466c:	0f b6 c2             	movzbl %dl,%eax
8010466f:	29 d8                	sub    %ebx,%eax
}
80104671:	5b                   	pop    %ebx
80104672:	5e                   	pop    %esi
80104673:	5f                   	pop    %edi
80104674:	5d                   	pop    %ebp
80104675:	c3                   	ret    
80104676:	8d 76 00             	lea    0x0(%esi),%esi
80104679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104680 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 45 08             	mov    0x8(%ebp),%eax
80104688:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010468b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010468e:	89 c2                	mov    %eax,%edx
80104690:	eb 19                	jmp    801046ab <strncpy+0x2b>
80104692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104698:	83 c3 01             	add    $0x1,%ebx
8010469b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010469f:	83 c2 01             	add    $0x1,%edx
801046a2:	84 c9                	test   %cl,%cl
801046a4:	88 4a ff             	mov    %cl,-0x1(%edx)
801046a7:	74 09                	je     801046b2 <strncpy+0x32>
801046a9:	89 f1                	mov    %esi,%ecx
801046ab:	85 c9                	test   %ecx,%ecx
801046ad:	8d 71 ff             	lea    -0x1(%ecx),%esi
801046b0:	7f e6                	jg     80104698 <strncpy+0x18>
    ;
  while(n-- > 0)
801046b2:	31 c9                	xor    %ecx,%ecx
801046b4:	85 f6                	test   %esi,%esi
801046b6:	7e 17                	jle    801046cf <strncpy+0x4f>
801046b8:	90                   	nop
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801046c0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801046c4:	89 f3                	mov    %esi,%ebx
801046c6:	83 c1 01             	add    $0x1,%ecx
801046c9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801046cb:	85 db                	test   %ebx,%ebx
801046cd:	7f f1                	jg     801046c0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
801046cf:	5b                   	pop    %ebx
801046d0:	5e                   	pop    %esi
801046d1:	5d                   	pop    %ebp
801046d2:	c3                   	ret    
801046d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	53                   	push   %ebx
801046e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046e8:	8b 45 08             	mov    0x8(%ebp),%eax
801046eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801046ee:	85 c9                	test   %ecx,%ecx
801046f0:	7e 26                	jle    80104718 <safestrcpy+0x38>
801046f2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801046f6:	89 c1                	mov    %eax,%ecx
801046f8:	eb 17                	jmp    80104711 <safestrcpy+0x31>
801046fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104700:	83 c2 01             	add    $0x1,%edx
80104703:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104707:	83 c1 01             	add    $0x1,%ecx
8010470a:	84 db                	test   %bl,%bl
8010470c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010470f:	74 04                	je     80104715 <safestrcpy+0x35>
80104711:	39 f2                	cmp    %esi,%edx
80104713:	75 eb                	jne    80104700 <safestrcpy+0x20>
    ;
  *s = 0;
80104715:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104718:	5b                   	pop    %ebx
80104719:	5e                   	pop    %esi
8010471a:	5d                   	pop    %ebp
8010471b:	c3                   	ret    
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104720 <strlen>:

int
strlen(const char *s)
{
80104720:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104721:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104723:	89 e5                	mov    %esp,%ebp
80104725:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104728:	80 3a 00             	cmpb   $0x0,(%edx)
8010472b:	74 0c                	je     80104739 <strlen+0x19>
8010472d:	8d 76 00             	lea    0x0(%esi),%esi
80104730:	83 c0 01             	add    $0x1,%eax
80104733:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104737:	75 f7                	jne    80104730 <strlen+0x10>
    ;
  return n;
}
80104739:	5d                   	pop    %ebp
8010473a:	c3                   	ret    

8010473b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010473b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010473f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104743:	55                   	push   %ebp
  pushl %ebx
80104744:	53                   	push   %ebx
  pushl %esi
80104745:	56                   	push   %esi
  pushl %edi
80104746:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104747:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104749:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010474b:	5f                   	pop    %edi
  popl %esi
8010474c:	5e                   	pop    %esi
  popl %ebx
8010474d:	5b                   	pop    %ebx
  popl %ebp
8010474e:	5d                   	pop    %ebp
  ret
8010474f:	c3                   	ret    

80104750 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104750:	55                   	push   %ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80104751:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104758:	89 e5                	mov    %esp,%ebp
8010475a:	8b 45 08             	mov    0x8(%ebp),%eax
  if(addr >= proc->sz || addr+4 > proc->sz)
8010475d:	8b 52 04             	mov    0x4(%edx),%edx
80104760:	39 c2                	cmp    %eax,%edx
80104762:	76 1c                	jbe    80104780 <fetchint+0x30>
80104764:	8d 48 04             	lea    0x4(%eax),%ecx
80104767:	39 ca                	cmp    %ecx,%edx
80104769:	72 15                	jb     80104780 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010476b:	8b 10                	mov    (%eax),%edx
8010476d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104770:	89 10                	mov    %edx,(%eax)
  return 0;
80104772:	31 c0                	xor    %eax,%eax
}
80104774:	5d                   	pop    %ebp
80104775:	c3                   	ret    
80104776:	8d 76 00             	lea    0x0(%esi),%esi
80104779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  *ip = *(int*)(addr);
  return 0;
}
80104785:	5d                   	pop    %ebp
80104786:	c3                   	ret    
80104787:	89 f6                	mov    %esi,%esi
80104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104790 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104790:	55                   	push   %ebp
  char *s, *ep;

  if(addr >= proc->sz)
80104791:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104797:	89 e5                	mov    %esp,%ebp
80104799:	8b 4d 08             	mov    0x8(%ebp),%ecx
  char *s, *ep;

  if(addr >= proc->sz)
8010479c:	39 48 04             	cmp    %ecx,0x4(%eax)
8010479f:	76 2b                	jbe    801047cc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801047a1:	8b 55 0c             	mov    0xc(%ebp),%edx
801047a4:	89 c8                	mov    %ecx,%eax
801047a6:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801047a8:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801047af:	8b 52 04             	mov    0x4(%edx),%edx
  for(s = *pp; s < ep; s++)
801047b2:	39 d1                	cmp    %edx,%ecx
801047b4:	73 16                	jae    801047cc <fetchstr+0x3c>
    if(*s == 0)
801047b6:	80 39 00             	cmpb   $0x0,(%ecx)
801047b9:	75 0a                	jne    801047c5 <fetchstr+0x35>
801047bb:	eb 1b                	jmp    801047d8 <fetchstr+0x48>
801047bd:	8d 76 00             	lea    0x0(%esi),%esi
801047c0:	80 38 00             	cmpb   $0x0,(%eax)
801047c3:	74 13                	je     801047d8 <fetchstr+0x48>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801047c5:	83 c0 01             	add    $0x1,%eax
801047c8:	39 c2                	cmp    %eax,%edx
801047ca:	77 f4                	ja     801047c0 <fetchstr+0x30>
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
    return -1;
801047cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
  return -1;
}
801047d1:	5d                   	pop    %ebp
801047d2:	c3                   	ret    
801047d3:	90                   	nop
801047d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
    if(*s == 0)
      return s - *pp;
801047d8:	29 c8                	sub    %ecx,%eax
  return -1;
}
801047da:	5d                   	pop    %ebp
801047db:	c3                   	ret    
801047dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047e0:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801047e7:	55                   	push   %ebp
801047e8:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047ea:	8b 42 1c             	mov    0x1c(%edx),%eax
801047ed:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801047f0:	8b 52 04             	mov    0x4(%edx),%edx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
801047f3:	8b 40 44             	mov    0x44(%eax),%eax
801047f6:	8d 04 88             	lea    (%eax,%ecx,4),%eax
801047f9:	8d 48 04             	lea    0x4(%eax),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
801047fc:	39 d1                	cmp    %edx,%ecx
801047fe:	73 18                	jae    80104818 <argint+0x38>
80104800:	8d 48 08             	lea    0x8(%eax),%ecx
80104803:	39 ca                	cmp    %ecx,%edx
80104805:	72 11                	jb     80104818 <argint+0x38>
    return -1;
  *ip = *(int*)(addr);
80104807:	8b 50 04             	mov    0x4(%eax),%edx
8010480a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010480d:	89 10                	mov    %edx,(%eax)
  return 0;
8010480f:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
80104811:	5d                   	pop    %ebp
80104812:	c3                   	ret    
80104813:	90                   	nop
80104814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
80104818:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
}
8010481d:	5d                   	pop    %ebp
8010481e:	c3                   	ret    
8010481f:	90                   	nop

80104820 <argptr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104820:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104826:	55                   	push   %ebp
80104827:	89 e5                	mov    %esp,%ebp
80104829:	53                   	push   %ebx

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010482a:	8b 50 1c             	mov    0x1c(%eax),%edx
8010482d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104830:	8b 52 44             	mov    0x44(%edx),%edx
80104833:	8d 0c 8a             	lea    (%edx,%ecx,4),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104836:	8b 50 04             	mov    0x4(%eax),%edx
argptr(int n, char **pp, int size)
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
80104839:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
8010483e:	8d 59 04             	lea    0x4(%ecx),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
80104841:	39 d3                	cmp    %edx,%ebx
80104843:	73 1e                	jae    80104863 <argptr+0x43>
80104845:	8d 59 08             	lea    0x8(%ecx),%ebx
80104848:	39 da                	cmp    %ebx,%edx
8010484a:	72 17                	jb     80104863 <argptr+0x43>
    return -1;
  *ip = *(int*)(addr);
8010484c:	8b 49 04             	mov    0x4(%ecx),%ecx
{
  int i;

  if(argint(n, &i) < 0)
    return -1;
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
8010484f:	39 d1                	cmp    %edx,%ecx
80104851:	73 10                	jae    80104863 <argptr+0x43>
80104853:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104856:	01 cb                	add    %ecx,%ebx
80104858:	39 d3                	cmp    %edx,%ebx
8010485a:	77 07                	ja     80104863 <argptr+0x43>
    return -1;
  *pp = (char*)i;
8010485c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010485f:	89 08                	mov    %ecx,(%eax)
  return 0;
80104861:	31 c0                	xor    %eax,%eax
}
80104863:	5b                   	pop    %ebx
80104864:	5d                   	pop    %ebp
80104865:	c3                   	ret    
80104866:	8d 76 00             	lea    0x0(%esi),%esi
80104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104870 <argstr>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104870:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104876:	55                   	push   %ebp
80104877:	89 e5                	mov    %esp,%ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104879:	8b 50 1c             	mov    0x1c(%eax),%edx
8010487c:	8b 4d 08             	mov    0x8(%ebp),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010487f:	8b 40 04             	mov    0x4(%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80104882:	8b 52 44             	mov    0x44(%edx),%edx
80104885:	8d 14 8a             	lea    (%edx,%ecx,4),%edx
80104888:	8d 4a 04             	lea    0x4(%edx),%ecx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
8010488b:	39 c1                	cmp    %eax,%ecx
8010488d:	73 07                	jae    80104896 <argstr+0x26>
8010488f:	8d 4a 08             	lea    0x8(%edx),%ecx
80104892:	39 c8                	cmp    %ecx,%eax
80104894:	73 0a                	jae    801048a0 <argstr+0x30>
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104896:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
8010489b:	5d                   	pop    %ebp
8010489c:	c3                   	ret    
8010489d:	8d 76 00             	lea    0x0(%esi),%esi
int
fetchint(uint addr, int *ip)
{
  if(addr >= proc->sz || addr+4 > proc->sz)
    return -1;
  *ip = *(int*)(addr);
801048a0:	8b 4a 04             	mov    0x4(%edx),%ecx
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;

  if(addr >= proc->sz)
801048a3:	39 c1                	cmp    %eax,%ecx
801048a5:	73 ef                	jae    80104896 <argstr+0x26>
    return -1;
  *pp = (char*)addr;
801048a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801048aa:	89 c8                	mov    %ecx,%eax
801048ac:	89 0a                	mov    %ecx,(%edx)
  ep = (char*)proc->sz;
801048ae:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048b5:	8b 52 04             	mov    0x4(%edx),%edx
  for(s = *pp; s < ep; s++)
801048b8:	39 d1                	cmp    %edx,%ecx
801048ba:	73 da                	jae    80104896 <argstr+0x26>
    if(*s == 0)
801048bc:	80 39 00             	cmpb   $0x0,(%ecx)
801048bf:	75 0c                	jne    801048cd <argstr+0x5d>
801048c1:	eb 1d                	jmp    801048e0 <argstr+0x70>
801048c3:	90                   	nop
801048c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048c8:	80 38 00             	cmpb   $0x0,(%eax)
801048cb:	74 13                	je     801048e0 <argstr+0x70>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
801048cd:	83 c0 01             	add    $0x1,%eax
801048d0:	39 c2                	cmp    %eax,%edx
801048d2:	77 f4                	ja     801048c8 <argstr+0x58>
801048d4:	eb c0                	jmp    80104896 <argstr+0x26>
801048d6:	8d 76 00             	lea    0x0(%esi),%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(*s == 0)
      return s - *pp;
801048e0:	29 c8                	sub    %ecx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
801048e2:	5d                   	pop    %ebp
801048e3:	c3                   	ret    
801048e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801048f0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
801048f4:	83 ec 04             	sub    $0x4,%esp
  int num;

  num = proc->tf->eax;
801048f7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801048fe:	8b 5a 1c             	mov    0x1c(%edx),%ebx
80104901:	8b 43 1c             	mov    0x1c(%ebx),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104904:	8d 48 ff             	lea    -0x1(%eax),%ecx
80104907:	83 f9 14             	cmp    $0x14,%ecx
8010490a:	77 1c                	ja     80104928 <syscall+0x38>
8010490c:	8b 0c 85 60 76 10 80 	mov    -0x7fef89a0(,%eax,4),%ecx
80104913:	85 c9                	test   %ecx,%ecx
80104915:	74 11                	je     80104928 <syscall+0x38>
    proc->tf->eax = syscalls[num]();
80104917:	ff d1                	call   *%ecx
80104919:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
  }
}
8010491c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010491f:	c9                   	leave  
80104920:	c3                   	ret    
80104921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104928:	50                   	push   %eax
            proc->pid, proc->name, num);
80104929:	8d 42 70             	lea    0x70(%edx),%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
8010492c:	50                   	push   %eax
8010492d:	ff 72 14             	pushl  0x14(%edx)
80104930:	68 2a 76 10 80       	push   $0x8010762a
80104935:	e8 06 bd ff ff       	call   80100640 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
8010493a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104940:	83 c4 10             	add    $0x10,%esp
80104943:	8b 40 1c             	mov    0x1c(%eax),%eax
80104946:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
8010494d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104950:	c9                   	leave  
80104951:	c3                   	ret    
80104952:	66 90                	xchg   %ax,%ax
80104954:	66 90                	xchg   %ax,%ax
80104956:	66 90                	xchg   %ax,%ax
80104958:	66 90                	xchg   %ax,%ax
8010495a:	66 90                	xchg   %ax,%ax
8010495c:	66 90                	xchg   %ax,%ax
8010495e:	66 90                	xchg   %ax,%ax

80104960 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	57                   	push   %edi
80104964:	56                   	push   %esi
80104965:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104966:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104969:	83 ec 44             	sub    $0x44,%esp
8010496c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010496f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104972:	56                   	push   %esi
80104973:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104974:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104977:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010497a:	e8 41 d6 ff ff       	call   80101fc0 <nameiparent>
8010497f:	83 c4 10             	add    $0x10,%esp
80104982:	85 c0                	test   %eax,%eax
80104984:	0f 84 f6 00 00 00    	je     80104a80 <create+0x120>
    return 0;
  ilock(dp);
8010498a:	83 ec 0c             	sub    $0xc,%esp
8010498d:	89 c7                	mov    %eax,%edi
8010498f:	50                   	push   %eax
80104990:	e8 7b cd ff ff       	call   80101710 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104995:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104998:	83 c4 0c             	add    $0xc,%esp
8010499b:	50                   	push   %eax
8010499c:	56                   	push   %esi
8010499d:	57                   	push   %edi
8010499e:	e8 dd d2 ff ff       	call   80101c80 <dirlookup>
801049a3:	83 c4 10             	add    $0x10,%esp
801049a6:	85 c0                	test   %eax,%eax
801049a8:	89 c3                	mov    %eax,%ebx
801049aa:	74 54                	je     80104a00 <create+0xa0>
    iunlockput(dp);
801049ac:	83 ec 0c             	sub    $0xc,%esp
801049af:	57                   	push   %edi
801049b0:	e8 2b d0 ff ff       	call   801019e0 <iunlockput>
    ilock(ip);
801049b5:	89 1c 24             	mov    %ebx,(%esp)
801049b8:	e8 53 cd ff ff       	call   80101710 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801049bd:	83 c4 10             	add    $0x10,%esp
801049c0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801049c5:	75 19                	jne    801049e0 <create+0x80>
801049c7:	66 83 7b 10 02       	cmpw   $0x2,0x10(%ebx)
801049cc:	89 d8                	mov    %ebx,%eax
801049ce:	75 10                	jne    801049e0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049d3:	5b                   	pop    %ebx
801049d4:	5e                   	pop    %esi
801049d5:	5f                   	pop    %edi
801049d6:	5d                   	pop    %ebp
801049d7:	c3                   	ret    
801049d8:	90                   	nop
801049d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801049e0:	83 ec 0c             	sub    $0xc,%esp
801049e3:	53                   	push   %ebx
801049e4:	e8 f7 cf ff ff       	call   801019e0 <iunlockput>
    return 0;
801049e9:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801049ef:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049f1:	5b                   	pop    %ebx
801049f2:	5e                   	pop    %esi
801049f3:	5f                   	pop    %edi
801049f4:	5d                   	pop    %ebp
801049f5:	c3                   	ret    
801049f6:	8d 76 00             	lea    0x0(%esi),%esi
801049f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104a00:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104a04:	83 ec 08             	sub    $0x8,%esp
80104a07:	50                   	push   %eax
80104a08:	ff 37                	pushl  (%edi)
80104a0a:	e8 91 cb ff ff       	call   801015a0 <ialloc>
80104a0f:	83 c4 10             	add    $0x10,%esp
80104a12:	85 c0                	test   %eax,%eax
80104a14:	89 c3                	mov    %eax,%ebx
80104a16:	0f 84 cc 00 00 00    	je     80104ae8 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
80104a1c:	83 ec 0c             	sub    $0xc,%esp
80104a1f:	50                   	push   %eax
80104a20:	e8 eb cc ff ff       	call   80101710 <ilock>
  ip->major = major;
80104a25:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104a29:	66 89 43 12          	mov    %ax,0x12(%ebx)
  ip->minor = minor;
80104a2d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104a31:	66 89 43 14          	mov    %ax,0x14(%ebx)
  ip->nlink = 1;
80104a35:	b8 01 00 00 00       	mov    $0x1,%eax
80104a3a:	66 89 43 16          	mov    %ax,0x16(%ebx)
  iupdate(ip);
80104a3e:	89 1c 24             	mov    %ebx,(%esp)
80104a41:	e8 1a cc ff ff       	call   80101660 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104a46:	83 c4 10             	add    $0x10,%esp
80104a49:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104a4e:	74 40                	je     80104a90 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
80104a50:	83 ec 04             	sub    $0x4,%esp
80104a53:	ff 73 04             	pushl  0x4(%ebx)
80104a56:	56                   	push   %esi
80104a57:	57                   	push   %edi
80104a58:	e8 83 d4 ff ff       	call   80101ee0 <dirlink>
80104a5d:	83 c4 10             	add    $0x10,%esp
80104a60:	85 c0                	test   %eax,%eax
80104a62:	78 77                	js     80104adb <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
80104a64:	83 ec 0c             	sub    $0xc,%esp
80104a67:	57                   	push   %edi
80104a68:	e8 73 cf ff ff       	call   801019e0 <iunlockput>

  return ip;
80104a6d:	83 c4 10             	add    $0x10,%esp
}
80104a70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
80104a73:	89 d8                	mov    %ebx,%eax
}
80104a75:	5b                   	pop    %ebx
80104a76:	5e                   	pop    %esi
80104a77:	5f                   	pop    %edi
80104a78:	5d                   	pop    %ebp
80104a79:	c3                   	ret    
80104a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104a80:	31 c0                	xor    %eax,%eax
80104a82:	e9 49 ff ff ff       	jmp    801049d0 <create+0x70>
80104a87:	89 f6                	mov    %esi,%esi
80104a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104a90:	66 83 47 16 01       	addw   $0x1,0x16(%edi)
    iupdate(dp);
80104a95:	83 ec 0c             	sub    $0xc,%esp
80104a98:	57                   	push   %edi
80104a99:	e8 c2 cb ff ff       	call   80101660 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a9e:	83 c4 0c             	add    $0xc,%esp
80104aa1:	ff 73 04             	pushl  0x4(%ebx)
80104aa4:	68 d4 76 10 80       	push   $0x801076d4
80104aa9:	53                   	push   %ebx
80104aaa:	e8 31 d4 ff ff       	call   80101ee0 <dirlink>
80104aaf:	83 c4 10             	add    $0x10,%esp
80104ab2:	85 c0                	test   %eax,%eax
80104ab4:	78 18                	js     80104ace <create+0x16e>
80104ab6:	83 ec 04             	sub    $0x4,%esp
80104ab9:	ff 77 04             	pushl  0x4(%edi)
80104abc:	68 d3 76 10 80       	push   $0x801076d3
80104ac1:	53                   	push   %ebx
80104ac2:	e8 19 d4 ff ff       	call   80101ee0 <dirlink>
80104ac7:	83 c4 10             	add    $0x10,%esp
80104aca:	85 c0                	test   %eax,%eax
80104acc:	79 82                	jns    80104a50 <create+0xf0>
      panic("create dots");
80104ace:	83 ec 0c             	sub    $0xc,%esp
80104ad1:	68 c7 76 10 80       	push   $0x801076c7
80104ad6:	e8 75 b8 ff ff       	call   80100350 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104adb:	83 ec 0c             	sub    $0xc,%esp
80104ade:	68 d6 76 10 80       	push   $0x801076d6
80104ae3:	e8 68 b8 ff ff       	call   80100350 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104ae8:	83 ec 0c             	sub    $0xc,%esp
80104aeb:	68 b8 76 10 80       	push   $0x801076b8
80104af0:	e8 5b b8 ff ff       	call   80100350 <panic>
80104af5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b00 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	56                   	push   %esi
80104b04:	53                   	push   %ebx
80104b05:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104b07:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104b0a:	89 d3                	mov    %edx,%ebx
80104b0c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104b0f:	50                   	push   %eax
80104b10:	6a 00                	push   $0x0
80104b12:	e8 c9 fc ff ff       	call   801047e0 <argint>
80104b17:	83 c4 10             	add    $0x10,%esp
80104b1a:	85 c0                	test   %eax,%eax
80104b1c:	78 3a                	js     80104b58 <argfd.constprop.0+0x58>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80104b1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b21:	83 f8 0f             	cmp    $0xf,%eax
80104b24:	77 32                	ja     80104b58 <argfd.constprop.0+0x58>
80104b26:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104b2d:	8b 54 82 2c          	mov    0x2c(%edx,%eax,4),%edx
80104b31:	85 d2                	test   %edx,%edx
80104b33:	74 23                	je     80104b58 <argfd.constprop.0+0x58>
    return -1;
  if(pfd)
80104b35:	85 f6                	test   %esi,%esi
80104b37:	74 02                	je     80104b3b <argfd.constprop.0+0x3b>
    *pfd = fd;
80104b39:	89 06                	mov    %eax,(%esi)
  if(pf)
80104b3b:	85 db                	test   %ebx,%ebx
80104b3d:	74 11                	je     80104b50 <argfd.constprop.0+0x50>
    *pf = f;
80104b3f:	89 13                	mov    %edx,(%ebx)
  return 0;
80104b41:	31 c0                	xor    %eax,%eax
}
80104b43:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b46:	5b                   	pop    %ebx
80104b47:	5e                   	pop    %esi
80104b48:	5d                   	pop    %ebp
80104b49:	c3                   	ret    
80104b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104b50:	31 c0                	xor    %eax,%eax
80104b52:	eb ef                	jmp    80104b43 <argfd.constprop.0+0x43>
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b5d:	eb e4                	jmp    80104b43 <argfd.constprop.0+0x43>
80104b5f:	90                   	nop

80104b60 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104b60:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b61:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104b63:	89 e5                	mov    %esp,%ebp
80104b65:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b66:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104b69:	83 ec 14             	sub    $0x14,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104b6c:	e8 8f ff ff ff       	call   80104b00 <argfd.constprop.0>
80104b71:	85 c0                	test   %eax,%eax
80104b73:	78 1b                	js     80104b90 <sys_dup+0x30>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104b75:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b78:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104b7e:	31 db                	xor    %ebx,%ebx
    if(proc->ofile[fd] == 0){
80104b80:	8b 4c 98 2c          	mov    0x2c(%eax,%ebx,4),%ecx
80104b84:	85 c9                	test   %ecx,%ecx
80104b86:	74 18                	je     80104ba0 <sys_dup+0x40>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80104b88:	83 c3 01             	add    $0x1,%ebx
80104b8b:	83 fb 10             	cmp    $0x10,%ebx
80104b8e:	75 f0                	jne    80104b80 <sys_dup+0x20>
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b95:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b98:	c9                   	leave  
80104b99:	c3                   	ret    
80104b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104ba0:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80104ba3:	89 54 98 2c          	mov    %edx,0x2c(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104ba7:	52                   	push   %edx
80104ba8:	e8 13 c3 ff ff       	call   80100ec0 <filedup>
  return fd;
80104bad:	89 d8                	mov    %ebx,%eax
80104baf:	83 c4 10             	add    $0x10,%esp
}
80104bb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bb5:	c9                   	leave  
80104bb6:	c3                   	ret    
80104bb7:	89 f6                	mov    %esi,%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <sys_read>:

int
sys_read(void)
{
80104bc0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bc1:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104bc3:	89 e5                	mov    %esp,%ebp
80104bc5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bc8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104bcb:	e8 30 ff ff ff       	call   80104b00 <argfd.constprop.0>
80104bd0:	85 c0                	test   %eax,%eax
80104bd2:	78 4c                	js     80104c20 <sys_read+0x60>
80104bd4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bd7:	83 ec 08             	sub    $0x8,%esp
80104bda:	50                   	push   %eax
80104bdb:	6a 02                	push   $0x2
80104bdd:	e8 fe fb ff ff       	call   801047e0 <argint>
80104be2:	83 c4 10             	add    $0x10,%esp
80104be5:	85 c0                	test   %eax,%eax
80104be7:	78 37                	js     80104c20 <sys_read+0x60>
80104be9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bec:	83 ec 04             	sub    $0x4,%esp
80104bef:	ff 75 f0             	pushl  -0x10(%ebp)
80104bf2:	50                   	push   %eax
80104bf3:	6a 01                	push   $0x1
80104bf5:	e8 26 fc ff ff       	call   80104820 <argptr>
80104bfa:	83 c4 10             	add    $0x10,%esp
80104bfd:	85 c0                	test   %eax,%eax
80104bff:	78 1f                	js     80104c20 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104c01:	83 ec 04             	sub    $0x4,%esp
80104c04:	ff 75 f0             	pushl  -0x10(%ebp)
80104c07:	ff 75 f4             	pushl  -0xc(%ebp)
80104c0a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c0d:	e8 1e c4 ff ff       	call   80101030 <fileread>
80104c12:	83 c4 10             	add    $0x10,%esp
}
80104c15:	c9                   	leave  
80104c16:	c3                   	ret    
80104c17:	89 f6                	mov    %esi,%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104c25:	c9                   	leave  
80104c26:	c3                   	ret    
80104c27:	89 f6                	mov    %esi,%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c30 <sys_write>:

int
sys_write(void)
{
80104c30:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c31:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104c33:	89 e5                	mov    %esp,%ebp
80104c35:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c3b:	e8 c0 fe ff ff       	call   80104b00 <argfd.constprop.0>
80104c40:	85 c0                	test   %eax,%eax
80104c42:	78 4c                	js     80104c90 <sys_write+0x60>
80104c44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c47:	83 ec 08             	sub    $0x8,%esp
80104c4a:	50                   	push   %eax
80104c4b:	6a 02                	push   $0x2
80104c4d:	e8 8e fb ff ff       	call   801047e0 <argint>
80104c52:	83 c4 10             	add    $0x10,%esp
80104c55:	85 c0                	test   %eax,%eax
80104c57:	78 37                	js     80104c90 <sys_write+0x60>
80104c59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c5c:	83 ec 04             	sub    $0x4,%esp
80104c5f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c62:	50                   	push   %eax
80104c63:	6a 01                	push   $0x1
80104c65:	e8 b6 fb ff ff       	call   80104820 <argptr>
80104c6a:	83 c4 10             	add    $0x10,%esp
80104c6d:	85 c0                	test   %eax,%eax
80104c6f:	78 1f                	js     80104c90 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104c71:	83 ec 04             	sub    $0x4,%esp
80104c74:	ff 75 f0             	pushl  -0x10(%ebp)
80104c77:	ff 75 f4             	pushl  -0xc(%ebp)
80104c7a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c7d:	e8 3e c4 ff ff       	call   801010c0 <filewrite>
80104c82:	83 c4 10             	add    $0x10,%esp
}
80104c85:	c9                   	leave  
80104c86:	c3                   	ret    
80104c87:	89 f6                	mov    %esi,%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104c95:	c9                   	leave  
80104c96:	c3                   	ret    
80104c97:	89 f6                	mov    %esi,%esi
80104c99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ca0 <sys_close>:

int
sys_close(void)
{
80104ca0:	55                   	push   %ebp
80104ca1:	89 e5                	mov    %esp,%ebp
80104ca3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104ca6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104ca9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cac:	e8 4f fe ff ff       	call   80104b00 <argfd.constprop.0>
80104cb1:	85 c0                	test   %eax,%eax
80104cb3:	78 2b                	js     80104ce0 <sys_close+0x40>
    return -1;
  proc->ofile[fd] = 0;
80104cb5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104cb8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  fileclose(f);
80104cbe:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  proc->ofile[fd] = 0;
80104cc1:	c7 44 90 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,4)
80104cc8:	00 
  fileclose(f);
80104cc9:	ff 75 f4             	pushl  -0xc(%ebp)
80104ccc:	e8 3f c2 ff ff       	call   80100f10 <fileclose>
  return 0;
80104cd1:	83 c4 10             	add    $0x10,%esp
80104cd4:	31 c0                	xor    %eax,%eax
}
80104cd6:	c9                   	leave  
80104cd7:	c3                   	ret    
80104cd8:	90                   	nop
80104cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  proc->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104ce5:	c9                   	leave  
80104ce6:	c3                   	ret    
80104ce7:	89 f6                	mov    %esi,%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cf0 <sys_fstat>:

int
sys_fstat(void)
{
80104cf0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104cf1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104cf3:	89 e5                	mov    %esp,%ebp
80104cf5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104cf8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104cfb:	e8 00 fe ff ff       	call   80104b00 <argfd.constprop.0>
80104d00:	85 c0                	test   %eax,%eax
80104d02:	78 2c                	js     80104d30 <sys_fstat+0x40>
80104d04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d07:	83 ec 04             	sub    $0x4,%esp
80104d0a:	6a 14                	push   $0x14
80104d0c:	50                   	push   %eax
80104d0d:	6a 01                	push   $0x1
80104d0f:	e8 0c fb ff ff       	call   80104820 <argptr>
80104d14:	83 c4 10             	add    $0x10,%esp
80104d17:	85 c0                	test   %eax,%eax
80104d19:	78 15                	js     80104d30 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104d1b:	83 ec 08             	sub    $0x8,%esp
80104d1e:	ff 75 f4             	pushl  -0xc(%ebp)
80104d21:	ff 75 f0             	pushl  -0x10(%ebp)
80104d24:	e8 b7 c2 ff ff       	call   80100fe0 <filestat>
80104d29:	83 c4 10             	add    $0x10,%esp
}
80104d2c:	c9                   	leave  
80104d2d:	c3                   	ret    
80104d2e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104d35:	c9                   	leave  
80104d36:	c3                   	ret    
80104d37:	89 f6                	mov    %esi,%esi
80104d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d40 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	57                   	push   %edi
80104d44:	56                   	push   %esi
80104d45:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d46:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104d49:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d4c:	50                   	push   %eax
80104d4d:	6a 00                	push   $0x0
80104d4f:	e8 1c fb ff ff       	call   80104870 <argstr>
80104d54:	83 c4 10             	add    $0x10,%esp
80104d57:	85 c0                	test   %eax,%eax
80104d59:	0f 88 fb 00 00 00    	js     80104e5a <sys_link+0x11a>
80104d5f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d62:	83 ec 08             	sub    $0x8,%esp
80104d65:	50                   	push   %eax
80104d66:	6a 01                	push   $0x1
80104d68:	e8 03 fb ff ff       	call   80104870 <argstr>
80104d6d:	83 c4 10             	add    $0x10,%esp
80104d70:	85 c0                	test   %eax,%eax
80104d72:	0f 88 e2 00 00 00    	js     80104e5a <sys_link+0x11a>
    return -1;

  begin_op();
80104d78:	e8 43 df ff ff       	call   80102cc0 <begin_op>
  if((ip = namei(old)) == 0){
80104d7d:	83 ec 0c             	sub    $0xc,%esp
80104d80:	ff 75 d4             	pushl  -0x2c(%ebp)
80104d83:	e8 18 d2 ff ff       	call   80101fa0 <namei>
80104d88:	83 c4 10             	add    $0x10,%esp
80104d8b:	85 c0                	test   %eax,%eax
80104d8d:	89 c3                	mov    %eax,%ebx
80104d8f:	0f 84 f3 00 00 00    	je     80104e88 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104d95:	83 ec 0c             	sub    $0xc,%esp
80104d98:	50                   	push   %eax
80104d99:	e8 72 c9 ff ff       	call   80101710 <ilock>
  if(ip->type == T_DIR){
80104d9e:	83 c4 10             	add    $0x10,%esp
80104da1:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80104da6:	0f 84 c4 00 00 00    	je     80104e70 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104dac:	66 83 43 16 01       	addw   $0x1,0x16(%ebx)
  iupdate(ip);
80104db1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104db4:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104db7:	53                   	push   %ebx
80104db8:	e8 a3 c8 ff ff       	call   80101660 <iupdate>
  iunlock(ip);
80104dbd:	89 1c 24             	mov    %ebx,(%esp)
80104dc0:	e8 5b ca ff ff       	call   80101820 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104dc5:	58                   	pop    %eax
80104dc6:	5a                   	pop    %edx
80104dc7:	57                   	push   %edi
80104dc8:	ff 75 d0             	pushl  -0x30(%ebp)
80104dcb:	e8 f0 d1 ff ff       	call   80101fc0 <nameiparent>
80104dd0:	83 c4 10             	add    $0x10,%esp
80104dd3:	85 c0                	test   %eax,%eax
80104dd5:	89 c6                	mov    %eax,%esi
80104dd7:	74 5b                	je     80104e34 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104dd9:	83 ec 0c             	sub    $0xc,%esp
80104ddc:	50                   	push   %eax
80104ddd:	e8 2e c9 ff ff       	call   80101710 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104de2:	83 c4 10             	add    $0x10,%esp
80104de5:	8b 03                	mov    (%ebx),%eax
80104de7:	39 06                	cmp    %eax,(%esi)
80104de9:	75 3d                	jne    80104e28 <sys_link+0xe8>
80104deb:	83 ec 04             	sub    $0x4,%esp
80104dee:	ff 73 04             	pushl  0x4(%ebx)
80104df1:	57                   	push   %edi
80104df2:	56                   	push   %esi
80104df3:	e8 e8 d0 ff ff       	call   80101ee0 <dirlink>
80104df8:	83 c4 10             	add    $0x10,%esp
80104dfb:	85 c0                	test   %eax,%eax
80104dfd:	78 29                	js     80104e28 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104dff:	83 ec 0c             	sub    $0xc,%esp
80104e02:	56                   	push   %esi
80104e03:	e8 d8 cb ff ff       	call   801019e0 <iunlockput>
  iput(ip);
80104e08:	89 1c 24             	mov    %ebx,(%esp)
80104e0b:	e8 70 ca ff ff       	call   80101880 <iput>

  end_op();
80104e10:	e8 1b df ff ff       	call   80102d30 <end_op>

  return 0;
80104e15:	83 c4 10             	add    $0x10,%esp
80104e18:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104e1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e1d:	5b                   	pop    %ebx
80104e1e:	5e                   	pop    %esi
80104e1f:	5f                   	pop    %edi
80104e20:	5d                   	pop    %ebp
80104e21:	c3                   	ret    
80104e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104e28:	83 ec 0c             	sub    $0xc,%esp
80104e2b:	56                   	push   %esi
80104e2c:	e8 af cb ff ff       	call   801019e0 <iunlockput>
    goto bad;
80104e31:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104e34:	83 ec 0c             	sub    $0xc,%esp
80104e37:	53                   	push   %ebx
80104e38:	e8 d3 c8 ff ff       	call   80101710 <ilock>
  ip->nlink--;
80104e3d:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
80104e42:	89 1c 24             	mov    %ebx,(%esp)
80104e45:	e8 16 c8 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
80104e4a:	89 1c 24             	mov    %ebx,(%esp)
80104e4d:	e8 8e cb ff ff       	call   801019e0 <iunlockput>
  end_op();
80104e52:	e8 d9 de ff ff       	call   80102d30 <end_op>
  return -1;
80104e57:	83 c4 10             	add    $0x10,%esp
}
80104e5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104e5d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e62:	5b                   	pop    %ebx
80104e63:	5e                   	pop    %esi
80104e64:	5f                   	pop    %edi
80104e65:	5d                   	pop    %ebp
80104e66:	c3                   	ret    
80104e67:	89 f6                	mov    %esi,%esi
80104e69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104e70:	83 ec 0c             	sub    $0xc,%esp
80104e73:	53                   	push   %ebx
80104e74:	e8 67 cb ff ff       	call   801019e0 <iunlockput>
    end_op();
80104e79:	e8 b2 de ff ff       	call   80102d30 <end_op>
    return -1;
80104e7e:	83 c4 10             	add    $0x10,%esp
80104e81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e86:	eb 92                	jmp    80104e1a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104e88:	e8 a3 de ff ff       	call   80102d30 <end_op>
    return -1;
80104e8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e92:	eb 86                	jmp    80104e1a <sys_link+0xda>
80104e94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ea0 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	57                   	push   %edi
80104ea4:	56                   	push   %esi
80104ea5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104ea6:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104ea9:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104eac:	50                   	push   %eax
80104ead:	6a 00                	push   $0x0
80104eaf:	e8 bc f9 ff ff       	call   80104870 <argstr>
80104eb4:	83 c4 10             	add    $0x10,%esp
80104eb7:	85 c0                	test   %eax,%eax
80104eb9:	0f 88 82 01 00 00    	js     80105041 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104ebf:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104ec2:	e8 f9 dd ff ff       	call   80102cc0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104ec7:	83 ec 08             	sub    $0x8,%esp
80104eca:	53                   	push   %ebx
80104ecb:	ff 75 c0             	pushl  -0x40(%ebp)
80104ece:	e8 ed d0 ff ff       	call   80101fc0 <nameiparent>
80104ed3:	83 c4 10             	add    $0x10,%esp
80104ed6:	85 c0                	test   %eax,%eax
80104ed8:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104edb:	0f 84 6a 01 00 00    	je     8010504b <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104ee1:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104ee4:	83 ec 0c             	sub    $0xc,%esp
80104ee7:	56                   	push   %esi
80104ee8:	e8 23 c8 ff ff       	call   80101710 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104eed:	58                   	pop    %eax
80104eee:	5a                   	pop    %edx
80104eef:	68 d4 76 10 80       	push   $0x801076d4
80104ef4:	53                   	push   %ebx
80104ef5:	e8 66 cd ff ff       	call   80101c60 <namecmp>
80104efa:	83 c4 10             	add    $0x10,%esp
80104efd:	85 c0                	test   %eax,%eax
80104eff:	0f 84 fc 00 00 00    	je     80105001 <sys_unlink+0x161>
80104f05:	83 ec 08             	sub    $0x8,%esp
80104f08:	68 d3 76 10 80       	push   $0x801076d3
80104f0d:	53                   	push   %ebx
80104f0e:	e8 4d cd ff ff       	call   80101c60 <namecmp>
80104f13:	83 c4 10             	add    $0x10,%esp
80104f16:	85 c0                	test   %eax,%eax
80104f18:	0f 84 e3 00 00 00    	je     80105001 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104f1e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104f21:	83 ec 04             	sub    $0x4,%esp
80104f24:	50                   	push   %eax
80104f25:	53                   	push   %ebx
80104f26:	56                   	push   %esi
80104f27:	e8 54 cd ff ff       	call   80101c80 <dirlookup>
80104f2c:	83 c4 10             	add    $0x10,%esp
80104f2f:	85 c0                	test   %eax,%eax
80104f31:	89 c3                	mov    %eax,%ebx
80104f33:	0f 84 c8 00 00 00    	je     80105001 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104f39:	83 ec 0c             	sub    $0xc,%esp
80104f3c:	50                   	push   %eax
80104f3d:	e8 ce c7 ff ff       	call   80101710 <ilock>

  if(ip->nlink < 1)
80104f42:	83 c4 10             	add    $0x10,%esp
80104f45:	66 83 7b 16 00       	cmpw   $0x0,0x16(%ebx)
80104f4a:	0f 8e 24 01 00 00    	jle    80105074 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104f50:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80104f55:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104f58:	74 66                	je     80104fc0 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104f5a:	83 ec 04             	sub    $0x4,%esp
80104f5d:	6a 10                	push   $0x10
80104f5f:	6a 00                	push   $0x0
80104f61:	56                   	push   %esi
80104f62:	e8 79 f5 ff ff       	call   801044e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f67:	6a 10                	push   $0x10
80104f69:	ff 75 c4             	pushl  -0x3c(%ebp)
80104f6c:	56                   	push   %esi
80104f6d:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f70:	e8 bb cb ff ff       	call   80101b30 <writei>
80104f75:	83 c4 20             	add    $0x20,%esp
80104f78:	83 f8 10             	cmp    $0x10,%eax
80104f7b:	0f 85 e6 00 00 00    	jne    80105067 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104f81:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80104f86:	0f 84 9c 00 00 00    	je     80105028 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104f8c:	83 ec 0c             	sub    $0xc,%esp
80104f8f:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f92:	e8 49 ca ff ff       	call   801019e0 <iunlockput>

  ip->nlink--;
80104f97:	66 83 6b 16 01       	subw   $0x1,0x16(%ebx)
  iupdate(ip);
80104f9c:	89 1c 24             	mov    %ebx,(%esp)
80104f9f:	e8 bc c6 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
80104fa4:	89 1c 24             	mov    %ebx,(%esp)
80104fa7:	e8 34 ca ff ff       	call   801019e0 <iunlockput>

  end_op();
80104fac:	e8 7f dd ff ff       	call   80102d30 <end_op>

  return 0;
80104fb1:	83 c4 10             	add    $0x10,%esp
80104fb4:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fb9:	5b                   	pop    %ebx
80104fba:	5e                   	pop    %esi
80104fbb:	5f                   	pop    %edi
80104fbc:	5d                   	pop    %ebp
80104fbd:	c3                   	ret    
80104fbe:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104fc0:	83 7b 18 20          	cmpl   $0x20,0x18(%ebx)
80104fc4:	76 94                	jbe    80104f5a <sys_unlink+0xba>
80104fc6:	bf 20 00 00 00       	mov    $0x20,%edi
80104fcb:	eb 0f                	jmp    80104fdc <sys_unlink+0x13c>
80104fcd:	8d 76 00             	lea    0x0(%esi),%esi
80104fd0:	83 c7 10             	add    $0x10,%edi
80104fd3:	3b 7b 18             	cmp    0x18(%ebx),%edi
80104fd6:	0f 83 7e ff ff ff    	jae    80104f5a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104fdc:	6a 10                	push   $0x10
80104fde:	57                   	push   %edi
80104fdf:	56                   	push   %esi
80104fe0:	53                   	push   %ebx
80104fe1:	e8 4a ca ff ff       	call   80101a30 <readi>
80104fe6:	83 c4 10             	add    $0x10,%esp
80104fe9:	83 f8 10             	cmp    $0x10,%eax
80104fec:	75 6c                	jne    8010505a <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104fee:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104ff3:	74 db                	je     80104fd0 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104ff5:	83 ec 0c             	sub    $0xc,%esp
80104ff8:	53                   	push   %ebx
80104ff9:	e8 e2 c9 ff ff       	call   801019e0 <iunlockput>
    goto bad;
80104ffe:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80105001:	83 ec 0c             	sub    $0xc,%esp
80105004:	ff 75 b4             	pushl  -0x4c(%ebp)
80105007:	e8 d4 c9 ff ff       	call   801019e0 <iunlockput>
  end_op();
8010500c:	e8 1f dd ff ff       	call   80102d30 <end_op>
  return -1;
80105011:	83 c4 10             	add    $0x10,%esp
}
80105014:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80105017:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010501c:	5b                   	pop    %ebx
8010501d:	5e                   	pop    %esi
8010501e:	5f                   	pop    %edi
8010501f:	5d                   	pop    %ebp
80105020:	c3                   	ret    
80105021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80105028:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
8010502b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
8010502e:	66 83 68 16 01       	subw   $0x1,0x16(%eax)
    iupdate(dp);
80105033:	50                   	push   %eax
80105034:	e8 27 c6 ff ff       	call   80101660 <iupdate>
80105039:	83 c4 10             	add    $0x10,%esp
8010503c:	e9 4b ff ff ff       	jmp    80104f8c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80105041:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105046:	e9 6b ff ff ff       	jmp    80104fb6 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
8010504b:	e8 e0 dc ff ff       	call   80102d30 <end_op>
    return -1;
80105050:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105055:	e9 5c ff ff ff       	jmp    80104fb6 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
8010505a:	83 ec 0c             	sub    $0xc,%esp
8010505d:	68 f8 76 10 80       	push   $0x801076f8
80105062:	e8 e9 b2 ff ff       	call   80100350 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80105067:	83 ec 0c             	sub    $0xc,%esp
8010506a:	68 0a 77 10 80       	push   $0x8010770a
8010506f:	e8 dc b2 ff ff       	call   80100350 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105074:	83 ec 0c             	sub    $0xc,%esp
80105077:	68 e6 76 10 80       	push   $0x801076e6
8010507c:	e8 cf b2 ff ff       	call   80100350 <panic>
80105081:	eb 0d                	jmp    80105090 <sys_open>
80105083:	90                   	nop
80105084:	90                   	nop
80105085:	90                   	nop
80105086:	90                   	nop
80105087:	90                   	nop
80105088:	90                   	nop
80105089:	90                   	nop
8010508a:	90                   	nop
8010508b:	90                   	nop
8010508c:	90                   	nop
8010508d:	90                   	nop
8010508e:	90                   	nop
8010508f:	90                   	nop

80105090 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	57                   	push   %edi
80105094:	56                   	push   %esi
80105095:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105096:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105099:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010509c:	50                   	push   %eax
8010509d:	6a 00                	push   $0x0
8010509f:	e8 cc f7 ff ff       	call   80104870 <argstr>
801050a4:	83 c4 10             	add    $0x10,%esp
801050a7:	85 c0                	test   %eax,%eax
801050a9:	0f 88 9e 00 00 00    	js     8010514d <sys_open+0xbd>
801050af:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801050b2:	83 ec 08             	sub    $0x8,%esp
801050b5:	50                   	push   %eax
801050b6:	6a 01                	push   $0x1
801050b8:	e8 23 f7 ff ff       	call   801047e0 <argint>
801050bd:	83 c4 10             	add    $0x10,%esp
801050c0:	85 c0                	test   %eax,%eax
801050c2:	0f 88 85 00 00 00    	js     8010514d <sys_open+0xbd>
    return -1;

  begin_op();
801050c8:	e8 f3 db ff ff       	call   80102cc0 <begin_op>

  if(omode & O_CREATE){
801050cd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801050d1:	0f 85 89 00 00 00    	jne    80105160 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801050d7:	83 ec 0c             	sub    $0xc,%esp
801050da:	ff 75 e0             	pushl  -0x20(%ebp)
801050dd:	e8 be ce ff ff       	call   80101fa0 <namei>
801050e2:	83 c4 10             	add    $0x10,%esp
801050e5:	85 c0                	test   %eax,%eax
801050e7:	89 c7                	mov    %eax,%edi
801050e9:	0f 84 8e 00 00 00    	je     8010517d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
801050ef:	83 ec 0c             	sub    $0xc,%esp
801050f2:	50                   	push   %eax
801050f3:	e8 18 c6 ff ff       	call   80101710 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801050f8:	83 c4 10             	add    $0x10,%esp
801050fb:	66 83 7f 10 01       	cmpw   $0x1,0x10(%edi)
80105100:	0f 84 d2 00 00 00    	je     801051d8 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105106:	e8 45 bd ff ff       	call   80100e50 <filealloc>
8010510b:	85 c0                	test   %eax,%eax
8010510d:	89 c6                	mov    %eax,%esi
8010510f:	74 2b                	je     8010513c <sys_open+0xac>
80105111:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105118:	31 db                	xor    %ebx,%ebx
8010511a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
80105120:	8b 44 9a 2c          	mov    0x2c(%edx,%ebx,4),%eax
80105124:	85 c0                	test   %eax,%eax
80105126:	74 68                	je     80105190 <sys_open+0x100>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105128:	83 c3 01             	add    $0x1,%ebx
8010512b:	83 fb 10             	cmp    $0x10,%ebx
8010512e:	75 f0                	jne    80105120 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80105130:	83 ec 0c             	sub    $0xc,%esp
80105133:	56                   	push   %esi
80105134:	e8 d7 bd ff ff       	call   80100f10 <fileclose>
80105139:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010513c:	83 ec 0c             	sub    $0xc,%esp
8010513f:	57                   	push   %edi
80105140:	e8 9b c8 ff ff       	call   801019e0 <iunlockput>
    end_op();
80105145:	e8 e6 db ff ff       	call   80102d30 <end_op>
    return -1;
8010514a:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
8010514d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80105150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80105155:	5b                   	pop    %ebx
80105156:	5e                   	pop    %esi
80105157:	5f                   	pop    %edi
80105158:	5d                   	pop    %ebp
80105159:	c3                   	ret    
8010515a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105160:	83 ec 0c             	sub    $0xc,%esp
80105163:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105166:	31 c9                	xor    %ecx,%ecx
80105168:	6a 00                	push   $0x0
8010516a:	ba 02 00 00 00       	mov    $0x2,%edx
8010516f:	e8 ec f7 ff ff       	call   80104960 <create>
    if(ip == 0){
80105174:	83 c4 10             	add    $0x10,%esp
80105177:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105179:	89 c7                	mov    %eax,%edi
    if(ip == 0){
8010517b:	75 89                	jne    80105106 <sys_open+0x76>
      end_op();
8010517d:	e8 ae db ff ff       	call   80102d30 <end_op>
      return -1;
80105182:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105187:	eb 43                	jmp    801051cc <sys_open+0x13c>
80105189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105190:	83 ec 0c             	sub    $0xc,%esp
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105193:	89 74 9a 2c          	mov    %esi,0x2c(%edx,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105197:	57                   	push   %edi
80105198:	e8 83 c6 ff ff       	call   80101820 <iunlock>
  end_op();
8010519d:	e8 8e db ff ff       	call   80102d30 <end_op>

  f->type = FD_INODE;
801051a2:	c7 06 02 00 00 00    	movl   $0x2,(%esi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801051a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051ab:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
801051ae:	89 7e 10             	mov    %edi,0x10(%esi)
  f->off = 0;
801051b1:	c7 46 14 00 00 00 00 	movl   $0x0,0x14(%esi)
  f->readable = !(omode & O_WRONLY);
801051b8:	89 d0                	mov    %edx,%eax
801051ba:	83 e0 01             	and    $0x1,%eax
801051bd:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051c0:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801051c3:	88 46 08             	mov    %al,0x8(%esi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051c6:	0f 95 46 09          	setne  0x9(%esi)
  return fd;
801051ca:	89 d8                	mov    %ebx,%eax
}
801051cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051cf:	5b                   	pop    %ebx
801051d0:	5e                   	pop    %esi
801051d1:	5f                   	pop    %edi
801051d2:	5d                   	pop    %ebp
801051d3:	c3                   	ret    
801051d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
801051d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801051db:	85 d2                	test   %edx,%edx
801051dd:	0f 84 23 ff ff ff    	je     80105106 <sys_open+0x76>
801051e3:	e9 54 ff ff ff       	jmp    8010513c <sys_open+0xac>
801051e8:	90                   	nop
801051e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801051f0 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801051f6:	e8 c5 da ff ff       	call   80102cc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801051fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051fe:	83 ec 08             	sub    $0x8,%esp
80105201:	50                   	push   %eax
80105202:	6a 00                	push   $0x0
80105204:	e8 67 f6 ff ff       	call   80104870 <argstr>
80105209:	83 c4 10             	add    $0x10,%esp
8010520c:	85 c0                	test   %eax,%eax
8010520e:	78 30                	js     80105240 <sys_mkdir+0x50>
80105210:	83 ec 0c             	sub    $0xc,%esp
80105213:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105216:	31 c9                	xor    %ecx,%ecx
80105218:	6a 00                	push   $0x0
8010521a:	ba 01 00 00 00       	mov    $0x1,%edx
8010521f:	e8 3c f7 ff ff       	call   80104960 <create>
80105224:	83 c4 10             	add    $0x10,%esp
80105227:	85 c0                	test   %eax,%eax
80105229:	74 15                	je     80105240 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010522b:	83 ec 0c             	sub    $0xc,%esp
8010522e:	50                   	push   %eax
8010522f:	e8 ac c7 ff ff       	call   801019e0 <iunlockput>
  end_op();
80105234:	e8 f7 da ff ff       	call   80102d30 <end_op>
  return 0;
80105239:	83 c4 10             	add    $0x10,%esp
8010523c:	31 c0                	xor    %eax,%eax
}
8010523e:	c9                   	leave  
8010523f:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80105240:	e8 eb da ff ff       	call   80102d30 <end_op>
    return -1;
80105245:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010524a:	c9                   	leave  
8010524b:	c3                   	ret    
8010524c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105250 <sys_mknod>:

int
sys_mknod(void)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105256:	e8 65 da ff ff       	call   80102cc0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010525b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010525e:	83 ec 08             	sub    $0x8,%esp
80105261:	50                   	push   %eax
80105262:	6a 00                	push   $0x0
80105264:	e8 07 f6 ff ff       	call   80104870 <argstr>
80105269:	83 c4 10             	add    $0x10,%esp
8010526c:	85 c0                	test   %eax,%eax
8010526e:	78 60                	js     801052d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105270:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105273:	83 ec 08             	sub    $0x8,%esp
80105276:	50                   	push   %eax
80105277:	6a 01                	push   $0x1
80105279:	e8 62 f5 ff ff       	call   801047e0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010527e:	83 c4 10             	add    $0x10,%esp
80105281:	85 c0                	test   %eax,%eax
80105283:	78 4b                	js     801052d0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105285:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105288:	83 ec 08             	sub    $0x8,%esp
8010528b:	50                   	push   %eax
8010528c:	6a 02                	push   $0x2
8010528e:	e8 4d f5 ff ff       	call   801047e0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105293:	83 c4 10             	add    $0x10,%esp
80105296:	85 c0                	test   %eax,%eax
80105298:	78 36                	js     801052d0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010529a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010529e:	83 ec 0c             	sub    $0xc,%esp
801052a1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801052a5:	ba 03 00 00 00       	mov    $0x3,%edx
801052aa:	50                   	push   %eax
801052ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801052ae:	e8 ad f6 ff ff       	call   80104960 <create>
801052b3:	83 c4 10             	add    $0x10,%esp
801052b6:	85 c0                	test   %eax,%eax
801052b8:	74 16                	je     801052d0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
801052ba:	83 ec 0c             	sub    $0xc,%esp
801052bd:	50                   	push   %eax
801052be:	e8 1d c7 ff ff       	call   801019e0 <iunlockput>
  end_op();
801052c3:	e8 68 da ff ff       	call   80102d30 <end_op>
  return 0;
801052c8:	83 c4 10             	add    $0x10,%esp
801052cb:	31 c0                	xor    %eax,%eax
}
801052cd:	c9                   	leave  
801052ce:	c3                   	ret    
801052cf:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801052d0:	e8 5b da ff ff       	call   80102d30 <end_op>
    return -1;
801052d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801052da:	c9                   	leave  
801052db:	c3                   	ret    
801052dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052e0 <sys_chdir>:

int
sys_chdir(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	53                   	push   %ebx
801052e4:	83 ec 14             	sub    $0x14,%esp
  char *path;
  struct inode *ip;

  begin_op();
801052e7:	e8 d4 d9 ff ff       	call   80102cc0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801052ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ef:	83 ec 08             	sub    $0x8,%esp
801052f2:	50                   	push   %eax
801052f3:	6a 00                	push   $0x0
801052f5:	e8 76 f5 ff ff       	call   80104870 <argstr>
801052fa:	83 c4 10             	add    $0x10,%esp
801052fd:	85 c0                	test   %eax,%eax
801052ff:	78 7f                	js     80105380 <sys_chdir+0xa0>
80105301:	83 ec 0c             	sub    $0xc,%esp
80105304:	ff 75 f4             	pushl  -0xc(%ebp)
80105307:	e8 94 cc ff ff       	call   80101fa0 <namei>
8010530c:	83 c4 10             	add    $0x10,%esp
8010530f:	85 c0                	test   %eax,%eax
80105311:	89 c3                	mov    %eax,%ebx
80105313:	74 6b                	je     80105380 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105315:	83 ec 0c             	sub    $0xc,%esp
80105318:	50                   	push   %eax
80105319:	e8 f2 c3 ff ff       	call   80101710 <ilock>
  if(ip->type != T_DIR){
8010531e:	83 c4 10             	add    $0x10,%esp
80105321:	66 83 7b 10 01       	cmpw   $0x1,0x10(%ebx)
80105326:	75 38                	jne    80105360 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105328:	83 ec 0c             	sub    $0xc,%esp
8010532b:	53                   	push   %ebx
8010532c:	e8 ef c4 ff ff       	call   80101820 <iunlock>
  iput(proc->cwd);
80105331:	58                   	pop    %eax
80105332:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105338:	ff 70 6c             	pushl  0x6c(%eax)
8010533b:	e8 40 c5 ff ff       	call   80101880 <iput>
  end_op();
80105340:	e8 eb d9 ff ff       	call   80102d30 <end_op>
  proc->cwd = ip;
80105345:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return 0;
8010534b:	83 c4 10             	add    $0x10,%esp
    return -1;
  }
  iunlock(ip);
  iput(proc->cwd);
  end_op();
  proc->cwd = ip;
8010534e:	89 58 6c             	mov    %ebx,0x6c(%eax)
  return 0;
80105351:	31 c0                	xor    %eax,%eax
}
80105353:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105356:	c9                   	leave  
80105357:	c3                   	ret    
80105358:	90                   	nop
80105359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
80105360:	83 ec 0c             	sub    $0xc,%esp
80105363:	53                   	push   %ebx
80105364:	e8 77 c6 ff ff       	call   801019e0 <iunlockput>
    end_op();
80105369:	e8 c2 d9 ff ff       	call   80102d30 <end_op>
    return -1;
8010536e:	83 c4 10             	add    $0x10,%esp
80105371:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105376:	eb db                	jmp    80105353 <sys_chdir+0x73>
80105378:	90                   	nop
80105379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105380:	e8 ab d9 ff ff       	call   80102d30 <end_op>
    return -1;
80105385:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010538a:	eb c7                	jmp    80105353 <sys_chdir+0x73>
8010538c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105390 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105390:	55                   	push   %ebp
80105391:	89 e5                	mov    %esp,%ebp
80105393:	57                   	push   %edi
80105394:	56                   	push   %esi
80105395:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105396:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010539c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801053a2:	50                   	push   %eax
801053a3:	6a 00                	push   $0x0
801053a5:	e8 c6 f4 ff ff       	call   80104870 <argstr>
801053aa:	83 c4 10             	add    $0x10,%esp
801053ad:	85 c0                	test   %eax,%eax
801053af:	78 7f                	js     80105430 <sys_exec+0xa0>
801053b1:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801053b7:	83 ec 08             	sub    $0x8,%esp
801053ba:	50                   	push   %eax
801053bb:	6a 01                	push   $0x1
801053bd:	e8 1e f4 ff ff       	call   801047e0 <argint>
801053c2:	83 c4 10             	add    $0x10,%esp
801053c5:	85 c0                	test   %eax,%eax
801053c7:	78 67                	js     80105430 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801053c9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801053cf:	83 ec 04             	sub    $0x4,%esp
801053d2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801053d8:	68 80 00 00 00       	push   $0x80
801053dd:	6a 00                	push   $0x0
801053df:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801053e5:	50                   	push   %eax
801053e6:	31 db                	xor    %ebx,%ebx
801053e8:	e8 f3 f0 ff ff       	call   801044e0 <memset>
801053ed:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801053f0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801053f6:	83 ec 08             	sub    $0x8,%esp
801053f9:	57                   	push   %edi
801053fa:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801053fd:	50                   	push   %eax
801053fe:	e8 4d f3 ff ff       	call   80104750 <fetchint>
80105403:	83 c4 10             	add    $0x10,%esp
80105406:	85 c0                	test   %eax,%eax
80105408:	78 26                	js     80105430 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010540a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105410:	85 c0                	test   %eax,%eax
80105412:	74 2c                	je     80105440 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105414:	83 ec 08             	sub    $0x8,%esp
80105417:	56                   	push   %esi
80105418:	50                   	push   %eax
80105419:	e8 72 f3 ff ff       	call   80104790 <fetchstr>
8010541e:	83 c4 10             	add    $0x10,%esp
80105421:	85 c0                	test   %eax,%eax
80105423:	78 0b                	js     80105430 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105425:	83 c3 01             	add    $0x1,%ebx
80105428:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010542b:	83 fb 20             	cmp    $0x20,%ebx
8010542e:	75 c0                	jne    801053f0 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105430:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105433:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105438:	5b                   	pop    %ebx
80105439:	5e                   	pop    %esi
8010543a:	5f                   	pop    %edi
8010543b:	5d                   	pop    %ebp
8010543c:	c3                   	ret    
8010543d:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105440:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105446:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
80105449:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105450:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105454:	50                   	push   %eax
80105455:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010545b:	e8 80 b6 ff ff       	call   80100ae0 <exec>
80105460:	83 c4 10             	add    $0x10,%esp
}
80105463:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105466:	5b                   	pop    %ebx
80105467:	5e                   	pop    %esi
80105468:	5f                   	pop    %edi
80105469:	5d                   	pop    %ebp
8010546a:	c3                   	ret    
8010546b:	90                   	nop
8010546c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105470 <sys_pipe>:

int
sys_pipe(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	57                   	push   %edi
80105474:	56                   	push   %esi
80105475:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105476:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105479:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010547c:	6a 08                	push   $0x8
8010547e:	50                   	push   %eax
8010547f:	6a 00                	push   $0x0
80105481:	e8 9a f3 ff ff       	call   80104820 <argptr>
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	85 c0                	test   %eax,%eax
8010548b:	78 48                	js     801054d5 <sys_pipe+0x65>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010548d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105490:	83 ec 08             	sub    $0x8,%esp
80105493:	50                   	push   %eax
80105494:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105497:	50                   	push   %eax
80105498:	e8 c3 df ff ff       	call   80103460 <pipealloc>
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	85 c0                	test   %eax,%eax
801054a2:	78 31                	js     801054d5 <sys_pipe+0x65>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054a4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
801054a7:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801054ae:	31 c0                	xor    %eax,%eax
    if(proc->ofile[fd] == 0){
801054b0:	8b 54 81 2c          	mov    0x2c(%ecx,%eax,4),%edx
801054b4:	85 d2                	test   %edx,%edx
801054b6:	74 28                	je     801054e0 <sys_pipe+0x70>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801054b8:	83 c0 01             	add    $0x1,%eax
801054bb:	83 f8 10             	cmp    $0x10,%eax
801054be:	75 f0                	jne    801054b0 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
    fileclose(rf);
801054c0:	83 ec 0c             	sub    $0xc,%esp
801054c3:	53                   	push   %ebx
801054c4:	e8 47 ba ff ff       	call   80100f10 <fileclose>
    fileclose(wf);
801054c9:	58                   	pop    %eax
801054ca:	ff 75 e4             	pushl  -0x1c(%ebp)
801054cd:	e8 3e ba ff ff       	call   80100f10 <fileclose>
    return -1;
801054d2:	83 c4 10             	add    $0x10,%esp
801054d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054da:	eb 45                	jmp    80105521 <sys_pipe+0xb1>
801054dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054e0:	8d 34 81             	lea    (%ecx,%eax,4),%esi
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801054e6:	31 d2                	xor    %edx,%edx
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
801054e8:	89 5e 2c             	mov    %ebx,0x2c(%esi)
801054eb:	90                   	nop
801054ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
801054f0:	83 7c 91 2c 00       	cmpl   $0x0,0x2c(%ecx,%edx,4)
801054f5:	74 19                	je     80105510 <sys_pipe+0xa0>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
801054f7:	83 c2 01             	add    $0x1,%edx
801054fa:	83 fa 10             	cmp    $0x10,%edx
801054fd:	75 f1                	jne    801054f0 <sys_pipe+0x80>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      proc->ofile[fd0] = 0;
801054ff:	c7 46 2c 00 00 00 00 	movl   $0x0,0x2c(%esi)
80105506:	eb b8                	jmp    801054c0 <sys_pipe+0x50>
80105508:	90                   	nop
80105509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
80105510:	89 7c 91 2c          	mov    %edi,0x2c(%ecx,%edx,4)
      proc->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105514:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80105517:	89 01                	mov    %eax,(%ecx)
  fd[1] = fd1;
80105519:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010551c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010551f:	31 c0                	xor    %eax,%eax
}
80105521:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105524:	5b                   	pop    %ebx
80105525:	5e                   	pop    %esi
80105526:	5f                   	pop    %edi
80105527:	5d                   	pop    %ebp
80105528:	c3                   	ret    
80105529:	66 90                	xchg   %ax,%ax
8010552b:	66 90                	xchg   %ax,%ax
8010552d:	66 90                	xchg   %ax,%ax
8010552f:	90                   	nop

80105530 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105533:	5d                   	pop    %ebp
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105534:	e9 a7 e5 ff ff       	jmp    80103ae0 <fork>
80105539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105540 <sys_exit>:
}

int
sys_exit(void)
{
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	83 ec 08             	sub    $0x8,%esp
  exit();
80105546:	e8 35 e8 ff ff       	call   80103d80 <exit>
  return 0;  // not reached
}
8010554b:	31 c0                	xor    %eax,%eax
8010554d:	c9                   	leave  
8010554e:	c3                   	ret    
8010554f:	90                   	nop

80105550 <sys_wait>:

int
sys_wait(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105553:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105554:	e9 87 ea ff ff       	jmp    80103fe0 <wait>
80105559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105560 <sys_kill>:
}

int
sys_kill(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105566:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105569:	50                   	push   %eax
8010556a:	6a 00                	push   $0x0
8010556c:	e8 6f f2 ff ff       	call   801047e0 <argint>
80105571:	83 c4 10             	add    $0x10,%esp
80105574:	85 c0                	test   %eax,%eax
80105576:	78 18                	js     80105590 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105578:	83 ec 0c             	sub    $0xc,%esp
8010557b:	ff 75 f4             	pushl  -0xc(%ebp)
8010557e:	e8 ad eb ff ff       	call   80104130 <kill>
80105583:	83 c4 10             	add    $0x10,%esp
}
80105586:	c9                   	leave  
80105587:	c3                   	ret    
80105588:	90                   	nop
80105589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
80105590:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
80105595:	c9                   	leave  
80105596:	c3                   	ret    
80105597:	89 f6                	mov    %esi,%esi
80105599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055a0 <sys_getpid>:

int
sys_getpid(void)
{
  return proc->pid;
801055a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  return kill(pid);
}

int
sys_getpid(void)
{
801055a6:	55                   	push   %ebp
801055a7:	89 e5                	mov    %esp,%ebp
  return proc->pid;
801055a9:	8b 40 14             	mov    0x14(%eax),%eax
}
801055ac:	5d                   	pop    %ebp
801055ad:	c3                   	ret    
801055ae:	66 90                	xchg   %ax,%ax

801055b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801055b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return proc->pid;
}

int
sys_sbrk(void)
{
801055b7:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801055ba:	50                   	push   %eax
801055bb:	6a 00                	push   $0x0
801055bd:	e8 1e f2 ff ff       	call   801047e0 <argint>
801055c2:	83 c4 10             	add    $0x10,%esp
801055c5:	85 c0                	test   %eax,%eax
801055c7:	78 27                	js     801055f0 <sys_sbrk+0x40>
    return -1;
  addr = proc->sz;
801055c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(growproc(n) < 0)
801055cf:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = proc->sz;
801055d2:	8b 58 04             	mov    0x4(%eax),%ebx
  if(growproc(n) < 0)
801055d5:	ff 75 f4             	pushl  -0xc(%ebp)
801055d8:	e8 93 e4 ff ff       	call   80103a70 <growproc>
801055dd:	83 c4 10             	add    $0x10,%esp
801055e0:	85 c0                	test   %eax,%eax
801055e2:	78 0c                	js     801055f0 <sys_sbrk+0x40>
    return -1;
  return addr;
801055e4:	89 d8                	mov    %ebx,%eax
}
801055e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055e9:	c9                   	leave  
801055ea:	c3                   	ret    
801055eb:	90                   	nop
801055ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
801055f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055f5:	eb ef                	jmp    801055e6 <sys_sbrk+0x36>
801055f7:	89 f6                	mov    %esi,%esi
801055f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105600 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105604:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105607:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010560a:	50                   	push   %eax
8010560b:	6a 00                	push   $0x0
8010560d:	e8 ce f1 ff ff       	call   801047e0 <argint>
80105612:	83 c4 10             	add    $0x10,%esp
80105615:	85 c0                	test   %eax,%eax
80105617:	0f 88 8a 00 00 00    	js     801056a7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010561d:	83 ec 0c             	sub    $0xc,%esp
80105620:	68 20 39 11 80       	push   $0x80113920
80105625:	e8 86 ec ff ff       	call   801042b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010562a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010562d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105630:	8b 1d 60 41 11 80    	mov    0x80114160,%ebx
  while(ticks - ticks0 < n){
80105636:	85 d2                	test   %edx,%edx
80105638:	75 27                	jne    80105661 <sys_sleep+0x61>
8010563a:	eb 54                	jmp    80105690 <sys_sleep+0x90>
8010563c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(proc->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105640:	83 ec 08             	sub    $0x8,%esp
80105643:	68 20 39 11 80       	push   $0x80113920
80105648:	68 60 41 11 80       	push   $0x80114160
8010564d:	e8 be e8 ff ff       	call   80103f10 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105652:	a1 60 41 11 80       	mov    0x80114160,%eax
80105657:	83 c4 10             	add    $0x10,%esp
8010565a:	29 d8                	sub    %ebx,%eax
8010565c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010565f:	73 2f                	jae    80105690 <sys_sleep+0x90>
    if(proc->killed){
80105661:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105667:	8b 40 28             	mov    0x28(%eax),%eax
8010566a:	85 c0                	test   %eax,%eax
8010566c:	74 d2                	je     80105640 <sys_sleep+0x40>
      release(&tickslock);
8010566e:	83 ec 0c             	sub    $0xc,%esp
80105671:	68 20 39 11 80       	push   $0x80113920
80105676:	e8 15 ee ff ff       	call   80104490 <release>
      return -1;
8010567b:	83 c4 10             	add    $0x10,%esp
8010567e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
80105683:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105686:	c9                   	leave  
80105687:	c3                   	ret    
80105688:	90                   	nop
80105689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80105690:	83 ec 0c             	sub    $0xc,%esp
80105693:	68 20 39 11 80       	push   $0x80113920
80105698:	e8 f3 ed ff ff       	call   80104490 <release>
  return 0;
8010569d:	83 c4 10             	add    $0x10,%esp
801056a0:	31 c0                	xor    %eax,%eax
}
801056a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056a5:	c9                   	leave  
801056a6:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
801056a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ac:	eb d5                	jmp    80105683 <sys_sleep+0x83>
801056ae:	66 90                	xchg   %ax,%ax

801056b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	53                   	push   %ebx
801056b4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801056b7:	68 20 39 11 80       	push   $0x80113920
801056bc:	e8 ef eb ff ff       	call   801042b0 <acquire>
  xticks = ticks;
801056c1:	8b 1d 60 41 11 80    	mov    0x80114160,%ebx
  release(&tickslock);
801056c7:	c7 04 24 20 39 11 80 	movl   $0x80113920,(%esp)
801056ce:	e8 bd ed ff ff       	call   80104490 <release>
  return xticks;
}
801056d3:	89 d8                	mov    %ebx,%eax
801056d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056d8:	c9                   	leave  
801056d9:	c3                   	ret    
801056da:	66 90                	xchg   %ax,%ax
801056dc:	66 90                	xchg   %ax,%ax
801056de:	66 90                	xchg   %ax,%ax

801056e0 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801056e0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801056e1:	ba 43 00 00 00       	mov    $0x43,%edx
801056e6:	b8 34 00 00 00       	mov    $0x34,%eax
801056eb:	89 e5                	mov    %esp,%ebp
801056ed:	83 ec 14             	sub    $0x14,%esp
801056f0:	ee                   	out    %al,(%dx)
801056f1:	ba 40 00 00 00       	mov    $0x40,%edx
801056f6:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
801056fb:	ee                   	out    %al,(%dx)
801056fc:	b8 2e 00 00 00       	mov    $0x2e,%eax
80105701:	ee                   	out    %al,(%dx)
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
  picenable(IRQ_TIMER);
80105702:	6a 00                	push   $0x0
80105704:	e8 87 dc ff ff       	call   80103390 <picenable>
}
80105709:	83 c4 10             	add    $0x10,%esp
8010570c:	c9                   	leave  
8010570d:	c3                   	ret    

8010570e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010570e:	1e                   	push   %ds
  pushl %es
8010570f:	06                   	push   %es
  pushl %fs
80105710:	0f a0                	push   %fs
  pushl %gs
80105712:	0f a8                	push   %gs
  pushal
80105714:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80105715:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105719:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010571b:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010571d:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80105721:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80105723:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80105725:	54                   	push   %esp
  call trap
80105726:	e8 e5 00 00 00       	call   80105810 <trap>
  addl $4, %esp
8010572b:	83 c4 04             	add    $0x4,%esp

8010572e <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010572e:	61                   	popa   
  popl %gs
8010572f:	0f a9                	pop    %gs
  popl %fs
80105731:	0f a1                	pop    %fs
  popl %es
80105733:	07                   	pop    %es
  popl %ds
80105734:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105735:	83 c4 08             	add    $0x8,%esp
  iret
80105738:	cf                   	iret   
80105739:	66 90                	xchg   %ax,%ax
8010573b:	66 90                	xchg   %ax,%ax
8010573d:	66 90                	xchg   %ax,%ax
8010573f:	90                   	nop

80105740 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105740:	31 c0                	xor    %eax,%eax
80105742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105748:	8b 14 85 0c a0 10 80 	mov    -0x7fef5ff4(,%eax,4),%edx
8010574f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105754:	c6 04 c5 64 39 11 80 	movb   $0x0,-0x7feec69c(,%eax,8)
8010575b:	00 
8010575c:	66 89 0c c5 62 39 11 	mov    %cx,-0x7feec69e(,%eax,8)
80105763:	80 
80105764:	c6 04 c5 65 39 11 80 	movb   $0x8e,-0x7feec69b(,%eax,8)
8010576b:	8e 
8010576c:	66 89 14 c5 60 39 11 	mov    %dx,-0x7feec6a0(,%eax,8)
80105773:	80 
80105774:	c1 ea 10             	shr    $0x10,%edx
80105777:	66 89 14 c5 66 39 11 	mov    %dx,-0x7feec69a(,%eax,8)
8010577e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010577f:	83 c0 01             	add    $0x1,%eax
80105782:	3d 00 01 00 00       	cmp    $0x100,%eax
80105787:	75 bf                	jne    80105748 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105789:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010578a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010578f:	89 e5                	mov    %esp,%ebp
80105791:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105794:	a1 0c a1 10 80       	mov    0x8010a10c,%eax

  initlock(&tickslock, "time");
80105799:	68 19 77 10 80       	push   $0x80107719
8010579e:	68 20 39 11 80       	push   $0x80113920
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057a3:	66 89 15 62 3b 11 80 	mov    %dx,0x80113b62
801057aa:	c6 05 64 3b 11 80 00 	movb   $0x0,0x80113b64
801057b1:	66 a3 60 3b 11 80    	mov    %ax,0x80113b60
801057b7:	c1 e8 10             	shr    $0x10,%eax
801057ba:	c6 05 65 3b 11 80 ef 	movb   $0xef,0x80113b65
801057c1:	66 a3 66 3b 11 80    	mov    %ax,0x80113b66

  initlock(&tickslock, "time");
801057c7:	e8 c4 ea ff ff       	call   80104290 <initlock>
}
801057cc:	83 c4 10             	add    $0x10,%esp
801057cf:	c9                   	leave  
801057d0:	c3                   	ret    
801057d1:	eb 0d                	jmp    801057e0 <idtinit>
801057d3:	90                   	nop
801057d4:	90                   	nop
801057d5:	90                   	nop
801057d6:	90                   	nop
801057d7:	90                   	nop
801057d8:	90                   	nop
801057d9:	90                   	nop
801057da:	90                   	nop
801057db:	90                   	nop
801057dc:	90                   	nop
801057dd:	90                   	nop
801057de:	90                   	nop
801057df:	90                   	nop

801057e0 <idtinit>:

void
idtinit(void)
{
801057e0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801057e1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801057e6:	89 e5                	mov    %esp,%ebp
801057e8:	83 ec 10             	sub    $0x10,%esp
801057eb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801057ef:	b8 60 39 11 80       	mov    $0x80113960,%eax
801057f4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801057f8:	c1 e8 10             	shr    $0x10,%eax
801057fb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801057ff:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105802:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105805:	c9                   	leave  
80105806:	c3                   	ret    
80105807:	89 f6                	mov    %esi,%esi
80105809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105810 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105810:	55                   	push   %ebp
80105811:	89 e5                	mov    %esp,%ebp
80105813:	57                   	push   %edi
80105814:	56                   	push   %esi
80105815:	53                   	push   %ebx
80105816:	83 ec 0c             	sub    $0xc,%esp
80105819:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010581c:	8b 43 30             	mov    0x30(%ebx),%eax
8010581f:	83 f8 40             	cmp    $0x40,%eax
80105822:	0f 84 f8 00 00 00    	je     80105920 <trap+0x110>
    if(proc->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105828:	83 e8 20             	sub    $0x20,%eax
8010582b:	83 f8 1f             	cmp    $0x1f,%eax
8010582e:	77 68                	ja     80105898 <trap+0x88>
80105830:	ff 24 85 c0 77 10 80 	jmp    *-0x7fef8840(,%eax,4)
80105837:	89 f6                	mov    %esi,%esi
80105839:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
80105840:	e8 9b cf ff ff       	call   801027e0 <cpunum>
80105845:	85 c0                	test   %eax,%eax
80105847:	0f 84 b3 01 00 00    	je     80105a00 <trap+0x1f0>
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
8010584d:	e8 2e d0 ff ff       	call   80102880 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105852:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105858:	85 c0                	test   %eax,%eax
8010585a:	74 2d                	je     80105889 <trap+0x79>
8010585c:	8b 50 28             	mov    0x28(%eax),%edx
8010585f:	85 d2                	test   %edx,%edx
80105861:	0f 85 86 00 00 00    	jne    801058ed <trap+0xdd>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105867:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
8010586b:	0f 84 ef 00 00 00    	je     80105960 <trap+0x150>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105871:	8b 40 28             	mov    0x28(%eax),%eax
80105874:	85 c0                	test   %eax,%eax
80105876:	74 11                	je     80105889 <trap+0x79>
80105878:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
8010587c:	83 e0 03             	and    $0x3,%eax
8010587f:	66 83 f8 03          	cmp    $0x3,%ax
80105883:	0f 84 c1 00 00 00    	je     8010594a <trap+0x13a>
    exit();
}
80105889:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010588c:	5b                   	pop    %ebx
8010588d:	5e                   	pop    %esi
8010588e:	5f                   	pop    %edi
8010588f:	5d                   	pop    %ebp
80105890:	c3                   	ret    
80105891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
80105898:	65 8b 0d 04 00 00 00 	mov    %gs:0x4,%ecx
8010589f:	85 c9                	test   %ecx,%ecx
801058a1:	0f 84 8d 01 00 00    	je     80105a34 <trap+0x224>
801058a7:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801058ab:	0f 84 83 01 00 00    	je     80105a34 <trap+0x224>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801058b1:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058b4:	8b 73 38             	mov    0x38(%ebx),%esi
801058b7:	e8 24 cf ff ff       	call   801027e0 <cpunum>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
801058bc:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058c3:	57                   	push   %edi
801058c4:	56                   	push   %esi
801058c5:	50                   	push   %eax
801058c6:	ff 73 34             	pushl  0x34(%ebx)
801058c9:	ff 73 30             	pushl  0x30(%ebx)
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
801058cc:	8d 42 70             	lea    0x70(%edx),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058cf:	50                   	push   %eax
801058d0:	ff 72 14             	pushl  0x14(%edx)
801058d3:	68 7c 77 10 80       	push   $0x8010777c
801058d8:	e8 63 ad ff ff       	call   80100640 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpunum(), tf->eip,
            rcr2());
    proc->killed = 1;
801058dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801058e3:	83 c4 20             	add    $0x20,%esp
801058e6:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801058ed:	0f b7 53 3c          	movzwl 0x3c(%ebx),%edx
801058f1:	83 e2 03             	and    $0x3,%edx
801058f4:	66 83 fa 03          	cmp    $0x3,%dx
801058f8:	0f 85 69 ff ff ff    	jne    80105867 <trap+0x57>
    exit();
801058fe:	e8 7d e4 ff ff       	call   80103d80 <exit>
80105903:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105909:	85 c0                	test   %eax,%eax
8010590b:	0f 85 56 ff ff ff    	jne    80105867 <trap+0x57>
80105911:	e9 73 ff ff ff       	jmp    80105889 <trap+0x79>
80105916:	8d 76 00             	lea    0x0(%esi),%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
80105920:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105926:	8b 70 28             	mov    0x28(%eax),%esi
80105929:	85 f6                	test   %esi,%esi
8010592b:	0f 85 bf 00 00 00    	jne    801059f0 <trap+0x1e0>
      exit();
    proc->tf = tf;
80105931:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105934:	e8 b7 ef ff ff       	call   801048f0 <syscall>
    if(proc->killed)
80105939:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010593f:	8b 58 28             	mov    0x28(%eax),%ebx
80105942:	85 db                	test   %ebx,%ebx
80105944:	0f 84 3f ff ff ff    	je     80105889 <trap+0x79>
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
8010594a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010594d:	5b                   	pop    %ebx
8010594e:	5e                   	pop    %esi
8010594f:	5f                   	pop    %edi
80105950:	5d                   	pop    %ebp
    if(proc->killed)
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
80105951:	e9 2a e4 ff ff       	jmp    80103d80 <exit>
80105956:	8d 76 00             	lea    0x0(%esi),%esi
80105959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80105960:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105964:	0f 85 07 ff ff ff    	jne    80105871 <trap+0x61>
    yield();
8010596a:	e8 61 e5 ff ff       	call   80103ed0 <yield>
8010596f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80105975:	85 c0                	test   %eax,%eax
80105977:	0f 85 f4 fe ff ff    	jne    80105871 <trap+0x61>
8010597d:	e9 07 ff ff ff       	jmp    80105889 <trap+0x79>
80105982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105988:	e8 33 cd ff ff       	call   801026c0 <kbdintr>
    lapiceoi();
8010598d:	e8 ee ce ff ff       	call   80102880 <lapiceoi>
    break;
80105992:	e9 bb fe ff ff       	jmp    80105852 <trap+0x42>
80105997:	89 f6                	mov    %esi,%esi
80105999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801059a0:	e8 2b 02 00 00       	call   80105bd0 <uartintr>
801059a5:	e9 a3 fe ff ff       	jmp    8010584d <trap+0x3d>
801059aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801059b0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801059b4:	8b 7b 38             	mov    0x38(%ebx),%edi
801059b7:	e8 24 ce ff ff       	call   801027e0 <cpunum>
801059bc:	57                   	push   %edi
801059bd:	56                   	push   %esi
801059be:	50                   	push   %eax
801059bf:	68 24 77 10 80       	push   $0x80107724
801059c4:	e8 77 ac ff ff       	call   80100640 <cprintf>
            cpunum(), tf->cs, tf->eip);
    lapiceoi();
801059c9:	e8 b2 ce ff ff       	call   80102880 <lapiceoi>
    break;
801059ce:	83 c4 10             	add    $0x10,%esp
801059d1:	e9 7c fe ff ff       	jmp    80105852 <trap+0x42>
801059d6:	8d 76 00             	lea    0x0(%esi),%esi
801059d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801059e0:	e8 5b c7 ff ff       	call   80102140 <ideintr>
    lapiceoi();
801059e5:	e8 96 ce ff ff       	call   80102880 <lapiceoi>
    break;
801059ea:	e9 63 fe ff ff       	jmp    80105852 <trap+0x42>
801059ef:	90                   	nop
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(proc->killed)
      exit();
801059f0:	e8 8b e3 ff ff       	call   80103d80 <exit>
801059f5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059fb:	e9 31 ff ff ff       	jmp    80105931 <trap+0x121>
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
80105a00:	83 ec 0c             	sub    $0xc,%esp
80105a03:	68 20 39 11 80       	push   $0x80113920
80105a08:	e8 a3 e8 ff ff       	call   801042b0 <acquire>
      ticks++;
      wakeup(&ticks);
80105a0d:	c7 04 24 60 41 11 80 	movl   $0x80114160,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpunum() == 0){
      acquire(&tickslock);
      ticks++;
80105a14:	83 05 60 41 11 80 01 	addl   $0x1,0x80114160
      wakeup(&ticks);
80105a1b:	e8 b0 e6 ff ff       	call   801040d0 <wakeup>
      release(&tickslock);
80105a20:	c7 04 24 20 39 11 80 	movl   $0x80113920,(%esp)
80105a27:	e8 64 ea ff ff       	call   80104490 <release>
80105a2c:	83 c4 10             	add    $0x10,%esp
80105a2f:	e9 19 fe ff ff       	jmp    8010584d <trap+0x3d>
80105a34:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a37:	8b 73 38             	mov    0x38(%ebx),%esi
80105a3a:	e8 a1 cd ff ff       	call   801027e0 <cpunum>
80105a3f:	83 ec 0c             	sub    $0xc,%esp
80105a42:	57                   	push   %edi
80105a43:	56                   	push   %esi
80105a44:	50                   	push   %eax
80105a45:	ff 73 30             	pushl  0x30(%ebx)
80105a48:	68 48 77 10 80       	push   $0x80107748
80105a4d:	e8 ee ab ff ff       	call   80100640 <cprintf>
              tf->trapno, cpunum(), tf->eip, rcr2());
      panic("trap");
80105a52:	83 c4 14             	add    $0x14,%esp
80105a55:	68 1e 77 10 80       	push   $0x8010771e
80105a5a:	e8 f1 a8 ff ff       	call   80100350 <panic>
80105a5f:	90                   	nop

80105a60 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105a60:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105a65:	55                   	push   %ebp
80105a66:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105a68:	85 c0                	test   %eax,%eax
80105a6a:	74 1c                	je     80105a88 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a6c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a71:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105a72:	a8 01                	test   $0x1,%al
80105a74:	74 12                	je     80105a88 <uartgetc+0x28>
80105a76:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a7b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a7c:	0f b6 c0             	movzbl %al,%eax
}
80105a7f:	5d                   	pop    %ebp
80105a80:	c3                   	ret    
80105a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105a88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105a8d:	5d                   	pop    %ebp
80105a8e:	c3                   	ret    
80105a8f:	90                   	nop

80105a90 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	57                   	push   %edi
80105a94:	56                   	push   %esi
80105a95:	53                   	push   %ebx
80105a96:	89 c7                	mov    %eax,%edi
80105a98:	bb 80 00 00 00       	mov    $0x80,%ebx
80105a9d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105aa2:	83 ec 0c             	sub    $0xc,%esp
80105aa5:	eb 1b                	jmp    80105ac2 <uartputc.part.0+0x32>
80105aa7:	89 f6                	mov    %esi,%esi
80105aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105ab0:	83 ec 0c             	sub    $0xc,%esp
80105ab3:	6a 0a                	push   $0xa
80105ab5:	e8 e6 cd ff ff       	call   801028a0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105aba:	83 c4 10             	add    $0x10,%esp
80105abd:	83 eb 01             	sub    $0x1,%ebx
80105ac0:	74 07                	je     80105ac9 <uartputc.part.0+0x39>
80105ac2:	89 f2                	mov    %esi,%edx
80105ac4:	ec                   	in     (%dx),%al
80105ac5:	a8 20                	test   $0x20,%al
80105ac7:	74 e7                	je     80105ab0 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ac9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ace:	89 f8                	mov    %edi,%eax
80105ad0:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105ad1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ad4:	5b                   	pop    %ebx
80105ad5:	5e                   	pop    %esi
80105ad6:	5f                   	pop    %edi
80105ad7:	5d                   	pop    %ebp
80105ad8:	c3                   	ret    
80105ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ae0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105ae0:	55                   	push   %ebp
80105ae1:	31 c9                	xor    %ecx,%ecx
80105ae3:	89 c8                	mov    %ecx,%eax
80105ae5:	89 e5                	mov    %esp,%ebp
80105ae7:	57                   	push   %edi
80105ae8:	56                   	push   %esi
80105ae9:	53                   	push   %ebx
80105aea:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105aef:	89 da                	mov    %ebx,%edx
80105af1:	83 ec 0c             	sub    $0xc,%esp
80105af4:	ee                   	out    %al,(%dx)
80105af5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105afa:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105aff:	89 fa                	mov    %edi,%edx
80105b01:	ee                   	out    %al,(%dx)
80105b02:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b07:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b0c:	ee                   	out    %al,(%dx)
80105b0d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b12:	89 c8                	mov    %ecx,%eax
80105b14:	89 f2                	mov    %esi,%edx
80105b16:	ee                   	out    %al,(%dx)
80105b17:	b8 03 00 00 00       	mov    $0x3,%eax
80105b1c:	89 fa                	mov    %edi,%edx
80105b1e:	ee                   	out    %al,(%dx)
80105b1f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105b24:	89 c8                	mov    %ecx,%eax
80105b26:	ee                   	out    %al,(%dx)
80105b27:	b8 01 00 00 00       	mov    $0x1,%eax
80105b2c:	89 f2                	mov    %esi,%edx
80105b2e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b2f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b34:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105b35:	3c ff                	cmp    $0xff,%al
80105b37:	74 5a                	je     80105b93 <uartinit+0xb3>
    return;
  uart = 1;
80105b39:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80105b40:	00 00 00 
80105b43:	89 da                	mov    %ebx,%edx
80105b45:	ec                   	in     (%dx),%al
80105b46:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b4b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  picenable(IRQ_COM1);
80105b4c:	83 ec 0c             	sub    $0xc,%esp
80105b4f:	6a 04                	push   $0x4
80105b51:	e8 3a d8 ff ff       	call   80103390 <picenable>
  ioapicenable(IRQ_COM1, 0);
80105b56:	59                   	pop    %ecx
80105b57:	5b                   	pop    %ebx
80105b58:	6a 00                	push   $0x0
80105b5a:	6a 04                	push   $0x4
80105b5c:	bb 40 78 10 80       	mov    $0x80107840,%ebx
80105b61:	e8 2a c8 ff ff       	call   80102390 <ioapicenable>
80105b66:	83 c4 10             	add    $0x10,%esp
80105b69:	b8 78 00 00 00       	mov    $0x78,%eax
80105b6e:	eb 0a                	jmp    80105b7a <uartinit+0x9a>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b70:	83 c3 01             	add    $0x1,%ebx
80105b73:	0f be 03             	movsbl (%ebx),%eax
80105b76:	84 c0                	test   %al,%al
80105b78:	74 19                	je     80105b93 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105b7a:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
80105b80:	85 d2                	test   %edx,%edx
80105b82:	74 ec                	je     80105b70 <uartinit+0x90>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b84:	83 c3 01             	add    $0x1,%ebx
80105b87:	e8 04 ff ff ff       	call   80105a90 <uartputc.part.0>
80105b8c:	0f be 03             	movsbl (%ebx),%eax
80105b8f:	84 c0                	test   %al,%al
80105b91:	75 e7                	jne    80105b7a <uartinit+0x9a>
    uartputc(*p);
}
80105b93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b96:	5b                   	pop    %ebx
80105b97:	5e                   	pop    %esi
80105b98:	5f                   	pop    %edi
80105b99:	5d                   	pop    %ebp
80105b9a:	c3                   	ret    
80105b9b:	90                   	nop
80105b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ba0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105ba0:	8b 15 c0 a5 10 80    	mov    0x8010a5c0,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105ba6:	55                   	push   %ebp
80105ba7:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105ba9:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105bab:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105bae:	74 10                	je     80105bc0 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105bb0:	5d                   	pop    %ebp
80105bb1:	e9 da fe ff ff       	jmp    80105a90 <uartputc.part.0>
80105bb6:	8d 76 00             	lea    0x0(%esi),%esi
80105bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105bc0:	5d                   	pop    %ebp
80105bc1:	c3                   	ret    
80105bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bd0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105bd6:	68 60 5a 10 80       	push   $0x80105a60
80105bdb:	e8 f0 ab ff ff       	call   801007d0 <consoleintr>
}
80105be0:	83 c4 10             	add    $0x10,%esp
80105be3:	c9                   	leave  
80105be4:	c3                   	ret    

80105be5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105be5:	6a 00                	push   $0x0
  pushl $0
80105be7:	6a 00                	push   $0x0
  jmp alltraps
80105be9:	e9 20 fb ff ff       	jmp    8010570e <alltraps>

80105bee <vector1>:
.globl vector1
vector1:
  pushl $0
80105bee:	6a 00                	push   $0x0
  pushl $1
80105bf0:	6a 01                	push   $0x1
  jmp alltraps
80105bf2:	e9 17 fb ff ff       	jmp    8010570e <alltraps>

80105bf7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105bf7:	6a 00                	push   $0x0
  pushl $2
80105bf9:	6a 02                	push   $0x2
  jmp alltraps
80105bfb:	e9 0e fb ff ff       	jmp    8010570e <alltraps>

80105c00 <vector3>:
.globl vector3
vector3:
  pushl $0
80105c00:	6a 00                	push   $0x0
  pushl $3
80105c02:	6a 03                	push   $0x3
  jmp alltraps
80105c04:	e9 05 fb ff ff       	jmp    8010570e <alltraps>

80105c09 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c09:	6a 00                	push   $0x0
  pushl $4
80105c0b:	6a 04                	push   $0x4
  jmp alltraps
80105c0d:	e9 fc fa ff ff       	jmp    8010570e <alltraps>

80105c12 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c12:	6a 00                	push   $0x0
  pushl $5
80105c14:	6a 05                	push   $0x5
  jmp alltraps
80105c16:	e9 f3 fa ff ff       	jmp    8010570e <alltraps>

80105c1b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c1b:	6a 00                	push   $0x0
  pushl $6
80105c1d:	6a 06                	push   $0x6
  jmp alltraps
80105c1f:	e9 ea fa ff ff       	jmp    8010570e <alltraps>

80105c24 <vector7>:
.globl vector7
vector7:
  pushl $0
80105c24:	6a 00                	push   $0x0
  pushl $7
80105c26:	6a 07                	push   $0x7
  jmp alltraps
80105c28:	e9 e1 fa ff ff       	jmp    8010570e <alltraps>

80105c2d <vector8>:
.globl vector8
vector8:
  pushl $8
80105c2d:	6a 08                	push   $0x8
  jmp alltraps
80105c2f:	e9 da fa ff ff       	jmp    8010570e <alltraps>

80105c34 <vector9>:
.globl vector9
vector9:
  pushl $0
80105c34:	6a 00                	push   $0x0
  pushl $9
80105c36:	6a 09                	push   $0x9
  jmp alltraps
80105c38:	e9 d1 fa ff ff       	jmp    8010570e <alltraps>

80105c3d <vector10>:
.globl vector10
vector10:
  pushl $10
80105c3d:	6a 0a                	push   $0xa
  jmp alltraps
80105c3f:	e9 ca fa ff ff       	jmp    8010570e <alltraps>

80105c44 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c44:	6a 0b                	push   $0xb
  jmp alltraps
80105c46:	e9 c3 fa ff ff       	jmp    8010570e <alltraps>

80105c4b <vector12>:
.globl vector12
vector12:
  pushl $12
80105c4b:	6a 0c                	push   $0xc
  jmp alltraps
80105c4d:	e9 bc fa ff ff       	jmp    8010570e <alltraps>

80105c52 <vector13>:
.globl vector13
vector13:
  pushl $13
80105c52:	6a 0d                	push   $0xd
  jmp alltraps
80105c54:	e9 b5 fa ff ff       	jmp    8010570e <alltraps>

80105c59 <vector14>:
.globl vector14
vector14:
  pushl $14
80105c59:	6a 0e                	push   $0xe
  jmp alltraps
80105c5b:	e9 ae fa ff ff       	jmp    8010570e <alltraps>

80105c60 <vector15>:
.globl vector15
vector15:
  pushl $0
80105c60:	6a 00                	push   $0x0
  pushl $15
80105c62:	6a 0f                	push   $0xf
  jmp alltraps
80105c64:	e9 a5 fa ff ff       	jmp    8010570e <alltraps>

80105c69 <vector16>:
.globl vector16
vector16:
  pushl $0
80105c69:	6a 00                	push   $0x0
  pushl $16
80105c6b:	6a 10                	push   $0x10
  jmp alltraps
80105c6d:	e9 9c fa ff ff       	jmp    8010570e <alltraps>

80105c72 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c72:	6a 11                	push   $0x11
  jmp alltraps
80105c74:	e9 95 fa ff ff       	jmp    8010570e <alltraps>

80105c79 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c79:	6a 00                	push   $0x0
  pushl $18
80105c7b:	6a 12                	push   $0x12
  jmp alltraps
80105c7d:	e9 8c fa ff ff       	jmp    8010570e <alltraps>

80105c82 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c82:	6a 00                	push   $0x0
  pushl $19
80105c84:	6a 13                	push   $0x13
  jmp alltraps
80105c86:	e9 83 fa ff ff       	jmp    8010570e <alltraps>

80105c8b <vector20>:
.globl vector20
vector20:
  pushl $0
80105c8b:	6a 00                	push   $0x0
  pushl $20
80105c8d:	6a 14                	push   $0x14
  jmp alltraps
80105c8f:	e9 7a fa ff ff       	jmp    8010570e <alltraps>

80105c94 <vector21>:
.globl vector21
vector21:
  pushl $0
80105c94:	6a 00                	push   $0x0
  pushl $21
80105c96:	6a 15                	push   $0x15
  jmp alltraps
80105c98:	e9 71 fa ff ff       	jmp    8010570e <alltraps>

80105c9d <vector22>:
.globl vector22
vector22:
  pushl $0
80105c9d:	6a 00                	push   $0x0
  pushl $22
80105c9f:	6a 16                	push   $0x16
  jmp alltraps
80105ca1:	e9 68 fa ff ff       	jmp    8010570e <alltraps>

80105ca6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105ca6:	6a 00                	push   $0x0
  pushl $23
80105ca8:	6a 17                	push   $0x17
  jmp alltraps
80105caa:	e9 5f fa ff ff       	jmp    8010570e <alltraps>

80105caf <vector24>:
.globl vector24
vector24:
  pushl $0
80105caf:	6a 00                	push   $0x0
  pushl $24
80105cb1:	6a 18                	push   $0x18
  jmp alltraps
80105cb3:	e9 56 fa ff ff       	jmp    8010570e <alltraps>

80105cb8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105cb8:	6a 00                	push   $0x0
  pushl $25
80105cba:	6a 19                	push   $0x19
  jmp alltraps
80105cbc:	e9 4d fa ff ff       	jmp    8010570e <alltraps>

80105cc1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105cc1:	6a 00                	push   $0x0
  pushl $26
80105cc3:	6a 1a                	push   $0x1a
  jmp alltraps
80105cc5:	e9 44 fa ff ff       	jmp    8010570e <alltraps>

80105cca <vector27>:
.globl vector27
vector27:
  pushl $0
80105cca:	6a 00                	push   $0x0
  pushl $27
80105ccc:	6a 1b                	push   $0x1b
  jmp alltraps
80105cce:	e9 3b fa ff ff       	jmp    8010570e <alltraps>

80105cd3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105cd3:	6a 00                	push   $0x0
  pushl $28
80105cd5:	6a 1c                	push   $0x1c
  jmp alltraps
80105cd7:	e9 32 fa ff ff       	jmp    8010570e <alltraps>

80105cdc <vector29>:
.globl vector29
vector29:
  pushl $0
80105cdc:	6a 00                	push   $0x0
  pushl $29
80105cde:	6a 1d                	push   $0x1d
  jmp alltraps
80105ce0:	e9 29 fa ff ff       	jmp    8010570e <alltraps>

80105ce5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105ce5:	6a 00                	push   $0x0
  pushl $30
80105ce7:	6a 1e                	push   $0x1e
  jmp alltraps
80105ce9:	e9 20 fa ff ff       	jmp    8010570e <alltraps>

80105cee <vector31>:
.globl vector31
vector31:
  pushl $0
80105cee:	6a 00                	push   $0x0
  pushl $31
80105cf0:	6a 1f                	push   $0x1f
  jmp alltraps
80105cf2:	e9 17 fa ff ff       	jmp    8010570e <alltraps>

80105cf7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105cf7:	6a 00                	push   $0x0
  pushl $32
80105cf9:	6a 20                	push   $0x20
  jmp alltraps
80105cfb:	e9 0e fa ff ff       	jmp    8010570e <alltraps>

80105d00 <vector33>:
.globl vector33
vector33:
  pushl $0
80105d00:	6a 00                	push   $0x0
  pushl $33
80105d02:	6a 21                	push   $0x21
  jmp alltraps
80105d04:	e9 05 fa ff ff       	jmp    8010570e <alltraps>

80105d09 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d09:	6a 00                	push   $0x0
  pushl $34
80105d0b:	6a 22                	push   $0x22
  jmp alltraps
80105d0d:	e9 fc f9 ff ff       	jmp    8010570e <alltraps>

80105d12 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d12:	6a 00                	push   $0x0
  pushl $35
80105d14:	6a 23                	push   $0x23
  jmp alltraps
80105d16:	e9 f3 f9 ff ff       	jmp    8010570e <alltraps>

80105d1b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d1b:	6a 00                	push   $0x0
  pushl $36
80105d1d:	6a 24                	push   $0x24
  jmp alltraps
80105d1f:	e9 ea f9 ff ff       	jmp    8010570e <alltraps>

80105d24 <vector37>:
.globl vector37
vector37:
  pushl $0
80105d24:	6a 00                	push   $0x0
  pushl $37
80105d26:	6a 25                	push   $0x25
  jmp alltraps
80105d28:	e9 e1 f9 ff ff       	jmp    8010570e <alltraps>

80105d2d <vector38>:
.globl vector38
vector38:
  pushl $0
80105d2d:	6a 00                	push   $0x0
  pushl $38
80105d2f:	6a 26                	push   $0x26
  jmp alltraps
80105d31:	e9 d8 f9 ff ff       	jmp    8010570e <alltraps>

80105d36 <vector39>:
.globl vector39
vector39:
  pushl $0
80105d36:	6a 00                	push   $0x0
  pushl $39
80105d38:	6a 27                	push   $0x27
  jmp alltraps
80105d3a:	e9 cf f9 ff ff       	jmp    8010570e <alltraps>

80105d3f <vector40>:
.globl vector40
vector40:
  pushl $0
80105d3f:	6a 00                	push   $0x0
  pushl $40
80105d41:	6a 28                	push   $0x28
  jmp alltraps
80105d43:	e9 c6 f9 ff ff       	jmp    8010570e <alltraps>

80105d48 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d48:	6a 00                	push   $0x0
  pushl $41
80105d4a:	6a 29                	push   $0x29
  jmp alltraps
80105d4c:	e9 bd f9 ff ff       	jmp    8010570e <alltraps>

80105d51 <vector42>:
.globl vector42
vector42:
  pushl $0
80105d51:	6a 00                	push   $0x0
  pushl $42
80105d53:	6a 2a                	push   $0x2a
  jmp alltraps
80105d55:	e9 b4 f9 ff ff       	jmp    8010570e <alltraps>

80105d5a <vector43>:
.globl vector43
vector43:
  pushl $0
80105d5a:	6a 00                	push   $0x0
  pushl $43
80105d5c:	6a 2b                	push   $0x2b
  jmp alltraps
80105d5e:	e9 ab f9 ff ff       	jmp    8010570e <alltraps>

80105d63 <vector44>:
.globl vector44
vector44:
  pushl $0
80105d63:	6a 00                	push   $0x0
  pushl $44
80105d65:	6a 2c                	push   $0x2c
  jmp alltraps
80105d67:	e9 a2 f9 ff ff       	jmp    8010570e <alltraps>

80105d6c <vector45>:
.globl vector45
vector45:
  pushl $0
80105d6c:	6a 00                	push   $0x0
  pushl $45
80105d6e:	6a 2d                	push   $0x2d
  jmp alltraps
80105d70:	e9 99 f9 ff ff       	jmp    8010570e <alltraps>

80105d75 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d75:	6a 00                	push   $0x0
  pushl $46
80105d77:	6a 2e                	push   $0x2e
  jmp alltraps
80105d79:	e9 90 f9 ff ff       	jmp    8010570e <alltraps>

80105d7e <vector47>:
.globl vector47
vector47:
  pushl $0
80105d7e:	6a 00                	push   $0x0
  pushl $47
80105d80:	6a 2f                	push   $0x2f
  jmp alltraps
80105d82:	e9 87 f9 ff ff       	jmp    8010570e <alltraps>

80105d87 <vector48>:
.globl vector48
vector48:
  pushl $0
80105d87:	6a 00                	push   $0x0
  pushl $48
80105d89:	6a 30                	push   $0x30
  jmp alltraps
80105d8b:	e9 7e f9 ff ff       	jmp    8010570e <alltraps>

80105d90 <vector49>:
.globl vector49
vector49:
  pushl $0
80105d90:	6a 00                	push   $0x0
  pushl $49
80105d92:	6a 31                	push   $0x31
  jmp alltraps
80105d94:	e9 75 f9 ff ff       	jmp    8010570e <alltraps>

80105d99 <vector50>:
.globl vector50
vector50:
  pushl $0
80105d99:	6a 00                	push   $0x0
  pushl $50
80105d9b:	6a 32                	push   $0x32
  jmp alltraps
80105d9d:	e9 6c f9 ff ff       	jmp    8010570e <alltraps>

80105da2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105da2:	6a 00                	push   $0x0
  pushl $51
80105da4:	6a 33                	push   $0x33
  jmp alltraps
80105da6:	e9 63 f9 ff ff       	jmp    8010570e <alltraps>

80105dab <vector52>:
.globl vector52
vector52:
  pushl $0
80105dab:	6a 00                	push   $0x0
  pushl $52
80105dad:	6a 34                	push   $0x34
  jmp alltraps
80105daf:	e9 5a f9 ff ff       	jmp    8010570e <alltraps>

80105db4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105db4:	6a 00                	push   $0x0
  pushl $53
80105db6:	6a 35                	push   $0x35
  jmp alltraps
80105db8:	e9 51 f9 ff ff       	jmp    8010570e <alltraps>

80105dbd <vector54>:
.globl vector54
vector54:
  pushl $0
80105dbd:	6a 00                	push   $0x0
  pushl $54
80105dbf:	6a 36                	push   $0x36
  jmp alltraps
80105dc1:	e9 48 f9 ff ff       	jmp    8010570e <alltraps>

80105dc6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105dc6:	6a 00                	push   $0x0
  pushl $55
80105dc8:	6a 37                	push   $0x37
  jmp alltraps
80105dca:	e9 3f f9 ff ff       	jmp    8010570e <alltraps>

80105dcf <vector56>:
.globl vector56
vector56:
  pushl $0
80105dcf:	6a 00                	push   $0x0
  pushl $56
80105dd1:	6a 38                	push   $0x38
  jmp alltraps
80105dd3:	e9 36 f9 ff ff       	jmp    8010570e <alltraps>

80105dd8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105dd8:	6a 00                	push   $0x0
  pushl $57
80105dda:	6a 39                	push   $0x39
  jmp alltraps
80105ddc:	e9 2d f9 ff ff       	jmp    8010570e <alltraps>

80105de1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105de1:	6a 00                	push   $0x0
  pushl $58
80105de3:	6a 3a                	push   $0x3a
  jmp alltraps
80105de5:	e9 24 f9 ff ff       	jmp    8010570e <alltraps>

80105dea <vector59>:
.globl vector59
vector59:
  pushl $0
80105dea:	6a 00                	push   $0x0
  pushl $59
80105dec:	6a 3b                	push   $0x3b
  jmp alltraps
80105dee:	e9 1b f9 ff ff       	jmp    8010570e <alltraps>

80105df3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105df3:	6a 00                	push   $0x0
  pushl $60
80105df5:	6a 3c                	push   $0x3c
  jmp alltraps
80105df7:	e9 12 f9 ff ff       	jmp    8010570e <alltraps>

80105dfc <vector61>:
.globl vector61
vector61:
  pushl $0
80105dfc:	6a 00                	push   $0x0
  pushl $61
80105dfe:	6a 3d                	push   $0x3d
  jmp alltraps
80105e00:	e9 09 f9 ff ff       	jmp    8010570e <alltraps>

80105e05 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e05:	6a 00                	push   $0x0
  pushl $62
80105e07:	6a 3e                	push   $0x3e
  jmp alltraps
80105e09:	e9 00 f9 ff ff       	jmp    8010570e <alltraps>

80105e0e <vector63>:
.globl vector63
vector63:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $63
80105e10:	6a 3f                	push   $0x3f
  jmp alltraps
80105e12:	e9 f7 f8 ff ff       	jmp    8010570e <alltraps>

80105e17 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e17:	6a 00                	push   $0x0
  pushl $64
80105e19:	6a 40                	push   $0x40
  jmp alltraps
80105e1b:	e9 ee f8 ff ff       	jmp    8010570e <alltraps>

80105e20 <vector65>:
.globl vector65
vector65:
  pushl $0
80105e20:	6a 00                	push   $0x0
  pushl $65
80105e22:	6a 41                	push   $0x41
  jmp alltraps
80105e24:	e9 e5 f8 ff ff       	jmp    8010570e <alltraps>

80105e29 <vector66>:
.globl vector66
vector66:
  pushl $0
80105e29:	6a 00                	push   $0x0
  pushl $66
80105e2b:	6a 42                	push   $0x42
  jmp alltraps
80105e2d:	e9 dc f8 ff ff       	jmp    8010570e <alltraps>

80105e32 <vector67>:
.globl vector67
vector67:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $67
80105e34:	6a 43                	push   $0x43
  jmp alltraps
80105e36:	e9 d3 f8 ff ff       	jmp    8010570e <alltraps>

80105e3b <vector68>:
.globl vector68
vector68:
  pushl $0
80105e3b:	6a 00                	push   $0x0
  pushl $68
80105e3d:	6a 44                	push   $0x44
  jmp alltraps
80105e3f:	e9 ca f8 ff ff       	jmp    8010570e <alltraps>

80105e44 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e44:	6a 00                	push   $0x0
  pushl $69
80105e46:	6a 45                	push   $0x45
  jmp alltraps
80105e48:	e9 c1 f8 ff ff       	jmp    8010570e <alltraps>

80105e4d <vector70>:
.globl vector70
vector70:
  pushl $0
80105e4d:	6a 00                	push   $0x0
  pushl $70
80105e4f:	6a 46                	push   $0x46
  jmp alltraps
80105e51:	e9 b8 f8 ff ff       	jmp    8010570e <alltraps>

80105e56 <vector71>:
.globl vector71
vector71:
  pushl $0
80105e56:	6a 00                	push   $0x0
  pushl $71
80105e58:	6a 47                	push   $0x47
  jmp alltraps
80105e5a:	e9 af f8 ff ff       	jmp    8010570e <alltraps>

80105e5f <vector72>:
.globl vector72
vector72:
  pushl $0
80105e5f:	6a 00                	push   $0x0
  pushl $72
80105e61:	6a 48                	push   $0x48
  jmp alltraps
80105e63:	e9 a6 f8 ff ff       	jmp    8010570e <alltraps>

80105e68 <vector73>:
.globl vector73
vector73:
  pushl $0
80105e68:	6a 00                	push   $0x0
  pushl $73
80105e6a:	6a 49                	push   $0x49
  jmp alltraps
80105e6c:	e9 9d f8 ff ff       	jmp    8010570e <alltraps>

80105e71 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e71:	6a 00                	push   $0x0
  pushl $74
80105e73:	6a 4a                	push   $0x4a
  jmp alltraps
80105e75:	e9 94 f8 ff ff       	jmp    8010570e <alltraps>

80105e7a <vector75>:
.globl vector75
vector75:
  pushl $0
80105e7a:	6a 00                	push   $0x0
  pushl $75
80105e7c:	6a 4b                	push   $0x4b
  jmp alltraps
80105e7e:	e9 8b f8 ff ff       	jmp    8010570e <alltraps>

80105e83 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e83:	6a 00                	push   $0x0
  pushl $76
80105e85:	6a 4c                	push   $0x4c
  jmp alltraps
80105e87:	e9 82 f8 ff ff       	jmp    8010570e <alltraps>

80105e8c <vector77>:
.globl vector77
vector77:
  pushl $0
80105e8c:	6a 00                	push   $0x0
  pushl $77
80105e8e:	6a 4d                	push   $0x4d
  jmp alltraps
80105e90:	e9 79 f8 ff ff       	jmp    8010570e <alltraps>

80105e95 <vector78>:
.globl vector78
vector78:
  pushl $0
80105e95:	6a 00                	push   $0x0
  pushl $78
80105e97:	6a 4e                	push   $0x4e
  jmp alltraps
80105e99:	e9 70 f8 ff ff       	jmp    8010570e <alltraps>

80105e9e <vector79>:
.globl vector79
vector79:
  pushl $0
80105e9e:	6a 00                	push   $0x0
  pushl $79
80105ea0:	6a 4f                	push   $0x4f
  jmp alltraps
80105ea2:	e9 67 f8 ff ff       	jmp    8010570e <alltraps>

80105ea7 <vector80>:
.globl vector80
vector80:
  pushl $0
80105ea7:	6a 00                	push   $0x0
  pushl $80
80105ea9:	6a 50                	push   $0x50
  jmp alltraps
80105eab:	e9 5e f8 ff ff       	jmp    8010570e <alltraps>

80105eb0 <vector81>:
.globl vector81
vector81:
  pushl $0
80105eb0:	6a 00                	push   $0x0
  pushl $81
80105eb2:	6a 51                	push   $0x51
  jmp alltraps
80105eb4:	e9 55 f8 ff ff       	jmp    8010570e <alltraps>

80105eb9 <vector82>:
.globl vector82
vector82:
  pushl $0
80105eb9:	6a 00                	push   $0x0
  pushl $82
80105ebb:	6a 52                	push   $0x52
  jmp alltraps
80105ebd:	e9 4c f8 ff ff       	jmp    8010570e <alltraps>

80105ec2 <vector83>:
.globl vector83
vector83:
  pushl $0
80105ec2:	6a 00                	push   $0x0
  pushl $83
80105ec4:	6a 53                	push   $0x53
  jmp alltraps
80105ec6:	e9 43 f8 ff ff       	jmp    8010570e <alltraps>

80105ecb <vector84>:
.globl vector84
vector84:
  pushl $0
80105ecb:	6a 00                	push   $0x0
  pushl $84
80105ecd:	6a 54                	push   $0x54
  jmp alltraps
80105ecf:	e9 3a f8 ff ff       	jmp    8010570e <alltraps>

80105ed4 <vector85>:
.globl vector85
vector85:
  pushl $0
80105ed4:	6a 00                	push   $0x0
  pushl $85
80105ed6:	6a 55                	push   $0x55
  jmp alltraps
80105ed8:	e9 31 f8 ff ff       	jmp    8010570e <alltraps>

80105edd <vector86>:
.globl vector86
vector86:
  pushl $0
80105edd:	6a 00                	push   $0x0
  pushl $86
80105edf:	6a 56                	push   $0x56
  jmp alltraps
80105ee1:	e9 28 f8 ff ff       	jmp    8010570e <alltraps>

80105ee6 <vector87>:
.globl vector87
vector87:
  pushl $0
80105ee6:	6a 00                	push   $0x0
  pushl $87
80105ee8:	6a 57                	push   $0x57
  jmp alltraps
80105eea:	e9 1f f8 ff ff       	jmp    8010570e <alltraps>

80105eef <vector88>:
.globl vector88
vector88:
  pushl $0
80105eef:	6a 00                	push   $0x0
  pushl $88
80105ef1:	6a 58                	push   $0x58
  jmp alltraps
80105ef3:	e9 16 f8 ff ff       	jmp    8010570e <alltraps>

80105ef8 <vector89>:
.globl vector89
vector89:
  pushl $0
80105ef8:	6a 00                	push   $0x0
  pushl $89
80105efa:	6a 59                	push   $0x59
  jmp alltraps
80105efc:	e9 0d f8 ff ff       	jmp    8010570e <alltraps>

80105f01 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f01:	6a 00                	push   $0x0
  pushl $90
80105f03:	6a 5a                	push   $0x5a
  jmp alltraps
80105f05:	e9 04 f8 ff ff       	jmp    8010570e <alltraps>

80105f0a <vector91>:
.globl vector91
vector91:
  pushl $0
80105f0a:	6a 00                	push   $0x0
  pushl $91
80105f0c:	6a 5b                	push   $0x5b
  jmp alltraps
80105f0e:	e9 fb f7 ff ff       	jmp    8010570e <alltraps>

80105f13 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f13:	6a 00                	push   $0x0
  pushl $92
80105f15:	6a 5c                	push   $0x5c
  jmp alltraps
80105f17:	e9 f2 f7 ff ff       	jmp    8010570e <alltraps>

80105f1c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f1c:	6a 00                	push   $0x0
  pushl $93
80105f1e:	6a 5d                	push   $0x5d
  jmp alltraps
80105f20:	e9 e9 f7 ff ff       	jmp    8010570e <alltraps>

80105f25 <vector94>:
.globl vector94
vector94:
  pushl $0
80105f25:	6a 00                	push   $0x0
  pushl $94
80105f27:	6a 5e                	push   $0x5e
  jmp alltraps
80105f29:	e9 e0 f7 ff ff       	jmp    8010570e <alltraps>

80105f2e <vector95>:
.globl vector95
vector95:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $95
80105f30:	6a 5f                	push   $0x5f
  jmp alltraps
80105f32:	e9 d7 f7 ff ff       	jmp    8010570e <alltraps>

80105f37 <vector96>:
.globl vector96
vector96:
  pushl $0
80105f37:	6a 00                	push   $0x0
  pushl $96
80105f39:	6a 60                	push   $0x60
  jmp alltraps
80105f3b:	e9 ce f7 ff ff       	jmp    8010570e <alltraps>

80105f40 <vector97>:
.globl vector97
vector97:
  pushl $0
80105f40:	6a 00                	push   $0x0
  pushl $97
80105f42:	6a 61                	push   $0x61
  jmp alltraps
80105f44:	e9 c5 f7 ff ff       	jmp    8010570e <alltraps>

80105f49 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f49:	6a 00                	push   $0x0
  pushl $98
80105f4b:	6a 62                	push   $0x62
  jmp alltraps
80105f4d:	e9 bc f7 ff ff       	jmp    8010570e <alltraps>

80105f52 <vector99>:
.globl vector99
vector99:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $99
80105f54:	6a 63                	push   $0x63
  jmp alltraps
80105f56:	e9 b3 f7 ff ff       	jmp    8010570e <alltraps>

80105f5b <vector100>:
.globl vector100
vector100:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $100
80105f5d:	6a 64                	push   $0x64
  jmp alltraps
80105f5f:	e9 aa f7 ff ff       	jmp    8010570e <alltraps>

80105f64 <vector101>:
.globl vector101
vector101:
  pushl $0
80105f64:	6a 00                	push   $0x0
  pushl $101
80105f66:	6a 65                	push   $0x65
  jmp alltraps
80105f68:	e9 a1 f7 ff ff       	jmp    8010570e <alltraps>

80105f6d <vector102>:
.globl vector102
vector102:
  pushl $0
80105f6d:	6a 00                	push   $0x0
  pushl $102
80105f6f:	6a 66                	push   $0x66
  jmp alltraps
80105f71:	e9 98 f7 ff ff       	jmp    8010570e <alltraps>

80105f76 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f76:	6a 00                	push   $0x0
  pushl $103
80105f78:	6a 67                	push   $0x67
  jmp alltraps
80105f7a:	e9 8f f7 ff ff       	jmp    8010570e <alltraps>

80105f7f <vector104>:
.globl vector104
vector104:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $104
80105f81:	6a 68                	push   $0x68
  jmp alltraps
80105f83:	e9 86 f7 ff ff       	jmp    8010570e <alltraps>

80105f88 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f88:	6a 00                	push   $0x0
  pushl $105
80105f8a:	6a 69                	push   $0x69
  jmp alltraps
80105f8c:	e9 7d f7 ff ff       	jmp    8010570e <alltraps>

80105f91 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f91:	6a 00                	push   $0x0
  pushl $106
80105f93:	6a 6a                	push   $0x6a
  jmp alltraps
80105f95:	e9 74 f7 ff ff       	jmp    8010570e <alltraps>

80105f9a <vector107>:
.globl vector107
vector107:
  pushl $0
80105f9a:	6a 00                	push   $0x0
  pushl $107
80105f9c:	6a 6b                	push   $0x6b
  jmp alltraps
80105f9e:	e9 6b f7 ff ff       	jmp    8010570e <alltraps>

80105fa3 <vector108>:
.globl vector108
vector108:
  pushl $0
80105fa3:	6a 00                	push   $0x0
  pushl $108
80105fa5:	6a 6c                	push   $0x6c
  jmp alltraps
80105fa7:	e9 62 f7 ff ff       	jmp    8010570e <alltraps>

80105fac <vector109>:
.globl vector109
vector109:
  pushl $0
80105fac:	6a 00                	push   $0x0
  pushl $109
80105fae:	6a 6d                	push   $0x6d
  jmp alltraps
80105fb0:	e9 59 f7 ff ff       	jmp    8010570e <alltraps>

80105fb5 <vector110>:
.globl vector110
vector110:
  pushl $0
80105fb5:	6a 00                	push   $0x0
  pushl $110
80105fb7:	6a 6e                	push   $0x6e
  jmp alltraps
80105fb9:	e9 50 f7 ff ff       	jmp    8010570e <alltraps>

80105fbe <vector111>:
.globl vector111
vector111:
  pushl $0
80105fbe:	6a 00                	push   $0x0
  pushl $111
80105fc0:	6a 6f                	push   $0x6f
  jmp alltraps
80105fc2:	e9 47 f7 ff ff       	jmp    8010570e <alltraps>

80105fc7 <vector112>:
.globl vector112
vector112:
  pushl $0
80105fc7:	6a 00                	push   $0x0
  pushl $112
80105fc9:	6a 70                	push   $0x70
  jmp alltraps
80105fcb:	e9 3e f7 ff ff       	jmp    8010570e <alltraps>

80105fd0 <vector113>:
.globl vector113
vector113:
  pushl $0
80105fd0:	6a 00                	push   $0x0
  pushl $113
80105fd2:	6a 71                	push   $0x71
  jmp alltraps
80105fd4:	e9 35 f7 ff ff       	jmp    8010570e <alltraps>

80105fd9 <vector114>:
.globl vector114
vector114:
  pushl $0
80105fd9:	6a 00                	push   $0x0
  pushl $114
80105fdb:	6a 72                	push   $0x72
  jmp alltraps
80105fdd:	e9 2c f7 ff ff       	jmp    8010570e <alltraps>

80105fe2 <vector115>:
.globl vector115
vector115:
  pushl $0
80105fe2:	6a 00                	push   $0x0
  pushl $115
80105fe4:	6a 73                	push   $0x73
  jmp alltraps
80105fe6:	e9 23 f7 ff ff       	jmp    8010570e <alltraps>

80105feb <vector116>:
.globl vector116
vector116:
  pushl $0
80105feb:	6a 00                	push   $0x0
  pushl $116
80105fed:	6a 74                	push   $0x74
  jmp alltraps
80105fef:	e9 1a f7 ff ff       	jmp    8010570e <alltraps>

80105ff4 <vector117>:
.globl vector117
vector117:
  pushl $0
80105ff4:	6a 00                	push   $0x0
  pushl $117
80105ff6:	6a 75                	push   $0x75
  jmp alltraps
80105ff8:	e9 11 f7 ff ff       	jmp    8010570e <alltraps>

80105ffd <vector118>:
.globl vector118
vector118:
  pushl $0
80105ffd:	6a 00                	push   $0x0
  pushl $118
80105fff:	6a 76                	push   $0x76
  jmp alltraps
80106001:	e9 08 f7 ff ff       	jmp    8010570e <alltraps>

80106006 <vector119>:
.globl vector119
vector119:
  pushl $0
80106006:	6a 00                	push   $0x0
  pushl $119
80106008:	6a 77                	push   $0x77
  jmp alltraps
8010600a:	e9 ff f6 ff ff       	jmp    8010570e <alltraps>

8010600f <vector120>:
.globl vector120
vector120:
  pushl $0
8010600f:	6a 00                	push   $0x0
  pushl $120
80106011:	6a 78                	push   $0x78
  jmp alltraps
80106013:	e9 f6 f6 ff ff       	jmp    8010570e <alltraps>

80106018 <vector121>:
.globl vector121
vector121:
  pushl $0
80106018:	6a 00                	push   $0x0
  pushl $121
8010601a:	6a 79                	push   $0x79
  jmp alltraps
8010601c:	e9 ed f6 ff ff       	jmp    8010570e <alltraps>

80106021 <vector122>:
.globl vector122
vector122:
  pushl $0
80106021:	6a 00                	push   $0x0
  pushl $122
80106023:	6a 7a                	push   $0x7a
  jmp alltraps
80106025:	e9 e4 f6 ff ff       	jmp    8010570e <alltraps>

8010602a <vector123>:
.globl vector123
vector123:
  pushl $0
8010602a:	6a 00                	push   $0x0
  pushl $123
8010602c:	6a 7b                	push   $0x7b
  jmp alltraps
8010602e:	e9 db f6 ff ff       	jmp    8010570e <alltraps>

80106033 <vector124>:
.globl vector124
vector124:
  pushl $0
80106033:	6a 00                	push   $0x0
  pushl $124
80106035:	6a 7c                	push   $0x7c
  jmp alltraps
80106037:	e9 d2 f6 ff ff       	jmp    8010570e <alltraps>

8010603c <vector125>:
.globl vector125
vector125:
  pushl $0
8010603c:	6a 00                	push   $0x0
  pushl $125
8010603e:	6a 7d                	push   $0x7d
  jmp alltraps
80106040:	e9 c9 f6 ff ff       	jmp    8010570e <alltraps>

80106045 <vector126>:
.globl vector126
vector126:
  pushl $0
80106045:	6a 00                	push   $0x0
  pushl $126
80106047:	6a 7e                	push   $0x7e
  jmp alltraps
80106049:	e9 c0 f6 ff ff       	jmp    8010570e <alltraps>

8010604e <vector127>:
.globl vector127
vector127:
  pushl $0
8010604e:	6a 00                	push   $0x0
  pushl $127
80106050:	6a 7f                	push   $0x7f
  jmp alltraps
80106052:	e9 b7 f6 ff ff       	jmp    8010570e <alltraps>

80106057 <vector128>:
.globl vector128
vector128:
  pushl $0
80106057:	6a 00                	push   $0x0
  pushl $128
80106059:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010605e:	e9 ab f6 ff ff       	jmp    8010570e <alltraps>

80106063 <vector129>:
.globl vector129
vector129:
  pushl $0
80106063:	6a 00                	push   $0x0
  pushl $129
80106065:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010606a:	e9 9f f6 ff ff       	jmp    8010570e <alltraps>

8010606f <vector130>:
.globl vector130
vector130:
  pushl $0
8010606f:	6a 00                	push   $0x0
  pushl $130
80106071:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106076:	e9 93 f6 ff ff       	jmp    8010570e <alltraps>

8010607b <vector131>:
.globl vector131
vector131:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $131
8010607d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106082:	e9 87 f6 ff ff       	jmp    8010570e <alltraps>

80106087 <vector132>:
.globl vector132
vector132:
  pushl $0
80106087:	6a 00                	push   $0x0
  pushl $132
80106089:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010608e:	e9 7b f6 ff ff       	jmp    8010570e <alltraps>

80106093 <vector133>:
.globl vector133
vector133:
  pushl $0
80106093:	6a 00                	push   $0x0
  pushl $133
80106095:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010609a:	e9 6f f6 ff ff       	jmp    8010570e <alltraps>

8010609f <vector134>:
.globl vector134
vector134:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $134
801060a1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801060a6:	e9 63 f6 ff ff       	jmp    8010570e <alltraps>

801060ab <vector135>:
.globl vector135
vector135:
  pushl $0
801060ab:	6a 00                	push   $0x0
  pushl $135
801060ad:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801060b2:	e9 57 f6 ff ff       	jmp    8010570e <alltraps>

801060b7 <vector136>:
.globl vector136
vector136:
  pushl $0
801060b7:	6a 00                	push   $0x0
  pushl $136
801060b9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801060be:	e9 4b f6 ff ff       	jmp    8010570e <alltraps>

801060c3 <vector137>:
.globl vector137
vector137:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $137
801060c5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801060ca:	e9 3f f6 ff ff       	jmp    8010570e <alltraps>

801060cf <vector138>:
.globl vector138
vector138:
  pushl $0
801060cf:	6a 00                	push   $0x0
  pushl $138
801060d1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801060d6:	e9 33 f6 ff ff       	jmp    8010570e <alltraps>

801060db <vector139>:
.globl vector139
vector139:
  pushl $0
801060db:	6a 00                	push   $0x0
  pushl $139
801060dd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801060e2:	e9 27 f6 ff ff       	jmp    8010570e <alltraps>

801060e7 <vector140>:
.globl vector140
vector140:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $140
801060e9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801060ee:	e9 1b f6 ff ff       	jmp    8010570e <alltraps>

801060f3 <vector141>:
.globl vector141
vector141:
  pushl $0
801060f3:	6a 00                	push   $0x0
  pushl $141
801060f5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801060fa:	e9 0f f6 ff ff       	jmp    8010570e <alltraps>

801060ff <vector142>:
.globl vector142
vector142:
  pushl $0
801060ff:	6a 00                	push   $0x0
  pushl $142
80106101:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106106:	e9 03 f6 ff ff       	jmp    8010570e <alltraps>

8010610b <vector143>:
.globl vector143
vector143:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $143
8010610d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106112:	e9 f7 f5 ff ff       	jmp    8010570e <alltraps>

80106117 <vector144>:
.globl vector144
vector144:
  pushl $0
80106117:	6a 00                	push   $0x0
  pushl $144
80106119:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010611e:	e9 eb f5 ff ff       	jmp    8010570e <alltraps>

80106123 <vector145>:
.globl vector145
vector145:
  pushl $0
80106123:	6a 00                	push   $0x0
  pushl $145
80106125:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010612a:	e9 df f5 ff ff       	jmp    8010570e <alltraps>

8010612f <vector146>:
.globl vector146
vector146:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $146
80106131:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106136:	e9 d3 f5 ff ff       	jmp    8010570e <alltraps>

8010613b <vector147>:
.globl vector147
vector147:
  pushl $0
8010613b:	6a 00                	push   $0x0
  pushl $147
8010613d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106142:	e9 c7 f5 ff ff       	jmp    8010570e <alltraps>

80106147 <vector148>:
.globl vector148
vector148:
  pushl $0
80106147:	6a 00                	push   $0x0
  pushl $148
80106149:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010614e:	e9 bb f5 ff ff       	jmp    8010570e <alltraps>

80106153 <vector149>:
.globl vector149
vector149:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $149
80106155:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010615a:	e9 af f5 ff ff       	jmp    8010570e <alltraps>

8010615f <vector150>:
.globl vector150
vector150:
  pushl $0
8010615f:	6a 00                	push   $0x0
  pushl $150
80106161:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106166:	e9 a3 f5 ff ff       	jmp    8010570e <alltraps>

8010616b <vector151>:
.globl vector151
vector151:
  pushl $0
8010616b:	6a 00                	push   $0x0
  pushl $151
8010616d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106172:	e9 97 f5 ff ff       	jmp    8010570e <alltraps>

80106177 <vector152>:
.globl vector152
vector152:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $152
80106179:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010617e:	e9 8b f5 ff ff       	jmp    8010570e <alltraps>

80106183 <vector153>:
.globl vector153
vector153:
  pushl $0
80106183:	6a 00                	push   $0x0
  pushl $153
80106185:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010618a:	e9 7f f5 ff ff       	jmp    8010570e <alltraps>

8010618f <vector154>:
.globl vector154
vector154:
  pushl $0
8010618f:	6a 00                	push   $0x0
  pushl $154
80106191:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106196:	e9 73 f5 ff ff       	jmp    8010570e <alltraps>

8010619b <vector155>:
.globl vector155
vector155:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $155
8010619d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801061a2:	e9 67 f5 ff ff       	jmp    8010570e <alltraps>

801061a7 <vector156>:
.globl vector156
vector156:
  pushl $0
801061a7:	6a 00                	push   $0x0
  pushl $156
801061a9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801061ae:	e9 5b f5 ff ff       	jmp    8010570e <alltraps>

801061b3 <vector157>:
.globl vector157
vector157:
  pushl $0
801061b3:	6a 00                	push   $0x0
  pushl $157
801061b5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801061ba:	e9 4f f5 ff ff       	jmp    8010570e <alltraps>

801061bf <vector158>:
.globl vector158
vector158:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $158
801061c1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801061c6:	e9 43 f5 ff ff       	jmp    8010570e <alltraps>

801061cb <vector159>:
.globl vector159
vector159:
  pushl $0
801061cb:	6a 00                	push   $0x0
  pushl $159
801061cd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801061d2:	e9 37 f5 ff ff       	jmp    8010570e <alltraps>

801061d7 <vector160>:
.globl vector160
vector160:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $160
801061d9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801061de:	e9 2b f5 ff ff       	jmp    8010570e <alltraps>

801061e3 <vector161>:
.globl vector161
vector161:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $161
801061e5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801061ea:	e9 1f f5 ff ff       	jmp    8010570e <alltraps>

801061ef <vector162>:
.globl vector162
vector162:
  pushl $0
801061ef:	6a 00                	push   $0x0
  pushl $162
801061f1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801061f6:	e9 13 f5 ff ff       	jmp    8010570e <alltraps>

801061fb <vector163>:
.globl vector163
vector163:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $163
801061fd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106202:	e9 07 f5 ff ff       	jmp    8010570e <alltraps>

80106207 <vector164>:
.globl vector164
vector164:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $164
80106209:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010620e:	e9 fb f4 ff ff       	jmp    8010570e <alltraps>

80106213 <vector165>:
.globl vector165
vector165:
  pushl $0
80106213:	6a 00                	push   $0x0
  pushl $165
80106215:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010621a:	e9 ef f4 ff ff       	jmp    8010570e <alltraps>

8010621f <vector166>:
.globl vector166
vector166:
  pushl $0
8010621f:	6a 00                	push   $0x0
  pushl $166
80106221:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106226:	e9 e3 f4 ff ff       	jmp    8010570e <alltraps>

8010622b <vector167>:
.globl vector167
vector167:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $167
8010622d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106232:	e9 d7 f4 ff ff       	jmp    8010570e <alltraps>

80106237 <vector168>:
.globl vector168
vector168:
  pushl $0
80106237:	6a 00                	push   $0x0
  pushl $168
80106239:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010623e:	e9 cb f4 ff ff       	jmp    8010570e <alltraps>

80106243 <vector169>:
.globl vector169
vector169:
  pushl $0
80106243:	6a 00                	push   $0x0
  pushl $169
80106245:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010624a:	e9 bf f4 ff ff       	jmp    8010570e <alltraps>

8010624f <vector170>:
.globl vector170
vector170:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $170
80106251:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106256:	e9 b3 f4 ff ff       	jmp    8010570e <alltraps>

8010625b <vector171>:
.globl vector171
vector171:
  pushl $0
8010625b:	6a 00                	push   $0x0
  pushl $171
8010625d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106262:	e9 a7 f4 ff ff       	jmp    8010570e <alltraps>

80106267 <vector172>:
.globl vector172
vector172:
  pushl $0
80106267:	6a 00                	push   $0x0
  pushl $172
80106269:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010626e:	e9 9b f4 ff ff       	jmp    8010570e <alltraps>

80106273 <vector173>:
.globl vector173
vector173:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $173
80106275:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010627a:	e9 8f f4 ff ff       	jmp    8010570e <alltraps>

8010627f <vector174>:
.globl vector174
vector174:
  pushl $0
8010627f:	6a 00                	push   $0x0
  pushl $174
80106281:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106286:	e9 83 f4 ff ff       	jmp    8010570e <alltraps>

8010628b <vector175>:
.globl vector175
vector175:
  pushl $0
8010628b:	6a 00                	push   $0x0
  pushl $175
8010628d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106292:	e9 77 f4 ff ff       	jmp    8010570e <alltraps>

80106297 <vector176>:
.globl vector176
vector176:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $176
80106299:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010629e:	e9 6b f4 ff ff       	jmp    8010570e <alltraps>

801062a3 <vector177>:
.globl vector177
vector177:
  pushl $0
801062a3:	6a 00                	push   $0x0
  pushl $177
801062a5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801062aa:	e9 5f f4 ff ff       	jmp    8010570e <alltraps>

801062af <vector178>:
.globl vector178
vector178:
  pushl $0
801062af:	6a 00                	push   $0x0
  pushl $178
801062b1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801062b6:	e9 53 f4 ff ff       	jmp    8010570e <alltraps>

801062bb <vector179>:
.globl vector179
vector179:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $179
801062bd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801062c2:	e9 47 f4 ff ff       	jmp    8010570e <alltraps>

801062c7 <vector180>:
.globl vector180
vector180:
  pushl $0
801062c7:	6a 00                	push   $0x0
  pushl $180
801062c9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801062ce:	e9 3b f4 ff ff       	jmp    8010570e <alltraps>

801062d3 <vector181>:
.globl vector181
vector181:
  pushl $0
801062d3:	6a 00                	push   $0x0
  pushl $181
801062d5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801062da:	e9 2f f4 ff ff       	jmp    8010570e <alltraps>

801062df <vector182>:
.globl vector182
vector182:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $182
801062e1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801062e6:	e9 23 f4 ff ff       	jmp    8010570e <alltraps>

801062eb <vector183>:
.globl vector183
vector183:
  pushl $0
801062eb:	6a 00                	push   $0x0
  pushl $183
801062ed:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801062f2:	e9 17 f4 ff ff       	jmp    8010570e <alltraps>

801062f7 <vector184>:
.globl vector184
vector184:
  pushl $0
801062f7:	6a 00                	push   $0x0
  pushl $184
801062f9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801062fe:	e9 0b f4 ff ff       	jmp    8010570e <alltraps>

80106303 <vector185>:
.globl vector185
vector185:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $185
80106305:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010630a:	e9 ff f3 ff ff       	jmp    8010570e <alltraps>

8010630f <vector186>:
.globl vector186
vector186:
  pushl $0
8010630f:	6a 00                	push   $0x0
  pushl $186
80106311:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106316:	e9 f3 f3 ff ff       	jmp    8010570e <alltraps>

8010631b <vector187>:
.globl vector187
vector187:
  pushl $0
8010631b:	6a 00                	push   $0x0
  pushl $187
8010631d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106322:	e9 e7 f3 ff ff       	jmp    8010570e <alltraps>

80106327 <vector188>:
.globl vector188
vector188:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $188
80106329:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010632e:	e9 db f3 ff ff       	jmp    8010570e <alltraps>

80106333 <vector189>:
.globl vector189
vector189:
  pushl $0
80106333:	6a 00                	push   $0x0
  pushl $189
80106335:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010633a:	e9 cf f3 ff ff       	jmp    8010570e <alltraps>

8010633f <vector190>:
.globl vector190
vector190:
  pushl $0
8010633f:	6a 00                	push   $0x0
  pushl $190
80106341:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106346:	e9 c3 f3 ff ff       	jmp    8010570e <alltraps>

8010634b <vector191>:
.globl vector191
vector191:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $191
8010634d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106352:	e9 b7 f3 ff ff       	jmp    8010570e <alltraps>

80106357 <vector192>:
.globl vector192
vector192:
  pushl $0
80106357:	6a 00                	push   $0x0
  pushl $192
80106359:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010635e:	e9 ab f3 ff ff       	jmp    8010570e <alltraps>

80106363 <vector193>:
.globl vector193
vector193:
  pushl $0
80106363:	6a 00                	push   $0x0
  pushl $193
80106365:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010636a:	e9 9f f3 ff ff       	jmp    8010570e <alltraps>

8010636f <vector194>:
.globl vector194
vector194:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $194
80106371:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106376:	e9 93 f3 ff ff       	jmp    8010570e <alltraps>

8010637b <vector195>:
.globl vector195
vector195:
  pushl $0
8010637b:	6a 00                	push   $0x0
  pushl $195
8010637d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106382:	e9 87 f3 ff ff       	jmp    8010570e <alltraps>

80106387 <vector196>:
.globl vector196
vector196:
  pushl $0
80106387:	6a 00                	push   $0x0
  pushl $196
80106389:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010638e:	e9 7b f3 ff ff       	jmp    8010570e <alltraps>

80106393 <vector197>:
.globl vector197
vector197:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $197
80106395:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010639a:	e9 6f f3 ff ff       	jmp    8010570e <alltraps>

8010639f <vector198>:
.globl vector198
vector198:
  pushl $0
8010639f:	6a 00                	push   $0x0
  pushl $198
801063a1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801063a6:	e9 63 f3 ff ff       	jmp    8010570e <alltraps>

801063ab <vector199>:
.globl vector199
vector199:
  pushl $0
801063ab:	6a 00                	push   $0x0
  pushl $199
801063ad:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801063b2:	e9 57 f3 ff ff       	jmp    8010570e <alltraps>

801063b7 <vector200>:
.globl vector200
vector200:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $200
801063b9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801063be:	e9 4b f3 ff ff       	jmp    8010570e <alltraps>

801063c3 <vector201>:
.globl vector201
vector201:
  pushl $0
801063c3:	6a 00                	push   $0x0
  pushl $201
801063c5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801063ca:	e9 3f f3 ff ff       	jmp    8010570e <alltraps>

801063cf <vector202>:
.globl vector202
vector202:
  pushl $0
801063cf:	6a 00                	push   $0x0
  pushl $202
801063d1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801063d6:	e9 33 f3 ff ff       	jmp    8010570e <alltraps>

801063db <vector203>:
.globl vector203
vector203:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $203
801063dd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801063e2:	e9 27 f3 ff ff       	jmp    8010570e <alltraps>

801063e7 <vector204>:
.globl vector204
vector204:
  pushl $0
801063e7:	6a 00                	push   $0x0
  pushl $204
801063e9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801063ee:	e9 1b f3 ff ff       	jmp    8010570e <alltraps>

801063f3 <vector205>:
.globl vector205
vector205:
  pushl $0
801063f3:	6a 00                	push   $0x0
  pushl $205
801063f5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801063fa:	e9 0f f3 ff ff       	jmp    8010570e <alltraps>

801063ff <vector206>:
.globl vector206
vector206:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $206
80106401:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106406:	e9 03 f3 ff ff       	jmp    8010570e <alltraps>

8010640b <vector207>:
.globl vector207
vector207:
  pushl $0
8010640b:	6a 00                	push   $0x0
  pushl $207
8010640d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106412:	e9 f7 f2 ff ff       	jmp    8010570e <alltraps>

80106417 <vector208>:
.globl vector208
vector208:
  pushl $0
80106417:	6a 00                	push   $0x0
  pushl $208
80106419:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010641e:	e9 eb f2 ff ff       	jmp    8010570e <alltraps>

80106423 <vector209>:
.globl vector209
vector209:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $209
80106425:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010642a:	e9 df f2 ff ff       	jmp    8010570e <alltraps>

8010642f <vector210>:
.globl vector210
vector210:
  pushl $0
8010642f:	6a 00                	push   $0x0
  pushl $210
80106431:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106436:	e9 d3 f2 ff ff       	jmp    8010570e <alltraps>

8010643b <vector211>:
.globl vector211
vector211:
  pushl $0
8010643b:	6a 00                	push   $0x0
  pushl $211
8010643d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106442:	e9 c7 f2 ff ff       	jmp    8010570e <alltraps>

80106447 <vector212>:
.globl vector212
vector212:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $212
80106449:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010644e:	e9 bb f2 ff ff       	jmp    8010570e <alltraps>

80106453 <vector213>:
.globl vector213
vector213:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $213
80106455:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010645a:	e9 af f2 ff ff       	jmp    8010570e <alltraps>

8010645f <vector214>:
.globl vector214
vector214:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $214
80106461:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106466:	e9 a3 f2 ff ff       	jmp    8010570e <alltraps>

8010646b <vector215>:
.globl vector215
vector215:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $215
8010646d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106472:	e9 97 f2 ff ff       	jmp    8010570e <alltraps>

80106477 <vector216>:
.globl vector216
vector216:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $216
80106479:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010647e:	e9 8b f2 ff ff       	jmp    8010570e <alltraps>

80106483 <vector217>:
.globl vector217
vector217:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $217
80106485:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010648a:	e9 7f f2 ff ff       	jmp    8010570e <alltraps>

8010648f <vector218>:
.globl vector218
vector218:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $218
80106491:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106496:	e9 73 f2 ff ff       	jmp    8010570e <alltraps>

8010649b <vector219>:
.globl vector219
vector219:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $219
8010649d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801064a2:	e9 67 f2 ff ff       	jmp    8010570e <alltraps>

801064a7 <vector220>:
.globl vector220
vector220:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $220
801064a9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801064ae:	e9 5b f2 ff ff       	jmp    8010570e <alltraps>

801064b3 <vector221>:
.globl vector221
vector221:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $221
801064b5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801064ba:	e9 4f f2 ff ff       	jmp    8010570e <alltraps>

801064bf <vector222>:
.globl vector222
vector222:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $222
801064c1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801064c6:	e9 43 f2 ff ff       	jmp    8010570e <alltraps>

801064cb <vector223>:
.globl vector223
vector223:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $223
801064cd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801064d2:	e9 37 f2 ff ff       	jmp    8010570e <alltraps>

801064d7 <vector224>:
.globl vector224
vector224:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $224
801064d9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801064de:	e9 2b f2 ff ff       	jmp    8010570e <alltraps>

801064e3 <vector225>:
.globl vector225
vector225:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $225
801064e5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801064ea:	e9 1f f2 ff ff       	jmp    8010570e <alltraps>

801064ef <vector226>:
.globl vector226
vector226:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $226
801064f1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801064f6:	e9 13 f2 ff ff       	jmp    8010570e <alltraps>

801064fb <vector227>:
.globl vector227
vector227:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $227
801064fd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106502:	e9 07 f2 ff ff       	jmp    8010570e <alltraps>

80106507 <vector228>:
.globl vector228
vector228:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $228
80106509:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010650e:	e9 fb f1 ff ff       	jmp    8010570e <alltraps>

80106513 <vector229>:
.globl vector229
vector229:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $229
80106515:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010651a:	e9 ef f1 ff ff       	jmp    8010570e <alltraps>

8010651f <vector230>:
.globl vector230
vector230:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $230
80106521:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106526:	e9 e3 f1 ff ff       	jmp    8010570e <alltraps>

8010652b <vector231>:
.globl vector231
vector231:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $231
8010652d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106532:	e9 d7 f1 ff ff       	jmp    8010570e <alltraps>

80106537 <vector232>:
.globl vector232
vector232:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $232
80106539:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010653e:	e9 cb f1 ff ff       	jmp    8010570e <alltraps>

80106543 <vector233>:
.globl vector233
vector233:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $233
80106545:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010654a:	e9 bf f1 ff ff       	jmp    8010570e <alltraps>

8010654f <vector234>:
.globl vector234
vector234:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $234
80106551:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106556:	e9 b3 f1 ff ff       	jmp    8010570e <alltraps>

8010655b <vector235>:
.globl vector235
vector235:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $235
8010655d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106562:	e9 a7 f1 ff ff       	jmp    8010570e <alltraps>

80106567 <vector236>:
.globl vector236
vector236:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $236
80106569:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010656e:	e9 9b f1 ff ff       	jmp    8010570e <alltraps>

80106573 <vector237>:
.globl vector237
vector237:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $237
80106575:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010657a:	e9 8f f1 ff ff       	jmp    8010570e <alltraps>

8010657f <vector238>:
.globl vector238
vector238:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $238
80106581:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106586:	e9 83 f1 ff ff       	jmp    8010570e <alltraps>

8010658b <vector239>:
.globl vector239
vector239:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $239
8010658d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106592:	e9 77 f1 ff ff       	jmp    8010570e <alltraps>

80106597 <vector240>:
.globl vector240
vector240:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $240
80106599:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010659e:	e9 6b f1 ff ff       	jmp    8010570e <alltraps>

801065a3 <vector241>:
.globl vector241
vector241:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $241
801065a5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801065aa:	e9 5f f1 ff ff       	jmp    8010570e <alltraps>

801065af <vector242>:
.globl vector242
vector242:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $242
801065b1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801065b6:	e9 53 f1 ff ff       	jmp    8010570e <alltraps>

801065bb <vector243>:
.globl vector243
vector243:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $243
801065bd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801065c2:	e9 47 f1 ff ff       	jmp    8010570e <alltraps>

801065c7 <vector244>:
.globl vector244
vector244:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $244
801065c9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801065ce:	e9 3b f1 ff ff       	jmp    8010570e <alltraps>

801065d3 <vector245>:
.globl vector245
vector245:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $245
801065d5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801065da:	e9 2f f1 ff ff       	jmp    8010570e <alltraps>

801065df <vector246>:
.globl vector246
vector246:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $246
801065e1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801065e6:	e9 23 f1 ff ff       	jmp    8010570e <alltraps>

801065eb <vector247>:
.globl vector247
vector247:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $247
801065ed:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801065f2:	e9 17 f1 ff ff       	jmp    8010570e <alltraps>

801065f7 <vector248>:
.globl vector248
vector248:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $248
801065f9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801065fe:	e9 0b f1 ff ff       	jmp    8010570e <alltraps>

80106603 <vector249>:
.globl vector249
vector249:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $249
80106605:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010660a:	e9 ff f0 ff ff       	jmp    8010570e <alltraps>

8010660f <vector250>:
.globl vector250
vector250:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $250
80106611:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106616:	e9 f3 f0 ff ff       	jmp    8010570e <alltraps>

8010661b <vector251>:
.globl vector251
vector251:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $251
8010661d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106622:	e9 e7 f0 ff ff       	jmp    8010570e <alltraps>

80106627 <vector252>:
.globl vector252
vector252:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $252
80106629:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010662e:	e9 db f0 ff ff       	jmp    8010570e <alltraps>

80106633 <vector253>:
.globl vector253
vector253:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $253
80106635:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010663a:	e9 cf f0 ff ff       	jmp    8010570e <alltraps>

8010663f <vector254>:
.globl vector254
vector254:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $254
80106641:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106646:	e9 c3 f0 ff ff       	jmp    8010570e <alltraps>

8010664b <vector255>:
.globl vector255
vector255:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $255
8010664d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106652:	e9 b7 f0 ff ff       	jmp    8010570e <alltraps>
80106657:	66 90                	xchg   %ax,%ax
80106659:	66 90                	xchg   %ax,%ax
8010665b:	66 90                	xchg   %ax,%ax
8010665d:	66 90                	xchg   %ax,%ax
8010665f:	90                   	nop

80106660 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
80106663:	57                   	push   %edi
80106664:	56                   	push   %esi
80106665:	53                   	push   %ebx
80106666:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106668:	c1 ea 16             	shr    $0x16,%edx
8010666b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010666e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106671:	8b 07                	mov    (%edi),%eax
80106673:	a8 01                	test   $0x1,%al
80106675:	74 29                	je     801066a0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106677:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010667c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106682:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106685:	c1 eb 0a             	shr    $0xa,%ebx
80106688:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010668e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106691:	5b                   	pop    %ebx
80106692:	5e                   	pop    %esi
80106693:	5f                   	pop    %edi
80106694:	5d                   	pop    %ebp
80106695:	c3                   	ret    
80106696:	8d 76 00             	lea    0x0(%esi),%esi
80106699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801066a0:	85 c9                	test   %ecx,%ecx
801066a2:	74 2c                	je     801066d0 <walkpgdir+0x70>
801066a4:	e8 d7 be ff ff       	call   80102580 <kalloc>
801066a9:	85 c0                	test   %eax,%eax
801066ab:	89 c6                	mov    %eax,%esi
801066ad:	74 21                	je     801066d0 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801066af:	83 ec 04             	sub    $0x4,%esp
801066b2:	68 00 10 00 00       	push   $0x1000
801066b7:	6a 00                	push   $0x0
801066b9:	50                   	push   %eax
801066ba:	e8 21 de ff ff       	call   801044e0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801066bf:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801066c5:	83 c4 10             	add    $0x10,%esp
801066c8:	83 c8 07             	or     $0x7,%eax
801066cb:	89 07                	mov    %eax,(%edi)
801066cd:	eb b3                	jmp    80106682 <walkpgdir+0x22>
801066cf:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
801066d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801066d3:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801066d5:	5b                   	pop    %ebx
801066d6:	5e                   	pop    %esi
801066d7:	5f                   	pop    %edi
801066d8:	5d                   	pop    %ebp
801066d9:	c3                   	ret    
801066da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801066e0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801066e0:	55                   	push   %ebp
801066e1:	89 e5                	mov    %esp,%ebp
801066e3:	57                   	push   %edi
801066e4:	56                   	push   %esi
801066e5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801066e6:	89 d3                	mov    %edx,%ebx
801066e8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801066ee:	83 ec 1c             	sub    $0x1c,%esp
801066f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801066f4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801066f8:	8b 7d 08             	mov    0x8(%ebp),%edi
801066fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106700:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106703:	8b 45 0c             	mov    0xc(%ebp),%eax
80106706:	29 df                	sub    %ebx,%edi
80106708:	83 c8 01             	or     $0x1,%eax
8010670b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010670e:	eb 15                	jmp    80106725 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106710:	f6 00 01             	testb  $0x1,(%eax)
80106713:	75 45                	jne    8010675a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106715:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106718:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010671b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010671d:	74 31                	je     80106750 <mappages+0x70>
      break;
    a += PGSIZE;
8010671f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106725:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106728:	b9 01 00 00 00       	mov    $0x1,%ecx
8010672d:	89 da                	mov    %ebx,%edx
8010672f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106732:	e8 29 ff ff ff       	call   80106660 <walkpgdir>
80106737:	85 c0                	test   %eax,%eax
80106739:	75 d5                	jne    80106710 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010673b:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010673e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106743:	5b                   	pop    %ebx
80106744:	5e                   	pop    %esi
80106745:	5f                   	pop    %edi
80106746:	5d                   	pop    %ebp
80106747:	c3                   	ret    
80106748:	90                   	nop
80106749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106750:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106753:	31 c0                	xor    %eax,%eax
}
80106755:	5b                   	pop    %ebx
80106756:	5e                   	pop    %esi
80106757:	5f                   	pop    %edi
80106758:	5d                   	pop    %ebp
80106759:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010675a:	83 ec 0c             	sub    $0xc,%esp
8010675d:	68 48 78 10 80       	push   $0x80107848
80106762:	e8 e9 9b ff ff       	call   80100350 <panic>
80106767:	89 f6                	mov    %esi,%esi
80106769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106770 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106770:	55                   	push   %ebp
80106771:	89 e5                	mov    %esp,%ebp
80106773:	57                   	push   %edi
80106774:	56                   	push   %esi
80106775:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106776:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010677c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010677e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106784:	83 ec 1c             	sub    $0x1c,%esp
80106787:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010678a:	39 d3                	cmp    %edx,%ebx
8010678c:	73 60                	jae    801067ee <deallocuvm.part.0+0x7e>
8010678e:	89 d6                	mov    %edx,%esi
80106790:	eb 3d                	jmp    801067cf <deallocuvm.part.0+0x5f>
80106792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
80106798:	8b 10                	mov    (%eax),%edx
8010679a:	f6 c2 01             	test   $0x1,%dl
8010679d:	74 26                	je     801067c5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010679f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801067a5:	74 52                	je     801067f9 <deallocuvm.part.0+0x89>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801067a7:	83 ec 0c             	sub    $0xc,%esp
801067aa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801067b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801067b3:	52                   	push   %edx
801067b4:	e8 17 bc ff ff       	call   801023d0 <kfree>
      *pte = 0;
801067b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067bc:	83 c4 10             	add    $0x10,%esp
801067bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801067c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067cb:	39 f3                	cmp    %esi,%ebx
801067cd:	73 1f                	jae    801067ee <deallocuvm.part.0+0x7e>
    pte = walkpgdir(pgdir, (char*)a, 0);
801067cf:	31 c9                	xor    %ecx,%ecx
801067d1:	89 da                	mov    %ebx,%edx
801067d3:	89 f8                	mov    %edi,%eax
801067d5:	e8 86 fe ff ff       	call   80106660 <walkpgdir>
    if(!pte)
801067da:	85 c0                	test   %eax,%eax
801067dc:	75 ba                	jne    80106798 <deallocuvm.part.0+0x28>
      a += (NPTENTRIES - 1) * PGSIZE;
801067de:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801067e4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067ea:	39 f3                	cmp    %esi,%ebx
801067ec:	72 e1                	jb     801067cf <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801067ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
801067f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067f4:	5b                   	pop    %ebx
801067f5:	5e                   	pop    %esi
801067f6:	5f                   	pop    %edi
801067f7:	5d                   	pop    %ebp
801067f8:	c3                   	ret    
    if(!pte)
      a += (NPTENTRIES - 1) * PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801067f9:	83 ec 0c             	sub    $0xc,%esp
801067fc:	68 fa 71 10 80       	push   $0x801071fa
80106801:	e8 4a 9b ff ff       	call   80100350 <panic>
80106806:	8d 76 00             	lea    0x0(%esi),%esi
80106809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106810 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106810:	55                   	push   %ebp
80106811:	89 e5                	mov    %esp,%ebp
80106813:	53                   	push   %ebx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106814:	31 db                	xor    %ebx,%ebx

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106816:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106819:	e8 c2 bf ff ff       	call   801027e0 <cpunum>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010681e:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80106824:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80106829:	8d 90 e0 12 11 80    	lea    -0x7feeed20(%eax),%edx
8010682f:	c6 80 5d 13 11 80 9a 	movb   $0x9a,-0x7feeeca3(%eax)
80106836:	c6 80 5e 13 11 80 cf 	movb   $0xcf,-0x7feeeca2(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010683d:	c6 80 65 13 11 80 92 	movb   $0x92,-0x7feeec9b(%eax)
80106844:	c6 80 66 13 11 80 cf 	movb   $0xcf,-0x7feeec9a(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010684b:	66 89 4a 78          	mov    %cx,0x78(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010684f:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106854:	66 89 5a 7a          	mov    %bx,0x7a(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106858:	66 89 8a 80 00 00 00 	mov    %cx,0x80(%edx)
8010685f:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106861:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106866:	66 89 9a 82 00 00 00 	mov    %bx,0x82(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010686d:	66 89 8a 90 00 00 00 	mov    %cx,0x90(%edx)
80106874:	31 db                	xor    %ebx,%ebx
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106876:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010687b:	66 89 9a 92 00 00 00 	mov    %bx,0x92(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106882:	31 db                	xor    %ebx,%ebx
80106884:	66 89 8a 98 00 00 00 	mov    %cx,0x98(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010688b:	8d 88 94 13 11 80    	lea    -0x7feeec6c(%eax),%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106891:	66 89 9a 9a 00 00 00 	mov    %bx,0x9a(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106898:	31 db                	xor    %ebx,%ebx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010689a:	c6 80 75 13 11 80 fa 	movb   $0xfa,-0x7feeec8b(%eax)
801068a1:	c6 80 76 13 11 80 cf 	movb   $0xcf,-0x7feeec8a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801068a8:	66 89 9a 88 00 00 00 	mov    %bx,0x88(%edx)
801068af:	66 89 8a 8a 00 00 00 	mov    %cx,0x8a(%edx)
801068b6:	89 cb                	mov    %ecx,%ebx
801068b8:	c1 e9 18             	shr    $0x18,%ecx
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068bb:	c6 80 7d 13 11 80 f2 	movb   $0xf2,-0x7feeec83(%eax)
801068c2:	c6 80 7e 13 11 80 cf 	movb   $0xcf,-0x7feeec82(%eax)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801068c9:	88 8a 8f 00 00 00    	mov    %cl,0x8f(%edx)
801068cf:	c6 80 6d 13 11 80 92 	movb   $0x92,-0x7feeec93(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801068d6:	b9 37 00 00 00       	mov    $0x37,%ecx
801068db:	c6 80 6e 13 11 80 c0 	movb   $0xc0,-0x7feeec92(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
801068e2:	05 50 13 11 80       	add    $0x80111350,%eax
801068e7:	66 89 4d f2          	mov    %cx,-0xe(%ebp)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
801068eb:	c1 eb 10             	shr    $0x10,%ebx
  pd[1] = (uint)p;
801068ee:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801068f2:	c1 e8 10             	shr    $0x10,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801068f5:	c6 42 7c 00          	movb   $0x0,0x7c(%edx)
801068f9:	c6 42 7f 00          	movb   $0x0,0x7f(%edx)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801068fd:	c6 82 84 00 00 00 00 	movb   $0x0,0x84(%edx)
80106904:	c6 82 87 00 00 00 00 	movb   $0x0,0x87(%edx)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010690b:	c6 82 94 00 00 00 00 	movb   $0x0,0x94(%edx)
80106912:	c6 82 97 00 00 00 00 	movb   $0x0,0x97(%edx)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106919:	c6 82 9c 00 00 00 00 	movb   $0x0,0x9c(%edx)
80106920:	c6 82 9f 00 00 00 00 	movb   $0x0,0x9f(%edx)

  // Map cpu and proc -- these are private per cpu.
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80106927:	88 9a 8c 00 00 00    	mov    %bl,0x8c(%edx)
8010692d:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106931:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106934:	0f 01 10             	lgdtl  (%eax)
}

static inline void
loadgs(ushort v)
{
  asm volatile("movw %0, %%gs" : : "r" (v));
80106937:	b8 18 00 00 00       	mov    $0x18,%eax
8010693c:	8e e8                	mov    %eax,%gs
  lgdt(c->gdt, sizeof(c->gdt));
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
8010693e:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80106945:	00 00 00 00 

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80106949:	65 89 15 00 00 00 00 	mov    %edx,%gs:0x0
  loadgs(SEG_KCPU << 3);

  // Initialize cpu-local storage.
  cpu = c;
  proc = 0;
}
80106950:	83 c4 14             	add    $0x14,%esp
80106953:	5b                   	pop    %ebx
80106954:	5d                   	pop    %ebp
80106955:	c3                   	ret    
80106956:	8d 76 00             	lea    0x0(%esi),%esi
80106959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106960 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106960:	55                   	push   %ebp
80106961:	89 e5                	mov    %esp,%ebp
80106963:	56                   	push   %esi
80106964:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106965:	e8 16 bc ff ff       	call   80102580 <kalloc>
8010696a:	85 c0                	test   %eax,%eax
8010696c:	74 52                	je     801069c0 <setupkvm+0x60>
    return 0;
  memset(pgdir, 0, PGSIZE);
8010696e:	83 ec 04             	sub    $0x4,%esp
80106971:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106973:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106978:	68 00 10 00 00       	push   $0x1000
8010697d:	6a 00                	push   $0x0
8010697f:	50                   	push   %eax
80106980:	e8 5b db ff ff       	call   801044e0 <memset>
80106985:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106988:	8b 43 04             	mov    0x4(%ebx),%eax
8010698b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010698e:	83 ec 08             	sub    $0x8,%esp
80106991:	8b 13                	mov    (%ebx),%edx
80106993:	ff 73 0c             	pushl  0xc(%ebx)
80106996:	50                   	push   %eax
80106997:	29 c1                	sub    %eax,%ecx
80106999:	89 f0                	mov    %esi,%eax
8010699b:	e8 40 fd ff ff       	call   801066e0 <mappages>
801069a0:	83 c4 10             	add    $0x10,%esp
801069a3:	85 c0                	test   %eax,%eax
801069a5:	78 19                	js     801069c0 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801069a7:	83 c3 10             	add    $0x10,%ebx
801069aa:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801069b0:	75 d6                	jne    80106988 <setupkvm+0x28>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
801069b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801069b5:	89 f0                	mov    %esi,%eax
801069b7:	5b                   	pop    %ebx
801069b8:	5e                   	pop    %esi
801069b9:	5d                   	pop    %ebp
801069ba:	c3                   	ret    
801069bb:	90                   	nop
801069bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801069c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
801069c3:	31 c0                	xor    %eax,%eax
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
}
801069c5:	5b                   	pop    %ebx
801069c6:	5e                   	pop    %esi
801069c7:	5d                   	pop    %ebp
801069c8:	c3                   	ret    
801069c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069d0 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801069d6:	e8 85 ff ff ff       	call   80106960 <setupkvm>
801069db:	a3 64 41 11 80       	mov    %eax,0x80114164
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069e0:	05 00 00 00 80       	add    $0x80000000,%eax
801069e5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
801069e8:	c9                   	leave  
801069e9:	c3                   	ret    
801069ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801069f0 <switchkvm>:
801069f0:	a1 64 41 11 80       	mov    0x80114164,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801069f5:	55                   	push   %ebp
801069f6:	89 e5                	mov    %esp,%ebp
801069f8:	05 00 00 00 80       	add    $0x80000000,%eax
801069fd:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106a00:	5d                   	pop    %ebp
80106a01:	c3                   	ret    
80106a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a10 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106a10:	55                   	push   %ebp
80106a11:	89 e5                	mov    %esp,%ebp
80106a13:	53                   	push   %ebx
80106a14:	83 ec 04             	sub    $0x4,%esp
80106a17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80106a1a:	e8 f1 d9 ff ff       	call   80104410 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106a1f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a25:	b9 67 00 00 00       	mov    $0x67,%ecx
80106a2a:	8d 50 08             	lea    0x8(%eax),%edx
80106a2d:	66 89 88 a0 00 00 00 	mov    %cx,0xa0(%eax)
80106a34:	c6 80 a6 00 00 00 40 	movb   $0x40,0xa6(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80106a3b:	c6 80 a5 00 00 00 89 	movb   $0x89,0xa5(%eax)
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106a42:	66 89 90 a2 00 00 00 	mov    %dx,0xa2(%eax)
80106a49:	89 d1                	mov    %edx,%ecx
80106a4b:	c1 ea 18             	shr    $0x18,%edx
80106a4e:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106a54:	ba 10 00 00 00       	mov    $0x10,%edx
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106a59:	c1 e9 10             	shr    $0x10,%ecx
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
80106a5c:	66 89 50 10          	mov    %dx,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106a60:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80106a67:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106a6d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106a72:	8b 52 0c             	mov    0xc(%edx),%edx
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
80106a75:	66 89 48 6e          	mov    %cx,0x6e(%eax)
{
  pushcli();
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
  cpu->gdt[SEG_TSS].s = 0;
  cpu->ts.ss0 = SEG_KDATA << 3;
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80106a79:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106a7f:	89 50 0c             	mov    %edx,0xc(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106a82:	b8 30 00 00 00       	mov    $0x30,%eax
80106a87:	0f 00 d8             	ltr    %ax
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
80106a8a:	8b 43 08             	mov    0x8(%ebx),%eax
80106a8d:	85 c0                	test   %eax,%eax
80106a8f:	74 11                	je     80106aa2 <switchuvm+0x92>
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a91:	05 00 00 00 80       	add    $0x80000000,%eax
80106a96:	0f 22 d8             	mov    %eax,%cr3
    panic("switchuvm: no pgdir");
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106a99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106a9c:	c9                   	leave  
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106a9d:	e9 9e d9 ff ff       	jmp    80104440 <popcli>
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  cpu->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106aa2:	83 ec 0c             	sub    $0xc,%esp
80106aa5:	68 4e 78 10 80       	push   $0x8010784e
80106aaa:	e8 a1 98 ff ff       	call   80100350 <panic>
80106aaf:	90                   	nop

80106ab0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	57                   	push   %edi
80106ab4:	56                   	push   %esi
80106ab5:	53                   	push   %ebx
80106ab6:	83 ec 1c             	sub    $0x1c,%esp
80106ab9:	8b 75 10             	mov    0x10(%ebp),%esi
80106abc:	8b 45 08             	mov    0x8(%ebp),%eax
80106abf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106ac2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ac8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106acb:	77 49                	ja     80106b16 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106acd:	e8 ae ba ff ff       	call   80102580 <kalloc>
  memset(mem, 0, PGSIZE);
80106ad2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106ad5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ad7:	68 00 10 00 00       	push   $0x1000
80106adc:	6a 00                	push   $0x0
80106ade:	50                   	push   %eax
80106adf:	e8 fc d9 ff ff       	call   801044e0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106ae4:	58                   	pop    %eax
80106ae5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106aeb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106af0:	5a                   	pop    %edx
80106af1:	6a 06                	push   $0x6
80106af3:	50                   	push   %eax
80106af4:	31 d2                	xor    %edx,%edx
80106af6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106af9:	e8 e2 fb ff ff       	call   801066e0 <mappages>
  memmove(mem, init, sz);
80106afe:	89 75 10             	mov    %esi,0x10(%ebp)
80106b01:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106b04:	83 c4 10             	add    $0x10,%esp
80106b07:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106b0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b0d:	5b                   	pop    %ebx
80106b0e:	5e                   	pop    %esi
80106b0f:	5f                   	pop    %edi
80106b10:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106b11:	e9 7a da ff ff       	jmp    80104590 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106b16:	83 ec 0c             	sub    $0xc,%esp
80106b19:	68 62 78 10 80       	push   $0x80107862
80106b1e:	e8 2d 98 ff ff       	call   80100350 <panic>
80106b23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b30 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	57                   	push   %edi
80106b34:	56                   	push   %esi
80106b35:	53                   	push   %ebx
80106b36:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106b39:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106b40:	0f 85 91 00 00 00    	jne    80106bd7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106b46:	8b 75 18             	mov    0x18(%ebp),%esi
80106b49:	31 db                	xor    %ebx,%ebx
80106b4b:	85 f6                	test   %esi,%esi
80106b4d:	75 1a                	jne    80106b69 <loaduvm+0x39>
80106b4f:	eb 6f                	jmp    80106bc0 <loaduvm+0x90>
80106b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b58:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b5e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106b64:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106b67:	76 57                	jbe    80106bc0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106b69:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b6c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b6f:	31 c9                	xor    %ecx,%ecx
80106b71:	01 da                	add    %ebx,%edx
80106b73:	e8 e8 fa ff ff       	call   80106660 <walkpgdir>
80106b78:	85 c0                	test   %eax,%eax
80106b7a:	74 4e                	je     80106bca <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106b7c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b7e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106b81:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106b86:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106b8b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b91:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b94:	01 d9                	add    %ebx,%ecx
80106b96:	05 00 00 00 80       	add    $0x80000000,%eax
80106b9b:	57                   	push   %edi
80106b9c:	51                   	push   %ecx
80106b9d:	50                   	push   %eax
80106b9e:	ff 75 10             	pushl  0x10(%ebp)
80106ba1:	e8 8a ae ff ff       	call   80101a30 <readi>
80106ba6:	83 c4 10             	add    $0x10,%esp
80106ba9:	39 c7                	cmp    %eax,%edi
80106bab:	74 ab                	je     80106b58 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106bad:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106bb5:	5b                   	pop    %ebx
80106bb6:	5e                   	pop    %esi
80106bb7:	5f                   	pop    %edi
80106bb8:	5d                   	pop    %ebp
80106bb9:	c3                   	ret    
80106bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106bc3:	31 c0                	xor    %eax,%eax
}
80106bc5:	5b                   	pop    %ebx
80106bc6:	5e                   	pop    %esi
80106bc7:	5f                   	pop    %edi
80106bc8:	5d                   	pop    %ebp
80106bc9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106bca:	83 ec 0c             	sub    $0xc,%esp
80106bcd:	68 7c 78 10 80       	push   $0x8010787c
80106bd2:	e8 79 97 ff ff       	call   80100350 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106bd7:	83 ec 0c             	sub    $0xc,%esp
80106bda:	68 20 79 10 80       	push   $0x80107920
80106bdf:	e8 6c 97 ff ff       	call   80100350 <panic>
80106be4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106bf0 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
80106bf6:	83 ec 0c             	sub    $0xc,%esp
80106bf9:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106bfc:	85 ff                	test   %edi,%edi
80106bfe:	0f 88 ca 00 00 00    	js     80106cce <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106c04:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106c0a:	0f 82 82 00 00 00    	jb     80106c92 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106c10:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c16:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106c1c:	39 df                	cmp    %ebx,%edi
80106c1e:	77 43                	ja     80106c63 <allocuvm+0x73>
80106c20:	e9 bb 00 00 00       	jmp    80106ce0 <allocuvm+0xf0>
80106c25:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106c28:	83 ec 04             	sub    $0x4,%esp
80106c2b:	68 00 10 00 00       	push   $0x1000
80106c30:	6a 00                	push   $0x0
80106c32:	50                   	push   %eax
80106c33:	e8 a8 d8 ff ff       	call   801044e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c38:	58                   	pop    %eax
80106c39:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106c3f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c44:	5a                   	pop    %edx
80106c45:	6a 06                	push   $0x6
80106c47:	50                   	push   %eax
80106c48:	89 da                	mov    %ebx,%edx
80106c4a:	8b 45 08             	mov    0x8(%ebp),%eax
80106c4d:	e8 8e fa ff ff       	call   801066e0 <mappages>
80106c52:	83 c4 10             	add    $0x10,%esp
80106c55:	85 c0                	test   %eax,%eax
80106c57:	78 47                	js     80106ca0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106c59:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c5f:	39 df                	cmp    %ebx,%edi
80106c61:	76 7d                	jbe    80106ce0 <allocuvm+0xf0>
    mem = kalloc();
80106c63:	e8 18 b9 ff ff       	call   80102580 <kalloc>
    if(mem == 0){
80106c68:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106c6a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106c6c:	75 ba                	jne    80106c28 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106c6e:	83 ec 0c             	sub    $0xc,%esp
80106c71:	68 9a 78 10 80       	push   $0x8010789a
80106c76:	e8 c5 99 ff ff       	call   80100640 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c7b:	83 c4 10             	add    $0x10,%esp
80106c7e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106c81:	76 4b                	jbe    80106cce <allocuvm+0xde>
80106c83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c86:	8b 45 08             	mov    0x8(%ebp),%eax
80106c89:	89 fa                	mov    %edi,%edx
80106c8b:	e8 e0 fa ff ff       	call   80106770 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106c90:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106c92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c95:	5b                   	pop    %ebx
80106c96:	5e                   	pop    %esi
80106c97:	5f                   	pop    %edi
80106c98:	5d                   	pop    %ebp
80106c99:	c3                   	ret    
80106c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106ca0:	83 ec 0c             	sub    $0xc,%esp
80106ca3:	68 b2 78 10 80       	push   $0x801078b2
80106ca8:	e8 93 99 ff ff       	call   80100640 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106cad:	83 c4 10             	add    $0x10,%esp
80106cb0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106cb3:	76 0d                	jbe    80106cc2 <allocuvm+0xd2>
80106cb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106cb8:	8b 45 08             	mov    0x8(%ebp),%eax
80106cbb:	89 fa                	mov    %edi,%edx
80106cbd:	e8 ae fa ff ff       	call   80106770 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106cc2:	83 ec 0c             	sub    $0xc,%esp
80106cc5:	56                   	push   %esi
80106cc6:	e8 05 b7 ff ff       	call   801023d0 <kfree>
      return 0;
80106ccb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106cce:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106cd1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106cd3:	5b                   	pop    %ebx
80106cd4:	5e                   	pop    %esi
80106cd5:	5f                   	pop    %edi
80106cd6:	5d                   	pop    %ebp
80106cd7:	c3                   	ret    
80106cd8:	90                   	nop
80106cd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106ce3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106ce5:	5b                   	pop    %ebx
80106ce6:	5e                   	pop    %esi
80106ce7:	5f                   	pop    %edi
80106ce8:	5d                   	pop    %ebp
80106ce9:	c3                   	ret    
80106cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cf0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106cf0:	55                   	push   %ebp
80106cf1:	89 e5                	mov    %esp,%ebp
80106cf3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cf6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106cfc:	39 d1                	cmp    %edx,%ecx
80106cfe:	73 10                	jae    80106d10 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d00:	5d                   	pop    %ebp
80106d01:	e9 6a fa ff ff       	jmp    80106770 <deallocuvm.part.0>
80106d06:	8d 76 00             	lea    0x0(%esi),%esi
80106d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106d10:	89 d0                	mov    %edx,%eax
80106d12:	5d                   	pop    %ebp
80106d13:	c3                   	ret    
80106d14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d20 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
80106d26:	83 ec 0c             	sub    $0xc,%esp
80106d29:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d2c:	85 f6                	test   %esi,%esi
80106d2e:	74 59                	je     80106d89 <freevm+0x69>
80106d30:	31 c9                	xor    %ecx,%ecx
80106d32:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d37:	89 f0                	mov    %esi,%eax
80106d39:	e8 32 fa ff ff       	call   80106770 <deallocuvm.part.0>
80106d3e:	89 f3                	mov    %esi,%ebx
80106d40:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106d46:	eb 0f                	jmp    80106d57 <freevm+0x37>
80106d48:	90                   	nop
80106d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d50:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d53:	39 fb                	cmp    %edi,%ebx
80106d55:	74 23                	je     80106d7a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106d57:	8b 03                	mov    (%ebx),%eax
80106d59:	a8 01                	test   $0x1,%al
80106d5b:	74 f3                	je     80106d50 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106d5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d62:	83 ec 0c             	sub    $0xc,%esp
80106d65:	83 c3 04             	add    $0x4,%ebx
80106d68:	05 00 00 00 80       	add    $0x80000000,%eax
80106d6d:	50                   	push   %eax
80106d6e:	e8 5d b6 ff ff       	call   801023d0 <kfree>
80106d73:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d76:	39 fb                	cmp    %edi,%ebx
80106d78:	75 dd                	jne    80106d57 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106d7a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d80:	5b                   	pop    %ebx
80106d81:	5e                   	pop    %esi
80106d82:	5f                   	pop    %edi
80106d83:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106d84:	e9 47 b6 ff ff       	jmp    801023d0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106d89:	83 ec 0c             	sub    $0xc,%esp
80106d8c:	68 ce 78 10 80       	push   $0x801078ce
80106d91:	e8 ba 95 ff ff       	call   80100350 <panic>
80106d96:	8d 76 00             	lea    0x0(%esi),%esi
80106d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106da0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106da0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106da1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106da3:	89 e5                	mov    %esp,%ebp
80106da5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106da8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dab:	8b 45 08             	mov    0x8(%ebp),%eax
80106dae:	e8 ad f8 ff ff       	call   80106660 <walkpgdir>
  if(pte == 0)
80106db3:	85 c0                	test   %eax,%eax
80106db5:	74 05                	je     80106dbc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106db7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106dba:	c9                   	leave  
80106dbb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106dbc:	83 ec 0c             	sub    $0xc,%esp
80106dbf:	68 df 78 10 80       	push   $0x801078df
80106dc4:	e8 87 95 ff ff       	call   80100350 <panic>
80106dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106dd0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106dd9:	e8 82 fb ff ff       	call   80106960 <setupkvm>
80106dde:	85 c0                	test   %eax,%eax
80106de0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106de3:	0f 84 b2 00 00 00    	je     80106e9b <copyuvm+0xcb>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106dec:	85 c9                	test   %ecx,%ecx
80106dee:	0f 84 9c 00 00 00    	je     80106e90 <copyuvm+0xc0>
80106df4:	31 f6                	xor    %esi,%esi
80106df6:	eb 4a                	jmp    80106e42 <copyuvm+0x72>
80106df8:	90                   	nop
80106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e00:	83 ec 04             	sub    $0x4,%esp
80106e03:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106e09:	68 00 10 00 00       	push   $0x1000
80106e0e:	57                   	push   %edi
80106e0f:	50                   	push   %eax
80106e10:	e8 7b d7 ff ff       	call   80104590 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106e15:	58                   	pop    %eax
80106e16:	5a                   	pop    %edx
80106e17:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80106e1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e20:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e23:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e28:	52                   	push   %edx
80106e29:	89 f2                	mov    %esi,%edx
80106e2b:	e8 b0 f8 ff ff       	call   801066e0 <mappages>
80106e30:	83 c4 10             	add    $0x10,%esp
80106e33:	85 c0                	test   %eax,%eax
80106e35:	78 3e                	js     80106e75 <copyuvm+0xa5>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e37:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106e3d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106e40:	76 4e                	jbe    80106e90 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e42:	8b 45 08             	mov    0x8(%ebp),%eax
80106e45:	31 c9                	xor    %ecx,%ecx
80106e47:	89 f2                	mov    %esi,%edx
80106e49:	e8 12 f8 ff ff       	call   80106660 <walkpgdir>
80106e4e:	85 c0                	test   %eax,%eax
80106e50:	74 5a                	je     80106eac <copyuvm+0xdc>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106e52:	8b 18                	mov    (%eax),%ebx
80106e54:	f6 c3 01             	test   $0x1,%bl
80106e57:	74 46                	je     80106e9f <copyuvm+0xcf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106e59:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106e5b:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106e61:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106e64:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106e6a:	e8 11 b7 ff ff       	call   80102580 <kalloc>
80106e6f:	85 c0                	test   %eax,%eax
80106e71:	89 c3                	mov    %eax,%ebx
80106e73:	75 8b                	jne    80106e00 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106e75:	83 ec 0c             	sub    $0xc,%esp
80106e78:	ff 75 e0             	pushl  -0x20(%ebp)
80106e7b:	e8 a0 fe ff ff       	call   80106d20 <freevm>
  return 0;
80106e80:	83 c4 10             	add    $0x10,%esp
80106e83:	31 c0                	xor    %eax,%eax
}
80106e85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e88:	5b                   	pop    %ebx
80106e89:	5e                   	pop    %esi
80106e8a:	5f                   	pop    %edi
80106e8b:	5d                   	pop    %ebp
80106e8c:	c3                   	ret    
80106e8d:	8d 76 00             	lea    0x0(%esi),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106e93:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e96:	5b                   	pop    %ebx
80106e97:	5e                   	pop    %esi
80106e98:	5f                   	pop    %edi
80106e99:	5d                   	pop    %ebp
80106e9a:	c3                   	ret    
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106e9b:	31 c0                	xor    %eax,%eax
80106e9d:	eb e6                	jmp    80106e85 <copyuvm+0xb5>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106e9f:	83 ec 0c             	sub    $0xc,%esp
80106ea2:	68 03 79 10 80       	push   $0x80107903
80106ea7:	e8 a4 94 ff ff       	call   80100350 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106eac:	83 ec 0c             	sub    $0xc,%esp
80106eaf:	68 e9 78 10 80       	push   $0x801078e9
80106eb4:	e8 97 94 ff ff       	call   80100350 <panic>
80106eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ec0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106ec0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ec1:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106ec3:	89 e5                	mov    %esp,%ebp
80106ec5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ec8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ecb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ece:	e8 8d f7 ff ff       	call   80106660 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106ed3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106ed5:	89 c2                	mov    %eax,%edx
80106ed7:	83 e2 05             	and    $0x5,%edx
80106eda:	83 fa 05             	cmp    $0x5,%edx
80106edd:	75 11                	jne    80106ef0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106edf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80106ee4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106ee5:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106eea:	c3                   	ret    
80106eeb:	90                   	nop
80106eec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106ef0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106ef2:	c9                   	leave  
80106ef3:	c3                   	ret    
80106ef4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106efa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f00 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	83 ec 1c             	sub    $0x1c,%esp
80106f09:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106f0c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f0f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f12:	85 db                	test   %ebx,%ebx
80106f14:	75 40                	jne    80106f56 <copyout+0x56>
80106f16:	eb 70                	jmp    80106f88 <copyout+0x88>
80106f18:	90                   	nop
80106f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106f20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f23:	89 f1                	mov    %esi,%ecx
80106f25:	29 d1                	sub    %edx,%ecx
80106f27:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106f2d:	39 d9                	cmp    %ebx,%ecx
80106f2f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f32:	29 f2                	sub    %esi,%edx
80106f34:	83 ec 04             	sub    $0x4,%esp
80106f37:	01 d0                	add    %edx,%eax
80106f39:	51                   	push   %ecx
80106f3a:	57                   	push   %edi
80106f3b:	50                   	push   %eax
80106f3c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106f3f:	e8 4c d6 ff ff       	call   80104590 <memmove>
    len -= n;
    buf += n;
80106f44:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f47:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106f4a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106f50:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f52:	29 cb                	sub    %ecx,%ebx
80106f54:	74 32                	je     80106f88 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106f56:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f58:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106f5b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106f5e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f64:	56                   	push   %esi
80106f65:	ff 75 08             	pushl  0x8(%ebp)
80106f68:	e8 53 ff ff ff       	call   80106ec0 <uva2ka>
    if(pa0 == 0)
80106f6d:	83 c4 10             	add    $0x10,%esp
80106f70:	85 c0                	test   %eax,%eax
80106f72:	75 ac                	jne    80106f20 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106f77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f7c:	5b                   	pop    %ebx
80106f7d:	5e                   	pop    %esi
80106f7e:	5f                   	pop    %edi
80106f7f:	5d                   	pop    %ebp
80106f80:	c3                   	ret    
80106f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106f8b:	31 c0                	xor    %eax,%eax
}
80106f8d:	5b                   	pop    %ebx
80106f8e:	5e                   	pop    %esi
80106f8f:	5f                   	pop    %edi
80106f90:	5d                   	pop    %ebp
80106f91:	c3                   	ret    

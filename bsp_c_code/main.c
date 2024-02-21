// data section
volatile unsigned long dbg = 0x300;

// bss section
volatile unsigned long *counter1 = 0;

void main(void)
{
  volatile unsigned long *counter2 = (void *) 0x300;

  counter1 = (void *) dbg;

  while (1) {
    *counter1 += 1;
    *counter2 += 1;
  }
}



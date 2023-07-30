#include "encoding.h"

#if __riscv_xlen == 64
  # define LREG ld
  # define LREGU lwu
  # define SREG sd
  # define REGBYTES 8
  # define FMV fmv.d.x
#else
  # define LREG lw
  # define SREG sw
  # define LREGU lw
  # define REGBYTES 4
  # define FMV fmv.w.x
#endif

  .section ".text.init"
  .globl _start
_start:
  la sp, begin_signature
  LREG  x1, 0*REGBYTES(sp)
  LREG  x3, 1*REGBYTES(sp)
  LREG  x4, 2*REGBYTES(sp)
  LREG  x5, 3*REGBYTES(sp)
  LREG  x6, 4*REGBYTES(sp)
  LREG  x7, 5*REGBYTES(sp)
  LREG  x8, 6*REGBYTES(sp)
  LREG  x9, 7*REGBYTES(sp)
  LREG  x10,8*REGBYTES(sp)
  LREG  x11,9*REGBYTES(sp)
  LREG  x12,10*REGBYTES(sp)
  LREG  x13,11*REGBYTES(sp)
  LREG  x14,12*REGBYTES(sp)
  LREG  x15,13*REGBYTES(sp)
  LREG  x16,14*REGBYTES(sp)
  LREG  x17,15*REGBYTES(sp)
  LREG  x18,16*REGBYTES(sp)
  LREG  x19,17*REGBYTES(sp)
  LREG  x20,18*REGBYTES(sp)
  LREG  x21,19*REGBYTES(sp)
  LREG  x22,20*REGBYTES(sp)
  LREG  x23,21*REGBYTES(sp)
  LREG  x24,22*REGBYTES(sp)
  LREG  x25,23*REGBYTES(sp)
  LREG  x26,24*REGBYTES(sp)
  LREG  x27,25*REGBYTES(sp)
  LREG  x28,26*REGBYTES(sp)
  LREG  x29,27*REGBYTES(sp)
  LREG  x30,28*REGBYTES(sp)
  LREG  x31,29*REGBYTES(sp)

  # enable FPU and accelerator if present
  li t0, MSTATUS_FS | MSTATUS_XS
  csrs mstatus, t0

  # make sure XLEN agrees with compilation choice
  li t0, 1
  slli t0, t0, 31
#if __riscv_xlen == 64
  bgez t0, 1f
#else
  bltz t0, 1f
#endif
2:
  li a0, 1
  sw a0, tohost, t0
  j 2b
1:

#ifdef __riscv_flen
  # initialize FPU if we have one
  la t0, 1f
  csrw mtvec, t0

  fssr    x0
  FMV  f0, x1
  FMV  f1, x1
  FMV  f2, x2
  FMV  f3, x3
  FMV  f4, x4
  FMV  f5, x5
  FMV  f6, x6
  FMV  f7, x7
  FMV  f8, x8
  FMV  f9, x9
  FMV  f10, x10
  FMV  f11, x11
  FMV  f12, x12
  FMV  f13, x13
  FMV  f14, x14
  FMV  f15, x15
  FMV  f16, x16
  FMV  f17, x17
  FMV  f18, x18
  FMV  f19, x19
  FMV  f20, x20
  FMV  f21, x21
  FMV  f22, x22
  FMV  f23, x23
  FMV  f24, x24
  FMV  f25, x25
  FMV  f26, x26
  FMV  f27, x27
  FMV  f28, x28
  FMV  f29, x29
  FMV  f30, x30
  FMV  f31, x31
  .align 4
1:
#endif

  # initialize trap vector
  la t0, trap_entry
  csrw mtvec, t0

  la  tp, _end + 63
  and tp, tp, -64

  # get core id
  csrr a0, mhartid
  # for now, assume only 1 core
  li a1, 1
1:bgeu a0, a1, 1b

  # give each core 128KB of stack + TLS
#define STKSHIFT 17
  sll a2, a0, STKSHIFT
  add tp, tp, a2
  add sp, a0, 1
  sll sp, sp, STKSHIFT
  add sp, sp, tp

  j main

  .align 2
trap_entry:
  addi sp, sp, -272

  SREG x1, 1*REGBYTES(sp)
  SREG x2, 2*REGBYTES(sp)
  SREG x3, 3*REGBYTES(sp)
  SREG x4, 4*REGBYTES(sp)
  SREG x5, 5*REGBYTES(sp)
  SREG x6, 6*REGBYTES(sp)
  SREG x7, 7*REGBYTES(sp)
  SREG x8, 8*REGBYTES(sp)
  SREG x9, 9*REGBYTES(sp)
  SREG x10, 10*REGBYTES(sp)
  SREG x11, 11*REGBYTES(sp)
  SREG x12, 12*REGBYTES(sp)
  SREG x13, 13*REGBYTES(sp)
  SREG x14, 14*REGBYTES(sp)
  SREG x15, 15*REGBYTES(sp)
  SREG x16, 16*REGBYTES(sp)
  SREG x17, 17*REGBYTES(sp)
  SREG x18, 18*REGBYTES(sp)
  SREG x19, 19*REGBYTES(sp)
  SREG x20, 20*REGBYTES(sp)
  SREG x21, 21*REGBYTES(sp)
  SREG x22, 22*REGBYTES(sp)
  SREG x23, 23*REGBYTES(sp)
  SREG x24, 24*REGBYTES(sp)
  SREG x25, 25*REGBYTES(sp)
  SREG x26, 26*REGBYTES(sp)
  SREG x27, 27*REGBYTES(sp)
  SREG x28, 28*REGBYTES(sp)
  SREG x29, 29*REGBYTES(sp)
  SREG x30, 30*REGBYTES(sp)
  SREG x31, 31*REGBYTES(sp)

  csrr a0, mcause                 # copy the mcause to register a0.
  csrr a1, mepc                   # copy the mepc to register a1.
  lhu  a2, 0(a1)                  # load instruction into reg a1.

  # check the lower 2 bits to see if the instruction is 32-bit or 16-bit.
  andi a2, a2, 0x3;
  li t0, 0x3
  bne a2,t0,inst16

  inst32:                           # is 32-bit instruction then increment by 4
  addi a1,a1,0x4
  beqz x0,1f

inst16:
  addi a1,a1,0x2                  # is 16-bit instruction then increment by 2

1: 
  csrw mepc, a1                   # point mepc to the next instruction.

  # use mcause to update the number of exceptions encountered in the program.

  # Remain in M-mode after eret
  li t0, MSTATUS_MPP
  csrs mstatus, t0

  LREG x1, 1*REGBYTES(sp)
  LREG x2, 2*REGBYTES(sp)
  LREG x3, 3*REGBYTES(sp)
  LREG x4, 4*REGBYTES(sp)
  LREG x5, 5*REGBYTES(sp)
  LREG x6, 6*REGBYTES(sp)
  LREG x7, 7*REGBYTES(sp)
  LREG x8, 8*REGBYTES(sp)
  LREG x9, 9*REGBYTES(sp)
  LREG x10, 10*REGBYTES(sp)
  LREG x11, 11*REGBYTES(sp)
  LREG x12, 12*REGBYTES(sp)
  LREG x13, 13*REGBYTES(sp)
  LREG x14, 14*REGBYTES(sp)
  LREG x15, 15*REGBYTES(sp)
  LREG x16, 16*REGBYTES(sp)
  LREG x17, 17*REGBYTES(sp)
  LREG x18, 18*REGBYTES(sp)
  LREG x19, 19*REGBYTES(sp)
  LREG x20, 20*REGBYTES(sp)
  LREG x21, 21*REGBYTES(sp)
  LREG x22, 22*REGBYTES(sp)
  LREG x23, 23*REGBYTES(sp)
  LREG x24, 24*REGBYTES(sp)
  LREG x25, 25*REGBYTES(sp)
  LREG x26, 26*REGBYTES(sp)
  LREG x27, 27*REGBYTES(sp)
  LREG x28, 28*REGBYTES(sp)
  LREG x29, 29*REGBYTES(sp)
  LREG x30, 30*REGBYTES(sp)
  LREG x31, 31*REGBYTES(sp)

  addi sp, sp, 272
  mret

.section ".tdata.begin"
.globl _tdata_begin
_tdata_begin:

.section ".tdata.end"
.globl _tdata_end
_tdata_end:

.section ".tbss.end"
.globl _tbss_end
_tbss_end:

.section ".tohost","aw",@progbits
.align 6
.globl tohost
tohost: .dword 0
.align 6
.globl fromhost
fromhost: .dword 0

# Exception generation numbers
.align 4
.globl ecause_num
ecause_num:
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0
    .dword 0

# Read only data
.section ".rodata"
.globl rodata
rodata:
    	.dword 0x5b707269762d6d6f
	.dword 0x64655d0a6d6f6465
	.dword 0x203d206d0a5b6765
	.dword 0x6e6572616c5d0a74
	.dword 0x6f74616c5f696e73
	.dword 0x7472756374696f6e
	.dword 0x73203d2031300a72
	.dword 0x6567735f6e6f745f
	.dword 0x757365203d207831
	.dword 0x2c78320a63757374
	.dword 0x6f6d5f747261705f
	.dword 0x68616e646c657220
	.dword 0x3d20547275650a63
	.dword 0x6f64655f73746172
	.dword 0x745f616464726573
	.dword 0x73203d2032313437
	.dword 0x3438333634380a64
	.dword 0x656661756c745f70
	.dword 0x726f6772616d5f65
	.dword 0x786974203d205472
	.dword 0x75650a64656c6567
	.dword 0x6174696f6e203d20
	.dword 0x300a5b6973612d69
	.dword 0x6e73747275637469
	.dword 0x6f6e2d6469737472
	.dword 0x69627574696f6e5d
	.dword 0x0a72656c5f737973
	.dword 0x203d20300a72656c
	.dword 0x5f7379732e637372
	.dword 0x203d20300a72656c
	.dword 0x5f72763332692e63
	.dword 0x74726c203d20300a
	.dword 0x72656c5f72763332
	.dword 0x692e636f6d707574
	.dword 0x65203d2031300a72
	.dword 0x656c5f7276333269
	.dword 0x2e64617461203d20
	.dword 0x300a72656c5f7276
	.dword 0x3332692e66656e63
	.dword 0x65203d20300a7265
	.dword 0x6c5f72763634692e
	.dword 0x636f6d7075746520
	.dword 0x3d20300a72656c5f
	.dword 0x72763634692e6461
	.dword 0x7461203d20300a72
	.dword 0x656c5f7276333269
	.dword 0x2e7a6261203d2030
	.dword 0x0a72656c5f727636
	.dword 0x34692e7a6261203d
	.dword 0x20300a72656c5f72
	.dword 0x763332692e7a6262
	.dword 0x203d20300a72656c
	.dword 0x5f72763634692e7a
	.dword 0x6262203d20300a72
	.dword 0x656c5f7276333269
	.dword 0x2e7a6263203d2030
	.dword 0x0a72656c5f727633
	.dword 0x32692e7a6273203d
	.dword 0x20300a72656c5f72
	.dword 0x763332692e7a6265
	.dword 0x203d20300a72656c
	.dword 0x5f72763634692e7a
	.dword 0x6265203d20300a72
	.dword 0x656c5f7276333269
	.dword 0x2e7a6266203d2030
	.dword 0x0a72656c5f727636
	.dword 0x34692e7a6266203d
	.dword 0x20300a72656c5f72
	.dword 0x763634692e7a626d
	.dword 0x203d20300a72656c
	.dword 0x5f72763332692e7a
	.dword 0x6270203d20300a72
	.dword 0x656c5f7276363469
	.dword 0x2e7a6270203d2030
	.dword 0x0a72656c5f727633
	.dword 0x32692e7a6272203d
	.dword 0x20300a72656c5f72
	.dword 0x763634692e7a6272
	.dword 0x203d20300a72656c
	.dword 0x5f72763332692e7a
	.dword 0x6274203d20300a72
	.dword 0x656c5f7276363469
	.dword 0x2e7a6274203d2030
	.dword 0x0a72656c5f727633
	.dword 0x326d203d20300a72
	.dword 0x656c5f727636346d
	.dword 0x203d20300a72656c
	.dword 0x5f7276333261203d
	.dword 0x20300a72656c5f72
	.dword 0x76363461203d2030
	.dword 0x0a72656c5f727633
	.dword 0x3266203d20300a72
	.dword 0x656c5f7276363466
	.dword 0x203d20300a72656c
	.dword 0x5f7276333264203d
	.dword 0x20300a72656c5f72
	.dword 0x76363464203d2030
	.dword 0x0a72656c5f727663
	.dword 0x2e6374726c203d20
	.dword 0x300a72656c5f7276
	.dword 0x632e636f6d707574
	.dword 0x65203d20300a7265
	.dword 0x6c5f7276632e7370
	.dword 0x203d20300a72656c
	.dword 0x5f7276632e646174
	.dword 0x61203d20300a7265
	.dword 0x6c5f7276632e6664
	.dword 0x617461203d20300a
	.dword 0x72656c5f72763332
	.dword 0x632e636f6d707574
	.dword 0x65203d20300a7265
	.dword 0x6c5f72763332632e
	.dword 0x6374726c203d2030
	.dword 0x0a72656c5f727633
	.dword 0x32632e6664617461
	.dword 0x203d20300a72656c
	.dword 0x5f72763634632e63
	.dword 0x6f6d70757465203d
	.dword 0x20300a72656c5f72
	.dword 0x763634632e646174
	.dword 0x61203d20300a5b66
	.dword 0x6c6f61742d726f75
	.dword 0x6e64696e675d0a72
	.dword 0x6e65203d20300a72
	.dword 0x747a203d20300a72
	.dword 0x646e203d20300a72
	.dword 0x7570203d20300a72
	.dword 0x6d6d203d20300a5b
	.dword 0x6272616e63682d63
	.dword 0x6f6e74726f6c5d0a
	.dword 0x6261636b77617264
	.dword 0x2d70726f62616269
	.dword 0x6c697479203d2030
	.dword 0x2e350a626c6f636b
	.dword 0x2d73697a65203d20
	.dword 0x370a5b7265637572
	.dword 0x73696f6e2d6f7074
	.dword 0x696f6e735d0a7265
	.dword 0x63757273696f6e2d
	.dword 0x656e61626c65203d
	.dword 0x2046616c73650a72
	.dword 0x6563757273696f6e
	.dword 0x2d6465707468203d
	.dword 0x20300a7265637572
	.dword 0x73696f6e2d63616c
	.dword 0x6c73203d20300a5b
	.dword 0x6163636573732d73
	.dword 0x656374696f6e735d
	.dword 0x0a626567696e5f73
	.dword 0x69676e6174757265
	.dword 0x203d203078383030
	.dword 0x39313030302c3078
	.dword 0x3830303935303030
	.dword 0x2c72770a5b637372
	.dword 0x2d73656374696f6e
	.dword 0x735d0a7365637469
	.dword 0x6f6e73203d203078
	.dword 0x303130303a307864
	.dword 0x66662c2030783332
	.dword 0x352c203078353030
	.dword 0x3a30786666660a5b
	.dword 0x757365722d66756e
	.dword 0x6374696f6e735d0a
	.dword 0x66756e6331203d20
	.dword 0x7b303a2261646420
	.dword 0x78302c78302c7830
	.dword 0x227d0a5b73776974
	.dword 0x63682d707269762d
	.dword 0x6d6f6465735d0a73
	.dword 0x77697463685f6d6f
	.dword 0x646573203d204661
	.dword 0x6c73650a6e756d5f
	.dword 0x7377697463686573
	.dword 0x203d20300a5b692d
	.dword 0x63616368655d0a6e
	.dword 0x756d5f63616c6c73
	.dword 0x203d20300a6e756d
	.dword 0x5f62797465735f70
	.dword 0x65725f626c6f636b
	.dword 0x203d2031360a6e75
	.dword 0x6d5f626c6f636b73
	.dword 0x203d20380a6e756d
	.dword 0x5f6379636c657320
	.dword 0x3d2031300a5b642d
	.dword 0x63616368655d0a6e
	.dword 0x756d5f63616c6c73
	.dword 0x203d20300a6e756d
	.dword 0x5f62797465735f70
	.dword 0x65725f626c6f636b
	.dword 0x203d2031360a6e75
	.dword 0x6d5f626c6f636b73
	.dword 0x203d20380a6e756d
	.dword 0x5f6379636c657320
	.dword 0x3d2031300a5b6578
	.dword 0x63657074696f6e2d
	.dword 0x67656e6572617469
	.dword 0x6f6e5d0a65636175
	.dword 0x73653030203d2030
	.dword 0x0a65636175736530
	.dword 0x31203d20300a6563
	.dword 0x617573653032203d
	.dword 0x20300a6563617573
	.dword 0x653033203d20300a
	.dword 0x6563617573653034
	.dword 0x203d20300a656361
	.dword 0x7573653035203d20
	.dword 0x300a656361757365
	.dword 0x3036203d20300a65
	.dword 0x6361757365303720
	.dword 0x3d20300a65636175
	.dword 0x73653038203d2030
	.dword 0x0a65636175736530
	.dword 0x39203d20300a6563
	.dword 0x617573653130203d
	.dword 0x20300a6563617573
	.dword 0x653131203d20300a
	.dword 0x6563617573653132
	.dword 0x203d20300a656361
	.dword 0x7573653133203d20
	.dword 0x300a656361757365
	.dword 0x3134203d20300a5b
	.dword 0x646174612d68617a
	.dword 0x617264735d0a7261
	.dword 0x775f70726f62203d
	.dword 0x20302e350a776172
	.dword 0x5f70726f62203d20
	.dword 0x302e350a7761775f
	.dword 0x70726f62203d2030
	.dword 0x2e350a6e756d5f72
	.dword 0x6567735f6c6f6f6b
	.dword 0x626568696e64203d
	.dword 0x20330a5b70726f67
	.dword 0x72616d2d6d616372
	.dword 0x6f5d0a7072655f70
	.dword 0x726f6772616d5f6d
	.dword 0x6163726f203d2061
	.dword 0x64642078302c7830
	.dword 0x2c78300a706f7374
	.dword 0x5f70726f6772616d
	.dword 0x5f6d6163726f203d
	.dword 0x206164642078302c
	.dword 0x78302c78300a7072
	.dword 0x655f6272616e6368
	.dword 0x5f6d6163726f203d
	.dword 0x206164642078302c
	.dword 0x78302c78300a706f
	.dword 0x73745f6272616e63
	.dword 0x685f6d6163726f20
	.dword 0x3d20616464207830
	.dword 0x2c78302c78300a65
	.dword 0x6361757365303020
	.dword 0x3d2072616e646f6d
	.dword 0x0a65636175736530
	.dword 0x31203d2072616e64
	.dword 0x6f6d0a6563617573
	.dword 0x653032203d207261
	.dword 0x6e646f6d0a656361
	.dword 0x7573653033203d20
	.dword 0x72616e646f6d0a65
	.dword 0x6361757365303420
	.dword 0x3d2072616e646f6d
	.dword 0x0a65636175736530
	.dword 0x35203d2072616e64
	.dword 0x6f6d0a6563617573
	.dword 0x653036203d207261
	.dword 0x6e646f6d0a656361
	.dword 0x7573653037203d20
	.dword 0x72616e646f6d0a65
	.dword 0x6361757365303820
	.dword 0x3d2072616e646f6d
	.dword 0x0a65636175736530
	.dword 0x39203d2072616e64
	.dword 0x6f6d0a6563617573
	.dword 0x653130203d207261
	.dword 0x6e646f6d0a656361
	.dword 0x7573653131203d20
	.dword 0x72616e646f6d0a65
	.dword 0x6361757365313220
	.dword 0x3d2072616e646f6d
	.dword 0x0a65636175736531
	.dword 0x33203d2072616e64
	.dword 0x6f6d0a6563617573
	.dword 0x653134203d207261
	.dword 0x6e646f6d0a5b7365
	.dword 0x6c662d636865636b
	.dword 0x696e675d0a726174
	.dword 0x65203d20310a7465
	.dword 0x73745f706173735f
	.dword 0x6d6163726f203d20
	.dword 0x6c61202020202020
	.dword 0x73702c2062656769
	.dword 0x6e5f7369676e6174
	.dword 0x7572653b20616464
	.dword 0x692020202073702c
	.dword 0x2073702c20322a52
	.dword 0x454742595445533b
	.dword 0x206c692020202020
	.dword 0x2074312c20307866
	.dword 0x666666663b205352
	.dword 0x4547202020207431
	.dword 0x2c20302a52454742
	.dword 0x5954455328737029
	.dword 0x0a746573745f6661
	.dword 0x696c5f6d6163726f
	.dword 0x203d206164642078
	.dword 0x302c78302c78300a

# See https://gitlab.com/vyoma_systems/common/-/blob/main/LICENSE.vyoma for more details
 
#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV32M
RVTEST_CODE_BEGIN

  .align 2
  .option norvc

  li TESTNUM, 2
illegal_instruction:
  .word 0              
  j fail
  TEST_PASSFAIL

  .align 8
  .global mtvec_handler
mtvec_handler:
  li t1, CAUSE_ILLEGAL_INSTRUCTION
  csrr t0, mcause               # Check if the cause of the exception (stored in t0) is equal to the cause code for the "Illegal Instruction" exception (stored in t1)
  bne t0, t1, fail              
  csrr t1, mepc                 # Read the machine exception program counter (mepc) and store its value into register t1
  addi t1, t1, 8                # Skip the illegal instruction that caused the exception by adding 8 to the program counter
  csrw mepc, t1                 # Update the machine exception program counter (mepc) to the next instruction after the illegal one

  mret

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
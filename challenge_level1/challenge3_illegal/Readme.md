# challenge_level1/challenge3_illegal

Rectification of the test.S file to successfully perform the spike test simulation without the illegal instruction that was causing the error.

## Bug
Enter to the directory with buggy test.S file.

```bash
cd challenge_level1/challenge3_illegal
```

Try the buggy file to see any errors present by executing the make file with the command.
```bash
make
```
\
This is the error - the loop never stops..... (Quitting it with --Ctrl+C "Q"-- command on spike.)

![bash make error.png](<make error.png>)

## Rectification
Rectification of the test.S file.

- Original Code -
```
  .align 8
  .global mtvec_handler
mtvec_handler:
  li t1, CAUSE_ILLEGAL_INSTRUCTION
  csrr t0, mcause
  bne t0, t1, fail

  mret

```
In this code the loop control variable is present but it is not utilized in the code being the reason for the error message.

- Rectified code -
```
  .align 8
  .global mtvec_handler
mtvec_handler:
  li t1, CAUSE_ILLEGAL_INSTRUCTION
  csrr t0, mcause               # Check if the cause of the exception 
  bne t0, t1, fail              
  csrr t1, mepc                 # Read mepc and store its value into register t1
  addi t1, t1, 8                # Skip the illegal instruction that caused the exception by adding 8 to the program counter
  csrw mepc, t1                 # Update the mepc to the next instruction after the illegal one

  mret
```
The rectified code includes the correct handler code, earlier MEPC was not updated in handler code. we then skip the illegal  instruction and go to the next instruction and finally updating the csr value.


- Now we try the make file with the updated test.S file.
```bash
make
```
\
This is the final execution of the make without any bugs.\
We can see the "test.elf", "test.diass", "test_spike_signature.log" and "test_spike.dump" files are succesfully generated.

![bash make rectified.png](<make rectified.png>)

We can verify the exception is handelled correctly from the test_spike.dump file.

![verification spike dump file](<verification spike dump file.png>)

## Thank You

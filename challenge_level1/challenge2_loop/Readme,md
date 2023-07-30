# challenge_level1/challenge2_lop

Rectification of the test.S file to successfully perform the spike test simulation.

## Bug
Enter to the directory with buggy test.S file.

```bash
cd challenge_level1/challenge2_loop
```

Try the buggy file to see any errors present by executing the make file with the command.
```bash
make
```
\
This is the error message.

![bash make error.png](<bash make error.png>)

## Rectification
Rectification of the test.S file.

- Original Code -
```
 la t0, test_cases
  li t5, 3

loop:
	lw t1, (t0)
  lw t2, 4(t0)
  lw t3, 8(t0)
  add t4, t1, t2
  addi t0, t0, 12
  beq t3, t4, loop        # check if sum is correct
  j fail

test_end:
```
In this code the loop control variable is present but it is not utilized in the code being the reason for the error message.

- Rectified code -
```
  la t0, test_cases
  li t5, 3

loop:
	lw t1, (t0)
  lw t2, 4(t0)
  lw t3, 8(t0)
  add t4, t1, t2
  addi t0, t0, 12
  bne t3, t4, fail        # check if sum is correct -- Jump to the "fail" label if t3 is not equal to t4
  addi t5, t5, -1         # Decrement the loop control variable t5
  beqz t5, pass           # Jump to the "pass" label if t5 is zero
  j loop                  # Else go to the loop again.
  
test_end:
```
The rectified code includes the loop control to run the simulation error free while testing the conditions mentioned.


- Now we try the make file with the updated test.S file.
```bash
make
```
\
This is the final execution of the make without any bugs.\
We can see the "test.elf", "test.diass", "test_spike_signature.log" and "test_spike.dump" files are succesfully generated.
![bash make rectified.png](<bash make rectified.png>)

## Testcase
- Test 1 (No Error)
```
test_cases:
  .word 0x20               # input 1
  .word 0x20               # input 2
  .word 0x30               # sum
  .word 0x03034078
  .word 0x5d70344d
  .word 0x607374C5
  .word 0xcafe
  .word 0x1
  .word 0xcaff
```
Output

![Test_case_1.png](Test_case_1.png)

- Test 2 (Error in last set of .word)
```
test_cases:
  .word 0x20               # input 1
  .word 0x20               # input 2
  .word 0x30               # sum
  .word 0x03034078
  .word 0x5d70344d
  .word 0x607374C5
  .word 0xcafd
  .word 0x1
  .word 0xcaff
```
Output

![Test_case_2.png](Test_case_2.png)
Error in the test cases result in the  *** **FAILED** *** message to pop up on spike.

## Thank You
# challenge_level2/challenge1_instructions

Rectification of the rv32i.yaml file to successfully perform the spike test simulation.

## Bug
Enter to the directory with buggy rv32i.yaml file.

```bash
cd challenge_level1/challenge2_loop
```

Try the buggy file to see any errors present by executing the make file with the command.
```bash
make
```
\
This is the error message.

![Make Error](<error make.png>)

## Rectification
Rectification of the test.S file.

- Original Code -
```yaml
  rel_rv64i.zbp: 0
  rel_rv32i.zbr: 0
  rel_rv64i.zbr: 0
  rel_rv32i.zbt: 0
  rel_rv64i.zbt: 0
  rel_rv32m: 0
  rel_rv64m: 10
  rel_rv32a: 0
  rel_rv64a: 0
  rel_rv32f: 0
  rel_rv64f: 0
  rel_rv32d: 0
  rel_rv64d: 0
```
In this code, "rel_rv64m: 10" the 64bit instruction set of the RISC-V are used but the compilation is done only for the rv32i, 32 bit base ISA resulting in the error.

- Rectified code -
```yaml
  rel_rv64i.zbp: 0
  rel_rv32i.zbr: 0
  rel_rv64i.zbr: 0
  rel_rv32i.zbt: 0
  rel_rv64i.zbt: 0
  rel_rv32m: 0
  rel_rv64m: 0
  rel_rv32a: 0
  rel_rv64a: 0
  rel_rv32f: 0
  rel_rv64f: 0
  rel_rv32d: 0
  rel_rv64d: 0
```
"rel_rv64m: 10" is updated to value "0" so the the random generator dosent include the rv64m instructions along with it.


- Now we try the make file with the updated rv32i.yaml file.
```bash
make
```
\
This is the final execution of the make without any bugs.\
We can see the "test.elf", "test.diass", "test_spike_signature.log" and "test_spike.dump" files are succesfully generated.

![bash make rectified.png](<make rectified.png>)

## Thank You

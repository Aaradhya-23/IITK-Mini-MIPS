# IITK-Mini-MIPS

## Overview

A simplified MIPS-like processor implemented in Verilog with a single-cycle design, supporting arithmetic, logical, memory, control flow, and floating-point operations. Suitable for FPGA synthesis or Verilog simulation.

---

## Key Features

- **Instruction Set**: Arithmetic, logical, memory, control flow, and floating-point addition/subtraction.  
- **Architecture**: Single-cycle with instruction/data memory, ALU, register file, and program counter.  
- **Floating-Point**: Basic addition and subtraction supported.

---

## Files

- `Processor.v`: Top-level module.  
- `Control_unit.v`: Decodes instructions.  
- `Alu.v`: Handles ALU operations including floating-point add/sub.  
- `dist_mem_gen_0.v`: Dual-port memory.  
- `Inst_decoder.v`: Instruction decoder.  
- `inst_mem.mem`: Sample instructions.  
- `PC.v`: Program counter.  
- `Register_Memory.v`: 32-register file.

---

## Instruction Set

The processor supports the following instructions, categorized by type:

### Arithmetic Instructions

| Instruction | Operation            | Inst Code    |
|-------------|----------------------|--------------|
| add         | Signed addition      | 6'b000000    |
| sub         | Signed subtraction   | 6'b000001    |
| addu        | Unsigned addition    | 6'b000010    |
| subu        | Unsigned subtraction | 6'b000011    |
| addi        | Add immediate        | 6'b000100    |
| addiu       | Add immediate unsigned | 6'b000101 |
| madd        | Multiply and add     | 6'b000110    |
| maddu       | Multiply and add unsigned | 6'b000111 |
| mul         | Multiply             | 6'b100111    |

### Logical Instructions

| Instruction | Operation          | Inst Code    |
|-------------|--------------------|--------------|
| and         | Bitwise AND        | 6'b001000    |
| andi        | AND with immediate | 6'b001001    |
| or          | Bitwise OR         | 6'b001010    |
| ori         | OR with immediate  | 6'b001011    |
| not         | Bitwise NOT        | 6'b001100    |
| xor         | Bitwise XOR        | 6'b001101    |
| xori        | XOR with immediate | 6'b001110    |

### Shift Instructions

| Instruction | Operation             | Inst Code    |
|-------------|-----------------------|--------------|
| sll         | Shift left logical    | 6'b001111    |
| srl         | Shift right logical   | 6'b010000    |
| sla         | Shift left arithmetic | 6'b010001    |
| sra         | Shift right arithmetic| 6'b010010    |

### Comparison Instructions

| Instruction | Operation                     | Inst Code    |
|-------------|-------------------------------|--------------|
| sgt         | Set if greater than (signed)  | 6'b010011    |
| slt         | Set if less than (signed)     | 6'b010100    |
| seq         | Set if equal                  | 6'b010101    |
| sgtu        | Set if greater than (unsigned)| 6'b010110    |
| sltu        | Set if less than (unsigned)   | 6'b010111    |

### Memory Instructions

- **lw** (Load Word): Loads a 32-bit word from memory (CU_op = 4'b0101).  
- **sw** (Store Word): Stores a 32-bit word to memory (CU_op = 4'b0110).

### Control Flow Instructions

- **j** (Jump): Unconditional jump to a target address (CU_op = 4'b1001).  
- **jr** (Jump Register): Jump to an address in a register (CU_op = 4'b1100).  
- **jal** (Jump and Link): Jump to a target and save return address (CU_op = 4'b1101).  
- **Conditional Branch**: Branches based on comparison results (CU_op = 4'b1000).

### Other Instructions

- **lui** (Load Upper Immediate): Loads a 16-bit immediate into the upper half of a register (CU_op = 4'b0111).  
- **slt, seq** (Set Less Than, Set Equal): Comparison operations (CU_op = 4'b1010).  
- **slti** (Set Less Than Immediate): Comparison with immediate (CU_op = 4'b1011).

---

## Branching Mechanism

The processor supports conditional branching:

- **Instruction Type**: Identified by `CU_op = 4'b1000`.  
- **Control Signals**: Control unit sets `is_jump = 2'b01` for conditional branches.  
- **Condition Check**: ALU performs a comparison (e.g., `slt`, `seq`, `sgt`) using the `funct` code, result stored in `res`.

**Branch Decision:**
- If `is_jump == 1` and `res == 1`, the PC is updated to the target address:  
  `pc2 = pc_curr + 1 + offset`
- Else, normal PC increment: `pc_curr + 1`.

**Operation:**  
ALU compares `alu_inp_a` (from `r1_out`) and `alu_inp_b` (from `r2_out`), and the result (`res`) determines whether the branch is taken.

---

## Setup

- **Tools**: Verilog simulator (e.g., ModelSim) or FPGA tool (e.g., Vivado).  
- **Steps**: Place files in one directory, simulate with a testbench, or synthesize for FPGA.

---

## Course
CS220 - Introduction To Computer Hardware

---

## Professor
Debapriya Basu Roy

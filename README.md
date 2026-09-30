# INT8 MAC Unit

A simple Verilog implementation of an INT8 Multiply-Accumulate (MAC) unit.

The module takes two signed 8-bit inputs, multiplies them, and adds the result to a 32-bit accumulator.

## Features

- Signed INT8 multiplication
- 32-bit accumulation
- Enable control
- Accumulator clear
- Active-low reset
- Output valid signal

## Module

`mac_int8`

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `DATA_WIDTH` | 8 | Input data width |
| `ACC_WIDTH` | 32 | Accumulator width |

### Inputs

| Signal | Description |
|--------|-------------|
| `clk` | Clock |
| `rst_n` | Active-low reset |
| `en` | Enables MAC operation |
| `clear_acc` | Clears the accumulator |
| `a` | Signed input A |
| `b` | Signed input B |

### Outputs

| Signal | Description |
|--------|-------------|
| `acc` | Accumulated multiplication result |
| `valid_out` | High for one cycle when accumulation happens |

## Operation

When `en` is high:

```text
acc = acc + (a × b)
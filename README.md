# `Swift6502` – a simple 6502 emulator and disassembler

This repo contains a simple, but working, software implementation of a generic system based on the [6502 processor](https://no.wikipedia.org/wiki/MOS_Technology_6502) containing a CPU, bus and RAM.

It is capable of running programs written for this architecture. No GUI or CLI capabilities have been added yet.

A working disassembler also exists.

## Usage
### Emulator
The emulator has no output yet, so all that's currently possible is to run some code and make assertions in a test scenario. Clock frequency is not emulated, so unless code with an infinite loop is given it'll finish quite fast.

```swift
// Provide a program as a byte array.
let program: [UInt8] = [0x20, 0x09, 0x00, 0x20, 0x0C, 0x00, 0x20, 0x12, 0x00, 0xA2, 0x00, 0x60, 0xE8, 0xE0, 0x05, 0xD0, 0xFB, 0x60, 0x00]

// Create RAM (of length 0xFFFF + 1), with the program placed at the beginning.
let ram = Array.createRam(withProgram: program)

// Create the CPU.
let cpu = CPU.create(ram: ram)

// Run the program.
cpu.run()
```

### Disassembler
The disassembler is capable of disassembling a program back into human readable code.

```swift
// Provide a program as a byte array.
let program: [UInt8] = [0x20, 0x09, 0x00, 0x20, 0x0C, 0x00, 0x20, 0x12, 0x00, 0xA2, 0x00, 0x60, 0xE8, 0xE0, 0x05, 0xD0, 0xFB, 0x60, 0x00]

// Create the disassembler with the given program.
let disassembler = Disassembler(program: program)

// Disassemble the program. The return is a `[String]` containing human readable code.
let code = disassembler.disassemble()
```


## Motivation
I've had a lot of fun watching videos on YouTube of people either writing or disassembling games for the NES, which uses the 6502, and I wanted to see if I could write a software emulator that could run code assembled for that processor.

The main goal of this repo is to just have fun and learn something new I don't work with on a daily basis.

## Ideas / todo
- Make `Bus` own `CPU` – not the other way around.
- Make types `public`, if they need to.
- Don't break program flow when encountering opcode `0x00`, aka `BRK`.
- Add support for decimal mode.
- Implement the interrupt vector.
- Programs don't start at address `0x0000`. Fix this somehow.
- Emulate clock frequency.
- Improve disassembler output.
- Add labels for disassembly output for i.e. `JSR`.
- Create a CLI tool for the disassembler.
- Create a visual tool/app that can/has:
    - Load binaries from file.
    - Step debugging support.
    - Visualize registers and status flags.
    - Live disassemble while stepping through.

## References

| What | Description |
| --- | --- |
| [Masswerk](https://www.masswerk.at/6502/6502_instruction_set.html) | Probably the most useful resource I've used. Contains description of all instructions and addressing modes, as well as descriptions on when/how status flags are set. |
| [Instruction set](https://www.atariarchives.org/2bml/chapter_10.php) | Have answered some questions I couldn't find on Masswerk's site. |
| [Overflow explanation](https://www.righto.com/2012/12/the-6502-overflow-flag-explained.html) | Setting the overflow flag properly was probably the thing I struggled the most with. This site gave some highly appreciated insights. |
| [Online assembler](https://skilldrick.github.io/easy6502/) | This page has a nice step debugger and visualization of registers and flags. |
| [Online disassembler](https://www.masswerk.at/6502/disassembler.html) | Used to compare the output of my disassembler against a result from someone who actually knows what they're doing. |
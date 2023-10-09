import Foundation

extension CPU {
    @discardableResult
    func perform(instruction: Instruction, addressMode: AddressMode) -> UInt8 {
        switch instruction {
        case .xxx: 0
        case .adc: adc(addressMode: addressMode)
        case .and: and(addressMode: addressMode)
        case .asl: asl(addressMode: addressMode)
        case .bcc: bcc(addressMode: addressMode)
        case .bcs: bcs(addressMode: addressMode)
        case .beq: beq(addressMode: addressMode)
        case .bit: bit(addressMode: addressMode)
        case .bmi: bmi(addressMode: addressMode)
        case .bne: bne(addressMode: addressMode)
        case .bpl: bpl(addressMode: addressMode)
        case .brk: brk(addressMode: addressMode)
        case .bvc: bvc(addressMode: addressMode)
        case .bvs: bvs(addressMode: addressMode)
        case .clc: clc(addressMode: addressMode)
        case .cld: cld(addressMode: addressMode)
        case .cli: cli(addressMode: addressMode)
        case .clv: clv(addressMode: addressMode)
        case .cmp: cmp(addressMode: addressMode)
        case .cpx: cpx(addressMode: addressMode)
        case .cpy: cpy(addressMode: addressMode)
        case .dec: dec(addressMode: addressMode)
        case .dex: dex(addressMode: addressMode)
        case .dey: dey(addressMode: addressMode)
        case .eor: eor(addressMode: addressMode)
        case .inc: inc(addressMode: addressMode)
        case .inx: inx(addressMode: addressMode)
        case .iny: iny(addressMode: addressMode)
        case .jmp: jmp(addressMode: addressMode)
        case .jsr: jsr(addressMode: addressMode)
        case .lda: lda(addressMode: addressMode)
        case .ldx: ldx(addressMode: addressMode)
        case .ldy: ldy(addressMode: addressMode)
        case .lsr: lsr(addressMode: addressMode)
        case .nop: nop(addressMode: addressMode)
        case .ora: ora(addressMode: addressMode)
        case .pha: pha(addressMode: addressMode)
        case .php: php(addressMode: addressMode)
        case .pla: pla(addressMode: addressMode)
        case .plp: plp(addressMode: addressMode)
        case .rol: rol(addressMode: addressMode)
        case .ror: ror(addressMode: addressMode)
        case .rti: rti(addressMode: addressMode)
        case .rts: rts(addressMode: addressMode)
        case .sbc: sbc(addressMode: addressMode)
        case .sec: sec(addressMode: addressMode)
        case .sed: sed(addressMode: addressMode)
        case .sei: sei(addressMode: addressMode)
        case .sta: sta(addressMode: addressMode)
        case .stx: stx(addressMode: addressMode)
        case .sty: sty(addressMode: addressMode)
        case .tax: tax(addressMode: addressMode)
        case .tay: tay(addressMode: addressMode)
        case .tsx: tsx(addressMode: addressMode)
        case .txa: txa(addressMode: addressMode)
        case .txs: txs(addressMode: addressMode)
        case .tya: tya(addressMode: addressMode)
        }
    }
}

private extension CPU {
    // Add memory to accumulator with carry.
    func adc(addressMode: AddressMode) -> UInt8 {
        // Overflow using `UInt8` results in an exception being thrown.
        // "Cheat" and use `UInt16` when adding instead.
        let valueToAdd = readByte(addressAbsolute).asWord + readFlag(.carry).value.asWord
        let newValue = acc.asWord + valueToAdd

        // Set carry.
        setFlag(.carry, newValue > 0xFF)

        // Set zero flag.
        setFlag(.zero, newValue & 0xFF == 0x00)

        // Set negative flag, if highest bit is set.
        setFlag(.negative, newValue & 0x80 == 0x80)

        // Set overflow flag.
        // This flag should be set if the addition overflow in `Int8`, aka. if the result goes out of bounds of (-128 <-> +127).
        // Cast both `acc` and `valueToAdd` to `Int8`, add them and check if there's an overflow.
        let addResult = Int8(bitPattern: acc).addingReportingOverflow(Int8(bitPattern: UInt8(valueToAdd & 0xFF)))
        setFlag(.overflow, addResult.overflow)

        acc = UInt8(newValue & 0xFF)

        return 1
    }

    // AND memory with accumulator.
    func and(addressMode: AddressMode) -> UInt8 {
        let value = readByte(addressAbsolute)

        acc = acc & value

        setFlag(.zero, acc == 0x00)
        setFlag(.negative, acc & 0x80 == 0x80)

        return 1
    }

    // Shift left one bit (memory or accumulator).
    func asl(addressMode: AddressMode) -> UInt8 {
        var value: UInt16

        // If addressMode is `implied` we read from, and write back to, accumulator.
        // Otherwise we read/write to memory.
        if addressMode == .imp {
            value = acc.asWord
        } else {
            value = readByte(addressAbsolute).asWord
        }

        value = value << 1

        setFlag(.carry, value > 255)
        setFlag(.zero, value & 0x00FF == 0x00)
        setFlag(.negative, value & 0x80 == 0x80)

        let byte = UInt8(value & 0x00FF)

        if addressMode == .imp {
            acc = byte
        } else {
            writeByte(addressAbsolute, data: byte)
        }

        return 0
    }

    // Branch on carry clear.
    func bcc(addressMode: AddressMode) -> UInt8 {
        if !readFlag(.carry) {
            setPcFromRelativeAddress()
        }
        return 0
    }

    // Branch on carry set.
    func bcs(addressMode: AddressMode) -> UInt8 {
        if readFlag(.carry) {
            setPcFromRelativeAddress()
        }
        return 0
    }

    // Branch on result zero.
    func beq(addressMode: AddressMode) -> UInt8 {
        if readFlag(.zero) {
            setPcFromRelativeAddress()
        }
        return 0
    }

    // Test bits in memory with accumulator.
    func bit(addressMode: AddressMode) -> UInt8 {
        let memory = readByte(addressAbsolute)

        // Set zero flag if AND == 0.
        setFlag(.zero, acc & memory == 0x00)

        // Test bits 7 and 6 in memory.
        setFlag(.negative, memory & 0x80 == 0x80)
        setFlag(.overflow, memory & 0x40 == 0x40)

        return 0
    }

    // Branch on result minus.
    func bmi(addressMode: AddressMode) -> UInt8 {
        if readFlag(.negative) {
            setPcFromRelativeAddress()
        }
        return 0
    }

    // Branch on result not zero.
    func bne(addressMode: AddressMode) -> UInt8 {
        if !readFlag(.zero) {
            setPcFromRelativeAddress()
        }
        return 0
    }

    // Branch on result plus.
    func bpl(addressMode: AddressMode) -> UInt8 {
        if !readFlag(.negative) {
            setPcFromRelativeAddress()
        }
        return 0
    }

    // Force break.
    func brk(addressMode: AddressMode) -> UInt8 {
        // Push PC onto stack.
        pc += 1
        pushToStack(word: pc)

        // Set break and interrupt flag, before pushing status onto stack.
        setFlag(.break, true)
        setFlag(.interrupt, true)
        pushToStack(byte: flags)

        // Turn off break flag.
        setFlag(.break, false)

        // Set PC to contain address in interrupt vector at 0xFFFE
        pc = readWord(0xFFFE)

        return 0
    }

    // Branch on overflow clear.
    func bvc(addressMode: AddressMode) -> UInt8 {
        if !readFlag(.overflow) {
            setPcFromRelativeAddress()
        }
        return 0
    }

    // Branch on overflow set.
    func bvs(addressMode: AddressMode) -> UInt8 {
        if readFlag(.overflow) {
            setPcFromRelativeAddress()
        }
        return 0
    }

    // Clear carry flag.
    func clc(addressMode: AddressMode) -> UInt8 {
        setFlag(.carry, false)
        return 0
    }

    // Clear decimal mode.
    func cld(addressMode: AddressMode) -> UInt8 {
        setFlag(.decimal, false)
        return 0
    }

    // Clear interrupt disable bit.
    func cli(addressMode: AddressMode) -> UInt8 {
        setFlag(.interrupt, false)
        return 0
    }

    // Clear overflow flag.
    func clv(addressMode: AddressMode) -> UInt8 {
        setFlag(.overflow, false)
        return 0
    }

    // Compare memory with accumulator.
    func cmp(addressMode: AddressMode) -> UInt8 {
        compareMemoryAgainst(acc)
        return 1
    }

    // Compare memory with X.
    func cpx(addressMode: AddressMode) -> UInt8 {
        compareMemoryAgainst(xReg)
        return 0
    }

    // Compare memory with Y.
    func cpy(addressMode: AddressMode) -> UInt8 {
        compareMemoryAgainst(yReg)
        return 0
    }

    // Decrement memory by one.
    func dec(addressMode: AddressMode) -> UInt8 {
        let value = readByte(addressAbsolute)
        let decremented = perform(.dec, on: value)
        writeByte(addressAbsolute, data: decremented)
        return 0
    }

    // Decrement X by one.
    func dex(addressMode: AddressMode) -> UInt8 {
        xReg = perform(.dec, on: xReg)
        return 0
    }

    // Decrement Y by one.
    func dey(addressMode: AddressMode) -> UInt8 {
        yReg = perform(.dec, on: yReg)
        return 0
    }

    // Exclusive-OR memory with accumulator.
    func eor(addressMode: AddressMode) -> UInt8 {
        let memory = readByte(addressAbsolute)

        acc = acc ^ memory

        setFlag(.zero, acc & 0x00FF == 0x00)
        setFlag(.negative, acc & 0x80 == 0x80)

        return 1
    }

    // Increment memory by one.
    func inc(addressMode: AddressMode) -> UInt8 {
        let value = readByte(addressAbsolute)
        let incremented = perform(.inc, on: value)
        writeByte(addressAbsolute, data: incremented)
        return 0
    }

    // Increment X by one.
    func inx(addressMode: AddressMode) -> UInt8 {
        xReg = perform(.inc, on: xReg)
        return 0
    }

    // Increment Y by one.
    func iny(addressMode: AddressMode) -> UInt8 {
        yReg = perform(.inc, on: yReg)
        return 0
    }

    // Jump to new location.
    func jmp(addressMode: AddressMode) -> UInt8 {
        pc = addressAbsolute
        return 0
    }

    // Jump to new location, saving return address.
    func jsr(addressMode: AddressMode) -> UInt8 {
        pc -= 1
        pushToStack(word: pc)
        pc = addressAbsolute

        return 0
    }

    // Load accumulator.
    func lda(addressMode: AddressMode) -> UInt8 {
        acc = readByte(addressAbsolute)

        setFlag(.zero, acc & 0x00FF == 0x00)
        setFlag(.negative, acc & 0x80 == 0x80)

        return 0
    }

    // Load X register.
    func ldx(addressMode: AddressMode) -> UInt8 {
        xReg = readByte(addressAbsolute)

        setFlag(.zero, xReg & 0x00FF == 0x00)
        setFlag(.negative, xReg & 0x80 == 0x80)

        return 0
    }

    // Load Y register.
    func ldy(addressMode: AddressMode) -> UInt8 {
        yReg = readByte(addressAbsolute)

        setFlag(.zero, yReg & 0x00FF == 0x00)
        setFlag(.negative, yReg & 0x80 == 0x80)

        return 0
    }

    // Logical shift right (shifts in a zero bit on the left).
    func lsr(addressMode: AddressMode) -> UInt8 {
        var value: UInt16

        // If addressMode is `implied` we read from, and write back to, accumulator.
        // Otherwise we read/write to memory.
        if addressMode == .imp {
            value = acc.asWord
        } else {
            value = readByte(addressAbsolute).asWord
        }

        // Carry flag will be set if we push a bit off.
        setFlag(.carry, value & 0x01 == 0x01)

        value = value >> 1

        setFlag(.zero, value & 0x00FF == 0x00)
        
        // Can never be negative, since we don't push a bit onto bit 7.
        setFlag(.negative, false)

        let byte = UInt8(value & 0x00FF)

        if addressMode == .imp {
            acc = byte
        } else {
            writeByte(addressAbsolute, data: byte)
        }

        return 0
    }

    // No operation.
    func nop(addressMode: AddressMode) -> UInt8 {
        // TODO: Revisit NOPs that potentially uses more clock cycles.
        // I believe there exists a few NOP opcodes that will spend N clock cycles doing nothing.
        return 0
    }

    // OR memory with accumulator.
    func ora(addressMode: AddressMode) -> UInt8 {
        let value = readByte(addressAbsolute)

        acc = acc | value

        setFlag(.zero, acc == 0x00)
        setFlag(.negative, acc & 0x80 == 0x80)

        return 1
    }

    // Push accumulator on stack.
    func pha(addressMode: AddressMode) -> UInt8 {
        pushToStack(byte: acc)
        return 0
    }

    // Push processor status on stack.
    func php(addressMode: AddressMode) -> UInt8 {
        pushToStack(byte: flags)
        return 0
    }

    // Pull accumulator from stack.
    func pla(addressMode: AddressMode) -> UInt8 {
        acc = pullByteFromStack()

        setFlag(.zero, acc == 0x00)
        setFlag(.negative, acc & 0x80 == 0x80)

        return 0
    }

    // Pull processor status from stack.
    func plp(addressMode: AddressMode) -> UInt8 {
        flags = pullByteFromStack()
        return 0
    }

    // Rotate one bit left (memory or accumulator).
    func rol(addressMode: AddressMode) -> UInt8 {
        var value: UInt16

        // If addressMode is `implied` we read from, and write back to, accumulator.
        // Otherwise we read/write to memory.
        if addressMode == .imp {
            value = acc.asWord
        } else {
            value = readByte(addressAbsolute).asWord
        }

        value = (value << 1) | UInt16(readFlag(.carry).value)

        setFlag(.carry, value > 255)
        setFlag(.zero, value & 0x00FF == 0x00)
        setFlag(.negative, value & 0x80 == 0x80)

        let byte = UInt8(value & 0x00FF)

        if addressMode == .imp {
            acc = byte
        } else {
            writeByte(addressAbsolute, data: byte)
        }

        return 0
    }

    // Rotate one bit right (memory or accumulator).
    func ror(addressMode: AddressMode) -> UInt8 {
        var value: UInt16

        // If addressMode is `implied` we read from, and write back to, accumulator.
        // Otherwise we read/write to memory.
        if addressMode == .imp {
            value = acc.asWord
        } else {
            value = readByte(addressAbsolute).asWord
        }

        // Carry flag will be set if we push a bit off.
        // Check this before doing bitwise operations.
        let shouldSetCarry = value & 0x01 == 0x01

        value = (UInt16(readFlag(.carry).value) << 7) | (value >> 1)

        setFlag(.carry, shouldSetCarry)
        setFlag(.zero, value & 0x00FF == 0x00)
        setFlag(.negative, value & 0x80 == 0x80)

        let byte = UInt8(value & 0x00FF)

        if addressMode == .imp {
            acc = byte
        } else {
            writeByte(addressAbsolute, data: byte)
        }

        return 0
    }

    // Return from interrupt.
    func rti(addressMode: AddressMode) -> UInt8 {
        flags = pullByteFromStack()
        pc = pullWordFromStack()

        return 0
    }

    // Return from subroutine.
    func rts(addressMode: AddressMode) -> UInt8 {
        pc = pullWordFromStack()
        pc += 1

        return 0
    }

    /// Subtract memory from accumulator with borrow.
    ///
    /// References:
    /// - https://www.righto.com/2012/12/the-6502-overflow-flag-explained.html
    /// - http://forum.6502.org/viewtopic.php?f=1&t=7444
    /// - https://www.atariarchives.org/2bml/chapter_10.php
    func sbc(addressMode: AddressMode) -> UInt8 {
        let memory = readByte(addressAbsolute)
        
        // Flip the bits of memory so we get a negative number.
        let valueToAdd = (memory ^ 0xFF).asWord

        // Add together with carry, aka. negative borrow.
        let newValue = acc.asWord + valueToAdd + readFlag(.carry).value.asWord
        
        // Set overflow flag.
        // Read this before setting the other, since we need to read out what the carry was initially set to.
        // This flag should be set if the addition overflow in `Int8`, aka. if the result goes out of bounds of (-128 <-> +127).
        // This will happen if i.e. you add to positive numbers and the result is negative.
        // Cast both `acc` and `memory` to `Int8`, subtract them and check if there's an overflow.
        let subtractionResult = Int8(bitPattern: acc)
            .subtractingReportingOverflow(
                Int8(bitPattern: memory &- (1 - readFlag(.carry).value))
            )
        setFlag(.overflow, subtractionResult.overflow)

        // Set flags.
        setFlag(.carry, newValue > 0x00FF)
        setFlag(.zero, newValue & 0x00FF == 0x00)
        setFlag(.negative, newValue & 0x80 == 0x80)


        acc = UInt8(newValue & 0xFF)

        return 0
    }

    // Set carry flag.
    func sec(addressMode: AddressMode) -> UInt8 {
        setFlag(.carry, true)
        return 0
    }

    // Set decimal flag.
    func sed(addressMode: AddressMode) -> UInt8 {
        setFlag(.decimal, true)
        return 0
    }

    // Set interrupt disable status.
    func sei(addressMode: AddressMode) -> UInt8 {
        setFlag(.interrupt, true)
        return 0
    }

    // Store accumulator in memory.
    func sta(addressMode: AddressMode) -> UInt8 {
        writeByte(addressAbsolute, data: acc)
        return 0
    }

    // Store X in memory.
    func stx(addressMode: AddressMode) -> UInt8 {
        writeByte(addressAbsolute, data: xReg)
        return 0
    }

    // Store Y in memory.
    func sty(addressMode: AddressMode) -> UInt8 {
        writeByte(addressAbsolute, data: yReg)
        return 0
    }

    // Transfer accumulator to X.
    func tax(addressMode: AddressMode) -> UInt8 {
        xReg = acc

        setFlag(.zero, xReg == 0x00)
        setFlag(.negative, xReg & 0x80 == 0x80)

        return 0
    }

    // Transfer accumulator to Y.
    func tay(addressMode: AddressMode) -> UInt8 {
        yReg = acc

        setFlag(.zero, yReg == 0x00)
        setFlag(.negative, yReg & 0x80 == 0x80)

        return 0
    }

    // Transfer stack pointer to X.
    func tsx(addressMode: AddressMode) -> UInt8 {
        xReg = stackPointer

        setFlag(.zero, xReg == 0x00)
        setFlag(.negative, xReg & 0x80 == 0x80)

        return 0
    }

    // Transfer X to accumulator.
    func txa(addressMode: AddressMode) -> UInt8 {
        acc = xReg

        setFlag(.zero, acc == 0x00)
        setFlag(.negative, acc & 0x80 == 0x80)

        return 0
    }

    // Transfer X to stack pointer.
    func txs(addressMode: AddressMode) -> UInt8 {
        stackPointer = xReg
        return 0
    }

    // Transfer Y to accumulator.
    func tya(addressMode: AddressMode) -> UInt8 {
        acc = yReg

        setFlag(.zero, acc == 0x00)
        setFlag(.negative, acc & 0x80 == 0x80)

        return 0
    }
}

// MARK: - Private methods

private extension CPU {
    func setPcFromRelativeAddress() {
        // `addressRelative` may be a negative number, so make sure we don't overflow.
        let result = pc.addingReportingOverflow(addressRelative)

        // If page boundry is crossed, another clock cycle will be used.
        if result.overflow {
            // TODO: Increment clock cycles, when/if needed to keep track of this.
        }

        pc = result.partialValue
    }

    func compareMemoryAgainst(_ value: UInt8) {
        let memory = readByte(addressAbsolute)

        // If register is bigger than, or equal to, memory, then set carry flag to true.
        setFlag(.carry, value >= memory)

        // Set flags based on difference between value and memory.
        let diff = value.subtractingReportingOverflow(memory).partialValue
        setFlag(.zero, diff == 0x00)
        setFlag(.negative, diff & 0x80 == 0x80)
    }
}

private extension CPU {
    enum IncrementOrDecrement {
        case inc
        case dec
    }

    func perform(_ op: IncrementOrDecrement, on value: UInt8) -> UInt8 {
        let result: UInt8
        switch op {
        case .inc:
            result = value.addingReportingOverflow(1).partialValue
        case .dec:
            result = value.subtractingReportingOverflow(1).partialValue
        }

        setFlag(.zero, result == 0x00)
        setFlag(.negative, result & 0x80 == 0x80)

        return result
    }
}

private extension CPU {
    func pushToStack(byte: UInt8) {
        writeByte(0x0100 + stackPointer.asWord, data: byte)
        stackPointer = stackPointer.subtractingReportingOverflow(1).partialValue
    }

    func pushToStack(word: UInt16) {
        pushToStack(byte: word.highByte)
        pushToStack(byte: word.lowByte)
    }

    func pullByteFromStack() -> UInt8 {
        stackPointer = stackPointer.addingReportingOverflow(1).partialValue
        return readByte(0x0100 + stackPointer.asWord)
    }

    func pullWordFromStack() -> UInt16 {
        let lowByte = pullByteFromStack()
        let highByte = pullByteFromStack()
        return .createWord(highByte: highByte, lowByte: lowByte)
    }
}

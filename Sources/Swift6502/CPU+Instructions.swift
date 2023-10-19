import Foundation

extension CPU {
    typealias ShouldIncludeExtraClockCycles = Bool

    @discardableResult
    func perform(instruction: Instruction, addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        switch instruction {
        case .xxx: false
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
    func adc(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        // Overflow using `UInt8` results in an exception being thrown.
        // "Cheat" and use `UInt16` when adding instead.
        let valueToAdd = readByte(addressAbsolute).asWord + readFlag(.carry).value.asWord
        let newValue = acc.asWord + valueToAdd

        // Set carry.
        setFlag(.carry, newValue > 0xFF)

        // Set zero flag.
        setZeroFlag(using: newValue)

        // Set negative flag, if highest bit is set.
        setNegativeFlag(using: newValue)

        // Set overflow flag.
        // This flag should be set if the addition overflow in `Int8`, aka. if the result goes out of bounds of (-128 <-> +127).
        // Cast both `acc` and `valueToAdd` to `Int8`, add them and check if there's an overflow.
        let addResult = Int8(bitPattern: acc).addingReportingOverflow(Int8(bitPattern: UInt8(valueToAdd & 0xFF)))
        setFlag(.overflow, addResult.overflow)

        acc = UInt8(newValue & 0xFF)

        return true
    }

    // AND memory with accumulator.
    func and(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        let value = readByte(addressAbsolute)

        acc = acc & value

        setZeroFlag(using: acc)
        setNegativeFlag(using: acc)

        return true
    }

    // Shift left one bit (memory or accumulator).
    func asl(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
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
        setZeroFlag(using: value)
        setNegativeFlag(using: value)

        let byte = UInt8(value & 0x00FF)

        if addressMode == .imp {
            acc = byte
        } else {
            writeByte(addressAbsolute, data: byte)
        }

        return false
    }

    // Branch on carry clear.
    func bcc(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        if !readFlag(.carry) {
            setPcFromRelativeAddress()
        }
        return false
    }

    // Branch on carry set.
    func bcs(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        if readFlag(.carry) {
            setPcFromRelativeAddress()
        }
        return false
    }

    // Branch on result zero.
    func beq(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        if readFlag(.zero) {
            setPcFromRelativeAddress()
        }
        return false
    }

    // Test bits in memory with accumulator.
    func bit(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        let memory = readByte(addressAbsolute)

        // Set zero flag if AND == 0.
        setZeroFlag(using: acc & memory)

        // Test bits 7 and 6 in memory.
        setNegativeFlag(using: memory)
        setFlag(.overflow, memory & 0x40 == 0x40)

        return false
    }

    // Branch on result minus.
    func bmi(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        if readFlag(.negative) {
            setPcFromRelativeAddress()
        }
        return false
    }

    // Branch on result not zero.
    func bne(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        if !readFlag(.zero) {
            setPcFromRelativeAddress()
        }
        return false
    }

    // Branch on result plus.
    func bpl(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        if !readFlag(.negative) {
            setPcFromRelativeAddress()
        }
        return false
    }

    // Force break.
    func brk(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
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

        return false
    }

    // Branch on overflow clear.
    func bvc(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        if !readFlag(.overflow) {
            setPcFromRelativeAddress()
        }
        return false
    }

    // Branch on overflow set.
    func bvs(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        if readFlag(.overflow) {
            setPcFromRelativeAddress()
        }
        return false
    }

    // Clear carry flag.
    func clc(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        setFlag(.carry, false)
        return false
    }

    // Clear decimal mode.
    func cld(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        setFlag(.decimal, false)
        return false
    }

    // Clear interrupt disable bit.
    func cli(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        setFlag(.interrupt, false)
        return false
    }

    // Clear overflow flag.
    func clv(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        setFlag(.overflow, false)
        return false
    }

    // Compare memory with accumulator.
    func cmp(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        compareMemoryAgainst(acc)
        return true
    }

    // Compare memory with X.
    func cpx(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        compareMemoryAgainst(xReg)
        return false
    }

    // Compare memory with Y.
    func cpy(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        compareMemoryAgainst(yReg)
        return false
    }

    // Decrement memory by one.
    func dec(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        let value = readByte(addressAbsolute)
        let decremented = perform(.dec, on: value)
        writeByte(addressAbsolute, data: decremented)
        return false
    }

    // Decrement X by one.
    func dex(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        xReg = perform(.dec, on: xReg)
        return false
    }

    // Decrement Y by one.
    func dey(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        yReg = perform(.dec, on: yReg)
        return false
    }

    // Exclusive-OR memory with accumulator.
    func eor(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        let memory = readByte(addressAbsolute)

        acc = acc ^ memory

        setZeroFlag(using: acc)
        setNegativeFlag(using: acc)

        return true
    }

    // Increment memory by one.
    func inc(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        let value = readByte(addressAbsolute)
        let incremented = perform(.inc, on: value)
        writeByte(addressAbsolute, data: incremented)
        return false
    }

    // Increment X by one.
    func inx(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        xReg = perform(.inc, on: xReg)
        return false
    }

    // Increment Y by one.
    func iny(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        yReg = perform(.inc, on: yReg)
        return false
    }

    // Jump to new location.
    func jmp(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        pc = addressAbsolute
        return false
    }

    // Jump to new location, saving return address.
    func jsr(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        pc -= 1
        pushToStack(word: pc)
        pc = addressAbsolute

        return false
    }

    // Load accumulator.
    func lda(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        acc = readByte(addressAbsolute)

        setZeroFlag(using: acc)
        setNegativeFlag(using: acc)

        return false
    }

    // Load X register.
    func ldx(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        xReg = readByte(addressAbsolute)

        setZeroFlag(using: xReg)
        setNegativeFlag(using: xReg)

        return false
    }

    // Load Y register.
    func ldy(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        yReg = readByte(addressAbsolute)

        setZeroFlag(using: yReg)
        setNegativeFlag(using: yReg)

        return false
    }

    // Logical shift right (shifts in a zero bit on the left).
    func lsr(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
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

        setZeroFlag(using: value)

        // Can never be negative, since we don't push a bit onto bit 7.
        setFlag(.negative, false)

        let byte = UInt8(value & 0x00FF)

        if addressMode == .imp {
            acc = byte
        } else {
            writeByte(addressAbsolute, data: byte)
        }

        return false
    }

    // No operation.
    func nop(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        // TODO: Revisit NOPs that potentially uses more clock cycles.
        // I believe there exists a few NOP opcodes that will spend N clock cycles doing nothing.
        return false
    }

    // OR memory with accumulator.
    func ora(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        let value = readByte(addressAbsolute)

        acc = acc | value

        setZeroFlag(using: acc)
        setNegativeFlag(using: acc)

        return true
    }

    // Push accumulator on stack.
    func pha(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        pushToStack(byte: acc)
        return false
    }

    // Push processor status on stack.
    func php(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        pushToStack(byte: flags)
        return false
    }

    // Pull accumulator from stack.
    func pla(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        acc = pullByteFromStack()

        setZeroFlag(using: acc)
        setNegativeFlag(using: acc)

        return false
    }

    // Pull processor status from stack.
    func plp(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        flags = pullByteFromStack()
        return false
    }

    // Rotate one bit left (memory or accumulator).
    func rol(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
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
        setZeroFlag(using: value)
        setNegativeFlag(using: value)

        let byte = UInt8(value & 0x00FF)

        if addressMode == .imp {
            acc = byte
        } else {
            writeByte(addressAbsolute, data: byte)
        }

        return false
    }

    // Rotate one bit right (memory or accumulator).
    func ror(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
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
        setZeroFlag(using: value)
        setNegativeFlag(using: value)

        let byte = UInt8(value & 0x00FF)

        if addressMode == .imp {
            acc = byte
        } else {
            writeByte(addressAbsolute, data: byte)
        }

        return false
    }

    // Return from interrupt.
    func rti(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        flags = pullByteFromStack()
        pc = pullWordFromStack()

        return false
    }

    // Return from subroutine.
    func rts(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        pc = pullWordFromStack()
        pc += 1

        return false
    }

    /// Subtract memory from accumulator with borrow.
    ///
    /// References:
    /// - https://www.righto.com/2012/12/the-6502-overflow-flag-explained.html
    /// - http://forum.6502.org/viewtopic.php?f=1&t=7444
    /// - https://www.atariarchives.org/2bml/chapter_10.php
    func sbc(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
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
        setZeroFlag(using: newValue)
        setNegativeFlag(using: newValue)


        acc = UInt8(newValue & 0xFF)

        return false
    }

    // Set carry flag.
    func sec(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        setFlag(.carry, true)
        return false
    }

    // Set decimal flag.
    func sed(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        setFlag(.decimal, true)
        return false
    }

    // Set interrupt disable status.
    func sei(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        setFlag(.interrupt, true)
        return false
    }

    // Store accumulator in memory.
    func sta(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        writeByte(addressAbsolute, data: acc)
        return false
    }

    // Store X in memory.
    func stx(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        writeByte(addressAbsolute, data: xReg)
        return false
    }

    // Store Y in memory.
    func sty(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        writeByte(addressAbsolute, data: yReg)
        return false
    }

    // Transfer accumulator to X.
    func tax(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        xReg = acc

        setZeroFlag(using: xReg)
        setNegativeFlag(using: xReg)

        return false
    }

    // Transfer accumulator to Y.
    func tay(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        yReg = acc

        setZeroFlag(using: yReg)
        setNegativeFlag(using: yReg)

        return false
    }

    // Transfer stack pointer to X.
    func tsx(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        xReg = stackPointer

        setZeroFlag(using: xReg)
        setNegativeFlag(using: xReg)

        return false
    }

    // Transfer X to accumulator.
    func txa(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        acc = xReg

        setZeroFlag(using: acc)
        setNegativeFlag(using: acc)

        return false
    }

    // Transfer X to stack pointer.
    func txs(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        stackPointer = xReg
        return false
    }

    // Transfer Y to accumulator.
    func tya(addressMode: AddressMode) -> ShouldIncludeExtraClockCycles {
        acc = yReg

        setZeroFlag(using: acc)
        setNegativeFlag(using: acc)

        return false
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
        setZeroFlag(using: diff)
        setNegativeFlag(using: diff)
    }
}

// MARK: - Increment and decrement

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

        setZeroFlag(using: result)
        setNegativeFlag(using: result)

        return result
    }
}

// MARK: - Stack operations

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

// MARK: - Flag operations

private extension CPU {
    func setZeroFlag(using value: UInt8) {
        setFlag(.zero, value == 0x00)
    }

    func setZeroFlag(using value: UInt16) {
        setFlag(.zero, value & 0xFF == 0x00)
    }

    func setNegativeFlag(using value: UInt8) {
        setFlag(.negative, value & 0x80 == 0x80)
    }

    func setNegativeFlag(using value: UInt16) {
        setFlag(.negative, value & 0x80 == 0x80)
    }
}

import Foundation

extension CPU {
    typealias ExtraClockCycles = Int
    
    @discardableResult
    func setupAddressing(using addressMode: AddressMode) -> ExtraClockCycles {
        switch addressMode {
        case .imp: imp()
        case .imm: imm()
        case .zp0: zp0()
        case .zpx: zpx()
        case .zpy: zpy()
        case .rel: rel()
        case .abs: abs()
        case .abx: abx()
        case .aby: aby()
        case .ind: ind()
        case .izx: izx()
        case .izy: izy()
        }
    }
}

private extension CPU {
    /// Implied.
    ///
    /// I'm not sure how to handle this right now. Sometimes the accumulator is read, and sometimes it's an instruction with no parameters.
    private func imp() -> ExtraClockCycles {
        0
    }

    /// Immediate.
    ///
    /// The addressing mode will read the next byte as the data.
    /// This means that the program counter will already be pointing to this address.
    private func imm() -> ExtraClockCycles {
        addressAbsolute = pc
        pc += 1

        return 0
    }

    /// Zero page.
    ///
    /// Point a zero page address, aka the first page. `0x0000` to `0x00FF`.
    private func zp0() -> ExtraClockCycles {
        addressAbsolute = (readByte(pc)).asWord
        pc += 1
        return 0
    }

    /// Zero page, with X register offset.
    ///
    /// Point a zero page address, offset by the value in the X register.
    /// If the value with offset exceeds `0xFF` the value wraps around, which means we will
    /// always address an address within zero page.
    private func zpx() -> ExtraClockCycles {
        addressAbsolute = (readByte(pc) &+ xReg).asWord
        pc += 1
        
        return 0
    }

    /// Zero page, with Y register offset.
    ///
    /// Point a zero page address, offset by the value in the Y register.
    /// If the value with offset exceeds `0xFF` the value wraps around, which means we will
    /// always address an address within zero page.
    private func zpy() -> ExtraClockCycles {
        addressAbsolute = (readByte(pc) &+ yReg).asWord
        pc += 1

        return 0
    }

    /// Relative.
    ///
    /// Relative addressing allows for a navigating to an address within -128 to +127 of the program counter.
    private func rel() -> ExtraClockCycles {
        var addressRelative = readByte(pc).asWord
        pc += 1

        // If the relative offset is negative, we need to flip the highest bits so a "subtraction" will occur.
        if addressRelative & 0x80 == 0x80 {
            addressRelative |= 0xFF00
        }

        // Add the relative offset to the current program counter.
        addressAbsolute = pc &+ addressRelative

        // Return 2 clock cycles if page boundry was crossed.
        if !pc.isSamePage(as: addressAbsolute) {
            return 2
        }

        return 1
    }

    /// Absolute.
    ///
    /// Will read the two next bytes and form them into an address.
    /// Little-endian is used, so the first byte will contain the low byte and the second byte the high byte.
    /// Ex. the byte sequence `0xAA,0xFF` will form the address `0xFFAA`.
    private func abs() -> ExtraClockCycles {
        addressAbsolute = readWord(pc)
        pc += 2
        
        return 0
    }

    /// Absolute, with X offset.
    private func abx() -> ExtraClockCycles {
        let addressRead = readWord(pc)
        pc += 2
        
        addressAbsolute = addressRead &+ xReg.asWord

        // 1 extra clock cycle is used if page boundry is crossed.
        if !addressRead.isSamePage(as: addressAbsolute) {
            return 1
        }

        return 0
    }

    /// Absolute, with Y offset.
    private func aby() -> ExtraClockCycles {
        let addressRead = readWord(pc)
        pc += 2

        addressAbsolute = addressRead &+ yReg.asWord

        // 1 extra clock cycle is used if page boundry is crossed.
        if !addressRead.isSamePage(as: addressAbsolute) {
            return 1
        }

        return 0
    }

    
    /// Indirect, aka. pointer.
    ///
    /// The two next bytes form a 16-bit address from where the absolute address should be read from.
    /// Since the corresponding memory adress will only contain a single byte, we need to read `(pointer + 1) | pointer` to get
    /// the absolute address.
    private func ind() -> ExtraClockCycles {
        addressAbsolute = readWord(readWord(pc))
        pc += 2

        return 0
    }

    /// Indirect, aka. pointer. Read from zero page with X offset.
    ///
    /// The next byte contains a byte, `loc`, which points to a location in zero page. Add X to this value to get the offset.
    /// The pointer will point to this location, where we'll read the absolute address from:
    ///
    /// `((loc + X + 1) << 8) | (loc + X)`
    private func izx() -> ExtraClockCycles {
        // Make sure we wrap around in zero page, instead of incrementing page.
        let pointer = readByte(pc) &+ xReg
        addressAbsolute = readWord(pointer.asWord)
        pc += 1

        return 0
    }

    /// Indirect, aka. pointer. Read address from zero page, and offset this address with Y.
    ///
    /// The next byte contains a byte, `loc`, which points to a location in zero page. Add Y to this value to get the offset.
    /// The pointer will point to this location, where we'll read the absolute address from:
    ///
    /// `(((loc + 1) << 8) | loc) + Y`
    private func izy() -> ExtraClockCycles {
        // Read address from zero page pointer and add content of Y register.
        let zeroPagePointer = readByte(pc).asWord
        let addressRead = readWord(zeroPagePointer)
        addressAbsolute = addressRead &+ yReg.asWord

        pc += 1

        // Check if page boundry was crossed.
        if !addressRead.isSamePage(as: addressAbsolute) {
            return 1
        }

        return 0
    }
}

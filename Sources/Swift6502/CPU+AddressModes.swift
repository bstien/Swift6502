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
    /// The next byte will be read as the address from where to read data.
    private func imm() -> ExtraClockCycles {
        addressAbsolute = pc
        pc += 1

        return 0
    }

    /// Zero page.
    ///
    /// The value read from 
    private func zp0() -> ExtraClockCycles {
        addressAbsolute = (readByte(pc)).asWord
        pc += 1
        return 0
    }

    /// Zero page, with X offset.
    private func zpx() -> ExtraClockCycles {
        addressAbsolute = (readByte(pc) + xReg).asWord
        pc += 1
        addressAbsolute &= 0x00FF
        return 0
    }

    /// Zero page, with Y offset.
    private func zpy() -> ExtraClockCycles {
        addressAbsolute = (readByte(pc) + yReg).asWord
        pc += 1
        addressAbsolute &= 0x00FF
        return 0
    }

    /// Relative.
    private func rel() -> ExtraClockCycles {
        addressRelative = readByte(pc).asWord
        pc += 1

        // Relative addressing allows for a navigating to an address within -128 to +127 of `pc`.
        // If the relative offset is negative, we need to flip the bits so a "subtraction" will occur.
        if addressRelative & 0x80 == 0x80 {
            addressRelative |= 0xFF00
        }

        return 0
    }

    /// Absolute.
    private func abs() -> ExtraClockCycles {
        addressAbsolute = readWord(pc)
        pc += 2
        return 0
    }

    /// Absolute, with X offset.
    private func abx() -> ExtraClockCycles {
        let lowByte = readByte(pc)
        let highByte = readByte(pc + 1)
        pc += 2
        
        addressAbsolute = .createWord(highByte: highByte, lowByte: lowByte) + xReg.asWord

        // 1 extra clock cycle is used if page boundry is crossed.
        if ((addressAbsolute & 0xFF00) != (UInt16(highByte) << 8)) {
            return 1
        }

        return 0
    }

    /// Absolute, with Y offset.
    private func aby() -> ExtraClockCycles {
        let lowByte = readByte(pc)
        let highByte = readByte(pc + 1)
        pc += 2

        addressAbsolute = .createWord(highByte: highByte, lowByte: lowByte) + yReg.asWord

        // 1 extra clock cycle is used if page boundry is crossed.
        if ((addressAbsolute & 0xFF00) != (highByte.asWord << 8)) {
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
        let pointer = readByte(pc).asWord + xReg.asWord
        addressAbsolute = readWord(pointer)
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
        let zeroPagePointer = readByte(pc).asWord
        pc += 1

        // Read address from zero page pointer.
        let lowByte = readByte(zeroPagePointer)
        let highByte = readByte(zeroPagePointer + 1)

        addressAbsolute = .createWord(highByte: highByte, lowByte: lowByte) + yReg.asWord

        // Check if page boundry was crossed.
        if addressAbsolute & 0xFF00 != (highByte.asWord << 8) {
            return 1
        }

        return 0
    }
}

extension UInt8 {
    var asWord: UInt16 {
        UInt16(self)
    }
}

extension UInt16 {
    static func createWord(highByte: UInt8, lowByte: UInt8) -> UInt16 {
        (highByte.asWord << 8) | lowByte.asWord
    }
}

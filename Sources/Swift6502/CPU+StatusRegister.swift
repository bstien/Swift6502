import Foundation

extension CPU {
    // https://www.masswerk.at/6502/6502_instruction_set.html#registers
    enum StatusFlag: UInt8 {
        case negative     = 0b00000001  // Negative.
        case overflow     = 0b00000010  // Overflow.
        case unused       = 0b00000100  // Ignore – not in use.
        case `break`      = 0b00001000  // Break.
        case decimal      = 0b00010000  // Decimal (use BCD for arithmetics).
        case interrupt    = 0b00100000  // Interrupt (IRQ disable).
        case zero         = 0b01000000  // Zero.
        case carry        = 0b10000000  // Carry.
    }
}

import Foundation

extension CPU {
    // https://www.masswerk.at/6502/6502_instruction_set.html#registers
    enum StatusFlag: UInt8, CaseIterable {
        case negative     = 0b10000000  // Negative.
        case overflow     = 0b01000000  // Overflow.
        case unused       = 0b00100000  // Ignore – not in use.
        case `break`      = 0b00010000  // Break.
        case decimal      = 0b00001000  // Decimal (use BCD for arithmetics).
        case interrupt    = 0b00000100  // Interrupt (IRQ disable).
        case zero         = 0b00000010  // Zero.
        case carry        = 0b00000001  // Carry.

        var letter: String {
            switch self {
            case .negative:
                "N"
            case .overflow:
                "V"
            case .unused:
                "-"
            case .break:
                "B"
            case .decimal:
                "D"
            case .interrupt:
                "I"
            case .zero:
                "Z"
            case .carry:
                "C"
            }
        }
    }
}

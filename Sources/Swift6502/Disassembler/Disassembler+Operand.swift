import Foundation

extension Disassembler {
    enum Operand {
        case immediate(UInt8)
        case relative(UInt8)

        case zeroPage(UInt8)
        case zeroPageX(UInt8)
        case zeroPageY(UInt8)

        case absolute(UInt16)
        case absoluteX(UInt16)
        case absoluteY(UInt16)

        case indirect(UInt16)
        case indirectX(UInt8)
        case indirectY(UInt8)

        case none
    }
}

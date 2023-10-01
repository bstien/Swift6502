import Foundation

enum AddressMode {
    case imp    // Implied.
    case imm    // Immediate.
    case zp0    // Zero page.
    case zpx    // Zero page with X offset.
    case zpy    // Zero page with Y offset.
    case rel    // Relative.
    case abs    // Absolute.
    case abx    // Absolute with X offset.
    case aby    // Absolute with Y offset.
    case ind    // Indirect.
    case izx    // Indirect zero page with X offset.
    case izy    // Indirect zero page with Y offset.
}

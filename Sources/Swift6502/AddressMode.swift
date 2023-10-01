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

    func perform(cpu: CPU) -> UInt8 {
        switch self {
        case .imp: imp(cpu: cpu)
        case .imm: imm(cpu: cpu)
        case .zp0: zp0(cpu: cpu)
        case .zpx: zpx(cpu: cpu)
        case .zpy: zpy(cpu: cpu)
        case .rel: rel(cpu: cpu)
        case .abs: abs(cpu: cpu)
        case .abx: abx(cpu: cpu)
        case .aby: aby(cpu: cpu)
        case .ind: ind(cpu: cpu)
        case .izx: izx(cpu: cpu)
        case .izy: izy(cpu: cpu)
        }
    }
}

extension AddressMode {
    func imp(cpu: CPU) -> UInt8 {
        0
    }

    func imm(cpu: CPU) -> UInt8 {
        0
    }

    func zp0(cpu: CPU) -> UInt8 {
        0
    }

    func zpx(cpu: CPU) -> UInt8 {
        0
    }

    func zpy(cpu: CPU) -> UInt8 {
        0
    }

    func rel(cpu: CPU) -> UInt8 {
        0
    }

    func abs(cpu: CPU) -> UInt8 {
        0
    }

    func abx(cpu: CPU) -> UInt8 {
        0
    }

    func aby(cpu: CPU) -> UInt8 {
        0
    }

    func ind(cpu: CPU) -> UInt8 {
        0
    }

    func izx(cpu: CPU) -> UInt8 {
        0
    }

    func izy(cpu: CPU) -> UInt8 {
        0
    }
}

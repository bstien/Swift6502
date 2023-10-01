import Foundation

extension CPU {
    func setupAddressing(using addressMode: AddressMode) -> UInt8 {
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
    private func imp() -> UInt8 {
        0
    }

    private func imm() -> UInt8 {
        0
    }

    private func zp0() -> UInt8 {
        0
    }

    private func zpx() -> UInt8 {
        0
    }

    private func zpy() -> UInt8 {
        0
    }

    private func rel() -> UInt8 {
        0
    }

    private func abs() -> UInt8 {
        0
    }

    private func abx() -> UInt8 {
        0
    }

    private func aby() -> UInt8 {
        0
    }

    private func ind() -> UInt8 {
        0
    }

    private func izx() -> UInt8 {
        0
    }

    private func izy() -> UInt8 {
        0
    }
}

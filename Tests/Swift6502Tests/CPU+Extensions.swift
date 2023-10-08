@testable import Swift6502

extension CPU {
    static func create(
        ram: [UInt8],
        acc: UInt8 = 0x00,
        pc: UInt16 = 0x0000,
        xReg: UInt8 = 0x00,
        yReg: UInt8 = 0x00
    ) -> CPU {
        CPU(
            bus: Bus(ram: ram),
            pc: pc,
            stackPointer: 0x00,
            acc: acc,
            xReg: xReg,
            yReg: yReg,
            flags: 0x00
        )
    }
}


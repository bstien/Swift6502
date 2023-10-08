@testable import Swift6502

extension CPU {
    static func create(
        ram: [UInt8],
        acc: UInt8 = 0x00,
        pc: UInt16 = 0x0000,
        stackPointer: UInt8 = 0xFF,
        xReg: UInt8 = 0x00,
        yReg: UInt8 = 0x00
    ) -> CPU {
        CPU(
            bus: Bus(ram: ram),
            pc: pc,
            stackPointer: stackPointer,
            acc: acc,
            xReg: xReg,
            yReg: yReg,
            flags: 0x00
        )
    }
}


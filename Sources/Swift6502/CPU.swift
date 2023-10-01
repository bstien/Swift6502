import Foundation

class CPU {
    
    // MARK: - Internal properties

    var pc: UInt16 = 0x0000
    var stackPointer: UInt8 = 0x00
    var acc: UInt8 = 0x00
    var xReg: UInt8 = 0x00
    var yReg: UInt8 = 0x00
    var flags: UInt8 = 0x00

    // MARK: - Private properties

    private let bus: Bus

    // MARK: - Init

    init(
        bus: Bus = Bus(),
        pc: UInt16 = 0x0000,
        stackPointer: UInt8 = 0x00,
        acc: UInt8 = 0x00,
        xReg: UInt8 = 0x00,
        yReg: UInt8 = 0x00,
        flags: UInt8 = 0x00
    ) {
        self.bus = bus
        self.pc = pc
        self.stackPointer = stackPointer
        self.acc = acc
        self.xReg = xReg
        self.yReg = yReg
        self.flags = flags
    }

    // MARK: - Communicate with bus

    func readByte(_ address: UInt16) -> UInt8 {
        bus.read(address)
    }

    func writeByte(_ address: UInt16, data: UInt8) {
        bus.write(address, data: data)
    }

    // MARK: - Flags

    func setFlag(_ flag: StatusFlag, _ isOn: Bool) {
        if isOn {
            // OR the current flags against the given flag.
            flags |= flag.rawValue
        } else {
            // AND the current flags against the flipped bits on the given flag.
            flags &= ~flag.rawValue
        }
    }

    func readFlag(_ flag: StatusFlag) -> UInt8 {
        (flags & flag.rawValue) > 0 ? 1 : 0
    }
}

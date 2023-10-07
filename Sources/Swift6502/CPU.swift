import Foundation

class CPU {
    
    // MARK: - Internal properties

    var pc: UInt16 = 0x0000
    var stackPointer: UInt8 = 0x00
    var acc: UInt8 = 0x00
    var xReg: UInt8 = 0x00
    var yReg: UInt8 = 0x00
    var flags: UInt8 = 0x00

    // These are separated, but they can probably be combined into a single variable. Check what's possible.
    // Maybe the `AddressMode` can return an adress instead?
    var addressAbsolute: UInt16 = 0x0000
    var addressRelative: UInt16 = 0x0000

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

    
    /// Reads a single byte from memory.
    /// - Parameter address: The memory address.
    /// - Returns: A byte from memory.
    func readByte(_ address: UInt16) -> UInt8 {
        bus.read(address)
    }

    /// Creates a word from bytes read from `address` and `address + 1`.
    /// - Parameter address: The address in memory where the word to read starts.
    /// - Returns: A word.
    func readWord(_ address: UInt16) -> UInt16 {
        let lowByte = readByte(address)
        let highByte = readByte(address + 1)

        return .createWord(highByte: highByte, lowByte: lowByte)
    }
    
    /// Writes a single byte to memory.
    /// - Parameters:
    ///   - address: The address where to store the data.
    ///   - data: A byte.
    func writeByte(_ address: UInt16, data: UInt8) {
        bus.write(address, data: data)
    }

    // MARK: - Flags
    
    /// Sets a status flag either on or off.
    /// - Parameters:
    ///   - flag: The flag to set.
    ///   - isOn: Whether the flag is on or not.
    func setFlag(_ flag: StatusFlag, _ isOn: Bool) {
        if isOn {
            // OR the current flags against the given flag.
            flags |= flag.rawValue
        } else {
            // AND the current flags against the flipped bits on the given flag.
            flags &= ~flag.rawValue
        }
    }
    
    /// Reads the state of a flag from the status register.
    /// - Parameter flag: The flag to read.
    /// - Returns: A `Bool` to indicate whether the flag is enabled or not.
    func readFlag(_ flag: StatusFlag) -> Bool {
        (flags & flag.rawValue) > 0
    }
}

extension Bool {
    var value: UInt8 {
        switch self {
        case true: 1
        case false: 0
        }
    }
}

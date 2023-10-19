import Foundation

class Disassembler: CPU {

    // MARK: - Private properties

    private var program: [UInt8]
    private var operations = [Operation]()

    // MARK: - Init

    init(program: [UInt8], pc: UInt16 = 0x00) {
        self.program = program

        super.init(
            bus: Bus(ram: .createRam(withProgram: program)),
            pc: pc
        )
    }

    // MARK: - Internal methods

    func disassemble() -> [String] {
        operations = []

        while program.isWithinBounds(pc) {
            let offset = pc
            let opcodeByte = readByte(pc)
            pc += 1

            // Read byte and setup addressing mode.
            let opcode = Self.opcodes[Int(opcodeByte)]
            setupAddressing(using: opcode.1)

            let operand = getOperand(using: opcode.1)

            let operation = Operation(offset: offset, opcode: opcodeByte, instruction: opcode.0, operand: operand)

            operations.append(operation)
        }

        // Map operations to String and return it.
        return operations.map { $0.asCode }
    }

    // MARK: - Private methods

    private func getOperand(using addressMode: AddressMode) -> Operand {
        switch addressMode {
        case .imp:
            return .none
        case .imm:
            return .immediate(readByte(pc - 1))
        case .zp0:
            return .zeroPage(readByte(pc - 1))
        case .zpx:
            return .zeroPageX(readByte(pc - 1))
        case .zpy:
            return .zeroPageY(readByte(pc - 1))
        case .rel:
            return .relative(readByte(pc - 1))
        case .abs:
            return .absolute(readWord(pc - 2))
        case .abx:
            return .absoluteX(readWord(pc - 2))
        case .aby:
            return .absoluteY(readWord(pc - 2))
        case .ind:
            return .indirect(readWord(pc - 2))
        case .izx:
            return .indirectX(readByte(pc - 1))
        case .izy:
            return .indirectY(readByte(pc - 1))
        }
    }
}

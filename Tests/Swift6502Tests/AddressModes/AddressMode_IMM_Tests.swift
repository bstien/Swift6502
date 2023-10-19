import XCTest
@testable import Swift6502
import Nimble

class AddressMode_IMM_Tests: XCTestCase {
    func test_simple_example() {
        // The immediate addressing mode will read the next byte as the data.
        // This means that the program counter will already be pointing to this address.
        let cpu = CPU.create(ram: [], pc: 0xAAAA)

        cpu.setupAddressing(using: .imm)

        // Given that the program counter is already
        expect(cpu.addressAbsolute) == 0xAAAA
        expect(cpu.pc) == 0xAAAB
    }

    func test_extra_cycles() {
        let cpu = CPU.create(ram: [])

        let extraCycles = cpu.setupAddressing(using: .imm)

        expect(extraCycles) == 0
    }
}

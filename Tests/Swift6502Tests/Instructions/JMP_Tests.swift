import XCTest
@testable import Swift6502
import Nimble

class JMP_Tests: XCTestCase {
    func test_it_sets_using_absolute_address() {
        let cpu = CPU.create(ram: [0xBB, 0xAA])
        cpu.setupAddressing(using: .abs)

        cpu.perform(instruction: .jmp, addressMode: .abs)

        expect(cpu.pc) == 0xAABB
    }

    func test_it_sets_using_indirect_address() {
        let cpu = CPU.create(ram: [0x02, 0x00, 0xBB, 0xAA])
        cpu.setupAddressing(using: .ind)

        cpu.perform(instruction: .jmp, addressMode: .ind)

        expect(cpu.pc) == 0xAABB
    }
}

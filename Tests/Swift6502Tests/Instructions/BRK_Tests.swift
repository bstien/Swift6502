import XCTest
@testable import Swift6502
import Nimble

class BRK_Tests: XCTestCase {
    func test_it_pulls_program_counter_from_stack() {
        let initialRam = Array.createRam(using: [
            // Interrupt vector.
            0xFFFE: 0xBB,
            0xFFFF: 0xAA
        ])

        let cpu = CPU.create(ram: initialRam)
        cpu.setupAddressing(using: .imp)

        // Set current PC and flags. PC will be incremented.
        cpu.pc = 0xFA
        cpu.flags = 0x00

        cpu.perform(instruction: .brk, addressMode: .imp)

        expect(cpu.pc) == 0xAABB
        expect(cpu.readWord(0x01FE)) == 0xFB
        expect(cpu.readByte(0x01FD)) == CPU.StatusFlag.interrupt.rawValue | CPU.StatusFlag.break.rawValue
    }
}

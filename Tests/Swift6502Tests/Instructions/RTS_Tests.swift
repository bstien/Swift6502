import XCTest
@testable import Swift6502
import Nimble

class RTS_Tests: XCTestCase {
    func test_it_pulls_program_counter_from_stack() {
        let cpu = CPU.create(ram: .prepareForStack() + [0x00, 0xBB, 0xAA], stackPointer: 0x00)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .rts, addressMode: .imp)

        expect(cpu.pc) == 0xAABC
    }
}

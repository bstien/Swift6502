import XCTest
@testable import Swift6502
import Nimble

class RTI_Tests: XCTestCase {
    func test_it_pulls_status_and_program_counter_from_stack() {
        let cpu = CPU.create(ram: .prepareForStack() + [0x00, 0xFF, 0xBB, 0xAA], stackPointer: 0x00)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .rti, addressMode: .imp)

        expect(cpu.flags) == 0xFF
        expect(cpu.pc) == 0xAABB
    }
}

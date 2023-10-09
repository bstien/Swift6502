import XCTest
@testable import Swift6502
import Nimble

class JSR_Tests: XCTestCase {
    func test_it_pushes_current_pc_onto_stack() {
        let cpu = CPU.create(
            ram: .prepareForStack(startData: [0xBB, 0xAA, 0x00]) + [0x11, 0x11, 0x11, 0x11],
            stackPointer: 0x03
        )
        cpu.setupAddressing(using: .abs)

        cpu.perform(instruction: .jsr, addressMode: .abs)

        expect(cpu.pc) == 0xAABB
        expect(cpu.readWord(0x0102)) == 0x0001 // The location for the next instruction after JSR, minus 1.
        expect(cpu.stackPointer) == 0x01
    }
}

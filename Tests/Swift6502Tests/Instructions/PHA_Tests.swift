import XCTest
@testable import Swift6502
import Nimble

class PHA_Tests: XCTestCase {
    func test_it_transfers_the_stack_pointer() {
        let cpu = CPU.create(ram: .prepareForStack() + [0x00, 0x00, 0x00], acc: 0xFF, stackPointer: 0x02)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .pha, addressMode: .imp)

        expect(cpu.readByte(0x0102)) == 0xFF
        expect(cpu.stackPointer) == 0x01
    }
}

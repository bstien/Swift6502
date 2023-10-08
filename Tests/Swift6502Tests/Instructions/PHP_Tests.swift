import XCTest
@testable import Swift6502
import Nimble

class PHP_Tests: XCTestCase {
    func test_it_transfers_the_stack_pointer() {
        let cpu = CPU.create(ram: .prepareForStack() + [0x00, 0x00, 0x00], stackPointer: 0x02)
        cpu.setupAddressing(using: .imp)

        cpu.flags = 0xAA

        cpu.perform(instruction: .php, addressMode: .imp)

        expect(cpu.readByte(0x0102)) == 0xAA
        expect(cpu.stackPointer) == 0x01
    }
}

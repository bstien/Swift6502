import XCTest
@testable import Swift6502
import Nimble

class PLP_Tests: XCTestCase {
    func test_it_pulls_the_status_register() {
        let cpu = CPU.create(ram: .prepareForStack() + [0x00, 0x00, 0xFF], stackPointer: 0x01)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .plp, addressMode: .imp)

        expect(cpu.flags) == 0xFF
        expect(cpu.stackPointer) == 0x02
    }
}

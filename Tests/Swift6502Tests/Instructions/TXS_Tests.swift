import XCTest
@testable import Swift6502
import Nimble

class TXS_Tests: XCTestCase {
    func test_it_sets_the_stack_pointer() {
        let cpu = CPU.create(ram: [], stackPointer: 0xFF, xReg: 0xAA)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .txs, addressMode: .imp)

        expect(cpu.stackPointer) == 0xAA
    }
}

import XCTest
@testable import Swift6502
import Nimble

class AddressMode_IND_Tests: XCTestCase {
    func test_simple_example() {
        let cpu = CPU.create(ram: [0x02, 0x00, 0xAA, 0xFF])

        cpu.setupAddressing(using: .ind)

        expect(cpu.addressAbsolute) == 0xFFAA
        expect(cpu.pc) == 0x02
    }
}

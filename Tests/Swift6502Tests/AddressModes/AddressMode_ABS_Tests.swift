import XCTest
@testable import Swift6502
import Nimble

class AddressMode_ABS_Tests: XCTestCase {
    func test_simple_example() {
        let cpu = CPU.create(ram: [0xAA, 0xFF])

        cpu.setupAddressing(using: .abs)

        expect(cpu.addressAbsolute) == 0xFFAA
        expect(cpu.pc) == 0x02
    }
}

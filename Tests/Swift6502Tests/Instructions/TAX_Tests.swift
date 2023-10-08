import XCTest
@testable import Swift6502
import Nimble

class TAX_Tests: XCTestCase {
    func test_it_stores() {
        let cpu = CPU.create(ram: [], acc: 0xFF)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .tax, addressMode: .imp)

        expect(cpu.xReg) == 0xFF
    }
}

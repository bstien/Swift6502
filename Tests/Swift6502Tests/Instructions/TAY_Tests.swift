import XCTest
@testable import Swift6502
import Nimble

class TAY_Tests: XCTestCase {
    func test_it_stores() {
        let cpu = CPU.create(ram: [], acc: 0xFF)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .tay, addressMode: .imp)

        expect(cpu.yReg) == 0xFF
    }
}

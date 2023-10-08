import XCTest
@testable import Swift6502
import Nimble

class STY_Tests: XCTestCase {
    func test_it_stores() {
        let cpu = CPU.create(ram: [0x01, 0x00], yReg: 0xFF)
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .sty, addressMode: .zp0)

        expect(cpu.readByte(0x01)) == 0xFF
    }
}

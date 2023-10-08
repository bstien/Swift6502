import XCTest
@testable import Swift6502
import Nimble

class STA_Tests: XCTestCase {
    func test_it_stores() {
        let cpu = CPU.create(ram: [0x01, 0x00], acc: 0xFF)
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .sta, addressMode: .zp0)

        expect(cpu.readByte(0x01)) == 0xFF
    }
}

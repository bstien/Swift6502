import XCTest
@testable import Swift6502
import Nimble

class ProgramTest: XCTestCase {
    // Disassembler: https://www.masswerk.at/6502/disassembler.html
    func test_jsr_and_increment_loop() {
        let code: [UInt8] = [0x20, 0x09, 0x00, 0x20, 0x0C, 0x00, 0x20, 0x12, 0x00, 0xA2, 0x00, 0x60, 0xE8, 0xE0, 0x05, 0xD0, 0xFB, 0x60, 0x00]
        let cpu = CPU.create(ram: .createRam(using: code))

        cpu.run()

        expect(cpu.xReg) == 5
    }
}

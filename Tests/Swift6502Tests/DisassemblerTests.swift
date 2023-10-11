import XCTest
@testable import Swift6502
import Nimble

class DisassemblerTests: XCTestCase {
    func test_it_disassembles() {
        let disassembler = Disassembler(data: [0x20, 0x09, 0x00, 0x20, 0x0C, 0x00, 0x20, 0x12, 0x00, 0xA2, 0x00, 0x60, 0xE8, 0xE0, 0x05, 0xD0, 0xFB, 0x60, 0x00])

        let code = disassembler.disassemble()

        expect(code) == [
            "JSR $0009",
            "JSR $000C",
            "JSR $0012",
            "LDX #$00",
            "RTS",
            "INX",
            "CPX #$05",
            "BNE $000C",
            "RTS",
            "BRK"
        ]
    }
}

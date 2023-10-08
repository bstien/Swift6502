import XCTest
@testable import Swift6502
import Nimble

class TYA_Tests: XCTestCase {
    func test_it_stores() {
        let cpu = CPU.create(ram: [], yReg: 0xFF)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .tya, addressMode: .imp)

        expect(cpu.acc) == 0xFF
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [], yReg: 0x00)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .tya, addressMode: .imp)

        expect(cpu.acc) == 0x00
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [], yReg: 0x80)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .tya, addressMode: .imp)

        expect(cpu.acc) == 0x80
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == true
    }
}

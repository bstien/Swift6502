import XCTest
@testable import Swift6502
import Nimble

class DEY_Tests: XCTestCase {
    func test_it_decrements() {
        let cpu = CPU.create(ram: [], yReg: 0x0F)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .dey, addressMode: .imp)

        expect(cpu.yReg) == 0x0E

        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_overflows() {
        let cpu = CPU.create(ram: [], yReg: 0x00)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .dey, addressMode: .imp)

        expect(cpu.yReg) == 0xFF

        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == true
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [], yReg: 0x01)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .dey, addressMode: .imp)

        expect(cpu.yReg) == 0x00

        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [], yReg: 0xFF)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .dey, addressMode: .imp)

        expect(cpu.yReg) == 0xFE

        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == true
    }
}

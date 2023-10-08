import XCTest
@testable import Swift6502
import Nimble

class INX_Tests: XCTestCase {
    func test_it_increments() {
        let cpu = CPU.create(ram: [], xReg: 0x0F)
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .inx, addressMode: .zp0)

        expect(cpu.xReg) == 0x10
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_overflows() {
        let cpu = CPU.create(ram: [], xReg: 0xFF)
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .inx, addressMode: .zp0)

        expect(cpu.xReg) == 0x00
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [], xReg: 0xFF)
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .inx, addressMode: .zp0)

        expect(cpu.xReg) == 0x00
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [], xReg: 0xFE)
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .inx, addressMode: .zp0)

        expect(cpu.xReg) == 0xFF
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == true
    }
}

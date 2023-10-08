import XCTest
@testable import Swift6502
import Nimble

class INY_Tests: XCTestCase {
    func test_it_increments() {
        let cpu = CPU.create(ram: [], yReg: 0x0F)
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .iny, addressMode: .zp0)

        expect(cpu.yReg) == 0x10
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_overflows() {
        let cpu = CPU.create(ram: [], yReg: 0xFF)
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .iny, addressMode: .zp0)

        expect(cpu.yReg) == 0x00
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [], yReg: 0xFF)
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .iny, addressMode: .zp0)

        expect(cpu.yReg) == 0x00
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [], yReg: 0xFE)
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .iny, addressMode: .zp0)

        expect(cpu.yReg) == 0xFF
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == true
    }
}

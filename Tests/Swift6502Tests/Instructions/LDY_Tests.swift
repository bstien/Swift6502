import XCTest
@testable import Swift6502
import Nimble

class LDY_Tests: XCTestCase {
    func test_it_loads_memory() {
        let cpu = CPU.create(ram: [0x0F])
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .ldy, addressMode: .imm)

        expect(cpu.yReg) == 0x0F
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [0x00])
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .ldy, addressMode: .imm)

        expect(cpu.yReg) == 0x00
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [0xF0])
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .ldy, addressMode: .imm)

        expect(cpu.yReg) == 0xF0
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == true
    }
}

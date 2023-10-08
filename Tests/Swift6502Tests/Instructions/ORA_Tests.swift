import XCTest
@testable import Swift6502
import Nimble

class ORA_Tests: XCTestCase {
    func test_simple_addition() {
        let cpu = CPU.create(ram: [0x3F], acc: 0xF3)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .ora, addressMode: .imm)

        expect(cpu.acc) == 0xFF
        expect(cpu.readFlag(.negative)) == true
        expect(cpu.readFlag(.zero)) == false
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [0x00], acc: 0x00)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .ora, addressMode: .imm)

        expect(cpu.acc) == 0x00
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == true
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [0x80], acc: 0x0F)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .ora, addressMode: .imm)

        expect(cpu.acc) == 0x8F
        expect(cpu.readFlag(.negative)) == true
        expect(cpu.readFlag(.zero)) == false
    }
}

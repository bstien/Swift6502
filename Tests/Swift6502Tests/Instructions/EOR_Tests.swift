import XCTest
@testable import Swift6502
import Nimble

class EOR_Tests: XCTestCase {
    func test_simple_xor() {
        let cpu = CPU.create(ram: [0x3F], acc: 0xF3)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .eor, addressMode: .imm)

        expect(cpu.acc) == 0xCC
        expect(cpu.readFlag(.negative)) == true
        expect(cpu.readFlag(.zero)) == false
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [0x0F], acc: 0x0F)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .eor, addressMode: .imm)

        expect(cpu.acc) == 0x00
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == true
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [0x80], acc: 0x70)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .eor, addressMode: .imm)

        expect(cpu.acc) == 0xF0
        expect(cpu.readFlag(.negative)) == true
        expect(cpu.readFlag(.zero)) == false
    }
}

import XCTest
@testable import Swift6502
import Nimble

class CPX_Tests: XCTestCase {
    func test_it_sets_carry_if_acc_is_bigger() {
        let cpu = CPU.create(ram: [0xAA], xReg: 0xBB)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .cpx, addressMode: .imm)

        expect(cpu.readFlag(.carry)) == true
    }

    func test_it_clears_carry_if_acc_is_smaller() {
        let cpu = CPU.create(ram: [0xBB], xReg: 0xAA)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .cpx, addressMode: .imm)

        expect(cpu.readFlag(.carry)) == false
    }

    func test_it_sets_zero_if_equal() {
        let cpu = CPU.create(ram: [0xFA], xReg: 0xFA)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .cpx, addressMode: .imm)

        expect(cpu.readFlag(.zero)) == true
    }

    func test_it_clears_zero_if_not_equal() {
        let cpu = CPU.create(ram: [0x00], xReg: 0xFA)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .cpx, addressMode: .imm)

        expect(cpu.readFlag(.zero)) == false
    }

    func test_it_sets_negative_flag_if_negative_result() {
        let cpu = CPU.create(ram: [0x02], xReg: 0x01)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .cpx, addressMode: .imm)

        expect(cpu.readFlag(.negative)) == true
    }

    func test_it_clears_negative_flag_if_positive_result() {
        let cpu = CPU.create(ram: [0x02], xReg: 0x0F)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .cpx, addressMode: .imm)

        expect(cpu.readFlag(.negative)) == false
    }
}

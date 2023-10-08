import XCTest
@testable import Swift6502
import Nimble

class ADC_Tests: XCTestCase {
    func test_simple_addition() {
        let cpu = CPU.create(ram: [0x03], acc: 0x02)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .adc, addressMode: .imm)

        expect(cpu.acc) == 0x05

        expect(cpu.readFlag(.carry)) == false
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.overflow)) == false
    }

    func test_it_includes_carry_flag() {
        let cpu = CPU.create(ram: [0x03], acc: 0x02)
        cpu.setupAddressing(using: .imm)

        cpu.setFlag(.carry, true)

        cpu.perform(instruction: .adc, addressMode: .imm)

        expect(cpu.acc) == 0x06
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [0xFF], acc: 0x01)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .adc, addressMode: .imm)
        expect(cpu.acc) == 0x00
        expect(cpu.readFlag(.zero)) == true
    }

    func test_it_sets_carry_flag() {
        let cpu = CPU.create(ram: [0xFF], acc: 0x01)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .adc, addressMode: .imm)
        expect(cpu.acc) == 0x00
        expect(cpu.readFlag(.carry)) == true
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [0x7F], acc: 0x01)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .adc, addressMode: .imm)
        expect(cpu.acc) == 0x80
        expect(cpu.readFlag(.negative)) == true
    }

    func test_it_sets_overflow_flag() {
        let cpu = CPU.create(ram: [0x7F], acc: 0x01)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .adc, addressMode: .imm)
        expect(cpu.acc) == 0x80
        expect(cpu.readFlag(.overflow)) == true
    }
}

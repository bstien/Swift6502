import XCTest
@testable import Swift6502
import Nimble

class SBC_Tests: XCTestCase {
    func test_simple_subtraction() {
        let cpu = CPU.create(ram: [0x04], acc: 0x06)
        cpu.setupAddressing(using: .imm)

        // Carry must be set in order to **remove the borrow**.
        cpu.setFlag(.carry, true)
        cpu.perform(instruction: .sbc, addressMode: .imm)

        expect(cpu.acc) == 0x02
        expect(cpu.readFlag(.carry)) == true
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.overflow)) == false
    }

    func test_simple_subtraction_with_memory() {
        let cpu = CPU.create(ram: [0x02, 0x00, 0x04], acc: 0x06)
        cpu.setupAddressing(using: .abs)

        cpu.setFlag(.carry, true)
        cpu.perform(instruction: .sbc, addressMode: .abs)

        expect(cpu.acc) == 0x02
        expect(cpu.readFlag(.carry)) == true
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.overflow)) == false
    }

    func test_it_includes_carry_flag_as_borrow() {
        let cpu = CPU.create(ram: [0x03], acc: 0x09)
        cpu.setupAddressing(using: .imm)

        // Set to 0 to add a borrow.
        cpu.setFlag(.carry, false)
        cpu.perform(instruction: .sbc, addressMode: .imm)

        expect(cpu.acc) == 0x05
        expect(cpu.readFlag(.carry)) == true
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.overflow)) == false
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [0x01], acc: 0x01)
        cpu.setupAddressing(using: .imm)

        cpu.setFlag(.carry, true)
        cpu.perform(instruction: .sbc, addressMode: .imm)
        
        expect(cpu.acc) == 0x00
        expect(cpu.readFlag(.carry)) == true
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.overflow)) == false
    }

    func test_it_sets_carry_flag() {
        let cpu = CPU.create(ram: [0xFE], acc: 0xFF)
        cpu.setupAddressing(using: .imm)

        cpu.setFlag(.carry, false)
        cpu.perform(instruction: .sbc, addressMode: .imm)
        
        expect(cpu.acc) == 0x00
        expect(cpu.readFlag(.carry)) == true
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.overflow)) == false
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [0x7F], acc: 0x01)
        cpu.setupAddressing(using: .imm)

        cpu.setFlag(.carry, true)
        cpu.perform(instruction: .sbc, addressMode: .imm)
        
        expect(cpu.acc) == 0x82
        expect(cpu.readFlag(.carry)) == false
        expect(cpu.readFlag(.negative)) == true
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.overflow)) == false
    }

    func test_it_sets_overflow_flag() {
        let cpu = CPU.create(ram: [0x80], acc: 0x80)
        cpu.setupAddressing(using: .imm)

        cpu.setFlag(.carry, true)
        cpu.perform(instruction: .sbc, addressMode: .imm)
        
        expect(cpu.acc) == 0x00
        expect(cpu.readFlag(.carry)) == true
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.overflow)) == false
    }
}

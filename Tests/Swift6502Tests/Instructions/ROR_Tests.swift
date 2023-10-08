import XCTest
@testable import Swift6502
import Nimble

class ROR_Tests: XCTestCase {
    func test_accumulator() {
        let cpu = CPU.create(ram: [], acc: 0x08)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .ror, addressMode: .imp)

        expect(cpu.acc) == 0x04
        expect(cpu.readFlag(.carry)) == false
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == false
    }

    func test_memory() {
        let cpu = CPU.create(ram: [0x08])
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .ror, addressMode: .imm)

        expect(cpu.readByte(0x00)) == 0x04
        expect(cpu.readFlag(.carry)) == false
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == false
    }

    func test_with_carry_set() {
        let cpu = CPU.create(ram: [], acc: 0x08)
        cpu.setupAddressing(using: .imp)
        cpu.setFlag(.carry, true)

        cpu.perform(instruction: .ror, addressMode: .imp)

        expect(cpu.acc) == 0x84
        expect(cpu.readFlag(.carry)) == false
        expect(cpu.readFlag(.negative)) == true
        expect(cpu.readFlag(.zero)) == false
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [], acc: 0x01)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .ror, addressMode: .imp)

        expect(cpu.acc) == 0x00
        expect(cpu.readFlag(.carry)) == true
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == true
    }

    func test_it_sets_carry_flag() {
        let cpu = CPU.create(ram: [], acc: 0xFF)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .ror, addressMode: .imp)

        expect(cpu.acc) == 0x7F
        expect(cpu.readFlag(.carry)) == true
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == false
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [], acc: 0x01)
        cpu.setupAddressing(using: .imp)
        cpu.setFlag(.carry, true)

        cpu.perform(instruction: .ror, addressMode: .imp)

        expect(cpu.acc) == 0x80
        expect(cpu.readFlag(.carry)) == true
        expect(cpu.readFlag(.negative)) == true
        expect(cpu.readFlag(.zero)) == false
    }
}

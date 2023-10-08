import XCTest
@testable import Swift6502
import Nimble

class ASL_Tests: XCTestCase {
    func test_accumulator() {
        let cpu = CPU.create(ram: [], acc: 0x08)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .asl, addressMode: .imp)

        expect(cpu.acc) == 0x10
        expect(cpu.readFlag(.carry)) == false
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == false
    }

    func test_memory() {
        let cpu = CPU.create(ram: [0x08])
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .asl, addressMode: .imm)

        expect(cpu.readByte(0x00)) == 0x10
        expect(cpu.readFlag(.carry)) == false
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == false
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [], acc: 0x40)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .asl, addressMode: .imp)
        
        expect(cpu.acc) == 0x80
        expect(cpu.readFlag(.carry)) == false
        expect(cpu.readFlag(.negative)) == true
        expect(cpu.readFlag(.zero)) == false
    }

    func test_it_sets_carry_flag() {
        let cpu = CPU.create(ram: [], acc: 0xAA)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .asl, addressMode: .imp)
        
        expect(cpu.acc) == 0b01010100
        expect(cpu.readFlag(.carry)) == true
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == false
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [], acc: 0x70)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .asl, addressMode: .imp)
        
        expect(cpu.acc) == 0xE0
        expect(cpu.readFlag(.carry)) == false
        expect(cpu.readFlag(.negative)) == true
        expect(cpu.readFlag(.zero)) == false
    }
}

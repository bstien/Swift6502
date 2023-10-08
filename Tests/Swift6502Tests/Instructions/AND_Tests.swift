import XCTest
@testable import Swift6502
import Nimble

class AND_Tests: XCTestCase {
    func test_simple_example() {
        let cpu = CPU.create(ram: [0x3F], acc: 0xF3)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .and, addressMode: .imm)

        expect(cpu.acc) == 0x33
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.zero)) == false
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [0x0F], acc: 0xF0)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .and, addressMode: .imm)
        
        expect(cpu.acc) == 0x00
        expect(cpu.readFlag(.zero)) == true
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [0x80], acc: 0xFF)
        cpu.setupAddressing(using: .imm)

        cpu.perform(instruction: .and, addressMode: .imm)
        
        expect(cpu.acc) == 0x80
        expect(cpu.readFlag(.negative)) == true
    }
}

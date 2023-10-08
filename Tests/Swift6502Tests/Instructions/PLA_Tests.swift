import XCTest
@testable import Swift6502
import Nimble

class PLA_Tests: XCTestCase {
    func test_it_pulls_the_accumulator() {
        let cpu = CPU.create(ram: .prepareForStack() + [0x00, 0x00, 0xFA], stackPointer: 0x01)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .pla, addressMode: .imp)

        expect(cpu.acc) == 0xFA
        expect(cpu.stackPointer) == 0x02
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: .prepareForStack() + [0x00, 0x00, 0x00], stackPointer: 0x01)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .pla, addressMode: .imp)

        expect(cpu.acc) == 0x00
        expect(cpu.stackPointer) == 0x02
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: .prepareForStack() + [0x00, 0x00, 0x80], stackPointer: 0x01)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .pla, addressMode: .imp)

        expect(cpu.acc) == 0x80
        expect(cpu.stackPointer) == 0x02
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == true
    }
}

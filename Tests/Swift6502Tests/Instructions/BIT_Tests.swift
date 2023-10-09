import XCTest
@testable import Swift6502
import Nimble

class BIT_Tests: XCTestCase {
    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [0x02, 0x00, 0x04], acc: 0x01)
        cpu.setupAddressing(using: .abs)

        cpu.perform(instruction: .bit, addressMode: .abs)

        expect(cpu.acc) == 0x01
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.overflow)) == false
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [0x02, 0x00, 0x80], acc: 0x80)
        cpu.setupAddressing(using: .abs)

        cpu.perform(instruction: .bit, addressMode: .abs)

        expect(cpu.acc) == 0x80
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == true
        expect(cpu.readFlag(.overflow)) == false
    }

    func test_it_sets_overflow_flag() {
        let cpu = CPU.create(ram: [0x02, 0x00, 0x70], acc: 0x70)
        cpu.setupAddressing(using: .abs)

        cpu.perform(instruction: .bit, addressMode: .abs)

        expect(cpu.acc) == 0x70
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == false
        expect(cpu.readFlag(.overflow)) == true
    }
}

import XCTest
@testable import Swift6502
import Nimble

class INC_Tests: XCTestCase {
    func test_it_increments() {
        let cpu = CPU.create(ram: [0x01, 0x0F])
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .inc, addressMode: .zp0)

        expect(cpu.readByte(0x01)) == 0x10

        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_overflows() {
        let cpu = CPU.create(ram: [0x01, 0xFF])
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .inc, addressMode: .zp0)

        expect(cpu.readByte(0x01)) == 0x00

        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [0x01, 0xFF])
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .inc, addressMode: .zp0)

        expect(cpu.readByte(0x01)) == 0x00
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [0x01, 0xFE])
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .inc, addressMode: .zp0)

        expect(cpu.readByte(0x01)) == 0xFF
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == true
    }
}

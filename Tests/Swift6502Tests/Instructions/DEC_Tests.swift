import XCTest
@testable import Swift6502
import Nimble

class DEC_Tests: XCTestCase {
    func test_it_decrements() {
        let cpu = CPU.create(ram: [0x01, 0x0F])
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .dec, addressMode: .zp0)

        expect(cpu.readByte(0x01)) == 0x0E

        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_overflows() {
        let cpu = CPU.create(ram: [0x01, 0x00])
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .dec, addressMode: .zp0)

        expect(cpu.readByte(0x01)) == 0xFF

        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == true
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [0x01, 0x01])
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .dec, addressMode: .zp0)

        expect(cpu.readByte(0x01)) == 0x00
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [0x01, 0xFF])
        cpu.setupAddressing(using: .zp0)

        cpu.perform(instruction: .dec, addressMode: .zp0)

        expect(cpu.readByte(0x01)) == 0xFE
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == true
    }
}

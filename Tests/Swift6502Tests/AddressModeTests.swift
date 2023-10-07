import XCTest
@testable import Swift6502
import Quick
import Nimble

class AddressModeTests: XCTestCase {
    func test_imm() {
        // Set some random bytes in RAM.
        // IMM defines that the next byte will be read as data, so `programCounter` will be the
        // actual address used.
        // `pc` is set to `1`, to emulate that the first byte in the array below is the opcode and
        // that it has already been read.
        let cpu = CPU.create(ram: [0xAA, 0xAA, 0xAA], pc: 0x01)

        cpu.setupAddressing(using: .imm)

        expect(cpu.addressAbsolute) == 0x01
        expect(cpu.pc) == 0x02
    }

    func test_zp0() {
        let cpu = CPU.create(ram: [0x00, 0x01, 0x02], pc: 0x01)

        cpu.setupAddressing(using: .zp0)

        expect(cpu.addressAbsolute) == 0x01
        expect(cpu.pc) == 0x02
    }

    func test_zpx() {
        let cpu = CPU.create(ram: [0x00, 0xAA, 0x02, 0x03], pc: 0x01, xReg: 0x02)

        cpu.setupAddressing(using: .zpx)

        expect(cpu.addressAbsolute) == 0xAC
        expect(cpu.pc) == 0x02
    }

    func test_zpy() {
        let cpu = CPU.create(ram: [0x00, 0xAA, 0x02, 0x03], pc: 0x01, yReg: 0x02)

        cpu.setupAddressing(using: .zpy)

        expect(cpu.addressAbsolute) == 0xAC
        expect(cpu.pc) == 0x02
    }

    func test_rel() {
        let cpu = CPU.create(ram: [0x00, 0xAA, 0x02, 0x03], pc: 0x01)

        cpu.setupAddressing(using: .rel)

        expect(cpu.addressRelative) == 0xAA
        expect(cpu.pc) == 0x02
    }

    func test_abs() {
        let cpu = CPU.create(ram: [0x00, 0xAA, 0xFF, 0x03], pc: 0x01)

        cpu.setupAddressing(using: .abs)

        expect(cpu.addressAbsolute) == 0xFFAA
        expect(cpu.pc) == 0x03
    }

    func test_abx() {
        let cpu = CPU.create(ram: [0x00, 0xAA, 0xFF, 0x03], pc: 0x01, xReg: 0x11)

        let extraClockCycles = cpu.setupAddressing(using: .abx)

        expect(cpu.addressAbsolute) == 0xFFBB
        expect(cpu.pc) == 0x03
        expect(extraClockCycles) == 0
    }

    func test_abx_with_page_boundry_crossed() {
        let cpu = CPU.create(ram: [0x00, 0xFF, 0x0E, 0x03], pc: 0x01, xReg: 0x02)

        let extraClockCycles = cpu.setupAddressing(using: .abx)

        expect(cpu.addressAbsolute) == 0x0F01
        expect(cpu.pc) == 0x03
        expect(extraClockCycles) == 1
    }
    
    func test_aby() {
        let cpu = CPU.create(ram: [0x00, 0xAA, 0xFF, 0x03], pc: 0x01, yReg: 0x11)

        let extraClockCycles = cpu.setupAddressing(using: .aby)

        expect(cpu.addressAbsolute) == 0xFFBB
        expect(cpu.pc) == 0x03
        expect(extraClockCycles) == 0
    }

    func test_aby_with_page_boundry_crossed() {
        let cpu = CPU.create(ram: [0x00, 0xFF, 0x0E, 0x03], pc: 0x01, yReg: 0x02)

        let extraClockCycles = cpu.setupAddressing(using: .aby)

        expect(cpu.addressAbsolute) == 0x0F01
        expect(cpu.pc) == 0x03
        expect(extraClockCycles) == 1
    }

    func test_ind() {
        let cpu = CPU.create(ram: [0x00, 0x03, 0x00, 0xAA, 0xFF], pc: 0x01)

        cpu.setupAddressing(using: .ind)

        expect(cpu.addressAbsolute) == 0xFFAA
        expect(cpu.pc) == 0x03
    }

    func test_izx() {
        let cpu = CPU.create(ram: [0x00, 0x03, 0x00, 0x00, 0x00, 0xAA, 0xFF], pc: 0x01, xReg: 0x02)

        cpu.setupAddressing(using: .izx)

        expect(cpu.addressAbsolute) == 0xFFAA
        expect(cpu.pc) == 0x02
    }

    func test_izy() {
        let cpu = CPU.create(ram: [0x00, 0x03, 0x00, 0x00, 0x00, 0xAA, 0xFF], pc: 0x01, yReg: 0x02)

        cpu.setupAddressing(using: .izy)

        expect(cpu.addressAbsolute) == 0xFFAA
        expect(cpu.pc) == 0x02
    }
}

private extension CPU {
    static func create(
        ram: [UInt8],
        pc: UInt16 = 0x0000,
        xReg: UInt8 = 0x00,
        yReg: UInt8 = 0x00
    ) -> CPU {
        CPU(
            bus: Bus(ram: ram),
            pc: pc,
            stackPointer: 0x00,
            acc: 0x00,
            xReg: xReg,
            yReg: yReg,
            flags: 0x00
        )
    }
}

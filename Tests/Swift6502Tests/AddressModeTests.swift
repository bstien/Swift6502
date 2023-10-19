import XCTest
@testable import Swift6502
import Nimble

class AddressModeTests: XCTestCase {
    func test_abs() {
        let cpu = CPU.create(ram: [0xAA, 0xFF, 0x03])

        cpu.setupAddressing(using: .abs)

        expect(cpu.addressAbsolute) == 0xFFAA
        expect(cpu.pc) == 0x02
    }

    func test_abx() {
        let cpu = CPU.create(ram: [0xAA, 0xFF, 0x03], xReg: 0x11)

        let extraClockCycles = cpu.setupAddressing(using: .abx)

        expect(cpu.addressAbsolute) == 0xFFBB
        expect(cpu.pc) == 0x02
        expect(extraClockCycles) == 0
    }

    func test_abx_with_page_boundry_crossed() {
        let cpu = CPU.create(ram: [0xFF, 0x0E, 0x03], xReg: 0x02)

        let extraClockCycles = cpu.setupAddressing(using: .abx)

        expect(cpu.addressAbsolute) == 0x0F01
        expect(cpu.pc) == 0x02
        expect(extraClockCycles) == 1
    }
    
    func test_aby() {
        let cpu = CPU.create(ram: [0xAA, 0xFF, 0x03], yReg: 0x11)

        let extraClockCycles = cpu.setupAddressing(using: .aby)

        expect(cpu.addressAbsolute) == 0xFFBB
        expect(cpu.pc) == 0x02
        expect(extraClockCycles) == 0
    }

    func test_aby_with_page_boundry_crossed() {
        let cpu = CPU.create(ram: [0xFF, 0x0E, 0x03], yReg: 0x02)

        let extraClockCycles = cpu.setupAddressing(using: .aby)

        expect(cpu.addressAbsolute) == 0x0F01
        expect(cpu.pc) == 0x02
        expect(extraClockCycles) == 1
    }

    func test_ind() {
        let cpu = CPU.create(ram: [0x02, 0x00, 0xAA, 0xFF])

        cpu.setupAddressing(using: .ind)

        expect(cpu.addressAbsolute) == 0xFFAA
        expect(cpu.pc) == 0x02
    }

    func test_izx() {
        let cpu = CPU.create(ram: [0x02, 0x00, 0x00, 0x00, 0xAA, 0xFF], xReg: 0x02)

        cpu.setupAddressing(using: .izx)

        expect(cpu.addressAbsolute) == 0xFFAA
        expect(cpu.pc) == 0x01
    }

    func test_izy() {
        let cpu = CPU.create(ram: [0x02, 0x00, 0xAA, 0xBB], yReg: 0x02)

        let extraClockCycles = cpu.setupAddressing(using: .izy)

        expect(cpu.addressAbsolute) == 0xBBAC
        expect(cpu.pc) == 0x01
        expect(extraClockCycles) == 0
    }

    func test_izy_with_page_boundry_crossed() {
        let cpu = CPU.create(ram: [0x02, 0x00, 0xFE, 0xBB], yReg: 0x03)

        let extraClockCycles = cpu.setupAddressing(using: .izy)

        expect(cpu.addressAbsolute) == 0xBC01
        expect(cpu.pc) == 0x01
        expect(extraClockCycles) == 1
    }
}

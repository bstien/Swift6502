import XCTest
@testable import Swift6502
import Nimble

class DEX_Tests: XCTestCase {
    func test_it_dexrements() {
        let cpu = CPU.create(ram: [], xReg: 0x0F)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .dex, addressMode: .imp)

        expect(cpu.xReg) == 0x0E

        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_overflows() {
        let cpu = CPU.create(ram: [], xReg: 0x00)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .dex, addressMode: .imp)

        expect(cpu.xReg) == 0xFF

        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == true
    }

    func test_it_sets_zero_flag() {
        let cpu = CPU.create(ram: [], xReg: 0x01)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .dex, addressMode: .imp)

        expect(cpu.xReg) == 0x00
        
        expect(cpu.readFlag(.zero)) == true
        expect(cpu.readFlag(.negative)) == false
    }

    func test_it_sets_negative_flag() {
        let cpu = CPU.create(ram: [], xReg: 0xFF)
        cpu.setupAddressing(using: .imp)

        cpu.perform(instruction: .dex, addressMode: .imp)

        expect(cpu.xReg) == 0xFE
        
        expect(cpu.readFlag(.zero)) == false
        expect(cpu.readFlag(.negative)) == true
    }
}

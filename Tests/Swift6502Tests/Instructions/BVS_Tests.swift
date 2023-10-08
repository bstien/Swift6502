import XCTest
@testable import Swift6502
import Nimble

class BVS_Tests: XCTestCase {
    func test_it_branches_with_positive_offset() {
        let cpu = CPU.create(ram: [0x08])
        cpu.setupAddressing(using: .rel)
        cpu.setFlag(.overflow, true)

        cpu.perform(instruction: .bvs, addressMode: .rel)

        expect(cpu.pc) == 0x09
    }

    func test_it_branches_with_negative_offset() {
        let cpu = CPU.create(ram: [0x00, 0x00, 0x00, 0xFE], pc: 0x03)
        cpu.setupAddressing(using: .rel)
        cpu.setFlag(.overflow, true)

        cpu.perform(instruction: .bvs, addressMode: .rel)

        expect(cpu.pc) == 0x02
    }

    func test_it_continues_on_overflow_not_set() {
        let cpu = CPU.create(ram: [0x80])
        cpu.setupAddressing(using: .rel)
        cpu.setFlag(.overflow, false)

        cpu.perform(instruction: .bvs, addressMode: .rel)

        expect(cpu.pc) == 0x01
    }
}

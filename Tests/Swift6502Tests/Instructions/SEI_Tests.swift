import XCTest
@testable import Swift6502
import Nimble

class SEI_Tests: XCTestCase {
    func test_it_sets_if_not_set() {
        let cpu = CPU.create(ram: [])
        cpu.setFlag(.interrupt, false)

        cpu.perform(instruction: .sei, addressMode: .imp)

        expect(cpu.readFlag(.interrupt)) == true
    }

    func test_it_does_not_clear_if_already_set() {
        let cpu = CPU.create(ram: [])
        cpu.setFlag(.interrupt, true)

        cpu.perform(instruction: .sei, addressMode: .imp)

        expect(cpu.readFlag(.interrupt)) == true
    }
}

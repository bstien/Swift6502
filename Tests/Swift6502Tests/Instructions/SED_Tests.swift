import XCTest
@testable import Swift6502
import Nimble

class SED_Tests: XCTestCase {
    func test_it_sets_if_not_set() {
        let cpu = CPU.create(ram: [])
        cpu.setFlag(.decimal, false)

        cpu.perform(instruction: .sed, addressMode: .imp)

        expect(cpu.readFlag(.decimal)) == true
    }

    func test_it_does_not_clear_if_already_set() {
        let cpu = CPU.create(ram: [])
        cpu.setFlag(.decimal, true)

        cpu.perform(instruction: .sed, addressMode: .imp)

        expect(cpu.readFlag(.decimal)) == true
    }
}

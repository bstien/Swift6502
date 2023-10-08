import XCTest
@testable import Swift6502
import Nimble

class SEC_Tests: XCTestCase {
    func test_it_sets_if_not_set() {
        let cpu = CPU.create(ram: [])
        cpu.setFlag(.carry, false)

        cpu.perform(instruction: .sec, addressMode: .imp)

        expect(cpu.readFlag(.carry)) == true
    }

    func test_it_does_not_clear_if_already_set() {
        let cpu = CPU.create(ram: [])
        cpu.setFlag(.carry, true)

        cpu.perform(instruction: .sec, addressMode: .imp)

        expect(cpu.readFlag(.carry)) == true
    }
}

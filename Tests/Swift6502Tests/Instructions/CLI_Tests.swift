import XCTest
@testable import Swift6502
import Nimble

class CLI_Tests: XCTestCase {
    func test_it_clears_if_set() {
        let cpu = CPU.create(ram: [])
        cpu.setFlag(.interrupt, true)

        cpu.perform(instruction: .cli, addressMode: .imp)

        expect(cpu.readFlag(.interrupt)) == false
    }

    func test_it_does_not_set_if_already_cleared() {
        let cpu = CPU.create(ram: [])
        cpu.setFlag(.interrupt, false)

        cpu.perform(instruction: .cli, addressMode: .imp)

        expect(cpu.readFlag(.interrupt)) == false
    }
}

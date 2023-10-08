import XCTest
@testable import Swift6502
import Nimble

class CLD_Tests: XCTestCase {
    func test_it_clears_if_set() {
        let cpu = CPU.create(ram: [])
        cpu.setFlag(.decimal, true)

        cpu.perform(instruction: .cld, addressMode: .imp)

        expect(cpu.readFlag(.decimal)) == false
    }

    func test_it_does_not_set_if_already_cleared() {
        let cpu = CPU.create(ram: [])
        cpu.setFlag(.decimal, false)

        cpu.perform(instruction: .cld, addressMode: .imp)

        expect(cpu.readFlag(.decimal)) == false
    }
}

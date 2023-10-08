import XCTest
@testable import Swift6502
import Nimble

class CLV_Tests: XCTestCase {
    func test_it_clears_if_set() {
        let cpu = CPU.create(ram: [])
        cpu.setFlag(.overflow, true)

        cpu.perform(instruction: .clv, addressMode: .imp)

        expect(cpu.readFlag(.overflow)) == false
    }

    func test_it_does_not_set_if_already_cleared() {
        let cpu = CPU.create(ram: [])
        cpu.setFlag(.overflow, false)

        cpu.perform(instruction: .clv, addressMode: .imp)

        expect(cpu.readFlag(.overflow)) == false
    }
}

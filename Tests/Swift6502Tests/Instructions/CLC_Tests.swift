import XCTest
@testable import Swift6502
import Nimble

class CLC_Tests: XCTestCase {
    func test_it_clears_if_set() {
        let cpu = CPU.create(ram: [])
        cpu.setFlag(.carry, true)

        cpu.perform(instruction: .clc, addressMode: .imp)

        expect(cpu.readFlag(.carry)) == false
    }

    func test_it_does_not_set_if_already_cleared() {
        let cpu = CPU.create(ram: [])
        cpu.setFlag(.carry, false)

        cpu.perform(instruction: .clc, addressMode: .imp)

        expect(cpu.readFlag(.carry)) == false
    }
}

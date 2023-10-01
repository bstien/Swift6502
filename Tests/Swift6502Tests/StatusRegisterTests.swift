import XCTest
@testable import Swift6502

final class StatusRegisterTests: XCTestCase {
    private var cpu = CPU(flags: 0x00)

    override func setUp() {
        cpu = CPU(flags: 0x00)
    }

    func test_negative_flag() {
        XCTAssertEqual(0b0000_0000, cpu.flags)
        XCTAssertFalse(cpu.readFlag(.negative))

        cpu.setFlag(.negative, true)
        XCTAssertEqual(0b0000_0001, cpu.flags)
        XCTAssertTrue(cpu.readFlag(.negative))

        cpu.setFlag(.negative, false)
        XCTAssertEqual(0b0000_0000, cpu.flags)
        XCTAssertFalse(cpu.readFlag(.negative))
    }

    func test_overflow_flag() {
        XCTAssertEqual(0b0000_0000, cpu.flags)
        XCTAssertFalse(cpu.readFlag(.overflow))

        cpu.setFlag(.overflow, true)
        XCTAssertEqual(0b0000_0010, cpu.flags)
        XCTAssertTrue(cpu.readFlag(.overflow))

        cpu.setFlag(.overflow, false)
        XCTAssertEqual(0b0000_0000, cpu.flags)
        XCTAssertFalse(cpu.readFlag(.overflow))
    }

    func test_break_flag() {
        XCTAssertEqual(0b0000_0000, cpu.flags)
        XCTAssertFalse(cpu.readFlag(.break))

        cpu.setFlag(.break, true)
        XCTAssertEqual(0b0000_1000, cpu.flags)
        XCTAssertTrue(cpu.readFlag(.break))

        cpu.setFlag(.break, false)
        XCTAssertEqual(0b0000_0000, cpu.flags)
        XCTAssertFalse(cpu.readFlag(.break))
    }

    func test_decimal_flag() {
        XCTAssertEqual(0b0000_0000, cpu.flags)
        XCTAssertFalse(cpu.readFlag(.decimal))

        cpu.setFlag(.decimal, true)
        XCTAssertEqual(0b0001_0000, cpu.flags)
        XCTAssertTrue(cpu.readFlag(.decimal))

        cpu.setFlag(.decimal, false)
        XCTAssertEqual(0b0000_0000, cpu.flags)
        XCTAssertFalse(cpu.readFlag(.decimal))
    }

    func test_interrupt_flag() {
        XCTAssertEqual(0b0000_0000, cpu.flags)
        XCTAssertFalse(cpu.readFlag(.interrupt))

        cpu.setFlag(.interrupt, true)
        XCTAssertEqual(0b0010_0000, cpu.flags)
        XCTAssertTrue(cpu.readFlag(.interrupt))

        cpu.setFlag(.interrupt, false)
        XCTAssertEqual(0b0000_0000, cpu.flags)
        XCTAssertFalse(cpu.readFlag(.interrupt))
    }

    func test_zero_flag() {
        XCTAssertEqual(0b0000_0000, cpu.flags)
        XCTAssertFalse(cpu.readFlag(.zero))

        cpu.setFlag(.zero, true)
        XCTAssertEqual(0b0100_0000, cpu.flags)
        XCTAssertTrue(cpu.readFlag(.zero))

        cpu.setFlag(.zero, false)
        XCTAssertEqual(0b0000_0000, cpu.flags)
        XCTAssertFalse(cpu.readFlag(.zero))
    }

    func test_carry_flag() {
        XCTAssertEqual(0b0000_0000, cpu.flags)
        XCTAssertFalse(cpu.readFlag(.carry))

        cpu.setFlag(.carry, true)
        XCTAssertEqual(0b1000_0000, cpu.flags)
        XCTAssertTrue(cpu.readFlag(.carry))

        cpu.setFlag(.carry, false)
        XCTAssertEqual(0b0000_0000, cpu.flags)
        XCTAssertFalse(cpu.readFlag(.carry))
    }
}

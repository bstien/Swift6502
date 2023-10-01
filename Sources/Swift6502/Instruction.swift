import Foundation

enum Instruction: String {
    case xxx = "???" // Not in use. Defaults to no-op.
    
    case adc = "ADC"
    case and = "AND"
    case asl = "ASL"
    case bcc = "BCC"
    case bcs = "BCS"
    case beq = "BEQ"
    case bit = "BIT"
    case bmi = "BMI"
    case bne = "BNE"
    case bpl = "BPL"
    case brk = "BRK"
    case bvc = "BVC"
    case bvs = "BVS"
    case clc = "CLC"
    case cld = "CLD"
    case cli = "CLI"
    case clv = "CLV"
    case cmp = "CMP"
    case cpx = "CPX"
    case cpy = "CPY"
    case dec = "DEC"
    case dex = "DEX"
    case dey = "DEY"
    case eor = "EOR"
    case inc = "INC"
    case inx = "INX"
    case iny = "INY"
    case jmp = "JMP"
    case jsr = "JSR"
    case lda = "LDA"
    case ldx = "LDX"
    case ldy = "LDY"
    case lsr = "LSR"
    case nop = "NOP"
    case ora = "ORA"
    case pha = "PHA"
    case php = "PHP"
    case pla = "PLA"
    case plp = "PLP"
    case rol = "ROL"
    case ror = "ROR"
    case rti = "RTI"
    case rts = "RTS"
    case sbc = "SBC"
    case sec = "SEC"
    case sed = "SED"
    case sei = "SEI"
    case sta = "STA"
    case stx = "STX"
    case sty = "STY"
    case tax = "TAX"
    case tay = "TAY"
    case tsx = "TSX"
    case txa = "TXA"
    case txs = "TXS"
    case tya = "TYA"

    func perform(cpu: CPU) -> UInt8 {
        switch self {
        case .xxx: 0
        case .adc: adc(cpu: cpu)
        case .and: and(cpu: cpu)
        case .asl: asl(cpu: cpu)
        case .bcc: bcc(cpu: cpu)
        case .bcs: bcs(cpu: cpu)
        case .beq: beq(cpu: cpu)
        case .bit: bit(cpu: cpu)
        case .bmi: bmi(cpu: cpu)
        case .bne: bne(cpu: cpu)
        case .bpl: bpl(cpu: cpu)
        case .brk: brk(cpu: cpu)
        case .bvc: bvc(cpu: cpu)
        case .bvs: bvs(cpu: cpu)
        case .clc: clc(cpu: cpu)
        case .cld: cld(cpu: cpu)
        case .cli: cli(cpu: cpu)
        case .clv: clv(cpu: cpu)
        case .cmp: cmp(cpu: cpu)
        case .cpx: cpx(cpu: cpu)
        case .cpy: cpy(cpu: cpu)
        case .dec: dec(cpu: cpu)
        case .dex: dex(cpu: cpu)
        case .dey: dey(cpu: cpu)
        case .eor: eor(cpu: cpu)
        case .inc: inc(cpu: cpu)
        case .inx: inx(cpu: cpu)
        case .iny: iny(cpu: cpu)
        case .jmp: jmp(cpu: cpu)
        case .jsr: jsr(cpu: cpu)
        case .lda: lda(cpu: cpu)
        case .ldx: ldx(cpu: cpu)
        case .ldy: ldy(cpu: cpu)
        case .lsr: lsr(cpu: cpu)
        case .nop: nop(cpu: cpu)
        case .ora: ora(cpu: cpu)
        case .pha: pha(cpu: cpu)
        case .php: php(cpu: cpu)
        case .pla: pla(cpu: cpu)
        case .plp: plp(cpu: cpu)
        case .rol: rol(cpu: cpu)
        case .ror: ror(cpu: cpu)
        case .rti: rti(cpu: cpu)
        case .rts: rts(cpu: cpu)
        case .sbc: sbc(cpu: cpu)
        case .sec: sec(cpu: cpu)
        case .sed: sed(cpu: cpu)
        case .sei: sei(cpu: cpu)
        case .sta: sta(cpu: cpu)
        case .stx: stx(cpu: cpu)
        case .sty: sty(cpu: cpu)
        case .tax: tax(cpu: cpu)
        case .tay: tay(cpu: cpu)
        case .tsx: tsx(cpu: cpu)
        case .txa: txa(cpu: cpu)
        case .txs: txs(cpu: cpu)
        case .tya: tya(cpu: cpu)
        }
    }
}

private extension Instruction {
    // Add memory to accumulator with carry.
    func adc(cpu: CPU) -> UInt8 {
        0
    }

    // AND memory with accumulator.
    func and(cpu: CPU) -> UInt8 {
        0
    }

    // Shift left one bit (memory or accumulator).
    func asl(cpu: CPU) -> UInt8 {
        0
    }

    // Branch on carry clear.
    func bcc(cpu: CPU) -> UInt8 {
        0
    }

    // Branch on carry set.
    func bcs(cpu: CPU) -> UInt8 {
        0
    }

    // Branch on result zero.
    func beq(cpu: CPU) -> UInt8 {
        0
    }

    // Test bits in memory with accumulator.
    func bit(cpu: CPU) -> UInt8 {
        0
    }

    // Branch on result minus.
    func bmi(cpu: CPU) -> UInt8 {
        0
    }

    // Branch on result not zero.
    func bne(cpu: CPU) -> UInt8 {
        0
    }

    // Branch on result plus.
    func bpl(cpu: CPU) -> UInt8 {
        0
    }

    // Force break.
    func brk(cpu: CPU) -> UInt8 {
        0
    }

    // Branch on overflow clear.
    func bvc(cpu: CPU) -> UInt8 {
        0
    }

    // Branch on overflow set.
    func bvs(cpu: CPU) -> UInt8 {
        0
    }

    // Clear carry flag.
    func clc(cpu: CPU) -> UInt8 {
        0
    }

    // Clear decimal mode.
    func cld(cpu: CPU) -> UInt8 {
        0
    }

    // Clear interrupt disable bit.
    func cli(cpu: CPU) -> UInt8 {
        0
    }

    // Clear overflow flag.
    func clv(cpu: CPU) -> UInt8 {
        0
    }

    // Compare memory with accumulator.
    func cmp(cpu: CPU) -> UInt8 {
        0
    }

    // Compare memory with X.
    func cpx(cpu: CPU) -> UInt8 {
        0
    }

    // Compare memory with Y.
    func cpy(cpu: CPU) -> UInt8 {
        0
    }

    // Decrement memory by one.
    func dec(cpu: CPU) -> UInt8 {
        0
    }

    // Decrement X by one.
    func dex(cpu: CPU) -> UInt8 {
        0
    }

    // Decrement Y by one.
    func dey(cpu: CPU) -> UInt8 {
        0
    }

    // Exclusive-OR memory with accumulator.
    func eor(cpu: CPU) -> UInt8 {
        0
    }

    // Increment memory by one.
    func inc(cpu: CPU) -> UInt8 {
        0
    }

    // Increment X by one.
    func inx(cpu: CPU) -> UInt8 {
        0
    }

    // Increment Y by one.
    func iny(cpu: CPU) -> UInt8 {
        0
    }

    // Jump to new location.
    func jmp(cpu: CPU) -> UInt8 {
        0
    }

    // Jump to new location, saving return address.
    func jsr(cpu: CPU) -> UInt8 {
        0
    }

    // Load accumulator.
    func lda(cpu: CPU) -> UInt8 {
        0
    }

    // Load X register.
    func ldx(cpu: CPU) -> UInt8 {
        0
    }

    // Load Y register.
    func ldy(cpu: CPU) -> UInt8 {
        0
    }

    // Logical shift right (shifts in a zero bit on the left).
    func lsr(cpu: CPU) -> UInt8 {
        0
    }

    // No operation.
    func nop(cpu: CPU) -> UInt8 {
        0
    }

    // OR memory with accumulator.
    func ora(cpu: CPU) -> UInt8 {
        0
    }

    // Push accumulator on stack.
    func pha(cpu: CPU) -> UInt8 {
        0
    }

    // Push processor status on stack.
    func php(cpu: CPU) -> UInt8 {
        0
    }

    // Pull accumulator from stack.
    func pla(cpu: CPU) -> UInt8 {
        0
    }

    // Pull processor status from stack.
    func plp(cpu: CPU) -> UInt8 {
        0
    }

    // Rotate one bit left (memory or accumulator).
    func rol(cpu: CPU) -> UInt8 {
        0
    }

    // Rotate one bit right (memory or accumulator).
    func ror(cpu: CPU) -> UInt8 {
        0
    }

    // Return from interrupt.
    func rti(cpu: CPU) -> UInt8 {
        0
    }

    // Return from subroutine.
    func rts(cpu: CPU) -> UInt8 {
        0
    }

    // Subtract memory from accumulator with borrow.
    func sbc(cpu: CPU) -> UInt8 {
        0
    }

    // Set carry flag.
    func sec(cpu: CPU) -> UInt8 {
        0
    }

    // Set decimal flag.
    func sed(cpu: CPU) -> UInt8 {
        0
    }

    // Set interrupt disable status.
    func sei(cpu: CPU) -> UInt8 {
        0
    }

    // Store accumulator in memory.
    func sta(cpu: CPU) -> UInt8 {
        0
    }

    // Store X in memory.
    func stx(cpu: CPU) -> UInt8 {
        0
    }

    // Store Y in memory.
    func sty(cpu: CPU) -> UInt8 {
        0
    }

    // Transfer accumulator to X.
    func tax(cpu: CPU) -> UInt8 {
        0
    }

    // Transfer accumulator to Y.
    func tay(cpu: CPU) -> UInt8 {
        0
    }

    // Transfer stack pointer to X.
    func tsx(cpu: CPU) -> UInt8 {
        0
    }

    // Transfer X to accumulator.
    func txa(cpu: CPU) -> UInt8 {
        0
    }

    // Transfer X to stack pointer.
    func txs(cpu: CPU) -> UInt8 {
        0
    }

    // Transfer Y to accumulator.
    func tya(cpu: CPU) -> UInt8 {
        0
    }
}

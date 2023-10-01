import Foundation

extension CPU {
    typealias OpCode = (Instruction, AddressMode, Int)
    
    /// An array of all 256 available opcodes. Several of them are no-op, specified by `.xxx` instruction.
    /// There also exists several no-op that uses a number of clock cycles doing nothing, these uses `.nop`.
    /// References:
    /// - https://www.masswerk.at/6502/6502_instruction_set.html
    /// - https://www.nesdev.org/wiki/CPU_unofficial_opcodes
    static var opcodes: [OpCode] {
        [
            //     00               01               02               03
            (.brk, .imm, 7), (.ora, .izx, 6), (.xxx, .imp, 2), (.xxx, .imp, 8),
            //     04               05               06               07
            (.nop, .imp, 3), (.ora, .zp0, 3), (.asl, .zp0, 5), (.xxx, .imp, 5),
            //     08               09               0A               0B
            (.php, .imp, 3), (.ora, .imm, 2), (.asl, .imp, 2), (.xxx, .imp, 2),
            //     0C               0D               0E               0F
            (.nop, .imp, 4), (.ora, .abs, 4), (.asl, .abs, 6), (.xxx, .imp, 6),

            //     10               11               12               13
            (.bpl, .rel, 2), (.ora, .izy, 5), (.xxx, .imp, 2), (.xxx, .imp, 8),
            //     14               15               16               17
            (.nop, .imp, 4), (.ora, .zpx, 4), (.asl, .zpx, 6), (.xxx, .imp, 6),
            //     18               19               1A               1B
            (.clc, .imp, 2), (.ora, .aby, 4), (.nop, .imp, 2), (.xxx, .imp, 7),
            //     1C               1D               1E               1F
            (.nop, .imp, 4), (.ora, .abx, 4), (.asl, .abx, 7), (.xxx, .imp, 7),

            //     20               21               22               23
            (.jsr, .abs, 6), (.and, .izx, 6), (.xxx, .imp, 2), (.xxx, .imp, 8),
            //     24               25               26               27
            (.bit, .zp0, 3), (.and, .zp0, 3), (.rol, .zp0, 5), (.xxx, .imp, 5),
            //     28               29               2A               2B
            (.plp, .imp, 4), (.and, .imm, 2), (.rol, .imp, 2), (.xxx, .imp, 2),
            //     2C               2D               2E               2F
            (.bit, .abs, 4), (.and, .abs, 4), (.rol, .abs, 6), (.xxx, .imp, 6),

            //     30               31               32               33
            (.bmi, .rel, 2), (.and, .izy, 5), (.xxx, .imp, 2), (.xxx, .imp, 8),
            //     34               35               36               37
            (.nop, .imp, 4), (.and, .zpx, 4), (.rol, .zpx, 6), (.xxx, .imp, 6),
            //     38               39               3A               3B
            (.sec, .imp, 2), (.and, .aby, 4), (.nop, .imp, 2), (.xxx, .imp, 7),
            //     3C               3D               3E               3F
            (.nop, .imp, 4), (.and, .abx, 4), (.rol, .abx, 7), (.xxx, .imp, 7),

            //     40               41               42               43
            (.rti, .imp, 6), (.eor, .izx, 6), (.xxx, .imp, 2), (.xxx, .imp, 8),
            //     44               45               46               47
            (.nop, .imp, 3), (.eor, .zp0, 3), (.lsr, .zp0, 5), (.xxx, .imp, 5),
            //     48               49               4A               4B
            (.pha, .imp, 3), (.eor, .imm, 2), (.lsr, .imp, 2), (.xxx, .imp, 2),
            //     4C               4D               4E               4F
            (.jmp, .abs, 3), (.eor, .abs, 4), (.lsr, .abs, 6), (.xxx, .imp, 6),

            //     50               51               52               53
            (.bvc, .rel, 2), (.eor, .izy, 5), (.xxx, .imp, 2), (.xxx, .imp, 8),
            //     54               55               56               57
            (.nop, .imp, 4), (.eor, .zpx, 4), (.lsr, .zpx, 6), (.xxx, .imp, 6),
            //     58               59               5A               5B
            (.cli, .imp, 2), (.eor, .aby, 4), (.nop, .imp, 2), (.xxx, .imp, 7),
            //     5C               5D               5E               5F
            (.nop, .imp, 4), (.eor, .abx, 4), (.lsr, .abx, 7), (.xxx, .imp, 7),

            //     60               61               62               63
            (.rts, .imp, 6), (.adc, .izx, 6), (.xxx, .imp, 2), (.xxx, .imp, 8),
            //     64               65               66               67
            (.nop, .imp, 3), (.adc, .zp0, 3), (.ror, .zp0, 5), (.xxx, .imp, 5),
            //     68               69               6A               6B
            (.pla, .imp, 4), (.adc, .imm, 2), (.ror, .imp, 2), (.xxx, .imp, 2),
            //     6C               6D               6E               6F
            (.jmp, .ind, 5), (.adc, .abs, 4), (.ror, .abs, 6), (.xxx, .imp, 6),

            //     70               71               72               73
            (.bvs, .rel, 2), (.adc, .izy, 5), (.xxx, .imp, 2), (.xxx, .imp, 8),
            //     74               75               76               77
            (.nop, .imp, 4), (.adc, .zpx, 4), (.ror, .zpx, 6), (.xxx, .imp, 6),
            //     78               79               7A               7B
            (.sei, .imp, 2), (.adc, .aby, 4), (.nop, .imp, 2), (.xxx, .imp, 7),
            //     7C               7D               7E               7F
            (.nop, .imp, 4), (.adc, .abx, 4), (.ror, .abx, 7), (.xxx, .imp, 7),

            //     80               81               82               83
            (.nop, .imp, 2), (.sta, .izx, 6), (.nop, .imp, 2), (.xxx, .imp, 6),
            //     84               85               86               87
            (.sty, .zp0, 3), (.sta, .zp0, 3), (.stx, .zp0, 3), (.xxx, .imp, 3),
            //     88               89               8A               8B
            (.dey, .imp, 2), (.nop, .imp, 2), (.txa, .imp, 2), (.xxx, .imp, 2),
            //     8C               8D               8E               8F
            (.sty, .abs, 4), (.sta, .abs, 4), (.stx, .abs, 4), (.xxx, .imp, 4),

            //     90               91               92               93
            (.bcc, .rel, 2), (.sta, .izy, 6), (.xxx, .imp, 2), (.xxx, .imp, 6),
            //     94               95               96               97
            (.sty, .zpx, 4), (.sta, .zpx, 4), (.stx, .zpy, 4), (.xxx, .imp, 4),
            //     98               99               9A               9B
            (.tya, .imp, 2), (.sta, .aby, 5), (.txs, .imp, 2), (.xxx, .imp, 5),
            //     9C               9D               9E               9F
            (.nop, .imp, 5), (.sta, .abx, 5), (.xxx, .imp, 5), (.xxx, .imp, 5),

            //     A0               A1               A2               A3
            (.ldy, .imm, 2), (.lda, .izx, 6), (.ldx, .imm, 2), (.xxx, .imp, 6),
            //     A4               A5               A6               A7
            (.ldy, .zp0, 3), (.lda, .zp0, 3), (.ldx, .zp0, 3), (.xxx, .imp, 3),
            //     A8               A9               AA               AB
            (.tay, .imp, 2), (.lda, .imm, 2), (.tax, .imp, 2), (.xxx, .imp, 2),
            //     AC               AD               AE               AF
            (.ldy, .abs, 4), (.lda, .abs, 4), (.ldx, .abs, 4), (.xxx, .imp, 4),

            //     B0               B1               B2               B3
            (.bcs, .rel, 2), (.lda, .izy, 5), (.xxx, .imp, 2), (.xxx, .imp, 5),
            //     B4               B5               B6               B7
            (.ldy, .zpx, 4), (.lda, .zpx, 4), (.ldx, .zpy, 4), (.xxx, .imp, 4),
            //     B8               B9               BA               BB
            (.clv, .imp, 2), (.lda, .aby, 4), (.tsx, .imp, 2), (.xxx, .imp, 4),
            //     BC               BD               BE               BF
            (.ldy, .abx, 4), (.lda, .abx, 4), (.ldx, .aby, 4), (.xxx, .imp, 4),

            //     C0               C1               C2               C3
            (.cpy, .imm, 2), (.cmp, .izx, 6), (.nop, .imp, 2), (.xxx, .imp, 8),
            //     C4               C5               C6               C7
            (.cpy, .zp0, 3), (.cmp, .zp0, 3), (.dec, .zp0, 5), (.xxx, .imp, 5),
            //     C8               C9               CA               CB
            (.iny, .imp, 2), (.cmp, .imm, 2), (.dex, .imp, 2), (.xxx, .imp, 2),
            //     CC               CD               CE               CF
            (.cpy, .abs, 4), (.cmp, .abs, 4), (.dec, .abs, 6), (.xxx, .imp, 6),

            //     D0               D1               D2               D3
            (.bne, .rel, 2), (.cmp, .izy, 5), (.xxx, .imp, 2), (.xxx, .imp, 8),
            //     D4               D5               D6               D7
            (.nop, .imp, 4), (.cmp, .zpx, 4), (.dec, .zpx, 6), (.xxx, .imp, 6),
            //     D8               D9               DA               DB
            (.cld, .imp, 2), (.cmp, .aby, 4), (.nop, .imp, 2), (.xxx, .imp, 7),
            //     DC               DD               DE               DF
            (.nop, .imp, 4), (.cmp, .abx, 4), (.dec, .abx, 7), (.xxx, .imp, 7),

            //     E0               E1               E2               E3
            (.cpx, .imm, 2), (.sbc, .izx, 6), (.nop, .imp, 2), (.xxx, .imp, 8),
            //     E4               E5               E6               E7
            (.cpx, .zp0, 3), (.sbc, .zp0, 3), (.inc, .zp0, 5), (.xxx, .imp, 5),
            //     E8               E9               EA               EB
            (.inx, .imp, 2), (.sbc, .imm, 2), (.nop, .imp, 2), (.sbc, .imp, 2),
            //     EC               ED               EE               EF
            (.cpx, .abs, 4), (.sbc, .abs, 4), (.inc, .abs, 6), (.xxx, .imp, 6),

            //     F0               F1               F2               F3
            (.beq, .rel, 2), (.sbc, .izy, 5), (.xxx, .imp, 2), (.xxx, .imp, 8),
            //     F4               F5               F6               F7
            (.nop, .imp, 4), (.sbc, .zpx, 4), (.inc, .zpx, 6), (.xxx, .imp, 6),
            //     F8               F9               FA               FB
            (.sed, .imp, 2), (.sbc, .aby, 4), (.nop, .imp, 2), (.xxx, .imp, 7),
            //     FC               FD               FE               FF
            (.nop, .imp, 4), (.sbc, .abx, 4), (.inc, .abx, 7), (.xxx, .imp, 7),
        ]
    }
}

extension [CPU.OpCode] {
    func get(_ opcode: UInt8) -> CPU.OpCode? {
        guard indices.contains(Int(opcode)) else { return nil }
        return self[Int(opcode)]
    }
}

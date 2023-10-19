import Foundation

extension Disassembler {
    struct Operation {
       let offset: UInt16
       let opcode: UInt8
       let instruction: Instruction
       let operand: Operand

       var asCode: String {
           [instruction.rawValue, operandAsString].compactMap { $0 }.joined(separator: " ")
       }

       var operandAsString: String? {
           switch operand {
           case .immediate(let value):
               return "#$\(value.asHex)"

           case .relative(let value):
               var value = value.asWord

               // The value is a signed byte.
               // Flip the high bits if value is negative so we can add it to offset.
               if value & 0x80 == 0x80 {
                   value = value ^ 0xFF00
               }

               // 2 is the number of bytes between offset and the next instruction, which is where
               // the relative location should be calculated from.
               let location = offset &+ 2 &+ value
               return "$\(location.asHex)"

           case .zeroPage(let value):
               return "$\(value.asHex)"
           case .zeroPageX(let value):
               return "$\(value.asHex),X"
           case .zeroPageY(let value):
               return "$\(value.asHex),Y"

           case .absolute(let value):
               return "$\(value.asHex)"
           case .absoluteX(let value):
               return "$\(value.asHex),X"
           case .absoluteY(let value):
               return "$\(value.asHex),Y"

           case .indirect(let value):
               return "($\(value.asHex))"
           case .indirectX(let value):
               return "($\(value.asHex),X)"
           case .indirectY(let value):
               return "($\(value.asHex)),Y"

           case .none:
               return nil
           }
       }
   }
}

import Foundation

extension UInt16 {
    var highByte: UInt8 {
        UInt8(self >> 8)
    }
    
    var lowByte: UInt8 {
        UInt8(self & 0xFF)
    }
}

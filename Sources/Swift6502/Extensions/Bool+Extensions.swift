import Foundation

extension Bool {
    var value: UInt8 {
        switch self {
        case true: 1
        case false: 0
        }
    }
}

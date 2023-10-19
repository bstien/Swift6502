import Foundation

extension Int {
    var asHex: String {
        String(format: "%04X", self)
    }
}

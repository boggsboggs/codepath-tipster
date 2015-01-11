import Foundation

extension Double {
    func format(f: String) -> String {
        return NSString(format: f, self)
    }
}

extension String {
    func doubleValue() -> Double {
        return (self as NSString).doubleValue
    }
}

extension NSDate {
    func toEpoch() -> Int {
        return Int(self.timeIntervalSince1970)
    }
}
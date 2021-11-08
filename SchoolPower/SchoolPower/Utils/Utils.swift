//
//  Utils.swift
//  SchoolPower
//
//  Created by Mark Wang on 11/3/21.
//

import Foundation

extension Double {
    func rounded(digits: Int) -> String {
        return String(format: "%.\(digits)f", self)
    }
}

extension String {
    func asPercentage() -> String {
        if (self.hasSuffix("%")) {
            return self
        } else {
            return "\(self)%"
        }
    }
}

extension Int64 {
    func asMillisDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self) / 1000)
    }
}

extension Date {
    func formatted() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: self)
    }
}

class Utils {
    static func saveStringToFile(filename: String, data: String) {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(filename)
            do { try data.write(to: path, atomically: true, encoding: .utf8) }
            catch { print("Failed to save string to file \(filename): \(error)") }
        }
    }
    
    static func readStringFromFile(filename: String) -> String? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let path = dir.appendingPathComponent(filename)
            do { return try String(contentsOf: path, encoding: .utf8) }
            catch { print("Failed to read string from file \(filename): \(error)") }
        }
        return nil
    }
}

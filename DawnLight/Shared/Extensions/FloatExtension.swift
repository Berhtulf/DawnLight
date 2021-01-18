//
//  FloatExtension.swift
//  IncGame
//
//  Created by Martin Václavík on 22.11.2020.
//

import SwiftUI

extension Float {
    var toScientific: String {
        if self < 100000 {
            return String(format: "%.f", self)
        }
        let val = self
        let formatter = NumberFormatter()
        formatter.numberStyle = .scientific
        formatter.positiveFormat = "0.##E+0"
        formatter.exponentSymbol = "e"
        if let scientificFormatted = formatter.string(for: val) {
            return scientificFormatted  // "5e+2"
        }
        return ""
    }
    
}

extension TimeInterval {
    var toHoursMinutesSeconds: (Int,Int,Int) {
        return (Int(self / 3600),
                Int((self.truncatingRemainder(dividingBy: 3600)) / 60),
                Int((self.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60)))
    }
}

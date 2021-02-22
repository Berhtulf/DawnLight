//
//  TimeInterval.swift
//  IncGame
//
//  Created by Martin Václavík on 10/11/2020.
//

import Foundation

extension TimeInterval{
    var toHoursMinutesSeconds: (Int, Int, Int) {
        return (Int( self / 3600),
                Int((self.truncatingRemainder(dividingBy: 3600)) / 60),
                Int((self.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60)))
    }
}

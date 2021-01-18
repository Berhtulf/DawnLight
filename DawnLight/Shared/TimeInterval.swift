//
//  TimeInterval.swift
//  IncGame
//
//  Created by Martin Václavík on 10/11/2020.
//

import Foundation



func secondsToHoursMinutesSeconds (_ seconds : TimeInterval) -> (Int, Int, Int) {
    return (Int(seconds / 3600),
            Int((seconds.truncatingRemainder(dividingBy: 3600)) / 60),
            Int((seconds.truncatingRemainder(dividingBy: 3600)).truncatingRemainder(dividingBy: 60)))
}

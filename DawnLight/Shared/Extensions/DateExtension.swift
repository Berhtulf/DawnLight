//
//  DateExtension.swift
//  DawnLight
//
//  Created by Martin Václavík on 03.02.2021.
//

import Foundation

extension Date {
    func add(days: Int) -> Date{
        return self.addingTimeInterval(TimeInterval(days * 86400))
    }
}

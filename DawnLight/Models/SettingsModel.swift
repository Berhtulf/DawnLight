//
//  MainModel.swift
//  DawnLight
//
//  Created by Martin Václavík on 19.01.2021.
//

import Foundation

struct SettingsModel: Codable {
    var sunrise: String?
    var volume: Float = 0.5
    var usingGPS: Bool = true
    var alarm: Alarm = Alarm.Auratone
    
    var backupBuzz: Date?
}

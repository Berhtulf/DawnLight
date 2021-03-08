//
//  Alarm.swift
//  DawnLight
//
//  Created by Martin Václavík on 22.02.2021.
//

import Foundation

struct Alarm: Hashable, Identifiable, Codable {
    internal init(displayName: String, systemName: String) {
        self.id = UUID()
        self.displayName = displayName
        self.systemName = systemName
    }
    
    let id: UUID
    let displayName: String
    let systemName: String
    
    
    static let availableAlarms = [Ping1, Ping2, FantasyVillage, Auratone, Happyday, Softchime, Freshstart, MorningBirds, Daybreak, EarlyRiser, SlowMorning]
    
    static let FantasyVillage = Alarm(displayName: "Fantasy village", systemName: "FantasyVillage.mp3")
    static let Auratone = Alarm(displayName: "Auratone", systemName: "Auratone.mp3")
    static let Happyday = Alarm(displayName: "Happyday", systemName: "Happyday.mp3")
    static let Ping1 = Alarm(displayName: "Ping 1", systemName: "Ping1.mp3")
    static let Ping2 = Alarm(displayName: "Ping 2", systemName: "Ping2.mp3")
    static let Softchime = Alarm(displayName: "Softchime", systemName: "Softchime.mp3")
    static let Freshstart = Alarm(displayName: "Freshstart", systemName: "Freshstart.mp3")
    static let MorningBirds = Alarm(displayName: "Morning Birds", systemName: "MorningBirds.mp3")
    static let Daybreak = Alarm(displayName: "Daybreak", systemName: "Daybreak.mp3")
    static let EarlyRiser = Alarm(displayName: "Early Riser", systemName: "EarlyRiser.mp3")
    static let SlowMorning = Alarm(displayName: "Slow Morning", systemName: "SlowMorning.mp3")
}

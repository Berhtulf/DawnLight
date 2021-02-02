//
//  UserSettings.swift
//  DawnLight
//
//  Created by Martin Václavík on 23.01.2021.
//

import SwiftUI

class UserSettings: ObservableObject{
    @Published var usingLocationData = true
    
    @Published var soundAndHaptic = true
    @Published var soundID = 1
    @Published var volume: Float = 0.5
}

//
//  DawnLightApp.swift
//  DawnLight
//
//  Created by Martin Václavík on 18.01.2021.
//

import SwiftUI

@main
struct DawnLightApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserSettings())
                .preferredColorScheme(.dark)
                .accentColor(.orange)
        }
    }
}

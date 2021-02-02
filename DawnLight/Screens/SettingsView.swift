//
//  SettingsView.swift
//  DawnLight
//
//  Created by Martin Václavík on 23.01.2021.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settings: UserSettings
    
    var body: some View {
        NavigationView{
                Form{
                    Section(header:Text("General")){
                        Toggle(isOn: $settings.usingLocationData, label: {
                            Text("Use location data")
                        })
                    }
                    Section(header:Text("Alarm")){
                        Toggle(isOn: $settings.soundAndHaptic, label: {
                            Text("Sound and haptic")
                        })
                        Section{
                            Picker("Sound", selection: $settings.soundID) {
                                ForEach(0..<100) { i in
                                    Text("\(i)")
                                }
                            }
                            HStack{
                                Image(systemName: "speaker.fill")
                                Slider(value: $settings.volume, in: 0...1, label: {Text("Volume")})
                                Image(systemName: "speaker.wave.3.fill")
                            }
                        }.disabled(!settings.soundAndHaptic)
                    }
                }
                .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(UserSettings())
            .preferredColorScheme(.dark)
    }
}

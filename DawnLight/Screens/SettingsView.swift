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
            VStack{
                Spacer()
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
                            Picker(selection: $settings.soundID, label: Text("Sound"), content: {
                                Text("Birds").tag(1)
                                Text("Dogs").tag(2)
                            })
                            HStack{
                                Image(systemName: "speaker.fill")
                                Slider(value: $settings.volume, in: 0...1, label: {Text("Volume")})
                                Image(systemName: "speaker.wave.3.fill")
                            }
                        }.disabled(!settings.soundAndHaptic)
                    }
                }
                .buttonStyle(CapsuleButtonStyle())
            }.navigationBarTitle("")
            .navigationBarHidden(true)
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

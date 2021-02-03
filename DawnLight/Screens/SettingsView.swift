//
//  SettingsView.swift
//  DawnLight
//
//  Created by Martin Václavík on 23.01.2021.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("usingGPS") private var usingGPS = true
    @AppStorage("soundAndHaptic") private var soundAndHaptic = true
    @AppStorage("soundID") private var soundID = 1
    @AppStorage("volume") private var volume = 0.5
    
    var body: some View {
        NavigationView{
            Form{
                Section(header:Text("General")){
                    Toggle("Use location data", isOn: $usingGPS)
                }
                Section(header:Text("Alarm")){
                    Toggle("Sound and haptic", isOn: $soundAndHaptic)
                    Section{
                        Picker("Sound", selection: $soundID) {
                            ForEach(0..<10) { i in
                                Text("\(i)")
                            }
                        }
                        HStack{
                            Image(systemName: "speaker.fill")
                            Slider(value: $volume, in: 0...1, label: {Text("Volume")})
                            Image(systemName: "speaker.wave.3.fill")
                        }
                    }
                    .disabled(!soundAndHaptic)
                }
            }
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}

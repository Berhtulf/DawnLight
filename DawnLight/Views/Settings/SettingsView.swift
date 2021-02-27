//
//  SettingsView.swift
//  DawnLight
//
//  Created by Martin Václavík on 23.01.2021.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView{
            List{
                Section(header:Text("General")){
                    Toggle("Use location data", isOn: $viewModel.usingGPS)
                }
                Section(header:Text("Alarm")){
                    NavigationLink(
                        destination: AlarmPicker(),
                        label: {
                            HStack{
                                Text("Sound")
                                Spacer()
                                Text(viewModel.alarm.displayName)
                                    .foregroundColor(.secondary)
                            }
                        })
                    HStack{
                        Image(systemName: "speaker.fill")
                        Slider(value: $viewModel.volume, in: 0...1, label: {Text("Volume")})
                        Image(systemName: "speaker.wave.3.fill")
                    }
                }
                Section(footer: Text("Set up your fixed alarm time. This time will be used if its earlier then sunrise. Only works if Location data is turned ON")){
                    DatePicker("Fixed alarm", selection: $viewModel.backupBuzz, displayedComponents: .hourAndMinute)
                }.disabled(!viewModel.usingGPS)
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
    }
}

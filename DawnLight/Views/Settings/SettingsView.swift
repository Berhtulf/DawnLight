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
                        .onChange(of: viewModel.usingGPS, perform: { value in
                            if value {
                                viewModel.checkLocationPermissions()
                            }
                        })
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
                    Picker(selection: $viewModel.snoozeInterval, label: Text("Snooze"), content: {
                        Text("5 min").tag(1)
                        Text("10 min").tag(2)
                        Text("15 min").tag(3)
                        Text("20 min").tag(4)
                        Text("25 min").tag(5)
                        Text("30 min").tag(6)
                    })
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

//
//  AlarmPicker.swift
//  DawnLight
//
//  Created by Martin Václavík on 22.02.2021.
//

import SwiftUI

struct AlarmPicker: View {
    var model: HomeViewModel
    @State var playingSample: Alarm?
    var alarmController = AlarmController()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List(Alarm.availableAlarms) { item in
            HStack{
                Text(item.displayName)
                Spacer()
                Image(systemName: playingSample != item ? "play.fill" : "stop.fill")
                    .onTapGesture {
                        if (playingSample != item){
                            alarmController.stopSample()
                            playingSample = item
                            alarmController.playSample(item, volume: model.volume)
                        }else{
                            alarmController.stopSample()
                            playingSample = nil
                        }
                    }
                    .foregroundColor(.accentColor)
                    .padding(.horizontal)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                model.alarm = item
                print(model.alarm)
                presentationMode.wrappedValue.dismiss()
            }
        }.listStyle(InsetListStyle())
        .onDisappear(){
            alarmController.stopSample()
        }
    }
}

struct AlarmPicker_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            AlarmPicker(model: HomeViewModel())
                .preferredColorScheme(.dark)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

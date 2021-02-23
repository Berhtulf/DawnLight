//
//  HomeView.swift
//  DawnLight
//
//  Created by Martin Václavík on 23.01.2021.
//

import SwiftUI
import AVFoundation
import MediaPlayer

struct HomeView: View {
    @ObservedObject var initModel: HomeViewModel
    var alarmController = AlarmController()
    
    @State var player: AVAudioPlayer?
    
    @State private var isMaxScale = true
    @State private var _animationTimer: Timer?
    
    var body: some View {
        VStack{
            if initModel.isLoading {
                LoadingView()
            } else {
                GeometryReader{ geometry in
                    VStack{
                        Link("Accurate times provided by Sunrise-Sunset.org", destination: URL(string: "https://sunrise-sunset.org")!)
                            .font(.caption)
                            .padding()
                        Spacer()
                        ZStack{
                            VStack{
                                DatePicker("", selection: $initModel.buzzDate, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .padding()
                                    .disabled(initModel.usingGPS || initModel.alarmSet)
                                    .scaleEffect(initModel.usingGPS ? 3 : 2.5)
                                    .padding(.vertical, initModel.usingGPS ? 0 : 20)
                                if (initModel.usingGPS){
                                    Text("Sunrise at \(initModel.sunriseTime ?? "NIL")")
                                }
                            }
                            Circle()
                                .strokeBorder(LinearGradient(
                                                gradient: Gradient(stops: [
                                                                    .init(color: .orange, location: 0),
                                                                    .init(color: .red, location: 1)]),
                                                startPoint: UnitPoint(x: 1, y: 1),
                                                endPoint: UnitPoint(x: 0, y: 0)),
                                              lineWidth: 5)
                                .padding(20)
                                .blur(radius: 1)
                                .scaleEffect(isMaxScale ? 1 : 0.9)
                        }
                        .frame(height: geometry.size.width)
                        .padding()
                        Button(action: {
                            initModel.alarmSet ? cancelAlarm() : scheduleAlarm()
                        }, label: {
                            Text(initModel.alarmSet ? "Cancel" : "Start")
                        })
                            .font(.system(size: 25))
                            .foregroundColor(.white)
                            .background(
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(LinearGradient(
                                            gradient: Gradient(stops: [
                                                                .init(color: Color(#colorLiteral(red: 1, green: 0.2705882489681244, blue: 0.22745098173618317, alpha: 1)), location: 0),
                                                                .init(color: Color(#colorLiteral(red: 1, green: 0.6235294342041016, blue: 0.03921568766236305, alpha: 1)), location: 1)]),
                                            startPoint: UnitPoint(x: 0, y: 0),
                                            endPoint: UnitPoint(x: 1, y: 1)))
                                    .frame(width: 222, height: 63)
                            )
                            .padding()
                        Spacer()
                    }
                }
            }
        }
    }
    
    private func cancelAlarm() {
        alarmController.cancelAlarm()
        _animationTimer?.invalidate()
        isMaxScale = true
        initModel.alarmSet = false
    }
    
    private func scheduleAlarm() {
        if initModel.usingGPS {
            guard let sunrise = initModel.sunriseAsDate else { return }
            initModel.buzzDate = sunrise
        }
        print(initModel.backupBuzz)
        initModel.updateBuzzTimes()
        if (initModel.usingGPS){
            initModel.buzzDate = min(initModel.buzzDate, initModel.backupBuzz)
        }
        alarmController.createAVPlayer(sound: initModel.alarm.systemName)
        alarmController.play(volume: initModel.volume, delay: initModel.buzzDate.timeIntervalSinceNow)
        
        initModel.alarmSet = true
        print("Alarm set to \(initModel.buzzDate), volume: \(initModel.volume), alarm: \(initModel.alarm.systemName)")
    }
    
    let dayInterval:TimeInterval = 86400
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(initModel: HomeViewModel())
            .preferredColorScheme(.dark)
    }
}

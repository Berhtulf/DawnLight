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
    @AppStorage("usingGPS") private var usingGPS = true
    @AppStorage("soundAndHaptic") private var soundAndHaptic = true
    @AppStorage("soundID") private var soundID = 1
    @AppStorage("volume") private var volume: Double = 1
    
    
    @StateObject var viewModel = HomeViewModel()
    
    @State private var player: AVAudioPlayer?
    
    @State private var isMaxScale = true
    private var animation = Animation.easeInOut(duration: 2).repeatForever(autoreverses: true)
    @State private var _animationTimer: Timer?
    
    var body: some View {
        VStack{
            if viewModel.isLoading {
                VStack(spacing: 20){
                    ProgressView()
                        .scaleEffect(2)
                    Text("Loading...")
                }
            } else {
                GeometryReader{ geometry in
                    VStack{
                        Spacer()
                        ZStack{
                            VStack{
                                DatePicker("", selection: $viewModel.buzzDate, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                    .padding()
                                    .disabled(usingGPS)
                                    .scaleEffect(usingGPS ? 3 : 2.5)
                                    .padding(.vertical, usingGPS ? 0 : 20)
                                if (usingGPS){
                                    Text("Sunrise at \(viewModel.sunriseTime ?? "NIL")")
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
                            viewModel.alarmSet ? cancelAlarm() : scheduleAlarm()
                        }, label: {
                            Text(viewModel.alarmSet ? "Cancel" : "Start")
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
        .onAppear{
            if (usingGPS){
                viewModel.loadWeatherData()
            }
        }
    }
    
    private func cancelAlarm(){
        player?.stop()
        viewModel.alarmSet = false
        
        _animationTimer?.invalidate()
        withAnimation(.easeInOut){
            isMaxScale = true
        }
    }
    
    private func scheduleAlarm() {
        if usingGPS {
            guard let sunrise = viewModel.sunriseAsDate else { return }
            viewModel.buzzDate = sunrise
        }
        
        let path = Bundle.main.path(forResource: "FantasyVillage.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        let delay:Double =  viewModel.buzzDate.timeIntervalSince1970 - Date().timeIntervalSince1970
        print("\(Date()) - \(viewModel.buzzDate) = \(delay)")
        do {
            player = try AVAudioPlayer(contentsOf: url)
            
            try AVAudioSession.sharedInstance().setActive(false)
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            UIApplication.shared.beginReceivingRemoteControlEvents()
        } catch let error as NSError {
            print("AVAudioSession error: \(error.localizedDescription)")
        }
        
        player!.volume = Float(volume)
        player!.prepareToPlay()
        player!.play(atTime: player!.deviceCurrentTime + delay)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay - 10) {
            MPVolumeView.setVolume(Float(volume))
        }
        
        viewModel.alarmSet = true
        
        withAnimation(.easeInOut(duration: 2)) {
            isMaxScale.toggle()
        }
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            _animationTimer = timer
            withAnimation(.easeInOut(duration: 2)) {
                isMaxScale.toggle()
            }
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .preferredColorScheme(.dark)
    }
}

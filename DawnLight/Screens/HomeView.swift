//
//  HomeView.swift
//  DawnLight
//
//  Created by Martin Václavík on 23.01.2021.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
    @EnvironmentObject var settings: UserSettings
    @ObservedObject var viewModel = HomeViewModel()
    @ObservedObject var locationViewModel = LocationViewModel()
    
    @State private var isLoading = false
    
    @State private var player: AVAudioPlayer?
    let weatherAPI = WeatherAPI(apiKey: "fe8b5986474317d00dd8b08ca8b886ff")
    
    var body: some View {
        VStack{
            if isLoading {
                ProgressView()
                    .scaleEffect(2)
            } else {
                if let sunrise = viewModel.sunrise {
                    GeometryReader{ geometry in
                        VStack{
                            Spacer()
                            ZStack{
                                VStack{
                                    DatePicker("", selection: $viewModel.buzzDate, displayedComponents: .hourAndMinute)
                                        .labelsHidden()
                                        .padding()
                                        .disabled(settings.usingLocationData)
                                        .scaleEffect(2.5)
                                        .padding(.vertical, settings.usingLocationData ? 0 : 20)
                                    Text("Sunrise at \(sunrise)")
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
                            }
                            .frame(height: geometry.size.width)
                            .padding()
                            Button("Start", action: scheduleAlarm)
                                .font(.system(size: geometry.size.width/20))
                                .foregroundColor(.white)
                                .background(
                                    RoundedRectangle(cornerRadius: geometry.size.width/3)
                                        .fill(LinearGradient(
                                                gradient: Gradient(stops: [
                                                                    .init(color: .orange, location: 0),
                                                                    .init(color: .red, location: 1)]),
                                                startPoint: UnitPoint(x: 1, y: 1),
                                                endPoint: UnitPoint(x: 0, y: 0)))
                                        .frame(width: geometry.size.width/3, height: min(geometry.size.width/3/2, 75), alignment: .center)
                                )
                                .padding()
                            Spacer()
                        }
                    }
                }
            }
        }
        .onAppear(perform:
                    loadWeatherData
        )
    }
    
    private func scheduleAlarm() {
        let path = Bundle.main.path(forResource: "FantasyVillage.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            
            try AVAudioSession.sharedInstance().setActive(false)
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: .duckOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            
            UIApplication.shared.beginReceivingRemoteControlEvents()
            
            print("playing")
        } catch let error as NSError {
            print("AVAudioSession error: \(error.localizedDescription)")
        }
        
        player!.volume = settings.volume
        player!.prepareToPlay()
        player!.play(atTime: player!.deviceCurrentTime + 10)
    }
    private func loadWeatherData() {
        if (settings.usingLocationData){
            isLoading = true
            try? weatherAPI.getWeather(lat: locationViewModel.userLatitude, lon: locationViewModel.userLongitude)
            { data in
                guard let data = data else { return }
                isLoading = false
                viewModel.setData(data)
            }
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserSettings())
            .preferredColorScheme(.dark)
    }
}

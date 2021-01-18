//
//  ContentView.swift
//  DawnLight
//
//  Created by Martin Václavík on 18.01.2021.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @ObservedObject var viewModel = MainViewModel()
    @ObservedObject var locationViewModel = LocationViewModel()
    @ObservedObject var weatherAPI = WeatherAPI()
    
    @AppStorage("usingLocationData") var usingLocationData = true
    
    @State var date = Date()
    var body: some View {
            TabView(selection: $viewModel.selectedTab){
                VStack{
                    if let location = locationViewModel.placeName?.name{
                        Text("Location: \(location)")
                            .padding()
                            .foregroundColor(.gray)
                    }
                    DatePicker("", selection: $weatherAPI.buzzDate, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .padding()
                        .scaleEffect(2.5)
                        .disabled(usingLocationData)
                    if let sunrise = weatherAPI.sunrise, let sunset = weatherAPI.sunset {
                        HStack(spacing: 50){
                            VStack{
                                Image(systemName: "sunset.fill")
                                    .renderingMode(.original)
                                Text(sunset)
                            }
                            
                            VStack{
                                Image(systemName: "sunrise.fill")
                                    .renderingMode(.original)
                                Text(sunrise)
                            }
                        }
                    }
                }
                .onAppear(){
                    if (usingLocationData){
                        weatherAPI.getWeatherData(lat: locationViewModel.userLatitude, lon: locationViewModel.userLongitude)
                    }
                }
                .tag(0)
                .tabItem{
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }
                
                VStack{
                    Spacer()
                    Form{
                        Toggle(isOn: $usingLocationData, label: {
                            Text("Use location data")
                        })
                    }
                    .buttonStyle(CapsuleButtonStyle())
                }
                .tag(1)
                .tabItem{
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}

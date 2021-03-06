//
//  ContentView.swift
//  DawnLight
//
//  Created by Martin Václavík on 18.01.2021.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @State var selectedTab = 0
    @EnvironmentObject var model: HomeViewModel
    var body: some View {
        if model.alarmSet {
            ZStack{
                if model.isShowingBlackScreen {
                    Color.black
                        .statusBar(hidden: true)
                        .onTapGesture {
                            model.hideBlackScreen()
                            model.startScreenTimer()
                        }
                }else{
                    GoodNightView()
                }
            }
            .animation(.easeInOut(duration: 1))
        }else{
            ZStack{
                TabView(selection: $selectedTab){
                    HomeView()
                        .tag(0)
                        .tabItem{
                            VStack {
                                Image(systemName: "house.fill")
                                Text("Home")
                            }
                        }
                    SettingsView()
                        .tag(1)
                        .tabItem{
                            VStack {
                                Image(systemName: "gear")
                                Text("Settings")
                            }
                        }
                }.transition(AnyTransition.opacity.combined(with: .move(edge: .bottom)))
                .alert(isPresented: $model.alarmRinging, content: {
                    Alert(title: Text("Wake UP"), message: Text("Sun is shining and so are you"), primaryButton: .cancel(Text("Snooze"), action: model.snoozeAlarm), secondaryButton: .default(Text("I'm up"), action: model.cancelAlarm))
                })
                
                if (model.isShowingLocationWarning){
                    ZStack{
                        Color(UIColor.systemBackground).opacity(0.6)
                            .ignoresSafeArea(.all)
                            .onTapGesture {
                                model.isShowingLocationWarning = false
                            }
                        VStack{
                            Spacer()
                            AllowLocationSettingsView(isPresented: $model.isShowingLocationWarning)
                        }
                    }
                }
            }.transition(.move(edge: .bottom))
        }
    }
    
    private func goToAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .accentColor(.orange)
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
    }
}

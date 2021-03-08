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
                GoodNightView()
                    .animation(.default)
                Color.black
                    .statusBar(hidden: model.screenHider.isShowingBlackScreen)
                    .onTapGesture {
                        model.screenHider.hideBlackScreen()
                        model.screenHider.startScreenTimer()
                    }
                    .opacity(model.screenHider.isShowingBlackScreen ? 1 : 0)
            }
            .transition(.move(edge: .bottom))
            .animation(.easeIn)
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
                        .onAppear{
                            model.calculateBestTime()
                        }
                    SettingsView()
                        .tag(1)
                        .tabItem{
                            VStack {
                                Image(systemName: "gear")
                                Text("Settings")
                            }
                        }
                        .animation(.none)
                }
                .alert(isPresented: $model.alarmRinging, content: {
                    Alert(title: Text("Wake UP"),
                          message: Text("Sun is shining and so are you"),
                          primaryButton: .cancel(Text("Snooze"),
                                                 action: {
                                                    model.snoozeAlarm(by: TimeInterval(model.snoozeInterval * 5 * 60))
                                                 }),
                          secondaryButton: .default(Text("I'm up"),
                                                    action: model.cancelAlarm))
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
            }
            .transition(.move(edge: .bottom))
            .animation(.spring())
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

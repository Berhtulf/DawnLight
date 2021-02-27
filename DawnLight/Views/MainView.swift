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
        }else{
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
            .sheet(isPresented: $model.isShowingLocationWarning){
                Text("Location services denied")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
    }
}

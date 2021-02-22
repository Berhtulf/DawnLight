//
//  ContentView.swift
//  DawnLight
//
//  Created by Martin Václavík on 18.01.2021.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @State var selectedTab = 0
    var model = HomeViewModel()
    var body: some View {
        TabView(selection: $selectedTab){
            HomeView(initModel: model)
                .tag(0)
                .tabItem{
                    VStack {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                }
            SettingsView(viewModel: model)
                .tag(1)
                .tabItem{
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .active:
                model.load()
                print("App is active")
            case .inactive:
                model.save()
                print("App is inactive")
            case .background:
                print("App is in background")
            @unknown default:
                print("Oh - interesting: I received an unexpected new value.")
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



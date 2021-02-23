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
    var model: HomeViewModel
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(model: HomeViewModel())
            .preferredColorScheme(.dark)
    }
}



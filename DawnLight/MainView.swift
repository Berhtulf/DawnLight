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
    
    @State var date = Date()
    var body: some View {
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
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}



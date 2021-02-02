//
//  MainViewModel.swift
//  DawnLight
//
//  Created by Martin Václavík on 18.01.2021.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var model = MainModel()
    
    var selectedTab: Int {
        get {
            model.selectedTab
        }
        set {
            model.selectedTab = newValue
        }
    }
    
    var sunrise: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date(timeIntervalSince1970: model.sunrise ?? 0))
    }
    
    var sunset: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: Date(timeIntervalSince1970: model.sunset ?? 0))
    }
    
    var buzzDate:Date {
        get{
            Date(timeIntervalSince1970: model.sunrise ?? 0)
        }
        set{
            model.sunrise = newValue.timeIntervalSince1970
        }
    }
    
    //MARK: - Intents
    func setData(_ data: WeatherData) {
        print(data)
        model.buzzDate = data.sys.sunrise
        model.sunrise = data.sys.sunrise
        model.sunset = data.sys.sunset
    }
}

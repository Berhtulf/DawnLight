//
//  MainModel.swift
//  DawnLight
//
//  Created by Martin Václavík on 19.01.2021.
//

import Foundation

struct HomeModel {
    var selectedTab = 0
    var sunrise: String?
    
    var buzzDate: TimeInterval {
        get {
            UserDefaults.standard.double(forKey: StringConstants.sunrise.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: StringConstants.sunrise.rawValue)
        }
    }
}

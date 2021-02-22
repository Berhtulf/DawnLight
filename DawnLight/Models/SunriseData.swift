//
//  SunriseData.swift
//  DawnLight
//
//  Created by Martin Václavík on 06.02.2021.
//

import Foundation

struct SunriseData: Codable {
    var results: Results
    var status: String
}

struct Results: Codable {
    var sunrise: String
    var sunset: String
}

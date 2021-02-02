//
//  WeatherData.swift
//  DawnLight
//
//  Created by Martin Václavík on 23.01.2021.
//

import Foundation

struct WeatherData : Codable {
    var sys: Sys
}
struct Sys: Codable{
    var sunset: TimeInterval
    var sunrise: TimeInterval
}

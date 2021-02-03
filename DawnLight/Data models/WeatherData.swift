//
//  WeatherData.swift
//  DawnLight
//
//  Created by Martin Václavík on 23.01.2021.
//

import Foundation

struct WeatherData : Codable {
    var astronomy: Astronomy
}
struct Astronomy: Codable{
    var astro: Astro
}
struct Astro: Codable {
    var sunrise: String
}

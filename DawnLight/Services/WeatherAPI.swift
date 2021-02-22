//
//  WeatherAPI.swift
//  DawnLight
//
//  Created by Martin Václavík on 18.01.2021.
//

import Foundation

class WeatherAPI {
    func getWeather(lat: Double, lon: Double, _ completion: @escaping (SunriseData?) -> () ) throws {
        var urlParams = [URLQueryItem]()
        
        urlParams.append(URLQueryItem(name: "lat", value: "\(lat)"))
        urlParams.append(URLQueryItem(name: "lng", value: "\(lon)"))
        urlParams.append(URLQueryItem(name: "formatted", value: "0"))
        urlParams.append(URLQueryItem(name: "date", value: "tomorrow"))
        guard var url = URLComponents(string: "https://api.sunrise-sunset.org/") else {
            throw WeatherAPIError.invalidURL
        }
        url.queryItems = urlParams
        url.path.append("json")
        guard let urlPath = url.url else {
            throw WeatherAPIError.invalidURL
        }
        print("Sending API Request")
        var request = URLRequest(url: urlPath, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                //TODO: - handle error
            } else {
                guard let data = data else { return }
                let weatherData = try? JSONDecoder().decode(SunriseData.self, from: data)
                DispatchQueue.main.async {
                    completion(weatherData)
                }
            }
        }.resume()
    }
}

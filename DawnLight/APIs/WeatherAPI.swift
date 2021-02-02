//
//  WeatherAPI.swift
//  DawnLight
//
//  Created by Martin Václavík on 18.01.2021.
//

import Foundation

enum WeatherAPIErrors : Error {
    case invalidURL
    case invalidAPIKey
}

class WeatherAPI {
    private var apiKey: String
    private var baseURL = "https://api.openweathermap.org/data/2.5/"
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func getWeather(lat: Double, lon: Double,_ completion: @escaping (WeatherData?) -> () ) throws {
        var urlParams = [URLQueryItem]()
        urlParams.append(URLQueryItem(name: "appid", value: apiKey))
        urlParams.append(URLQueryItem(name: "units", value: "metric"))
        urlParams.append(URLQueryItem(name: "lat", value: "\(lat)"))
        urlParams.append(URLQueryItem(name: "lon", value: "\(lon)"))
        guard var url = URLComponents(string: baseURL) else {
            throw WeatherAPIErrors.invalidURL
        }
        url.queryItems = urlParams
        url.path.append("weather")
        guard let urlPath = url.url else {
            throw WeatherAPIErrors.invalidURL
        }
        
        let request = URLRequest(url: urlPath, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data)
            DispatchQueue.main.async {
                completion(weatherData)
            }
        }.resume()
    }
}

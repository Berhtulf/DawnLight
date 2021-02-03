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
    private var apiKey: String = "fe8b5986474317d00dd8b08ca8b886ff"
    private var baseURL = "https://weatherapi-com.p.rapidapi.com/"
    
    
    func getWeather(lat: Double, lon: Double,_ completion: @escaping (WeatherData?) -> () ) throws {
        var urlParams = [URLQueryItem]()
    
        let stringDateFormatter = DateFormatter()
            stringDateFormatter.dateFormat = "yyyy-MM-dd"
        let dateText = stringDateFormatter.string(from: Date().add(days: 1))
        
        urlParams.append(URLQueryItem(name: "dt", value: dateText))
        urlParams.append(URLQueryItem(name: "q", value: "\(lat),\(lon)"))
        guard var url = URLComponents(string: baseURL) else {
            throw WeatherAPIErrors.invalidURL
        }
        url.queryItems = urlParams
        url.path.append("astronomy.json")
        guard let urlPath = url.url else {
            throw WeatherAPIErrors.invalidURL
        }
        
        let headers = [
            "x-rapidapi-key": "9fc717f313msh990c369cba1caa7p119254jsn90814659232e",
            "x-rapidapi-host": "weatherapi-com.p.rapidapi.com"
        ]
        print(urlPath)
        
        var request = URLRequest(url: urlPath, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                //TODO: - handle error
            } else {
                guard let data = data else { return }
                let weatherData = try? JSONDecoder().decode(WeatherData.self, from: data)
                DispatchQueue.main.async {
                    completion(weatherData)
                }
            }
        }.resume()
    }
}

//
//  WeatherAPI.swift
//  DawnLight
//
//  Created by Martin Václavík on 18.01.2021.
//

import Foundation

class WeatherAPI: ObservableObject {
    @Published var sunrise: String?
    @Published var sunset: String?
    @Published var buzzDate = Date()
    
    func getWeatherData(lat: Double, lon: Double) {
        let headers = [
            "x-rapidapi-key": "9fc717f313msh990c369cba1caa7p119254jsn90814659232e",
            "x-rapidapi-host": "weatherapi-com.p.rapidapi.com"
        ]
        
        let tomorow = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        let day = Calendar.current.component(.day, from: tomorow!)
        let month = Calendar.current.component(.month, from: tomorow!)
        let year = Calendar.current.component(.year, from: tomorow!)
        
        let url = URL(string: "https://weatherapi-com.p.rapidapi.com/astronomy.json?q=\(lat),\(lon)&dt=\(year)-\(month)-\(day)")
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.allHTTPHeaderFields = headers
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8)!)
            let weatherData = try! JSONDecoder().decode(WeatherData.self, from: data)
            DispatchQueue.main.async {
                self.sunrise = weatherData.astronomy.astro.sunrise
                self.sunset = weatherData.astronomy.astro.sunset
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "h:mm a"
                if let sunrise = self.sunrise {
                    let date = dateFormatter.date(from: sunrise)
                    
                    let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
                    let dateComponents = gregorian.components([.year, .month, .day, .hour, .minute, .timeZone], from: date!)
                    var tomorrowComponents = gregorian.components([.year, .month, .day, .hour, .minute, .timeZone], from: tomorow!)
                    
                    tomorrowComponents.hour = dateComponents.hour
                    tomorrowComponents.minute = dateComponents.minute
                    
                    let tomDate = gregorian.date(from: tomorrowComponents)!
                    
                    self.buzzDate = tomDate
                }
            }
        }
        
        task.resume()
    }
}


struct WeatherData : Codable {
    var location: Location
    var astronomy: Astronomy
}
struct Location: Codable {
    var name: String
    var lat: Double
    var lon: Double
}
struct Astronomy: Codable{
    var astro: AstronomyData
}
struct AstronomyData: Codable{
    var sunset: String
    var sunrise: String
    var moon_phase: String
}

//
//  WeatherManager.swift
//  WeatherDemo
//
//  Created by Temi Lajumoke on 12/20/21.
//

import Foundation
import CoreLocation

//aae022dc3e8133a9cb492c4851e12c8d
//api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
class WeatherManager {
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\("aae022dc3e8133a9cb492c4851e12c8d")&units=metric") else {
            fatalError("Missing URL")
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Erro fetching weather data")}
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        return decodedData
    }
}


struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse
    
    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }
    
    struct WeatherResponse: Decodable {
        var id: Int
        var main: String
        var description: String
        var icon: String
    }
    
    struct MainResponse: Decodable {
        let temp, feels_like, temp_min, temp_max: Double
        let pressure: Int
        let humidity: Double
        let sea_level: Int?
        let grnd_level: Int?
    }
    
    struct WindResponse: Decodable {
        let speed: Double
        let deg: Int
        let gust: Double
    }
}

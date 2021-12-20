//
//  ContentView.swift
//  WeatherDemo
//
//  Created by Temi Lajumoke on 12/20/21.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManger = LocationManager()
    var weatherManager = WeatherManager()
    
    @State var weather: ResponseBody?
    
    var body: some View {
        VStack {
            if let location = locationManger.location {
                if let weather = weather {
                    WeatherView(weather: weather)
                } else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                
                            } catch {
                                print("Error getting eeather: \(error)")
                            }
                        }
                }
            } else {
                if locationManger.isLoading {
                    LoadingView()
                } else {
                    WelcomeView()
                        .environmentObject(locationManger)
                }
            }
        }
        .background(Color(hue: 0.613, saturation: 0.96, brightness: 0.303))
        .preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

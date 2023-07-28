//
//  WeatherSearchViewModel.swift
//  WeatherApp
//
//  Created by Ngoc Nguyen on 6/28/23.
//

import Foundation

final class WeatherViewModel: ObservableObject {
    @Published var weatherList: [WeatherInfo] = [] //Current weather info
    
    var service: WeatherServiceProtocol
    
    init(service: WeatherServiceProtocol) {
        self.service = service
    }
    
    func fetchWeather(by city: String){
        Task{
            do{
                //Fetch Weather by city
                let locationResponses = try await service.fetchWeather(city: city)
                // Extract the first location
                guard let locationResponse = locationResponses.first else { return }

                // Extract Lat and lon
                let lat = locationResponse.lat
                let lon = locationResponse.lon
                print("Lat: \(lat)")
                print("Lon: \(lon)")

                //Fetch Weather by lat/lon
                fetchWeather(lat: lat, lon: lon)
            } catch {
                if let networkError = error as? NetworkError {
                    print("Error occurred during fetching by city: \(networkError.description)")
                }
            }
        }
    }
    
    func fetchWeather(lat: Double, lon: Double){
        Task{
            do{
                let weatherByLatLonResponse = try await service.fetchWeather(lat: lat, lon: lon)
                self.weatherList.insert(WeatherInfo(model: weatherByLatLonResponse), at: 0)
            } catch {
                if let networkError = error as? NetworkError {
                    print("Error occurred during fetching by lon, lat: \(networkError.description)")
                }
            }
        }
    }
}
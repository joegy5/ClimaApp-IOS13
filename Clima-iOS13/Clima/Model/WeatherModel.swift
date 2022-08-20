//
//  WeatherModel.swift
//  Clima
//
//  Created by Suren Gurivireddy on 7/28/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    
    // This is a computed property. It is a property that can be calculated by using the code within the curly braces
    // The return statements output what the value of conditionName should be
    // Computed properties must always be preceded by the var keyword, not the let keyword
    // The data type of the computed property should also be specified
    var conditionName: String {
        switch conditionID {
            case 200...232:
               return "cloud.bolt"
            case 300...321:
                return "cloud.drizzle"
            case 500...531:
                return "cloud.rain"
            case 600...622:
                return "cloud.snow"
            case 701...781:
                return "cloud.fog"
            case 800:
                return "sun.max"
            case 801...804:
                return "cloud.bolt"
            default:
                return "cloud"
        }
    }

    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
}

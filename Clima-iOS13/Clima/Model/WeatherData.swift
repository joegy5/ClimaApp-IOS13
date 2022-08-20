//
//  WeatherData.swift
//  Clima
//
//  Created by Suren Gurivireddy on 7/27/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
// Typealias Codable is just a protocol that combines the Decodable and Encodable protocls together
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather] // the properties inside the weather property are in an array, with a single item in the array containing all those inside properties
        // So, we can create a Weather struct with all those properties, inside an array to mimick the way it is in the JSON format
}

struct Main: Codable {
    let temp: Double
    let feels_like: Float
    let temp_min: Float
    let temp_max: Float
    let pressure: Int
    let humidity: Int
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

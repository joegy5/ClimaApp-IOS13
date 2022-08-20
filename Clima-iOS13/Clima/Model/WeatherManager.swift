//
//  WeatherManager.swift
//  Clima
//
//  Created by Suren Gurivireddy on 7/27/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager : WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var weatherURL =  "https://api.openweathermap.org/data/2.5/weather?appid=77e78b06f4b8bc7f2b99b77c1af8918a&units=metric"
    //NOTE: MAKE SURE TO USE https, NOT http, as http is not secure
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName : String) {
        let urlString = weatherURL + "&q=\(cityName)"
        performRequest(with: urlString) // Replacing parameter name with "with" to make code more readable, beacuse saying "perform request with urlString" sounds better than "perform request urlString: urlString"
    }
    
    func performRequest(with urlString : String) {
        // 1. Create a URL
        
        // optional binding because URL is initialized as URL? because of possible typos in string causing the URL to fail
        if let url = URL(string: urlString) {
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the URLSession a task
            let task = session.dataTask(with: url) { data, response, error in // The compiler can infer the data types of each of the parameters
                // The below code will be triggered AFTER the data task is done, because that is the purpose of the function parameter "completionHandler"
                
                if error != nil {
                    // Checking if there is an error
                    self.delegate?.didFailWithError(error: error!) // Just exit the function, because the URLSession has failed
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {// add the self keyword for calling methods whenever inside a closure
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        
                        
                    }
                }
            }
            // The completionHandler parameter takes in a function as input, and the function does not actually need any parameters. This is because
            // once the session is done, the task variable itself will trigger the handle() function with appropriate inputs of its own. Once the handle() function is called, we can access the values of its parameters as shown below.
            
            // 4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? { // Return type is optional so that we have the option to return nil if there is an error in the process
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData) // The decode function returns a WeatherData object that is stored in the decodedData variable
            // The decodedData object will now have all the properties of the JSON weather data, decoded into the Swift language
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weatherModel = WeatherModel(conditionID: id, cityName: name, temperature: temp)
            return weatherModel
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
// If we keep implementing more and more delegate protocols, our code will start getting messy. So, we can implement extensions for each type of the same class that implements a different protocol, with the syntax:
// extension SomeType: Protocol {
// }
// This is an extension of the same class but for a specific protocol
class WeatherViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.delegate = self
        weatherManager.delegate = self
        
    }

    
}

//MARK: - UITextFieldDelegate
// This sepeartes the code into sections: one with the WeatherViewController, and the other with the extension UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    // Note: None of these following functions are called by the view controller itself.
    // Instead, they are called by the UITextFieldDelegate class that is responsible for deciding when to call these following functions based on the data it gets from the user interactions in the user interface
    // When these functions are triggered, a parameter called textField is passed into the triggered function, and it is the same textField object that caused the class to trigger the function in the first place, which in our case, is represented by the searchTextField object. That is why, for example in the textFieldShouldEndEditing function, we use the variable textField instead of searchTextField without any problems
    
    // This function is to process when the return ("go") keyword is pressed
    
    // This is useful when there are multiple text fields
    
    // This same concept applies to the other functions above, like the functions that get triggered when the buttons get pressed
    
    
    // The reason we don't have to implement these methods below is because there is an underlying extension created by Apple itself that already gives default implementations of these functions to whatever class or struct that implements the UITextFieldDelegate protocol
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Makes sure that the keyboard actually goes awaqy after either the search button or the "go" button (on the keyboard) is pressed
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    // triggered whenever the .endEditing() function is called on the textField object
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Use the text in the text field to get the weather from the city that the user entered into the text field before setting the textField.text equal to an empty string
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName : city)
        }
        
        textField.text = ""
        
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }
        else {
            textField.placeholder = "Type Something"
            return false
        }
    }

    
}

//MARK: - WeatherManagerDelegate
// sepearates the WeatherManagerdelegate extension into its own section
extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager : WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async { // have to wrap our code in this DispatchQueue closure because the completion handler is the function that is providing the weather data to here, and it is running in the backgrond so that it does not interfere with the UI (because that function is dependent on the actual networking being done, which may take some time). Otherwise, the app would be frozen until the networking is done.
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
        
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}



//
//  ViewController.swift
//  weatherTestApp
//
//  Created by iMac on 8/9/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    var myZip: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.zipCode.delegate = self
        
        //let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=ed9908158efded926d6117d0a36ae15f")
        
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        
        myZip = zipCode.text

        getData()
        

        return false
        
        
    }
    
    @IBAction func zipCodeEntered(sender: AnyObject) {
        
        myZip = zipCode.text
        
        getData()
    }
    private func getData() {
        
        let zip = "33069"
        
        myZip = zipCode.text
        
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?zip=\(myZip),us&appid=ed9908158efded926d6117d0a36ae15f")
        print(zip)
        print(url)
        
        let request = NSMutableURLRequest(URL: url!)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            
            
            func displayError(error: String) {
                
                print(error)
                
            }
            
            if error == nil {
                guard let data = data else {
                    
                    displayError("No data was returned from the request")
                    return
                    
                }
                
                let result: AnyObject!
                
                do {
                    result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                } catch {
                    
                    print("Could not parse the data as JSON")
                    return
                    
                }
                
                //print(result)
                if let weather = result["weather"] as? NSArray, mainWeather = result["main"] as? [String: AnyObject], wind = result["wind"] as? [String: AnyObject], sys = result["sys"] as? [String: AnyObject], currentCoor = result["coord"] as? [String: AnyObject], currentCity = result["name"] as? String, clouds = result["clouds"] as? [String: AnyObject]{
                    
                    let weatherDict = weather[0] as? [String: AnyObject]
                    
                    //print(currentCoor)
                    //print(currentCoor["lat"])
                    let currentLat: Float = (currentCoor["lat"] as? Float)!
                    let currentLon: Float = (currentCoor["lon"] as? Float)!
                    //print("\(currentLat)")
                    //print(currentLon)
                    
                    //print(weatherDict!["description"])
                    //print(mainWeather)
                    //print(wind)
                    //print(sys["sunrise"])
                    var windSpeed: Float = (wind["speed"] as? Float)!
                    windSpeed = windSpeed * 2.2369362921
                    let windDirection: Float = (wind["deg"] as? Float)!
                    let kelvin: Float = (mainWeather["temp"] as? Float)!
                    let Fahrenheit: Float = (kelvin - 273.15) * 1.8000 + 32.00
                    let cloudiness: Float = (clouds["all"] as? Float)!
                    
                    performUIUpdatesOnMain() {
                     
                        
                        self.latitudeLabel.text = "Latitude: \(currentLat)"
                        self.longitudeLabel.text = "Longitude: \(currentLon)"
                        self.cityLabel.text = "City: \(currentCity)"
                        self.tempLabel.text = "Tempurature: \(Fahrenheit) F."
                        self.windLabel.text = "Speed: \(windSpeed)MPH, Direction: \(windDirection)"
                        self.cloudsLabel.text = "Cloudiness: \(cloudiness)%"
                        
                    }

                    
                }
                
                
                
                
            }
            
        }
        task.resume()
    
    }
    

}


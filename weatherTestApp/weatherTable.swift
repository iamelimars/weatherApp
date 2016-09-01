//
//  weatherTable.swift
//  weatherTestApp
//
//  Created by iMac on 8/9/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

import UIKit
import MXParallaxHeader
import ChameleonFramework
import CoreLocation
import JSSAlertView




class weatherTable: UITableViewController, CLLocationManagerDelegate {

    var daysArray = []
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    let locationCLLocation = CLLocation()
    var startLocation: CLLocation!
    var currentLocationString: NSString = ""
    var myCustomView: customHeaderView! = nil
    var myErrorPage: errorView! = nil
    //var longitude: CLLocationDegrees!
    //var latitude: CLLocationDegrees!
    var currentWeather = [Weather]()
    var currentLocationWeather = [locationWeather]()
    var currentWeatherDetails = [WeatherDetails]()
    var testString = ""
    var coldColors = [UIColor]()
    var hotColors = [UIColor]()
    var normalColors = [UIColor]()
    
    var currentConditionArray = [String:String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daysArray = ["Tommorrow", "2.Days.Out", "3.Days.Out", "4.Days.Out", "5.Days.Out", "6.Days.Out", "7.Days.Out", "8.Days.Out"]
        
        //http://www.mapquestapi.com/geocoding/v1/reverse?key=20nebg0CcusFuel5NExAlbSALLkwuQmN&callback=renderReverse&location=40.053116,-76.313603
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.parallaxHeader.height = self.view.frame.size.height - 150
        self.tableView.parallaxHeader.mode = MXParallaxHeaderMode.Fill
        self.tableView.parallaxHeader.minimumHeight = 150
        self.tableView.parallaxHeader.view?.backgroundColor = UIColor.flatTealColor()
        
        //self.tableView.parallaxHeader.view = NSBundle.mainBundle().loadNibNamed("customHeader", owner: self, options: nil).first as? UIView
        
        self.navigationController?.navigationBarHidden = true
        
        coldColors = [UIColor.flatBlueColor(),
                      UIColor.flatWhiteColor()]
        hotColors = [UIColor.flatRedColor(),
                         UIColor.flatOrangeColor()]
        normalColors = [UIColor.flatOrangeColor(),
                            UIColor.flatSkyBlueColor()]
        
        myCustomView = UINib(nibName: "customHeader", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! customHeaderView
        //myCustomView.changeBackground(UIColor.flatBlueColor(), color2: UIColor.flatWhiteColor())
        myCustomView.backgroundColor = UIColor.init(gradientStyle: UIGradientStyle.TopToBottom, withFrame: self.view.frame, andColors: normalColors)
        myCustomView.backButton.addTarget(self, action: #selector(weatherTable.dismissVC(_:)), forControlEvents: .TouchUpInside)
        let myBackButton = myCustomView.backButton as UIButton
        //backButton.addTarget(self, action: Selector(dismissVC()), forControlEvents:.TouchUpInside)
        self.parallaxHeader?.view?.addSubview(myBackButton)
        self.tableView.parallaxHeader.view = myCustomView
 
        
    }

 
    override func viewDidAppear(animated: Bool) {
        if testString == "" {
            getCurrentLocation()
        } else {
            myCustomView.cityLabel.text = "City.\(testString)"
            getData(testString)
        }
    }
    override func viewDidDisappear(animated: Bool) {
        
        self.currentWeather = []
        self.currentLocationWeather = []
        self.currentWeatherDetails = []
        
    }
    func changeParallaxBackground(color1: UIColor, color2: UIColor, parallaxView: UIView) -> Void{
        //let colors = [color1,
         //             color2]
        
        //self.backgroundColor = UIColor.init(gradientStyle: UIGradientStyle.TopToBottom, withFrame: self.frame, andColors: colors)
        //parallaxView.backgroundColor = UIColor.blackColor()
        //self.backgroundView.backgroundColor = UIColor.init(gradientStyle: UIGradientStyle.TopToBottom, withFrame: self.backgroundView.frame, andColors: colors)
        
    }
    func dismissVC(sender:UIButton) {
        //self.dismissViewControllerAnimated(false, completion: nil)
        
        self.performSegueWithIdentifier("toWeatherTable", sender: self)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navVC = segue.destinationViewController as! UINavigationController
        
        let secondViewController = navVC.viewControllers.first as! MenuViewController
        
        //let secondViewController = segue.destinationViewController as! MenuViewController
        secondViewController.weatherViewController = self
    }
    
    func getCurrentLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        performSelector(#selector(stopUpdatingLocation), withObject: self, afterDelay: 1.0)
        
        }
    func stopUpdatingLocation() {
        //
        print(currentLocationWeather.count)
        
        //performSelector(Selector(getData(self.currentLocationString as String)), withObject: self, afterDelay: 3.0)

        locationManager.stopUpdatingLocation()
        myCustomView.cityLabel.text = "City.\(self.currentLocationString)"
        getData(self.currentLocationString as String)
        
    }
    
    //Mark: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latestLocation: AnyObject = locations[locations.count - 1]
        
        let latitude: CLLocationDegrees = latestLocation.coordinate.latitude
        let longitude: CLLocationDegrees = latestLocation.coordinate.longitude
        let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) -> Void in
            
            
            if error != nil {
                
                print("Reverse Geocode Failed")
                return
                
            }
            if placemarks?.count > 0 {
                let pm = placemarks![0] 
                //print("\(pm.locality)")
                if let cityName = pm.locality {
                    self.currentLocationString = cityName
                }
                //self.currentLocationString = "\(pm.locality)" as! String
                

                
            } else {
                print("Problem with data received by geocoder")
            }
        })
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentWeather.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! weatherCell
        let weather = currentWeather[indexPath.row]
        cell.descriptionLabel.text = weather.text
        cell.hiLabel.text = weather.high
        cell.lowLabel.text = weather.low
        cell.currentDayLabel.text = weather.day
        
        return cell
        
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 75.0
        
    }
    
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        //NSLog("progress %f", scrollView.parallaxHeader.progress)
    }

    
    func customAlertView (alertColor: UIColor, customTitle: String) {
        
        let alertview = JSSAlertView().show(self,
                                            title: customTitle,
                                            text: "We're having trouble getting your weather.",
                                            buttonText: "Try Again?!",
                                            color: alertColor
        )
        
        alertview.addAction(self.myCallback) // Method to run after dismissal
        alertview.setTitleFont("HelveticaNeue-Light") // Title font
        alertview.setTextFont("HelveticaNeue-Thin") // Alert body text font
        alertview.setButtonFont("HelveticaNeue-UltraLight") // Button text font
        alertview.setTextTheme(.Light) // can be .Light or .Dark

    }
    
    func myCallback() {
        // this'll run after the alert is dismissed
        
        if testString == "" {
            getCurrentLocation()
        } else {
            myCustomView.cityLabel.text = "City.\(testString)"
            getData(testString)
        }
        
    }
    
    func getData(currentCity:String) {
        let city = self.currentLocationString as String
        let replacedCity = (currentCity as NSString).stringByReplacingOccurrencesOfString(" ", withString: "%20")
        let replacedCityComma = (replacedCity as NSString).stringByReplacingOccurrencesOfString(",", withString: "%2C")
        
        let url = NSURL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(replacedCityComma)%22)&format=json&diagnostics=true&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback=")
        let request = NSMutableURLRequest(URL: url!)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in
            
            func displayError (error: String){
                print(error)
            }
            if error == nil {
                
                guard let data = data else {
                    displayError("No data was returned from the request")
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.customAlertView(UIColor.flatOrangeColor(), customTitle: "😩 Awww Sorry")
                    })
                    return
                }
            
                let result: AnyObject!
                do {
                    result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                } catch {
                    print("Could not parse the data as JSON")
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.customAlertView(UIColor.flatGrayColor(), customTitle: "😕 Sorry About That!")

                        
                    })
                    return
                }
                
                guard let query = result["query"] as? [String: AnyObject],
                    let results = query["results"] as? [String:AnyObject],
                    let channel = results["channel"] as? [String:AnyObject],
                    let astronomy = channel["astronomy"] as? [String:AnyObject],
                    let atmosphere = channel["atmosphere"] as? [String:AnyObject],
                    let wind = channel["wind"] as? [String:AnyObject],
                    let item = channel["item"] as? [String:AnyObject],
                    let forecast = item["forecast"] as? NSArray,
                    let condition = item["condition"] as? [String:AnyObject] else  {
                    
                    print("We're having trouble getting your weather")
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        self.customAlertView(UIColor.flatSkyBlueColor(), customTitle: "🙄 OOOPS")
                        
                    })
                    //self.errorPage()
                    return
                        
                }
                let myWeatherDetails = WeatherDetails()
                myWeatherDetails.sunrise = astronomy["sunrise"] as! String
                myWeatherDetails.sunset = astronomy["sunset"] as! String
                myWeatherDetails.humidity = atmosphere["humidity"] as! String
                myWeatherDetails.windChill = wind["chill"] as! String
                myWeatherDetails.windSpeed = wind["speed"] as! String
                self.currentWeatherDetails.append(myWeatherDetails)
                
                for items in condition {
                    
                    let myLocationWeather = locationWeather()
                    myLocationWeather.date = condition["date"] as! String
                    myLocationWeather.temp = condition["temp"] as! String
                    myLocationWeather.text = condition["text"] as! String
                    self.currentLocationWeather.append(myLocationWeather)
                    
                }
                for days in forecast {
                    if let day = days as? [String:AnyObject] {
                        
                        let weather = Weather()
                        weather.date = day["date"] as! String
                        weather.day = day["day"] as! String
                        weather.high = day["high"] as! String
                        weather.low = day["low"] as! String
                        weather.text = day["text"] as! String
                        self.currentWeather.append(weather)
                        
                    }
                }
                
                
                /*
                if let query = result["query"] as? [String: AnyObject]{
                    if let results = query["results"] as? [String:AnyObject] {
                        if let channel = results["channel"] as? [String:AnyObject] {
                            if let item = channel["item"] as? [String:AnyObject] {
                                if let forecast = item["forecast"] as? NSArray, condition = item["condition"] as? [String:AnyObject] {
                                    for items in condition {
                                        let myLocationWeather = locationWeather()
                                        myLocationWeather.date = condition["date"] as! String
                                        myLocationWeather.temp = condition["temp"] as! String
                                        myLocationWeather.text = condition["text"] as! String
                                        self.currentLocationWeather.append(myLocationWeather)
                                    }
                                        
                                    for days in forecast {
                                        if let day = days as? [String:AnyObject] {
                                            //if self.currentWeather.count <= 6 {
                                            
                                                let weather = Weather()
                                                weather.date = day["date"] as! String
                                                weather.day = day["day"] as! String
                                                weather.high = day["high"] as! String
                                                weather.low = day["low"] as! String
                                                weather.text = day["text"] as! String
                                                self.currentWeather.append(weather)
                                                
                                            //}
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                */

                dispatch_async(dispatch_get_main_queue()) {
                    
                    self.tableView.reloadData()
                    let myCurrentWeather = self.currentLocationWeather[0]
                    self.myCustomView.degreesLabel.text = "\(myCurrentWeather.temp)˚"
                    let degreesString: String = myCurrentWeather.temp
                    
                    let myCurrentWeatherDetails = self.currentWeatherDetails[0]
                    self.myCustomView.sunriseLabel.text = myCurrentWeatherDetails.sunrise
                    self.myCustomView.sunsetLabel.text = myCurrentWeatherDetails.sunset
                    self.myCustomView.humidityLabel.text = myCurrentWeatherDetails.humidity
                    self.myCustomView.windChillLabel.text = myCurrentWeatherDetails.windChill
                    self.myCustomView.windSpeedLabel.text = myCurrentWeatherDetails.windSpeed
                    
                    let a:Int? = Int(degreesString)
                    
                    if a <= 60 {
                        
                        self.myCustomView.backgroundColor = UIColor.init(gradientStyle: UIGradientStyle.TopToBottom, withFrame: self.view.frame, andColors: self.coldColors)

                        
                    } else if a>60 && a <= 75 {
                        
                        self.myCustomView.backgroundColor = UIColor.init(gradientStyle: UIGradientStyle.TopToBottom, withFrame: self.view.frame, andColors: self.normalColors)
                        
                        
                    } else if a > 75 {
                        
                        self.myCustomView.backgroundColor = UIColor.init(gradientStyle: UIGradientStyle.TopToBottom, withFrame: self.view.frame, andColors: self.hotColors)

                    }
                    
                    self.myCustomView.descriptionLabel.text = myCurrentWeather.text
                }
            }
        }
        task.resume()
    }

}

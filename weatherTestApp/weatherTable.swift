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



class weatherTable: UITableViewController, CLLocationManagerDelegate {

    var daysArray = []
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    let locationCLLocation = CLLocation()
    var startLocation: CLLocation!
    var currentLocationString: NSString = ""
    var myCustomView: customHeaderView! = nil
    //var longitude: CLLocationDegrees!
    //var latitude: CLLocationDegrees!
    var currentWeather = [Weather]()
    var currentLocationWeather = [locationWeather]()
    var testString = ""
    
    var currentConditionArray = [String:String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        daysArray = ["Tommorrow", "2.Days.Out", "3.Days.Out", "4.Days.Out", "5.Days.Out", "6.Days.Out", "7.Days.Out", "8.Days.Out"]
        
        //http://www.mapquestapi.com/geocoding/v1/reverse?key=20nebg0CcusFuel5NExAlbSALLkwuQmN&callback=renderReverse&location=40.053116,-76.313603
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.parallaxHeader.height = 400
        self.tableView.parallaxHeader.mode = MXParallaxHeaderMode.Fill
        self.tableView.parallaxHeader.minimumHeight = 20
        self.tableView.parallaxHeader.view?.backgroundColor = UIColor.flatTealColor()
        
        //self.tableView.parallaxHeader.view = NSBundle.mainBundle().loadNibNamed("customHeader", owner: self, options: nil).first as? UIView
        
        self.navigationController?.navigationBarHidden = true
        
        myCustomView = UINib(nibName: "customHeader", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! customHeaderView
        myCustomView.changeBackground(UIColor.flatBlueColor(), color2: UIColor.flatWhiteColor())
        myCustomView.backButton.addTarget(self, action: #selector(weatherTable.dismissVC(_:)), forControlEvents: .TouchUpInside)
        //let backButton = myCustomView.backButton as UIButton
        //backButton.addTarget(self, action: Selector(dismissVC()), forControlEvents:.TouchUpInside)
        
        self.tableView.parallaxHeader.view = myCustomView
        
        
        
        
        print(self.currentLocationString)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let secondViewController = segue.destinationViewController as! MenuViewController
        secondViewController.weatherViewController = self
    }
 
    override func viewDidAppear(animated: Bool) {
        
        print(testString)
        
        getCurrentLocation()

    }
    override func viewDidDisappear(animated: Bool) {
        
        self.currentLocationWeather = []
        
    }
    func dismissVC(sender:UIButton) {
        
        //self.dismissViewControllerAnimated(false, completion: nil)
        
        self.performSegueWithIdentifier("toWeatherTable", sender: self)
        print("button Pressed")
        
    }
    
    
    func getCurrentLocation() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        performSelector(#selector(stopUpdatingLocation), withObject: self, afterDelay: 1.0)
        performSelector(#selector(getData), withObject: self, afterDelay: 1.1)
        
        }
    func stopUpdatingLocation() {
        //
        print(currentLocationWeather.count)
        
        locationManager.stopUpdatingLocation()
        myCustomView.cityLabel.text = "City.\(self.currentLocationString)"
        
        
        
    }
    
    //Mark: - Location Delegate Methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let latestLocation: AnyObject = locations[locations.count - 1]
        
        
        let latitude: CLLocationDegrees = latestLocation.coordinate.latitude
        let longitude: CLLocationDegrees = latestLocation.coordinate.longitude
        let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
        //print(currentLocation)
        
        CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) -> Void in
            
            //print(currentLocation)
            
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
                
                print("Problem with data recieved my geocoder")
                
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
    
    
    func getData() {
        let city = self.currentLocationString as String
        //print(self.currentLocationString)
        //print(city)
        let replacedCity = (city as NSString).stringByReplacingOccurrencesOfString(" ", withString: "%20")
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
                    return
                }
            
            
                let result: AnyObject!
            
                do {
                    result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                    
                    
                } catch {
                    
                    print("Could not parse the data as JSON")
                    return
                
                }
                
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
                                    
                                        print(myLocationWeather.date)
                                        print(myLocationWeather.temp)
                                        print(myLocationWeather.text)
                                        self.currentLocationWeather.append(myLocationWeather)
                                    }
                                        
                                    
                                    for days in forecast {
                                        //print(days)
                                        if let day = days as? [String:AnyObject] {
                                            if self.currentWeather.count <= 6 {
                                            
                                                let weather = Weather()
                                                weather.date = days["date"] as! String
                                                weather.day = days["day"] as! String
                                                weather.high = days["high"] as! String
                                                weather.low = days["low"] as! String
                                                weather.text = days["text"] as! String
                                                self.currentWeather.append(weather)
                                                
                                            }
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                self.currentWeather.removeAtIndex(0)

                dispatch_async(dispatch_get_main_queue()) {
                    
                    
                    
                    self.tableView.reloadData()
                    
                    print("dispatchCount: \(self.currentLocationWeather.count)")
                    
                    let myCurrentWeather = self.currentLocationWeather[0]
                    self.myCustomView.degreesLabel.text = "\(myCurrentWeather.temp)˚"
                    self.myCustomView.descriptionLabel.text = myCurrentWeather.text

                }

                
                
            }
            
        }
        task.resume()
        
        
       
    }

}

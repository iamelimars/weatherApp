//
//  MenuViewController.swift
//  weatherTestApp
//
//  Created by iMac on 8/17/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

import UIKit
//import Foundation
import GooglePlaces
import GoogleMaps
import GooglePlacePicker
import CoreLocation


class MenuViewController: UITableViewController, GMSAutocompleteViewControllerDelegate, CLLocationManagerDelegate {
    weak var weatherViewController: weatherTable?
    var TableArray = [String]()
    var placesArray = [[String:AnyObject]]()
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    let locationCLLocation = CLLocation()
    var startLocation: CLLocation!
    var currentLocationString: NSString = ""
    var sendingString = String()
    //private var placesClient: GMSPlacesClient!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GMSPlacesClient.provideAPIKey("AIzaSyBF3gQH1VS3an12xVfH0OaHfZyUp2JDREM")
        
        TableArray = ["Weather","Second","Third"]
        
        let customFont = UIFont(name: "HelveticaNeue-Thin", size: 15.0)
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: customFont!], forState: UIControlState.Normal)
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: customFont!], forState: UIControlState.Normal)

    }
    override func viewDidAppear(animated: Bool) {
        
        placesArray = NSUserDefaults.standardUserDefaults().objectForKey("placesArray") as! [[String:AnyObject]]
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("placesArray")
        defaults.setObject(placesArray, forKey:"placesArray")
        defaults.synchronize()
        
        getCurrentLocation()
        self.tableView.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return placesArray.count + 1
    }
    
    @IBAction func unwindToMainMenu(segue: UIStoryboardSegue) {
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! MenuCell
        if indexPath.row == 0 {
            cell.bottomLabel.text = "Current Location"
            cell.topLabel.text = self.currentLocationString as String
            return cell
            
        } else {
            //let defaults = NSUserDefaults.standardUserDefaults()
            let dict = NSUserDefaults.standardUserDefaults().objectForKey("placesArray") as? [[String: String]] ?? [[String: String]]()
            print(dict[indexPath.row-1])
            let myArray = dict[indexPath.row - 1] as! [String:String]
            let latitude = myArray["latitude"]
            let longitude = myArray["longitude"]
            cell.topLabel.text = myArray["name"]
            cell.bottomLabel.text = latitude! + longitude!
            return cell
            
        }
    }
    /*
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "backToWeather" {
            
            let secondViewController = segue.destinationViewController as SecondViewController
            secondViewController.firstViewController = self
        }
    }
    */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row == 0 {
            weatherViewController?.testString = self.currentLocationString as String
            
            
        }else {
            
            let dict = NSUserDefaults.standardUserDefaults().objectForKey("placesArray") as? [[String: String]] ?? [[String: String]]()
            let myArray = dict[indexPath.row - 1]
            //let latitude = myArray["latitude"]
            //let longitude = myArray["longitude"]
            self.sendingString = myArray["name"]!
            print("Sending String: \(self.sendingString)")
            weatherViewController?.testString = self.sendingString
            
            
        }
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }

    @IBAction func backButtonPressed(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
        
    }
    
    //Mark: - GMSAutoComplete Delegate methods
    @IBAction func searchButtonPressed(sender: AnyObject) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        let filter = GMSAutocompleteFilter()
        filter.type = .City
        autoCompleteController.autocompleteFilter = filter
        self.presentViewController(autoCompleteController, animated: true, completion: nil)
        
        //adjust colors of autoCompleteController
        
        let darkGray = UIColor.darkGrayColor()
        let lightGray = UIColor.flatGrayColor()
        
        autoCompleteController.secondaryTextColor = UIColor.colorWithAlphaComponent(UIColor.flatWhiteColor())(0.5)
        autoCompleteController.primaryTextColor = lightGray
        autoCompleteController.primaryTextHighlightColor = UIColor.whiteColor()
        autoCompleteController.tableCellBackgroundColor = darkGray
        autoCompleteController.tableCellSeparatorColor = lightGray
        autoCompleteController.tintColor = lightGray;
        //autoCompleteController.autocompleteFilter = GM
        
        
        
    }
    func viewController(viewController: GMSAutocompleteViewController, didAutocompleteWithPlace place: GMSPlace) {
        //var coordinateText:String = "\(place.coordinate.)"
        let latitude: String = "\(place.coordinate.latitude)" 
        let longitude: String = "\(place.coordinate.longitude)"
        
        let Dict: [String:AnyObject] = ["name":place.name,
                                    "latitude":latitude,
                                   "longitude":longitude]
        
        placesArray.append(Dict)
        
        for (key, value) in Dict {
            print("\(key): \(value)")
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey("placesArray")
        defaults.setObject(placesArray, forKey:"placesArray")
        defaults.synchronize()
        
        tableView.reloadData()
        
        //print(place.name)
        //print(place.formattedAddress)
        //print(place.coordinate)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func viewController(viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: NSError) {
        
        print(error.description)
        
    }
    
    func wasCancelled(viewController: GMSAutocompleteViewController) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
    }
    
    func didRequestAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
    }
    
    func didUpdateAutocompletePredictions(viewController: GMSAutocompleteViewController) {
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        
    }
    /*
    func placeAutocomplete() {
        let filter = GMSAutocompleteFilter()
        filter.type = .City
        placesClient?.autocompleteQuery("Sydney Oper", bounds: nil, filter: filter, callback: { (results, error: NSError?) -> Void in
            guard error == nil else {
                print("Autocomplete error \(error)")
                return
            }
            
            for result in results! {
                print("Result \(result.attributedFullText) with placeID \(result.placeID)")
            }
        })
    }
    */
    
    func getCurrentLocation() {
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
        performSelector(#selector(stopUpdatingLocation), withObject: self, afterDelay: 1.0)
        //performSelector(#selector(getData), withObject: self, afterDelay: 1.5)
        
    }
    func stopUpdatingLocation() {
        //
        //print(currentLocationWeather.count)
        print(self.currentLocationString)
        locationManager.stopUpdatingLocation()
        self.tableView.reloadData()
        //myCustomView.cityLabel.text = "City.\(self.currentLocationString)"
        
        
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

    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let defaults = NSUserDefaults.standardUserDefaults()
            placesArray.removeAtIndex(indexPath.row - 1)
            
            defaults.removeObjectForKey("placesArray")
            defaults.setObject(placesArray, forKey:"placesArray")
            defaults.synchronize()
            
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

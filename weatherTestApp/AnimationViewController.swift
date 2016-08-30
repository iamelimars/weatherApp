//
//  AnimationViewController.swift
//  weatherTestApp
//
//  Created by iMac on 8/20/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

import UIKit
import CoreLocation

class AnimationViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var weatherButton: UIButton!
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //weatherButton.titleLabel?.text = "Weather"
        weatherButton.titleLabel?.textColor = UIColor.whiteColor()
        weatherButton.backgroundColor = UIColor.clearColor()
        weatherButton.layer.cornerRadius = 5.0
        weatherButton.layer.borderWidth = 0.5
        weatherButton.layer.borderColor = UIColor.whiteColor().CGColor
        weatherButton.hidden = true
        
        let introCircle = animatedCircle()
        introCircle.circleAnimation(200, height: 200, strokeColor: UIColor.whiteColor(), view: self.view)
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //locationManager.requestAlwaysAuthorization()
        
        
        
    }
    

    @IBAction func weatherButtonPressed(sender: AnyObject) {
        
        performSegueWithIdentifier("introToMain", sender: self)
        
    }
    /*
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedAlways {
            if CLLocationManager.isMonitoringAvailableForClass(CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {

                
                print("accepted")
                
                }
            }
        } else {
            
            print("status not .AuthorizedAlways")
        }
    }
    */
    func segueToMain() {
        
        performSegueWithIdentifier("introToMain", sender: self)
        
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined:
            // If status has not yet been determied, ask for authorization
            print("NoeDetermined")
            weatherButton.hidden = true
            manager.requestWhenInUseAuthorization()
            break
        case .AuthorizedWhenInUse:
            // If authorized when in use
            print("authorizedWhenInUse")
            weatherButton.hidden = false
            manager.startUpdatingLocation()
            NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(AnimationViewController.segueToMain), userInfo: nil, repeats: false)
            break
        case .AuthorizedAlways:
            // If always authorized
            print("authorizedAlways")
            weatherButton.hidden = false
            manager.startUpdatingLocation()
            break
        case .Restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            print("restricted")
            break
        case .Denied:
            print("If user denied your app access to Location Services, but can grant access from Settings.app")
            weatherButton.hidden = true
            break
        }
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

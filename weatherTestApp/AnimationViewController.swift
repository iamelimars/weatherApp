//
//  AnimationViewController.swift
//  weatherTestApp
//
//  Created by iMac on 8/20/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

import UIKit
import CoreLocation
import JSSAlertView

class AnimationViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //weatherButton.titleLabel?.text = "Weather"
        
        let introCircle = animatedCircle()
        introCircle.circleAnimation(200, height: 200, strokeColor: UIColor.whiteColor(), view: self.view)
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        //locationManager.requestAlwaysAuthorization()
        
        
        
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
            manager.requestWhenInUseAuthorization()
            break
        case .AuthorizedWhenInUse:
            // If authorized when in use
            print("authorizedWhenInUse")
            manager.startUpdatingLocation()
            NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: #selector(AnimationViewController.segueToMain), userInfo: nil, repeats: false)
            break
        case .AuthorizedAlways:
            // If always authorized
            print("authorizedAlways")
            manager.startUpdatingLocation()
            break
        case .Restricted:
            // If restricted by e.g. parental controls. User can't enable Location Services
            self.customAlertView(UIColor.flatWhiteColor(), customTitle: "Location Services Restricted 🚫")
            print("restricted")
            break
        case .Denied:
            self.customAlertView(UIColor.flatWhiteColor(), customTitle: "Go To Settings? 🤔")
            
            print("If user denied your app access to Location Services, but can grant access from Settings.app")
            break
        }
    }

    func customAlertView (alertColor: UIColor, customTitle: String) {
        
        let alertview = JSSAlertView().show(self,
                                            title: customTitle,
                                            text: "Your location is needed to use this app. 😊",
                                            buttonText: "OK?",
                                            color: alertColor,
                                            cancelButtonText: "Cancel"
        )
        alertview.addCancelAction(myCancelCallback)
        alertview.addAction(self.myCallback) // Method to run after dismissal
        alertview.setTitleFont("HelveticaNeue-Light") // Title font
        alertview.setTextFont("HelveticaNeue-Thin") // Alert body text font
        alertview.setButtonFont("HelveticaNeue-UltraLight") // Button text font
        alertview.setTextTheme(.Dark) // can be .Light or .Dark
        
    }
    func myCancelCallback() {
        
        
        
    }
    
    func myCallback() {
        // this'll run after the alert is dismissed
        
        let settingsUrl = NSURL(string: UIApplicationOpenSettingsURLString)
        if let url = settingsUrl {
            UIApplication.sharedApplication().openURL(url)
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

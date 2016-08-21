//
//  AnimationViewController.swift
//  weatherTestApp
//
//  Created by iMac on 8/20/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

import UIKit

class AnimationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let introCircle = animatedCircle()
        introCircle.circleAnimation(250, height: 250, strokeColor: UIColor.whiteColor(), view: self.view)
        
        [self.performSelector(#selector(AnimationViewController.leaveAnimation), withObject: nil, afterDelay: 4.0)]
        
    }

    func leaveAnimation() {
        
        print("ask for location permission")
        
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

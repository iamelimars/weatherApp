//
//  animatedCircle.swift
//  weatherTestApp
//
//  Created by iMac on 8/20/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

import UIKit

class animatedCircle: NSObject {
    
    func circleAnimation (width: CGFloat, height: CGFloat, strokeColor: UIColor, view: UIView) {
        
        
        let screenWidth = view.frame.size.width
        let screenHeight = view.frame.size.height
        
        let ovalStartingAngle = CGFloat(90.01 * M_PI/180)
        let ovalEndAngle = CGFloat(90 * M_PI/180)
        let ovalRect = CGRectMake(screenWidth/2-(width/2), screenHeight/2-(height/2), width, height)
        
        //create the bezier path
        let ovalPath = UIBezierPath()
        
        ovalPath.addArcWithCenter(CGPointMake(CGRectGetMidX(ovalRect), CGRectGetMidY(ovalRect)), radius: CGRectGetWidth(ovalRect) / 2, startAngle: ovalStartingAngle, endAngle: ovalEndAngle, clockwise: true)
        
        //create an object that represents how the curve should be presented on the screen
        let progressLine = CAShapeLayer()
        progressLine.path = ovalPath.CGPath
        progressLine.strokeColor = strokeColor.CGColor
        progressLine.fillColor = UIColor.clearColor().CGColor
        progressLine.lineWidth = 0.6
        progressLine.lineCap = kCALineCapRound
        
        //Add curve to the screen
        view.layer.addSublayer(progressLine)
        
        //create a basic animation that animates the value 'strokeEnd' from 0.0 to 1.0 over 3 seconds
        let animateStrokeEnd = CABasicAnimation(keyPath: "strokeEnd")
        animateStrokeEnd.duration = 3.0
        animateStrokeEnd.fromValue = 0.0
        animateStrokeEnd.toValue = 1.0
        
        //add the animation
        progressLine.addAnimation(animateStrokeEnd, forKey: "animate stroke end animation")
        
        
    }

}

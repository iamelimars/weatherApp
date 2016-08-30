//
//  customHeaderView.swift
//  weatherTestApp
//
//  Created by iMac on 8/9/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

import UIKit
import ChameleonFramework
import MXParallaxHeader


class customHeaderView: UIView, MXParallaxHeaderProtocol {

    @IBOutlet weak var degreesLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var humidityIcon: UIImageView!
    @IBOutlet weak var windIcon: UIImageView!
    @IBOutlet weak var sunriseIcon: UIImageView!
    
    @IBOutlet weak var windSpeedTitle: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    @IBOutlet weak var windChillTitle: UILabel!
    @IBOutlet weak var windChillLabel: UILabel!
    
    @IBOutlet weak var humidityTitle: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var sunriseTitle: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    
    @IBOutlet weak var sunsetTitle: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    
    @IBOutlet weak var slideUpArrow: UIImageView!
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        
    }
    
    class func instanciateFromNib() -> customHeaderView {
        
        return NSBundle.mainBundle().loadNibNamed("customHeader", owner: nil, options: nil)[0] as! customHeaderView
    }
    
    
    
    func changeBackground(color1: UIColor, color2: UIColor) -> Void{
        let colors = [color1,
                      color2]
        
        //self.backgroundColor = UIColor.init(gradientStyle: UIGradientStyle.TopToBottom, withFrame: self.frame, andColors: colors)
        self.backgroundColor = UIColor.blackColor()
        //self.backgroundView.backgroundColor = UIColor.init(gradientStyle: UIGradientStyle.TopToBottom, withFrame: self.backgroundView.frame, andColors: colors)
        
    }
    func changeDegrees(degrees: Float) {
        let myDegrees: Float = degrees
        
        self.degreesLabel.text = "\(myDegrees)"
        
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        
        //self.dismissViewControllerAnimated(weatherTable)
        //performSelector(weatherTable.dismissVC(weatherTable))
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let subView: UIView = loadViewFromNib()
        subView.frame = self.bounds
        subView.addSubview(backButton)
        addSubview(subView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func loadViewFromNib() -> UIView {
        
        let view: UIView = UINib(nibName: "customHeader", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
        return view
        
    }
    
    // MARK: - <MXParallaxHeader>

    func parallaxHeaderDidScroll(parallaxHeader: MXParallaxHeader) {
        
        if parallaxHeader.progress >= -0.375000 {
            UIView.animateWithDuration(1.0, animations: {
                
                self.cityLabel.alpha = 1
                self.humidityIcon.alpha = 1
                self.windIcon.alpha = 1
                self.sunriseIcon.alpha = 1
                self.windSpeedTitle.alpha = 1
                self.windSpeedLabel.alpha = 1
                self.windChillTitle.alpha = 1
                self.windChillLabel.alpha = 1
                self.sunriseTitle.alpha = 1
                self.sunriseLabel.alpha = 1
                self.sunsetTitle.alpha = 1
                self.sunsetLabel.alpha = 1
                self.humidityTitle.alpha = 1
                self.humidityLabel.alpha = 1
                self.slideUpArrow.alpha = 1
                self.descriptionLabel.alpha = 1

            })
        } else {
            
            UIView.animateWithDuration(1.0, animations: {
                
                
                self.cityLabel.alpha = 0
                self.humidityIcon.alpha = 0
                self.windIcon.alpha = 0
                self.sunriseIcon.alpha = 0
                self.windSpeedTitle.alpha = 0
                self.windSpeedLabel.alpha = 0
                self.windChillTitle.alpha = 0
                self.windChillLabel.alpha = 0
                self.sunriseTitle.alpha = 0
                self.sunriseLabel.alpha = 0
                self.sunsetTitle.alpha = 0
                self.sunsetLabel.alpha = 0
                self.humidityTitle.alpha = 0
                self.humidityLabel.alpha = 0
                self.slideUpArrow.alpha = 0
                self.descriptionLabel.alpha = 0

                
            })
        }
        
        //let angle = parallaxHeader.progress * CGFloat(M_PI) * 2
        //self.degreesLabel.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle)
        
        //print(angle)
            
        
        
    }


}

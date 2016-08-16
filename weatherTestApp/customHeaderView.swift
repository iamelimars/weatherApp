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
        
        self.backgroundColor = UIColor.init(gradientStyle: UIGradientStyle.TopToBottom, withFrame: self.frame, andColors: colors)
        //self.backgroundView.backgroundColor = UIColor.init(gradientStyle: UIGradientStyle.TopToBottom, withFrame: self.backgroundView.frame, andColors: colors)
        
    }
    func changeDegrees(degrees: Float) {
        let myDegrees: Float = degrees
        
        self.degreesLabel.text = "\(myDegrees)"
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let subView: UIView = loadViewFromNib()
        subView.frame = self.bounds
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

                
            })
            
            
        } else {
            
            UIView.animateWithDuration(1.0, animations: {
                
                
                self.cityLabel.alpha = 0

                
            })
            
        }
        
        //let angle = parallaxHeader.progress * CGFloat(M_PI) * 2
        //self.degreesLabel.transform = CGAffineTransformRotate(CGAffineTransformIdentity, angle)
        
        //print(angle)
            
        
        
    }


}

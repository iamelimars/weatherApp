//
//  errorView.swift
//  Parallax Weather
//
//  Created by iMac on 8/31/16.
//  Copyright © 2016 Marshall. All rights reserved.
//

import UIKit

class errorView: UIView {
    
    @IBOutlet weak var tryAgainButton: UIButton!
    
    class func instanciateFromNib() -> errorView {
        
        return NSBundle.mainBundle().loadNibNamed("ErrorView", owner: nil, options: nil)[0] as! errorView
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let subView: UIView = loadViewFromNib()
        subView.frame = self.bounds
        subView.addSubview(tryAgainButton)
        addSubview(subView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func loadViewFromNib() -> UIView {
        
        let view: UIView = UINib(nibName: "ErrorView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! UIView
        return view
        
    }
    
    @IBAction func tryAgainButtonPressed(sender: AnyObject) {
        
        
        
    }


}

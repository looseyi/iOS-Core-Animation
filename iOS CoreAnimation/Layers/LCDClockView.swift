//
//  LCDClockView.swift
//  iOS CoreAnimation
//
//  Created by Edmond on 10/31/15.
//  Copyright © 2015 Edmond. All rights reserved.
//

import UIKit

class LCDClockView : UIView {
    @IBOutlet var digitalViews: [UIView]!
    var timer: NSTimer?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        layer.opacity = 0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale

        _lgc_setupSubViews()
    }
    
    override func awakeFromNib() {
        _lgc_setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    private func _lgc_setupSubViews() {
        let digits = UIImage(named:"Digits")
        //set up digit views
        for view in digitalViews {
            //set contents
            view.layer.contents = digits?.CGImage
            view.layer.contentsRect = CGRectMake(0, 0, 0.1, 1.0)
            view.layer.contentsGravity = kCAGravityResizeAspectFill
            view.layer.magnificationFilter = kCAFilterNearest
        }
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector: "tick:", userInfo:nil, repeats:true)
    }
    
    func setDigit(digit: Int, forView view: UIView) {
        view.layer.contentsRect = CGRectMake(CGFloat(digit) * 0.1, 0, 0.1, 1.0)
    }
    
    func tick(sender: NSTimer) {
        if layer.opacity == 0 {
            layer.opacity = 0.5
        }
    
        //convert time to hours, minutes and seconds
        if let calendar = NSCalendar(identifier:NSCalendarIdentifierGregorian) {
            let units:NSCalendarUnit  = [.Hour, .Minute, .Second]
            let components = calendar.components(units, fromDate:NSDate())
            
            //set hours
            setDigit(components.hour / 10, forView: digitalViews[0])
            setDigit(components.hour % 10, forView: digitalViews[1])
            
            //set minutes
            setDigit(components.minute / 10, forView: digitalViews[2])
            setDigit(components.minute % 10, forView: digitalViews[3])
            
            //set seconds
            setDigit(components.second / 10, forView: digitalViews[4])
            setDigit(components.second % 10, forView: digitalViews[5])
        }
    }
}

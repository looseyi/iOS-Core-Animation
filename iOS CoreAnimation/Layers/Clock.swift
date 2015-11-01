//
//  Clock.swift
//  iOS CoreAnimation
//
//  Created by Edmond on 10/31/15.
//  Copyright © 2015 Edmond. All rights reserved.
//

import UIKit

class ClockView : UIView {
    
    @IBOutlet weak var secondHand: UIImageView!
    @IBOutlet weak var minuteHand: UIImageView!
    @IBOutlet weak var hourHand: UIImageView!
    var timer: NSTimer?

    override init(frame: CGRect) {
        super.init(frame:frame)
        _lgc_setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func awakeFromNib() {
        _lgc_setupViews()
    }
    
    deinit {
        if let timer = timer {
            timer.invalidate()
            self.timer = nil
        }
    }
    
    private func _lgc_setupViews() {
        let newAnchorPt = CGPointMake(0.5, 0.9)
        hourHand.layer.anchorPoint = newAnchorPt
        minuteHand.layer.anchorPoint = newAnchorPt
        secondHand.layer.anchorPoint = newAnchorPt
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target:self, selector: "tick:", userInfo:nil, repeats:true)
    }
    
    func _lgc_setAngle(angle: CGFloat, forHand handView: UIView, animated: Bool) {
        //generate transform
        let transform = CATransform3DMakeRotation(angle, 0, 0, 1)
        if let presentationLayer = handView.layer.presentationLayer() where animated {
            //create transform animation
            let animation = CABasicAnimation()
            animation.keyPath = "transform"
            animation.fromValue = presentationLayer.valueForKey("transform")
            animation.toValue = NSValue(CATransform3D: transform)
            animation.duration = 0.5
            animation.delegate = self
            animation.timingFunction = CAMediaTimingFunction(controlPoints:1, 0, 0.75, 1)
            //apply animation
            handView.layer.transform = transform
            handView.layer.addAnimation(animation, forKey:nil)
        } else {
            //set transform directly
            handView.layer.transform = transform
        }
    }

    
    func tick(sender: NSTimer) {
        //convert time to hours, minutes and seconds
        if let calendar = NSCalendar(identifier:NSCalendarIdentifierGregorian) {
            let units:NSCalendarUnit  = [.Hour, .Minute, .Second]
            let components = calendar.components(units, fromDate:NSDate())
                let hoursAngle = CGFloat((Double(components.hour) / 12.0) * M_PI * 2.0)
                //calculate hour hand angle //calculate minute hand angle
                let minsAngle = CGFloat((Double(components.minute) / 60.0) * M_PI * 2.0)
                //calculate second hand angle
                let secsAngle = CGFloat((Double(components.second) / 60.0) * M_PI * 2.0)
//                //rotate hands
//                hourHand.transform = CGAffineTransformMakeRotation(hoursAngle)
//                minuteHand.transform = CGAffineTransformMakeRotation(minsAngle)
//                secondHand.transform = CGAffineTransformMakeRotation(secsAngle)
            
            // MARK: Custom
            _lgc_setAngle(hoursAngle, forHand:hourHand, animated:true)
            _lgc_setAngle(minsAngle, forHand:minuteHand, animated:true)
            _lgc_setAngle(secsAngle, forHand:secondHand, animated:true)
        }
    }
}

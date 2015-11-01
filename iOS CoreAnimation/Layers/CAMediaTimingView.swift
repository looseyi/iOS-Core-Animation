//
//  CAMediaTimingView.swift
//  iOS CoreAnimation
//
//  Created by Edmond on 11/1/15.
//  Copyright © 2015 Edmond. All rights reserved.
//

import UIKit

class CAMediaTimingView : UIView {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var repeatCountField: UITextField!
    @IBOutlet weak var durationField: UITextField!
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timeOffsetSlider: UISlider!
    @IBOutlet weak var speedSlider: UISlider!
    @IBOutlet weak var timeOffsetLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    let bezierPath = UIBezierPath()
    
    var shipLayer = CALayer()
    var doorLayer = CALayer()
    var pathLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        _lgc_setUpSubViews()
    }
    
    private func _lgc_setUpSubViews() {
        repeatCountField.keyboardType = .DecimalPad
        durationField.keyboardType = .DecimalPad

        //create a path
        bezierPath.moveToPoint(CGPointMake(100, 100))
        bezierPath.addCurveToPoint(CGPointMake(300, 100), controlPoint1:CGPointMake(150, 0), controlPoint2: CGPointMake(325, 200))
        //draw the path using a CAShapeLayer
        pathLayer.path = bezierPath.CGPath
        pathLayer.fillColor = UIColor.clearColor().CGColor
        pathLayer.strokeColor = UIColor.redColor().CGColor
        pathLayer.lineWidth = 3.0
        pathLayer.opacity = 0
        layer.addSublayer(pathLayer)
        
        //add the ship
        shipLayer.frame = CGRectMake(0, 0, 64, 64)
        shipLayer.position = CGPointMake(240, 80)
        shipLayer.contents = UIImage(named:"ship")?.CGImage
        layer.addSublayer(shipLayer)
        
        //add the door
        doorLayer.opacity = 0
        doorLayer.frame = CGRectMake(0, 0, 64, 128)
        doorLayer.position = CGPointMake(240, 80)
        doorLayer.anchorPoint = CGPointMake(0, 0.5)
        doorLayer.contents = UIImage(named:"door")?.CGImage
        layer.addSublayer(doorLayer)
    }
    
    private func _lgc_setControllsEnabled(enabled: Bool) {
        for control in [durationField, repeatCountField, startButton] {
            control.enabled = enabled
            control.alpha = enabled ? 1 : 0.25
        }
    }
    
    private func hideKeyboard() {
        durationField.resignFirstResponder()
        repeatCountField.resignFirstResponder()
    }
    
    private func updateSliders() {
        let timeOffset = timeOffsetSlider.value //CFTimeInterval
        let speed = speedSlider.value //CFTimeInterval
        timeOffsetLabel.text = "\(timeOffset)"
        speedLabel.text = "\(speed)"
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        //reenable controls
        _lgc_setControllsEnabled(true)
    }
    
    @IBAction func durationAnimationAction(sender: AnyObject) {
        doorLayer.opacity = 0
        shipLayer.opacity = 1
        pathLayer.opacity = 0
    }
    
    @IBAction func autoReversesAnimationAction(sender: AnyObject) {
        doorLayer.opacity = 1
        shipLayer.opacity = 0
        pathLayer.opacity = 0
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500.0
        layer.sublayerTransform = perspective
        //apply swinging animation
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation.y"
        animation.toValue = -M_PI_2
        animation.duration = 2.0
        animation.repeatDuration = Double.infinity
        animation.autoreverses = true
        doorLayer.addAnimation(animation, forKey:nil)
    }
    
    @IBAction func relateTimeAction(sender: AnyObject) {
        doorLayer.opacity = 0
        shipLayer.opacity = 1
        pathLayer.opacity = 1
    }

    @IBAction func timeOffsetAction(sender: AnyObject) {
        updateSliders()
    }
    
    @IBAction func speedAction(sender: AnyObject) {
        updateSliders()
    }

    
    @IBAction func start(sender: AnyObject) {
        if let duration = durationField.text, repeatCount = repeatCountField.text {
            //animate the ship rotation
            let animation = CABasicAnimation()
            animation.keyPath = "transform.rotation"
            animation.duration = NSString(string:duration).doubleValue
            animation.repeatCount = NSString(string:repeatCount).floatValue
            animation.byValue = M_PI * 2.0
            animation.delegate = self
            shipLayer.addAnimation(animation, forKey:"rotateAnimation")
            //disable controls
            _lgc_setControllsEnabled(false)
        }
    }
    
    @IBAction func play(sender: AnyObject) {
        //create the keyframe animation
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.timeOffset = CFTimeInterval(timeOffsetSlider.value)
        animation.speed = speedSlider.value
        animation.duration = 1.0
        animation.path = bezierPath.CGPath
        animation.rotationMode = kCAAnimationRotateAuto;
        animation.removedOnCompletion = false
        shipLayer.addAnimation(animation, forKey:"slider")
    }
}

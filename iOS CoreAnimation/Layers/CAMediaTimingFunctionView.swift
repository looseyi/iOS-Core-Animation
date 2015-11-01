//
//  CAMediaTimingFunctionView.swift
//  iOS CoreAnimation
//
//  Created by Edmond on 11/2/15.
//  Copyright © 2015 Edmond. All rights reserved.
//

import UIKit

class CAMediaTimingFunctionView : UIView {
    let ballView = UIImageView(image:UIImage(named:"Spark"))
    @IBOutlet weak var containerView: UIView!
    
    let shapeLayer = CAShapeLayer()
    let timeFunctions = [
        kCAMediaTimingFunctionDefault,
        kCAMediaTimingFunctionLinear,
        kCAMediaTimingFunctionEaseIn,
        kCAMediaTimingFunctionEaseOut,
        kCAMediaTimingFunctionEaseInEaseOut,
        "kCAMediaTimingFuntionCustom"
    ]

    override func awakeFromNib() {
        _lgc_createShapeLayer()
        _lgc_setUpSubViews(timeFunctions[0])
    }
    
    func _lgc_createShapeLayer() {
        ballView.hidden = true
        addSubview(ballView)
        
        //create shape layer
        shapeLayer.strokeColor = UIColor.redColor().CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.lineWidth = 4.0
        containerView.layer.addSublayer(shapeLayer)
        //flip geometry so that 0,0 is in the bottom-left
        containerView.layer.geometryFlipped = true
    }
    
    func _lgc_setUpSubViews(timeFunctionName: String) {
        //create timing function
        var function : CAMediaTimingFunction?
        if timeFunctionName == "kCAMediaTimingFuntionCustom" {
            function = CAMediaTimingFunction(controlPoints:1, 0, 0.75, 1)
        } else {
            function = CAMediaTimingFunction(name:timeFunctionName)
        }
        if let function = function {
            //get control points
            let ctrlPoints = _lgc_controlPoints(function)
            if ctrlPoints.count >= 2 {
                //create curve
                let path = UIBezierPath()
                path.moveToPoint(CGPointZero)
                path.addCurveToPoint(CGPointMake(1.0, 1.0), controlPoint1:ctrlPoints[0], controlPoint2:ctrlPoints[1])
                //scale the path up to a reasonable size for display
                path.applyTransform(CGAffineTransformMakeScale(180, 180))
                shapeLayer.path = path.CGPath
            }
        }
    }
    
    @IBAction func bollAction(sender: UIButton) {
        sender.selected = !sender.selected
        ballView.hidden = sender.selected
        _lgc_beginBollAnimation()
    }
    
    private func _lgc_beginBollAnimation() {
        //reset ball to top of screen
        self.ballView.center = CGPointMake(150, 32)
        //create keyframe animation
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.duration = 1.0
        animation.delegate = self
        animation.values = [
            NSValue(CGPoint: CGPointMake(150, 32)),
            NSValue(CGPoint: CGPointMake(150, 268)),
            NSValue(CGPoint: CGPointMake(150, 140)),
            NSValue(CGPoint: CGPointMake(150, 268)),
            NSValue(CGPoint: CGPointMake(150, 220)),
            NSValue(CGPoint: CGPointMake(150, 268)),
            NSValue(CGPoint: CGPointMake(150, 250)),
            NSValue(CGPoint: CGPointMake(150, 268)),
        ]
        animation.timingFunctions = [
            CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn),
            CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut),
            CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn),
            CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut),
            CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn),
            CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut),
            CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn),
        ]
        animation.keyTimes = [0.0, 0.3, 0.5, 0.7, 0.8, 0.9, 0.95, 1.0]
        //apply animation
        ballView.layer.position = CGPointMake(150, 268)
        ballView.layer.addAnimation(animation, forKey:nil)
    }
    
    private func interpolate(from: Float, to: Float, time: Float) -> Float {
        return (to - from) * time + from
    }
    
    private func _lgc_interpolate(fromValue: AnyObject, toValue: AnyObject, time: Float) -> AnyObject {
        if fromValue is NSValue {
            // TODO:
            //get type
//            let type = fromValue.objCType
//            if strcasecmp(type, )
//            if (strcmp(type, @encode(CGPoint)) == 0) {
//                CGPoint from = [fromValue CGPointValue];
//                CGPoint to = [toValue CGPointValue];
//                CGPoint result = CGPointMake(interpolate(from.x, to.x, time), interpolate(from.y, to.y, time));
//                return [NSValue valueWithCGPoint:result];
//            }
        }
        //provide safe default implementation
//        return (time < 0.5)? fromValue: toValue;
        return 0.0
    }
    
    func bounceEaseOut(t: Float) -> Float {
        if t < 4 / 11.0 {
            return (121 * t * t) / 16.0
        } else if t < 8 / 11.0 {
            return (363 / 40.0 * t * t) - (99 / 10.0 * t) + 17 / 5.0
        } else if (t < 9 / 10.0) {
            return (4356 / 361.0 * t * t) - (35442 / 1805.0 * t) + 16061 / 1805.0
        }
        return (54 / 5.0 * t * t) - (513 / 25.0 * t) + 268 / 25.0
    }
    
    private func customAnimation() {
        //reset ball to top of screen
        ballView.center = CGPointMake(150, 32)
        //set up animation parameters
        let fromValue = NSValue(CGPoint:CGPointMake(150, 32))
        let toValue = NSValue(CGPoint:CGPointMake(150, 268))
        let duration: CFTimeInterval = 1.0
        //generate keyframes
        let numFrames = duration * 60.0
        var frames = [AnyObject]()
        for i in 0..<Int(numFrames) {
            var time = Float(1 / numFrames * Double(i))
            //apply easing
            time = bounceEaseOut(time)
            frames.append(_lgc_interpolate(fromValue, toValue:toValue, time:time))
        }
        //create keyframe animation
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.duration = 1.0
        animation.delegate = self
        animation.values = frames
        //apply animation
        ballView.layer.addAnimation(animation, forKey:nil)

    }
    
    private func _lgc_controlPoints(fun: CAMediaTimingFunction) -> [CGPoint] {
        // Create point array to point to
        var point: [Float] = [0.0, 0.0]
        var pointArray = [CGPoint]()
        for i in 1...2 {
            fun.getControlPointAtIndex(i, values: &point)
            pointArray.append(CGPoint(x: CGFloat(point[0]), y: CGFloat(point[1])))
        }
        return pointArray
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if !ballView.hidden {
            _lgc_beginBollAnimation()
        }
    }
}

extension CAMediaTimingFunctionView : UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeFunctions.count
    }
}

extension CAMediaTimingFunctionView : UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeFunctions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        _lgc_setUpSubViews(timeFunctions[row])
    }
}

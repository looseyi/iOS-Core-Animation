//
//  PropertyAnimationView.swift
//  iOS CoreAnimation
//
//  Created by Edmond on 11/1/15.
//  Copyright © 2015 Edmond. All rights reserved.
//

import UIKit

class PropertyAnimationView : UIView {
    let layerView = UIView()
    let colorLayer = CALayer()
    let changeBtn = UIButton()
    let changeKeyframeBtn = UIButton()
    let airplainBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        changeBtn.frame = CGRectMake(10, 10, 120, 30)
        changeBtn.setTitleColor(UIColor.redColor(), forState:.Normal)
        changeBtn.setTitle("baseAnimation", forState:.Normal)
        changeBtn.addTarget(self, action:"changeColor:", forControlEvents:.TouchUpInside)
        addSubview(changeBtn)
        
        changeKeyframeBtn.frame = CGRectMake(10, 50, 160, 30)
        changeKeyframeBtn.setTitleColor(UIColor.redColor(), forState:.Normal)
        changeKeyframeBtn.setTitle("keyframeAnimation", forState:.Normal)
        changeKeyframeBtn.addTarget(self, action:"changeKeyframeColor:", forControlEvents:.TouchUpInside)
        addSubview(changeKeyframeBtn)

        airplainBtn.frame = CGRectMake(10, 90, 160, 30)
        airplainBtn.setTitleColor(UIColor.redColor(), forState:.Normal)
        airplainBtn.setTitle("pathAnimation", forState:.Normal)
        airplainBtn.addTarget(self, action:"pathAnimation:", forControlEvents:.TouchUpInside)
        addSubview(airplainBtn)

        
        colorLayer.frame = CGRectMake(200.0, 50.0, 100.0, 100.0)
        colorLayer.backgroundColor = UIColor.yellowColor().CGColor
        
        
        //add a custom action
        let transition = CATransition()
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        colorLayer.actions = ["backgroundColor" : transition]
        //add it to our view
        layerView.layer.addSublayer(colorLayer)
        
        //add it to our view
        addSubview(layerView)
    }
    
    func applyBasicAnimation(animation: CABasicAnimation, toLayer: CALayer) {
        //set the from value (using presentation layer if available)
        if let presentationLayer = toLayer.presentationLayer(), keyPath = animation.keyPath, toValue = animation.toValue {
            animation.fromValue = presentationLayer.valueForKeyPath(keyPath)
            //update the property in advance
            //note: this approach will only work if toValue != nil
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            toLayer.setValue(toValue, forKeyPath:keyPath)
            CATransaction.commit()
            //apply animation to layer
            toLayer.addAnimation(animation, forKey:nil)
        }
    }

    
    func changeColor(sender: UIButton) {
        if let subLayers = colorLayer.sublayers {
            subLayers.forEach{ $0.removeFromSuperlayer() }
        }

        //randomize the layer background color
        let red = Float(arc4random()) / Float(INT_MAX)
        let green = Float(arc4random()) / Float(INT_MAX)
        let blue = Float(arc4random()) / Float(INT_MAX)
        let color = UIColor(colorLiteralRed:red, green:green, blue:blue, alpha:1.0).CGColor
        
        /*
        我们希望对每个动画的过程重复这样的缓冲，于是每次颜色的变换都会有脉冲效果。 见10章
        */
        let animation = CABasicAnimation()
        animation.keyPath = "backgroundColor"
        animation.toValue = color
        animation.delegate = self
        let fu = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
//        animation.timingFunction = [fu, fu, fu]
        animation.timingFunction = fu
        animation
        
        //apply animation to layer
        colorLayer.addAnimation(animation, forKey:nil)
    }
    
    func changeKeyframeColor(sender: UIButton) {
        /*
        动画会在开始的时候突然跳转到第一帧的值，然后在动画结束的时候突然恢复到原始的值。所以为了动画的平滑特性，我们需要开始和结束的关键帧来匹配当前属性的值。
        */
        
        //create a keyframe animation
        let animation = CAKeyframeAnimation()
        animation.keyPath = "backgroundColor"
        animation.duration = 2.0
        animation.values = [
            UIColor.blueColor().CGColor,
            UIColor.redColor().CGColor,
            UIColor.greenColor().CGColor,
            UIColor.blueColor().CGColor]
        //apply animation to layer
        colorLayer.addAnimation(animation, forKey:nil)
    }
    
    func pathAnimation(sender: UIButton) {
        if let subLayers = colorLayer.sublayers {
            subLayers.forEach{ $0.removeFromSuperlayer() }
        }
        
        //create a path
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPointMake(0, 150))
        bezierPath.addCurveToPoint(CGPointMake(300, 150), controlPoint1:CGPointMake(75, 0), controlPoint2: CGPointMake(225, 300))
        //draw the path using a CAShapeLayer
        let pathLayer = CAShapeLayer()
        pathLayer.path = bezierPath.CGPath
        pathLayer.fillColor = UIColor.clearColor().CGColor
        pathLayer.strokeColor = UIColor.redColor().CGColor
        pathLayer.lineWidth = 3.0
        layer.addSublayer(pathLayer)
        
        let bgLayer = CALayer()
        bgLayer.frame = CGRectMake(0, 0, 64, 64)
        bgLayer.position = CGPointMake(0, 150)
        bgLayer.backgroundColor = UIColor.greenColor().CGColor
        layer.addSublayer(bgLayer)

        //add the ship
        let shipLayer = CALayer()
        shipLayer.frame = CGRectMake(0, 0, 64, 64)
        shipLayer.position = CGPointMake(0, 150)
        shipLayer.contents = UIImage(named:"ship")?.CGImage
        layer.addSublayer(shipLayer)

        //create the keyframe animation
//        let positionAnimation = CAKeyframeAnimation()
//        positionAnimation.keyPath = "position"
//        positionAnimation.duration = 4.0
//        positionAnimation.path = bezierPath.CGPath
//        positionAnimation.rotationMode = kCAAnimationRotateAuto
//        shipLayer.addAnimation(positionAnimation, forKey:"position")
//
//        let rotationAnimation = CABasicAnimation()
//        rotationAnimation.keyPath = "transform.rotation"
//        rotationAnimation.duration = 2.0
//        rotationAnimation.byValue = M_PI * 2
//        shipLayer.addAnimation(rotationAnimation, forKey:"rotate")
//        
//        let groupAnimation = CAAnimationGroup()
//        groupAnimation.animations = [positionAnimation, rotationAnimation]
//        groupAnimation.duration = 4.0
//        shipLayer.addAnimation(rotationAnimation, forKey:nil)
        
        let animation1 = CAKeyframeAnimation()
        animation1.keyPath = "position"
        animation1.path = bezierPath.CGPath
        animation1.rotationMode = kCAAnimationRotateAuto
        //create the color animation
        let animation2 = CABasicAnimation()
        animation2.keyPath = "backgroundColor"
        animation2.toValue = UIColor.redColor().CGColor
        //create group animation
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [animation1, animation2]
        groupAnimation.duration = 4.0
        //add the animation to the color layer
        bgLayer.addAnimation(groupAnimation, forKey:nil)
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        //set the backgroundColor property to match animation toValue
        let baseAnimation = anim as! CABasicAnimation
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            colorLayer.backgroundColor = baseAnimation.toValue as! CGColor
            CATransaction.commit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    /*
    点击屏幕上的任意位置将会让图层平移到那里。点击图层本身可以随机改变它的颜色。我们通过对呈现图层调用-hitTest:来判断是否被点击。
    
    如果修改代码让-hitTest:直接作用于colorLayer而不是呈现图层，你会发现当图层移动的时候它并不能正确显示。这时候你就需要点击图层将要移动到的位置而不是图层本身来响应点击（这就是为什么用呈现图层来响应交互的原因）。
    */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent:event)
        if let touch = touches.first {
            //get the touch point
            let point = touch.locationInView(self)
            //check if we've tapped the moving layer
            if let presentationLayer = colorLayer.presentationLayer() where presentationLayer.hitTest(point) != nil {
                let red = Float(arc4random()) / Float(INT_MAX)
                let green = Float(arc4random()) / Float(INT_MAX)
                let blue = Float(arc4random()) / Float(INT_MAX)
                colorLayer.backgroundColor = UIColor(colorLiteralRed:red, green:green, blue:blue, alpha:1.0).CGColor
            } else {
                //otherwise (slowly) move the layer to new position
                CATransaction.begin()
                CATransaction.setAnimationDuration(4.0)
                colorLayer.position = point
                CATransaction.commit()
            }
        }
    }
}
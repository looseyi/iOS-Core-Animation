//
//  TickAnimationView.swift
//  iOS CoreAnimation
//
//  Created by Edmond on 11/5/15.
//  Copyright © 2015 Edmond. All rights reserved.
//

import UIKit

class TickAnimationView : UIView {
    let containerView = UIView()
    let ballView = UIImageView(image:UIImage(named:"Spark"))
    let displayLink = UIImageView(image:UIImage(named:"Spark"))
    var timer: NSTimer?
    var linkTimer: CADisplayLink?
    var duration: NSTimeInterval = 1.0
    var timeOffset: NSTimeInterval = 1.0
    var lastStep: NSTimeInterval = 1.0
    var fromValue: AnyObject?
    var toValue: AnyObject?
    var linkFromValue: AnyObject?
    var linkToValue: AnyObject?
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        addSubview(ballView)
        addSubview(displayLink)
        _lgc_animate()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func interpolate(from: CGFloat, to: CGFloat, time: CGFloat) -> CGFloat {
        return (to - from) * time + from
    }
    
    private func bounceEaseOut(t: Float) -> Float {
        if t < 4 / 11.0 {
            return (121 * t * t) / 16.0
        } else if (t < 8 / 11.0) {
            return (363 / 40.0 * t * t) - (99 / 10.0 * t) + 17 / 5.0
        } else if (t < 9 / 10.0) {
            return (4356 / 361.0 * t * t) - (35442 / 1805.0 * t) + 16061 / 1805.0
        }
        return (54 / 5.0 * t * t) - (513 / 25.0 * t) + 268 / 25.0
    }

    private func _lgc_animate() {
        //reset ball to top of screen
        ballView.center = CGPointMake(150, 32)
        //configure the animation
        duration = 1.0
        timeOffset = 0.0
        fromValue = NSValue(CGPoint:CGPointMake(150, 32))
        toValue = NSValue(CGPoint:CGPointMake(150, 268))
        //stop the timer if it's already running
        
        //start the timer
        if let timer = timer {
            timer.invalidate()
        }
        /*
        一个典型的例子就是当是用UIScrollview滑动的时候，重绘滚动视图的内容会比别的任务优先级更高，所以标准的NSTimer和网络请求就不会启动，一些常见的run loop模式如下：
        NSDefaultRunLoopMode - 标准优先级
        NSRunLoopCommonModes - 高优先级
        UITrackingRunLoopMode - 用于UIScrollView和别的控件的动画
        同样可以同时对CADisplayLink指定多个run loop模式，于是我们可以同时加入NSDefaultRunLoopMode和UITrackingRunLoopMode来保证它不会被滑动打断，也不会被其他UIKit控件动画影响性能，像这样：
        */
        lastStep = CACurrentMediaTime()
        linkTimer = CADisplayLink(target:self, selector:"step:")
        linkTimer?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode:NSDefaultRunLoopMode)
        
        if let linkTimer = linkTimer {
            linkTimer.invalidate()
        }
        linkFromValue = NSValue(CGPoint:CGPointMake(250, 32))
        linkToValue = NSValue(CGPoint:CGPointMake(250, 268))
        timer = NSTimer.scheduledTimerWithTimeInterval(1/60.0, target:self, selector:"stepNSTimer:", userInfo:nil, repeats:true)
    }
    
    private func _lgc_interpolate(fromValue:AnyObject, toValue:AnyObject, time: Float) -> AnyObject {
//        let type = fromValue.objCType
//        if (strcmp(type, @encode(CGPoint)) == 0) {
        if let fromValue = fromValue as? NSValue, toValue = toValue as? NSValue {
            let from = fromValue.CGPointValue()
            let to = toValue.CGPointValue()
            let result = CGPointMake(interpolate(from.x, to: to.x, time: CGFloat(time)), interpolate(from.y, to: to.y, time: CGFloat(time)))
            return NSValue(CGPoint:result)
        }
        //provide safe default implementation
        return time < 0.5 ? fromValue : toValue
    }
    
    func step(step: NSTimer) {
        //calculate time delta
        let thisStep = CACurrentMediaTime()
        let stepDuration = thisStep - lastStep
        lastStep = thisStep
        //update time offset
        timeOffset = min(timeOffset + stepDuration, duration)
        //get normalized time offset (in range 0 - 1)
        var time = Float(timeOffset / duration)
        //apply easing
        time = bounceEaseOut(time)
        //interpolate position
        if let fromValue = fromValue, toValue = toValue {
            let position = _lgc_interpolate(fromValue, toValue:toValue, time:time)
            if let position = position as? NSValue {
                //move ball view to new position
                ballView.center = position.CGPointValue()
                //stop the timer if we've reached the end of the animation
                if let timer = timer where timeOffset >= duration {
                    timer.invalidate()
                    self.timer = nil
                }
                
            }
        }
    }
    
    func stepNSTimer(step: CADisplayLink) {
        //update time offset
        timeOffset = min(timeOffset + 1/60.0, duration)
        //get normalized time offset (in range 0 - 1)
        var time = Float(timeOffset / duration)
        //apply easing
        time = bounceEaseOut(time)
        //interpolate position
        if let fromValue = linkFromValue, toValue = linkToValue {
            let position = _lgc_interpolate(fromValue, toValue:toValue, time:time)
            if let position = position as? NSValue {
                //move ball view to new position
                displayLink.center = position.CGPointValue()
                //stop the timer if we've reached the end of the animation
                if let timer = timer where timeOffset >= duration {
                    timer.invalidate()
                    self.timer = nil
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        _lgc_animate()
    }
}

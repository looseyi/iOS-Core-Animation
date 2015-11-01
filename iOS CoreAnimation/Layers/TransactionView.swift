//
//  TransactionView.swift
//  iOS CoreAnimation
//
//  Created by Edmond on 11/1/15.
//  Copyright © 2015 Edmond. All rights reserved.
//

import UIKit

class TransactionView : UIView {
    let layerView = UIView()
    let colorLayer = CALayer()
    let changeBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        changeBtn.frame = CGRectMake(50, 180, 100, 30)
        changeBtn.setTitleColor(UIColor.redColor(), forState:.Normal)
        changeBtn.setTitle("Change", forState:.Normal)
        changeBtn.addTarget(self, action:"changeColor:", forControlEvents:.TouchUpInside)
        addSubview(changeBtn)
        
        colorLayer.frame = CGRectMake(50.0, 50.0, 100.0, 100.0)
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
    
    func changeColor(sender: UIButton) {
        //begin a new transaction
        CATransaction.begin()
        //set the animation duration to 1 second
        CATransaction.setAnimationDuration(1.0)
        CATransaction.setCompletionBlock { () -> Void in
            //rotate the layer 90 degrees
            var transform = self.colorLayer.affineTransform()
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            self.colorLayer.setAffineTransform(transform)
        }
        
        //randomize the layer background color
        let red = Float(arc4random()) / Float(INT_MAX)
        let green = Float(arc4random()) / Float(INT_MAX)
        let blue = Float(arc4random()) / Float(INT_MAX)
        colorLayer.backgroundColor = UIColor(colorLiteralRed:red, green:green, blue:blue, alpha:1.0).CGColor
        
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

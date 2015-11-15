//
//  DrawViewController.swift
//  iOS CoreAnimation
//
//  Created by Edmond on 11/7/15.
//  Copyright © 2015 Edmond. All rights reserved.
//

import UIKit

let BRUSH_SIZE: CGFloat = 32
class DrawViewController : UIViewController {
    var detailItem: ContentModel?
    lazy var lineDrawView: LineDrawingView = {
        return LineDrawingView(frame:self.view.bounds)
        }()
    
    lazy var brushView: BrushView = {
        return BrushView(frame:self.view.bounds)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineDrawView.frame = view.bounds
        view.insertSubview(lineDrawView, atIndex:0)
    }
    
    @IBAction func showBrush(sender: UIButton) {
        sender.selected = !sender.selected
        if sender.selected {
            lineDrawView.path.removeAllPoints()
            lineDrawView.removeFromSuperview()
            view.insertSubview(brushView, atIndex:0)
        } else {
            brushView.strokes.removeAll()
            brushView.removeFromSuperview()
            view.insertSubview(lineDrawView, atIndex:0)
        }
    }
}

class LineDrawingView : UIView {
    var path = UIBezierPath()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        let shapeLayer = layer as! CAShapeLayer
        shapeLayer.strokeColor = UIColor.redColor().CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineCap = kCALineCapRound
        backgroundColor = UIColor.whiteColor()
    }

    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let pt = touches.first?.locationInView(self) {
            path.moveToPoint(pt)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let pt = touches.first?.locationInView(self) {
            path.addLineToPoint(pt)
            if let shapeLayer = layer as? CAShapeLayer {
                shapeLayer.path = path.CGPath
            }
        }
    }
    
    override func drawRect(rect: CGRect) {
        UIColor.clearColor().setFill()
        UIColor.redColor().setFill()
        path.stroke()
    }
}

class BrushView : UIView {
    var strokes = [NSValue]()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        backgroundColor = UIColor.clearColor()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _lgc_addBrushStrokeAtPoint(pt: CGPoint) {
        strokes.append(NSValue(CGPoint:pt))
        setNeedsDisplayInRect(_lgc_brushRectForPoint(pt))
    }
    
    private func _lgc_brushRectForPoint(pt: CGPoint) -> CGRect {
        return CGRectMake(pt.x - CGFloat(BRUSH_SIZE / 2.0), pt.y - CGFloat(BRUSH_SIZE / 2), BRUSH_SIZE, BRUSH_SIZE)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let pt = touches.first?.locationInView(self) {
            _lgc_addBrushStrokeAtPoint(pt)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let pt = touches.first?.locationInView(self) {
            _lgc_addBrushStrokeAtPoint(pt)
        }
    }
    
    override func drawRect(rect: CGRect) {
        //redraw strokes
        for stroke in strokes {
            let pt = stroke.CGPointValue()
            let brushRect = _lgc_brushRectForPoint(pt)
            //only draw brush stroke if it intersects dirty rect
            if (CGRectIntersectsRect(rect, brushRect)) {
                //draw brush stroke
                UIImage(named:"chalk")?.drawInRect(rect)
            }
        }
        super.drawRect(rect)
    }
}
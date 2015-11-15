//
//  DetailViewController.swift
//  iOS CoreAnimation
//
//  Created by Edmond on 10/31/15.
//  Copyright © 2015 Edmond. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    @IBOutlet weak var descriptionView: UITextView!
    var webView = WKWebView()
    @IBOutlet weak var detailDescriptionLabel: UILabel!

    var detailItem: ContentModel?

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.title
            }
            if let url = NSURL(string:detail.url) {
                let request = NSURLRequest(URL:url)
                view.addSubview(webView)
                webView.frame = CGRectMake(0, 340, CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds) - 340)
                webView.loadRequest(request)
            }
            _lgc_loadSubView(detail.layer)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func _lgc_loadSubView(type: String) {
        switch type {
        case "Property":
            _lgc_layerDelegateMethod()
        case "Clock":
            _lgc_setupClockLayer()
        case "LCD":
            _lgc_setupLCDClockLayer()
        case "AffineTransform":
            _lgc_setupAffineTransformView()
        case "Special Layer":
            _lgc_setupSpecialLayerView()
        case "Animation CATransaction":
            _lgc_setupCATransaction()
        case "CABaseAnimation，CAKeyframeAnimation":
            _lgc_setupCAPropertyAnimation()
        case "CAMediaTiming":
            _lgc_setupCAMediaTimingAnimation()
        case "CAMediaTimingFunction":
            _lgc_setupCAMediaTimingFunction()
        case "TickAnimation":
            _lgc_setupTickAnimationView()
        case "ImageIOView":
            _lgc_setupImageIOView()
        default: break
        }
    }
    
    private func _lgc_layerDelegateMethod() {
        let redLayer = CALayer()
        redLayer.backgroundColor = UIColor.redColor().CGColor
        redLayer.bounds = CGRectMake(0, 0, 240, 240)
        redLayer.position = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMaxY(detailDescriptionLabel.bounds) + 200)
        redLayer.contentsScale = UIScreen.mainScreen().scale
        redLayer.delegate = self
        view.layer.addSublayer(redLayer)
        redLayer.display()  // force redraw
    }

    // MARK:  CALayer Delegate 
    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        //draw a thick red circle
        CGContextSetLineWidth(ctx, 10.0)
        CGContextSetStrokeColorWithColor(ctx, UIColor.yellowColor().CGColor)
        CGContextStrokeEllipseInRect(ctx, layer.bounds)
    }

    private func _lgc_setupClockLayer() {
        let clockView = NSBundle.mainBundle().loadNibNamed("Clock", owner: nil, options:nil)[0] as! ClockView
        clockView.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMaxY(detailDescriptionLabel.bounds) + 200)
        view.addSubview(clockView)
    }
    
    private func _lgc_setupLCDClockLayer() {
        let clockView = NSBundle.mainBundle().loadNibNamed("LCDClockView", owner: nil, options:nil)[0] as! LCDClockView
        clockView.center = CGPointMake(CGRectGetMidX(view.bounds), CGRectGetMaxY(detailDescriptionLabel.bounds) + 200)

        view.addSubview(clockView)
    }
    
    private func _lgc_setupAffineTransformView() {
        let transformView = NSBundle.mainBundle().loadNibNamed("TransformView", owner: nil, options:nil)[0] as! TransformView
        transformView.frame = CGRectMake(0, CGRectGetMaxY(detailDescriptionLabel.frame), CGRectGetWidth(view.bounds), 240)
        view.addSubview(transformView)
    }
    
    private func _lgc_setupSpecialLayerView() {
        let transformView = NSBundle.mainBundle().loadNibNamed("SpecialLayer", owner: nil, options:nil)[0] as! SpecialLayer
        transformView.frame = CGRectMake(0, 100, CGRectGetWidth(view.bounds), 200)
        view.addSubview(transformView)
    }
    
    private func _lgc_setupCATransaction() {
        let transformView = TransactionView()
        transformView.frame = CGRectMake(0, 100, CGRectGetWidth(view.bounds), 200)
        view.addSubview(transformView)
    }
    
    private func _lgc_setupCAPropertyAnimation() {
        let transformView = PropertyAnimationView()
        transformView.frame = CGRectMake(0, 100, CGRectGetWidth(view.bounds), 200)
        view.addSubview(transformView)
    }
    
    private func _lgc_setupCAMediaTimingAnimation() {
        let transformView = NSBundle.mainBundle().loadNibNamed("CAMediaTimingView", owner: nil, options:nil)[0] as! CAMediaTimingView
        transformView.frame = CGRectMake(0, 100, CGRectGetWidth(view.bounds), 200)
        view.addSubview(transformView)
    }
    
    private func _lgc_setupCAMediaTimingFunction() {
        let transformView = NSBundle.mainBundle().loadNibNamed("CAMediaTimingFunctionView", owner: nil, options:nil)[0] as! CAMediaTimingFunctionView
        transformView.frame = CGRectMake(10, 100, CGRectGetWidth(view.bounds) - 20, 240)
        view.addSubview(transformView)
    }
    
    private func _lgc_setupTickAnimationView() {
        let transformView = TickAnimationView()
        transformView.frame = CGRectMake(10, 100, CGRectGetWidth(view.bounds) - 20, 240)
        view.addSubview(transformView)
    }
    
    private func _lgc_setupImageIOView() {
        let transformView = ImageIOView()
        transformView.frame = CGRectMake(10, 100, CGRectGetWidth(view.bounds) - 20, 240)
        view.addSubview(transformView)
    }
}
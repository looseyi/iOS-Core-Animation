//
//  SpecialLayer.swift
//  iOS CoreAnimation
//
//  Created by Edmond on 11/1/15.
//  Copyright © 2015 Edmond. All rights reserved.
//

import UIKit
import QuartzCore

class LayerLabel : UILabel {
    var textLayer: CATextLayer {
        return layer as! CATextLayer
    }
    override var text : String? {
        set {
            super.text = text
            textLayer.string = text
        }
        get {
            return self.text
        }
    }

    override var textColor : UIColor! {
        set {
            super.textColor = textColor
            textLayer.foregroundColor = textColor.CGColor
        }
        get {
            return self.textColor
        }
    }

    override var font : UIFont! {
        set {
            super.font = font
            textLayer.font = CGFontCreateWithFontName(font.fontName)
            textLayer.fontSize = font.pointSize
        }
        get {
            return self.font
        }
    }

    override class func layerClass() -> AnyClass {
        return CATextLayer.classForCoder()
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setUp()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override func awakeFromNib() {
        setUp()
    }
    
    func setUp() {
//        text = self.text
//        textColor = self.textColor
//        font = self.font
        textLayer.alignmentMode = kCAAlignmentJustified
        textLayer.wrapped = true
        layer.display()
    }
}

class SpecialLayer : UIView {
    @IBOutlet weak var containerView: UIView!
    
    @IBAction func lgc_shapeLayerAction(sender: AnyObject) {
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(175, 100))
        path.addArcWithCenter(CGPointMake(150, 100), radius:25, startAngle:0, endAngle:CGFloat(2 * M_PI), clockwise:true)
        path.moveToPoint(CGPointMake(150, 125))
        path.addLineToPoint(CGPointMake(125, 225))
        path.moveToPoint(CGPointMake(150, 175))
        path.addLineToPoint(CGPointMake(175, 225))
        path.moveToPoint(CGPointMake(100, 150))
        path.addLineToPoint(CGPointMake(200, 150))
        
        //create shape layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.redColor().CGColor
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.lineWidth = 5
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineCap = kCALineCapRound
        shapeLayer.path = path.CGPath
        //add it to our view
        _lgc_addSubeLayer(shapeLayer)
    }
    
    @IBAction func lgc_textLayerAction(sender: AnyObject) {
        let textLayer = CATextLayer()
        textLayer.frame = containerView.bounds
        containerView.layer.addSublayer(textLayer)
        
        textLayer.foregroundColor = UIColor.blackColor().CGColor
        textLayer.alignmentMode = kCAAlignmentJustified
        textLayer.wrapped = true
        
        // choose a font
        let font = UIFont.systemFontOfSize(15)
        //set layer font
        textLayer.font = CGFontCreateWithFontName(font.fontName)
        textLayer.fontSize = font.pointSize
        //choose some text
        let text = "Lorem ipsum dolor sit amet, consectetur adipiscing \\ elit. Quisque massa arcu, eleifend vel varius in, facilisis pulvinar \\ leo. Nunc quis nunc at mauris pharetra condimentum ut ac neque. Nunc elementum, libero ut porttitor dictum, diam odio congue lacus, vel \\ fringilla sapien diam at purus. Etiam suscipit pretium nunc sit amet \\ lobortis"
        //set layer text
        textLayer.string = text
        /*
        这些文本有一些像素化了。这是因为并没有以Retina的方式渲染，第二章提到了这个contentScale属性，用来决定图层内容应该以怎样的分辨率来渲染。contentsScale并不关心屏幕的拉伸因素而总是默认为1.0。如果我们想以Retina的质量来显示文字，我们就得手动地设置CATextLayer的contentsScale
        */
        textLayer.contentsScale = UIScreen.mainScreen().scale
        _lgc_addSubeLayer(textLayer)
    }
    
    @IBAction func lgc_transformLayerLayerAction(sender: AnyObject) {
        /*
        当我们在构造复杂的3D事物的时候，如果能够组织独立元素就太方便了。比如说，你想创造一个孩子的手臂：你就需要确定哪一部分是孩子的手腕，哪一部分是孩子的前臂，哪一部分是孩子的肘，哪一部分是孩子的上臂，哪一部分是孩子的肩膀等等。
        立方体示例，我们将通过旋转camara来解决图层平面化问题而不是像立方体示例代码中用的sublayerTransform。这是一个非常不错的技巧，但是只能作用域单个对象上，如果你的场景包含两个立方体，那我们就不能用这个技巧单独旋转他们了。
        可以创建一个新的UIView子类寄宿在CATransformLayer（用+layerClass方法）之上。但是，为了简化案例，我们仅仅重建了一个单独的图层，而不是使用视图。这意味着我们不能像第五章一样在立方体表面显示按钮和标签，不过我们现在也用不到这个特性。
        */
        _lgc3DObject()
    }
    
    @IBAction func lgc_gradientLayerAction(sender: AnyObject) {
        /*
        CAGradientLayer是用来生成两种或更多颜色平滑渐变的。用Core Graphics复制一个CAGradientLayer并将内容绘制到一个普通图层的寄宿图也是有可能的，但是CAGradientLayer的真正好处在于绘制使用了硬件加速。
        */
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        _lgc_addSubeLayer(gradientLayer)
        
        //set gradient colors
        gradientLayer.colors = [UIColor.redColor().CGColor, UIColor.blackColor().CGColor]
        //set gradient start and end points
        gradientLayer.startPoint = CGPointMake(0, 0)
        gradientLayer.endPoint = CGPointMake(1, 1)
        
        /*
        //create gradient layer and add it to our container view
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        _lgc_addSubeLayer(gradientLayer)
        
        //set gradient colors
        gradientLayer.colors = [UIColor.redColor().CGColor, UIColor.yellowColor().CGColor, UIColor.blackColor().CGColor]
        //set locations
        gradientLayer.locations = [0.0, 0.25, 0.5]

        //set gradient start and end points
        gradientLayer.startPoint = CGPointMake(0, 0)
        gradientLayer.endPoint = CGPointMake(1, 1)
        */
    }
    
    @IBAction func lgc_replicatorLayerAction(sender: AnyObject) {
        /*
        CAReplicatorLayer的目的是为了高效生成许多相似的图层。它会绘制一个或多个图层的子图层，并在每个复制体上应用不同的变换。
        真正应用到实际程序上的场景比如：一个游戏中导弹的轨迹云，或者粒子爆炸（尽管iOS 5已经引入了CAEmitterLayer，它更适合创建任意的粒子效果）。除此之外，还有一个实际应用是：反射 https://github.com/nicklockwood/ReflectionView
        */
        //create a replicator layer and add it to our view
        let replicator = CAReplicatorLayer()
        replicator.frame = self.containerView.bounds
        _lgc_addSubeLayer(replicator)
        
        //configure the replicator
        replicator.instanceCount = 10
        
        //apply a transform for each instance
        var transform = CATransform3DIdentity
        transform = CATransform3DTranslate(transform, 0, 200, 0)
        transform = CATransform3DRotate(transform, CGFloat(M_PI) / 5.0, 0, 0, 1)
        transform = CATransform3DTranslate(transform, 0, -200, 0)
        replicator.instanceTransform = transform
        
        //apply a color shift for each instance
        replicator.instanceBlueOffset = -0.1
        replicator.instanceGreenOffset = -0.1
        
        //create a sublayer and place it inside the replicator
        let layer = CALayer()
        layer.frame = CGRectMake(100.0, 100.0, 100.0, 100.0)
        layer.backgroundColor = UIColor.whiteColor().CGColor
        replicator.addSublayer(layer)
        
        /*
        let replicator = CAReplicatorLayer()
        replicator.frame = self.containerView.bounds
        _lgc_addSubeLayer(replicator)
        
        //configure the replicator
        replicator.instanceCount = 2

        //move reflection instance below original and flip vertically
        //apply a transform for each instance
        var transform = CATransform3DIdentity
        let verticalOffset = self.bounds.size.height + 2
        transform = CATransform3DTranslate(transform, 0, verticalOffset, 0)
        transform = CATransform3DScale(transform, 1, -1, 0)
        layer.instanceTransform = transform
        
        //reduce alpha of reflection layer
        layer.instanceAlphaOffset = -0.6

        */
    }
    
    @IBAction func lgc_emitterLayerAction(sender: AnyObject) {
        /*
        CAScrollLayer中的图层的实用方法。scrollPoint:方法从图层树中查找并找到第一个可用的CAScrollLayer，然后滑动它使得指定点成为可视的。scrollRectToVisible:方法实现了同样的事情只不过是作用在一个矩形上的。visibleRect属性决定图层（如果存在的话）的哪部分是当前的可视区域。如果你自己实现这些方法就会相对容易明白一点，但是CAScrollLayer帮你省了这些麻烦，所以当涉及到实现图层滑动的时候就可以用上了。
        */
        
        
        //create particle emitter layer
        let emitter = CAEmitterLayer()
        emitter.frame = containerView.bounds
        _lgc_addSubeLayer(emitter)
        
        //configure emitter
        emitter.renderMode = kCAEmitterLayerAdditive
        emitter.emitterPosition = CGPointMake(emitter.frame.size.width / 2.0, emitter.frame.size.height / 2.0)
        
        //create a particle template
        let cell = CAEmitterCell()
        cell.contents = UIImage(named:"Spark")?.CGImage
        cell.birthRate = 150
        cell.lifetime = 5.0
        cell.color = UIColor(colorLiteralRed:1, green:0.5, blue:0.1, alpha:1.0).CGColor
        cell.alphaSpeed = -0.4
        cell.velocity = 50
        cell.velocityRange = 80
        cell.emissionRange = CGFloat(M_PI) * 2.0
        
        //add particle template to emitter
        emitter.emitterCells = [cell]
    }

    private func _lgc_addSubeLayer(subLayer: CALayer?) {
        if let subLayers = containerView.layer.sublayers {
            for layer in subLayers {
                layer.removeFromSuperlayer()
            }
        }
        if let subLayer = subLayer {
            containerView.layer.addSublayer(subLayer)
        }
    }
    
    private func _lgc_faceWithTransform(transform: CATransform3D) -> CALayer {
        //create cube face layer
        let face = CALayer()
        face.frame = CGRectMake(-50, -50, 100, 100)
        //apply a random color
        let red = (Float(rand()) / Float(INT_MAX))
        let green = (Float(rand()) / Float(INT_MAX))
        let blue = (Float(rand()) / Float(INT_MAX))
        face.backgroundColor = UIColor(colorLiteralRed:red, green:green, blue:blue, alpha:1.0).CGColor
        //apply the transform and return
        face.transform = transform
        return face
    }
    
    private func _lgc_cubeWithTransform(transform: CATransform3D) -> CALayer {
        //create cube layer
        let cube = CATransformLayer()
    
        //add cube face 1
        var ct = CATransform3DMakeTranslation(0, 0, 50)
        cube.addSublayer(_lgc_faceWithTransform(ct))
    
        //add cube face 2
        ct = CATransform3DMakeTranslation(50, 0, 0)
        ct = CATransform3DRotate(ct, CGFloat(M_PI_2), 0, 1, 0)
        cube.addSublayer(_lgc_faceWithTransform(ct))
    
        //add cube face 3
        ct = CATransform3DMakeTranslation(0, -50, 0)
        ct = CATransform3DRotate(ct, CGFloat(M_PI_2), 1, 0, 0)
        cube.addSublayer(_lgc_faceWithTransform(ct))
    
        //add cube face 4
        ct = CATransform3DMakeTranslation(0, 50, 0);
        ct = CATransform3DRotate(ct, CGFloat(-M_PI_2), 1, 0, 0)
        cube.addSublayer(_lgc_faceWithTransform(ct))
    
        //add cube face 5
        ct = CATransform3DMakeTranslation(-50, 0, 0)
        ct = CATransform3DRotate(ct, CGFloat(-M_PI_2), 0, 1, 0)
        cube.addSublayer(_lgc_faceWithTransform(ct))
    
        //add cube face 6
        ct = CATransform3DMakeTranslation(0, 0, -50)
        ct = CATransform3DRotate(ct, CGFloat(M_PI), 0, 1, 0)
        cube.addSublayer(_lgc_faceWithTransform(ct))
    
        //center the cube layer within the container
        let containerSize = containerView.bounds.size
        cube.position = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0)
    
        //apply the transform and return
        cube.transform = transform
        return cube
    }
    
    private func _lgc3DObject() {
        _lgc_addSubeLayer(nil)
        
        //set up the perspective transform
        var pt = CATransform3DIdentity
        pt.m34 = -1.0 / 500.0
        containerView.layer.sublayerTransform = pt
        
        //set up the transform for cube 1 and add it
        var c1t = CATransform3DIdentity
        c1t = CATransform3DTranslate(c1t, -100, 0, 0)
        let cube1 = _lgc_cubeWithTransform(c1t)
        containerView.layer.addSublayer(cube1)
        
        //set up the transform for cube 2 and add it
        var c2t = CATransform3DIdentity
        c2t = CATransform3DTranslate(c2t, 100, 0, 0)
        c2t = CATransform3DRotate(c2t, CGFloat(-M_PI_4), 1, 0, 0)
        c2t = CATransform3DRotate(c2t, CGFloat(-M_PI_4), 0, 1, 0)
        let cube2 = _lgc_cubeWithTransform(c2t)
        containerView.layer.addSublayer(cube2)
    }
}

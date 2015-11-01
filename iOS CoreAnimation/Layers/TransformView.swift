//
//  TransformView.swift
//  iOS CoreAnimation
//
//  Created by Edmond on 11/1/15.
//  Copyright © 2015 Edmond. All rights reserved.
//

import UIKit
import QuartzCore
import GLKit

class TransformView : UIView {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet var faceViews: [UIView]!
    
    @IBOutlet weak var dialImageView: UIImageView!
    @IBOutlet weak var transformImageView: UIImageView!

    @IBAction func resetTransformAction(sender: UIButton) {
        _lgc_show3DObject(false)
        transformImageView.layer.setAffineTransform(CGAffineTransformIdentity)
        transformImageView.layer.transform = CATransform3DIdentity
    }

    @IBAction func affineTransformAction(sender: UIButton) {
                _lgc_show3DObject(false)
//        #define RADIANS_TO_DEGREES(x) ((x)/M_PI*180.0)
//        #define DEGREES_TO_RADIANS(x) ((x)/180.0*M_PI)
        let transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        transformImageView.layer.setAffineTransform(transform)
    }
    
    @IBAction func mixTransformAction(sender: UIButton) {
        _lgc_show3DObject(false)
//        CGAffineTransformRotate(CGAffineTransform t, CGFloat angle)
//        CGAffineTransformScale(CGAffineTransform t, CGFloat sx, CGFloat sy)
//        CGAffineTransformTranslate(CGAffineTransform t, CGFloat tx, CGFloat ty)
        
        var transform = CGAffineTransformIdentity
        //scale by 50%
        transform = CGAffineTransformScale(transform, 0.5, 0.5)
        //rotate by 30 degrees
        transform = CGAffineTransformRotate(transform, CGFloat(M_PI) / 180.0 * 30.0)
        //translate by 200 points
        transform = CGAffineTransformTranslate(transform, 200, 0)
        //apply transform to layer
        transformImageView.layer.setAffineTransform(transform)
    }
    
    @IBAction func cutTransformAction(sender: UIButton) {
        _lgc_show3DObject(false)
        //shear the layer at a 45-degree angle
        transformImageView.layer.setAffineTransform(_lgc_shearTransform(1, y:0))
    }
    
    @IBAction func transform3DAction(sender: UIButton) {
        _lgc_show3DObject(false)
//        CATransform3D也是一个矩阵，但是和2x3的矩阵不同，CATransform3D是一个可以在3维空间内做变换的4x4的矩阵
        
        /*
        m34的默认值是0，我们可以通过设置m34为-1.0 / d来应用透视效果，d代表了想象中视角相机和屏幕之间的距离，以像素为单位，那应该如何计算这个距离呢？实际上并不需要，大概估算一个就好了。
        因为视角相机实际上并不存在，所以可以根据屏幕上的显示效果自由决定它的放置的位置。通常500-1000就已经很好了，但对于特定的图层有时候更小或者更大的值会看起来更舒服，减少距离的值会增强透视效果，所以一个非常微小的值会让它看起来更加失真，然而一个非常大的值会让它基本失去透视效果
        */
        var outerTransform = CATransform3DIdentity
        //apply perspective
        outerTransform.m34 = -1.0 / 500.0
        //rotate by 45 degrees along the Y axis
        outerTransform = CATransform3DRotate(outerTransform, CGFloat(M_PI_4), 0, 1, 0)
        //apply to layer
        dialImageView.layer.transform = outerTransform

        var innerTransform = CATransform3DIdentity
        //apply perspective
        innerTransform.m34 = -1.0 / 500.0
        //rotate by 45 degrees along the Y axis
        innerTransform = CATransform3DRotate(innerTransform, CGFloat(-M_PI_4), 0, 1, 0)
        //apply to layer
        transformImageView.layer.transform = innerTransform
    }
    
    @IBAction func operaTransformAction(sender: UIButton) {
    }
    
    @IBAction func object3DAction(sender: UIButton) {
        _lgc_show3DObject(true)
        
        //set up the container sublayer transform
        var perspective = CATransform3DIdentity
        perspective.m34 = -1.0 / 500.0
        perspective = CATransform3DRotate(perspective, CGFloat(-M_PI_4), 1, 0, 0)
        perspective = CATransform3DRotate(perspective, CGFloat(-M_PI_4), 0, 1, 0)
        containerView.layer.sublayerTransform = perspective
        
        //add cube face 1
        var transform = CATransform3DMakeTranslation(0, 0, 60)
        _lgc_addFace(0, withTransform:transform)
        
        //add cube face 2
        transform = CATransform3DMakeTranslation(60, 0, 0)
        transform = CATransform3DRotate(transform, CGFloat(M_PI_2), 0, 1, 0)
        _lgc_addFace(1, withTransform:transform)
        
        //add cube face 3
        transform = CATransform3DMakeTranslation(0, -60, 0)
        transform = CATransform3DRotate(transform, CGFloat(M_PI_2), 1, 0, 0)
        _lgc_addFace(2, withTransform:transform)
        
        //add cube face 4
        transform = CATransform3DMakeTranslation(0, 60, 0);
        transform = CATransform3DRotate(transform, -CGFloat(M_PI_2), 1, 0, 0)
        _lgc_addFace(3, withTransform:transform)
        //add cube face 5
        transform = CATransform3DMakeTranslation(-60, 0, 0);
        transform = CATransform3DRotate(transform, -CGFloat(M_PI_2), 0, 1, 0)
        _lgc_addFace(4, withTransform:transform)
        //add cube face 6
        transform = CATransform3DMakeTranslation(0, 0, -60)
        transform = CATransform3DRotate(transform, CGFloat(M_PI), 0, 1, 0)
        _lgc_addFace(5, withTransform:transform)
        
        
        /*
        现在它看起来更像是一个立方体没错了，但是对每个面之间的连接还是很难分辨。Core Animation可以用3D显示图层，但是它对光线并没有概念。如果想让立方体看起来更加真实，需要自己做一个阴影效果。你可以通过改变每个面的背景颜色或者直接用带光亮效果的图片来调整。
        
        如果需要动态地创建光线效果，你可以根据每个视图的方向应用不同的alpha值做出半透明的阴影图层，但为了计算阴影图层的不透明度，你需要得到每个面的正太向量（垂直于表面的向量），然后根据一个想象的光源计算出两个向量叉乘结果。叉乘代表了光源和图层之间的角度，从而决定了它有多大程度上的光亮。
        
        清单5.10实现了这样一个结果，我们用GLKit框架来做向量的计算（你需要引入GLKit库来运行代码），每个面的CATransform3D都被转换成GLKMatrix4，然后通过GLKMatrix4GetMatrix3函数得出一个3×3的旋转矩阵。这个旋转矩阵指定了图层的方向，然后可以用它来得到正太向量的值。
        */
    }
    
    private func _lgc_show3DObject(show: Bool) {
        if show {
            containerView.hidden = false
            dialImageView.hidden = true
            transformImageView.hidden = true
        } else {
            containerView.hidden = true
            dialImageView.hidden = false
            transformImageView.hidden = false
        }
    }
    
    private func _lgc_shearTransform(x: CGFloat, y: CGFloat) -> CGAffineTransform {
        var transform = CGAffineTransformIdentity
        transform.c = -x
        transform.b = y
        return transform
    }
    
    private func _lgc_addFace(index: Int, withTransform transform: CATransform3D) {
        //get the face view and add it to the container
        let view = faceViews[index]
        containerView.addSubview(view)
        //center the face view within the container
        view.center = CGPointMake(CGRectGetMidX(containerView.bounds), CGRectGetMidY(containerView.bounds))
        // apply the transform
        view.layer.transform = transform
        _lgc_addLightingToFace(view.layer)
    }
    
    private func _lgc_addLightingToFace(face: CALayer) {
        //add lighting layer
        let layer = CALayer()
        layer.frame = face.bounds
        face.addSublayer(layer)
        //convert the face transform to matrix
        //(GLKMatrix4 has the same structure as CATransform3D)
        //译者注：GLKMatrix4和CATransform3D内存结构一致，但坐标类型有长度区别，所以理论上应该做一次float到CGFloat的转换，感谢[@zihuyishi](https://github.com/zihuyishi)同学~
        let transform = face.transform
        let matrix4 = GLKMatrix4Make(
            Float(transform.m11), Float(transform.m12), Float(transform.m13), Float(transform.m14),
            Float(transform.m21), Float(transform.m22), Float(transform.m23), Float(transform.m24),
            Float(transform.m31), Float(transform.m32), Float(transform.m33), Float(transform.m34),
            Float(transform.m41), Float(transform.m42), Float(transform.m43), Float(transform.m44))
//        let martrx4 = *(GLKMatrix4 *)&transform
        let matrix3 = GLKMatrix4GetMatrix3(matrix4) //GLKMatrix3
        //get face normal
        var normal = GLKVector3Make(0, 0, 1) //GLKVector3
        normal = GLKMatrix3MultiplyVector3(matrix3, normal)
        normal = GLKVector3Normalize(normal)
        //get dot product with light direction
        let light = GLKVector3Normalize(GLKVector3Make(0, 1, -0.5)) //GLKVector3
        let dotProduct = GLKVector3DotProduct(light, normal)
        //set lighting layer opacity
        let shadow = 1 + dotProduct - 0.5
        let color = UIColor(white:0, alpha:CGFloat(shadow))
        layer.backgroundColor = color.CGColor
    }
}

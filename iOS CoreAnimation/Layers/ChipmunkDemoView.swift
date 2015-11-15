//
//  ChipmunkDemoView.swift
//  iOS CoreAnimation
//
//  Created by Edmond on 11/7/15.
//  Copyright © 2015 Edmond. All rights reserved.
//

import UIKit
import QuartzCore
import chipmunk

let MASS: cpFloat = 100
let GRAVITY: cpFloat = 1000

/*
class Crate : UIImageView {
    let body: COpaquePointer//cpBody
    let shape: COpaquePointer//cpShape
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        image = UIImage(named:"Crate")
        contentMode = .ScaleAspectFill
        body = cpBodyNew(MASS, cpMomentForBox(MASS, cpFloat(frame.size.width), cpFloat(frame.size.height)))
        //create the shape
        let corners: [cpVect] = [
            cpv(0, 0),
            cpv(0, cpFloat(frame.size.height)),
            cpv(cpFloat(frame.size.width), cpFloat(frame.size.height)),
            cpv(cpFloat(frame.size.width), 0)]
        shape = cpPolyShapeNew(body, 4, corners, cpv(-frame.size.width/2.0, -frame.size.height/2.0))
        //set shape friction & elasticity
        cpShapeSetFriction(self.shape, 0.5)
        cpShapeSetElasticity(self.shape, 0.8)
        //link the crate to the shape
        //so we can refer to crate from callback later on
        shape.data = self
        //set the body position to match view
        cpBodySetPos(body, cpv(cpFloat(frame.origin.x + frame.size.width/2), cpFloat(300 - frame.origin.y - frame.size.height/2)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        cpShapeFree(shape)
        cpBodyFree(body)
    }
}

class ChipmunkDemoView : UIView {
    let containerView = UIView()
    let space: COpaquePointer
    let timer: CADisplayLink
    var lastStep: CFTimeInterval
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        //invert view coordinate system to match physics
        containerView.layer.geometryFlipped = true
        //set up physics space
        space = cpSpaceNew()
        cpSpaceSetGravity(self.space, cpv(0, -GRAVITY))
        //add a crate
        let crate = Crate(frame:CGRectMake(100, 0, 100, 100))
        containerView.addSubview(crate)
        cpSpaceAddBody(space, crate.body)
        cpSpaceAddShape(space, crate.shape)
        //start the timer
        lastStep = CACurrentMediaTime()
        timer = CADisplayLink(target:self, selector:"step:")
        timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode:NSDefaultRunLoopMode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func _lgc_updateShape(shape: cpShape, unused: Void) {
        //get the crate object associated with the shape
        let crate = (__bridge Crate *)shape->data
        //update crate view position and angle to match physics shape
        let body = shape->body
        crate.center = cpBodyGetPos(body)
        crate.transform = CGAffineTransformMakeRotation(cpBodyGetAngle(body))
    }
    
    func step(timer: CADisplayLink) {
        //calculate step duration
        let thisStep = CACurrentMediaTime();
        let stepDuration = thisStep - self.lastStep
        lastStep = thisStep
        //update physics
        cpSpaceStep(space, stepDuration)
        //update all the shapes
        cpSpaceEachShape(space, &updateShape, NULL)
    }
}
*/
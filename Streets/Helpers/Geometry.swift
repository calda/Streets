//
//  Geometry.swift
//  Streets
//
//  Created by Cal Stephens on 11/12/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import SpriteKit


//MARK: - CGPoint Operators

extension CGPoint {

    func distance(to point: CGPoint) -> CGFloat {
        return sqrt((self.x - point.x)^2 + (self.y - point.y)^2)
    }
    
    ///Angle in radians
    func angle(to point: CGPoint) -> CGFloat {
        let deltaX = point.x - self.x
        let deltaY = point.y - self.y
        
        let angle = atan2(deltaY, deltaX)
        return angle
    }
    
}

func +(left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}


//MARK: - Double Operators

infix operator ^: MultiplicationPrecedence

func ^(left: CGFloat, right: CGFloat) -> CGFloat {
    return pow(left, right)
}

func ^(left: CGFloat, right: Int) -> CGFloat {
    return left^CGFloat(right)
}

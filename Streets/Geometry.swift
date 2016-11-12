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
    
}


//MARK: - Double Operators

infix operator ^: MultiplicationPrecedence

func ^(left: CGFloat, right: CGFloat) -> CGFloat {
    return pow(left, right)
}

func ^(left: CGFloat, right: Int) -> CGFloat {
    return left^CGFloat(right)
}

//
//  Street.swift
//  Streets
//
//  Created by Cal Stephens on 11/12/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import Foundation
import SpriteKit

class Street : SKShapeNode {
    
    
    //MARK: - Managing Intersections
    
    private var intersectons = [Intersection]()
    
    public var allIntersections: [Intersection] {
        return self.intersectons
    }
    
    func addIntersection(_ intersection: Intersection) {
        intersectons.append(intersection)
        intersection.addStreet(self)
    }
    
}

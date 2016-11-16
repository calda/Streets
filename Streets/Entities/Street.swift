//
//  Street.swift
//  Streets
//
//  Created by Cal Stephens on 11/12/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import Foundation
import SpriteKit
import CGPathIntersection

class Street : SKShapeNode {
    
    lazy var pathImage: CGPathImage = {
        return CGPathImage(from: self.path!)
    }()
    
    //MARK: - Managing Intersections
    
    private var intersections = [Intersection]()
    
    public var allIntersections: [Intersection] {
        return self.intersections
    }
    
    func addIntersection(_ intersection: Intersection) {
        if intersections.contains(intersection) { return }

        intersections.append(intersection)
        intersection.addStreet(self)
    }
    
    
}

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
    
    let startingPoint: CGPoint
    
    
    //MARK: - Initializers
    
    init(startingAt start: CGPoint) {
        self.startingPoint = start
        super.init()
        self.strokeColor = .red
        self.lineWidth = 10.0
    }
    
    convenience init(between start: Intersection, and end: Intersection) {
        self.init(startingAt: start.position)
        self.addIntersection(start)
        self.addIntersection(end)
        self.path = self.path(from: start, to: end)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    
    //MARK: - Managing Intersections
    
    lazy var pathImage: CGPathImage = {
        return CGPathImage(from: self.path!)
    }()
    
    private var intersections = [Intersection]()
    
    public var allIntersections: [Intersection] {
        return self.intersections
    }
    
    func addIntersection(_ intersection: Intersection) {
        if intersections.contains(intersection) { return }

        intersections.append(intersection)
        intersection._addStreet(self)
        intersections.sort(by: self.intersection(_: isOrderedBefore:))
    }
    
    func hasAccess(to intersection: Intersection) -> Bool {
        return self.intersections.contains(intersection)
    }
    
    
    //MARK: - Shape-dependant methods. Override in subclasses.
    
    func intersection(_ one: Intersection, isOrderedBefore two: Intersection) -> Bool {
        let one_distanceFromStart = one.position.distance(to: self.startingPoint)
        let two_distanceFromStart = two.position.distance(to: self.startingPoint)
        return one_distanceFromStart <= two_distanceFromStart
    }
    
    func path(from start: Intersection, to end: Intersection) -> CGPath? {
        if !self.hasAccess(to: start) || !self.hasAccess(to: end) {
            return nil
        }
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: start.position)
        bezierPath.addLine(to: end.position)
        
        return bezierPath.cgPath
    }
    
}


//MARK: - Conform to Equatable

func ==(left: Street, right: Street) -> Bool {
    for intersection in left.allIntersections {
        if !right.allIntersections.contains(intersection) {
            return false
        }
    }
    
    return true
}

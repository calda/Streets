//
//  CreateStreetTouchDelegate.swift
//  Streets
//
//  Created by Cal Stephens on 11/12/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import SpriteKit

class CreateStreetDelegate : RoutableTouchDelegate {
    
    weak var owner: GameScene!
    var currentStreet: Street!
    var startingIntersection: Intersection!
    
    init(owner: GameScene) {
        self.owner = owner
    }
    
    func routingPriotory(from scene: GameScene, at point: CGPoint) -> RoutingPriotory {
        cleanUp() //in case any references are still hanging around
        
        if let closestIntersection = self.owner.closestIntersection(to: point, within: 20.0) {
            self.startingIntersection = closestIntersection
            print("from intersection")
            return .high //high priority if dragging from an existing intersection
        }
        
        print("from point")
        return .minimum //low priotiry if dragging from somewhere arbitrary
    }
    
    
    //MARK: - Finalize Interaction
    
    func commitStreet(withFinalPoint endPoint: CGPoint) {
        
        let closestToEnd = self.owner.closestIntersection(to: endPoint, within: 20.0)
        let endIntersection = closestToEnd ?? Intersection(position: endPoint)
        
        //add intersections
        currentStreet.addIntersection(self.startingIntersection)
        currentStreet.addIntersection(endIntersection)
        
        print("Start intersection has \(self.startingIntersection.allStreets.count) streets and end intersection has \(endIntersection.allStreets.count) streets.")
        
        self.currentStreet.removeFromParent()
        self.owner.addStreet(currentStreet)
        
        cleanUp()
    }
    
    func cleanUp() {
        self.startingIntersection = nil
        self.currentStreet = nil
    }
    
    
    //MARK: - Touch Events
    
    func touchDown(at point: CGPoint) {
        if self.startingIntersection == nil {
            self.startingIntersection = Intersection(position: point)
        }
        
        self.currentStreet = Street(path: CGPath(rect: .zero, transform: nil))
        self.currentStreet.strokeColor = .red
        self.currentStreet.lineWidth = 10.0
        self.owner.addChild(self.currentStreet)
    }
    
    func touchMoved(to point: CGPoint) {
        let path = UIBezierPath()
        path.move(to: self.startingIntersection.position)
        path.addLine(to: point)
        self.currentStreet.path = path.cgPath
    }
    
    func touchUp(at point: CGPoint) {
        if point.distance(to: self.startingIntersection.position) < 10.0 {
            touchCancelled(at: point)
        } else {
            commitStreet(withFinalPoint: point)
        }
    }
    
    func touchCancelled(at point: CGPoint) {
        self.currentStreet.removeFromParent()
        cleanUp()
    }
    
}

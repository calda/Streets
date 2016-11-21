//
//  CreateStreetTouchDelegate.swift
//  Streets
//
//  Created by Cal Stephens on 11/12/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import SpriteKit
import CGPathIntersection

class CreateStreetDelegate : RoutableTouchDelegate {
    
    weak var owner: GameScene!
    var currentStreet: Street!
    var startingIntersection: Intersection!
    
    init(owner: GameScene) {
        self.owner = owner
    }
    
    func routingPriotory(from scene: GameScene, at point: CGPoint) -> RoutingPriotory {
        cleanUp() //in case any references are still hanging around
        
        let (intersection, priotity) = self.intersection(for: point)
        self.startingIntersection = intersection
        return priotity
    }
    
    private func intersection(for point: CGPoint) -> (intersection: Intersection, priority: RoutingPriotory) {
        
        if let closestIntersection = self.owner.closestIntersection(to: point, within: 30.0) {
            print("from intersection")
            return (closestIntersection, .high) //high priority if dragging from an existing intersection
        }
        
        //else if let existingStreet = street(at: point) {
            //create a new intersection
            //but that can't be added to the existing street immediately
            //what's the best way to go about that?
        //}
        
        else {
            return (Intersection(position: point), .minimum) //low priotiry if dragging from somewhere arbitrary
        }
    }
    
    private func street(at point: CGPoint) -> Street? {
        let rectForPoint = CGRect(x: point.x - 5, y: point.y - 5, width: 10, height: 10)
        let pathForPoint = UIBezierPath(ovalIn: rectForPoint).cgPath
        let pointImage = CGPathImage(from: pathForPoint)
        
        for street in owner.allStreets {
            if street.pathImage.intersects(path: pointImage) {
                return street
            }
        }
        
        return nil
    }
    
    
    //MARK: - Finalize Interaction
    
    func commitStreet(withFinalPoint endPoint: CGPoint) {
        
        let closestToEnd = self.owner.closestIntersection(to: endPoint, within: 30.0)
        let endIntersection = closestToEnd ?? Intersection(position: endPoint)
        
        //add intersections
        currentStreet.addIntersection(self.startingIntersection)
        currentStreet.addIntersection(endIntersection)
        currentStreet.path = currentStreet.path(from: self.startingIntersection, to: endIntersection)
        
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
        
        self.currentStreet = Street(startingAt: self.startingIntersection.position)
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

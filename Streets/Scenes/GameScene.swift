//
//  GameScene.swift
//  Streets
//
//  Created by Cal Stephens on 11/12/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import SpriteKit
import CGPathIntersection

class GameScene: SKScene {
    
    var touchDelegate: RoutingDelegate?
    
    override func didMove(to view: SKView) {
        let delegates = [
            CreateStreetDelegate(owner: self)
        ]
        
        self.touchDelegate = RoutingDelegate(owner: self)
        self.touchDelegate?.delegates = delegates
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        //create streets
        
        /*let roundabout = Roundabout(at: CGPoint(x: 300, y: 500), radius: 160.0)
        self.addStreet(roundabout)
        
        let initialIntersection = Intersection(position: CGPoint(x: 460, y: 500))
        self.addChild(initialIntersection)
        roundabout.addIntersection(initialIntersection)
        
        let car = Car.new(at: initialIntersection)
        self.addChild(car)
        car.travelToRandomIntersection()*/
        
        let spawnIntersection = Intersection(position: CGPoint(x: 300, y: 200))
        let spawner = Spawner(intersection: spawnIntersection)
        
        self.addToSceneIfNecessary(spawnIntersection, spawner)
        
    }
    
    
    //MARK: - Streets
    
    private var streets = [Street]()
    
    public var allStreets: [Street] {
        return self.streets
    }
    
    public var allIntersections: [Intersection] {
        return self.children.flatMap { $0 as? Intersection }
    }
    
    public func closestIntersection(to point: CGPoint, within distance: CGFloat) -> Intersection? {
        let nearbyIntersections = self.allIntersections.filter { intersection in
            return intersection.position.distance(to: point) < distance
        }
        
        let closestIntersection = nearbyIntersections.sorted { (left, right) in
            return left.position.distance(to: point) < right.position.distance(to: point)
        }.first
        
        return closestIntersection
    }
    
    public func addToSceneIfNecessary(_ nodes: SKNode...) {
        for node in nodes {
            if node.parent == nil {
                self.addChild(node)
            }
        }
    }
    
    ///Creates a strong reference to the street
    public func addStreet(_ newStreet: Street) {
        if streets.contains(newStreet) { return }
        
        //add all intersections to the scene
        newStreet.allIntersections.forEach{ self.addToSceneIfNecessary($0) }
        
        //create additional intersections as necessary
        for street in streets {
            let intersectionPoints = street.pathImage.intersectionPoints(with: newStreet.pathImage)
            
            for intersectionPoint in intersectionPoints {
                let intersection = closestIntersection(to: intersectionPoint, within: 10.0) ?? Intersection(position: intersectionPoint)
                
                street.addIntersection(intersection)
                newStreet.addIntersection(intersection)
                
                self.addToSceneIfNecessary(intersection)
            }
        }
        
        streets.append(newStreet)
        self.addChild(newStreet)
    }
    
    func street(at point: CGPoint, within distance: CGFloat) -> (street: Street, intersection: CGPoint)? {
        let rectForPoint = CGRect(x: point.x - (distance/2), y: point.y - (distance/2), width: distance, height: distance)
        let pathForPoint = UIBezierPath(ovalIn: rectForPoint).cgPath
        let pointImage = CGPathImage(from: pathForPoint)
        
        for street in self.streets {
            if let intersection = street.pathImage.intersectionPoints(with: pointImage).first {
                return (street, intersection)
            }
        }
        
        return nil
    }
    
    
    //MARK: - Pass touches to the current delegate
    
    private func pass(touches: Set<UITouch>, to delegateMethod: ((CGPoint) -> ())?) {
        delegateMethod?(touches.first!.location(in: self))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pass(touches: touches, to: self.touchDelegate?.touchDown)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pass(touches: touches, to: self.touchDelegate?.touchMoved)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pass(touches: touches, to: self.touchDelegate?.touchUp)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pass(touches: touches, to: self.touchDelegate?.touchCancelled)
    }
    
    
    //MARK: - Internal Clock
    
    var previousUpdate: TimeInterval?
        
    override func update(_ currentTime: TimeInterval) {
        
        if let previousUpdate = self.previousUpdate {
            let delta = currentTime - previousUpdate
            self.previousUpdate = currentTime
            
            self.children.forEach { child in
                if let needsUpdate = child as? RunsOnGameLoop {
                    needsUpdate.update(delta: CGFloat(delta))
                }
            }
        }
        
        else {
            self.previousUpdate = currentTime
        }
        
    }
}

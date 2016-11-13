//
//  GameScene.swift
//  Streets
//
//  Created by Cal Stephens on 11/12/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var touchDelegate: RoutingDelegate?
    
    override func didMove(to view: SKView) {
        let delegates = [
            CreateStreetDelegate(owner: self)
        ]
        
        self.touchDelegate = RoutingDelegate(owner: self)
        self.touchDelegate?.delegates = delegates
    }
    
    
    //MARK: - Streets
    
    private var streets = [Street]()
    
    public var allStreets: [Street] {
        return self.streets
    }
    
    public var allIntersections: [Intersection] {
        return self.allStreets.flatMap { $0.allIntersections }
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
    
    
    /// Creates a strong reference to the street,
    public func addStreet(_ street: Street) {
        streets.append(street)
        self.addChild(street)
        
        street.allIntersections.forEach { intersection in
            if intersection.parent == nil {
                self.addChild(intersection)
            }
        }
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
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

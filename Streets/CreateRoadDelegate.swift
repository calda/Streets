//
//  CreateRoadTouchDelegate.swift
//  Streets
//
//  Created by Cal Stephens on 11/12/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import SpriteKit

class CreateRoadDelegate : TouchDelegate {
    
    
    var owner: GameScene
    var currentRoad: SKShapeNode!
    var origin: CGPoint!
    
    init(owner: GameScene) {
        self.owner = owner
    }
    
    
    //MARK: - Touch Events
    
    
    func touchDown(at point: CGPoint) {
        self.origin = point
        self.currentRoad = SKShapeNode(path: CGPath(rect: .zero, transform: nil))
        self.currentRoad.strokeColor = .red
        self.currentRoad.lineWidth = 10.0
        self.owner.addChild(self.currentRoad)
    }
    
    func touchMoved(to point: CGPoint) {
        let path = UIBezierPath()
        path.move(to: self.origin)
        path.addLine(to: point)
        self.currentRoad.path = path.cgPath
    }
    
    func touchUp(at point: CGPoint) {
        if point.distance(to: origin) < 10.0 {
            touchCancelled(at: point)
        } else {
            self.origin = nil
            self.currentRoad = nil
        }
    }
    
    func touchCancelled(at point: CGPoint) {
        self.currentRoad.removeFromParent()
        self.origin = nil
        self.currentRoad = nil
    }
    
}

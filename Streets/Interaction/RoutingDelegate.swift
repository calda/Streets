//
//  RoutingDelegate.swift
//  Streets
//
//  Created by Cal Stephens on 11/12/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import Foundation
import SpriteKit

class RoutingDelegate : TouchDelegate {
    
    var delegates = [RoutableTouchDelegate]()
    var routedDelegate: RoutableTouchDelegate?
    
    weak var owner: GameScene!
    
    init(owner: GameScene) {
        self.owner = owner
    }
    
    
    //MARK: - Routing only on touch-down
    
    func touchDown(at point: CGPoint) {
        
        self.routedDelegate = self.delegates
            .map { (delegate: $0, priority: $0.routingPriotory(from: self.owner, at: point)) }
            .sorted { (left, right) in left.priority.rawValue < right.priority.rawValue }
            .first?.delegate
        
        routedDelegate?.touchDown(at: point)
    }
    
    func touchMoved(to point: CGPoint) {
        routedDelegate?.touchMoved(to: point)
    }
    
    func touchUp(at point: CGPoint) {
        routedDelegate?.touchUp(at: point)
    }
    
    func touchCancelled(at point: CGPoint) {
        routedDelegate?.touchCancelled(at: point)
    }
    
    
    
}

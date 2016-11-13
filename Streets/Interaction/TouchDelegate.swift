//
//  TouchDelegate.swift
//  Streets
//
//  Created by Cal Stephens on 11/12/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import Foundation
import SpriteKit

protocol TouchDelegate {
    
    func touchDown(at point: CGPoint)
    func touchMoved(to point: CGPoint)
    func touchUp(at point: CGPoint)
    func touchCancelled(at point: CGPoint)
    
}

protocol RoutableTouchDelegate : TouchDelegate {
    func routingPriotory(from scene: GameScene, at point: CGPoint) -> RoutingPriotory
}

enum RoutingPriotory : Int {
    case high = 10
    case medium = 5
    case low = 2
    case minimum = 1
}

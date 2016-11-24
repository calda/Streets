//
//  Spawner.swift
//  Streets
//
//  Created by Cal Stephens on 11/21/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import SpriteKit

class Spawner : SKShapeNode {
    
    let intersection: Intersection
    
    //MARK: - Initializers
    
    init(intersection: Intersection) {
        self.intersection = intersection
        super.init()
        
        //decorate
        self.path = self.path(startingAt: intersection.position)
        self.fillColor = .blue
        self.strokeColor = .blue
        
        //set up actions
        let wait = SKAction.wait(forDuration: 7.0, withRange: 5.0)
        
        let spawnCar = SKAction.run {
            if intersection.allStreets.count != 0 {
                let car = Car(at: intersection)
                self.parent?.addChild(car)
            }
        }
        
        let actionLoop = SKAction.sequence([spawnCar, wait])
        self.run(SKAction.repeatForever(actionLoop))
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    
    //MARK: - Helper Functions
    
    private func path(startingAt tip: CGPoint) -> CGPath {
        let corner1 = tip + (-40, -60)
        let corner2 = corner1 + (80, 0)
        
        let path = UIBezierPath()
        path.move(to: tip)
        path.addLine(to: corner1)
        path.addLine(to: corner2)
        path.close()
        return path.cgPath
    }
    
    
}

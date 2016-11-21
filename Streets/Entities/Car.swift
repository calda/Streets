//
//  Car.swift
//  Streets
//
//  Created by Cal Stephens on 11/20/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import Foundation
import SpriteKit

class Car : SKShapeNode {
    
    var driveSpeed: CGFloat = 200.0
    var previousIntersection: Intersection? = nil
    var previousStreet: Street? = nil
    
    static func new(at intersection: Intersection) -> Car {
        let car = Car(circleOfRadius: 20.0)
        car.previousIntersection = intersection
        car.previousStreet = intersection.allStreets.randomItem()
        
        car.position = intersection.position
        car.fillColor = UIColor.blue
        car.zPosition = 1.0
        return car
    }
    
    func travelToRandomIntersection() {
        guard let currentIntersection = previousIntersection else { return }
        
        let possibleStreets = currentIntersection.allStreets
        let nextStreet = possibleStreets.randomItem(excluding: self.previousStreet)
        let nextIntersection = nextStreet.allIntersections.randomItem(excluding: currentIntersection)
        
        self.travel(between: currentIntersection, and: nextIntersection, on: nextStreet)
    }
    
    func travel(between start: Intersection, and end: Intersection, on street: Street) {
        self.position = start.position
        
        guard let path = street.path(from: start, to: end) else {
            fatalError("Street does not contain both intersections")
        }
        
        let drive = SKAction.follow(path, asOffset: false, orientToPath: false, speed: self.driveSpeed)
        
        let chooseNextIntersection = SKAction.run {
            self.previousIntersection = end
            self.previousStreet = street
            self.travelToRandomIntersection()
        }
        
        self.run(SKAction.sequence([drive, chooseNextIntersection]))
        
    }
    
}

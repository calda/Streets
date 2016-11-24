//
//  Car.swift
//  Streets
//
//  Created by Cal Stephens on 11/20/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import Foundation
import SpriteKit

///percentage from start to end -> position & rotation
public typealias PositionFunction = (CGFloat) -> (position: CGPoint, rotation: CGFloat)
public typealias TravelDetails = (travelFunction: PositionFunction, distance: CGFloat)

private typealias TravelLeg = (street: Street, destination: Intersection, details: TravelDetails)

class Car : SKShapeNode, RunsOnGameLoop {
    
    var driveSpeed: CGFloat = 200.0
    
    private var currentLeg: TravelLeg?
    private var nextLeg: TravelLeg?
    
    var travelPercentage: CGFloat = 0.0
    
    init(at intersection: Intersection) {
        super.init()
        
        let path = self.shape()
        self.path = path
        self.position = intersection.position
        self.fillColor = .blue
        self.strokeColor = .clear
        self.zPosition = 1.0
        
        self.currentLeg = randomLeg(from: intersection)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    
    //MARK: - Behavior
    
    private func randomLeg(from currentIntersection: Intersection, excluding previousLeg: TravelLeg? = nil) -> TravelLeg {
        let possibleStreets = currentIntersection.allStreets
        let nextStreet = possibleStreets.randomItem(excluding: previousLeg?.street)
        let nextIntersection = nextStreet.allIntersections.randomItem(excluding: previousLeg?.destination)
        let travelDetails = nextStreet.travelDetails(from: currentIntersection, to: nextIntersection)
        
        return (street: nextStreet, destination: nextIntersection, details: travelDetails)
    }
    
    
    //MARK: - Run Loop
    
    func update(delta: CGFloat) {
        guard let (_, _, (positionFunction, distance)) = self.currentLeg else { return }
        let distanceRemaining = distance - (distance * self.travelPercentage)
        
        //update current position
        let (newPosition, newAngle) = positionFunction(self.travelPercentage)
        self.position = newPosition
        self.zRotation = interpolatedRotation(newAngle, distanceRemaining: distanceRemaining)
        
        if (self.travelPercentage >= 1.0) {
            self.currentLeg = self.nextLeg
            self.nextLeg = nil
            self.travelPercentage = 0.0
            return
        }
        
        //calculate updated percentage
        let percentagePerUpdate = (driveSpeed / distance) * delta
        self.travelPercentage = min(self.travelPercentage + percentagePerUpdate, 1.0)
    }

    func interpolatedRotation(_ rotation: CGFloat, distanceRemaining: CGFloat) -> CGFloat {
        let minimumDistance: CGFloat = 50.0
        if distanceRemaining > minimumDistance {
            return rotation
        }
        
        if self.nextLeg == nil {
            self.nextLeg = self.randomLeg(from: self.currentLeg!.destination, excluding: self.currentLeg)
        }
        
        let currentRotation = self.zRotation
        let initialRotation = self.nextLeg!.details.travelFunction(0.0).rotation
        let interpolationPercentage = 1 - (distanceRemaining / minimumDistance)
        
        let difference = initialRotation - currentRotation
        let interpolatedRotation = currentRotation + (difference * interpolationPercentage)
        return interpolatedRotation
    }
    
    
    //MARK: - Helpers
    
    private func shape() -> CGPath {
        let tip = CGPoint(x: 25, y: 0)
        let corner1 = tip + (-50, -20)
        let inlet = corner1 + (10, 20)
        let corner2 = inlet + (-10, 20)
        
        let path = UIBezierPath()
        path.move(to: tip)
        path.addLine(to: corner1)
        path.addLine(to: inlet)
        path.addLine(to: corner2)
        path.close()
        
        return path.cgPath
    }
}

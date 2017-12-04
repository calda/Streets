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
    
    private var rotationBeforeSwitch: CGFloat?
    private var currentLeg: TravelLeg?
    private var nextLeg: TravelLeg?
    
    ///linear percentage between start and end
    var travelPercentage: CGFloat = 0.0
    
    init(at intersection: Intersection) {
        super.init()
        
        let path = self.carShape
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
        guard let (_, destination, (positionFunction, distance)) = self.currentLeg else { return }
        let distanceSoFar = distance * self.travelPercentage
        let distanceRemaining = distance - distanceSoFar
        
        //update current position
        let positionPercentage = CGFloat(-0.5 * cos(.pi * Double(self.travelPercentage)) + 0.5) //0.5cos(πx) + 0.5
        let (newPosition, newAngle) = positionFunction(positionPercentage)
        self.position = newPosition
        
        //calculate rotation
        let interpolationRange: CGFloat = 100.0
        let halfRange = (interpolationRange / 2)
        
        //first half of interopolation is at end of leg
        if distanceRemaining < halfRange {
            if self.nextLeg == nil {
                self.nextLeg = self.randomLeg(from: destination, excluding: self.currentLeg)
            }
            
            let initialRotationOfNext = self.nextLeg!.details.travelFunction(0.0).rotation
            let percentage = 0.5 - (distanceRemaining / interpolationRange)
            self.zRotation = self.interpolateRotation(newAngle, towards: initialRotationOfNext, interpolationPercentage: percentage)
        }
        
        //last half of interpolation is at start of next leg
        else if distanceSoFar < halfRange, let previousRotation = self.rotationBeforeSwitch {
            let percentage = (distanceSoFar) / halfRange
            self.zRotation = self.interpolateRotation(previousRotation, towards: newAngle, interpolationPercentage: percentage)
        }
        
        else {
            self.zRotation = newAngle
        }
        
        //start next leg if ready
        if (self.travelPercentage >= 1.0) {
            self.rotationBeforeSwitch = self.zRotation
            self.currentLeg = self.nextLeg
            self.nextLeg = nil
            self.travelPercentage = 0.0
            return
        }
        
        //calculate updated percentage
        let percentagePerUpdate = (driveSpeed / distance) * delta
        self.travelPercentage = min(self.travelPercentage + percentagePerUpdate, 1.0)
    }
    
    func interpolateRotation(_ current: CGFloat, towards end: CGFloat, interpolationPercentage: CGFloat) -> CGFloat {
        let difference = end - current
        let interpolatedRotation = current + (difference * interpolationPercentage)
        return interpolatedRotation
    }
    
    
    //MARK: - Helpers
    
    private var carShape: CGPath {
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

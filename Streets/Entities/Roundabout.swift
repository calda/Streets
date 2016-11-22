//
//  Roundabout.swift
//  Streets
//
//  Created by Cal Stephens on 11/20/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import SpriteKit

class Roundabout : Street {
    
    private var center: CGPoint
    private var radius: CGFloat
    
    init(at center: CGPoint, radius: CGFloat) {
        self.center = .zero
        self.radius = 0
        
        super.init(startingAt: center + CGPoint(x: radius, y: 0))
        self.update(center: center, radius: radius)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    func update(center: CGPoint, radius: CGFloat) {
        self.center = center
        self.radius = radius
        self.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: true).cgPath
    }
    
    
    //MARK: - Configure as circular paths
    
    private func angle(for intersection: Intersection) -> CGFloat {
        return self.center.angle(to: intersection.position)
    }
    
    override func intersection(_ one: Intersection, isOrderedBefore two: Intersection) -> Bool {
        return angle(for: one) < angle(for: two)
    }
    
    override func path(from start: Intersection, to end: Intersection) -> CGPath? {
        if !self.hasAccess(to: start) || !self.hasAccess(to: end) {
            return nil
        }
        
        let startAngle = angle(for: start)
        var endAngle = angle(for: end)
        
        //always travel clockwise
        if endAngle <= startAngle {
            endAngle += CGFloat(2 * M_PI)
        }
        
        return UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
    }
    
}

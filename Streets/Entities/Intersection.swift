//
//  Intersection.swift
//  Streets
//
//  Created by Cal Stephens on 11/12/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import Foundation
import SpriteKit

class Intersection : SKShapeNode {
    
    private var streets: NSHashTable<Street> //NSHashTable holding weak references
    
    init(position: CGPoint) {
        self.streets = NSHashTable<Street>(options: .weakMemory)
        super.init()
        
        self.position = position
        
        let rect = CGRect(origin: CGPoint(x: -15, y: -15), size: CGSize(width: 30, height: 30))
        self.path = CGPath(rect: rect, transform: nil)
        self.fillColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 0.5)
        self.strokeColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    
    //MARK: - Managing Streets
    
    var allStreets: [Street] {
        return streets.allObjects
    }
    
    func _addStreet(_ street: Street) {
        if streets.contains(street) { return }
        self.streets.add(street)
    }
    
    
    //MARK: - Helper Methods
    
    var center: CGPoint {
        let boundingBox = self.path!.boundingBox
        return CGPoint(x: boundingBox.midX, y: boundingBox.midY)
    }
    
}


//MARK: - Conform to Equatable

func ==(left: Intersection, right: Intersection) -> Bool {
    return left.position == right.position
}

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
    
    convenience init(position: CGPoint) {
        self.init()
        let rect = CGRect(origin: CGPoint(x: -15, y: -15), size: CGSize(width: 30, height: 30))
        self.path = CGPath(rect: rect, transform: nil)
        self.fillColor = .red
        self.position = position
    }
    
    override init() {
        streets = NSHashTable<Street>(options: .weakMemory)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // not implemented
        streets = NSHashTable<Street>(options: .weakMemory)
        super.init()
    }
    
    
    //MARK: - Managing Streets
    
    var allStreets: [Street] {
        return streets.allObjects
    }
    
    ///Call Street.addIntersection instead
    func addStreet(_ street: Street) {
        self.streets.add(street)
    }
    
    
}

//
//  Array+Helpers.swift
//  Streets
//
//  Created by Cal Stephens on 11/20/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import Foundation

extension Array {
    
    func randomItem() -> Element {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
    
}

extension Array where Element : Equatable {
    
    func randomItem(excluding: Element?) -> Element {
        if self.count == 1 {
            return self.first!
        } else {
            return self.filter{ $0 != excluding }.randomItem()
        }
    }
    
}

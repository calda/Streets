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

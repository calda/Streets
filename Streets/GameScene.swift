//
//  GameScene.swift
//  Streets
//
//  Created by Cal Stephens on 11/12/16.
//  Copyright © 2016 Cal Stephens. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var touchDelegate: TouchDelegate?
    
    override func didMove(to view: SKView) {
        self.touchDelegate = CreateRoadDelegate(owner: self)
    }
    
    
    //MARK: - Pass touches to the current delegate
    
    private func pass(touches: Set<UITouch>, to delegateMethod: ((CGPoint) -> ())?) {
        //touches.forEach { touch in
            delegateMethod?(touches.first!.location(in: self))
        //}
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pass(touches: touches, to: self.touchDelegate?.touchDown)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pass(touches: touches, to: self.touchDelegate?.touchMoved)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pass(touches: touches, to: self.touchDelegate?.touchUp)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.pass(touches: touches, to: self.touchDelegate?.touchCancelled)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

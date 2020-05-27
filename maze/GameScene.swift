//
//  GameScene.swift
//  maze
//
//  Created by 90304395 on 5/6/20.
//  Copyright © 2020 90304395. All rights reserved.
//

import SpriteKit

class Gamescene = SKScene()

    var player = SKSpriteNode()

override func didMoveToView(view: SKView) {
    self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    player = SKSpriteMode(color: UIColor.cyanColor(), size: CGSize(width: 90, hieght: 90))
    player.anchorpoint = CGPoint(x: 0.5, y: 0.5)
    player.position = CGPoint(x: 0, y:0)
    
    self.adChild(player)
}

override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    for touch in touches {
        
        let location = touch.locationInNode[self]
        
        player.position.x = location.x
        player.position.y = location.y
        
        print("x: ")
    }
}

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
    player.anchorpoint = CGPoint(x.5, y: 0.5)
    
}

//
//  GameScene.swift
//  maze
//
//  Created by 90304395 on 5/6/20.
//  Copyright © 2020 90304395. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private let wallSize = 27
    private let scale = 20
  
    var h = SKSpriteNode()
    var c = SKSpriteNode()
    override func didMove(to view: SKView) {
        h = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 50, height: 50))
        h.addChild(SKLabelNode(text: "host"))
        h.position = CGPoint(x: 200, y: 200)
        
        c = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 50, height: 50))
        c.addChild(SKLabelNode(text: "client"))
        c.position = CGPoint(x: 400, y: 200)
        addChild(c)
        addChild(h)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var t = touches.first?.location(in: self) as! CGPoint
        
        if h.contains(t){
            print("host")
        }
        else if c.contains(t){
            print("client")
        }
        
    }
        
    
}

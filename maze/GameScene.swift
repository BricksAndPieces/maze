//
//  GameScene.swift
//  maze
//
//  Created by 90304395 on 5/6/20.
//  Copyright © 2020 90304395. All rights reserved.
//

import SpriteKit
import GameplayKit
import SwiftSocket
class GameScene: SKScene {
    
   
    
    override func didMove(to view: SKView) {
        
       var s = Server()
        s.start()
        
        var c = Client(name: "hibey")
        var c2 = Client(name:"man")
        c.sendCords(x: 3, y: 4)
        c2.sendCords(x: 3, y: 4)
    }
    
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        }
        
        
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

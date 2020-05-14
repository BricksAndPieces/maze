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
        var maze = [[true, true],[false, true], [false, false] ]
       var s = Server()
        s.start()
        var client = Client(name:"jemes")
        
        
        sleep(2)
        s.sendMaze(maze: maze)
        var m = client.reciveMaze()
        print(m)
        sleep(2)
        client.start()
        client.sendCords(x: 40, y: 30)
        
        print(client.cords)
        
    }
    
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        }
        
        
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

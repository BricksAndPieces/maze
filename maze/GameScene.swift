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
    var m = SKSpriteNode()
    var s:Server?
    override func didMove(to view: SKView) {
        h = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 50, height: 50))
        h.addChild(SKLabelNode(text: "host"))
        h.position = CGPoint(x: 200, y: 200)
        
        c = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 50, height: 50))
        c.addChild(SKLabelNode(text: "client"))
        c.position = CGPoint(x: 100, y: 200)
        addChild(c)
        addChild(h)
        
        
        m = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 50, height: 50))
        m.addChild(SKLabelNode(text: "send maze"))
        m.position = CGPoint(x: 0, y: 200)
        addChild(m)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var t = touches.first?.location(in: self) as! CGPoint
        
        if h.contains(t){
            print("host")
             s = Server()
            s!.start()
            var cli = Client(name: "names")
            
            let n = DispatchQueue(label: "recive maze", qos:.userInitiated, attributes: .concurrent)

            n.async{
                
                
                var thing = cli.reciveMaze()
                print(thing)
                var scene = Masking(size: self.size)
                scene.c = cli
                scene.mazeLayout = thing
                scene.scaleMode = .aspectFit
                self.view?.presentScene(scene)
            }
            
            
            
        }
        else if c.contains(t){
            print("client")
            var cli = Client(name: "n")
            
            
            let n = DispatchQueue(label: "recive maze", qos:.userInitiated, attributes: .concurrent)

            n.async{
                
                
                var thing = cli.reciveMaze()
                print(thing)
                var scene = gameplay(size: self.size)
                scene.c = cli
                scene.mazeLayout = thing
                scene.scaleMode = .aspectFit
                self.view?.presentScene(scene)
                
            }
            
            
            
        }
        
        else if m.contains(t){
            print("yes")
            let mazeGen = MazeGenerator()
            let layout = mazeGen.generateMaze(width: wallSize, height: wallSize, centerSize: 3)
            s!.sendMaze(maze: layout)
        }
        
    }
        
    
}

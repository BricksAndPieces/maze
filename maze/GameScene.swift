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
    
    var lobby = SKLabelNode()
    
    var nameEntry = UITextField(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
    var ip = UITextField(frame: CGRect(x: 100, y: 30, width: 200, height: 50))
    
    override func didMove(to view: SKView) {
        h = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 50, height: 50))
        h.addChild(SKLabelNode(text: "host"))
        h.position = CGPoint(x: 200, y: 200)
        h.color = UIColor.blue
        
        c = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 50, height: 50))
        c.addChild(SKLabelNode(text: "client"))
        c.position = CGPoint(x: 100, y: 200)
        c.color = UIColor.red
        addChild(c)
        addChild(h)
        
        
        m = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 50, height: 50))
        m.addChild(SKLabelNode(text: "Start Game!"))
        m.position = CGPoint(x: 0, y: 200)
        m.color = UIColor.red
        
        
        nameEntry.backgroundColor = UIColor.black
        self.view!.addSubview(nameEntry)
        nameEntry.text = "Enter a Unique name"
        nameEntry.textColor = UIColor.white
        
        ip.backgroundColor = UIColor.black
        self.view!.addSubview(ip)
        ip.text = "Enter Server IP"
        ip.textColor = UIColor.white
        lobby = SKLabelNode(text: "")
        lobby.position = CGPoint(x: 0, y: 0)
        

        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var t = touches.first?.location(in: self) as! CGPoint
        
        if h.contains(t){
            
                        nameEntry.removeFromSuperview()
            ip.removeFromSuperview()
            c.removeFromParent()
            h.removeFromParent()
            s = Server(ip: ip.text!)
            s!.start()
            lobby.numberOfLines = 20
            addChild(lobby)
            var loop = DispatchQueue(label: "lobby", qos:.background, attributes: .concurrent)
            loop.async{
                while !self.s!.gameStarts{
                    var n = ""
                    for i in self.s!.names{
                        n = n + "\n" + i
                    }
                    self.lobby.text = n
                }
                    
                
                
            }
            var cli = Client(name: nameEntry.text!, ip: ip.text!)
            cli.sendName()
            addChild(m)
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
        else if c.contains(t){
            nameEntry.removeFromSuperview()
            ip.removeFromSuperview()
            c.removeFromParent()
            var cli = Client(name: nameEntry.text!, ip: ip.text!)
            cli.sendName()
            if cli.connected{
                h.removeFromParent()
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
            
            
            
            
        }
        
        else if m.contains(t){
            nameEntry.removeFromSuperview()
            ip.removeFromSuperview()
            let mazeGen = MazeGenerator()
            let layout = mazeGen.generateMaze(width: wallSize, height: wallSize, centerSize: 3)
            s!.sendMaze(maze: layout)
            s!.gameStarts = true
        }
        
    }
        
    
}

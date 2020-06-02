//
//  gameplay.swift
//  maze
//
//  Created by 90304395 on 5/25/20.
//  Copyright © 2020 90304395. All rights reserved.
//

import SpriteKit
import GameplayKit

class gameplay:SKScene{
    var l = SKSpriteNode()
    var r = SKSpriteNode()
    
    var up = SKSpriteNode()
    var down = SKSpriteNode()
    
    
    
    var player = SKShapeNode()
    var c:Client?
    var players = [SKShapeNode]()
    var names = "HELP"
    var right = false
    var left = false
    var ddown = false
    var uup = false
    var mazeLayout: [[Bool]]?
    override func didMove(to view: SKView) {
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.size = CGSize(width: 1500, height: 1334.0)
        var mazeGen = MazeGenerator()
        let tilemap = mazeGen.getMazeNode(layout: mazeLayout!)
        tilemap.setScale(0.4)
        addChild(tilemap)
        l = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 100, height: 100))
        l.addChild(SKLabelNode(text: "Left"))
        l.position = CGPoint(x: 500, y: 200)
        
        r = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 100, height: 100))
        r.addChild(SKLabelNode(text: "Right"))
        r.position = CGPoint(x: 700, y: 200)
        
        up = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 100, height: 100))
        up.addChild(SKLabelNode(text: "up"))
        up.position = CGPoint(x: 600, y: 300)
        
        down = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 100, height: 100))
        down.addChild(SKLabelNode(text: "down"))
        down.position = CGPoint(x: 600, y: 100)
        addChild(r)
        addChild(l)
        addChild(up)
        addChild(down)
        
        player = SKShapeNode(circleOfRadius: CGFloat(25))
        player.fillColor = UIColor.green
        player.position = CGPoint(x: 50, y: 50)
        player.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        player.physicsBody?.affectedByGravity = false
        
        addChild(player)
        c!.start()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var t = touches.first?.location(in: self) as! CGPoint
        
        if r.contains(t){
            right = true
            
            
        }
        else if l.contains(t){
            left = true
        }
        else if up.contains(t){
            uup = true
        }
        else if down.contains(t){
            ddown = true
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        right = false
        left = false
        uup = false
        ddown = false
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        for p in players{
            p.removeFromParent()
        }
        players = []
        
        for i in c!.cords{
            if i.0 != c!.name{
                var one = SKShapeNode(circleOfRadius: 25)
                one.position = CGPoint(x: Double(i.1)!, y: Double(i.2)!)
                one.fillColor = UIColor.red
                addChild(one)
                players.append(one)
            }
            
            
        }
        
        if right{
            player.position.x+=10
            c!.sendCords(x: Int(player.position.x), y: Int(player.position.y))
            
        }
        else if left{
            player.position.x-=10
            c!.sendCords(x: Int(player.position.x), y: Int(player.position.y))
        }
        else if ddown{
            player.position.y-=10
            c!.sendCords(x: Int(player.position.x), y: Int(player.position.y))
        }
        else if uup{
            player.position.y+=10
            c!.sendCords(x: Int(player.position.x), y: Int(player.position.y))
        }
    }
}

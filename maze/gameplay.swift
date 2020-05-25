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
    var player = SKShapeNode()
    var c:Client?
    var players = [SKShapeNode]()
    override func didMove(to view: SKView) {
        c = Client(name: "bob")
        c!.start()

        
        l = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 50, height: 50))
        l.addChild(SKLabelNode(text: "Left"))
        l.position = CGPoint(x: 200, y: 200)
        
        r = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 50, height: 50))
        r.addChild(SKLabelNode(text: "Right"))
        r.position = CGPoint(x: 100, y: 200)
        addChild(r)
        addChild(l)
        
        player = SKShapeNode(circleOfRadius: CGFloat(30))
        player.fillColor = UIColor.green
        player.position = CGPoint(x: 50, y: 50)
        addChild(player)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var t = touches.first?.location(in: self) as! CGPoint
        
        if r.contains(t){
            player.position.x+=10
            c!.sendCords(x: player.position.x, y: player.position.y)
            
        }
        else if l.contains(t){
            player.position.x-=10
            c!.sendCords(x: player.position.x, y: player.position.y)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        for p in players{
            p.removeFromParent()
        }
        players = []
        
        for i in c!.cords{
            var one = SKShapeNode(circleOfRadius: 30)
            one.position = CGPoint(x: Double(i.1)!, y: Double(i.2)!)
            one.fillColor = UIColor.red
            addChild(one)
            players.append(one)
            
        }
    }
}

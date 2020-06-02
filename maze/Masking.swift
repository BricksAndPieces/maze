//
//  Masking.swift
//  maze
//
//  Created by 64006038 on 5/27/20.
//  Copyright © 2020 90304395. All rights reserved.
//

import SpriteKit
import GameplayKit



class Masking: SKScene, SKPhysicsContactDelegate {
    struct PhysicsCategory {
      static let none      : UInt32 = 0
      static let all       : UInt32 = UInt32.max
      static let wall      : UInt32 = 0b1
      static let player       : UInt32 = 0b10
    }
    
    let player = SKShapeNode(circleOfRadius: 32)
    let cam = SKCameraNode()
    var c:Client?
    var players = [SKShapeNode]()
    var names = "HELP"
    var mazeLayout: [[Bool]]?
    let mazeGen = MazeGenerator()
    
    override func didMove(to view: SKView) {
        let tilemap = mazeGen.getMazeNode(layout: mazeLayout!)
        tilemap.setScale(1.3)
        addChild(tilemap)
        
        
        
        self.camera = cam
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        player.position = CGPoint(x: size.width/2, y: size.height/2)
        player.fillColor = SKColor.white
        player.physicsBody = SKPhysicsBody(circleOfRadius: 32)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.wall
        player.physicsBody?.collisionBitMask = PhysicsCategory.none
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.name = "player"
        addChild(player)
        
        let wall = SKShapeNode(rectOf: CGSize(width: 10, height: 200))
        wall.position = CGPoint(x: size.width/3, y: size.height/2)
        wall.fillColor = .white
        wall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: 200))
        wall.physicsBody?.isDynamic = true
        wall.physicsBody?.categoryBitMask = PhysicsCategory.wall
        wall.physicsBody?.contactTestBitMask = PhysicsCategory.player
        wall.physicsBody?.collisionBitMask = PhysicsCategory.none
        wall.name = "wall"
        //addChild(wall)
        addMasking()
        
        
        
        c!.start()
    }
    
    var mask = SKShapeNode()
    func addMasking(){
        let effect = SKEffectNode()
        effect.zPosition = 2
        addChild(effect)
        
        let width = size.width * 10
        let height = size.height * 10
        let xPos = -width/2
        let yPos = -height/2
        mask = SKShapeNode(rect: CGRect(x: xPos, y: yPos, width: width, height: height))
        mask.position = player.position
        mask.fillColor = .black
        effect.addChild(mask)
        
        let innerCircle = SKShapeNode(circleOfRadius: 36)
        innerCircle.position = CGPoint(x: 0, y: 0)
        innerCircle.fillColor = .white
        innerCircle.blendMode = .subtract
        mask.addChild(innerCircle)
        
        let startAngle = CGFloat(0.785398)
        let endAngle = CGFloat(2.35619)
        let conePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 160, startAngle: startAngle, endAngle: endAngle , clockwise: true)
        conePath.flatness = 100
        conePath.addLine(to: CGPoint(x: 0, y: 0))
        conePath.close()
        let coneShape = SKShapeNode()
        coneShape.lineWidth = 10
        coneShape.path = conePath.cgPath
        coneShape.fillColor = .white
        coneShape.position = CGPoint(x: 0, y: 0)
        coneShape.blendMode = .subtract
        mask.addChild(coneShape)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        movePlayer(location: location)
    }
    
    func movePlayer(location: CGPoint){
        let moveSpeed = (frame.size.width / 3.0)
        let moveDifference = CGPoint(x: location.x - player.position.x, y: location.y - player.position.y)
        
        //ROTATION
        var theta = CGFloat(0)
        if(location.x > player.position.x){
            if(location.y > player.position.y){
                theta = tan(moveDifference.y/moveDifference.x)
            }
            if(location.y < player.position.y){
                theta = tan(moveDifference.y/moveDifference.x) + 270
            }
        }
        if(location.x < player.position.x){
            if(location.y > player.position.y){
                theta = tan(moveDifference.y/moveDifference.x) + 90
            }
            if(location.y < player.position.y){
                theta = tan(moveDifference.y/moveDifference.x) + 180
            }
        }
        let radian = (theta * 3.141592)/180
        mask.zRotation = radian
        //END ROTATION
        
        let moveDistance = sqrt((moveDifference.x * moveDifference.x) + (moveDifference.y * moveDifference.y))
        let moveDuration = moveDistance/moveSpeed
        let moveAction = SKAction.move(to: location, duration: (TimeInterval(moveDuration)))
        let moveSequence = SKAction.sequence([moveAction, SKAction.run {self.player.removeAllActions()}])
        player.run(moveSequence)
        mask.run(moveSequence)
        c!.sendCords(x: player.position.x, y: player.position.y)
    }
    
    func playerWITHwallCollision(player: SKNode, wall: SKNode){
        player.removeAllActions()
        mask.removeAllActions()
        print("COLLISION")
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "player"{
            if nodeB.name == "wall" {
                playerWITHwallCollision(player: nodeA, wall: nodeB)
            }
        }
        if nodeA.name == "wall"{
            if nodeB.name == "player" {
                playerWITHwallCollision(player: nodeB, wall: nodeA)
            }
        }
    }
    
    override func update(_ currentTime: CFTimeInterval){
        cam.position = player.position
        
        
        
        for p in players{
            p.removeFromParent()
        }
        players = []
        
        for i in c!.cords{
            if i.0 != c!.name{
                let one = SKShapeNode(circleOfRadius: 30)
                one.position = CGPoint(x: Double(i.1)!, y: Double(i.2)!)
                one.fillColor = UIColor.red
                addChild(one)
                players.append(one)
            }
        }
    }
    
}

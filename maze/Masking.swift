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
      static let line       : UInt32 = 0b10
      static let player       : UInt32 = 0b100
    }
    
    let player = SKShapeNode(circleOfRadius: 16)
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        player.position = CGPoint(x: size.width/2, y: size.height/2)
        player.fillColor = SKColor.white
        player.physicsBody = SKPhysicsBody(circleOfRadius: 16)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.wall
        player.physicsBody?.collisionBitMask = PhysicsCategory.none
        addChild(player)

        //START MASKING
        
        let effect = SKEffectNode()
        effect.zPosition = 2
        addChild(effect)
        
        let mask = SKShapeNode(rect: CGRect(x: player.position.x + (-size.width - 10), y: player.position.y + (-size.height - 10), width: size.width + 20, height: size.height + 20))
        mask.position = CGPoint(x: size.width/2, y: size.height/2)
        mask.fillColor = .black
        effect.addChild(mask)
        
        let innerCircle = SKShapeNode(circleOfRadius: 20)
        innerCircle.position = CGPoint(x: 0, y: 0)
        innerCircle.fillColor = .white
        innerCircle.blendMode = .subtract
        mask.addChild(innerCircle)
        
        let startAngle = CGFloat(0.785398)
        let endAngle = CGFloat(2.35619)
        let conePath = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: 80, startAngle: startAngle, endAngle: endAngle , clockwise: true)
        conePath.flatness = 100
        conePath.addLine(to: CGPoint(x: 0, y: 0))
        conePath.close()
        let coneShape = SKShapeNode()
        coneShape.lineWidth = 50
        coneShape.path = conePath.cgPath
        coneShape.fillColor = .white
        coneShape.position = CGPoint(x: 0, y: 0)
        coneShape.blendMode = .subtract
        mask.addChild(coneShape)
        
        //END MASKING
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first!
        let location = touch.location(in: self)
        movePlayer(location: location)
    }
    
    func movePlayer(location: CGPoint){
        let moveSpeed = (frame.size.width / 3.0)
        let moveDifference = CGPoint(x: location.x - player.position.x, y: location.y - player.position.y)
        let moveDistance = sqrt((moveDifference.x * moveDifference.x) + (moveDifference.y * moveDifference.y))
        let moveDuration = moveDistance/moveSpeed
        let moveAction = SKAction.move(to: location, duration: (TimeInterval(moveDuration)))
        let moveSequence = SKAction.sequence([moveAction, SKAction.run {self.player.removeAllActions()}])
        player.run(moveSequence)
    }
}

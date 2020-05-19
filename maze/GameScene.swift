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
    private let mazeGen = MazeGenerator()
    
    override func didMove(to view: SKView) {
        let layout = mazeGen.generateMaze(width: wallSize, height: wallSize, centerSize: 3)
        
        for x in 0 ..< wallSize {
            for y in 0 ..< wallSize {
                let tileNum = layout[x][y] ? Int.random(in: 5...8) : Int.random(in: 1...4)
                
                let tile = SKSpriteNode(imageNamed: "tile\(tileNum)")
                tile.scale(to: CGSize(width: scale, height: scale))
                tile.position.x = CGFloat((wallSize/2-x)*scale)
                tile.position.y = CGFloat((wallSize/2-y)*scale)
                
                if layout[x][y] {
                    tile.physicsBody = SKPhysicsBody(rectangleOf: tile.size)
                }
                
                addChild(tile)
            }
        }
    }
}

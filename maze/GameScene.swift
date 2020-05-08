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
                if layout[x][y] {
                    let wall = SKShapeNode(rectOf: CGSize(width: scale, height: scale))
                    wall.position.x = CGFloat((wallSize/2-x)*scale)
                    wall.position.y = CGFloat((wallSize/2-y)*scale)
                    
                    wall.strokeColor = .white
                    wall.fillColor = .white
                    
                    addChild(wall)
                }
            }
        }
    }
}

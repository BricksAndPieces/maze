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
    private let mazeGen = MazeGenerator()
    
    override func didMove(to view: SKView) {
        let layout = mazeGen.generateMaze(width: wallSize, height: wallSize, centerSize: 3)
        let tilemap = mazeGen.getMazeNode(layout: layout)
        tilemap.setScale(0.2)
        addChild(tilemap)
    }
}

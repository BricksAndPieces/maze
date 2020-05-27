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
        let tileset = SKTileSet(named: "Maze Tile Set")!
        let pathTiles = tileset.tileGroups.first { $0.name == "Path" }
        let wallTiles = tileset.tileGroups.first { $0.name == "Wall" }
        let tileSize = CGSize(width: 128, height: 128)
        
        let tilemap = SKTileMapNode(tileSet: tileset, columns: wallSize, rows: wallSize, tileSize: tileSize)
        let layout = mazeGen.generateMaze(width: wallSize, height: wallSize, centerSize: 3)
    
        
        for x in 0 ..< wallSize {
            for y in 0 ..< wallSize {
                tilemap.setTileGroup(layout[x][y] ? wallTiles : pathTiles, forColumn: x, row: y)

                if layout[x][y] {
                    let tile = SKNode()
                    tile.position.x = CGFloat((x-wallSize/2)*128)
                    tile.position.y = CGFloat((y-wallSize/2)*128)
                    
                    tile.physicsBody = SKPhysicsBody(rectangleOf: tileSize)
                    tile.physicsBody?.affectedByGravity = false
                    tile.physicsBody?.allowsRotation = false
                    
                    tilemap.addChild(tile)
                }
            }
        }
        
        
        tilemap.setScale(0.2)
        addChild(tilemap)
    }
}

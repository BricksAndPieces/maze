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
            }
        }
        
        createTilemapCollider(tilemap: tilemap, layout: layout)
        tilemap.setScale(0.2)
        addChild(tilemap)
    }
    
    private func createTilemapCollider(tilemap: SKNode, layout: [[Bool]]) {
        var points = [(Int, Int)]()
        for y in 0 ..< layout[0].count {
            var blockSize = 0
            for x in 0 ... layout.count {
                if x < layout.count && layout[x][y]  {
                    blockSize += 1
                    if blockSize == 1 {
                        points.append((x, y))
                    }else if blockSize == 2 {
                        points.removeLast()
                    }
                }else {
                    if blockSize > 1 {
                        tilemap.addChild(createMazeColliderSegment(maze: layout, x: x, y: y, blockSize: blockSize, upDown: false))
                    }
                    
                    blockSize = 0
                }
            }
        }

        for x in 0 ..< layout.count {
            var blockSize = 0
            for y in 0 ... layout[0].count {
                if y < layout[0].count && layout[x][y] && points.contains(where: {$0.0 == x && $0.1 == y}) {
                    blockSize += 1
                }else {
                    if blockSize > 0 {
                        tilemap.addChild(createMazeColliderSegment(maze: layout, x: x, y: y, blockSize: blockSize, upDown: true))
                        blockSize = 0
                    }
                }
            }
        }
    }
    
    private func createMazeColliderSegment(maze: [[Bool]], x: Int, y: Int, blockSize: Int, upDown: Bool) -> SKNode {
        let node = SKNode()
        let hitbox: UIBezierPath
        let scale = 128/2
        
        if !upDown {
            node.position = CGPoint(x: (x-maze.count-blockSize*2)*scale, y: (y-maze[0].count)*scale)
            hitbox = UIBezierPath(rect: CGRect(x: x*scale, y: y*scale, width: scale*2*blockSize, height: scale*2))
        }else {
            node.position = CGPoint(x: (x-maze.count)*scale, y: (y-maze[0].count-blockSize*2)*scale)
            hitbox = UIBezierPath(rect: CGRect(x: x*scale, y: y*scale, width: scale*2, height: scale*2*blockSize))
        }
        
        node.physicsBody = SKPhysicsBody(edgeLoopFrom: hitbox.cgPath)
        return node
    }
}

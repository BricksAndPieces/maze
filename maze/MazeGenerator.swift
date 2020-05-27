//
//  MazeGenerator.swift
//  maze
//
//  Created by 90307332 on 5/7/20.
//  Copyright © 2020 90304395. All rights reserved.
//

import SpriteKit

class MazeGenerator {
    
    private let xDirs = [1, -1, 0, 0]
    private let yDirs = [0, 0, 1, -1]
    
    func generateMaze(width: Int, height: Int, centerSize: Int) -> [[Bool]] {
        var maze = fillMaze(width: width, height: height)
        maze = createCenter(maze: maze, centerSize: centerSize)
        maze = createPath(maze: maze, x: maze.count/2, y: maze[0].count/2-centerSize/2-1)
        return maze
    }
    
    private func createPath(maze: [[Bool]], x: Int, y: Int) -> [[Bool]] {
        var newMaze = maze
        var d = Int.random(in: 0...3)
        for _ in 0 ..< xDirs.count {
            let node1 = (x + xDirs[d], y + yDirs[d])
            let node2 = (node1.0 + xDirs[d], node1.1 + yDirs[d])
            let valid = validNode(maze: newMaze, node: node1) && validNode(maze: newMaze, node: node2)
            let blocked = valid ? newMaze[node1.0][node1.1] && newMaze[node2.0][node2.1] : false
            
            if blocked {
                newMaze[node1.0][node1.1] = false
                newMaze[node2.0][node2.1] = false
                newMaze = createPath(maze: newMaze, x: node2.0, y: node2.1)
            }
            
            d = (d+1) % 4
        }
        
        return newMaze
    }
    
    private func createCenter(maze: [[Bool]], centerSize: Int) -> [[Bool]] {
        var newMaze = maze
        for x in 0 ..< centerSize {
            for y in 0 ..< centerSize {
                newMaze[maze.count/2-centerSize/2+x][maze[x].count/2-centerSize/2+y] = false
            }
        }
        
        return newMaze
    }
    
    private func fillMaze(width: Int, height:Int) -> [[Bool]] {
        var maze = [[Bool]]()
        for _ in 0 ..< width {
            var row = [Bool]()
            for _ in 0 ..< height {
                row.append(true)
            }
            
            maze.append(row)
        }
        
        return maze
    }
    
    func validNode(maze: [[Bool]], node: (Int, Int)) -> Bool {
        return node.0 >= 0 && node.0 < maze.count && node.1 >= 0 && node.1 < maze[0].count
    }
    
    // MARK: fdfd
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- //
    
    func getMazeNode(layout: [[Bool]]) -> SKNode {
        let tileset = SKTileSet(named: "Maze Tile Set")!
        let pathTiles = tileset.tileGroups.first { $0.name == "Path" }
        let wallTiles = tileset.tileGroups.first { $0.name == "Wall" }
        let tileSize = CGSize(width: 128, height: 128)
            
        let tilemap = SKTileMapNode(tileSet: tileset, columns: layout[0].count, rows: layout.count, tileSize: tileSize)
        for x in 0 ..< layout.count {
            for y in 0 ..< layout[x].count {
                tilemap.setTileGroup(layout[x][y] ? wallTiles : pathTiles, forColumn: x, row: y)
            }
        }
            
        createTilemapCollider(tilemap: tilemap, layout: layout)
        return tilemap
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

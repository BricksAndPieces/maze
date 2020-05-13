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
                //if layout[x][y] {
//                    let wall = SKShapeNode(rectOf: CGSize(width: scale, height: scale))
//                    wall.position.x = CGFloat((wallSize/2-x)*scale)
//                    wall.position.y = CGFloat((wallSize/2-y)*scale)
//
//                    wall.strokeColor = .white
//                    wall.fillColor = .white
//
//                    addChild(wall)
                    
                if let tile = getTile(layout, x, y) {
                    let wall = SKSpriteNode(imageNamed: "tile\(tile)")
                    wall.scale(to: CGSize(width: scale, height: scale))
                    wall.position.x = CGFloat((wallSize/2-x)*scale)
                    wall.position.y = CGFloat((wallSize/2-y)*scale)
                    
                    addChild(wall)
                }
                    

                //}
            }
        }
    }
    
    private func getTile(_ layout: [[Bool]], _ x: Int, _ y: Int) -> Int? {
        
        let up = mazeGen.validNode(maze: layout, node: (x, y-1)) ? true : layout[x][y-1]
        let down = mazeGen.validNode(maze: layout, node: (x, y+1)) ? true : layout[x][y+1]
        let left = mazeGen.validNode(maze: layout, node: (x-1, y)) ? true : layout[x-1][y]
        let right = mazeGen.validNode(maze: layout, node: (x+1, y)) ? true : layout[x+1][y]
        let upRight = mazeGen.validNode(maze: layout, node: (x+1, y-1)) ? true : layout[x+1][y-1]
        let upLeft = mazeGen.validNode(maze: layout, node: (x-1, y-1)) ? true : layout[x-1][y-1]
        let downRight = mazeGen.validNode(maze: layout, node: (x+1, y+1)) ? true : layout[x+1][y+1]
        let downLeft = mazeGen.validNode(maze: layout, node: (x-1, y+1)) ? true : layout[x-1][y+1]
        
        if(!layout[x][y] && !up && !down && !left && !right && !upRight && !upLeft && !downRight && !downLeft) {
            return Int.random(in: 1...4)
        }
        
        if(layout[x][y] && !up && !down && !left && !right && !upRight && !upLeft && !downRight && !downLeft) {
            return Int.random(in: 1...4)
        }
        
        return nil
    }
}

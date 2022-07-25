//
//  ParticlePool.swift
//  penguin
//
//  Created by Gp on 7/21/22.
//

import SpriteKit

class ParticlePool {
    var cratePool: [SKEmitterNode] = []
    var heartPool: [SKEmitterNode] = []
    var crateIndex = 0
    var heartIndex = 0
    
    var gameScene = SKScene()
    
    init() {
        // create 5 crate explosion emitter nodes
        
        for i in 1...5 {
            let crate = SKEmitterNode(fileNamed: "CrateExplosion")!
            crate.position = CGPoint(x: -2000, y: -2000)
            crate.zPosition = CGFloat(45 - i)
            crate.name = "crate" + String(i)
            cratePool.append(crate)
        }
        
        // Repeat for other pools
        for i in 1...1 {
            let heart = SKEmitterNode(fileNamed: "HeartExplosion")!
            heart.position = CGPoint(x: -2000, y: -2000)
            heart.zPosition = CGFloat(45 - i)
            heart.name = "crate" + String(i)
            heartPool.append(heart)
            
        }
    }
        
        // Call the GameScene to add emitter as children
    func addEmittersToScene(scene: GameScene) {
        self.gameScene = scene
        // Add the crate emitters to the scene:
        for i in 0..<cratePool.count {
            self.gameScene.addChild(cratePool[i])
        }
       // Add the heart emitters to the scene:
        for i in 0..<heartPool.count {
            self.gameScene.addChild(heartPool[i])
        }
    }
        
        // Function to reposition the next pooled node into the desired position
   func placeEmitter(node: SKNode, emitterType: String) {
   // Pull an emitter node from the correct pool
       var emitter: SKEmitterNode
            
       switch emitterType {
            case "crate":
                emitter = cratePool[crateIndex]
                // Keep track of the next node to pull
                crateIndex += 1
                crateIndex = crateIndex % cratePool.count
            case "heart":
                emitter = heartPool[heartIndex]
                heartIndex += 1
                heartIndex = heartIndex % heartPool.count
            default:
                return
            }
            
            // find the node's position relative to gameScene
        var absolutePosition = node.position
            
        if node.parent != gameScene {
            absolutePosition = gameScene.convert(node.position, from: node.parent!)
        }
            
            // position the emitter on top of the node
        emitter.position = absolutePosition
            
            // restart the emitter animation
        emitter.resetSimulation()
        }
}

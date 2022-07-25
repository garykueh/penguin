//
//  EncounterManager.swift
//  penguin
//
//  Created by Gp on 7/7/22.
//

import SpriteKit

class EncounterManager {
    // Store your counter file name
    let encounterNames:[String] = [
        "EncounterA",
        "EncounterB",
        "EncounterC"
    ]
    
    // Each encounter is an SKNode, store an array
    var encounters:[SKNode] = []
    var currentEncounterIndex: Int?
    var previousEncounterIndex: Int?

    init() {
        // Loop through each enter scene
        for encounterFileName in encounterNames {
            // create a new node for the encounter:
            let encounterNode = SKNode()
            
            // Load this scene file into a SKScene instance:
            if let encounterScene = SKScene(fileNamed: encounterFileName) {
                // Loop through each child node in SKScene
                for child in encounterScene.children {
                    // create a copy of the schene's child node
                    // to add to our encountr node:
                    let copyOfNode = type(of: child).init()
                    // Save the scene node's position and name to the copy
                    copyOfNode.position = child.position
                    copyOfNode.name = child.name
                    // add the copy to our encounter node
                    encounterNode.addChild(copyOfNode)
                }
            }
            // Add the populated encounter node to the array
            encounters.append(encounterNode)
            // save initial sprite positions for this encounter
            saveSpritePositions(node: encounterNode)
            // Turn golden coins into gold
            
            encounterNode.enumerateChildNodes(withName: "gold") {
                (node: SKNode, stop: UnsafeMutablePointer) in (node as? Coin)?.turnToGold()
            }
             
        }
    }
    
    
    
    
    // Store the initial positions of the children of a node
    func saveSpritePositions(node: SKNode) {
        for sprite in node.children {
            if let spriteNode = sprite as? SKSpriteNode {
                let initialPositionvalue = NSValue.init(cgPoint: sprite.position)
                spriteNode.userData = ["initialPosition": initialPositionvalue]
                // save the positions for children of this node
                saveSpritePositions(node: spriteNode)
            }
        }
    }
    
    // reset all children nodes to their original position
    func resetSpritePositions(node: SKNode) {
        for sprite in node.children {
            if let spriteNode = sprite as? SKSpriteNode {
                // remove any linear or angular velocity
                spriteNode.physicsBody?.velocity = CGVector(dx:0, dy: 0)
                spriteNode.physicsBody?.angularVelocity = 0
                // reset the rotation of the sprite
                spriteNode.zRotation = 0
                
                // if this is a crate, call the reset function
                if let crateTest = spriteNode as? Crate {
                    crateTest.reset()
                }
                if let initialPositionVal = spriteNode.userData?.value(forKey: "initialPosition") as? NSValue {
                    // reset the position of the sprite
                    spriteNode.position = initialPositionVal.cgPointValue
                }
                // reset positions on this node's children
                resetSpritePositions(node: spriteNode)
            }
        }
    }
    
    // We will call this addEncountersToScene function from
        // the GameScene to append all of the encounter nodes to the
        // world node from our GameScene:
    func addEncounterToScene(gameScene:SKNode) {
        var encounterPosY = 1000
        for encounterNode in encounters {
            //print(encounterNode.position)

            // Spawn the encounters behind the action with
            // increasing height so they do not collide
            encounterNode.position = CGPoint(x: -2000, y:encounterPosY)
            gameScene.addChild(encounterNode)
            // Double the y pos for the next encounter
            encounterPosY = encounterPosY * 2
    }
}
    
    func placeNextEncounter(currentXPos: CGFloat) {
        // count the encounters in a random ready type (Uint32)
        let encounterCount = UInt32(encounters.count)
        // the game requires at least 3 encounters to function
        // so exit this function of there are less than 3
        if encounterCount < 3 {
            return
        }
        
        /*
         We need tp pick an encounter that is not
         currently displayed on the screen
         */
        
        var nextEncounterIndex: Int?
        var trulyNew: Bool?
        
        /*
         the current encounter and the directly previous encounter
         can potentially be on the screen at this time.
         Pick until we get a new encounter
         */
        
        while trulyNew == false || trulyNew == nil {
            // pick a random encounter to set next
            nextEncounterIndex = Int(arc4random_uniform(encounterCount))
            // first assert that this is a new encounter
            trulyNew = true
            // test if it is instead the current encounter
            if let currentIndex = currentEncounterIndex {
                if (nextEncounterIndex == currentIndex) {
                    trulyNew = false
                }
            }
            // test if it is the directly previous encounter
            if let previousIndex = previousEncounterIndex {
                if (nextEncounterIndex == previousIndex) {
                    trulyNew = false
                }
            }
        }
        
        // keep track of the current encounter
        previousEncounterIndex = currentEncounterIndex
        currentEncounterIndex = nextEncounterIndex
        // reset te new encounter and position it ahead of the player
        let encounter = encounters[currentEncounterIndex!]
        encounter.position = CGPoint(x: currentXPos + 1000, y: 300)
       // resetSpritePositions(node: encounter)
        
    }
     
    
}

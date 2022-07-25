//
//  Crate.swift
//  penguin
//
//  Created by Gp on 7/21/22.
//

import SpriteKit

class Crate: SKSpriteNode, GameSprite {
    var initialSize = CGSize(width: 40, height: 40)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var givesHeart = false
    var exploded = false
    
    init() {
        super.init(texture: nil, color: UIColor.clear, size: initialSize)
        self.physicsBody = SKPhysicsBody(rectangleOf: initialSize)
        
        // Only collide with ground and other crates
        self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue |
                                            PhysicsCategory.crate.rawValue
        self.physicsBody?.categoryBitMask = PhysicsCategory.crate.rawValue
        self.texture = textureAtlas.textureNamed("crate")
    }
    
    
  
    // A function that gives health
    func turnToHeartCreate() {
        self.physicsBody?.affectedByGravity = false
        self.texture = textureAtlas.textureNamed("crate-power-up")
        givesHeart = true
    }
    
    // Function for exploding crates
    func explode(gameScene: GameScene) {
        // Do not do anything if already exploded
        if exploded {
            //print("Exploded")
            return
        }
        
        // Prevent additional contact
        self.physicsBody?.categoryBitMask = 0
        
        // Place a crate explosion at this location
        gameScene.particlePool.placeEmitter(node: self, emitterType: "crate")
        
        // fade out the crate sprite
        self.run(SKAction.fadeAlpha(to: 0, duration: 0.1))
        
        if (givesHeart) {
            // this is a heart crate, award a health point
            let newHealth = gameScene.player.health + 1
            let maxHealth = gameScene.player.maxHealth
            gameScene.player.health = newHealth > maxHealth ? maxHealth : newHealth
            
            gameScene.hud.setHealthDisplay(newHealth: gameScene.player.health)
            
            // Place a heart location at this location
            gameScene.particlePool.placeEmitter(node: self, emitterType: "heart")
        } else {
            // otherwise reward the player with coins
            gameScene.coinsCollected += 1
            gameScene.hud.setCoinDisplay(newCoinCount: gameScene.coinsCollected)
        }
        // prevent additional contacts
        self.physicsBody?.categoryBitMask = 0
    }
    
    // Function to reset the crate for re-use
    func reset() {
        self.alpha = 1
        self.physicsBody?.categoryBitMask = PhysicsCategory.crate.rawValue
        exploded = false
        
        // Place the crate explosion
    }
    
    func onTap() {}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
     
}

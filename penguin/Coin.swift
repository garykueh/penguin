//
//  Coin.swift
//  penguin
//
//  Created by Gp on 7/6/22.
//


import SpriteKit

// Inherits SKSSpriteNode, adopts GameSprite protocol
class Coin: SKSpriteNode, GameSprite {
    // store size, texture atlas. animation as class wide properties
    var initialSize  = CGSize(width: 26, height: 26)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var value = 1
    
    let coinSound = SKAction.playSoundFileNamed("Sound/Coin.aif", waitForCompletion: false)
    
    init() {
        let bronzeTexture = textureAtlas.textureNamed("coin-bronze")
        super.init(texture: bronzeTexture, color: .clear, size: initialSize)
        
        // create an run the flying animation
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        self.physicsBody?.affectedByGravity =  false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        self.physicsBody?.collisionBitMask = 0
    }
    
    // A function to transform this coin into gold
    func turnToGold() {
        self.texture = textureAtlas.textureNamed("coin-gold")
        self.value = 5
    }
    
    func collect() {
        // prevent furthur contact
        self.physicsBody?.categoryBitMask = 0
        // Fade pit, move up, and scale the coin
        let collectAnimation = SKAction.group(
            [SKAction.fadeAlpha(to: 1.5, duration: 0.2),
             SKAction.scale(to: 1.5, duration: 0.2),
             SKAction.move(by: CGVector(dx: 0, dy: 25), duration: 0.2),
            ])
        // After fading, move the coin out of the way and reset it to initial value
        let resetAfterCollected = SKAction.run {
            self.position.y = 5000
            self.alpha = 1
            self.xScale = 1
            self.yScale = 1
            self.physicsBody?.categoryBitMask = PhysicsCategory.coin.rawValue
        }
        let collectSequence = SKAction.sequence([
            collectAnimation,
            resetAfterCollected
            ])
        self.run(collectSequence)
        // play the coin sound
        self.run(coinSound)
        
    }
    //? provided by XCode
    // Lastly, we are required to add this bit of boilerplate
    // to subclass SKSpriteNode. We will need to do this any
    // time we inherit from SKSpriteNode and use an init function
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    // onTap is not wired up yet, but we have to implement this
    // function to conform to our GameSprite protocol.
    // We will explore touch events in the next chapter.
    func onTap() {}
   
    
    func update() {
    }
    
}

//
//  Star.swift
//  penguin
//
//  Created by Gp on 7/6/22.
//

import SpriteKit

// Inherits SKSSpriteNode (why?), adopts GameSprite protocol
class Star: SKSpriteNode, GameSprite {
    // store size, texture atlas. animation as class wide properties
    var initialSize = CGSize(width: 40, height: 38)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    var pulseAnimation = SKAction()
    
    init() {
        let starTexture = textureAtlas.textureNamed("star")
        super.init(texture: starTexture, color: .clear, size: initialSize)
        
        // create an run the flying animation
        createAnimation()
        self.run(pulseAnimation)
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        self.physicsBody?.affectedByGravity =  false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.powerup.rawValue
    
    }
    
    func createAnimation() {
        // Scale the star and fade it
        let pulseOutGroup = SKAction.group([
            SKAction.fadeAlpha(to: 0.85, duration: 0.8),
            SKAction.scale(to: 0.6, duration: 1.5),
            SKAction.rotate(byAngle: -0.3, duration: 0.8)
            ])
        // push the star big again, fade it back in
        let pulseInGroup = SKAction.group([
            SKAction.fadeAlpha(to: 1, duration: 1.5),
            SKAction.scale(to: 1, duration: 1.5),
            SKAction.rotate(byAngle: 3.5, duration: 1.5)
            ])
            
        let pulseSequence = SKAction.sequence([pulseOutGroup, pulseInGroup])
        pulseAnimation = SKAction.repeatForever(pulseSequence)
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
    func onTap() {
    }
        
    // boiler-plate code from player.swift

}

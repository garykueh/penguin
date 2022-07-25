//
//  Bat.swift
//  penguin
//
//  Created by Gp on 7/6/22.
//

import SpriteKit

// Inherits SKSSpriteNode, adopts GameSprite protocol
class Bat: SKSpriteNode, GameSprite {
    // store size, texture atlas. animation as class wide properties
    var initialSize = CGSize(width: 44, height: 24)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    init() {
        // Call the init function on the base class (SKSpriteNode)
        // We will pass nil for the texture since we will animate the texture ourselves
        super.init(texture: nil, color: .clear, size: initialSize)
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        self.physicsBody?.affectedByGravity = false
        
        // create an run the flying animation
        createAnimations()
        // If we run an action with a key, "flapAnimation",
                // we can later reference that
                // key to remove the action.
        self.run(flyAnimation)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.enemy.rawValue
        self.physicsBody?.collisionBitMask = ~PhysicsCategory.damagedPenguin.rawValue
        
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
     

    func createAnimations() {
        // Find our news bee texture atlas
        let flyFrames:[SKTexture] = [
            textureAtlas.textureNamed("bat"),
            textureAtlas.textureNamed("bat-fly")
            ]
        
        // create SKAction to animate between the frames once
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.12)
        flyAnimation =  SKAction.repeatForever(flyAction)
    }
}

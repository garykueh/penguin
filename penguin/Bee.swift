//
//  Bee.swift
//  penguin
//
//  Created by Gp on 7/1/22.
//

import SpriteKit

// Inherits SKSSpriteNode (why?), adopts GameSprite protocol
class Bee: SKSpriteNode, GameSprite {
    // store size, texture atlas. animation as class wide properties
    var initialSize: CGSize = CGSize(width: 28, height: 24)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Enemies")
    var flyAnimation = SKAction()
    
    init() {
        // Call the init function on the base class (SKSpriteNode)
        // We will pass nil for the texture since we will animate the texture ourselves
        super.init(texture: nil, color: .clear, size: initialSize)
        
        // create an run the flying animation
        createAnimation()
        self.run(flyAnimation)
        // makes bee drop
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        self.physicsBody?.affectedByGravity =  false
        
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
    func onTap() {
        self.xScale = 4
        self.yScale = 4
    }
        
    // refactored from code in function addTheFlyingBee() in GameScene from ch2
    func createAnimation() {
        // Find our news bee texture atlas
        let beeFrames:[SKTexture] = [
            textureAtlas.textureNamed("bee"),
            textureAtlas.textureNamed("bee-fly")]
                
                // create SKAction to animate between the frames once
        let flyAction = SKAction.animate(with: beeFrames, timePerFrame: 0.14)
            // ch2 code: let beeAction = SKAction.repeatForever(flyAction)
        flyAnimation =  SKAction.repeatForever(flyAction)
    
        /*
         from ch2
        bee.run(beeAction)
                
                // set up the new actions to move our bee back and forth
                let pathLeft = SKAction.moveBy(x: -200, y: -10, duration: 2)
                let pathRight = SKAction.moveBy(x: 200, y: 10, duration: 2)
                let flipTextureNegative = SKAction.scaleX(to: -1, duration: 0)
                let flipTexturePositive = SKAction.scaleX(to: 1, duration: 0)
                
                //combine actions into a cohesive flight sequence
                let flightOfTheBee = SKAction.sequence( [pathLeft, flipTextureNegative, pathRight, flipTexturePositive])
                let neverEndingFlight = SKAction.repeatForever(flightOfTheBee)
                bee.run(neverEndingFlight)
        
        */
    }
}

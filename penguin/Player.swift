//
//  Player.swift
//  penguin
//
//  Created by Gp on 7/3/22.
//

import SpriteKit

// Inherits SKSSpriteNode, adopts GameSprite protocol
class Player: SKSpriteNode, GameSprite {
    // store size, texture atlas. animation as class wide properties
    var initialSize: CGSize = CGSize(width: 64, height: 64)
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Pierre")
    var flyAnimation = SKAction()
    var soarAnimation = SKAction()
    
    // store whether we are flapping our wings or in free-fall:
    var flapping = false
    // set a maximum upward force
    let maxFlappingForce: CGFloat = 57000
    // Penguin should slow down when he floes too high:
    let maxHeight: CGFloat = 1000
    
   // The player will be able to take 3 hits before game over:
    var health: Int = 3
    // Keep track of when the player is invulnerable:
    var invulnerable = false
    // Keep track of when the player is newly damaged:
    var damaged = false
    // We will create animations to run when the player takes
    // damage or dies. Add these properties to store them:
    var damageAnimation = SKAction()
    var dieAnimation = SKAction()
    // We want to stop forward velocity if the player dies,
    // so we will now store forward velocity as a property:
    var forwardVelocity: CGFloat = 200

    let powerupSound = SKAction.playSoundFileNamed("Sound/Powerup.aif", waitForCompletion: false)
    let hurtSound = SKAction.playSoundFileNamed("Sound/Hurt.aif", waitForCompletion: false)

    var Health:Int = 3
    let maxHealth = 3
    
    init() {
        // Call the init function on the base class (SKSpriteNode)
        // We will pass nil for the texture since we will animate the texture ourselves
        super.init(texture: nil, color: .clear, size: initialSize)
        
        // create an run the flying animation
        createAnimations()
        // If we run an action with a key, "flapAnimation",
                // we can later reference that
                // key to remove the action.
        //self.run(flyAnimation, withKey: "flapAnimation")
        self.run(soarAnimation, withKey: "soarAnimation")
        
        // Create a physics body based on one frame of Pierre's animation.
           // We will use the third frame, when his wings are tucked in,
           // and use the size from the spawn function's parameters:
        let bodyTexture = textureAtlas.textureNamed("pierre-flying-3.png")
        self.physicsBody = SKPhysicsBody(texture: bodyTexture, size: self.size)
        // Pierre will lose momentum quickly with a high linearDamping:
        self.physicsBody?.linearDamping = 0.9
        // Adult penguins weigh around 30kg:
        self.physicsBody?.mass = 30
        // don't let him rotate. If he rotates to will be faced down
        self.physicsBody?.allowsRotation = false
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
        self.physicsBody?.contactTestBitMask =
            PhysicsCategory.enemy.rawValue |
            PhysicsCategory.ground.rawValue |
            PhysicsCategory.ground.rawValue |
            PhysicsCategory.powerup.rawValue |
            PhysicsCategory.coin.rawValue |
            PhysicsCategory.crate.rawValue
        
        self.physicsBody?.collisionBitMask = PhysicsCategory.ground.rawValue
        
        // when game starts, make player not fall to the ground immediately
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.velocity.dy = 0
        
        // Create SKAction to start the gravity after a small delay
        let startGravitySequence = SKAction.sequence([
            SKAction.wait(forDuration: 0.6),
            SKAction.run { self.physicsBody?.affectedByGravity = true}
            ])
        self.run(startGravitySequence)
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
    
    func startFlapping() {
        if self.health <= 0 { return }
        
        self.removeAction(forKey: "soarAnimation")
        self.run(flyAnimation, withKey: "flapAnimation")
        self.flapping = true
    }
    
    func stopFlapping() {
        if self.health <= 0 { return }

        self.removeAction(forKey: "flapAnimation")
        self.run(soarAnimation, withKey: "soarAnimation")
        self.flapping = false
    }
    
    func die() {
        // Make sure player is fully visible
        self.alpha = 1
        // remove all animations
        self.removeAllActions()
        self.run(dieAnimation)
        self.flapping = false
        self.forwardVelocity = 0
        
        // Alert the GameScene
        if let gameScene = self.parent as? GameScene {
            gameScene.gameOver()
        }
    }
    
    func takeDamage() {
        //if invulnerable or damaged, return
        if self.invulnerable || self.damaged { return }
        
        self.damaged = true
        self.health = self.health - 1
        if self.health == 0 {
            die()
        }
        else {
            self.run(damageAnimation)
        }
        self.run(hurtSound)
    }
    
    func starPower() {
        // Remove any existing star power-up animation, if
        // the player is already under the power of star
        self.removeAction(forKey: "starPower")
        // Grant great forward speed
        self.forwardVelocity = 400
        // Make the player invulnerable
        self.invulnerable = true
        // Create a sequence to scale the player larger,
        // wait 8 seconds, then scale back down and turn off
        // invulnerability, returning the player to normal:
        let starSequence = SKAction.sequence([
            SKAction.scale(to: 1.5, duration: 0.3),
            SKAction.wait(forDuration: 8),
            SKAction.scale(to: 1, duration: 1),
            SKAction.run {
                self.forwardVelocity = 200
                self.invulnerable = false
            }
            ])
            // Execute the sequence:
        self.run(starSequence, withKey: "starPower")
        self.run(powerupSound)
    }

    
    func update() {
        // if flapping, apply a enw force to push penguin higher
        
        if self.flapping {
            var forceToApply = maxFlappingForce
            
            // Apply less force if Penguin is above position 600
            if position.y > 600 {
                // the higher the penguin moves, the more force we remove
                let percentageOfMaxHeight = position.y / maxHeight
                let flappingForceSubtraction = percentageOfMaxHeight * maxFlappingForce
                forceToApply = forceToApply - flappingForceSubtraction
            }
            // Apply the final force:
            self.physicsBody?.applyForce(CGVector(dx: 0, dy: forceToApply))
            
            // limit penguin top speed as he climbs the y-axis
            // this prevents him from gaining enough momentum to shoot
            // over our max height. We pend the physics for gameplay:
            if self.physicsBody!.velocity.dy > 300 {
                self.physicsBody!.velocity.dy = 300
            }
        }
        
        // Set a constant velocity to the right:
        self.physicsBody?.velocity.dx = self.forwardVelocity
        
        

    }
     

    func createAnimations() {
        // Find our news bee texture atlas
        let flyFrames:[SKTexture] = [
            textureAtlas.textureNamed("pierre-flying-1"),
            textureAtlas.textureNamed("pierre-flying-2"),
            textureAtlas.textureNamed("pierre-flying-3"),
            textureAtlas.textureNamed("pierre-flying-4"),
            textureAtlas.textureNamed("pierre-flying-3"),
            textureAtlas.textureNamed("pierre-flying-2")
            ]
        
                // create SKAction to animate between the frames once
        let flyAction = SKAction.animate(with: flyFrames, timePerFrame: 0.03)
        
        let rotateUpAction = SKAction.rotate(toAngle: 0, duration: 0.475)
        rotateUpAction.timingMode = .easeOut
       
        flyAnimation =  SKAction.group([
            SKAction.repeatForever(flyAction),
            rotateUpAction
            ])
        let soarFrames:[SKTexture] =   [
            textureAtlas.textureNamed("pierre-flying-1")]
        let soarAction = SKAction.animate(with: soarFrames,
                       timePerFrame: 1)
        //Group soarFrame with rotateDown
        
        let rotateDownAction = SKAction.rotate(toAngle: -1, duration: 0.8)
        rotateDownAction.timingMode = .easeIn
        
        soarAnimation =  SKAction.group([
            SKAction.repeatForever(soarAction),
            rotateDownAction
            ])
        
        // --- Create the taking damage animation
        let damageStart = SKAction.run {
            // Allow the penguin to pass through enemies
            self.physicsBody?.categoryBitMask = PhysicsCategory.damagedPenguin.rawValue
        }
        // create an pacity pulse, slow at first then fast at the end
        let slowFade = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.35),
            SKAction.fadeAlpha(to: 0.7, duration: 0.35)
            ])
        let fastFade = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.3, duration: 0.2),
            SKAction.fadeAlpha(to: 0.7, duration: 0.2)
            ])
        let fadeOutAndIn = SKAction.sequence([
            SKAction.repeat(slowFade, count: 2),
            SKAction.repeat(fastFade, count: 5),
            SKAction.fadeAlpha(to: 1, duration: 0.15)
            ])
        // return the penguin to normal
        let damageEnd = SKAction.run {
            self.physicsBody?.categoryBitMask = PhysicsCategory.penguin.rawValue
            self.damaged = false
        }
        // Store the whole sequence in damageAnimation property
        damageAnimation = SKAction.sequence([
            damageStart, fadeOutAndIn, damageEnd
            ])
        
        // --- create the death animation
        let startDie = SKAction.run {
            // Switch to the dead penguin texture
            self.texture = self.textureAtlas.textureNamed("pierre-dead")
            // Suspend the penguin in space
            self.physicsBody?.affectedByGravity = false
            // Stop any movement
            self.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
        
        let endDie = SKAction.run {
            // turn gravity back on
            self.physicsBody?.affectedByGravity = true
        }
        
        self.dieAnimation = SKAction.sequence([
            startDie,
            SKAction.scale(to: 1.3, duration: 0.5),
            SKAction.wait(forDuration: 0.5),
            // rotate penguin on back
            SKAction.rotate(toAngle: 3, duration: 1.5),
            SKAction.wait(forDuration: 0.5),
            endDie
            ])
        
    }
}

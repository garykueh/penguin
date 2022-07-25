//
//  GameScene.swift
//  penguin
//
//  Created by Gp on 6/25/22.
//

import SpriteKit
import GameplayKit

enum PhysicsCategory: UInt32 {
    case penguin = 1
    case damagedPenguin = 2
    case ground = 4
    case enemy = 8
    case coin = 16
    case powerup = 32
    case crate = 64
}


class GameScene: SKScene, SKPhysicsContactDelegate {
    //let world = SKScene()
    // create a constant cam as a SKCameraNode
    let cam = SKCameraNode()
    //let bee = SKSpriteNode()
    // bee will be created from encounterManager
    let ground = Ground()
    let player = Player()
    
    // Zoom into as penguin flies higher
    // lower the ground
    var screenCenterY = CGFloat()
    
    let initialPlayerPosition = CGPoint(x: 150, y:250)
    var playerProgress = CGFloat()
    let encounterManager = EncounterManager()
    
    var nextEncounterSpawnPosition = CGFloat(150)
    
    var powerUpStar = Star()
    var coinsCollected = 0
    
    let hud = HUD()
    
    var backgrounds: [Background] = []
    
    let particlePool = ParticlePool()
    let heartCrate = Crate()
    
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6,
                                       blue: 0.95, alpha: 1.0)
        
        // store the vertical center of the screen
        screenCenterY = self.size.height / 2
        
        // assign the camera to the scene
        self.camera = cam
        
        // size and position the ground based on the screen size.
        // Position X: Negative one screen width.
        // Position Y: 150 above the bottom (remember the ground's top
        // left anchor point).
        ground.position = CGPoint(x: -self.size.width*2, y: 30)
        // Width: 3x the width of the screen.
        // Height: 0. Our child nodes will provide the height.
        ground.size = CGSize(width: self.size.width*6, height: 0)
        // Run the ground's createChildren function to build
                // the child texture tiles
        ground.createChildren()
        self.addChild(ground)
        
        //Add the player to the scene
        //player.position = CGPoint(x: 150, y:250)
        player.position = initialPlayerPosition
        self.addChild(player)
        
        //set gravity
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -5)
        
        encounterManager.addEncounterToScene(gameScene: self)
        //encounterManager.encounters[0].position = CGPoint(x: 400, y:330 )
        self.physicsWorld.contactDelegate = self
        
        // Place the star out of the way for now
        self.addChild(powerUpStar)
        powerUpStar.position = CGPoint(x: -2000, y: -2000)
        //powerUpStar.position = CGPoint(x: 200, y: 200)

        // let bat = Bat()
              //bat.position = CGPoint(x: 200, y: 200)
        
        // Add the camera itself to the scene's node tree
        self.addChild(self.camera!)
        // position the camera node above te game elements
        self.camera!.zPosition = 50
        // create the HID's child nodes
        hud.createHudNode(screenSize: self.size)
        // Add the HUD to the camera's node tree
        self.camera!.addChild(hud)
        
        // instantiate three backgrounds to the background appear
        
        for _ in 0..<3 {
            backgrounds.append(Background())
        }
        // Spawn the new backgrounds
        backgrounds[0].spawn(parentNode: self,
                             imageName: "background-front",
                             zPosition: -5,
                             movementMultiplier: 0.75)
        backgrounds[1].spawn(parentNode: self,
                             imageName: "background-middle",
                             zPosition: -10,
                             movementMultiplier: 0.5)
        backgrounds[2].spawn(parentNode: self,
                             imageName: "background-back",
                             zPosition: -15,
                             movementMultiplier: 0.2)
        
        // play the start sound
        self.run(SKAction.playSoundFileNamed("Sound/StartGame.aif", waitForCompletion: false))
        
        // Add emitter nodes to GameScene node tree
        particlePool.addEmittersToScene(scene: self)
        
        // spawn the heart crate, out of the way for now
        self.addChild(heartCrate)
        heartCrate.position = CGPoint(x: -2100, y: -2100)
        heartCrate.turnToHeartCreate()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        /* Each contact has two bodies. We do not know which is which.
         We will find the penguin body first, then use the other body to determine the type of contact.
         */
        let otherBody: SKPhysicsBody
        let penguinMask = PhysicsCategory.penguin.rawValue | PhysicsCategory.damagedPenguin.rawValue
        /* use the bitwie & to find the penguin. This returns a positive numnber
         if body's A category is the same as either the penguin or the damaged penguin
         */
        
        if (contact.bodyA.categoryBitMask & penguinMask > 0) {
            // bodyA is the penguin, we will tet bodyB's tyoe
            otherBody = contact.bodyB
        }
        else {
            // bodyB is the penguin, we will rtest bodyA's type
            otherBody = contact.bodyA
        }
        // find the type of contacts
        switch otherBody.categoryBitMask {
            case PhysicsCategory.ground.rawValue:
                //print("hit ground")
                player.takeDamage()
                hud.setHealthDisplay(newHealth: player.health)
            case PhysicsCategory.enemy.rawValue:
                //print("take damage")
                player.takeDamage()
                hud.setHealthDisplay(newHealth: player.health)

            case PhysicsCategory.coin.rawValue:
                //print("Collect coin")
                // Try to cast the otherBody's node as a Coin
                if let coin = otherBody.node as? Coin {
                    coin.collect()
                    self.coinsCollected = self.coinsCollected + coin.value
                    //print(self.coinsCollected)
                    hud.setCoinDisplay(newCoinCount: self.coinsCollected)
                }
            case PhysicsCategory.powerup.rawValue:
                //print("Start the power-up")
                player.starPower()
            case PhysicsCategory.crate.rawValue:
                //print("Hit crate")
                if let crate = otherBody.node as? Crate {
                    crate.explode(gameScene: self)
                }
            default:
                print("contact with no game logic")
        }
        
        // Instantiate a SKEmitterNode with the PenguinOath design
        if let dotEmitter = SKEmitterNode(fileNamed: "PenguinPath") {
            // position the penguin in front of other game objects
            player.zPosition = 10
            // place the particle zPosition behind the penguin
            dotEmitter.particleZPosition = -1
            // By adding the emitter node to the player, the emitter moves with
            // the penguin and emits new dots wherever the player is
            
            player.addChild(dotEmitter)
            
            // however the particle themselves should target the scene
            // so they trail behind as the player moves forward
            dotEmitter.targetNode = self
            
            
        }
        
        
    }
    
    func gameOver() {
        hud.showButtons()
    }
 
    override func didSimulatePhysics() {
        // Keep the camera centered on the bee
        // Notice the ! operator after camera. SKScene's camera
        // is an optional, but we know it is there since we
        // assigned it above in the didMove function. We can tell
        // Swift that we know it can unwrap this value by using
        // the ! operator after the property name.
        
        //var cameraYPos: CGFloat = 0
        // this moves the ground to fill less of screen. Why?
        var cameraYPos = screenCenterY
        //print(screenCenterY)  -> 332.0
        cam.yScale = 1
        cam.xScale = 1
        
        // Zoom the world as the penguin flies higher
        // Follow the player up if higher than half the screen:
        if (player.position.y > screenCenterY) {
            cameraYPos = player.position.y
            // Scale the camera as they go higher:
            let percentOfMaxHeight = (player.position.y - screenCenterY) /
                (player.maxHeight - screenCenterY)
            let newScale = 1 + percentOfMaxHeight
            cam.yScale = newScale
            cam.xScale = newScale
        }
        
        //self.camera!.position = player.position
        // move the cmaera for yoru new adjustment
        self.camera!.position = CGPoint(x: player.position.x, y: cameraYPos)

        // Keep track of how far the player has flown
        playerProgress = player.position.x - initialPlayerPosition.x
        
        // check to see if the ground should jump forward:
        ground.checkForReposition(playerProgress: playerProgress)
        
        // check to see if we should set a new encounter
        if player.position.x > nextEncounterSpawnPosition {
            encounterManager.placeNextEncounter(currentXPos: nextEncounterSpawnPosition)
            nextEncounterSpawnPosition = nextEncounterSpawnPosition + 1200
        }
        
        // Each encounter has an x% chance to spawn a star
        //let starRoll = Int(arc4random_uniform(10))
        //let starRoll = 0
        let starRoll = Int(arc4random_uniform(10))

        if starRoll == 0 {
            // only move the star if it is off the screen
            if abs(player.position.x - powerUpStar.position.x) > 1200 {
                // Y position 50-450:
                //let randomYPos = 50 + CGFloat(arc4random_uniform(400))
                let randomYPos = 50 + CGFloat(arc4random_uniform(200))
                powerUpStar.position = CGPoint(x: nextEncounterSpawnPosition, y: randomYPos)
                //remove any previous velocity and spin
                powerUpStar.physicsBody?.angularVelocity = 0
                powerUpStar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            }
        }
        if starRoll == 1 {
            // position the heart crate after this encounter
            heartCrate.reset()
            heartCrate.position = CGPoint(x: nextEncounterSpawnPosition - 600, y: 270 )
        }
        
        // position the backgrounds
      
        for background in self.backgrounds {
            background.updatePosition(playerProgress: playerProgress)
        }
       
    }
    
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            // find the location of the touch
            
            let location = touch.location(in: self)
            // locate the node at this location
            let nodeTouched = atPoint(location)
            // attempt tp downcast the node to the GameSprite protocl
            if let gameSprite = nodeTouched as? GameSprite {
                // if this node adheres to GameSprite, call onTap
                gameSprite.onTap()
            }
            
            // check for HUD button
            if nodeTouched.name == "restartGame" {
                // transition to a new version of the GameScene
                // to restart the game
                self.view?.presentScene(GameScene(size: self.size),
                                        transition: .crossFade(withDuration: 0.6))
            }
            else if nodeTouched.name == "returnToMenu" {
                self.view?.presentScene(MenuScene(size: self.size),
                                        transition: .crossFade(withDuration: 0.6))
            }
        }
        player.startFlapping()

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        player.stopFlapping()
    }
    
    override func update(_ currentTime: TimeInterval) {
        player.update()
    }
}

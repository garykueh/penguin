//
//  GameScene.swift
//  penguin
//
//  Created by Gp on 6/25/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    //let world = SKScene()
    // create a constant cam as a SKCameraNode
    let cam = SKCameraNode()
    
    let bee = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        /*
        let mySprite = SKSpriteNode(color: .blue, size: CGSize(width: 50, height: 50))
        
        //mySprite.position = CGPoint(x:300, y:300)
        //mySprite.position = CGPoint(x: size.width * 0.5, y:size.height*0.5)
        self.addChild(mySprite)
        
        // tweening action
        let demoAction = SKAction.moveBy(x: 100, y: 100, duration: 5)
        let demoAction1 = SKAction.scale(to: 4, duration: 5)
        let demoAction2 = SKAction.rotate(byAngle: 5, duration: 5)
        
        let actionGroup = SKAction.group([demoAction, demoAction1, demoAction2])
        
        mySprite.run(actionGroup)
        */
        
        self.anchorPoint = .zero
        self.backgroundColor = UIColor(red: 0.4, green: 0.6,
                                       blue: 0.95, alpha: 1.0)
        
        // assign the camera to the scene
        self.camera = cam
        
        self.addBackground()
        // call the new bee function
        self.addTheFlyingBee()
        
    }
        
    func addBackground() {
        let bg = SKSpriteNode(imageNamed: "background-menu")
        bg.position = CGPoint(x: 250, y: 250)
        // add this so that background doesn't cover bee
        bg.alpha = 1
        self.addChild(bg)
    }
    
    func addTheFlyingBee() {
        //size our bee
        //bee.size = CGSize(width: 100, height: 100)\
        bee.size = CGSize(width: 28, height: 24)
        // position our bee node
        bee.position = CGPoint(x: 250, y: 250)
        self.addChild(bee)
        
        // Find our news bee texture atlas
        
        let beeAtlas = SKTextureAtlas(named: "Enemies")
        let beeFrames:[SKTexture] = [
            beeAtlas.textureNamed("bee.png"),
            beeAtlas.textureNamed("bee-fly.png")]
        
        // create SKAction to animate between the frames once
        let flyAction = SKAction.animate(with: beeFrames, timePerFrame: 0.14)
        let beeAction = SKAction.repeatForever(flyAction)
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
    }
    
    override func didSimulatePhysics() {
        // Keep the camera centered on the bee
        // Notice the ! operator after camera. SKScene's camera
        // is an optional, but we know it is there since we
        // assigned it above in the didMove function. We can tell
        // Swift that we know it can unwrap this value by using
        // the ! operator after the property name.
        
        self.camera!.position = bee.position
        
        
        /* old version swift 1.2*/
        // To find the correct position, subtract half of the
        // scene size from the bee's position, adjusted for any
        // world scaling.
        // Multiply by -1 and you have the adjustment to keep our
        // sprite centered:
        /*let worldXPos = -(bee.position.x * world.xScale -
                (self.size.width / 2))
        let worldYPos = -(bee.position.y * world.yScale -
                (self.size.height / 2))
        // Move the world so that the bee is centered in the scene
        world.position = CGPoint(x: worldXPos, y: worldYPos)
        */
    }
}

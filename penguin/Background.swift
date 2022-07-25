//
//  Background.swift
//  penguin
//
//  Created by Gp on 7/14/22.
//

import SpriteKit

class Background: SKSpriteNode {
    /* movementMultiplier will store a float from 0..1 to indicate
     how fast the background should move past.
     0 is full adjustment, no movement as the world goes past
     1 is no adjustment, background passes at normal seed
     */
    
    var moveMultiplier = CGFloat(0)
    
    /* JumpAdjustment will store how many points of x positions this background has jumped forward, useful for calculating future seamless jump points:
     */
    
    var jumpAdjustment = CGFloat(0)
    
    let backgroundSize = CGSize(width: 1024, height: 768)
    var textureAtlas = SKTextureAtlas(named: "Backgrounds")
    
    func spawn(parentNode: SKNode, imageName: String,
               zPosition:CGFloat, movementMultiplier: CGFloat) {
       
        // position from the bottom left
        self.anchorPoint = CGPoint.zero
        // start the background at the top of the ground (y:30)
        self.position = CGPoint(x: 0, y: 30)
        // control the order of the backgrounds with zPosition
        self.zPosition = zPosition
        self.moveMultiplier = movementMultiplier
        // add the background to the parentNode
        parentNode.addChild(self)
        
        let texture = textureAtlas.textureNamed(imageName)
        
        /* Build three child node instances of the texture,
        Looping from -1 to 1 so the backgrounds cover both
        forward and behind the player at position zero.
         */
        
        for i in -1...1 {
            let newBGNode = SKSpriteNode(texture: texture)
            newBGNode.size = backgroundSize
            // position these nodes by their lower left corner
            newBGNode.anchorPoint = CGPoint.zero
            // position the background node
            newBGNode.position = CGPoint(x: i * Int(backgroundSize.width), y: 0)
            // add the node to the background
            self.addChild(newBGNode)
        }
    }
    
    // Call updatePosition every frame to reposition the background
    func updatePosition(playerProgress: CGFloat) {
        // calculate a position adjustment after loops and parallax multiplier
        let adjustedPosition = jumpAdjustment + playerProgress * (1 - moveMultiplier)
        // check if we need to jump the background forward
        if playerProgress - adjustedPosition > backgroundSize.width {
            jumpAdjustment = jumpAdjustment + backgroundSize.width
        }
        // adjust this background position forward as the camera pans
        // so the background appears slower
        self.position.x = adjustedPosition
    }
    
}

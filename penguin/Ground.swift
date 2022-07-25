//
//  Ground.swift
//  penguin
//
//  Created by Gp on 7/2/22.
//

import SpriteKit

class Ground: SKSpriteNode, GameSprite {
    var textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "Environment")
    // conform to protocol
    var initialSize: CGSize = CGSize.zero
    
    var jumpWidth = CGFloat()
    // Note the instantiation value of 1 here
    var jumpCount = CGFloat(1)
    
    // this function tiles the ground texture across the width of the ground node.
    func createChildren() {
        // This is one of those unique situations where we use a
              // non-default anchor point. By positioning the ground by
              // its top left corner, we can place it just slightly
              // above the bottom of the screen, on any of screen size.
        self.anchorPoint = CGPoint(x: 0, y: 1)
        
        let texture = textureAtlas.textureNamed("ground")
        
        var tileCount:CGFloat = 0
        
        //let textureSize = texture.size()
        // We will size the tiles at half the size of their texture for retina sharpness
        //bad:let tileSize = CGSize(width: textureSize.width/2, height: textureSize: height/2)
        // We will size the tiles in their point size
        // They are 35 points wide and 300 points tall
        let tileSize = CGSize(width: 35, height: 300)
               
        // Build nodes until we cover the enture ground with
        while tileCount * tileSize.width < self.size.width {
            let tileNode = SKSpriteNode(texture: texture)
            tileNode.size = tileSize
            tileNode.position.x = tileCount * tileSize.width
            // position chikd nodes by their upper left corner
            tileNode.anchorPoint = CGPoint(x: 0, y: 1)
            // Add the child texture to the ground
            self.addChild(tileNode)
            tileCount = tileCount + 1
        }
        
        
        // Draw an edge physics body along the top of the ground node.
          // Note: physics body positions are relative to their nodes.
          // The top left of the node is X: 0, Y: 0, given our anchor point.
          // The top right of the node is X: size.width, Y: 0
        let pointTopLeft = CGPoint(x: 0, y: 0)
        let pointTopRight = CGPoint(x: size.width, y: 0)
        self.physicsBody = SKPhysicsBody(edgeFrom: pointTopLeft, to: pointTopRight)
        
        // Save the width of one-third of the children nodes
        jumpWidth = tileSize.width * floor(tileCount / 3)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.ground.rawValue
        
    }
    
    func checkForReposition(playerProgress: CGFloat) {
        // The ground needs to jump forward
        // every time the player has ,pved this distance
        let groundJumpPosition = jumpWidth * jumpCount
        
        if playerProgress >= groundJumpPosition {
            // The player ha moved past the jump position, move the ground forward
            self.position.x = self.position.x + jumpWidth
            jumpCount = jumpCount + 1
        }
    }
    
    // Implement onTap to adhere to the protocol:
    func onTap() {}
}

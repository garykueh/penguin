//
//  MenuScene.swift
//  penguin
//
//  Created by Gp on 7/14/22.
//

import SpriteKit

class MenuScene: SKScene {
    let textureAtlas: SKTextureAtlas = SKTextureAtlas(named: "HUD")
    let startButton = SKSpriteNode()
    let optionsButton = SKSpriteNode()

    override func didMove(to view: SKView) {
        // Position nodes from the center of the scene
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        // Add the background image
        let backgroundImage = SKSpriteNode(imageNamed: "background-menu")
        backgroundImage.size = CGSize(width: 1024, height: 768)
        backgroundImage.zPosition = -1
        self.addChild(backgroundImage)
    
        // draw the name of the game
        let logoText = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        logoText.text = "Penguin!!!"
        logoText.position = CGPoint(x:10, y:100)
        logoText.fontSize = 60
        self.addChild(logoText)
        
        let logoTextBottom = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        logoTextBottom.text = "Escapes the Antarctic"
        logoTextBottom.position = CGPoint(x: 0, y: 50)
        logoTextBottom.fontSize = 40
        self.addChild(logoTextBottom)
 
        // Start game button
        startButton.texture = textureAtlas.textureNamed("button")
        startButton.size = CGSize(width: 295, height: 76)
        // Name for touch detection
        startButton.name = "StartBtn"
        startButton.position = CGPoint(x: 0, y: -20)
        self.addChild(startButton)
        
        // Add the text to the start button
        let startText = SKLabelNode(fontNamed: "AvenirNext-HeavyItalic")
        startText.text = "START GAME"
        startText.verticalAlignmentMode = .center
        startText.position = CGPoint(x: 0, y: 2)
        startText.fontSize = 40
        // Name the text node for touch detection:
        startText.name = "StartBtn"
        startText.zPosition = 5
        startButton.addChild(startText)
        
        // Pulse the start text in and out
        let pulseAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.5, duration: 0.9),
            SKAction.fadeAlpha(to: 1, duration: 0.9)
            ])
        startText.run(pulseAction)
        
        
        //options menu button
        optionsButton.texture = textureAtlas.textureNamed("button-options")
        optionsButton.name = "OptionsBtn"
        optionsButton.position = CGPoint(x: 0, y: -120)
        optionsButton.size = CGSize(width: 75, height: 75)
        self.addChild(optionsButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in (touches) {
            let location = touch.location(in: self)
            let nodeTouched = atPoint(location)
            if nodeTouched.name == "StartBtn" {
                // Switch to instance of the GameScene
                self.view?.presentScene(GameScene(size: self.size))
            } else if nodeTouched.name == "OptionsBtn" {
                self.view?.presentScene(OptionsScene(size: self.size))
            }
        }
    }
}

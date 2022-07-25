//
//  GameViewController.swift
//  penguin
//
//  Created by Gp on 6/25/22.
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation

class GameViewController: UIViewController {
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        
        // Build the menu scene
        let menuScene = MenuScene()
        let skView = self.view as! SKView
        /*
        igmore drawing order of the child node. This increases performance
        */
        skView.ignoresSiblingOrder = true
        // size scene to fit view exactly
        menuScene.size = view.bounds.size
        // Show the menu
        skView.presentScene(menuScene)
        //    view.showsFPS = true
        //    view.showsNodeCount = true
        
        // Build the menu scene
        BackgroundMusic.instance.playBackgroundMusic()
    }
    

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}

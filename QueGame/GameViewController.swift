//
//  GameViewController.swift
//  QueGame
//
//  Created by Thomas jordan on 2016-05-03.
//  Copyright (c) 2016 Thomas jordan. All rights reserved.


import UIKit
import SpriteKit

class GameViewController: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var name = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            print(UIDevice().model)
            if (UIDevice().model) == "iPad Simulator" || (UIDevice().model) == "iPad" {
                name = "GameScene2"
            }else {
                name = "GameScene"
            }
        }
        
        
        if let scene = GameScene(fileNamed:name) {
            // Configure the view.
            let skView = self.view as! SKView

            skView.showsFPS = false
            skView.showsNodeCount = false
            /* Sprite Kit applies additil optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            scene.viewController = self
            //scene.size = skView.bounds.size
            scene.scaleMode = .Fill
            skView.presentScene(scene)
            //bg.sendSub(self.view)
            
        }
        
        
        
        
    }

    
    
    override func shouldAutorotate() -> Bool {
        return true
    }

    
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}

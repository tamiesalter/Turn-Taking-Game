//
//  MainMenu.swift
//  QueGame
//
//  Created by Thomas jordan on 2016-05-16.
//  Copyright © 2016 Thomas jordan. All rights reserved.
//

import UIKit
import SpriteKit

class MainMenu: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        downSwipe.direction = .Down
        
        self.view.addGestureRecognizer(downSwipe)
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer){
        if (sender.direction == .Down){
            //self.view.viewWithTag(1)?.hidden = true
            returnToMainMenu()

        }

    }
    
    func returnToMainMenu(){
        var vc: UIViewController = UIViewController()
        vc = self.view!.window!.rootViewController!
        //vc.modalPresentationStyle = .OverCurrentContext
        self.viewController.performSegueWithIdentifier("game", sender: vc)
    }
}

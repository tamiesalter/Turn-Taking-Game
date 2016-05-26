//
//  AppDelegate.swift
//  QueGame
//
//  Created by Thomas jordan on 2016-05-03.
//  Copyright © 2016 Thomas jordan. All rights reserved.
//

import UIKit
import SpriteKit
import Foundation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var model1 = TheModel()
    var mill = SKSpriteNode()
    var someAction = SKAction()
    var forever = SKAction()
    //switch and slider values being declared 
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        model1.millSpeed = 2
        model1.ballSpeed = 200
        model1.turn = 4.0
        model1.music = false
        model1.baby = false
        model1.b = false
        model1.eyes = true
        model1.eyeTemp = true
        model1.bg = SKAudioNode()
        someAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:(appDelegate.model1.millSpeed))
        forever = SKAction.repeatActionForever(someAction)
        mill.runAction(forever)
        return true
    }
    
    
    //action for mill rotation
    func runAction() {
        mill.removeAllActions()
        someAction = SKAction.rotateByAngle(CGFloat(M_PI), duration:(appDelegate.model1.millSpeed))
        forever = SKAction.repeatActionForever(someAction)
        mill.runAction(forever)
        
        }
    
        
    
    
        func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


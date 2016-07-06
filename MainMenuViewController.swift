//
//  MainMenuViewController.swift
//  QueGame
//
//  Created by Thomas jordan on 2016-05-16.
//  Copyright © 2016 Thomas jordan. All rights reserved.
//

import UIKit
import SpriteKit

class MainMenuViewController: UIViewController {
    @IBOutlet weak var QueBtn: UIButton!
    @IBOutlet weak var musicSwitch: UISwitch!
    @IBOutlet weak var windmillSpeed: UISlider!
    @IBOutlet weak var turnSpeed: UISlider!
    @IBOutlet weak var elephantSpeed: UISlider!
    @IBOutlet weak var babyCloud: UISwitch!
    @IBOutlet weak var cloudEyes: UISwitch!
    //This page is used to like the switches and sliders to the game scene using values and functions in appDelegate
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        musicSwitch.setOn(true, animated: true)
                }
    
        
    
          @IBAction func moveMill(sender: AnyObject) {
            
        let temp = 11 - windmillSpeed.value
        appDelegate.model1.millSpeed =  Double(temp)
        appDelegate.runAction()
    }
    
    
    
    @IBAction func moveElephant(sender: AnyObject) {
        appDelegate.model1.ballSpeed = Float(elephantSpeed.value)
    }
    
    
    
    @IBAction func musicSwitch(sender: AnyObject) {
        if musicSwitch.on == true {
            appDelegate.model1.music = true
        }
        else if musicSwitch.on == false {
            appDelegate.model1.bg.removeFromParent()
        }
    }
    
    
    
    @IBAction func turnSpeedMoved(sender: AnyObject) {
        let temp = 16 - turnSpeed.value
        appDelegate.model1.turn = Double(temp)
    }
    
    
    
    @IBAction func babyCloudMoved(sender: AnyObject) {
        if babyCloud.on == true {
            appDelegate.model1.baby = true
            appDelegate.model1.b = true 
        }else if babyCloud.on == false {
            appDelegate.model1.baby = false
        }
    }
    
    
    
    @IBAction func cloudEyesMoved(sender: AnyObject) {
        if cloudEyes.on == true {
            appDelegate.model1.eyes = true
            appDelegate.model1.eyeTemp = true
        }else if cloudEyes.on == false {
            appDelegate.model1.eyes = false
        }
    }
    @IBAction func queBtnUsed(sender: AnyObject) {
        let url = NSURL(string: "http://www.queinnovations.com/")!
        UIApplication.sharedApplication().openURL(url)
    }
    @IBAction func devBtnUsed(sender: AnyObject) {
        let url = NSURL(string: "https://ca.linkedin.com/in/thomas-jordan-69714711b")!
        UIApplication.sharedApplication().openURL(url)
    }
}

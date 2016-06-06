//
//  GameScene.swift
//  QueGame
//
//  Created by Thomas jordan on 2016-05-03.
//  Copyright (c) 2016 Thomas jordan. All rights reserved.
//

import SpriteKit
import Foundation


var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
var turn = true

class GameScene: SKScene, SKPhysicsContactDelegate{
    var cannon: SKSpriteNode!
    var cannon_full = SKSpriteNode()
    var millHouse = SKSpriteNode()
    var CScore = SKSpriteNode()
    var EScore = SKSpriteNode()
    var cloud: SKSpriteNode!
    var cloudPosition: SKSpriteNode!
    var touchLocation:CGPoint = CGPointZero
    var eyes: SKSpriteNode!
    var viewController: UIViewController?
    var sparkEmmiter = SKEmitterNode()
    var userlbl = 0
    var cloudlbl = 0
    var action = SKAction()
    let wallMask:UInt32 = 0x1 << 0 //1
    let ballMask:UInt32 = 0x1 << 1 //2
    let rainMask:UInt32 = 0x1 << 2 //4
    let targetMask:UInt32 = 0x1 << 3 //8
    let babyMask:UInt32 = 0x1 << 4 //16
    var scoreLabel = SKLabelNode()
    var cloudLabel = SKLabelNode()
    var babyCloudEyes = SKSpriteNode()
    var babyT = NSTimer()
    var babyE = NSTimer()
    var babyCloud = SKSpriteNode()
    var move = CGFloat()
    var moveAndRemoveCloud = SKAction()
    var movementAmount = arc4random()
    
    
    
    /*Call function when first launched add the score  labels then  add
    background music declare sprites such as mill and cannon,
    call function to add action for movement such as mill turning
    and blinking eyes on cloud, add NSTimer for spawning clouds to
    move across screen*/
    override func didMoveToView(view: SKView) {
               // screenSize()
        addScoreLable()
        appDelegate.model1.bg = SKAudioNode(fileNamed: "music.mp3")
        addChild(appDelegate.model1.bg)
        appDelegate.mill = self.childNodeWithName("mill") as! SKSpriteNode
        appDelegate.runAction()
        cannon = self.childNodeWithName("cannon") as! SKSpriteNode
        cloud = self.childNodeWithName("cloud") as! SKSpriteNode
        cloudPosition = self.childNodeWithName("cloudPosition") as! SKSpriteNode
        self.physicsWorld.contactDelegate = self
        addRain()
        

                    }
    
    
    /*Function called when babyT NSTimer runs through a full cycle to 
     spawn moving clouds across screen, cloud and clouds eyes are two 
     separate images with same movement code*/
    func makeCloud() {
        movementAmount = arc4random() % UInt32(self.frame.size.height/2)
        moveCloud()
        let babyCloudTexture = SKTexture(imageNamed: "babyCloud.png")
        babyCloud = SKSpriteNode(imageNamed: "babyCloud")
        babyCloud.setScale(0.8)
        babyCloud.physicsBody = SKPhysicsBody(texture: babyCloudTexture, size: babyCloudTexture.size())
        babyCloud.physicsBody?.dynamic = false
        babyCloud.physicsBody?.usesPreciseCollisionDetection
        babyCloud.name = "babyCloud"
        babyCloud.physicsBody!.categoryBitMask = targetMask
        babyCloud.zPosition = 3
        babyCloud.position = CGPoint(x:CGRectGetMaxX(self.frame)+500, y: CGRectGetMinY(self.frame)+1000+move)
        babyCloud.runAction(moveAndRemoveCloud)
        self.addChild(babyCloud)
        makeCloudEyes()
    }
    
    
    
    func makeCloudEyes(){
        moveCloud()
        let babyCloudEyesTexture = SKTexture(imageNamed: "eyes.png")
        babyCloudEyes = SKSpriteNode(texture: babyCloudEyesTexture)
        babyCloudEyes.position = CGPoint(x:CGRectGetMaxX(self.frame)+500, y: CGRectGetMinY(self.frame)+1000+move)
        babyCloudEyes.size.height = 150
        babyCloudEyes.size.width = 300
        babyCloudEyes.zPosition = 5
        babyCloudEyes.runAction(moveAndRemoveCloud)
        self.addChild(babyCloudEyes)
    }
    
    
    
    func moveCloud(){
        let moveCloud = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.size.width/100))
        let removeCoud = SKAction.removeFromParent()
        moveAndRemoveCloud = SKAction.sequence([moveCloud, removeCoud])
         move = CGFloat(movementAmount) - (self.frame.size.height/4)
    }


        
    /*Function called when users touch has ended with the intention of spawning a sprite
     and releasing it with an impulse from the location of the cannon in the direction of
     the rotation angel of the cannon*/
 func userShoot() {
        let ball:SKSpriteNode = SKScene(fileNamed: "Ball")!.childNodeWithName("ball")! as! SKSpriteNode
        ball.removeFromParent()
        self.addChild(ball)
        self.runAction(SKAction.playSoundFileNamed("cannon.wav", waitForCompletion: true))
        ball.position = cannon.position
        let angleInRadians = Float(cannon.zRotation)
        let speed = CGFloat(appDelegate.model1.ballSpeed)
        let vx:CGFloat = CGFloat(cosf(angleInRadians)) * speed
        let vy:CGFloat = CGFloat(sinf(angleInRadians)) * speed
        ball.physicsBody?.applyImpulse(CGVectorMake(vx, vy))
        ball.physicsBody?.collisionBitMask = wallMask | ballMask | targetMask | babyMask
        ball.physicsBody?.contactTestBitMask = ball.physicsBody!.collisionBitMask
        let Rain:SKSpriteNode = SKScene(fileNamed: "Rain")!.childNodeWithName("Rain")! as! SKSpriteNode
        Rain.removeFromParent()
        Rain.position = self.cloud.position
        Rain.physicsBody?.collisionBitMask = wallMask | ballMask | targetMask | babyMask
        Rain.physicsBody?.contactTestBitMask = Rain.physicsBody!.collisionBitMask
        turn = false
        self.sparkEmmiter.particleBirthRate = 200
        delay(appDelegate.model1.turn - 2){
            self.addChild(Rain)
            self.runAction(SKAction.playSoundFileNamed("Water.mp3", waitForCompletion: true))
        }
        delay(appDelegate.model1.turn){
           turn = true
            self.sparkEmmiter.particleBirthRate = 0
        }
    }
    
    
    
    /*Function called when two sprites with physics come in 
     contact using UInt32 CatagoryBitMasks to group multiple  
     sprites to the same contact name*/
    func didBeginContact(contact: SKPhysicsContact) {
        let target = (contact.bodyA.categoryBitMask == targetMask) ? contact.bodyA : contact.bodyB
        let other = (target == contact.bodyA) ? contact.bodyB : contact.bodyA
        let target2 = (contact.bodyA.categoryBitMask == babyMask) ? contact.bodyA : contact.bodyB
        let baby = (target2 == contact.bodyA) ? contact.bodyB : contact.bodyA
        if other.categoryBitMask == ballMask {
            self.didHitBall(other)
            userlbl += 1
            scoreLabel.text = String(userlbl)
        }
        if other.categoryBitMask == rainMask {
            self.didHitBall(other)
            cloudlbl += 1
            cloudLabel.text = String(cloudlbl)
        }
        if baby.categoryBitMask == ballMask {
            self.didHitBall(baby)
            
        }
    }
    
    
    
    //adding both score lables
    func addScoreLable(){
        EScore = self.childNodeWithName("EScore") as! SKSpriteNode
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position.x = EScore.position.x
        scoreLabel.position.y = EScore.position.y - 160
       self.addChild(scoreLabel)
        CScore = self.childNodeWithName("CScore") as! SKSpriteNode
        cloudLabel.fontName = "Helvetica"
        cloudLabel.fontSize = 60
        cloudLabel.text = "0"
        cloudLabel.position.x = CScore.position.x
        cloudLabel.position.y = CScore.position.y - 160
        self.addChild(cloudLabel)
    }
    
    
    
    //adding blinking animation to clouds eyes by 
    //switching between two img's
    func addBlinkingEyes() {
        let eyeTexture = SKTexture(imageNamed: "eyes1.png")
        let eyeTexture2 = SKTexture(imageNamed: "eyes2.png")
        let animation = SKAction.animateWithTextures([eyeTexture, eyeTexture2], timePerFrame: 1.9)
        let blink = SKAction.repeatActionForever(animation)
        eyes = SKSpriteNode(texture: eyeTexture)
        eyes.position = cloud.position
        eyes.size.height = 200
        eyes.size.width = 300
        eyes.runAction(blink)
        eyes.zPosition = 3
        self.addChild(eyes)
    }
    
    
    
    //calling an sks file called go1 witch is an animation of rain and placeing it 
    //at the clouds locatuon
    func addRain() {
        sparkEmmiter = SKEmitterNode(fileNamed: "go1.sks")!
        sparkEmmiter.position = self.cloudPosition.position
        sparkEmmiter.name = "sparkEmmitter"
        sparkEmmiter.zPosition = 1
        sparkEmmiter.targetNode = self
        self.sparkEmmiter.particleBirthRate = 0
        self.addChild(sparkEmmiter)
    }

    
    
    //Calling a spark animation and giving it specific
    //colors depending on who’s turn it is then showing a spark and
    //removing  the ball from its parent
    func didHitBall(Rain:SKPhysicsBody){
        let blue = UIColor(red: 0.16, green: 0.73, blue: 0.78, alpha: 1.0)
        let orange = UIColor(red: 1.0, green: 0.45, blue: 0.0, alpha: 1.0)
        let spark: SKEmitterNode = SKEmitterNode(fileNamed:"Spark")!
        spark.position = Rain.node!.position
        spark.particleColor = (Rain.categoryBitMask == ballMask) ? orange :blue
        self.addChild(spark)
        Rain.node?.removeFromParent()
        self.runAction(SKAction.playSoundFileNamed("hit.wav", waitForCompletion: true))
    }
    
    
    
    //This function is called continuously so using if 
    //statements and a number a Boolean variables in the 
    //appDelegate it is possible to use function without issues
    override func update(currentTime: CFTimeInterval) {
        SKSceneScaleMode.AspectFit
        let shader = SKShader(fileNamed: "Blur")
        let percent = touchLocation.x / size.width
        let newAngle = percent * 180 - 180
        cannon.zRotation = CGFloat(newAngle * -1) * CGFloat(M_PI)/180.0
        if appDelegate.model1.music == true {
            appDelegate.model1.bg = SKAudioNode(fileNamed: "music.mp3")
            addChild(appDelegate.model1.bg)
            appDelegate.model1.music = false
        }
        if appDelegate.model1.baby == true {
            if appDelegate.model1.b == true {
                babyT.invalidate()
                babyT = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(GameScene.makeCloud), userInfo: nil, repeats: true)
                appDelegate.model1.b = false
            }
        } else if appDelegate.model1.baby == false {
            babyT.invalidate()
            babyE.invalidate()
        }
        if turn == true {
            self.cannon.shader = shader
            self.cloud.shader = nil
        }else if turn == false {
            delay(2){
                self.cloud.shader = shader
                self.cannon.shader = nil
                }
            
        }
        if appDelegate.model1.eyes == true{
            if appDelegate.model1.eyeTemp == true {
            addBlinkingEyes()
            babyT.invalidate()
            babyT = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: #selector(GameScene.makeCloud), userInfo: nil, repeats: true)
            appDelegate.model1.eyeTemp = false
            } }else if appDelegate.model1.eyes == false{
            eyes.removeFromParent()
            babyCloudEyes.removeFromParent()
        }
    }
    
    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time( DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }

    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchLocation = touches.first!.locationInNode(self)
    }
    
    
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchLocation = touches.first!.locationInNode(self)
    }
    
    
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if turn == true {
            userShoot()
        }
    }
    
    

    }

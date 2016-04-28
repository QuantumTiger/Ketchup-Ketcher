//
//  ViewController.swift
//  Ketchup Katcher
//
//  Created by WGonzalez on 4/6/16.
//  Copyright © 2016 Quantum Apple. All rights reserved.
// val test
//sdfklsdajfklsad;fjs ksdljflksdjflk;asdf
//dfjkasdjfklsadflsad ad

import UIKit


class ViewController: UIViewController, UICollisionBehaviorDelegate, UIWebViewDelegate
{

    var burger = UIImageView()
    var obstacle = UIImageView()
    var newWallLeft = UIImageView()
    var newWallRight = UIImageView()
    var ketchup = UIImageView()
    
    var collisionBehavior = UICollisionBehavior()
    var myDynamicAnimator = UIDynamicAnimator()
    
    var everythingStore : [UIImageView] = []
    var randomObstacle : [UIImageView] = []
    
    var leftWallBarrierStore : [UIImageView] = []
    var rightWallBarrierStore : [UIImageView] = []
    
    var wallExpired = 3
    var wallCounter = 0

    var gravity : UIGravityBehavior!
    var animator : UIDynamicAnimator!
    
    @IBOutlet weak var modeLabel: UILabel!
    
    weak var timer : NSTimer?
    
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    func countdown()
    {
        print("Time Elapsed : \(wallExpired)")
        wallExpired -= 1
        
        if wallExpired / 2 == 1
        {
            print("Wall Removed")
            print("\(CGRectGetMaxY(view.frame))", "\(CGRectGetMaxX(view.frame))")
            for newWall in randomObstacle
            {
                newWall.frame = CGRectMake(CGFloat(arc4random_uniform(130) + 130), CGFloat(arc4random_uniform(450) + 100), 25, 25)
                view.addSubview(newWall)
                myDynamicAnimator.updateItemUsingCurrentState(newWall)
            }
            for obstacle in leftWallBarrierStore
            {
                let leftX = 0
                
                obstacle.frame = CGRect(x: leftX, y: 550, width: Int(arc4random_uniform(35) + 100), height: 40)
            }
            for obstacle in rightWallBarrierStore
            {
                let rightX = Int(view.frame.width)
                
                obstacle.frame = CGRect(x: rightX, y: 550, width: -Int(arc4random_uniform(35) + 100), height: 40)
            }
        }
            
        else if wallExpired < 0
        {
            wallExpired = 3
            print("Reset")
        }
    }
    @IBAction func startGameGo(sender: AnyObject)
    {
        startButton.hidden = true
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.countdown), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        game()
    }
    
    func game()
    {
        let filePath = NSBundle.mainBundle().pathForResource("giphy-1", ofType: "gif")
        let gif = NSData(contentsOfFile: filePath!)
        
        let webViewBG = UIWebView(frame: self.view.frame)
        webViewBG.loadData(gif!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
        webViewBG.userInteractionEnabled = false
        self.view.addSubview(webViewBG)
        
        let filter = UIView()
        filter.frame = self.view.frame
        filter.backgroundColor = UIColor.blackColor()
        filter.alpha = 0.05
        self.view.addSubview(filter)
        
        ketchup = UIImageView(frame: CGRect(x:view.center.x - 20, y: 30, width: 30, height: 75))
        ketchup.image = UIImage(named: "Ketchup")
        ketchup.layer.cornerRadius = 5
        ketchup.clipsToBounds = true
        view.addSubview(ketchup)
        
        burger = UIImageView(frame: CGRectMake(view.center.x - 20, view.center.y * 1.8, 55, 45))
        burger.image = UIImage(named: "Burger")
        burger.layer.cornerRadius = 10.0
        burger.clipsToBounds = true
        view.addSubview(burger)
        
        myDynamicAnimator = UIDynamicAnimator(referenceView: view)
        
        let ketchupDynamiceBehavior = UIDynamicItemBehavior(items: [ketchup])
        ketchupDynamiceBehavior.anchored = true
        myDynamicAnimator.addBehavior(ketchupDynamiceBehavior)
        everythingStore.append(ketchup)
        
        let burgerDynamiceBehavior = UIDynamicItemBehavior(items: [burger])
        burgerDynamiceBehavior.density = 999999999.0
        burgerDynamiceBehavior.resistance = 999999.0
        burgerDynamiceBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(burgerDynamiceBehavior)
        everythingStore.append(burger)

        createRandom(5)
        createBarriers(10, NumberOfRightBarriers: 10)
        
        let wallDynamicBehavior = UIDynamicItemBehavior(items: randomObstacle)
        wallDynamicBehavior.allowsRotation = false
        wallDynamicBehavior.anchored = true
        myDynamicAnimator.addBehavior(wallDynamicBehavior)
        wallCounter += 1
        
        let obstacleDynamicBehaviorLeft = UIDynamicItemBehavior(items: leftWallBarrierStore)
        obstacleDynamicBehaviorLeft.allowsRotation = false
        obstacleDynamicBehaviorLeft.anchored = true
        myDynamicAnimator.addBehavior(obstacleDynamicBehaviorLeft)
        
        let obstacleDynamicBehaviorRight = UIDynamicItemBehavior(items: rightWallBarrierStore)
        obstacleDynamicBehaviorRight.allowsRotation = false
        obstacleDynamicBehaviorRight.anchored = true
        myDynamicAnimator.addBehavior(obstacleDynamicBehaviorRight)
        
        collisionBehavior = UICollisionBehavior(items: everythingStore)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        collisionBehavior.collisionDelegate = self
        myDynamicAnimator.addBehavior(collisionBehavior)
    }
   
    @IBAction func dragPad(sender: UIPanGestureRecognizer)
    {
        let panX = sender.locationInView(view).x
        let panY = sender.locationInView(view).y
        burger.center = CGPointMake(panX, panY)
        myDynamicAnimator.updateItemUsingCurrentState(burger)
    }
    
    func createRandom(NumberOfObstacles : Int)
    {
        for obstacle in 1...NumberOfObstacles
        {
            let newObstacle = UIImageView(frame: CGRect(x: Int(arc4random_uniform(200) + 50), y: Int(arc4random_uniform(450) + 100), width: 25, height: 25))
            newObstacle.frame = CGRectMake(CGFloat(arc4random_uniform(200) + 50), CGFloat(arc4random_uniform(450) + 100), 25, 25)
            newObstacle.image = UIImage(named: "Wall Color")
            view.addSubview(newObstacle)
            randomObstacle.append(newObstacle)
            everythingStore.append(newObstacle)
            wallCounter += 1
        }
    }
    func createBarriers(NumberOfLeftBarriers : Int, NumberOfRightBarriers : Int)
    {
        let leftX = 0
        let rightX = Int(view.frame.width)
        var leftDistanceBetween = 550
        var rightDistanceBetween = 550
        
        var obstacleY = (Int(view.frame.height - 10) - (NumberOfLeftBarriers - 1) * 3) / NumberOfLeftBarriers
        
        for leftObstacle in 1...NumberOfLeftBarriers
        {
            newWallLeft = UIImageView(frame: CGRect(x: leftX, y: leftDistanceBetween, width: Int(arc4random_uniform(100) + 35), height: 40))
            newWallLeft.image = UIImage(named: "Wall Color")
            newWallLeft.clipsToBounds = true
            view.addSubview(newWallLeft)
            everythingStore.append(newWallLeft)
            leftWallBarrierStore.append(newWallLeft)
            leftDistanceBetween -= 50
        }
        
        for rightObstacle in 1...NumberOfRightBarriers
        {
            newWallRight = UIImageView(frame: CGRect(x: rightX, y: rightDistanceBetween, width: -Int(arc4random_uniform(100) + 35), height: 40))
//            newObstacleRight.transform = CGAffineTransformMakeScale(-1, 1)
            newWallRight.image = UIImage(named: "Wall Color")
            newWallRight.clipsToBounds = true
            view.addSubview(newWallRight)
            everythingStore.append(newWallRight)
            rightWallBarrierStore.append(newWallRight)
            rightDistanceBetween -= 50
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint)
    {
        for leftWall in leftWallBarrierStore
        {
            if item1.isEqual(burger) && item2.isEqual(leftWall) || item1.isEqual(leftWall) && item2.isEqual(burger)
            {
                print("Game Over")
//                burger.removeFromSuperview()
//                collisionBehavior.removeItem(burger)
            }
        }
        for rightWall in rightWallBarrierStore
        {
            if item1.isEqual(burger) && item2.isEqual(rightWall) || item1.isEqual(rightWall) && item2.isEqual(burger)
            {
                print("Game Over")
//                burger.removeFromSuperview()
//                collisionBehavior.removeItem(burger)
            }
        }
        for obstacle in randomObstacle
        {
            if item1.isEqual(burger) && item2.isEqual(obstacle) || item1.isEqual(obstacle) && item2.isEqual(burger)
            {
                print("Restart")
                burger.frame = CGRectMake(view.center.x - 20, view.center.y * 1.8, 55, 45)
                myDynamicAnimator.updateItemUsingCurrentState(burger)
            }
        }
        if item1.isEqual(burger) && item2.isEqual(ketchup) || item1.isEqual(ketchup) && item2.isEqual(burger)
        {
            print("Winner")
        }
    }
    
    @IBAction func returnBackToHome(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
//
//  ViewController.swift
//  Ketchup Katcher
//
//  Created by WGonzalez on 4/6/16.
//  Copyright © 2016 Quantum Apple. All rights reserved.
// val test
//sdfklsdajfklsad;fjs ksdljflksdjflk;asdf
//dfjkasdjfklsadflsad

import UIKit


class ViewController: UIViewController, UICollisionBehaviorDelegate, UIWebViewDelegate
{

    var burger = UIImageView()
    var wall = UIImageView()
    var newObstacleLeft = UIImageView()
    var newObstacleRight = UIImageView()
    var ketchup = UIImageView()
    
    var collisionBehavior = UICollisionBehavior()
    var myDynamicAnimator = UIDynamicAnimator()
    
    var wallStoreFunction : [UIImageView] = []
    var randomWallStore : [UIImageView] = []
    
    var leftWallBarrierStore : [UIImageView] = []
    var rightWallBarrierStore : [UIImageView] = []
    
    var wallExpired = 3
    var wallCounter = 0
    
    var gravity : UIGravityBehavior!
    var animator : UIDynamicAnimator!
    
    weak var timer : NSTimer?
    
    @IBOutlet weak var startButton: UIButton!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    func countdown()
    {
        print("Time Elapsed : \(wallExpired)")
        
        if wallExpired / 2 == 1
        {
            print("Wall Removed")
            for newWall in randomWallStore
            {
                newWall.frame = CGRectMake(CGFloat(arc4random_uniform(130) + 130), CGFloat(arc4random_uniform(450) + 100), 25, 25)
                view.addSubview(newWall)
                myDynamicAnimator.updateItemUsingCurrentState(newWall)
                wallCounter -= 1
            }
        }
            
        else if wallExpired < 0
        {
            wallExpired = 3
            print("Reset")
        }
        else if wallCounter < 0
        {
            createRandom(5)
            myDynamicAnimator.updateItemUsingCurrentState(wall)
            view.addSubview(wall)
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
        
        burger = UIImageView(frame: CGRectMake(view.center.x - 40, view.center.y * 1.75, 55, 45))
        burger.image = UIImage(named: "Burger")
        burger.layer.cornerRadius = 10.0
        burger.clipsToBounds = true
        view.addSubview(burger)
        
        myDynamicAnimator = UIDynamicAnimator(referenceView: view)
        
//        let ketchupDynamiceBehavior = UIDynamicItemBehavior(items: [ketchup])
//        ketchupDynamiceBehavior.density = 0.0
//        ketchupDynamiceBehavior.resistance = 0.0
//        ketchupDynamiceBehavior.friction = 0.0
//        ketchupDynamiceBehavior.elasticity = 1.0
//        myDynamicAnimator.addBehavior(ketchupDynamiceBehavior)
//        
//        wallStoreFunction.append(ketchup)
        
        let burgerDynamiceBehavior = UIDynamicItemBehavior(items: [burger])
        burgerDynamiceBehavior.density = 999999999.0
        burgerDynamiceBehavior.resistance = 999999.0
        burgerDynamiceBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(burgerDynamiceBehavior)
        wallStoreFunction.append(burger)

        createRandom(5)
        createBarriers(10, NumberOfRightBarriers: 10)
        
        
        let wallDynamicBehavior = UIDynamicItemBehavior(items: randomWallStore)
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
        
        
        collisionBehavior = UICollisionBehavior(items: wallStoreFunction)
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
    
    func createRandom(NumberOfWalls : Int)
    {
        for walls in 1...NumberOfWalls
        {
            let newWall = UIImageView(frame: CGRect(x: Int(arc4random_uniform(200) + 50), y: Int(arc4random_uniform(450) + 100), width: 25, height: 25))
            newWall.frame = CGRectMake(CGFloat(arc4random_uniform(200) + 50), CGFloat(arc4random_uniform(450) + 100), 25, 25)
            newWall.image = UIImage(named: "Wall Color")
            view.addSubview(newWall)
            randomWallStore.append(newWall)
            wallStoreFunction.append(newWall)
            wallCounter += 1
        }
    }
    func createBarriers(NumberOfLeftBarriers : Int, NumberOfRightBarriers : Int)
    {
        let leftX = 0
        let rightX = 273 //273
        var leftDistanceBetween = 550
        var rightDistanceBetween = 550
        
        var obstacleY = (Int(view.frame.height - 10) - (NumberOfLeftBarriers - 1) * 3) / NumberOfLeftBarriers
        
        for leftObstacle in 1...NumberOfLeftBarriers
        {
            newObstacleLeft = UIImageView(frame: CGRect(x: leftX, y: leftDistanceBetween, width: Int(arc4random_uniform(100) + 35), height: 40))
            newObstacleLeft.image = UIImage(named: "Wall Color")
            newObstacleLeft.clipsToBounds = true
            view.addSubview(newObstacleLeft)
            wallStoreFunction.append(newObstacleLeft)
            leftWallBarrierStore.append(newObstacleLeft)
            leftDistanceBetween -= 50
        }
        
        for rightObstacle in 1...NumberOfRightBarriers
        {
            newObstacleRight = UIImageView(frame: CGRect(x: rightX, y: rightDistanceBetween, width: Int(arc4random_uniform(100) + 35), height: 40))
            newObstacleRight.transform = CGAffineTransformMakeScale(-1, 1)
            newObstacleRight.image = UIImage(named: "Wall Color")
            newObstacleRight.clipsToBounds = true
            view.addSubview(newObstacleRight)
            wallStoreFunction.append(newObstacleRight)
            rightWallBarrierStore.append(newObstacleRight)
            rightDistanceBetween -= 50
        }

    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint)
    {
        for wall in wallStoreFunction
        {
            if item1.isEqual(burger) && item2.isEqual(wall) || item1.isEqual(wall) && item2.isEqual(burger)
            {
                print("Game Over")
                burger.frame = CGRectMake(50, 550, 55, 45)
//                burger.removeFromSuperview()
//                collisionBehavior.removeItem(burger)
//                myDynamicAnimator.updateItemUsingCurrentState(burger)
            }
        }
    }
}
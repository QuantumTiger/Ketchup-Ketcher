//
//  ViewController.swift
//  Ketchup Katcher
//
//  Created by WGonzalez on 4/6/16.
//  Copyright © 2016 Quantum Apple. All rights reserved.
// val test
//sdfklsdajfklsad;fjs ksdljflksdjflk;asdf
//dfjkasdjfklsadflsad ad fghjk

import UIKit


class ViewController: UIViewController, UICollisionBehaviorDelegate, UIWebViewDelegate
{

    var burger = UIImageView()
    var obstacle = UIImageView()
    var newWallLeft = UIImageView()
    var newWallRight = UIImageView()
    var ketchup = UIImageView()
    
    var burgerLivesView = UIImageView()
    var burgerLivesStore : [UIImageView] = []
    
    var collisionBehavior = UICollisionBehavior()
    var myDynamicAnimator = UIDynamicAnimator()
    
    var everythingStore : [UIImageView] = []
    var randomObstacle : [UIImageView] = []
    
    var leftWallBarrierStore : [UIImageView] = []
    var rightWallBarrierStore : [UIImageView] = []
    
    var dataFound = DataController()
    
    @IBOutlet weak var notSureButton: UIButton!
    @IBOutlet weak var classicLabel: UILabel!
    
    var wallExpired = 2
    var wallCounter = 0
    var burgerLives = 0.0
    
    var perfectRuns = 0
    let defaults = NSUserDefaults.standardUserDefaults()

    var gravity : UIGravityBehavior!
    
    weak var timer : NSTimer?
    
    @IBOutlet weak var startButton: UIButton!
    
    var livesLabel = UILabel()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    func countdown()
    {
        print("Time Elapsed : \(wallExpired)")
        wallExpired -= 1
        
        if wallExpired / 1 == 1
        {
            print("Wall Removed")
            
            for meteor in randomObstacle
            {
                meteor.frame = CGRectMake(CGFloat(arc4random_uniform(100) + 100), CGFloat(arc4random_uniform(350) + 100), 30, 30)
                view.addSubview(obstacle)
                myDynamicAnimator.updateItemUsingCurrentState(meteor)
            }
            for leftWall in leftWallBarrierStore
            {
                let leftX = 0
                leftWall.frame = CGRect(x: leftX, y: 475, width: Int(arc4random_uniform(30) + 90), height: 30)
            }
            for rightWall in rightWallBarrierStore
            {
                let rightX = Int(view.frame.width)
                rightWall.frame = CGRect(x: rightX, y: 475, width: -Int(arc4random_uniform(30) + 90), height: 30)
            }
        }
            
        else if wallExpired < 0
        {
            wallExpired = 2
            print("Reset")
        }
    }
    @IBAction func startGameGo(sender: AnyObject)
    {
        startButton.hidden = true
        notSureButton.hidden = true
        classicLabel.hidden = true
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.countdown), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        game()
    }
    
    func game()
    {
        if let runs = defaults.stringForKey("Perfect Runs")
        {
            perfectRuns = Int(runs)!
        }
        
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
        
        lives()
        
        ketchup = UIImageView(frame: CGRect(x:view.center.x - 20, y: 65, width: 30, height: 75))
        ketchup.image = UIImage(named: "Ketchup")
        ketchup.layer.cornerRadius = 5
        ketchup.clipsToBounds = true
        view.addSubview(ketchup)
        
        burger = UIImageView(frame: CGRectMake(view.center.x - 20, view.center.y * 1.8, 45, 35))
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

        createRandom(4)
        createBarriers(10, NumberOfRightBarriers: 10)
        
        let obstacleDynamicBehavior = UIDynamicItemBehavior(items: randomObstacle)
        obstacleDynamicBehavior.allowsRotation = false
        obstacleDynamicBehavior.anchored = true
        myDynamicAnimator.addBehavior(obstacleDynamicBehavior)
        
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
    // ============================================================================================================
    func createRandom(NumberOfObstacles : Int)
    {
        for obstacle in 1...NumberOfObstacles
        {
            let newObstacle = UIImageView(frame: CGRect(x: Int(arc4random_uniform(200) + 50), y: Int(arc4random_uniform(450) + 100), width: 30, height: 30))
            newObstacle.frame = CGRectMake(CGFloat(arc4random_uniform(200) + 50), CGFloat(arc4random_uniform(375) + 100), 30, 30)
            newObstacle.image = UIImage(named: "Meteor")
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
        var leftDistanceBetween = Int(view.frame.width) + 165
        var rightDistanceBetween = Int(view.frame.width) + 165
        
        for leftWall in 1...NumberOfLeftBarriers
        {
            newWallLeft = UIImageView(frame: CGRect(x: leftX, y: leftDistanceBetween, width: Int(arc4random_uniform(80) + 30), height: 30))
            newWallLeft.image = UIImage(named: "UFO")
            newWallLeft.clipsToBounds = true
            view.addSubview(newWallLeft)
            everythingStore.append(newWallLeft)
            leftWallBarrierStore.append(newWallLeft)
            leftDistanceBetween -= 40
        }
        
        for rightWall in 1...NumberOfRightBarriers
        {
            newWallRight = UIImageView(frame: CGRect(x: rightX, y: rightDistanceBetween, width: -Int(arc4random_uniform(80) + 30), height: 30))
            newWallRight.image = UIImage(named: "UFO")
            newWallRight.clipsToBounds = true
            view.addSubview(newWallRight)
            everythingStore.append(newWallRight)
            rightWallBarrierStore.append(newWallRight)
            rightDistanceBetween -= 40
        }
    }
    
    func gameOver()
    {
        let gameOverAlert = UIAlertController(title: "Try Again", message: "You Failed", preferredStyle: .Alert)
        self.presentViewController(gameOverAlert, animated: true, completion: nil)
        let dismiss = UIAlertAction(title: "Better Luck Next Time", style: .Default)
        { (dismiss) in
            let homeStart = self.storyboard!.instantiateViewControllerWithIdentifier("HomeStart") as! HomeStart
            self.presentViewController(homeStart, animated: true, completion: nil)
        }
        gameOverAlert.addAction(dismiss)
        
        livesLabel.removeFromSuperview()
        burger.removeFromSuperview()
        burgerLivesView.removeFromSuperview()
        collisionBehavior.removeItem(burger)
        ketchup.removeFromSuperview()
        everythingStore.removeAll()
        for leftwall in leftWallBarrierStore
        {
            leftwall.hidden = true
            leftWallBarrierStore.removeAll()
            newWallLeft.hidden = true
            myDynamicAnimator.updateItemUsingCurrentState(leftwall)
        }
        for rightwall in rightWallBarrierStore
        {
            rightwall.hidden = true
            rightWallBarrierStore.removeAll()
            newWallRight.hidden = true
            myDynamicAnimator.updateItemUsingCurrentState(rightwall)
        }
            for newObstacle in randomObstacle
        {
            newObstacle.hidden = true
            randomObstacle.removeAll()
            obstacle.hidden = true
            myDynamicAnimator.updateItemUsingCurrentState(newObstacle)
        }
        timer?.invalidate()
        wallExpired = 0
        perfectRuns = 0
    }

    func winner()
    {
        defaults.setInteger(perfectRuns, forKey: "Perfect Runs")
        perfectRuns += 1
        burger.frame = CGRectMake(view.center.x - 20, view.center.y * 1.8, 45, 35)
        myDynamicAnimator.updateItemUsingCurrentState(burger)
        
        let scoreKeep = UIAlertController(title: "Winner", message: "You Caught the Ketchup!!! \n Perfect Runs : \(perfectRuns)", preferredStyle: .Alert)
        self.presentViewController(scoreKeep, animated: true, completion: nil)
        let dismiss = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil)
        scoreKeep.addAction(dismiss)
    }
    
    func lives()
    {
        let imageSpace = view.center.x - 155
        burgerLivesView = UIImageView(frame: CGRect(x: imageSpace, y: view.center.y * 0.13, width: 35, height: 25))
        burgerLivesView.image = UIImage(named: "Burger")
        view.addSubview(burgerLivesView)
        burgerLivesStore.append(burgerLivesView)
        burgerLives = 3
        
        livesLabel = UILabel(frame: CGRect(x: view.center.x - 195, y: view.center.y * 0.0, width: 200, height: 100))
        livesLabel.textAlignment = NSTextAlignment.Center
        livesLabel.text = "X : \(burgerLives)"
        livesLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(livesLabel)
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint)
    {
        for leftWall in leftWallBarrierStore
        {
            if item1.isEqual(burger) && item2.isEqual(leftWall) || item1.isEqual(leftWall) && item2.isEqual(burger)
            {
                burgerLives -= 1
                livesLabel.text = "X : \(burgerLives)"
                if burgerLives == 0.0
                {
                    print("Game Over")
                    gameOver()
                }
                else if burgerLives < 0.0
                {
                    gameOver()
                }
            }
        }
        for rightWall in rightWallBarrierStore
        {
            if item1.isEqual(burger) && item2.isEqual(rightWall) || item1.isEqual(rightWall) && item2.isEqual(burger)
            {
                burgerLives -= 1
                livesLabel.text = "X : \(burgerLives)"
                if burgerLives == 0.0
                {
                    print("Game Over")
                    gameOver()
                }
                else if burgerLives < 0.0
                {
                    gameOver()
                }
            }
        }
        for obstacle in randomObstacle
        {
            if item1.isEqual(burger) && item2.isEqual(obstacle) || item1.isEqual(obstacle) && item2.isEqual(burger)
            {
                burgerLives -= 0.5
                livesLabel.text = "X : \(burgerLives)"
                if burgerLives == 0.0
                {
                    print("Restart")
                    gameOver()
                }
                else if burgerLives < 0.0
                {
                    gameOver()
                }
                burger.frame = CGRectMake(view.center.x - 20, view.center.y * 1.8, 45, 35)
                myDynamicAnimator.updateItemUsingCurrentState(burger)
            }
        }
        if item1.isEqual(burger) && item2.isEqual(ketchup) || item1.isEqual(ketchup) && item2.isEqual(burger)
        {
            print("Winner")
            winner()
        }
    }
    
    @IBAction func returnBackToHome(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
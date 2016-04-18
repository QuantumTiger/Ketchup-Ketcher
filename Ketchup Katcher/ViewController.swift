//
//  ViewController.swift
//  Ketchup Katcher
//
//  Created by WGonzalez on 4/6/16.
//  Copyright © 2016 Quantum Apple. All rights reserved.
// val test
//sdfklsdajfklsad;fjs ksdljflksdjflk;asdf

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate
{

    var burger = UIImageView()
    var wall = UIImageView()
    var ketchup = UIImageView()
    
    var collisionBehavior = UICollisionBehavior()
    var myDynamicAnimator = UIDynamicAnimator()
    
    var wallStoreFunction : [UIImageView] = []
    var itemStore : [UIImageView] = []
    
    var wallExpired = 3
    var wallCounter = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        game()
    }
    
    func countdown()
    {
        wallExpired -= 1
    }
    func game()
    {
        createRandom()
        createRandom()
        createRandom()
        
        let timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(ViewController.countdown), userInfo: nil, repeats: true)
        print("Time \(wallExpired)")
        
        if wallCounter == 0
        {
            print("Time \(timer)")
            print("Removed")
            //            wall.removeFromSuperview()
            //            collisionBehavior.removeItem(wall)
            //            myDynamicAnimator.updateItemUsingCurrentState(wall)
        }
        
        ketchup = UIImageView(frame: CGRect(x:view.center.x - 20, y: 100, width: 30, height: 75))
        ketchup.image = UIImage(named: "Ketchup")
        ketchup.layer.cornerRadius = 5
        ketchup.clipsToBounds = true
        view.addSubview(ketchup)
        
        burger = UIImageView(frame: CGRectMake(view.center.x - 40, view.center.y * 1.75, 75, 75))
//        burger.backgroundColor = UIColor.blackColor()
        burger.image = UIImage(named: "Burger")
        burger.layer.cornerRadius = 40.0
        burger.clipsToBounds = true
        view.addSubview(burger)
        
        myDynamicAnimator = UIDynamicAnimator(referenceView: view)
        
//        let ketchupDynamiceBehavior = UIDynamicItemBehavior(items: [ketchup])
//        ketchupDynamiceBehavior.density = 0.0
//        ketchupDynamiceBehavior.resistance = 0.0
//        ketchupDynamiceBehavior.friction = 0.0
//        ketchupDynamiceBehavior.elasticity = 1.0
//        myDynamicAnimator.addBehavior(ketchupDynamiceBehavior)
        
//        wallStoreFunction.append(ketchup)
        
        let burgerDynamiceBehavior = UIDynamicItemBehavior(items: [burger])
        burgerDynamiceBehavior.density = 999999999.0
        burgerDynamiceBehavior.resistance = 999999.0
        burgerDynamiceBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(burgerDynamiceBehavior)
        wallStoreFunction.append(burger)
        
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
    
    func createRandom()
    {
        wall = UIImageView(frame: CGRect(x: Int(arc4random_uniform(200) + 50), y: Int(arc4random_uniform(450) + 100), width: 100, height: 30))
        wall.image = UIImage(named: "Wall Color")
        wall.clipsToBounds = true
        view.addSubview(wall)
        
        let wallDynamiceBehavior = UIDynamicItemBehavior(items: [wall])
        wallDynamiceBehavior.density = 99999999.0
        wallDynamiceBehavior.resistance = 99999999999999.0
        wallDynamiceBehavior.elasticity = 1.0
        wallDynamiceBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(wallDynamiceBehavior)
        wallStoreFunction.append(wall)
        wallCounter += 1
        print("Walls \(wallCounter)")
        
//        let pushBehavior = UIPushBehavior(items: [wall], mode: .Instantaneous)
//        pushBehavior.angle = 90.0
//        pushBehavior.magnitude = 5.0
//        myDynamicAnimator.addBehavior(pushBehavior)
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint)
    {
        for wall in wallStoreFunction
        {
            if item1.isEqual(burger) && item2.isEqual(wall) || item1.isEqual(wall) && item2.isEqual(burger)
            {
                print("Game Over")
                wall.removeFromSuperview()
                collisionBehavior.removeItem(wall)
                removeWalls()
                myDynamicAnimator.updateItemUsingCurrentState(wall)
                wallCounter -= 1
                print("Walls \(wallCounter)")
            }
            if wallCounter == 0
            {
                createRandom()
            }
        }
    }
    func removeWalls()
    {
        wallStoreFunction.removeAtIndex(1)
    }
}
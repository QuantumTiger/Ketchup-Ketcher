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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        game()
    }

    func game()
    {
        createRandom()
    
        ketchup = UIImageView(frame: CGRect(x:view.center.x - 20, y: 100, width: 30, height: 75))
        ketchup.image = UIImage(named: "Ketchup")
        ketchup.layer.cornerRadius = 5
        ketchup.clipsToBounds = true
        view.addSubview(ketchup)
        
        
        burger = UIImageView(frame: CGRectMake(view.center.x - 40, view.center.y * 1.75, 75, 75))
        burger.image = UIImage(named: "Burger")
        burger.layer.cornerRadius = 5
        burger.clipsToBounds = true
        view.addSubview(burger)
        
//        wall = UIImageView(frame: CGRect(x: 230, y: 100, width: 130, height: 50))
//        wall.image = UIImage(named: "Wall Color")
//        wall.clipsToBounds = false
//        view.addSubview(wall)
    
        
        myDynamicAnimator = UIDynamicAnimator(referenceView: view)
        
//        let ketchupDynamiceBehavior = UIDynamicItemBehavior(items: [ketchup])
//        ketchupDynamiceBehavior.density = 0.0
//        ketchupDynamiceBehavior.resistance = 0.0
//        ketchupDynamiceBehavior.friction = 0.0
//        ketchupDynamiceBehavior.elasticity = 1.0
//        myDynamicAnimator.addBehavior(ketchupDynamiceBehavior)
        wallStoreFunction.append(ketchup)
        
        let burgerDynamiceBehavior = UIDynamicItemBehavior(items: [burger])
        burgerDynamiceBehavior.density = 999999999.0
        burgerDynamiceBehavior.resistance = 999999.0
        burgerDynamiceBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(burgerDynamiceBehavior)
        wallStoreFunction.append(burger)
        
//        let wallDynamiceBehavior = UIDynamicItemBehavior(items: [wall])
//        //wallDynamiceBehavior.density = 0.0
//        wallDynamiceBehavior.resistance = 0.0
//        wallDynamiceBehavior.friction = 0.0
//        wallDynamiceBehavior.elasticity = 1.0
//        wallDynamiceBehavior.allowsRotation = false
//        myDynamicAnimator.addBehavior(wallDynamiceBehavior)
//        wallStoreFunction.append(wall)
        
//        let pushBehavior = UIPushBehavior(items: [wall], mode: .Instantaneous)
//        pushBehavior.angle = 90.0
//        pushBehavior.magnitude = 5.0
//        myDynamicAnimator.addBehavior(pushBehavior)
        
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
        
                wall = UIImageView(frame: CGRect(x: Int(arc4random_uniform(230)), y: Int(arc4random_uniform(100)), width: 130, height: 50))
                wall.image = UIImage(named: "Wall Color")
                wall.clipsToBounds = false
                view.addSubview(wall)

                let wallDynamiceBehavior = UIDynamicItemBehavior(items: [wall])
                //wallDynamiceBehavior.density = 0.0
                wallDynamiceBehavior.resistance = 0.0
                wallDynamiceBehavior.friction = 0.0
                wallDynamiceBehavior.elasticity = 1.0
                wallDynamiceBehavior.allowsRotation = false
                myDynamicAnimator.addBehavior(wallDynamiceBehavior)
                wallStoreFunction.append(wall)
        
                let pushBehavior = UIPushBehavior(items: [wall], mode: .Instantaneous)
                pushBehavior.angle = 90.0
                pushBehavior.magnitude = 5.0
                myDynamicAnimator.addBehavior(pushBehavior)


    }

    func makeWalls(wallsForLevel : Int, YValue : CGFloat, XValue : CGFloat)
    {
        var yPoint = 5
        let wallHeight = (Int(view.frame.height))
        for wall in 1...wallsForLevel
        {
            let newWall = UIImageView(frame: CGRectMake(CGFloat(yPoint), YValue, CGFloat(wallHeight), 50))
            newWall.image = UIImage(named: "Wall Color")
            newWall.contentMode = UIViewContentMode.ScaleAspectFit
            view.addSubview(newWall)
            yPoint += wallHeight
            
        }
    }
    
}


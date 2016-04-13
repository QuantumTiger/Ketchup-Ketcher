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
        
        let ketchupColorName = "Ketchup"
        let ketchupColor = UIImage(named: ketchupColorName)
        let ketchupImage = UIImageView(image: ketchupColor!)
        
        ketchupImage.frame = CGRect(x:view.center.x - 20, y: 100, width: 30, height: 75)
        view.addSubview(ketchupImage)

        game()
    }

    func game()
    {
        burger = UIImageView(frame: CGRectMake(view.center.x - 40, view.center.y * 1.75, 80, 80))
        burger.image = UIImage(named: "Burger")
        burger.layer.cornerRadius = 5
        burger.clipsToBounds = true
        view.addSubview(burger)
        
        wall = UIImageView(frame: CGRect(x: 230, y: 600, width: 150, height: 50))
        wall.image = UIImage(named: "Wall Color")
        wall.clipsToBounds = true
        view.addSubview(wall)
    
        
        myDynamicAnimator = UIDynamicAnimator(referenceView: view)
        
        let burgerDynamiceBehavior = UIDynamicItemBehavior(items: [burger])
        burgerDynamiceBehavior.density = 99999.0
        burgerDynamiceBehavior.resistance = 9999999999.0
        burgerDynamiceBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(burgerDynamiceBehavior)
        wallStoreFunction.append(burger)
        
        let wallDynamiceBehavior = UIDynamicItemBehavior(items: [wall])
        wallDynamiceBehavior.density = 9999999999.0
        wallDynamiceBehavior.resistance = 9999999.0
        wallDynamiceBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(wallDynamiceBehavior)
        wallStoreFunction.append(wall)
        
        collisionBehavior = UICollisionBehavior(items: wallStoreFunction)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        collisionBehavior.collisionDelegate = self
        myDynamicAnimator.addBehavior(collisionBehavior)
        
    }
   
    @IBAction func dragPad(sender: UIPanGestureRecognizer)
    {
        let panGesture = sender.locationInView(view).x
        burger.center = CGPointMake(panGesture, burger.center.y)
        myDynamicAnimator.updateItemUsingCurrentState(burger)
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


//
//  ViewController.swift
//  Ketchup Katcher
//
//  Created by WGonzalez on 4/6/16.
//  Copyright © 2016 Quantum Apple. All rights reserved.
// val test
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate
{

    var catcher = UIView()
    var wall = UIImage()
    
    var collisionBehavior = UICollisionBehavior()
    var myDynamicAnimator = UIDynamicAnimator()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        makeWalls(2, YValue: 445, XValue: 230)
        
        let wallColorName = "Wall Color"
        let wallColor = UIImage(named: wallColorName)
        let wallImage = UIImageView(image: wallColor!)
        
        wallImage.frame = CGRect(x: 230, y: 500, width: 150, height: 50)
        view.addSubview(wallImage)

        game()
    }

    func game()
    {
        catcher = UIView(frame: CGRectMake(view.center.x - 40, view.center.y * 1.75, 80, 20))
        catcher.backgroundColor = UIColor.redColor()
        catcher.layer.cornerRadius = 5
        catcher.clipsToBounds = true
        view.addSubview(catcher)
        
        myDynamicAnimator = UIDynamicAnimator(referenceView: view)
        
        let paddleDynamiceBehavior = UIDynamicItemBehavior(items: [catcher])
        paddleDynamiceBehavior.density = 10000.0
        paddleDynamiceBehavior.resistance = 100.0
        paddleDynamiceBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(paddleDynamiceBehavior)
    }
   
    @IBAction func dragPad(sender: UIPanGestureRecognizer)
    {
        let panGesture = sender.locationInView(view).x
        catcher.center = CGPointMake(panGesture, catcher.center.y)
        myDynamicAnimator.updateItemUsingCurrentState(catcher)
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


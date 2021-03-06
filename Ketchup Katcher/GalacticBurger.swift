//
//  Memory.swift
//  Ketchup Katcher
//
//  Created by WGonzalez on 4/27/16.
//  Copyright © 2016 Quantum Apple. All rights reserved.
//AYE

import UIKit

class GalacticBurger: UIViewController, UICollisionBehaviorDelegate
{
    var paddle = UIImageView()
    var ball = UIImageView()
    var lives = 5
    var collisionBehavior = UICollisionBehavior()
    var imageNames = ["lettuce", "tomato", "pickles"]
    var brickArray : [UIImageView] = []
    var brickCount = 0
    
    var livesLabel = UILabel()
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var notSureButton: UIButton!
    
    var myDynamicAnimator = UIDynamicAnimator()
    var everythingArray : [UIImageView] = []
    
    @IBOutlet weak var modeLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func createGame()
    {
        livesLabel.textColor = UIColor.whiteColor()
        notSureButton.removeFromSuperview()
        modeLabel.removeFromSuperview()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "space")!)
        continueGame()
        
        lives = 5
        livesLabel.text = "Lives: \(lives)"
    }
    
    func continueGame()
    {
        // Add ball
        ball = UIImageView(frame: CGRectMake(view.center.x - 10, view.center.y, 50, 50))
        ball.image = UIImage(named: "splat")
        ball.layer.cornerRadius = 10.25
        ball.clipsToBounds = true
        view.addSubview(ball)
        
        // Add Paddle
        paddle = UIImageView(frame: CGRectMake(view.center.x - 40, view.center.y * 1.75, 100, 50))
        paddle.image = UIImage(named: "Burger")
        paddle.layer.cornerRadius = 5
        paddle.clipsToBounds = true
        view.addSubview(paddle)
        
        myDynamicAnimator = UIDynamicAnimator(referenceView: view)
        
        let ballDynamiceBehavior = UIDynamicItemBehavior(items: [ball])
        ballDynamiceBehavior.friction = 0.0 //Transer of energy
        ballDynamiceBehavior.resistance = 0.0 //Slows down over time
        ballDynamiceBehavior.elasticity = 1.0 //Bounce factor
        ballDynamiceBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(ballDynamiceBehavior)
        everythingArray.append(ball)
        
        let paddleDynamiceBehavior = UIDynamicItemBehavior(items: [paddle])
        paddleDynamiceBehavior.density = 1000.0 //Transer of energy
        paddleDynamiceBehavior.resistance = 1000.0 //Slows down over time
        paddleDynamiceBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(paddleDynamiceBehavior)
        everythingArray.append(paddle)
        
        let brickDynamiceBehavior = UIDynamicItemBehavior(items: brickArray)
        brickDynamiceBehavior.density = 10000.0 //Transer of energy
        brickDynamiceBehavior.resistance = 1000.0 //Slows down over time
        brickDynamiceBehavior.allowsRotation = false
        myDynamicAnimator.addBehavior(brickDynamiceBehavior)
        
        let pushBehavior = UIPushBehavior(items: [ball], mode: .Instantaneous)
        pushBehavior.angle = 1.90
        pushBehavior.magnitude = 1.5 //Force given
        myDynamicAnimator.addBehavior(pushBehavior)
        
        collisionBehavior = UICollisionBehavior(items: everythingArray)
        collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        collisionBehavior.collisionMode = .Everything
        collisionBehavior.collisionDelegate = self
        myDynamicAnimator.addBehavior(collisionBehavior)
    }
    
    func makeBricks(NumberOfBricks: Int, YValue: CGFloat)
    {
        var xPoint = 5
        var brickWidth = (Int(view.frame.width - 25) - (NumberOfBricks - 1) * 3) / NumberOfBricks
        
        for bricks in 1...NumberOfBricks
        {
            let newBlock = UIImageView(frame: CGRectMake(CGFloat(xPoint), YValue + 20, CGFloat(brickWidth), 50))
            newBlock.image = UIImage(named: "UFO")
            newBlock.contentMode = UIViewContentMode.ScaleAspectFit
            print("brick made")
            view.addSubview(newBlock)
            brickArray.append(newBlock)
            everythingArray.append(newBlock)
            xPoint += brickWidth + 3
        }
    }
    
    @IBAction func startGameButtonTapped(sender: UIButton)
    {
        everythingArray.removeAll()
        brickArray.removeAll()
        makeBricks(7, YValue: 20)
        makeBricks(5, YValue: 45)
        makeBricks(10, YValue: 70)
        startButton.hidden = true
        lives = 5
        livesLabel = UILabel(frame: CGRectMake(view.center.x - 145, view.center.y * 1.90, 200, 20))
        view.addSubview(livesLabel)
        createGame()
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
    }
    
    @IBAction func dragPad(sender: UIPanGestureRecognizer)
    {
        let panGesture = sender.locationInView(view).x
        paddle.center = CGPointMake(panGesture, paddle.center.y)
        myDynamicAnimator.updateItemUsingCurrentState(paddle)
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, atPoint p: CGPoint)
    {
        if item.isEqual(ball) && p.y > paddle.center.y
        {
            print("Lost a life")
            lives -= 1
            
            if lives > 0
            {
                livesLabel.text = "Lives: \(lives)"
                ball.center = view.center
                myDynamicAnimator.updateItemUsingCurrentState(ball)
            }
            else
            {
                livesLabel.text = "Game Over"
                gameOver()
                clearGame()
                startButton.hidden = false
            }
        }
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item1: UIDynamicItem, withItem item2: UIDynamicItem, atPoint p: CGPoint)
    {
        for brick in brickArray
        {
            if item1.isEqual(ball) && item2.isEqual(brick) || item1.isEqual(brick) && item2.isEqual(ball)
            {
                print("Hit Brick")
                if brick.image == UIImage(named: "UFO")
                {
                    brick.image = UIImage(named: "pickles")
                }
               else if brick.image == UIImage(named: "pickles")
                {
                    brick.image = UIImage(named: "lettuce")
                }
                else if brick.image == UIImage(named: "lettuce")
                {
                    brick.image = UIImage(named: "tomato")
                }
                else
                {
                    brick.hidden = true
                    collisionBehavior.removeItem(brick)
                    myDynamicAnimator.updateItemUsingCurrentState(brick)
                }
            }
        }
    }
    
    func clearGame()
    {
        for brick in brickArray
        {
            brick.hidden = true
            collisionBehavior.removeItem(brick)
            myDynamicAnimator.updateItemUsingCurrentState(brick)
        }
        
        brickArray.removeAll()
        everythingArray.removeAll()
        ball.removeFromSuperview()
        paddle.removeFromSuperview()
        collisionBehavior.removeItem(ball)
        collisionBehavior.removeItem(paddle)
        myDynamicAnimator.updateItemUsingCurrentState(ball)
        myDynamicAnimator.updateItemUsingCurrentState(paddle)
        brickCount = 0
    }
}
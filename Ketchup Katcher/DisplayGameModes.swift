//
//  displayGameModes.swift
//  Ketchup Katcher
//
//  Created by WGonzalez on 4/26/16.
//  Copyright © 2016 Quantum Apple. All rights reserved.
//

import UIKit

class DisplayGameModes: UIViewController
{
    var classicSelected = true
    var memorySelected = false
    
    var data = DataController()
    
    @IBOutlet weak var classicButton: UIButton!
    @IBOutlet weak var memoryButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        classicButton.backgroundColor = UIColor(red: 94, green: 94, blue: 94, alpha: 0.15)
        memoryButton.backgroundColor = UIColor(red: 94, green: 94, blue: 94, alpha: 0.15)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
        if (segue.identifier == "ClassicMode")
        {
            let classicMode = segue.destinationViewController as! ViewController;
            classicMode.dataFound = data
        }
        if (segue.identifier == "ClassicMode")
        {
            let classicMode = segue.destinationViewController as! ViewController;
            classicMode.dataFound = data
        }

    }
    
    @IBAction func classicModeButton(sender: AnyObject)
    {
        classicSelected = true
        memorySelected = false
        memoryButton.highlighted = false
        classicButton.backgroundColor = UIColor(red: 94, green: 94, blue: 94, alpha: 0.05)
        memoryButton.backgroundColor = UIColor(red: 94, green: 94, blue: 94, alpha: 0.15)
    }
    
    @IBAction func memoryModeButton(sender: AnyObject)
    {
        classicSelected = false
        memorySelected = true
        memoryButton.backgroundColor = UIColor(red: 94, green: 94, blue: 94, alpha: 0.05)
        classicButton.backgroundColor = UIColor(red: 94, green: 94, blue: 94, alpha: 0.15)
    }
    
    @IBAction func returnToHome(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}

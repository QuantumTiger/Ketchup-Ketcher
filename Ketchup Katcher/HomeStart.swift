//
//  HomeStart.swift
//  Ketchup Katcher
//
//  Created by WGonzalez on 4/26/16.
//  Copyright © 2016 Quantum Apple. All rights reserved.
//

import UIKit

class HomeStart: UIViewController
{
    
    @IBOutlet weak var modeLabel: UILabel!
    
    var dataFound = DataController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        modeLabel.text = "\(dataFound.modeStored)"
    }

    @IBAction func homeStartButton(sender: AnyObject)
    {
        if dataFound.modeCheck == 0
        {
            let viewController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            
            self.presentViewController(viewController, animated: true, completion: nil)
        }
        if dataFound.modeCheck == 1
        {
            let memory = self.storyboard!.instantiateViewControllerWithIdentifier("Memory") as! Memory
            
            self.presentViewController(memory, animated: true, completion: nil)
        }
    }
}

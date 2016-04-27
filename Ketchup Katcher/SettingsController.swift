//
//  SettingsController.swift
//  Ketchup Katcher
//
//  Created by WGonzalez on 4/27/16.
//  Copyright © 2016 Quantum Apple. All rights reserved.
//

import UIKit

class SettingsController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    @IBAction func returnToModes(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }

}

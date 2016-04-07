//
//  Background.swift
//  Ketchup Katcher
//
//  Created by WGonzalez on 4/6/16.
//  Copyright © 2016 Quantum Apple. All rights reserved.
//

import Foundation
import SpriteKit

class Background: SKSpriteNode
{

    let segmentsPresent = 2
    let tileOne = UIColor.whiteColor()
    let tileTwo = UIColor.blackColor()
    
    init(size:CGSize)
    {
        super.init(texture:nil, color:UIColor.redColor(), size: CGSizeMake(size.width*2, size.height))
        anchorPoint = CGPointMake(0, 0.5)
        
        for var i = 0; i < segmentsPresent; i++
        {
            var segmentColor: UIColor!
            if i % 2 == 0
            {
                segmentColor = tileOne
            }
            else
            {
                segmentColor = tileTwo
            }
            
            let segment = SKSpriteNode(color: segmentColor, size: CGSizeMake(self.size.width / CGFloat(segmentsPresent), self.size.height))
            segment.anchorPoint = CGPointMake(0.0, 0.5)
            segment.position = CGPointMake(CGFloat(i)*segment.size.width, 0)
            addChild(segment)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }

}

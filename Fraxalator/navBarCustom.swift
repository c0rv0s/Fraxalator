//
//  navBarCustom.swift
//  Fraxalator
//
//  Created by Nathan Mueller on 7/18/16.
//  Copyright © 2016 OneNathan. All rights reserved.
//

import Foundation
import UIKit

class navBarCustom: UINavigationController {
    
    //let tintColor = UIColor(red: 1, green: 175/255, blue: 35/255, alpha: 1)
    //let del = UIApplication.sharedelegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationBar.translucent = false
        self.navigationBar.tintColor = UIColor.white

        self.navigationBar.barTintColor = UIColor.purple
        
        
        //let fontDictionary = [ NSForegroundColorAttributeName:UIColor.whiteColor() ]
        //self.navigationBar.titleTextAttributes = fontDictionary
        //self.navigationBar.setBackgroundImage(UIColor(red: 1, green: 175/255, blue: 35/255, alpha: 1), forBarMetrics: UIBarMetrics.Default)
    }
    
}

//
//  score.swift
//  Fraxalator
//
//  Created by Nathan Mueller on 6/11/16.
//  Copyright © 2016 OneNathan. All rights reserved.
//

import Foundation
import UIKit

class score: UIViewController {
    var fractalEngine : Engine!
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        textView.text = fractalEngine.output
        textView.isEditable = false
        print(fractalEngine.output ?? "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


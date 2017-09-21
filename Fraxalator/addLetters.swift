//
//  addLetters.swift
//  Fraxalator
//
//  Created by Nathan Mueller on 6/18/16.
//  Copyright © 2016 OneNathan. All rights reserved.
//

import Foundation
import UIKit

class addLetters: UIViewController {

    @IBOutlet weak var lettersField: UITextField!
    var text = ""

    var currentLetter : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lettersField.isUserInteractionEnabled = false
        lettersField.text = ""
    }
    
    @IBAction func A(_ sender: AnyObject) {

        text += "A"
        lettersField.text = text
    }
    
    @IBAction func B(_ sender: AnyObject) {

        text += "B"
        lettersField.text = text
    }
    @IBAction func C(_ sender: AnyObject) {

        text += "C"
        lettersField.text = text
    }
    @IBAction func D(_ sender: AnyObject) {

        text += "D"
        lettersField.text = text
    }
    @IBAction func E(_ sender: AnyObject) {

        text += "E"
        lettersField.text = text
    }
    @IBAction func F(_ sender: AnyObject) {

        text += "F"
        lettersField.text = text
    }
    @IBAction func G(_ sender: AnyObject) {

        text += "G"
        lettersField.text = text
    }
    
    @IBAction func dtlcya(_ sender: AnyObject) {
        if text.characters.count > 0 {
            print(text)
            text.remove(at: text.index(before: text.endIndex))
            print(text)
            lettersField.text = text
        }
    }
    
}






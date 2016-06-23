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
    var charString = [""]
    
    var currentLetter : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        lettersField.isUserInteractionEnabled = false
    }
    
    @IBAction func A(_ sender: AnyObject) {
        /*
         if charString[0] == "" {
         charString = ["G"]
         }
         else {
         charString.append("G")
         
         }
         self.text = charString.joined(separator: "")
         */
        text += "A"
        lettersField.text = text
    }
    
    @IBAction func B(_ sender: AnyObject) {
        /*
         if charString[0] == "" {
         charString = ["G"]
         }
         else {
         charString.append("G")
         
         }
         self.text = charString.joined(separator: "")
         */
        text += "B"
        lettersField.text = text
    }
    @IBAction func C(_ sender: AnyObject) {
        /*
         if charString[0] == "" {
         charString = ["G"]
         }
         else {
         charString.append("G")
         
         }
         self.text = charString.joined(separator: "")
         */
        text += "C"
        lettersField.text = text
    }
    @IBAction func D(_ sender: AnyObject) {
        /*
         if charString[0] == "" {
         charString = ["G"]
         }
         else {
         charString.append("G")
         
         }
         self.text = charString.joined(separator: "")
         */
        text += "D"
        lettersField.text = text
    }
    @IBAction func E(_ sender: AnyObject) {
        /*
         if charString[0] == "" {
         charString = ["G"]
         }
         else {
         charString.append("G")
         
         }
         self.text = charString.joined(separator: "")
         */
        text += "E"
        lettersField.text = text
    }
    @IBAction func F(_ sender: AnyObject) {
        /*
         if charString[0] == "" {
         charString = ["G"]
         }
         else {
         charString.append("G")
         
         }
         self.text = charString.joined(separator: "")
         */
        text += "F"
        lettersField.text = text
    }
    @IBAction func G(_ sender: AnyObject) {
        /*
        if charString[0] == "" {
            charString = ["G"]
        }
        else {
            charString.append("G")
            
        }
        self.text = charString.joined(separator: "")
 */
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






//
//  Score.swift
//  Fraxalator
//
//  Created by Nathanael Mueller on 3/10/20.
//  Copyright © 2020 OneNathan. All rights reserved.
//

import Foundation

struct Score {
    let letters = ["A", "B", "C", "D", "E", "F", "G"]
    var startString : String!
    var fractalScore : String!
    var rules: [String:String]
    
    init() {
        self.rules = letters.reduce(into: [:]) { dict, letter in
            dict[letter, default: ""] = ""
        }
    }
    
    //create the score
    mutating func generateScore() {
        var comp = startString
        for _ in 0...5 {
            var newComp = ""
            for character in comp! {
                newComp += rules[String(character)] ?? ""
            }
            comp = newComp
        }
        fractalScore = comp
    }
    
}

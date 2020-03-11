//
//  Score.swift
//  Fraxalator
//
//  Created by Nathanael Mueller on 3/10/20.
//  Copyright © 2020 OneNathan. All rights reserved.
//

import Foundation

struct Score {
    var letters: [String]
    var startString: String!
    var fractalScore: String!
    var rules: [String:String]
    var seed = ""
    
    init() {
        self.letters = (65...71).map({String(UnicodeScalar($0))})
        self.rules = letters.reduce(into: [:]) { dict, letter in
            dict[letter, default: ""] = ""
        }
    }
    
    //create the score
    mutating func generateScore() {
        var comp = seed
        for _ in 0...5 {
            var newComp = ""
            for char in comp {
                newComp += rules[String(char)] ?? ""
            }
            comp = newComp
        }
        fractalScore = comp
    }
    
}

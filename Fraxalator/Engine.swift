//
//  Engine.swift
//  Fraxalator
//
//  Created by Nathan Mueller on 6/9/16.
//  Copyright © 2016 OneNathan. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation
import CoreMIDI
import CoreAudio
import CoreAudioKit

var aRule : String?
var bRule : String?
var cRule : String?
var dRule : String?
var eRule : String?
var fRule : String?
var gRule : String?
var startString : String!

var fractalScore : String!
var letters = ["A", "B", "C", "D", "E", "F", "G"]

//create the score
func generateScore() {
    var comp = startString
    for _ in 0...5 {
        var newComp = ""
        for character in comp! {
            switch character {
                case "A": newComp += aRule!
                case "B": newComp += bRule!
                case "C": newComp += cRule!
                case "D": newComp += dRule!
                case "E": newComp += eRule!
                case "F": newComp += fRule!
                default: newComp += gRule!
            }
        }
        comp = newComp
    }
    fractalScore = comp
}



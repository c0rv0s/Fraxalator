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

class Engine {
    
    var aRule : String?
    var bRule : String?
    var cRule : String?
    var dRule : String?
    var eRule : String?
    var fRule : String?
    var gRule : String?
    var start : String!
    
    var output : String!
    
    //create the score
    func generate() {
        print("derp")
        self.lowerCase()
        
        var counter = 0
        var comp = start
        while counter < 5 {
            var newComp = ""
            
            for character in comp! {
                switch character {
                    case "a": newComp += self.aRule!
                    case "b": newComp += self.bRule!
                    case "c": newComp += self.cRule!
                    case "d": newComp += self.dRule!
                    case "e": newComp += self.eRule!
                    case "f": newComp += self.fRule!
                    default: newComp += self.gRule!
                }
            }
            comp = newComp
            print("\(counter) :  \(String(describing: comp))")
            
            counter += 1
        }
        if let derk = comp {
            self.output = derk
        }
        
    }
    
    //generator helper method
    func lowerCase() {
        self.aRule = aRule?.lowercased()
        self.bRule = bRule?.lowercased()
        self.cRule = cRule?.lowercased()
        self.dRule = dRule?.lowercased()
        self.eRule = eRule?.lowercased()
        self.fRule = fRule?.lowercased()
        self.gRule = gRule?.lowercased()
        self.start = start.lowercased()
    }
    
    
}


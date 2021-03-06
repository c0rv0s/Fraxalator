//
//  Score.swift
//  Fraxalator
//
//  Created by Nathanael Mueller on 3/10/20.
//  Copyright © 2020 OneNathan. All rights reserved.
//

import Foundation
import AudioToolbox

struct Score {
    var letters: [String]
    var startString: String!
    var fractalScore: String!
    var rules: [String:String]
    var seed = ""
    var iterations = 5
    var playing = false
    var paused = false
    var timestamp: MusicTimeStamp = 0
    var totalTime = 0.0
    
    var musicPlayer : MusicPlayer? = nil
    
    init() {
        self.letters = (65...71).map({String(UnicodeScalar($0))})
        self.rules = letters.reduce(into: [:]) { dict, letter in
            dict[letter, default: letter] = letter
        }
        NewMusicPlayer(&musicPlayer)
    }
    
    mutating func generateScore() {
        timestamp = 0
        var comp = seed
        for _ in 0...iterations {
            var newComp = ""
            for char in comp {
                newComp += rules[String(char)] ?? ""
            }
            comp = newComp
        }
        fractalScore = comp
    }
    
    mutating func playScore() {
        if timestamp == 0 || timestamp > totalTime {
            var sequence : MusicSequence? = nil
            NewMusicSequence(&sequence)

            var track : MusicTrack? = nil
            MusicSequenceNewTrack(sequence!, &track)
            var time = MusicTimeStamp(1.0)
            
            for noteLetter in self.fractalScore {
                var note = MIDINoteMessage(channel: 0,
                                           note: UInt8(58 + self.letters.firstIndex(of: String(noteLetter))!),
                                           velocity: 64,
                                           releaseVelocity: 0,
                                           duration: 0.5 )
                MusicTrackNewMIDINoteEvent(track!, time, &note)
                time += 0.5
            }
            totalTime = time
            NewMusicPlayer(&musicPlayer)
            MusicPlayerSetSequence(musicPlayer!, sequence)
            MusicPlayerStart(musicPlayer!)
        }
        else {
            MusicPlayerSetTime(musicPlayer!, timestamp)
            MusicPlayerStart(musicPlayer!)
        }
        playing = true
        paused = false
    }
    
    mutating func pauseScore() {
        playing = false
        paused = true
        MusicPlayerGetTime(musicPlayer!, &timestamp)
        MusicPlayerStop(musicPlayer!)
    }
    
    mutating func isPlaying() {
        MusicPlayerGetTime(musicPlayer!, &timestamp)
        if timestamp > totalTime {
            paused = false
        }
        playing = timestamp < totalTime && !paused
    }
    
}

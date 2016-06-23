//
//  MIDISampler.swift
//  Fraxalator
//
//  Created by Nathan Mueller on 6/9/16.
//  Copyright © 2016 OneNathan. All rights reserved.
//

import Foundation

import AVFoundation

class MIDISampler : NSObject {
    var engine:AVAudioEngine!
    var playerNode:AVAudioPlayerNode!
    var mixer:AVAudioMixerNode!
    var sampler:AVAudioUnitSampler!
    /// soundbanks are either dls or sf2. see http://www.sf2midi.com/
    var soundbank:NSURL!
    let melodicBank:UInt8 = UInt8(kAUSampler_DefaultMelodicBankMSB)
    /// general midi number for marimba
    let gmMarimba:UInt8 = 12
    let gmHarpsichord:UInt8 = 6
    
    override init() {
        super.init()
        initAudioEngine()
    }
    
    func initAudioEngine () {
        engine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        engine.attachNode(playerNode)
        mixer = engine.mainMixerNode
        engine.connect(playerNode, to: mixer, format: mixer.outputFormatForBus(0))
        
        // MIDI
        sampler = AVAudioUnitSampler()
        engine.attachNode(sampler)
        engine.connect(sampler, to: engine.outputNode, format: nil)
        
        soundbank = NSBundle.mainBundle().URLForResource("GeneralUser GS MuseScore v1.442", withExtension: "sf2")
        
        var error:NSError?
        if !engine.startAndReturnError(&error) {
            print("error couldn't start engine")
            if let e = error {
                print("error \(e.localizedDescription)")
            }
        }
    }
    
    func mstart(sender: AnyObject) {
        var error:NSError?
        if !sampler.loadSoundBankInstrumentAtURL(soundbank, program: gmMarimba,
                                                 bankMSB: melodicBank, bankLSB: 0, error: &error) {
            print("could not load soundbank")
        }
        if let e = error {
            print("error \(e.localizedDescription)")
        }
        
        self.sampler.sendProgramChange(gmMarimba, bankMSB: 0x79, bankLSB: 0, onChannel: 0)
        self.sampler.startNote(60, withVelocity: 64, onChannel: 0)
    }
    
    func hstart(sender: AnyObject) {
        var error:NSError?
        if !sampler.loadSoundBankInstrumentAtURL(soundbank, program: gmHarpsichord,
                                                 bankMSB: melodicBank, bankLSB: 0, error: &error) {
            print("could not load soundbank")
        }
        if let e = error {
            print("error \(e.localizedDescription)")
        }
        self.sampler.sendProgramChange(gmHarpsichord, bankMSB: melodicBank, bankLSB: 0, onChannel: 0)
        self.sampler.startNote(65, withVelocity: 64, onChannel: 0)
    }
    
    func mstop(sender: AnyObject) {
        self.sampler.sendProgramChange(gmMarimba, bankMSB: melodicBank, bankLSB: 0, onChannel: 0)
        self.sampler.stopNote(60, onChannel: 0)
    }
    
    func hstop(sender: AnyObject) {
        self.sampler.sendProgramChange(gmHarpsichord, bankMSB: melodicBank, bankLSB: 0, onChannel: 0)
        self.sampler.stopNote(65, onChannel: 0)
    }
}
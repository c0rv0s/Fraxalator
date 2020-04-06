//
//  Sampler1.swift
//  Fraxalator
//
//  Created by Nathan Mueller on 6/9/16.
//  Copyright © 2016 OneNathan. All rights reserved.
//

import AVFoundation
import Foundation
import CoreMIDI
import CoreAudio
import CoreAudioKit


class Sampler1 : NSObject {
    var engine: AVAudioEngine!
    
    var sampler: AVAudioUnitSampler!
    var sequencer:AVAudioSequencer!
    
    override init() {
        super.init()
        
        engine = AVAudioEngine()
        
        sampler = AVAudioUnitSampler()
        engine.attachNode(sampler)
        engine.connect(sampler, to: engine.mainMixerNode, format: nil)
        
        loadSF2PresetIntoSampler(0)
        
        addObservers()
        
        setSessionPlayback()
        
        //setupSequencer()
        //playSeq()
    }
    
/*func initAudio(){
 
 let engine = AVAudioEngine()
 self.sampler = AVAudioUnitSampler()
 engine.attachNode(self.sampler!)
 engine.connect(self.sampler!, to: engine.outputNode, format: nil)
 
 guard let soundbank = NSBundle.mainBundle().URLForResource("gs_instruments", withExtension: "dls") else {
 
 print("Could not initalize soundbank.")
 return
 }
 
 let melodicBank:UInt8 = UInt8(kAUSampler_DefaultMelodicBankMSB)
 let gmHarpsichord:UInt8 = 6
 do {
 
 try self.sampler!.loadSoundBankInstrumentAtURL(soundbank, program: gmHarpsichord, bankMSB: melodicBank, bankLSB: 0)
 
 }catch {
 print("An error occurred \(error)")
 return
 }
 
 self.sampler!.startNote(60, withVelocity: 64, onChannel: 0)
 }
 */

        func loadSF2PresetIntoSampler(preset:UInt8)  {
 
            guard let bankURL = NSBundle.mainBundle().URLForResource("muse", withExtension: "sf2") else {
                print("could not load sound font")
                return
            }
            
            do {
                 startEngine()
                try self.sampler.loadSoundBankInstrumentAtURL(bankURL,
                                                              program: preset,
                                                              bankMSB: UInt8(kAUSampler_DefaultMelodicBankMSB),
                                                              bankLSB: UInt8(kAUSampler_DefaultBankLSB))
            } catch {
                print("error loading sound bank instrument")
            }
        }

        func play() {
            print("playing")
            sampler.startNote(60, withVelocity: 64, onChannel: 0)
        }
        
        func stop() {
            sampler.stopNote(60, onChannel: 0)
        }

        func addObservers() {
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector:"engineConfigurationChange:",
                                                             name:AVAudioEngineConfigurationChangeNotification,
                                                             object:engine)
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector:"sessionInterrupted:",
                                                             name:AVAudioSessionInterruptionNotification,
                                                             object:engine)
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector:"sessionRouteChange:",
                                                             name:AVAudioSessionRouteChangeNotification,
                                                             object:engine)
        }
        
        func removeObservers() {
            NSNotificationCenter.defaultCenter().removeObserver(self,
                                                                name: AVAudioEngineConfigurationChangeNotification,
                                                                object: nil)
            
            NSNotificationCenter.defaultCenter().removeObserver(self,
                                                                name: AVAudioSessionInterruptionNotification,
                                                                object: nil)
            
            NSNotificationCenter.defaultCenter().removeObserver(self,
                                                                name: AVAudioSessionRouteChangeNotification,
                                                                object: nil)
        }

        func startEngine() {
            if engine.running {
                print("audio engine already started")
                return
            }
            
            do {
                try engine.start()
                print("audio engine started")
            } catch {
                print("oops \(error)")
                print("could not start audio engine")
            }
        }
        
        func setSessionPlayback() {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try
                    audioSession.setCategory(AVAudioSessionCategoryPlayback, withOptions:
                        AVAudioSessionCategoryOptions.MixWithOthers)
            } catch {
                print("couldn't set category \(error)")
                return
            }
            
            do {
                try audioSession.setActive(true)
            } catch {
                print("couldn't set category active \(error)")
                return
            }
        }
    
    func setupSequencer() {
        
        self.sequencer = AVAudioSequencer(audioEngine: self.engine)
        
        let options = AVMusicSequenceLoadOptions.SMF_PreserveTracks
        if let fileURL = NSBundle.mainBundle().URLForResource("muse", withExtension: "sf2") {
            do {
                try sequencer.loadFromURL(fileURL, options: options)
                print("loaded \(fileURL)")
            } catch {
                print("something screwed up \(error)")
                return
            }
        }
        sequencer.prepareToPlay()
    }
    
    func playSeq() {
        if sequencer.playing {
            stop()
        }
        
        sequencer.currentPositionInBeats = NSTimeInterval(0)
        
        do {
            try sequencer.start()
        } catch {
            print("cannot start \(error)")
        }
    }
    
    func stopSeq() {
        sequencer.stop()
    }
}
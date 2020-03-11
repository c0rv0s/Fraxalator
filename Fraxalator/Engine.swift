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

//midi setup
var engine = AVAudioEngine()
var sampler = AVAudioUnitSampler()

// this one is from a midi file
var midiPlayer:AVMIDIPlayer?

var midiPlayerFromData:AVMIDIPlayer?
var musicPlayer:MusicPlayer?
var soundbank:URL?
let soundFontMuseCoreName = "GeneralUser GS MuseScore v1.442"

//pick instument
var pickerData: [String] = ["1"]
var selectedMelody = 81

var musicSequence:MusicSequence!

// instance variables
let melodicBank = UInt8(kAUSampler_DefaultMelodicBankMSB)
let defaultBankLSB = UInt8(kAUSampler_DefaultBankLSB)
let gmMarimba = UInt8(12)
let gmHarpsichord = UInt8(6)

//audio engine type stuff
func playScore(score: Score) {
    //inside your playButton
    let delayConstant = 0.2
    for (noteNumber, note) in score.fractalScore.enumerated() {
        delay(delayConstant * Double(noteNumber)) {
            let n = UInt8(58 + score.letters.firstIndex(of: String(note))!)
            play(n)
            delay(delayConstant) {stop(n)}
        }
    }
}

func play(_ note: UInt8) {
    sampler.startNote(note, withVelocity: 64, onChannel: 0)
}

func stop(_ note: UInt8) {
    sampler.stopNote(note, onChannel: 0)
}

//global delay helper function
func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
        closure()
    }
}

func initAudio(){
    
     engine = AVAudioEngine()
     sampler = AVAudioUnitSampler()
     engine.attach(sampler)
     engine.connect(sampler, to: engine.outputNode, format: nil)
     
    guard let soundbank = Bundle.main.url(forResource: "gs_instruments", withExtension: "dls") else {
     
        print("Could not initalize soundbank.")
        return
     }
     
     let melodicBank:UInt8 = UInt8(kAUSampler_DefaultMelodicBankMSB)
     let gmHarpsichord:UInt8 = UInt8(selectedMelody)
     do {
        try engine.start()
        try sampler.loadSoundBankInstrument(at: soundbank, program: gmHarpsichord, bankMSB: melodicBank, bankLSB: 0)
     
     }catch {
        print("An error occurred \(error)")
        return
     }
}

//midi stuff
func createAVMIDIPlayer(_ musicSequence:MusicSequence) {
    
    guard let bankURL = Bundle.main.url(forResource: "GeneralUser GS MuseScore v1.442", withExtension: "sf2") else {
        fatalError("\"GeneralUser GS MuseScore v1.442.sf2\" file not found.")
    }
    
    
    var status = OSStatus(noErr)
    var data:Unmanaged<CFData>?
    status = MusicSequenceFileCreateData (musicSequence,
                                          MusicSequenceFileTypeID.midiType,
                                          MusicSequenceFileFlags.eraseFile,
                                          480, &data)
    
    if status != OSStatus(noErr) {
        print("bad status \(status)")
    }
    
    if let md = data {
        let midiData = md.takeUnretainedValue() as Data
        do {
            try midiPlayerFromData = AVMIDIPlayer(data: midiData, soundBankURL: bankURL)
            print("created midi player with sound bank url \(bankURL)")
        } catch let error as NSError {
            print("nil midi player")
            print("Error \(error.localizedDescription)")
        }
        data?.release()
        
        midiPlayerFromData?.prepareToPlay()
    }
    
}

func createAVMIDIPlayerFromMIDIFIle() {
    
    guard let midiFileURL = Bundle.main.url(forResource: "sibeliusGMajor", withExtension: "mid") else {
        fatalError("\"sibeliusGMajor.mid\" file not found.")
    }
    guard let bankURL = Bundle.main.url(forResource: "GeneralUser GS MuseScore v1.442", withExtension: "sf2") else {
        fatalError("\"GeneralUser GS MuseScore v1.442.sf2\" file not found.")
    }
    
    do {
        try midiPlayer = AVMIDIPlayer(contentsOf: midiFileURL, soundBankURL: bankURL)
        print("created midi player with sound bank url \(bankURL)")
    } catch let error as NSError {
        print("Error \(error.localizedDescription)")
    }
    
    midiPlayer?.prepareToPlay()
    //setupSlider()
}

func playWithMusicPlayer() {
    musicPlayer = createMusicPlayer(musicSequence)
    playMusicPlayer()
}

func createMusicPlayer(_ musicSequence:MusicSequence) -> MusicPlayer {
    var musicPlayer:MusicPlayer? = nil
    var status = OSStatus(noErr)
    status = NewMusicPlayer(&musicPlayer)
    if status != OSStatus(noErr) {
        print("bad status \(status) creating player")
    }
    status = MusicPlayerSetSequence(musicPlayer!, musicSequence)
    if status != OSStatus(noErr) {
        print("setting sequence \(status)")
    }
    status = MusicPlayerPreroll(musicPlayer!)
    if status != OSStatus(noErr) {
        print("prerolling player \(status)")
    }
    return musicPlayer!
}

func playMusicPlayer() {
    var status = OSStatus(noErr)
    var playing:DarwinBoolean = false
    status = MusicPlayerIsPlaying(musicPlayer!, &playing)
    if playing != false {
        print("music player is playing. stopping")
        status = MusicPlayerStop(musicPlayer!)
        if status != OSStatus(noErr) {
            print("Error stopping \(status)")
            return
        }
    } else {
        print("music player is not playing.")
    }
    
    status = MusicPlayerSetTime(musicPlayer!, 0)
    if status != OSStatus(noErr) {
        print("setting time \(status)")
        return
    }
    
    status = MusicPlayerStart(musicPlayer!)
    if status != OSStatus(noErr) {
        print("Error starting \(status)")
        return
    }
}



func createMusicSequence() -> MusicSequence {
    // create the sequence
    var musicSequence:MusicSequence? = nil
    var status = NewMusicSequence(&musicSequence)
    if status != OSStatus(noErr) {
        print("\(#line) bad status \(status) creating sequence")
    }
    
    var tempoTrack:MusicTrack? = nil
    if MusicSequenceGetTempoTrack(musicSequence!, &tempoTrack) != noErr {
        assert(tempoTrack != nil, "Cannot get tempo track")
    }
    //MusicTrackClear(tempoTrack, 0, 1)
    if MusicTrackNewExtendedTempoEvent(tempoTrack!, 0.0, 128.0) != noErr {
        print("could not set tempo")
    }
    if MusicTrackNewExtendedTempoEvent(tempoTrack!, 4.0, 256.0) != noErr {
        print("could not set tempo")
    }
    
    
    // add a track
    var track:MusicTrack? = nil
    status = MusicSequenceNewTrack(musicSequence!, &track)
    if status != OSStatus(noErr) {
        print("error creating track \(status)")
    }
    
    // bank select msb
    var chanmess = MIDIChannelMessage(status: 0xB0, data1: 0, data2: 0, reserved: 0)
    status = MusicTrackNewMIDIChannelEvent(track!, 0, &chanmess)
    if status != OSStatus(noErr) {
        print("creating bank select event \(status)")
    }
    // bank select lsb
    chanmess = MIDIChannelMessage(status: 0xB0, data1: 32, data2: 0, reserved: 0)
    status = MusicTrackNewMIDIChannelEvent(track!, 0, &chanmess)
    if status != OSStatus(noErr) {
        print("creating bank select event \(status)")
    }
    
    // program change. first data byte is the patch, the second data byte is unused for program change messages.
    chanmess = MIDIChannelMessage(status: 0xC0, data1: 0, data2: 0, reserved: 0)
    status = MusicTrackNewMIDIChannelEvent(track!, 0, &chanmess)
    if status != OSStatus(noErr) {
        print("creating program change event \(status)")
    }
    
    // now make some notes and put them on the track
    var beat:MusicTimeStamp = 0.0
    for i:UInt8 in 60...72 {
        var mess = MIDINoteMessage(channel: 0,
                                   note: i,
                                   velocity: 64,
                                   releaseVelocity: 0,
                                   duration: 1.0 )
        status = MusicTrackNewMIDINoteEvent(track!, beat, &mess)
        if status != OSStatus(noErr) {
            print("creating new midi note event \(status)")
        }
        beat += 1
    }
    
    CAShow(UnsafeMutablePointer<MusicSequence>(musicSequence!))
    
    return musicSequence!
}
//end MIDI stuff


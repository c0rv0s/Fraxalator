//
//  FirstViewController.swift
//  Fraxalator
//
//  Created by Nathan Mueller on 6/9/16.
//  Copyright © 2016 OneNathan. All rights reserved.
//

import UIKit
import AVFoundation

class FirstViewController: UITableViewController {
    
    //store instance
    var fractalEngine : Engine!
    
    //store working letter
    var currentLetter : String!
    
    @IBOutlet weak var instrumentField: UITextField!
    
    //individual references
    @IBOutlet weak var scoreButton: UIBarButtonItem!
    @IBOutlet weak var A: UITextField!
    @IBOutlet weak var B: UITextField!
    @IBOutlet weak var C: UITextField!
    @IBOutlet weak var D: UITextField!
    @IBOutlet weak var E: UITextField!
    @IBOutlet weak var F: UITextField!
    @IBOutlet weak var G: UITextField!
    
    @IBOutlet weak var playbutton: UIButton!
    
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
    
    @IBOutlet weak var start: UITextField!
    
    var selectedSet = 8
    
    override func viewDidLoad() {
        var num = 2
        while num < 129 {
            let entry  = String(num)
            print(entry)
            pickerData.append(entry)
            num += 1
        }
        print(pickerData)
        
        super.viewDidLoad()

        A.isUserInteractionEnabled = false
        B.isUserInteractionEnabled = false
        C.isUserInteractionEnabled = false
        D.isUserInteractionEnabled = false
        E.isUserInteractionEnabled = false
        F.isUserInteractionEnabled = false
        G.isUserInteractionEnabled = false
        instrumentField.isUserInteractionEnabled = false
        start.isUserInteractionEnabled = false
        
        playbutton.isHidden = true
        scoreButton.isEnabled = false
        initAudio()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func cancelFirstViewController(_ segue:UIStoryboardSegue) {
        
        if let addLetters = segue.source as? addLetters {
            if addLetters.text == "" {}
            else {
                if addLetters.currentLetter == "A" {
                    A.text = addLetters.text
                }
                if addLetters.currentLetter == "B" {
                    B.text = addLetters.text
                }
                if addLetters.currentLetter == "C" {
                    C.text = addLetters.text
                }
                if addLetters.currentLetter == "D" {
                    D.text = addLetters.text
                }
                if addLetters.currentLetter == "E" {
                    E.text = addLetters.text
                }
                if addLetters.currentLetter == "F" {
                    F.text = addLetters.text
                }
                if addLetters.currentLetter == "G" {
                    G.text = addLetters.text
                }
                if addLetters.currentLetter == "start" {
                    start.text = addLetters.text
                }
            }
        }
        
        if let pickInstrument = segue.source as? pickInstrument {
            self.selectedSet = pickInstrument.selectedSet

        }
    }

    @IBAction func generate(_ sender: AnyObject) {
        if start.text == "" {
            let alertController = UIAlertController(title: "Alert", message:
                "Please enter a starting sequence", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
        else {
            fractalEngine = Engine()
            fractalEngine.aRule = A.text
            fractalEngine.bRule = B.text
            fractalEngine.cRule = C.text
            fractalEngine.dRule = D.text
            fractalEngine.eRule = E.text
            fractalEngine.fRule = F.text
            fractalEngine.gRule = G.text
            fractalEngine.start = start.text
            fractalEngine.generate()
            playbutton.isHidden = false
            scoreButton.isEnabled = true
        }
    }
    
    
    @IBAction func styleButton(_ sender: AnyObject) {
        
    }
    
    @IBAction func playButton(_ sender: AnyObject) {

        let notes = Array(fractalEngine.output!.characters)

            //inside your playButton
            let delayConstant = 0.35 //customize as needed
            
            for (noteNumber, note) in notes.enumerated() {
                delay(delayConstant * Double(noteNumber)) {
                    //var note = notes[counter]
                    if note == "a" {
                        self.play(58)
                        self.delay(delayConstant) {self.stop(58)}
                        print("play")
                    }
                    else if note == "b" {
                        self.play(59)
                        self.delay(delayConstant) {self.stop(59)}
                        print("play")
                    }
                    else if note == "c" {
                        self.play(60)
                        self.delay(delayConstant) {self.stop(60)}
                        print("play")
                    }
                    else if note == "d" {
                        self.play(61)
                        self.delay(delayConstant) {self.stop(61)}
                        print("play")
                    }
                    else if note == "e" {
                        self.play(62)
                        self.delay(delayConstant) {self.stop(62)}
                        print("play")
                    }
                    else if note == "f" {
                        self.play(63)
                        self.delay(delayConstant) {self.stop(63)}
                        print("play")
                    }
                    else {
                        self.play(64)
                        self.delay(delayConstant) {self.stop(64)}
                        print("play")
                    }

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
         self.sampler = AVAudioUnitSampler()
         engine.attach(self.sampler)
         engine.connect(self.sampler, to: engine.outputNode, format: nil)
         
        guard let soundbank = Bundle.main.url(forResource: "gs_instruments", withExtension: "dls") else {
         
            print("Could not initalize soundbank.")
            return
         }
         
         let melodicBank:UInt8 = UInt8(kAUSampler_DefaultMelodicBankMSB)
         let gmHarpsichord:UInt8 = UInt8(selectedMelody)
         do {
            try engine.start()
            try self.sampler.loadSoundBankInstrument(at: soundbank, program: gmHarpsichord, bankMSB: melodicBank, bankLSB: 0)
         
         }catch {
            print("An error occurred \(error)")
            return
         }
    }
    
    
    @IBAction func viewScore(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "scoreSegue", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath as NSIndexPath).row == 8 {
            self.performSegue(withIdentifier: "instrumentSegue", sender: self)
        }
        else {
            if (indexPath as NSIndexPath).row == 0 {
                self.currentLetter = "A"
            }
            if (indexPath as NSIndexPath).row == 1 {
                self.currentLetter = "B"
            }
            if (indexPath as NSIndexPath).row == 2 {
                self.currentLetter = "C"
            }
            if (indexPath as NSIndexPath).row == 3 {
                self.currentLetter = "D"
            }
            if (indexPath as NSIndexPath).row == 4 {
                self.currentLetter = "E"
            }
            if (indexPath as NSIndexPath).row == 5 {
                self.currentLetter = "F"
            }
            if (indexPath as NSIndexPath).row == 6 {
                self.currentLetter = "G"
            }
            if (indexPath as NSIndexPath).row == 7 {
                self.currentLetter = "start"
            }
            
            self.performSegue(withIdentifier: "addLettersSegue", sender: self)
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue?, sender: Any?) {
        if (segue!.identifier == "scoreSegue") {
            let viewController:score = segue!.destination as! score
            viewController.fractalEngine = self.fractalEngine!
        }
        if (segue!.identifier == "addLettersSegue") {
            let viewController:addLetters = segue!.destination as! addLetters
            viewController.currentLetter = self.currentLetter
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
                try self.midiPlayerFromData = AVMIDIPlayer(data: midiData, soundBankURL: bankURL)
                print("created midi player with sound bank url \(bankURL)")
            } catch let error as NSError {
                print("nil midi player")
                print("Error \(error.localizedDescription)")
            }
            data?.release()
            
            self.midiPlayerFromData?.prepareToPlay()
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
            try self.midiPlayer = AVMIDIPlayer(contentsOf: midiFileURL, soundBankURL: bankURL)
            print("created midi player with sound bank url \(bankURL)")
        } catch let error as NSError {
            print("Error \(error.localizedDescription)")
        }
        
        self.midiPlayer?.prepareToPlay()
        //setupSlider()
    }
    
    func playWithMusicPlayer() {
        self.musicPlayer = createMusicPlayer(self.musicSequence)
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


}


//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Joey  Baker on 4/2/18.
//  Copyright © 2018 Waterfield. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    var audioRecorder : AVAudioRecorder!
    
    var recordedAudioURL:URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    @IBAction func recordAudio(_ sender: Any) {
        print("Record Button pressed")
        recordingLabel.text = "Recording in process"
        stopRecordButton.isEnabled = true
        recordButton.isEnabled = false
        
        //get the file path
        let dirParh = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) [0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirParh, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    @IBAction func stopRecording(_ sender: Any) {
        print("Stop recording button pressed")
        stopRecordButton.isEnabled = false
        recordButton.isEnabled = true
        recordingLabel.text = "tap to record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finished recording")
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVc = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVc.recordedAudioUrl = recordedAudioURL
        }
    }
}


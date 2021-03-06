//
//  AudioView.swift
//  RNIosUiCompoment
//
//  Created by bruno.nascimento on 28/01/21.
//

import Foundation
import AVFoundation

@objc(AudioView)
class AudioView: UIView, RCTBridgeModule, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
  
  static func moduleName() -> String! {
    return "AudioM"
  }
  
  var recordBtn: UIButton! = UIButton()
  var playBtn: UIButton! = UIButton()
  
  var recordingSession: AVAudioSession!
  var soundRecorder: AVAudioRecorder!
  var soundPlayer: AVAudioPlayer!
  var captureDevice : AVCaptureDevice?
  
  
  var fileName: String = "audiofile_2.m4a"
  
  @objc func onFinishCallback(_ callback: RCTResponseSenderBlock) {
    callback([NSNull(), [ "file": fileName]])
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    recordingSession = AVAudioSession.sharedInstance()

    do {
        try recordingSession.setCategory(.playAndRecord, mode: .default)
        try recordingSession.setActive(true)
        recordingSession.requestRecordPermission() { [unowned self] allowed in
            DispatchQueue.main.async {
                if allowed {
                    self.setupView()
                } else {
                    // failed to record!
                }
            }
        }
    } catch {
        // failed to record!
    }
    
    setupRecorder()
    playBtn.isEnabled = false
  }
  
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    
//    print(paths)
    //        let paths = URL(fileURLWithPath: NSTemporaryDirectory())
    //      let paths =  NSURL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
    
    return paths[0]
  }
  
  func setupView(){
    
    
    recordBtn.setTitle("Record", for: .normal )
    recordBtn.translatesAutoresizingMaskIntoConstraints = false
    recordBtn.addTarget(self, action: #selector(self.recordAction(_:)), for: .touchUpInside)
    
    
    playBtn.setTitle("Play", for: .normal )
    playBtn.translatesAutoresizingMaskIntoConstraints = false
    playBtn.addTarget(self, action: #selector(self.playAction(_:)), for: .touchUpInside)
    
    
    //    let stackView = UIStackView(arrangedSubviews: [recordBtn, playBtn])
    //    self.addSubview(stackView)
    
    
    self.addSubview(playBtn)
    self.addSubview(recordBtn)
    
    NSLayoutConstraint.activate([
      
      recordBtn.topAnchor.constraint(equalTo: self.centerYAnchor),
      recordBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      
      playBtn.topAnchor.constraint(equalTo: self.centerYAnchor, constant: 40),
      playBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor),
      
      
    ])
  }
  
  
  
  
  
  func setupRecorder() {
    let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
      
//    try? FileManager.default.removeItem(at: audioFilename)
    
    
    let recordSetting = [
      AVFormatIDKey: kAudioFormatAppleLossless,
      AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
      AVEncoderBitRateKey: 320000, AVNumberOfChannelsKey: 2,
      AVSampleRateKey: 44100.2 ] as [String: Any]

//    let recordSetting = [
//           AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
//           AVSampleRateKey: 12000,
//           AVNumberOfChannelsKey: 1,
//           AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
//       ]
    
    
    do {
      soundRecorder = try AVAudioRecorder(url: audioFilename, settings: recordSetting)
      soundRecorder.delegate = self
      soundRecorder.prepareToRecord()
      
    } catch {
      print(error)
    }
  }
  
  func setupPlayer() {
    let audioFilename = getDocumentsDirectory().appendingPathComponent(fileName)
    
    print("===============")
    print(NSURL(fileURLWithPath :audioFilename.path))
    print(audioFilename.path)
    
    
    let a = AudioEventEmitter()
        a.notifiyRN("onStop", parameters: ["file": audioFilename.path])
    
    do {

      soundPlayer = try AVAudioPlayer(contentsOf: audioFilename)
      soundPlayer.delegate = self
      soundPlayer.prepareToPlay()
      soundPlayer.volume = 10.0
      
    } catch {
        print(error)
    }
  }
  
  
  @IBAction func recordAction(_ sender: UIButton){
    if recordBtn.titleLabel?.text == "Record" {
      soundRecorder.record()
      recordBtn.setTitle("Stop", for: .normal)
      playBtn.isEnabled = false
    } else {
      soundRecorder.stop()
      recordBtn.setTitle("Record", for: .normal)
      playBtn.isEnabled = true
    }
  }
  
  @IBAction func playAction(_ sender: UIButton) {
    
    if playBtn.titleLabel?.text == "Play" {
      playBtn.setTitle("Stop", for: .normal)
      recordBtn.isEnabled = false
      setupPlayer()
      soundPlayer.play()
    } else {
      playBtn.setTitle("Play", for: .normal)
      soundPlayer.stop()
      recordBtn.isEnabled = true
    }
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init has not been implemented")
  }
  
}

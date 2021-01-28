//
//  AudioView.swift
//  RNIosUiCompoment
//
//  Created by bruno.nascimento on 28/01/21.
//

import Foundation
import AVFoundation

class AudioView: UIView, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
  
  var recordBtn: UIButton! = UIButton()
  var playBtn: UIButton! = UIButton()
  
  var soundRecorder: AVAudioRecorder!
  var soundPlayer: AVAudioPlayer!
  
  var fileName: String = "audiofile.m4a"
  
  
//  var fileName: String = "audiofile.m4a"
  
  override init(frame: CGRect) {
    super.init(frame: frame)
      
    print("inittt")
  
    setupView()
    setupRecorder()
    playBtn.isEnabled = false
  }
  
  func getDocumentsDirectory() -> URL {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
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

      let recordSetting = [
          AVFormatIDKey: kAudioFormatAppleLossless,
          AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
          AVEncoderBitRateKey: 320000, AVNumberOfChannelsKey: 2,
          AVSampleRateKey: 44100.2 ] as [String: Any]

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
        print("Record")
      
        soundRecorder.record()
        recordBtn.setTitle("Stop", for: .normal)
        playBtn.isEnabled = false
    } else {
        print("stop")
        soundRecorder.stop()
        recordBtn.setTitle("Record", for: .normal)
        playBtn.isEnabled = true
    }
  }

  @IBAction func playAction(_ sender: UIButton) {
        
      if playBtn.titleLabel?.text == "Play" {
          print("play")
          playBtn.setTitle("Stop", for: .normal)
          recordBtn.isEnabled = false
          setupPlayer()
          soundPlayer.play()
      } else {
          print("stop playing")
          playBtn.setTitle("Play", for: .normal)
          soundPlayer.stop()
          recordBtn.isEnabled = true
      }
  }

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init has not been implemented")
  }
  
}

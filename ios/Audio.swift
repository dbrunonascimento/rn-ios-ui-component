//
//  Audio.swift
//  RNIosUiCompoment
//
//  Created by bruno.nascimento on 28/01/21.
//

import Foundation

@objc(Audio)
class Audio: RCTViewManager {

  override func view() -> UIView! {
    return AudioView()
  }
  
  var fileName: String = "audiofile.m4a"
  
  @objc func onStopRecoding(_ callback: RCTResponseSenderBlock) {
    callback([NSNull(), [ "file": fileName]])
  }
  
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
}

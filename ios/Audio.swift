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
  
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
}

//
//  AudioEventEmitter.swift
//  RNIosUiCompoment
//
//  Created by bruno.nascimento on 28/01/21.
//

import Foundation


@objc(AudioEventEmitter)
class AudioEventEmitter: RCTEventEmitter {
    
  @objc func showFile() {
    print("Emitindo..... ")
    sendEvent(withName: "onStop", body: ["file": "===========file========="])
  }

  // A sobrescrita desse metodo prepara a listagem dos nome eventos que podem
  // ser escutados.
  override func supportedEvents() -> [String]! {
    return ["onStop"]
  }
  
  // you also need to add the override attribute
  // on these methods
//  override func constantsToExport() {
//
//  }
//  override static func requiresMainQueueSetup() {
//      return true
//  }
  
  
  override func startObserving() {
          NotificationCenter.default.addObserver(self, selector: #selector(emitEventInternal(_:)), name: NSNotification.Name(rawValue: "event-emitted"), object: nil)
      }
      
  override func stopObserving() {
      NotificationCenter.default.removeObserver(self)
  }
  
  @objc func emitEventInternal(_ notification: NSNotification)  {
      let eventName: String = notification.userInfo?["eventName"] as! String
      print("send event to RN: \(self.bridge) \(eventName) \(notification.userInfo)")
      self.sendEvent(withName: eventName, body: notification.userInfo)
  }

  @objc func notifiyRN(_ eventName: String, parameters: [String: Any] = [:] ) {
      var newParams: [String: Any] = parameters
      newParams["eventName"] = eventName
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: "event-emitted"), object: self, userInfo: newParams)
  }

  
  @objc
    override func constantsToExport() -> [AnyHashable: Any]! {
      return [
        "initialValue" : 0
      ]
    }
  
  @objc
    override static func requiresMainQueueSetup() -> Bool {
      return true
    }
  
}






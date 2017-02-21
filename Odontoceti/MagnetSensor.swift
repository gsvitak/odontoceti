//
//  MagnetSensor.swift
//  Odontoceti
//
//  Created by Gregory Foster on 2/20/17.
//  Copyright © 2017 Greg M Foster. All rights reserved.
//

import UIKit
import CoreLocation
import CoreMotion

class MagnetSensor: NSObject, CLLocationManagerDelegate {
  
  public static var updateNotificationName = Notification.Name(rawValue: "MagnetUpdate")
  static let sharedSensor = MagnetSensor()
  
  var gyroX: Double = 0.0
  var gyroY: Double = 0.0
  var gyroZ: Double = 0.0
  
  private let locationManager = CLLocationManager()
  private let motionManager = CMMotionManager()
  
  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.startUpdatingHeading()
    motionManager.startGyroUpdates(to: OperationQueue.main, withHandler: {gyroData, error in
      if let data = gyroData {
        self.gyroX = data.rotationRate.x
        self.gyroY = data.rotationRate.y
        self.gyroZ = data.rotationRate.z
      }
    })
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    let x = newHeading.x
    let y = newHeading.y
    let z = newHeading.z
    let mag = pow(pow(x, 2.0) + pow(y, 2.0) + pow(z, 2.0), 0.5)
    print(mag, gyroX, gyroY, gyroZ)
    NotificationCenter.default.post(name: MagnetSensor.updateNotificationName,
                                    object: nil,
                                    userInfo: ["value": mag])
  }
}

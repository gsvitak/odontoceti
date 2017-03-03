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

  var pitch: Double = 0.0
  var roll: Double = 0.0
  var yaw: Double = 0.0

  var mags = [Double]()
  var adjustedMags = [Double]()

  private let locationManager = CLLocationManager()
  private let motionManager = CMMotionManager()

  override init() {
    super.init()
    locationManager.delegate = self
//    motionManager.deviceMotionUpdateInterval = TimeInterval(0.02)
    locationManager.startUpdatingHeading()
    motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical,
                                           to: OperationQueue.main,
                                           withHandler: {motionData, error in
      let x = motionData?.magneticField.field.x
      let y = motionData?.magneticField.field.y
      let z = motionData?.magneticField.field.z
      if let x = x, let y = y, let z = z {
        let mag = pow(pow(x, 2.0) + pow(y, 2.0) + pow(z, 2.0), 0.5)
        NotificationCenter.default.post(name: MagnetSensor.updateNotificationName,
                                        object: nil,
                                        userInfo: ["value": mag])
      }
    })
  }

  private func updateVar(value: Double, ray: inout [Double]) -> Double {
    ray.append(value)
    if ray.count > 100 {
      ray.remove(at: 0)
    }
    let mean = Double(ray.reduce(0, +)) / Double(ray.count)
    let meanDifSquared = ray.reduce(0, {$0 + pow($1 - mean, 2)})
    let variance = meanDifSquared / Double(ray.count - 1)
    return variance
  }

  private func adjustMagnitude(mag: Double, pitch: Double, roll: Double, yaw: Double) -> Double {
    var adjustment = 0.0
    adjustment += -0.04526799 * pitch
    adjustment += 0.001717629 * roll
    adjustment += 0.002146705 * yaw
    adjustment += 0.000481678 * pitch * pitch
    adjustment += 0.000026555 * roll * roll
    adjustment += -0.00001342 * yaw * yaw
    return mag + adjustment
  }
}

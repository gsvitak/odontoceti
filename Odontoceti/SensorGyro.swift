//
//  SensorGyro.swift
//  Odontoceti
//
//  Created by Gregory Foster on 2/12/17.
//  Copyright © 2017 Greg M Foster. All rights reserved.
//

import Foundation

class SensorGyro: NSObject, SensorTableViewCellDataSource {
  public var sensorTitle: String {
    return "Gyroscope"
  }
  
  public var sensorData: NSNumber {
    return NSNumber(value: 31231.22)
  }
  
  // Capture gyro data
  public func startDataCapture() {
    manager.startGyroUpdates(to: OperationQueue.main, withHandler: {gyroData, error in
      if let data = gyroData {
        self.motionStream.addGyro(time: data.timestamp,
        x: CGFloat(data.rotationRate.x),
        y: CGFloat(data.rotationRate.y),
        z: CGFloat(data.rotationRate.z),
        point: self.touchLocation)
        
      }
    })
  }
}

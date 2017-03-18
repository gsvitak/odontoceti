//
//  MagnetDataSource.swift
//  Odontoceti
//
//  Created by Gregory Foster on 2/20/17.
//  Copyright © 2017 Greg M Foster. All rights reserved.
//

import UIKit
import CoreMotion


/// The the store of information about the current magnetic readings from the phone.
class MagnetDataSource: NSObject {

    /// The name for the notification which contains the latest measured magnet magnitude.
    public static var updateNotificationName = Notification.Name(rawValue: "MagnetUpdate")

    /// The class singleton.
    static let sharedSensor = MagnetDataSource()

    /// The manager which tracks and provides measurements from the magnet which are then passed on.
    private let motionManager = CMMotionManager()

    override init() {
        super.init()
//        motionManager.deviceMotionUpdateInterval = TimeInterval(0.02)
        motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical,
                                               to: OperationQueue.main,
                                               withHandler: {motionData, error in
            let x = motionData?.magneticField.field.x
            let y = motionData?.magneticField.field.y
            let z = motionData?.magneticField.field.z
            if let x = x, let y = y, let z = z {
                let mag = pow(pow(x, 2.0) + pow(y, 2.0) + pow(z, 2.0), 0.5)
                NotificationCenter.default.post(name: MagnetDataSource.updateNotificationName,
                                                object: nil,
                                                userInfo: ["value": mag])
            }
        })
    }
}

//
//  DeadReckoningModel.swift
//  Odontoceti
//
//  Created by Gregory Foster on 3/19/17.
//  Copyright © 2017 Greg M Foster. All rights reserved.
//

import UIKit

class DeadReckoningModel: NSObject {

    /// The current dead reckoning estimation for the user location.
    public var currentLocation = CGPoint(x: 200, y: 200)

    private var speed: CGPoint = CGPoint(x: 0, y: 0)

    /// The class singleton.
    static let sharedModel = DeadReckoningModel()

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(updateModel(note:)),
                                               name: MotionModel.updateNotificationName,
                                               object: nil)
    }

    /// Update the dead reckoning estimate based on a new accelerometer reading.
    func updateModel(note: Notification) {
        if let accelX = note.userInfo?["accelX"] as? Double,
                let accelY = note.userInfo?["accelY"] as? Double {

            let metersToPixels: CGFloat = 1000.0
            let orientation = OrientationModel.sharedModel.orientation

            speed.x -= CGFloat(accelX) * metersToPixels * CGFloat(MotionModel.sharedModel.rate)
            speed.y -= CGFloat(accelY) * metersToPixels * CGFloat(MotionModel.sharedModel.rate)
            speed.x *= 0.5
            speed.y *= 0.5

            print(speed)

            // Calculate the north/south, and the east/west distance in pixels.
            let northSouthDistance = Double(speed.x)
            let eastWestDistance = Double(speed.y)

            // Apply the northSouthDistance to the translation
            currentLocation.x += CGFloat(cos(orientation) * northSouthDistance)
            currentLocation.y += CGFloat(sin(orientation) * northSouthDistance)

            // Apply the eastWestDistance to the translation
            currentLocation.x += CGFloat(sin(orientation) * eastWestDistance)
            currentLocation.y -= CGFloat(cos(orientation) * eastWestDistance)

            // Ensure that the arrow does not move out of bounds
            currentLocation.x = min(currentLocation.x, UIScreen.main.bounds.width)
            currentLocation.x = max(currentLocation.x, 0)
            currentLocation.y = min(currentLocation.y, UIScreen.main.bounds.height)
            currentLocation.y = max(currentLocation.y, 0)
        }
    }
}

//
//  MapViewController.swift
//  Odontoceti
//
//  Created by Gregory Foster on 2/20/17.
//  Copyright © 2017 Greg M Foster. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
  
  var runningLocationPoint = CGPoint(x: 0.5, y: 0.5)
  let updateRate = 0.05
  
  lazy var heatMap: UIView = {
    let _heatMap = UIView()
    return _heatMap
  }()
  
  lazy var userPoint: UIView = {
    let _userPoint = UIView()
    _userPoint.backgroundColor = .white
    return _userPoint
  }()
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(self.magneticReading(notification:)),
                                           name: MagnetSensor.updateNotificationName,
                                           object: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    heatMap.frame = view.bounds
    populateHeatMap()
    
    userPoint.frame = CGRect(x: view.width / 2.0, y: view.height / 2.0, width: 20.0, height: 20.0)
    
    view.addSubview(heatMap)
    view.addSubview(userPoint)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    populateHeatMap()
  }
  
  private func populateHeatMap() {
    // Remove all old tiles from heatmap.
    _ = heatMap.subviews.map({$0.removeFromSuperview()})
    
    // Build in new ones.
    let size = Map.sharedMap.gridSize
    for y in 0..<size {
      for x in 0..<size {
        let square = UIView(frame: CGRect(x: CGFloat(x) * view.width / CGFloat(size),
                                          y: CGFloat(y) * view.height / CGFloat(size),
                                          width: view.width / CGFloat(size),
                                          height: view.height / CGFloat(size)))
        let val = Map.sharedMap.normalizedValueFor(location: IndexPath(item: x, section: y))
        square.backgroundColor = UIColor.colorBetween(.red, andColor: .blue, percent: CGFloat(val))
        heatMap.addSubview(square)
      }
    }
  }
  
  func magneticReading(notification: Notification) {
    if let magnitude = notification.userInfo?["value"] as? Double {
      // New magnet reading, reposition point.
      let percentPoint = Map.sharedMap.locationForValue(value: magnitude)
      runningLocationPoint.x += (percentPoint.x - runningLocationPoint.x) * CGFloat(updateRate)
      runningLocationPoint.y += (percentPoint.y - runningLocationPoint.y) * CGFloat(updateRate)
      let point = CGPoint(x: view.width * runningLocationPoint.x,
                          y: view.height * runningLocationPoint.y)
      UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
        self.userPoint.frame = CGRect(origin: point, size: self.userPoint.frame.size)
      }, completion: nil)
    }
  }
}

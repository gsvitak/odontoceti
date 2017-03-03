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
  var filtering: Bool = false

  lazy var tiles: [Point: UIView] = {
    var _tiles = [Point: UIView]()
    for p in Map.sharedMap.points {
      _tiles[p] = (UIView())
    }
    return _tiles
  }()

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    tabBarItem.title = "Localizer"
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
    let w: CGFloat = view.width / CGFloat(Map.sharedMap.gridSize)
    let h: CGFloat = view.height / CGFloat(Map.sharedMap.gridSize)
    for p in Map.sharedMap.points {
      if let tile = tiles[p] {
        tile.frame = CGRect(x: CGFloat(p.xLoc) * w, y: CGFloat(p.yLoc) * h, width: w, height: h)
        view.addSubview(tile)
      }
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    filtering = true
  }

  override func viewDidDisappear(_ animated: Bool) {
    filtering = false
  }

  private func updateTiles() {
    for p in Map.sharedMap.points {
      if let tile = tiles[p] {
        let likelihood = Map.sharedMap.likelihood(point:p)
        print(likelihood)
        tile.backgroundColor = UIColor.colorBetween(.black,
                                                    andColor: .white,
                                                    percent: CGFloat(likelihood))
      }
    }
  }

  func magneticReading(notification: Notification) {
    if filtering {
      if let magnitude = notification.userInfo?["value"] as? Double {
        Map.sharedMap.updateWeights(measurement: magnitude)
        updateTiles()
      }
    }
  }
}

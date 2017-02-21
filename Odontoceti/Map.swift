//
//  Map.swift
//  Odontoceti
//
//  Created by Gregory Foster on 2/20/17.
//  Copyright © 2017 Greg M Foster. All rights reserved.
//


import UIKit

class Map: NSObject {
  
  private let updateRate: Double
  private var grid = [IndexPath: Double]()
  let gridSize: Int
  
  static let sharedMap = Map(gridSize: 4, updateRate: 0.05)
  
  init(gridSize: Int, updateRate: Double) {
    self.updateRate = updateRate
    self.gridSize = gridSize
    super.init()
    
    // Populate grid with average values
    for y in 0..<gridSize {
      for x in 0..<gridSize {
        grid[IndexPath(item:x, section:y)] = -1
      }
    }
  }
  
  func update(location:IndexPath, value:Double) {
    if let curVal = grid[location] {
      if curVal > 0 {
        grid[location]! += (value - curVal) * updateRate
      } else {
        grid[location] = value
      }
    }
  }
  
  func normalizedValueFor(location: IndexPath) -> Double {
    let min:Double? = grid.values.filter({$0 > 0}).min()
    let max:Double? = grid.values.filter({$0 > 0}).max()
    if let val = grid[location], val > 0, let min = min, let max = max {
      let range:Double = max - min
      if (range > 0) {
        return (val - min) / range
      }
    }
    return 0.5
  }
  
  func locationForValue(value: Double) -> CGPoint {
    let closest = grid.min(by: {abs($0.value - value) < abs($1.value - value)})
    if let path = closest?.key {
      let x = path.item
      let y = path.section
      return CGPoint(x: 1.0 / CGFloat(gridSize) * CGFloat(x) + 0.5 / CGFloat(gridSize),
                     y: 1.0 / CGFloat(gridSize) * CGFloat(y) + 0.5 / CGFloat(gridSize))
    }
    return CGPoint(x: 0.5, y: 0.5)
  }
}

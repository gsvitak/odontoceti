//
//  Map.swift
//  Odontoceti
//
//  Created by Gregory Foster on 2/20/17.
//  Copyright © 2017 Greg M Foster. All rights reserved.
//


import UIKit

struct Particle {
  var xLoc: Int = 0
  var yLoc: Int = 0
  var weight: Double = 0
}

struct Point: Hashable {
  var xLoc: Int = 0
  var yLoc: Int = 0
  // required var for the Hashable protocol
  var hashValue: Int {
    return (xLoc * 0x1f1f1f1f) ^ yLoc
  }
}

func == (left: Point, right: Point) -> Bool {
  return left.xLoc == right.xLoc && left.yLoc == right.yLoc
}

func == (left: Particle, right: Point) -> Bool {
  return left.xLoc == right.xLoc && left.yLoc == right.yLoc
}

func == (left: Point, right: Particle) -> Bool {
  return left.xLoc == right.xLoc && left.yLoc == right.yLoc
}

extension Int {
  init(_ bool: Bool) {
    self = bool ? 1 : 0
  }
}

class Map: NSObject {

  private let numParticles = 500
  private var particles = [Particle]()
  private let updateRate: Double
  private var grid = [Point: Double]()
  let gridSize: Int

  static let sharedMap = Map(gridSize: 5, updateRate: 0.05)

  lazy var points: [Point] = {
    var _points = [Point]()
    for y in 0..<self.gridSize {
      for x in 0..<self.gridSize {
        _points.append(Point(xLoc:x, yLoc:y))
      }
    }
    return _points
  }()

  init(gridSize: Int, updateRate: Double) {
    self.updateRate = updateRate
    self.gridSize = gridSize
    super.init()

    // Create n particles with equal normalized weights.
    initializeParticles()

    // Populate grid with average values
    for y in 0..<gridSize {
      for x in 0..<gridSize {
        grid[Point(xLoc:x, yLoc:y)] = 30
      }
    }
  }

  func update(location: Point, value: Double) {
    if let curVal = grid[location] {
      if curVal > 0 {
        grid[location]! += (value - curVal) * updateRate
      } else {
        grid[location] = value
      }
    }
  }

  func valueFor(location: Point) -> Double {
    return grid[location]!
  }

  func normalizedValueFor(location: Point) -> Double {
    let min: Double? = grid.values.filter({$0 > 0}).min()
    let max: Double? = grid.values.filter({$0 > 0}).max()
    if let val = grid[location], val > 0, let min = min, let max = max {
      let range: Double = max - min
      if range > 0 {
        return (val - min) / range
      }
    }
    return 0.5
  }

  func locationForValue(value: Double) -> CGPoint {
    let closest = grid.min(by: {abs($0.value - value) < abs($1.value - value)})
    if let path = closest?.key {
      let x = path.xLoc
      let y = path.yLoc
      return CGPoint(x: 1.0 / CGFloat(gridSize) * CGFloat(x) + 0.5 / CGFloat(gridSize),
                     y: 1.0 / CGFloat(gridSize) * CGFloat(y) + 0.5 / CGFloat(gridSize))
    }
    return CGPoint(x: 0.5, y: 0.5)
  }


  // Update the current set of weights with some new measurement m.
  func updateWeights(measurement: Double) {
    let lambda: Double = 0.01
    for i in particles.indices {
      var p = particles[i]
      let y: Double = Map.sharedMap.valueFor(location: Point(xLoc: p.xLoc, yLoc: p.yLoc))
      // Lambda dictates how quicky weights grow.
      // Increase the weight of the particle if it is close to the measurement.
      p.weight += lambda / abs(y - measurement)
      particles[i] = p
    }
    // Now normalize the weights.
    let s: Double = particles.reduce(0, {$0 + $1.weight})
    particles = particles.map({ (p: Particle) -> Particle in
      var p = p
      p.weight = p.weight / s
      return p
    })
    // Now resample
    resampleParticles()
  }

  // Randomly generate a number between 0 and 1
  private func random() -> Double {
    return Double(Float(arc4random()) / Float(UINT32_MAX))
  }

  // Randomly generate a particle with resampling and weights consideration.
  private func generateParticle() -> Particle {
    var rand = random()
    for p in particles {
      rand -= p.weight
      if rand < 0 {
        return p
      }
    }
    return particles.last!
  }

  // Set all the weights to have equal probability.
  private func initializeParticles() {
    let pPerLoc = numParticles / (gridSize*gridSize)
    let w = Double(1) / Double(numParticles)

    for y in 0..<gridSize {
      for x in 0..<gridSize {
        particles += [Particle](repeating: Particle(xLoc: x, yLoc: y, weight: w), count: pPerLoc)
      }
    }
  }

  // Create a new set of particles.
  private func resampleParticles() {
    var newParticles = [Particle]()

    // Create some percentage of random particles each time to prevent getting stuck.
    let randomCount: Int = Int(0.1 * Double(numParticles))
    for _ in 0..<randomCount {
      let x = Int(random() * Double(gridSize))
      let y = Int(random() * Double(gridSize))
      newParticles.append(Particle(xLoc: x, yLoc: y, weight: 0.002))
    }

    for _ in 0..<numParticles - randomCount {
      newParticles.append(generateParticle())
    }
    particles = newParticles
  }

  // Return the probability that user is standing at some point.
  func likelihood(point: Point) -> Double {
    let count = particles.reduce(0, {$0 + Int($1 == point)})
    return Double(count) / Double(particles.count)
  }

}

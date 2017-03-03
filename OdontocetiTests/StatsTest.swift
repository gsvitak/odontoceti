//
//  StatsTest.swift
//  Odontoceti
//
//  Created by Gregory Foster on 3/3/17.
//  Copyright © 2017 Greg M Foster. All rights reserved.
//

import XCTest
@testable import Odontoceti

class StatsTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here.
        // This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here.
        // This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

  func testRoundTo() {
    XCTAssert(0.01.roundTo(places: 1) == 0.0, "Doubles do not correctly round.")
    XCTAssert(0.05.roundTo(places: 1) == 0.1, "Doubles do not correctly round.")
    XCTAssert(0.05.roundTo(places: 1) == 0.1, "Doubles do not correctly round.")
    XCTAssert(0.2315.roundTo(places: 0) == 0.0, "Doubles do not correctly round.")
    XCTAssert(0.2315.roundTo(places: 3) == 0.232, "Doubles do not correctly round.")
    XCTAssert(0.235213128.roundTo(places: 8) == 0.23521313, "Doubles do not correctly round.")
  }

  func testNormalPDF() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
      XCTAssert(Stats.normalPDF(measure: 0, mean: 0, sigma: 1).roundTo(places: 8) == 0.39894228,
                "Normal PDF does not calculate the correct probability.")
      XCTAssert(Stats.normalPDF(measure: 35, mean: 30, sigma: 5).roundTo(places: 8) == 0.04839414,
                "Normal PDF does not calculate the correct probability.")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

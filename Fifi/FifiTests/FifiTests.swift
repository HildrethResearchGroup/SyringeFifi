//
//  FifiTests.swift
//  FifiTests
//
//  Created by Connor Barnes on 6/17/21.
//

import XCTest
@testable import Fifi

class FifiTests: XCTestCase {
  
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() throws {
    let transformer = CoordinateTransformer(transformations: [.zRotation(.degrees(0))])
    
    let points: [Point3D] = [
      (0, 0, 0),
      (0, 1, 0),
      (1, 0, 0),
      (1, 1, 0)
    ]
    
    let transformed = points.map { transformer.transform($0) }
    
  }
  
  func testPerformanceExample() throws {
    // This is an example of a performance test case.
    self.measure {
      // Put the code you want to measure the time of here.
    }
  }
  
}

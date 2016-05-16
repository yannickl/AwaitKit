//
//  AwaitedPromiseKitTests.swift
//  AwaitedPromiseKitTests
//
//  Created by Yannick LORIOT on 16/05/16.
//  Copyright © 2016 Yannick Loriot. All rights reserved.
//

import PromiseKit
import XCTest
@testable import AwaitedPromiseKit

class AwaitedPromiseKitTests: XCTestCase {
  func testSimpleAsyncBlock() {
    let expectation = expectationWithDescription("Async should return value")

    let promise: Promise<String> = async {
      return "AwaitedPromiseKit"
    }

    promise.then { value in
      expectation.fulfill()
    }

    waitForExpectationsWithTimeout(0.1) { error in
      if error == nil {
        XCTAssertEqual(promise.value, "AwaitedPromiseKit")
      }
    }
  }

  func testSimpleDelayedAsyncBlock() {
    let expectation = expectationWithDescription("Async should return value")

    let promise: Promise<String> = async {
      NSThread.sleepForTimeInterval(0.2)

      return "AwaitedPromiseKit"
    }

    promise.then { value in
      expectation.fulfill()
    }

    waitForExpectationsWithTimeout(0.5) { error in
      if error == nil {
        XCTAssertEqual(promise.value, "AwaitedPromiseKit")
      }
    }
  }
}

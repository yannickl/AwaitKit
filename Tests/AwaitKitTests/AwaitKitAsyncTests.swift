/*
 * AwaitKit
 *
 * Copyright 2016-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import AwaitKit
import PromiseKit
import XCTest

class AwaitKitAsyncTests: XCTestCase {
  let commonError = NSError(domain: "com.yannickloriot.error", code: 320, userInfo: nil)

  func testSimpleDelayedValidAsyncBlock() {
    let expect = expectation(description: "Async should return value")

    let promise: Promise<String> = async {
      Thread.sleep(forTimeInterval: 0.2)

      return "AwaitedPromiseKit"
    }

    _ = promise.then { value -> Promise<Void> in
      expect.fulfill()

      return Promise()
    }

    waitForExpectations(timeout: 0.5) { error in
      if error == nil {
        XCTAssertEqual(promise.value, "AwaitedPromiseKit")
      }
    }
  }

  func testSimpleFailedAsyncBlock() {
    let expect = expectation(description: "Async should not return value")

    let promise: Promise<String> = async {
      throw self.commonError
    }

    _ = promise.catch { err in
      expect.fulfill()
    }

    waitForExpectations(timeout: 0.1) { error in
      if error == nil {
        XCTAssertNil(promise.value)
      }
    }
  }

  func testNoReturnedValueAsyncBlock() {
    let expect1 = expectation(description: "Async should not return value")
    let expect2 = expectation(description: "Async should throw")

    async {
      expect1.fulfill()
    }

    async {
      defer {
        expect2.fulfill()
      }

      throw self.commonError
    }

    waitForExpectations(timeout: 0.1, handler: nil)
  }
}

/*
 * AwaitedPromiseKit
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

import Foundation
import PromiseKit

final class AwaitedPromiseKit {
  static func awaitForPromise<T>(on queue: dispatch_queue_t, promise: Promise<T>) throws -> T {
    var result: T?
    var error: ErrorType?

    let semaphore = dispatch_semaphore_create(0)

    promise
      .then(on: queue) { value -> Void in
        result = value

        dispatch_semaphore_signal(semaphore)
      }
      .error { err in
        error = err

        dispatch_semaphore_signal(semaphore)
    }

    dispatch_semaphore_wait(semaphore, UINT64_MAX)

    if let result = result {
      return result
    }

    throw error ?? NSError(domain: "com.yannickloriot.awaitpromise", code: 0, userInfo: [
      NSLocalizedDescriptionKey: "Operation was unsuccessful.",
      NSLocalizedFailureReasonErrorKey: "No value found."
      ])
  }
}

public func async<T>(on queue: dispatch_queue_t = dispatch_queue_create("com.yannickloriot.queue", DISPATCH_QUEUE_CONCURRENT), _ body: () throws -> T) -> Promise<T> {
  return dispatch_promise(on: queue, body: body)
}

public func async(on queue: dispatch_queue_t = dispatch_queue_create("com.yannickloriot.queue", DISPATCH_QUEUE_CONCURRENT), _ body: () throws -> Void) {
  let promise: Promise<Any> = async(on: queue, body)

  promise.error { _ in }
}

public func await<T>(body: () throws -> T) throws -> T {
  return try await(on: dispatch_queue_create("com.yannickloriot.queue", DISPATCH_QUEUE_CONCURRENT), body: body)
}

public func await<T>(on queue: dispatch_queue_t, body: () throws -> T) throws -> T {
  let promise = dispatch_promise(on: queue, body: body)

  return try await(on: queue, promise: promise)
}

public func await<T>(promise: Promise<T>) throws -> T {
  return try await(on: dispatch_queue_create("com.yannickloriot.queue", DISPATCH_QUEUE_CONCURRENT), promise: promise)
}

public func await<T>(on queue: dispatch_queue_t, promise: Promise<T>) throws -> T {
  return try AwaitedPromiseKit.awaitForPromise(on: queue, promise: promise)
}
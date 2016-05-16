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
  static func awaitForPromise<T>(queue: dispatch_queue_t, promise: Promise<T>) throws -> T {
    var result: T?
    var error: ErrorType?

    let semaphore = dispatch_semaphore_create(0)

    promise
      .then(on: queue) { value in
        result = value

        dispatch_semaphore_signal(semaphore)

        return AnyPromise(bound: Promise())
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

  static func promisifyOnQueue<T>(queue: dispatch_queue_t, closure: () throws -> T) -> Promise<T> {
    return Promise { fulfill, reject in
      dispatch_async(queue) {
        do {
          let value = try closure()

          fulfill(value)
        }
        catch {
          reject(error)
        }
      }
    }
  }
}

public func async<T>(queue queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), _ closure: () throws -> T) -> Promise<T> {
  return AwaitedPromiseKit.promisifyOnQueue(queue, closure: closure)
}

public func async(queue queue: dispatch_queue_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), _ closure: () throws -> Void) {
  let promise: Promise<Any> = async(queue: queue, closure)

  promise.error { _ in }
}

public func await<T>(closure: () throws -> T) throws -> T {
  return try await(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), closure: closure)
}

public func await<T>(queue queue: dispatch_queue_t, closure: () throws -> T) throws -> T {
  let promise = AwaitedPromiseKit.promisifyOnQueue(queue, closure: closure)

  return try await(queue: queue, promise: promise)
}

public func await<T>(promise: Promise<T>) throws -> T {
  return try await(queue: dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), promise: promise)
}

public func await<T>(queue queue: dispatch_queue_t, promise: Promise<T>) throws -> T {
  return try AwaitedPromiseKit.awaitForPromise(queue, promise: promise)
}
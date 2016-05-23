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

import Foundation
import PromiseKit

/// Convenience class to make the background job.
final class AwaitKit {
  static var asyncQueue = dispatch_queue_create("com.yannickloriot.asyncqueue", DISPATCH_QUEUE_CONCURRENT)
  static var awaitQueue = dispatch_queue_create("com.yannickloriot.awaitqueue", DISPATCH_QUEUE_CONCURRENT)

  static func awaitForPromise<T>(on queue: dispatch_queue_t, promise: Promise<T>) throws -> T {
    guard dispatch_queue_get_label(queue) != dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL) else {
      throw NSError(domain: "com.yannickloriot.awaitkit", code: 0, userInfo: [
        NSLocalizedDescriptionKey: "Operation was aborted.",
        NSLocalizedFailureReasonErrorKey: "The current and target queues are the same."
        ])
    }

    var result: T?
    var error: ErrorType?

    let semaphore = dispatch_semaphore_create(0)

    promise
      .then(on: queue) { value -> Void in
        result = value

        dispatch_semaphore_signal(semaphore)
      }
      .errorOnQueue(on: queue) { err in
        error = err

        dispatch_semaphore_signal(semaphore)
    }

    dispatch_semaphore_wait(semaphore, UINT64_MAX)

    guard let unwrappedResult = result else {
      throw error!
    }

    return unwrappedResult
  }
}

/**
 Yields the execution to the given closure on a specified queue and returns a new promise.
 
 - parameter queue: The queue on which body should be executed.
 - parameter body: The closure that is executed on the given queue.
 - returns: A new promise that is resolved when the provided closure returned.
 */
public func async<T>(on queue: dispatch_queue_t = AwaitKit.asyncQueue, _ body: () throws -> T) -> Promise<T> {
  return dispatch_promise(on: queue, body: body)
}

/**
 Yields the execution to the given closure on a specified queue.

 - parameter queue: The queue on which body should be executed.
 - parameter body: The closure that is executed on the given queue.
 */
public func async(on queue: dispatch_queue_t = AwaitKit.asyncQueue, _ body: () throws -> Void) {
  let promise: Promise<Any> = async(on: queue, body)

  promise.error { _ in }
}

/**
 Awaits that the given closure finished on a background queue and return its value or throws an error if the closure failed.

 - parameter body: The closure that is executed on the given queue.
 - throws: The error sent by the closure.
 - returns: The value of the closure when it is done.
 - seeAlso: await(on:body:)
 */
public func await<T>(body: () throws -> T) throws -> T {
  return try await(on: AwaitKit.awaitQueue, body: body)
}

/**
 Awaits that the given closure finished on the specified queue and return its value or throws an error if the closure failed.

 - parameter queue: The queue on which body should be executed.
 - parameter body: The closure that is executed on the given queue.
 - throws: The error sent by the closure.
 - returns: The value of the closure when it is done.
 - seeAlso: await(on:promise:)
 */
public func await<T>(on queue: dispatch_queue_t, body: () throws -> T) throws -> T {
  let promise = dispatch_promise(on: queue, body: body)

  return try await(on: queue, promise: promise)
}

/**
 Awaits that the given promise resolved on a background queue and return its value or throws an error if the promise failed.

 - parameter promise: The promise to resolve.
 - throws: The error produced when the promise is rejected.
 - returns: The value of the promise when it is resolved.
 - seeAlso: await(on:promise:)
 */
public func await<T>(promise: Promise<T>) throws -> T {
  return try await(on: AwaitKit.awaitQueue, promise: promise)
}

/**
 Awaits that the given promise resolved on the specified queue and return its value or throws an error if the promise failed.
 
 - parameter queue: The queue on which body should be executed.
 - parameter promise: The promise to resolve.
 - throws: The error produced when the promise is rejected.
 - returns: The value of the promise when it is resolved.
 */
public func await<T>(on queue: dispatch_queue_t, promise: Promise<T>) throws -> T {
  return try AwaitKit.awaitForPromise(on: queue, promise: promise)
}
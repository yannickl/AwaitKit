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

let asyncQueue = DispatchQueue(label: "com.yannickloriot.asyncqueue", attributes: .concurrent)
let awaitQueue = DispatchQueue(label: "com.yannickloriot.awaitqueue", attributes: .concurrent)

// MARK: - Async -

/**
 Yields the execution to the given closure and returns a new promise.

 - parameter body: The closure that is executed on a concurrent queue.
 - returns: A new promise that is resolved when the provided closure returned.
 */
public func async<T>(_ body: @escaping () throws -> T) -> Promise<T> {
    return asyncQueue.promise(execute: body)
}

/**
 Yields the execution to the given closure which returns nothing.

 - parameter body: The closure that is executed on a concurrent queue.
 */
public func async(_ body: @escaping () throws -> Void) {
    async(body, queue: asyncQueue)
}

/**
 Yields the execution to the given closure and returns a new promise.
 
 - Parameter body: The closure that is executed on the given queue.
 - Returns: A new promise that is resolved when the provided closure returned.
 */
public func async<T>(_ body: @escaping () throws -> T, queue: DispatchQueue) -> Promise<T> {
    return queue.promise(execute: body)
}

/**
 Yields the execution to the given closure which returns nothing.
 
 - Parameter body: The closure that is executed on the given queue.
 */
public func async(_ body: @escaping () throws -> Void, queue: DispatchQueue) {
    let promise: Promise<Void> = async(body)
    
    promise.catch { _ in }
}

// MARK: - Await -

/**
 Awaits that the given closure finished and returns its value or throws an error if the closure failed.

 - parameter body: The closure that is executed on a concurrent queue.
 - throws: The error sent by the closure.
 - returns: The value of the closure when it is done.
 */
@discardableResult
public func await<T>(_ body: @escaping () throws -> T) throws -> T {
    return try await(body, queue: awaitQueue)
}

/**
 Awaits that the given promise resolved and returns its value or throws an error if the promise failed.

 - parameter promise: The promise to resolve.
 - throws: The error produced when the promise is rejected.
 - returns: The value of the promise when it is resolved.
 */
@discardableResult
public func await<T>(_ promise: Promise<T>) throws -> T {
    return try await(promise, queue: awaitQueue)
}

/**
 Awaits that the given closure finished on the receiver and returns its value or throws an error if the closure failed.
 
 - parameter body: The closure that is executed on the receiver.
 - throws: The error sent by the closure.
 - returns: The value of the closure when it is done.
 - seeAlso: await(promise:)
 */
@discardableResult
public func await<T>(_ body: @escaping () throws -> T, queue: DispatchQueue) throws -> T {
    let promise = queue.promise(execute: body)
    
    return try await(promise, queue: queue)
}

/**
 Awaits that the given promise resolved on the receiver and returns its value or throws an error if the promise failed.
 
 - parameter promise: The promise to resolve.
 - throws: The error produced when the promise is rejected or when the queues are the same.
 - returns: The value of the promise when it is resolved.
 */
@discardableResult
public func await<T>(_ promise: Promise<T>, queue: DispatchQueue) throws -> T {
    guard queue.label != DispatchQueue.main.label else {
        throw NSError(domain: "com.yannickloriot.awaitkit", code: 0, userInfo: [
            NSLocalizedDescriptionKey: "Operation was aborted.",
            NSLocalizedFailureReasonErrorKey: "The current and target queues are the same."
            ])
    }
    
    var result: T?
    var error: Error?
    
    let semaphore = DispatchSemaphore(value: 0)
    
    promise
        .then(on: queue) { value -> Void in
            result = value
            
            semaphore.signal()
        }
        .catch(on: queue) { err in
            error = err
            
            semaphore.signal()
    }
    
    _ = semaphore.wait(timeout: DispatchTime(uptimeNanoseconds: UINT64_MAX))
    
    guard let unwrappedResult = result else {
        throw error!
    }
    
    return unwrappedResult
}

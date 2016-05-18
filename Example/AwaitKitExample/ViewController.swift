//
//  ViewController.swift
//  AwaitKitExample
//
//  Created by Yannick LORIOT on 18/05/16.
//  Copyright © 2016 Yannick Loriot. All rights reserved.
//

import UIKit
import PromiseKit

struct User {
  var name: String
}

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    let user = try! await(signInWithUsername("Foo", password: "Bar"))
    try! await(sendWelcomeMailToUser(user))
    try! await(redirectToThankYouScreen())

    print("All done with \(user)!")
  }

  // MARK: - Promises

  func signInWithUsername(name: String, password: String) -> Promise<User> {
    return Promise { resolve, reject in
      resolve(User(name: name))
    }
  }

  func sendWelcomeMailToUser(user: User) -> Promise<Void> {
    return Promise { resolve, reject in
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_queue_create("com.yannickloriot.queue", DISPATCH_QUEUE_CONCURRENT), {
        resolve()
      })
    }
  }

  func redirectToThankYouScreen() -> Promise<Void> {
    return Promise { resolve, reject in
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_queue_create("com.yannickloriot.queue", DISPATCH_QUEUE_CONCURRENT), {
        resolve()
      })
    }
  }
}

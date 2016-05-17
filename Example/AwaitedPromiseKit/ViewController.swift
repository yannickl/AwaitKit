//
//  ViewController.swift
//  AwaitKit
//
//  Created by Yannick LORIOT on 16/05/16.
//  Copyright © 2016 Yannick Loriot. All rights reserved.
//

import UIKit
import PromiseKit

struct User {

}

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let user = try! await(signInWithUsername("Foo", password: "Bar"))
    try! await(sendWelcomeMailToUser(user))
    try! await(redirectToThankYouScreen())

    print("All done!")

    signInWithUsername("Foo", password: "Bar")
      .then { user in
        return self.sendWelcomeMailToUser(user)
      }
      .then { _ in
        return self.redirectToThankYouScreen()
      }
      .then { _ in
        print("All done!")
    }

    dispatch_get_main_queue()
    dispatch_async(dispatch_queue_create("com.yannickloriot.queue", DISPATCH_QUEUE_CONCURRENT)) { 

    }
  }

  // MARK: - Promises

  func signInWithUsername(name: String, password: String) -> Promise<User> {
    return Promise(1).then { _ in
      return User()
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


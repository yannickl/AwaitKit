//
//  ViewController.swift
//  AwaitKitExample
//
//  Created by Yannick LORIOT on 18/05/16.
//  Copyright © 2016 Yannick Loriot. All rights reserved.
//

import UIKit
import PromiseKit
import AwaitKit

struct User {
  var name: String
}

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    AwaitKit.async {
      throw NSError(domain: "com.yannickloriot.error", code: 3, userInfo: nil)
    }

    let user = try! AwaitKit.await(signIn(username: "Foo", password: "Bar"))
    try! AwaitKit.await(sendWelcomeMailToUser(user))
    try! AwaitKit.await(redirectToThankYouScreen())
    
    print("All done with \(user)!")
  }

  // MARK: - Promises

  func signIn(username name: String, password: String) -> Promise<User> {
    return Promise { resolve, reject in
      resolve(User(name: name))
    }
  }

  func sendWelcomeMailToUser(_ user: User) -> Promise<Void> {
    return Promise { resolve, reject in
      let deadlineTime = DispatchTime.now() + .seconds(1)
      let queue        = DispatchQueue(label: "com.yannickloriot.queue", attributes: .concurrent)

      queue.asyncAfter(deadline: deadlineTime, execute: {
        resolve()
      })
    }
  }

  func redirectToThankYouScreen() -> Promise<Void> {
    return Promise { resolve, reject in
      let deadlineTime = DispatchTime.now() + .seconds(1)
      let queue        = DispatchQueue(label: "com.yannickloriot.queue", attributes: .concurrent)

      queue.asyncAfter(deadline: deadlineTime, execute: {
        resolve()
      })
    }
  }
}

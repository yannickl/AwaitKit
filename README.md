# AwaitKit

[![License](https://cocoapod-badges.herokuapp.com/l/AwaitKit/badge.svg)](http://cocoadocs.org/docsets/AwaitKit/) [![Supported Platforms](https://cocoapod-badges.herokuapp.com/p/AwaitKit/badge.svg)](http://cocoadocs.org/docsets/AwaitKit/) [![Version](https://cocoapod-badges.herokuapp.com/v/AwaitKit/badge.svg)](http://cocoadocs.org/docsets/AwaitKit/) [![Build Status](https://travis-ci.org/yannickl/AwaitKit.svg?branch=master)](https://travis-ci.org/yannickl/AwaitKit) [![codecov.io](http://codecov.io/github/yannickl/AwaitKit/coverage.svg?branch=master)](http://codecov.io/github/yannickl/AwaitKit?branch=master) [![codebeat badge](https://codebeat.co/badges/212dd077-388c-4b0a-8829-9ccf16d0a200)](https://codebeat.co/projects/github-com-yannickl-awaitkit)

Have you ever dream to write asynchronous code like its synchronous counterpart?

_AwaitKit_ is a powerful Swift library inspired by the [Async/Await specification in ES7 (ECMAScript 7)](https://github.com/tc39/ecmascript-asyncawait) which provides a powerful way to write asynchronous code in a sequential manner.

Internally it uses [PromiseKit](https://github.com/mxcl/PromiseKit) to create and manage promises.

## Getting Started

To make simple. This:

```swift
let user = try! await(signInWithUsername("Foo", password: "Bar"))
try! await(sendWelcomeMailToUser(user))
try! await(redirectToThankYouScreen())

print("All done!")
```

Instead of:

```swift
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
```

Or worst, using completion block style:

```swift
signInWithUsername("Foo", password: "Bar") { user in
  self.sendWelcomeMailToUser(user) { _ in
    self.redirectToThankYouScreen() { _ in
      print("All done!")
    }
  }
}
```

## Usage

### Async

The `async` method yields the execution to its closure which will run in a background queue and returns a promise which will be resolved at this end of block.

Here a small example :

### Await

The `await` method will executes the given promise or block and await until it resolved.

```swift
func setupNewUser(name: String) -> Promise<User> {  
  return async {
    let newUser = try await(self.createUser(name))
    let friends = try await(self.getFacebookFriends(name))

    newUser.addFriends(friends)

    return newUser
  }
}
```
Here to setup a new user, we need to create it then find their friends to make the relation. The `createUser` and `getFacebookFriends` are promises. Both methods are called with the `await` method inside the `async` block.

## Installation

The recommended approach to use _AwaitKit_ in your project is using the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation.

### CocoaPods

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```
Go to the directory of your Xcode project, and Create and Edit your Podfile and add _AwaitKit_:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
pod 'AwaitKit', '~> 1.0.0'
```

Install into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```

### Swift Package Manager

You can use [The Swift Package Manager](https://swift.org/package-manager) to install `AwaitKit` by adding the proper description to your `Package.swift` file:

```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
        .Package(url: "https://github.com/yannickl/AwaitKit.git")
    ]
)
```

Note that the [Swift Package Manager](https://swift.org/package-manager) is still in early design and development, for more information checkout its [GitHub Page](https://github.com/apple/swift-package-manager).

### Manually

[Download](https://github.com/YannickL/AwaitKit/archive/master.zip) the project and copy the `AwaitKit` folder into your project to use it in.

## Contact

Yannick Loriot
 - [https://twitter.com/yannickloriot](https://twitter.com/yannickloriot)
 - [contact@yannickloriot.com](mailto:contact@yannickloriot.com)


## License (MIT)

Copyright (c) 2016-present - Yannick Loriot

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

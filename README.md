# AwaitedPromiseKit

_AwaitedPromiseKit_ provides a powerful way to write asynchronous code in a sequential manner in Swift. It is inspired by the [Async/Await specification in ES7 (ECMAScript 7)](https://github.com/tc39/ecmascript-asyncawait) and it uses [PromiseKit](https://github.com/mxcl/PromiseKit) for promises.

## Usage

The Async/Await pattern, like in ES7, is used in conjunction of Promise.

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

The recommended approach to use _AwaitedPromiseKit_ in your project is using the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation.

### CocoaPods

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```
Go to the directory of your Xcode project, and Create and Edit your Podfile and add _AwaitedPromiseKit.swift_:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
pod 'AwaitedPromiseKit', '~> 1.0.0'
```

Install into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```

### Manually

[Download](https://github.com/YannickL/AwaitedPromiseKit/archive/master.zip) the project and copy the `AwaitedPromiseKit` folder into your project to use it in.

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

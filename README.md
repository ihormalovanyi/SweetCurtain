![](https://ihor.pro/wp-content/uploads/2020/01/Artboard-1.png)
A framework that provides [Curtain Controller](#curtaincontroller). Curtain Controller is a container view controller that implements a content-curtain interface. 

[![Platform](https://img.shields.io/badge/platform-ios-blue.svg?style=flat%20)](https://developer.apple.com/iphone/index.action)
[![Swift 5.1](https://img.shields.io/badge/Swift-5.1-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![MIT](https://img.shields.io/badge/license-MIT-green)](https://github.com/multimediasuite/SweetCurtain/blob/master/LICENSE)

![](https://ihor.pro/wp-content/uploads/2020/01/ezgif-6-f06884bc0af6.gif)  ![](https://ihor.pro/wp-content/uploads/2020/01/ezgif-6-e332ad33f4ea.gif)

## Contents
- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage and explanation](#usageandexplanation)
- [TODO](#todo)
- [Credits](#credits)
- [License](#license)

## Overview
A **SweetCurtain** framework provides a [Curtain Controller](#curtaincontroller).
A Curtain Controller is a container view controller that manages two child view controllers in a content-curtain interface. In this type of interface, the primary view controller (the content) is covered with the secondary view controller (the curtain).

When building your app’s user interface, the Curtain Controller is typically the root view controller of your app’s window, but it may be embedded in another view controller. The Curtain Controller has no significant appearance of its own. Most of its appearance is defined by the child view controllers you install. You can configure the child view controllers using [Interface Builder](https://developer.apple.com/xcode/interface-builder/) or programmatically using the [init(content: curtain:) initializer](#curtaincontroller). The child view controllers can be custom view controllers or other container view controller, such as navigation controllers.

> **Note**: You can push a Curtain Controller onto a navigation stack. Also, its children can be contained in the navigation controller or tab bar controller.  But remember that curtain always covers the content. For example, if the content embed in the navigation controller, the curtain will cover the navigation bar too.

When displayed onscreen, the Curtain Controller uses its [Delegation](#curtaindelegate) object to messaging of its curtain changes.
Also, the Curtain Controller provides the curtain object to manage the [curtain's properties](#curtain).

## Features
- Coefficient oriented metrics.
- Friendly content changes mechanism.
- Works with storyboard and code.
- So easy to setup and use.
- Compatible with safe area.
- Compatible with scroll view.
- Compatible with horizontal scroll or swipe.
- Designed by the principle of iOS UI components.

## Installation

### CocoaPods

[CocoaPods](#https://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:
```
$ gem install cocoapods
```
To integrate **SweetCurtain** into your Xcode project using CocoaPods, specify it in your `Podfile`:
```ruby
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
  pod 'SweetCurtain'
end
```
Then, run the following command:
```
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](https://brew.sh) using the following command:
```
$ brew update
$ brew install carthage
```

To integrate **SweetCurtain** into your Xcode project using Carthage, specify it in your `Cartfile`:
```
git "https://github.com/multimediasuite/SweetCurtain"
```

Run `carthage update` to build the framework and drag the built SweetCurtain.framework into your Xcode project.

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate **SweetCurtain** into your project manually.

## Usage and explanation

### Setup using storyboard
1. Create a view controller and set the Class to be **CurtainController** in the [Identity Inspector](https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift/ConnectTheUIToCode.html).

![](https://ihor.pro/wp-content/uploads/2020/01/Screenshot-2020-01-03-at-22.37.43-1.png)

2. Create two other view controllers you want. The one will be a Content and another one will be a **Curtain**.

![](https://ihor.pro/wp-content/uploads/2020/01/Screenshot-2020-01-03-at-22.50.43.png)

3. Connect your **CurtainController** to your new view controllers with the **Curtain Connection Segue**.

![](https://ihor.pro/wp-content/uploads/2020/01/Screenshot-2020-01-03-at-22.58.58.png)

4. Choose the **Curtain Connection Segue** of your **Content** view controller and type **ContentID** as it's identifier in the [Identity Inspector](https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift/ConnectTheUIToCode.html).

![](https://ihor.pro/wp-content/uploads/2020/01/Screenshot-2020-01-03-at-23.03.00.png)

5. Choose the **Curtain Connection Segue** of your **Curtain** view controller and type **CurtainID** as it's identifier in the [Identity Inspector](https://developer.apple.com/library/archive/referencelibrary/GettingStarted/DevelopiOSAppsSwift/ConnectTheUIToCode.html).

![](https://ihor.pro/wp-content/uploads/2020/01/Screenshot-2020-01-03-at-23.03.20.png)

You all set!

> **Note**: Double-check your segues and segue IDs. This is important for the right setup of the flow.

### Setup using code

1. Create a two view controllers you want for using them as **Content** and **Curtain**.

```swift
//Also, you can instantiate your controllers from storyboard if you want it.
let contentViewController = IceCreamDetailViewController()
let curtainViewController = IceCreamListViewController()
```

2. Create a [Curtain Controller](#curtaincontroller) using two controllers that you created in the previous step.

```swift
let curtainController = CurtainController(content: contentViewController, curtain: curtainViewController)
```

3. Show the `curtainController` where and when you want.

```swift
show(curtainController, sender: nil)
```

You all set!

### CurtainController

**Curtain Controller** is a container view controller that implements a content-curtain interface.
You can create the **Curtain Controller** using [Storyboard](#setup-using-storyboard) or from the [code](#setup-using-code).
All of your view controllers have access to the `curtainController` property. It's computed property that provides access to the nearest ancestor in the view controller hierarchy that is a **Curtain Controller**.

The **Curtain Controller** object has a couple of properties and functions.

| Property | Type | Description |
| :--- | :--- | :--- |
| `curtainDelegate` | [CurtainDelegate?](#curtaindelegate) | The delegate you want to receive curtain controller messages that concern its curtain. |
| `curtain` | [Curtain!](#curtain) | The object that provides all curtain's behaviour properties. |

The initializer for creating a new **Curtain Controller**:
```swift
init(content: UIViewController, curtain: UIViewController)
```

Function for moving curtain to the [position](#curtainheightstate) you want:
```swift
func moveCurtain(to position: CurtainHeightState, animated: Bool)
```

### Curtain

The **Curtain** is the object of [Curtain Controller](#curtaincontroller) that provides a couple of properties for behavior and view customization. But **Curtain** is not the view. The **Сurtain** is the abstract object represented by protocol with properties that [Curtain Controller](#curtaincontroller) uses for its purposes. Simply put, the **Curtain** designed to reduce confusion and delimit settings duty in the controller.

| Property | Type | Description |
| :--- | :--- | :--- |
| `minHeightCoefficient` | [CGFloat](https://developer.apple.com/documentation/coregraphics/cgfloat) | The minimum value that describes the ratio of the curtain minimum permissible height to the height of the content. |
| `midHeightCoefficient` | [CGFloat?](https://developer.apple.com/documentation/coregraphics/cgfloat) | The intermediate value that describes the ratio of the curtain intermediate permissible height to the height of the content. |
| `maxHeightCoefficient` | [CGFloat](https://developer.apple.com/documentation/coregraphics/cgfloat) | The maximum value that describes the ratio of the curtain maximum permissible height to the height of the content. |
| `swipeResistance` | [CurtainSwipeResistance](#CurtainSwipeResistance) | The swipe resistance of the curtain. |
| `movingDuration` | [TimeInterval](https://developer.apple.com/documentation/foundation/timeinterval) | The time in seconds for reaching curtain to the nearest point. |
| `topBounce` | [Bool](https://developer.apple.com/documentation/swift/bool) | The boolean value that controls whether the curtain bounces past the top. |
| `bottomBounce` | [Bool](https://developer.apple.com/documentation/swift/bool) | The boolean value that controls whether the curtain bounces past the bottom. |
| `showsHandleIndicator` | [Bool](https://developer.apple.com/documentation/swift/bool) | The boolean that controls whether the curtain shows top handle indicator. |
| `handleIndicatorColor` | [UIColor](https://developer.apple.com/documentation/uikit/uicolor) | The color of the curtain's handle indicator. |
| `heightCoefficient` | [CGFloat](https://developer.apple.com/documentation/coregraphics/cgfloat) | The current readonly value that describes the ratio of the curtain actual height to the height of the content. |
| `actualHeight` | [CGFloat](https://developer.apple.com/documentation/coregraphics/cgfloat) | The current readonly value that describes the curtain actual height. |

### CurtainDelegate
**Curtain Delegate** is the protocol that allows receiving messages from [Curtain Controller](#curtaincontroller). **Curtain Delegate** provides a couple of functions.

Tells the delegate when thecCurtain did change ir's height state:
```swift
func curtain(_ curtain: Curtain, didChange heightState: CurtainHeightState)
```

Tells the delegate when the curtain is about to start dragging:
```swift
func curtainWillBeginDragging(_ curtain: Curtain)
```

Tells the delegate when dragging ended in the curtain:
```swift
func curtainDidEndDragging(_ curtain: Curtain)
```

Tells the delegate when the user draggs the curtain:
```swift
func curtainDidDrag(_ curtain: Curtain)
```

### CurtainHeightState

**Curtain height state** is an enumerator of height states of the curtain.

| Case | Description |
| :--- | :--- |
| min | Minimum defined height state. |
| mid | Intermediate defined height state. |
| max | Maximum defined height state. |
| hide | Hidden state. |

### CurtainSwipeResistance

**Curtain Swipe Resistance** is an enumerator of predefined (or custom) velocity swipe resistances available for the curtain.

| Case | Description |
| :--- | :--- |
| any | No resistance. Velocity value is 0. |
| low | Low resistance. Velocity value is 300. |
| normal | Normal resistance. Velocity value is 600. |
| high | High resistance. Velocity value is 900. |
| custom(velocity: CGFloat) | Custom resistance. Velocity value is what you set. |

## TODO

- Test gestures in the controller.
- Write unit tests.
- Update for iPad and big-phones horizontal screen.
- Write log messages for the wrong usage.
- Update animation parameters for grow smoothness.
- Fix horizontal scroll view work.
- Add videos that describe how to use SweetCurtain well.
- Add Swift Dependency way to install.

## Credits

- Ihor Malovanyi ([@multimediasuite](https://www.facebook.com/multimediasuite))

## License

SweetCurtain is released under the MIT license. See LICENSE for details.

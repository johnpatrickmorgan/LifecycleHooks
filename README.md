# 🎣 LifecycleHooks 🎣

[![Version](https://img.shields.io/cocoapods/v/LifecycleHooks.svg?style=flat)](http://cocoapods.org/pods/LifecycleHooks)
[![License](https://img.shields.io/cocoapods/l/LifecycleHooks.svg?style=flat)](http://cocoapods.org/pods/LifecycleHooks)
![Swift](https://img.shields.io/badge/Swift-4.0-orange.svg)

## About

LifecycleHooks allows custom code to be injected into views and view controllers in response to lifecycle events, e.g.,

	viewController.on(.viewDidAppear) { animated in
		print("View did appear", animated)
	}

The following lifecycle events are supported:

- `UIViewController` lifecycle hooks:

    - `viewDidLoad` 
    - `viewWillAppear`
    - `viewDidAppear`
    - `viewWillDisappear`
    - `viewDidDisappear`

- `UIView` lifecycle hooks:

    - `didMoveToWindow`

NOTE: Actions are run *after* the object's own implementation of the respective methods, with the exception of `viewDidLoad`, for which actions are run *before* the view controller's own `viewDidLoad` implementation. 

## How does it work?

Lifecycle events are automatically passed on to a view controller's children (and a view's subviews). By adding an invisible view / view controller into the hierarchy, the custom code can be executed at appropriate points. This was inspired by [this post](http://khanlou.com/2016/02/many-controllers/) by Soroush Khanlou. 

The approach has been refined to avoid forcing the target view controller's view to be loaded prematurely when the hook is added. This is achieved by using KVO to monitor when the view loads. This is how the `viewDidLoad` hook is implemented, and explains why that particular hook is run *before* `viewDidLoad` is called.

## Use cases

In most circumstances subclassing is sufficient to add lifecycle-dependent code directly into a view / view controller without needing external code injection. However, there are some cases where this is not possible, e.g.:

- When writing a `UIViewController` extension.
- When you need to customize a view controller from a third-party library, where you are not responsible for instantiating the view controller yourself.
- When adding a lifecycle-based behaviour to a view controller whose type is not known until runtime.
- Where multiple actions need to be added but singular inheritance makes this impractical.
- When writing tests for a view controller, e.g., where a test expectation should be fulfilled after a particular lifecycle event.

## Features

The following parameters allow for further customization of lifecycle hooks:

- `onceOnly`: Whether the hook should be performed once only or every time the lifecycle event is triggered.
- `priority`: If you add multiple hooks for a particular lifecycle event, they occur in priority order, (or in the order they were added if the priorities are the same).
- Hooks can be cancelled at any time by calling `cancel()` on the returned object.

## Installation

### CocoaPods

LifecycleHooks is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LifecycleHooks'
```

### Carthage

Add the following to your Cartfile:

```
github "johnpatrickmorgan/LifecycleHooks"
```

## License

LifecycleHooks is available under the MIT license. See the LICENSE file for more info.


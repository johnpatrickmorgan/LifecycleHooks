//
//  UIView+LifecycleHooking.swift
//  Pods
//
//  Created by John Morgan on 28/03/2016.
//
//

import Foundation

/**
 UIView lifecycle events which can be hooked into.
 
 - DidMoveToWindow: Called after the hooked view's `didMoveToWindow()` method.
 */
public enum ViewLifecycleHook {
    
    case DidMoveToWindow
}

extension UIView: LifecycleHooking {
    
    var hookObserver: HookObservingView  {
        
        if let observer = (subviews.flatMap { $0 as? HookObservingView }.first) {
            return observer
        }
        let observer = HookObservingView()
        addSubview(observer)
        return observer
    }

    /**
     Set an action to be invoked after a particular lifecycle hook.
     
     - parameter hook:     The lifecycle hook after which to invoke the action.
     - parameter onceOnly: The action should only ever be invoked once.
     - parameter priority: Allows multiple actions to be invoked in priority order.
     - parameter action:   A closure to be invoked after the lifecycle hook event.
     
     - returns: A cancellable object, on which `cancel()` can be called.
     */
    public func on(hook: ViewLifecycleHook, onceOnly: Bool = false, priority: HookPriority = .Medium, perform action: () -> Void) -> Cancellable? {
    
        return hookObserver.add(action, hook: hook, onceOnly: onceOnly, priority: priority)
    }
}

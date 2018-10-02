//
//  UIViewController+LifecycleHooking.swift
//  Pods
//
//  Created by John Morgan on 28/03/2016.
//
//

import Foundation

/**
 UIViewController lifecycle events which can be hooked into.
 
 - ViewWillAppear:    Called after `viewWillAppear(animated:)` returns.
 - ViewDidAppear:     Called after `viewDidAppear(animated:)` returns.
 - ViewWillDisappear: Called after `viewWillDisappear(animated:)` returns.
 - ViewDidDisappear:  Called after `viewDidDisappear(animated:)` returns.
 */
public enum ViewControllerLifecycleHook {
    
    case viewWillAppear
    case viewDidAppear
    case viewWillDisappear
    case viewDidDisappear
}

extension UIViewController: LifecycleHooking {
    
    var hookObserver: HookObservingViewController  {
        
        if let observer = (children.lazy.compactMap { $0 as? HookObservingViewController }.first) {
            return observer
        }
        let observer = HookObservingViewController()
        addChild(observer)
        
        self.onViewDidLoad(immediatelyIfAlreadyLoaded: true, priority: .highest) { [weak self] _ in
            self?.view.insertSubview(self!.hookObserver.view, at: 0)
            self?.hookObserver.didMove(toParent: self)
        }

        return observer
    }
    
    /**
     Set an action to be invoked when the view controller's view is set, immediately before `viewDidLoad` is called.
     
     - parameter immediately: Determines if the action should be invoked immediately if the view has already loaded.
     - parameter priority:    Allows multiple actions to be invoked in priority order.
     - parameter perform:     A closure to be invoked when the view controller's view is set.
     
     - returns: A cancellable object, on which `cancel()` can be called.
     */
    @discardableResult public func onViewDidLoad(immediatelyIfAlreadyLoaded immediately: Bool = false, priority: HookPriority = .medium, perform action: @escaping (_ alreadyLoaded: Bool) -> Void) -> Cancellable? {
        
        return hookObserver.addViewDidLoadAction(self, immediatelyIfAlreadyLoaded: immediately, perform: action)
    }
    
    /**
     Set an action to be invoked after a particular lifecycle hook.
     
     - parameter hook:     The lifecycle hook after which to invoke the action.
     - parameter onceOnly: The action should only ever be invoked once.
     - parameter priority: Allows multiple actions to be invoked in priority order.
     - parameter action:   A closure to be invoked after the lifecycle hook event.
     
     - returns: A cancellable object, on which `cancel()` can be called.
     */
    
    /**
     A convenience
     
     - parameter onceOnly: The action should only ever be invoked once.
     - parameter priority: Allows multiple actions to be invoked in priority order.
     - parameter perform:  A closure to be invoked after the lifecycle hook event.
     
     - returns: A cancellable object, on which `cancel()` can be called.
     */
    @discardableResult public func onView(_ hook: ViewLifecycleHook, onceOnly: Bool = false, priority: HookPriority = .medium, perform action: @escaping () -> Void) -> Cancellable? {
        
        return self.onViewDidLoad(immediatelyIfAlreadyLoaded: true, priority: priority) { [weak self] _ in
            
            self?.view.on(hook, onceOnly: onceOnly) {
                action()
            }
        }
    }
    
    /**
     Set an action to be invoked after a particular lifecycle hook.
     
     - parameter hook:     The lifecycle hook after which to invoke the action.
     - parameter onceOnly: The action should only ever be invoked once.
     - parameter priority: Allows multiple actions to be invoked in priority order.
     - parameter action:   A closure to be invoked after the lifecycle hook event.
     
     - returns: A cancellable object, on which `cancel()` can be called.
     */
    @discardableResult public func on(_ hook: ViewControllerLifecycleHook, onceOnly: Bool = false, priority: HookPriority = .medium, perform action: @escaping (Bool) -> Void) -> Cancellable? {

        return hookObserver.add(action, hook: hook, onceOnly: onceOnly, priority: priority)
    }
}

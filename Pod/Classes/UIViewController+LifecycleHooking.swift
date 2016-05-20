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
    
    case ViewWillAppear
    case ViewDidAppear
    case ViewWillDisappear
    case ViewDidDisappear
}

extension UIViewController: LifecycleHooking {
    
    var hookObserver: HookObservingViewController  {
        
        if let observer = (childViewControllers.flatMap { $0 as? HookObservingViewController
            }.first) {
                return observer
        }
        let observer = HookObservingViewController()
        addChildViewController(observer)
        
        self.onViewDidLoad(immediatelyIfAlreadyLoaded: true, priority: .Highest) { [weak self] _ in
            self?.view.insertSubview(self!.hookObserver.view, atIndex: 0)
            self?.hookObserver.didMoveToParentViewController(self)
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
    public func onViewDidLoad(immediatelyIfAlreadyLoaded immediately: Bool = false, priority: HookPriority = .Medium, perform action: (alreadyLoaded: Bool) -> Void) -> Cancellable? {
        
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
    public func onView(hook: ViewLifecycleHook, onceOnly: Bool = false, priority: HookPriority = .Medium, perform action: () -> Void) -> Cancellable? {
        
        return self.onViewDidLoad(immediatelyIfAlreadyLoaded: true, priority: priority) { [weak self] _ in
            
            self?.view.on(hook, onceOnly: onceOnly) { [weak self] in
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
    public func on(hook: ViewControllerLifecycleHook, onceOnly: Bool = false, priority: HookPriority = .Medium, perform action: Bool -> Void) -> Cancellable? {

        return hookObserver.add(action, hook: hook, onceOnly: onceOnly, priority: priority)
    }
}

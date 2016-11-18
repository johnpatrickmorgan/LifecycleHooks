//
//  HookObservingViewController.swift
//  Pods
//
//  Created by John Morgan on 28/03/2016.
//
//

import Foundation

/// Can be configured to run actions in response to view controller lifecycle events.
class HookObservingViewController: UIViewController, HookObserver {
    
    var kvoObservers = [HookKVObserver<UIViewController>]()
    
    var hooks = [ViewControllerLifecycleHook: [LifecycleAction<Bool>]]()
    
    //MARK: UIViewController lifecycle
    
    override func loadView() {
        
        view = InvisibleView()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        runHook(.ViewWillAppear, animated: animated)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        runHook(.ViewDidAppear, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        runHook(.ViewWillDisappear, animated: animated)
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        runHook(.ViewDidDisappear, animated: animated)
    }
    
    //MARK: HookObserver
    
    func add(action: Bool -> Void, hook: ViewControllerLifecycleHook, onceOnly: Bool, priority: HookPriority = .Medium) -> Cancellable {
        
        let lifecycleAction = LifecycleAction(performOnceOnly: onceOnly, priority: priority, action: action)
        
        var actions = (hooks[hook] ?? []) + [lifecycleAction]
        actions.stableSortInPlace { $0.priority > $1.priority }
        hooks[hook] = actions
        
        return Cancellation { [weak self, lifecycleAction] in
            
            self?.cancel(lifecycleAction, hook: hook)
        }
    }
    
    func addViewDidLoadAction(observed: UIViewController, immediatelyIfAlreadyLoaded: Bool = true, priority: HookPriority = .Medium, perform action: (alreadyLoaded: Bool) -> Void) -> Cancellable? {
        
        if observed.isViewLoaded() && immediatelyIfAlreadyLoaded {
            action(alreadyLoaded: true)
            return nil
        }
        
        let observer = HookKVObserver(object: observed, keyPath: "view", priority: priority)
        observer.observation = { [weak self] _, _, _ in
        
            action(alreadyLoaded: false)
            self?.kvoObservers.removeObject(observer)
        }
        
        kvoObservers.append(observer)
        kvoObservers.stableSortInPlace { $0.priority.value > $1.priority.value }
        
        return Cancellation { [weak self] in
            self?.kvoObservers.removeObject(observer)
        }
    }
    
    func cancel(action: LifecycleAction<Bool>, hook: ViewControllerLifecycleHook) {
        
        if let actions = hooks[hook], index = (actions.indexOf { $0 === action }) {
            hooks[hook]?.removeAtIndex(index)
        }
    }
    
    //MARK: Private
    
    private func runHook(hook: ViewControllerLifecycleHook, animated: Bool = false) {
        
        precondition(parentViewController != nil)
        
        for action in hooks[hook] ?? [] {
            
            action.perform(animated)
            
            if action.performOnceOnly {
                cancel(action, hook: hook)
            }
        }
    }
}

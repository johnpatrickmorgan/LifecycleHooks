//
//  HookObservingView.swift
//  Pods
//
//  Created by John Morgan on 28/03/2016.
//
//

import Foundation

/// Can be configured to run actions in response to view lifecycle events.
class HookObservingView: InvisibleView, HookObserver {
    
    //MARK: Properties
    
    var hooks = [ViewLifecycleHook: [LifecycleAction<Void>]]()
    
    //MARK: UIView lifecycle
    
    override func didMoveToWindow() {
        
        super.didMoveToWindow()
        
        runHook(.didMoveToWindow)
    }
    
    //MARK: HookObserver
    
    func add(_ action: @escaping (()) -> Void, hook: ViewLifecycleHook, onceOnly: Bool, priority: HookPriority = .medium) -> Cancellable {
        
        let lifecycleAction = LifecycleAction(performOnceOnly: onceOnly, priority: priority, action: action)
        
        var actions = (hooks[hook] ?? []) + [lifecycleAction]
        actions.stableSortInPlace { $0.priority > $1.priority }
        hooks[hook] = actions
        
        return Cancellation { [weak self, lifecycleAction] in
            
            self?.cancel(lifecycleAction, hook: hook)
        }
    }
    
    func cancel(_ action: LifecycleAction<Void>, hook: ViewLifecycleHook) {
        
        if let actions = hooks[hook], let index = (actions.firstIndex { $0 === action }) {
            hooks[hook]?.remove(at: index)
        }
    }
    
    //MARK: Private
    
    fileprivate func runHook(_ hook: ViewLifecycleHook) {
        
        precondition(superview != nil)
        
        for action in hooks[hook] ?? [] {
            
            action.perform(())
            
            if action.performOnceOnly {
                cancel(action, hook: hook)
            }
        }
    }
}

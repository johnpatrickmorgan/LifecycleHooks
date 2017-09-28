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
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        runHook(.viewWillAppear, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        runHook(.viewDidAppear, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        runHook(.viewWillDisappear, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        runHook(.viewDidDisappear, animated: animated)
    }
    
    //MARK: HookObserver
    
    @discardableResult func add(_ action: @escaping (Bool) -> Void, hook: ViewControllerLifecycleHook, onceOnly: Bool, priority: HookPriority = .medium) -> Cancellable {
        
        let lifecycleAction = LifecycleAction(performOnceOnly: onceOnly, priority: priority, action: action)
        
        var actions = (hooks[hook] ?? []) + [lifecycleAction]
        actions.stableSortInPlace { $0.priority > $1.priority }
        hooks[hook] = actions
        
        return Cancellation { [weak self, lifecycleAction] in
            
            self?.cancel(lifecycleAction, hook: hook)
        }
    }
    
    @discardableResult func addViewDidLoadAction(_ observed: UIViewController, immediatelyIfAlreadyLoaded: Bool = true, priority: HookPriority = .medium, perform action: @escaping (_ alreadyLoaded: Bool) -> Void) -> Cancellable? {
        
        if observed.isViewLoaded && immediatelyIfAlreadyLoaded {
            action(true)
            return nil
        }
        
        let observer = HookKVObserver(object: observed, keyPath: "view", priority: priority)
        observer.observation = { [weak self, weak observer] _, _, _ in
            guard let observer = observer else { return }
        
            action(false)
            self?.kvoObservers.removeObject(observer)
        }
        
        kvoObservers.append(observer)
        kvoObservers.stableSortInPlace { $0.priority.value > $1.priority.value }
        
        return Cancellation { [weak self, weak observer] in
            guard let observer = observer else { return }
            
            self?.kvoObservers.removeObject(observer)
        }
    }
    
    func cancel(_ action: LifecycleAction<Bool>, hook: ViewControllerLifecycleHook) {
        
        if let actions = hooks[hook], let index = (actions.index { $0 === action }) {
            hooks[hook]?.remove(at: index)
        }
    }
    
    //MARK: Private
    
    fileprivate func runHook(_ hook: ViewControllerLifecycleHook, animated: Bool = false) {
        
        precondition(parent != nil)
        
        for action in hooks[hook] ?? [] {
            
            action.perform(animated)
            
            if action.performOnceOnly {
                cancel(action, hook: hook)
            }
        }
    }
}

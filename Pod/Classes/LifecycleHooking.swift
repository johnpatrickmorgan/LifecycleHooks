//
//  LifecycleHooking.swift
//  Pods
//
//  Created by John Morgan on 28/03/2016.
//
//

/// A general protocol for objects that can ensure provided actions are performed after certain lifecycle hooks.
public protocol LifecycleHooking {
    
    typealias Hook
    typealias Action
    
    func on(hook: Hook, onceOnly: Bool, priority: HookPriority, perform: Action) -> Cancellable?
}

/// Hooks are performed in order of HookPriority.
public enum HookPriority {
    
    case Highest
    case High
    case Medium
    case Low
    case Lowest
    
    case Custom(Int)
    
    public var value: Int {
        switch self {
        case Highest:
            return 1000
        case High:
            return 750
        case Medium:
            return 500
        case Low:
            return 250
        case Lowest:
            return 0
        case .Custom(let priority):
            return min(max(priority, 0), 1000)
        }
    }
}

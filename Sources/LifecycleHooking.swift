//
//  LifecycleHooking.swift
//  Pods
//
//  Created by John Morgan on 28/03/2016.
//
//

/// A general protocol for objects that can ensure provided actions are performed after certain lifecycle hooks.
public protocol LifecycleHooking {
    
    associatedtype Hook
    associatedtype Action
    
    @discardableResult func on(_ hook: Hook, onceOnly: Bool, priority: HookPriority, perform: Action) -> Cancellable?
}

/// Hooks are performed in order of HookPriority.
public enum HookPriority {
    
    case highest
    case high
    case medium
    case low
    case lowest
    
    case custom(Int)
    
    public var value: Int {
        switch self {
        case .highest:
            return 1000
        case .high:
            return 750
        case .medium:
            return 500
        case .low:
            return 250
        case .lowest:
            return 0
        case .custom(let priority):
            return min(max(priority, 0), 1000)
        }
    }
}

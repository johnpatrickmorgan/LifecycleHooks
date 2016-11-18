//
//  HookObserver.swift
//  Pods
//
//  Created by John Morgan on 28/03/2016.
//
//

import Foundation

/// Defines an interface for an object which can manage a series of actions to be invoked after certain hook events.
protocol HookObserver {
    
    associatedtype Hook
    associatedtype Context
    
    func add(action: Context -> Void, hook: Hook, onceOnly: Bool, priority: HookPriority) -> Cancellable
}

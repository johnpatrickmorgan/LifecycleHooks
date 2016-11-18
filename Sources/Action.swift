//
//  Action.swift
//  Pods
//
//  Created by John Morgan on 07/04/2016.
//
//

import Foundation

/// Captures data related to an action to be performed after a particular Lifecycle event.
class LifecycleAction<Args> {
    
    var performOnceOnly: Bool
    
    var perform: (Args) -> Void
    
    var priority: Int
    
    init(performOnceOnly: Bool = false, priority: HookPriority, action: @escaping (Args) -> Void) {
        
        self.performOnceOnly = performOnceOnly
        self.priority = priority.value
        self.perform = action
    }
}

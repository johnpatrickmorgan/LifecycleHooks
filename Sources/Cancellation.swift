//
//  Cancellation.swift
//  Pods
//
//  Created by John Morgan on 07/04/2016.
//
//

import Foundation

/// An object which can be cancelled.
public protocol Cancellable {
    
    func cancel()
}

/// An anonymous object to be returned by lifecycle hook methods, so that they can be cancelled.
struct Cancellation: Cancellable {
    
    var cancelAction: () -> Void
    
    init(cancelAction: @escaping () -> Void) {
        
        self.cancelAction = cancelAction
    }
    
    func cancel() {
        
        cancelAction()
    }
}

//
//  KeyValueObserver.swift
//  Pods
//
//  Created by John Morgan on 07/04/2016.
//
//

import Foundation

/// A simple closure-based key-value observation helper.
class KeyValueObserver<Observed: NSObject>: NSObject {
    
    typealias Observation = (object: Observed, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) -> Void
    
    var observation: Observation?
    var keyPath: String
    weak var object: Observed?
    
    init(object: Observed, keyPath: String, observation: Observation? = nil) {
        
        self.observation = observation
        self.keyPath = keyPath
        self.object = object
        
        super.init()
        
        object.addKeyValueObserver(self)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        guard let keyPath = keyPath where keyPath == self.keyPath else { return }
        
        guard let observedObject = object as? Observed else { return }
        
        observation?(object: observedObject, change: change, context: context)
    }

    deinit {
        
        object?.removeKeyValueObserver(self)
    }
}

/// A specialization of KeyValueObserver to allow priority to be included.
class HookKVObserver<Observed: NSObject>: KeyValueObserver<Observed> {

    var priority: HookPriority
    
    init(object: Observed, keyPath: String, priority: HookPriority = .Medium, observation: Observation? = nil) {
        
        self.priority = priority
        
        super.init(object: object, keyPath: keyPath, observation: observation)
    }
}

/// Convenience methods to make working with KeyValueObservers less verbose.
extension NSObject {
    
    func addKeyValueObserver<T>(observer: KeyValueObserver<T>, options: NSKeyValueObservingOptions = [], context: UnsafeMutablePointer<Void> = nil) {
        
        addObserver(observer, forKeyPath: observer.keyPath, options: options, context: context)
    }
    
    func removeKeyValueObserver<T>(observer: KeyValueObserver<T>) {
        
        removeObserver(observer, forKeyPath: observer.keyPath)
    }
}

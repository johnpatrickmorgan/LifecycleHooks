//
//  InvisibleView.swift
//  Pods
//
//  Created by John Morgan on 06/04/2016.
//
//

import UIKit

/// A view that will never be visible.
class InvisibleView: UIView {
    
    override var hidden: Bool {
        get {
            return super.hidden
        }
        set {
            precondition(newValue == true)
            super.hidden = newValue
        }
    }
    
    override var userInteractionEnabled: Bool {
        get {
            return super.hidden
        }
        set {
            precondition(newValue == false)
            super.hidden = newValue
        }
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        hide()
    }

    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        hide()
    }
    
    func hide() {
        
        hidden = true
        userInteractionEnabled = false
    }
}

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
    
    override var isHidden: Bool {
        get {
            return super.isHidden
        }
        set {
            precondition(newValue == true)
            super.isHidden = newValue
        }
    }
    
    override var isUserInteractionEnabled: Bool {
        get {
            return super.isHidden
        }
        set {
            precondition(newValue == false)
            super.isHidden = newValue
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
        
        isHidden = true
        isUserInteractionEnabled = false
    }
}

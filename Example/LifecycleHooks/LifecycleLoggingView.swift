//
//  LifecycleLoggingView.swift
//  LifecycleHooks
//
//  Created by John Morgan on 08/04/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class LifecycleLoggingView: UIView {

    override func didMoveToWindow() {
        
        super.didMoveToWindow()
        
        print("Native \(#function)")
    }
}

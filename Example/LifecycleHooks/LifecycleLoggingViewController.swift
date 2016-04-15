//
//  LifecycleLoggingViewController.swift
//  LifecycleHooks
//
//  Created by John Morgan on 08/04/2016.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class LifecycleLoggingViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        print("Native \(__FUNCTION__)")
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        print("Native \(__FUNCTION__)")
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        print("Native \(__FUNCTION__)")
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        print("Native \(__FUNCTION__)")
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        print("Native \(__FUNCTION__)")
    }
}

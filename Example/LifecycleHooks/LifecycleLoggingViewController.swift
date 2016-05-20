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

        logLifecycleMethod()

    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        logLifecycleMethod()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        logLifecycleMethod()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        logLifecycleMethod()
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        logLifecycleMethod()
    }
    
    func logLifecycleMethod(methodName: String = #function) {
        
        print("Native \(methodName)")
        
    }
}

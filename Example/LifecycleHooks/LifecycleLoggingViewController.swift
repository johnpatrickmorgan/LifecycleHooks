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

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        logLifecycleMethod()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        logLifecycleMethod()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        logLifecycleMethod()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        
        logLifecycleMethod()
    }
    
    func logLifecycleMethod(_ methodName: String = #function) {
        
        print("Native \(methodName)")
        
    }
}

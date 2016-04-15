//
//  AppDelegate.swift
//  LifecycleHooks
//
//  Created by johnmorgan on 03/19/2016.
//  Copyright (c) 2016 johnmorgan. All rights reserved.
//

import UIKit
import LifecycleHooks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let firstTab = (window?.rootViewController as? UITabBarController)?.viewControllers?.first
        if let testViewController = firstTab as? LifecycleLoggingViewController {
            
            testViewController.onViewDidLoad() { [weak testViewController] _ in
                testViewController?.label.text = "CHANGED"
                print("Hooked viewDidLoad")
            }
            
            testViewController.onView(.DidMoveToWindow) { _ in
                print("Hooked didMoveToWindow")
            }
            
            testViewController.on(.ViewWillAppear) { _ in
                print("Hooked viewWillAppear")
            }
            
            testViewController.on(.ViewDidAppear) { _ in
                print("Hooked viewDidAppear")
            }
            
            testViewController.on(.ViewWillDisappear) { _ in
                print("Hooked viewWillDisappear")
            }
            
            testViewController.on(.ViewDidDisappear) { _ in
                print("Hooked viewDidDisappear")
            }

            print("All hooks added")
        }
        return true
    }
}


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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let firstTab = (window?.rootViewController as? UITabBarController)?.viewControllers?.first
        if let testViewController = firstTab as? LifecycleLoggingViewController {
            
            testViewController.onViewDidLoad() { [weak testViewController] _ in
                testViewController?.label.text = "CHANGED"
                print("Hooked viewDidLoad")
            }
            
            testViewController.onView(.didMoveToWindow) {
                print("Hooked didMoveToWindow")
            }
            
            testViewController.on(.viewWillAppear) { _ in
                print("Hooked viewWillAppear")
            }
            
            testViewController.on(.viewDidAppear) { _ in
                print("Hooked viewDidAppear")
            }
            
            testViewController.on(.viewWillDisappear) { _ in
                print("Hooked viewWillDisappear")
            }
            
            testViewController.on(.viewDidDisappear) { _ in
                print("Hooked viewDidDisappear")
            }
            
            print("All hooks added")
        }
        return true
    }
}


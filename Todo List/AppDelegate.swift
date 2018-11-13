//
//  AppDelegate.swift
//  Todo List
//
//  Created by Wmotion Mac 101 on 5/9/18.
//  Copyright © 2018 Wmotion Mac 101. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        return true
    }

}


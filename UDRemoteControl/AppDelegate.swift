//
//  AppDelegate.swift
//  UDRemoteControl
//
//  Created by UDLab on 06/12/15.
//  Copyright © 2015 UDLab. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    
    //KEY Constant for userDefaults
    let driverNameKey = "driverName"
    let AnonymousOption = "anonymous"
    let qos = "qos"
    let password = "password"
    let lastIp = "Ip"
    let lastPort = "port"
    let gyroSensitivity = "gyroSens"
    let gyroAccelerate = "gyroacc"
    let gyroSteer = "gyroturn"
    



    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        let storyBoard:UIStoryboard = UIStoryboard.init(name: "Main", bundle: NSBundle.mainBundle())
        
        if ((userDefaults.valueForKey(driverNameKey)?.empty) != nil){
            let secondViewController:UIViewController = storyBoard.instantiateViewControllerWithIdentifier("UserDetails")
            self.window?.rootViewController = secondViewController
        }else{
            let loginViewController:UIViewController = storyBoard.instantiateViewControllerWithIdentifier("CreateUser")
            self.window?.rootViewController = loginViewController
            firstTime()
            
        }
        return true
    }
    
    func firstTime(){
        userDefaults.setInteger(75, forKey: gyroSensitivity)
        userDefaults.setBool(true, forKey: gyroSteer)
        userDefaults.setBool(true, forKey: gyroAccelerate)
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    



}


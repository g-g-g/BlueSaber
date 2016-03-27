//
//  AppDelegate.swift
//  Saber
//
//  Created by Ganesh Gautham on 1/3/16.
//  Copyright © 2016 Ganesh Gautham Industries. All rights reserved.
//

//Frameworks
import UIKit    //For UI


//ViewController class
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //Variables
    var window: UIWindow?

    //Fuctions
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        // Siren is a singleton
        let siren = Siren.sharedInstance
        
        // Required: Your app's iTunes App Store ID
        siren.appID = "1076077872"
        
        // Optional: Defaults to .Option
        siren.alertType = .Option
        
        /*
        Replace .Immediately with .Daily or .Weekly to specify a maximum daily or weekly frequency for version
        checks.
        */
        siren.checkVersion(.Immediately)
        return true
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
        /*
        Useful if user returns to your app from the background after being sent to the
        App Store, but doesn't update their app before coming back to your app.
        
        ONLY USE WITH SirenAlertType.Force
        */
        
        //  Siren.sharedInstance.checkVersion(.Immediately)
    }
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        /*
        Perform daily (.Daily) or weekly (.Weekly) checks for new version of your app.
        Useful if user returns to your app from the background after extended period of time.
        Place in applicationDidBecomeActive(_:).	*/
        
        Siren.sharedInstance.checkVersion(.Immediately)
        
    }
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
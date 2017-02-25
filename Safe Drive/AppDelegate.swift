//
//  AppDelegate.swift
//  Safe Drive
//
//  Created by Andrew Stratmann on 2/24/17.
//  Copyright © 2017 JISS-ISU. All rights reserved.
//

import UIKit
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    //Add manager for location data
    var manager = CLLocationManager();

    
    var testTimer : Timer? = nil;
    


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //set the desired accuracy to maximum
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        
        //who knows what this does??
        manager.delegate = self;
        
        //request the user for indefinite authorization
        manager.requestAlwaysAuthorization();
        
        //let the manager update in the background.
        manager.allowsBackgroundLocationUpdates = true;
        
        manager.startUpdatingLocation();
        
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum);

        
        
        return true;
    }
    
    
    
    //handles something - we don't know what
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        //blank
    }
    
    
    //need a function containing the timer information
    func timerFired(){
        
        //these two lines stop the timer and reset it to zero
        testTimer?.invalidate();
        testTimer = nil;
        
        //this line gets the current location
        manager.startUpdatingLocation();
        
        
    }
    

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //do something with the location data
        //also, check for the screen being on
        //if not, the push notification should not send
 
        //TODO
        //get the current location data and perform the check for a high speed
        
        var currentLoc = manager.location;
        var currentSpeed = currentLoc?.speed;
        
        //prints the current speed of the phone to the developer console
        print(currentSpeed!);
        
        
        
        
        
        
        // reschedule the timer
        Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(timerFired), userInfo: nil, repeats: false);
        
        
        
        
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        //disable the GPS location to use less battery power
        manager.startMonitoringSignificantLocationChanges();
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


//
//  AppDelegate.swift
//  Safe Drive
//
//  Created by Andrew Stratmann on 2/24/17.
//  Copyright © 2017 JISS-ISU. All rights reserved.
//

import UIKit
import CoreLocation
import CoreFoundation
import NotificationCenter
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    //Add manager for location data
    var manager = CLLocationManager();
    
    //add notificaiton center - nothing to do with any location
    let center = UNUserNotificationCenter.current()
    
    //create a new timer
    var testTimer : Timer? = nil;
    
    //initialize to the 'screen on' status
    var lockChanges = "O";
    
    
    //if the status of the phone lock changes, flip lockChanges
    func callbackLock(_ name: NSString){
        if(name.isEqual("com.apple.springboard.lockcomplete")){
            print("phone locked");
        }
        else{
            print("phone lock status changed");
            if(lockChanges == "O"){
                lockChanges = "X";
            }
            else{
                lockChanges = "O";
            }
        }
    }
    
    
    //runs on application startup
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //set the desired accuracy to maximum
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        
        //who knows what this does??
        manager.delegate = self;
        
        //request the user for indefinite authorization
        manager.requestAlwaysAuthorization();
        
        
        
        //set up options for notification authorization
        let options : UNAuthorizationOptions = [.badge, .sound, .alert]
        
        //ask for permission
        center.requestAuthorization (options: options){
            ( granted, error)in
            if !granted{
                print(" something has gone terribly awry!");
            }
        }
        
        //let the manager update in the background.
        manager.allowsBackgroundLocationUpdates = true;
        
        manager.startUpdatingLocation();
        
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum);
        
        
        
        //the two lock events we want to track
        let lockEventName : CFString = "com.apple.springboard.lockcomplete" as CFString;
        let unlockEventName : CFString = "com.apple.springboard.lockstate" as CFString;
        
        //not clear on what this accomplishes, but it is definitely necessary
        let observer = UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque());
        
        //add the listener for the phone locking
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
            observer, // observer
            { (_, observer, name, _, _) -> Void in
                
                
                if let observer = observer, let name = name {
                    
                    
                    //extract pointer to 'self' from void pointer
                    let mySelf = Unmanaged<AppDelegate>.fromOpaque(observer).takeUnretainedValue();
                    
                   
                    
                    //call method
                    mySelf.callbackLock(name.rawValue as NSString);
                }
            }, // callback
            lockEventName, // event name
            nil, // object
            CFNotificationSuspensionBehavior(rawValue: CFIndex(kCFNotificationDeliverImmediately))!);
        
        
        //add the listener for the lock status changing
        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), //center
            observer, // observer
            { (_, observer, name, _, _) -> Void in
                
                
                if let observer = observer, let name = name {
                    
                    
                    //extract pointer to 'self' from void pointer
                    let mySelf = Unmanaged<AppDelegate>.fromOpaque(observer).takeUnretainedValue();
                    
                    
                    
                    //call method
                    mySelf.callbackLock(name.rawValue as NSString);
                }
            }, // callback
            unlockEventName, // event name
            nil, // object
            CFNotificationSuspensionBehavior(rawValue: CFIndex(kCFNotificationDeliverImmediately))!);
        
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
    

    
    //runs anytime there is location data to report - currently every 6 seconds or less
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //do something with the location data
        //also, check for the screen being on
        //if not, the push notification should not send
 
        let currentLoc = manager.location;
        let currentSpeed = currentLoc?.speed;
        
        //prints the current speed of the phone to the developer console
        print(currentSpeed!);
        
        //speed is in m/s
        //convert to km/h
        let convSpeed = currentSpeed! / 1.0; //change later
        
        //generate a local notification if the speed is greater than the threshold, and
        if(convSpeed > 1 && lockChanges == "O"){
            
            print("locks ", lockChanges);
            //finally, we are here!
            
            //send a push notification to the user alerting him/her to
            // stop using the device while driving
            
            //initialize the push notification
            let content = UNMutableNotificationContent()
            content.title = "Safe Drive"
            content.body = " Please don't use your phone when driving"
            content.sound = UNNotificationSound.default();
            
            
            //set trigger - fire after 1 second
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false);
            let identifier = "unsafedrivingnotification";
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger);
            center.add(request, withCompletionHandler: {(error) in
                if error != nil {
                    // something has gone terribly awry
                    print("notification error");
                }
            })
            
            
        }
        
        
        // reschedule the timer - ensures that loction data is collected within 6 seconds - probably more
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
        //manager.startMonitoringSignificantLocationChanges();
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

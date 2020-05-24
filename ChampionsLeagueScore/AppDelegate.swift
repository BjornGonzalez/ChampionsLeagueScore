//
//  AppDelegate.swift
//  ChampionsLeagueScore
//
//  Created by Björn Gonzalez on 2020-02-17.
//  Copyright © 2020 Bjorn Gonzalez. All rights reserved.
//

import UIKit
import GoogleSignIn
import TwitterKit
import FirebaseCore
import FBSDKCoreKit
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private func requestNotificationAuthorization(application: UIApplication){
        
        let center = UNUserNotificationCenter.current()
        let option: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        center.requestAuthorization(options: option) { granted, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        requestNotificationAuthorization(application: application)
        ApplicationDelegate.shared.application(
                application,
                didFinishLaunchingWithOptions: launchOptions
            )
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        FirebaseApp.configure()
        
        // Google sign in customer id and keys
        GIDSignIn.sharedInstance().clientID = "81699097335-1ji89vks5tcjcnikgps4qmkp1v6ijeep.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        
        // Twitter sign in customer id and keys.
        TWTRTwitter.sharedInstance().start(withConsumerKey: "kzx4IBcU88DIW3UxXBO1PUAtp", consumerSecret:"hxamlBmQxdG9umHhfgKvNIgUvBiKKbVNZdIUO04E8EdOL5b1zr")
        if UserDefaults.standard.getIDToken() != nil {
            moveOnHomeScreen()
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // If user previously logged into the system then directly move onto the home page.
    func moveOnHomeScreen() {
        let story = UIStoryboard(name: "Main", bundle:nil)
        let vc = story.instantiateViewController(withIdentifier: "TableResultMatchesViewController") as! TableResultMatchesViewController
        let navVc = UINavigationController(rootViewController: vc)
        navVc.navigationBar.isTranslucent = true
        navVc.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navVc.navigationBar.shadowImage = UIImage()
        navVc.view.backgroundColor = .clear
        UIApplication.shared.windows.first?.rootViewController = navVc
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

}

// Google Sign In
extension AppDelegate: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
          // [START_EXCLUDE silent]
          // [END_EXCLUDE]
          return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        _ = user.authentication.idToken // Safe to send to the server
        _ = user.profile.name
        _ = user.profile.givenName
        _ = user.profile.familyName
        _ = user.profile.email
        // [START_EXCLUDE]
        // Saving Value in userDefaults
        
        
        if let userId = userId {
            // saving access token into the userdefaults so we can judge next time that use is logged in or not.
            // Save all the token into this userdefaults.
            // After login into the google we need to send the detail on our server.
            UserDefaults.standard.saveIDToken(userID: userId)
            moveOnHomeScreen()
        }
        
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // [START_EXCLUDE]
      NotificationCenter.default.post(
        name: Notification.Name(rawValue: "ToggleAuthUINotification"),
        object: nil,
        userInfo: ["statusText": "User has disconnected."])
        // [END_EXCLUDE]
    }
}

// Twitter sign in
extension AppDelegate {
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        var valueTwitter: Bool = true

        valueTwitter =  TWTRTwitter.sharedInstance().application(app, open: url, options: options)
        return valueTwitter
    }

    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if (extensionPointIdentifier == .keyboard) {
            return false
        }
        return true
    }

}
extension AppDelegate: UNUserNotificationCenterDelegate {
    
}
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
      print("Firebase registration token: \(fcmToken)")

      let dataDict:[String: String] = ["token": fcmToken]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}

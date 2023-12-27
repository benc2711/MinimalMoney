//
//  MinimalMoneyApp.swift
//  MinimalMoney
//
//  Created by Ben Crotty on 11/20/23.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      UIApplication.shared.registerForRemoteNotifications()
      UNUserNotificationCenter.current().delegate = self
    FirebaseApp.configure()

    return true
  }
    
    func application(_ application: UIApplication,
                                    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Forward the token to your server
        let token = deviceToken.reduce("") { $0 + String(format: "%02X", $1) }
        print("token \(token)")
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // The token is not currently available
        print("Remote Notification is not available \(error.localizedDescription)")
    }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
    }
  }
}

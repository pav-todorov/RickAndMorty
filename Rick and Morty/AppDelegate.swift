//
//  AppDelegate.swift
//  Rick and Morty
//
//  Created by Pavel Todorov on 1.07.21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        guard let font = UIFont(name: "get schwifty", size: 34) else {
            fatalError("custom font not found")
        }
        
        let myColor = UIColor(displayP3Red: 35/255, green: 39/255, blue: 50/255, alpha: 1.0)
        
        UIBarButtonItem.appearance().tintColor = .white
        UINavigationBar.appearance().prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 54/255, green: 164/255, blue: 193/255, alpha: 1.0),
            NSAttributedString.Key.strokeColor : UIColor(displayP3Red: 202/255, green: 215/255, blue: 85/255, alpha: 1.0),
            NSAttributedString.Key.strokeWidth : -2.0,
            NSAttributedString.Key.font : font]
        navBarAppearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(displayP3Red: 54/255, green: 164/255, blue: 193/255, alpha: 1.0),
NSAttributedString.Key.strokeColor : UIColor(displayP3Red: 202/255, green: 215/255, blue: 85/255, alpha: 1.0),
        NSAttributedString.Key.strokeWidth : -2.0,
        NSAttributedString.Key.font : font]
        navBarAppearance.backgroundColor = myColor
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        
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
}

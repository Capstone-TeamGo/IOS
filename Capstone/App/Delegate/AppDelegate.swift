//
//  AppDelegate.swift
//  Capstone
//
//  Created by 정성윤 on 2024/03/26.
//

import UIKit
import SwiftKeychainWrapper
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        //로그인 유무 체크가 필요(메서드)
        if let _ = KeychainWrapper.standard.string(forKey: "JWTaccessToken"),
           let _ = KeychainWrapper.standard.string(forKey: "JWTrefreshToken"){
            let viewController = TabBarViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navigationController
        }else{
            let viewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navigationController
        }
        window?.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }


}


//
//  SceneDelegate.swift
//  Capstone
//
//  Created by 정성윤 on 2024/03/26.
//

import UIKit
import SwiftKeychainWrapper

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        guard let windowScene = (scene as? UIWindowScene) else {return}
        window = UIWindow(frame: UIScreen.main.bounds)
        //로그인 유무 체크가 필요(메서드)
        if let _ = KeychainWrapper.standard.string(forKey: "JWTaccessToken"),
           let _ = KeychainWrapper.standard.string(forKey: "JWTrefreshToken"){
            let viewController = ConsultingViewController(analysisId: "")
            let navigationController = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navigationController
        }else{
            let viewController = LoginViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navigationController
        }
        window?.makeKeyAndVisible() //화면에 보이게끔
        window?.windowScene = windowScene
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
       
    }

    func sceneWillResignActive(_ scene: UIScene) {
        
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }


}


//
//  TabBarViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/03/27.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AuthenticationServices

class TabBarViewController: UITabBarController {
    //MARK: UI Components
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
}
//MARK: - UI TabBar
extension TabBarViewController {
    private func setTabBar() {
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.tabBar.layer.shadowOpacity = 3
        self.tabBar.layer.shadowColor = UIColor.gray.cgColor
        self.tabBar.tintColor = .ThirdryColor
        
        let HomeVC = MainViewController()
        HomeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
        let homeNavigationController = UINavigationController(rootViewController: HomeVC)
        
        let MypageVC = MainViewController()
        MypageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person.fill"), tag: 1)
        let mypageNavigationController = UINavigationController(rootViewController: MypageVC)
        viewControllers = [homeNavigationController, mypageNavigationController]
    }
}

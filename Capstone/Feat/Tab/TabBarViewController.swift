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

final class TabBarViewController: UITabBarController {
    private let disposeBag = DisposeBag()
    private let reissueViewModel = ReissueViewModel()
    //MARK: UI Components
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        //토큰 유효성 검사
        reissueViewModel.reissueTrigger.onNext(())
        reissueViewModel.reissueExpire.bind { expire in
            if expire == true {
                self.navigationController?.pushViewController(LoginViewController(), animated: true)
            }else{
                print("TabBar - JWTaccessToken not Expired!")
            }
        }.disposed(by: disposeBag)
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
private extension TabBarViewController {
    private func setTabBar() {
        self.tabBar.backgroundColor = .white
        self.tabBar.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.tabBar.layer.shadowOpacity = 3
        self.tabBar.layer.shadowColor = UIColor.gray.cgColor
        self.tabBar.tintColor = .FifthryColor
        
        let HomeVC = MainViewController()
        HomeVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house.fill"), tag: 0)
        let homeNavigationController = UINavigationController(rootViewController: HomeVC)
        
        let MypageVC = MypageViewController()
        MypageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person.fill"), tag: 1)
        let mypageNavigationController = UINavigationController(rootViewController: MypageVC)
        viewControllers = [homeNavigationController, mypageNavigationController]
    }
}

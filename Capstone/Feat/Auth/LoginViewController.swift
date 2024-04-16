//
//  ViewController.swift
//  Capstone
//
//  Created by 정성윤 on 2024/03/26.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import AuthenticationServices
class LoginViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let loginViewModel = LoginViewModel()
    //MARK: UI Components
    private let image : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .PrimaryColor
        view.image = UIImage(named: "Splash")
        view.contentMode = .scaleAspectFit
        return view
    }()
    private let appleBtn : ASAuthorizationAppleIDButton = {
        let btn = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setBinding()
    }
}
//MARK: - UI Layout
extension LoginViewController {
    private func setLayout() {
        self.view.backgroundColor = .PrimaryColor
        self.view.addSubview(image)
        self.view.addSubview(appleBtn)
        image.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(0)
        }
        appleBtn.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(100)
        }
    }
}
//MARK: - UI Binding
extension LoginViewController{
    private func setBinding() {
        appleBtn.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [weak self] in
                guard let self = self else{return}
                self.loginViewModel.appleLoginTrigger.onNext(())
            })
            .disposed(by: disposeBag)
        loginViewModel.appleLoginSuccess
            .subscribe(onNext: { [weak self] in
                guard let self = self else{return}
                self.navigationController?.pushViewController(TabBarViewController(), animated: true)
            })
            .disposed(by: disposeBag)
    }
}

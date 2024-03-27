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
class LoginViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    //MARK: UI Components
    private let image : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .PrimaryColor
        view.image = UIImage(named: "Splash")
        view.contentMode = .scaleAspectFit
        return view
    }()
    private lazy var appleBtn : ASAuthorizationAppleIDButton = {
        let btn = ASAuthorizationAppleIDButton(type: .signIn, style: .black)
        btn.addTarget(self, action: #selector(handleAppleSignInButtonTapped), for: .touchUpInside)
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
        
    }
}
//MARK: - AppleLoginDelegate
extension LoginViewController {
    @objc func handleAppleSignInButtonTapped() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let code = appleIDCredential.authorizationCode,
               let name = appleIDCredential.fullName {
                print("사용자 코드 \(code), 이름 \(name)")
                self.navigationController?.pushViewController(MainViewController(), animated: true)
            }
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 오류 \(error)")
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

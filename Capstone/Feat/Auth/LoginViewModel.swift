//
//  LoginViewModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/04/16.
//

import Foundation
import RxSwift
import RxCocoa
import AuthenticationServices

class LoginViewModel : NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private lazy var disposeBag = DisposeBag()
    private lazy var loginViewController = LoginViewController()
    //로그인
    let appleLoginTrigger = PublishSubject<Void>()
    let appleLoginSuccess : PublishSubject<Void> = PublishSubject()
    override init() {
        super.init()
        self.appleLoginTrigger.subscribe(onNext: {[weak self] in
            guard let self = self else{return}
            self.handleAppleSignInButtonTapped()
        })
        .disposed(by: disposeBag)
    }
    private func handleAppleSignInButtonTapped() {
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
               let name = appleIDCredential.fullName,
               let identityToken = appleIDCredential.identityToken{
                let email = appleIDCredential.email ?? "Permission@Denied"
                print("AuthCode : \(code)\nFullName : \(name)\nidToken : \(identityToken)\nemail : \(email)")
                self.appleLoginSuccess.onNext(())
            }
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 오류 \(error)")
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.loginViewController.view.window!
    }
}

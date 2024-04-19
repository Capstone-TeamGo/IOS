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
import SwiftKeychainWrapper

class LoginViewModel : NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    private lazy var disposeBag = DisposeBag()
    private lazy var loginViewController = LoginViewController()
    //애플 로그인
    let appleLoginTrigger = PublishSubject<Void>()
    let appleLoginSuccess : PublishSubject<Void> = PublishSubject()
    
    //서버 로그인
    let serverLoginTrigger = PublishSubject<LoginRequestModel>()
    let serverLoginResult : PublishSubject<LoginResponseModel> = PublishSubject()
    override init() {
        super.init()
        self.appleLoginTrigger.subscribe(onNext: {[weak self] in
            guard let self = self else{return}
            self.handleAppleSignInButtonTapped()
        })
        .disposed(by: disposeBag)
        self.serverLoginTrigger.flatMapLatest { loginModel in
            return LoginServie.requestLogin(loginModel)
        }
        .bind(to: serverLoginResult)
        .disposed(by: disposeBag)
        self.serverLoginResult.subscribe(onNext: {[weak self] result in
            guard let self = self else{return}
            if result.code == 200 {
                if let accessToken = result.data?.accessToken,
                   let refreshToken = result.data?.refreshToken{
                    KeychainWrapper.standard.removeAllKeys()
                    KeychainWrapper.standard.set(accessToken, forKey: "JWTaccessToken")
                    KeychainWrapper.standard.set(refreshToken, forKey: "JWTrefreshToken")
                    self.appleLoginSuccess.onNext(())
                }
            }
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
            if let code = appleIDCredential.authorizationCode?.base64EncodedString(),
               let name = appleIDCredential.fullName{
                let email = appleIDCredential.email ?? "Permission@Denied"
                self.serverLoginTrigger.onNext(LoginRequestModel(socialId: code, nickname: name.familyName ?? "익명", email: email, socialType: "APPLE"))
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

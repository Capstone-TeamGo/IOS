//
//  ReissueViewModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/21.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftKeychainWrapper

final class ReissueViewModel {
    private let disposeBag = DisposeBag()
    private var reissueNetwork : ReissueNetwork
    
    //토큰 재발행
    let reissueTrigger = PublishSubject<Void>()
    let reissueResult : PublishSubject<ReissueResponseModel> = PublishSubject()
    //토큰 만료 검사
    let reissueExpire : PublishSubject<Bool> = PublishSubject()
    init() {
        let provider = NetworkProvider(endpoint: endpointURL)
        reissueNetwork = provider.reissueNetwork()
        
        reissueTrigger.flatMapLatest { _ in
            let JWTrefreshToken = KeychainWrapper.standard.string(forKey: "JWTrefreshToken") ?? ""
            let params : [String:Any] = [
                "refreshToken" : "\(JWTrefreshToken)"
            ]
            return self.reissueNetwork.postReissue(path: reissueURL, params: params)
        }
        .bind(to: reissueResult)
        .disposed(by: disposeBag)
        
        reissueResult
            .catch { error in
                KeychainWrapper.standard.removeAllKeys()
                self.reissueExpire.onNext((true))
                return Observable.empty()
            }
            .bind(onNext: { [weak self] result in
            guard let self = self else { return }
            if result.code == 200 {
                if let JWTaccessToken = KeychainWrapper.standard.string(forKey: "JWTaccessToken") {
                    self.reissueExpire.onNext((false))
                    KeychainWrapper.standard.remove(forKey: "JWTaccessToken")
                    KeychainWrapper.standard.set(JWTaccessToken, forKey: "JWTaccessToken")
                }
            }else if result.code == 404 {
                KeychainWrapper.standard.removeAllKeys()
                self.reissueExpire.onNext((true))
            }else{
                self.reissueExpire.onNext((false))
            }
        })
        .disposed(by: disposeBag)
    }
}

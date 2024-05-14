//
//  MypageViewModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/04/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MypageViewModel {
    private let disposeBag = DisposeBag()
    private var logoutNetwork : LogoutNetwork
    //로그아웃
    let logoutTrigger = PublishSubject<Void>()
    let logoutResult : PublishSubject<LogoutResponseModel> = PublishSubject<LogoutResponseModel>()
    
    init() {
        let provider = NetworkProvider(endpoint: endpointURL)
        logoutNetwork = provider.logoutNetwork()
        
        logoutTrigger.flatMapLatest {_ in
            return self.logoutNetwork.getLogout()
        }
        .bind(to: logoutResult)
        .disposed(by: disposeBag)
    }
}

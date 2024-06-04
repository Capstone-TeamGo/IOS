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
    private var logoutNetwork : LogoutNetwork //로그아웃 통신
    private var mypageNetwork : MypageNetwork //사용자 정보 조회
    
    //로그아웃
    let logoutTrigger = PublishSubject<Void>()
    let logoutResult : PublishSubject<LogoutResponseModel> = PublishSubject<LogoutResponseModel>()
    
    //마이페이지 정보 조회
    let mypageTrigger = PublishSubject<Void>()
    let mypageResult : PublishSubject<MypageResponseModel> = PublishSubject()
    init() {
        let provider = NetworkProvider(endpoint: endpointURL)
        logoutNetwork = provider.logoutNetwork()
        mypageNetwork = provider.getMypage()
        
        //마이페이지
        mypageTrigger.flatMapLatest { _ in
            return self.mypageNetwork.mypageNetwork(path: mypageURL)
                .catch { error in
                    //에러를 넘기기
                    return Observable.empty()
                }
        }
        .bind(to: mypageResult)
        .disposed(by: disposeBag)
        
        //로그아웃
        logoutTrigger.flatMapLatest {_ in
            return self.logoutNetwork.getLogout()
                .catch { error in
                    //에러를 넘기기
                    return Observable.empty()
                }
        }
        .bind(to: logoutResult)
        .disposed(by: disposeBag)
    }
}

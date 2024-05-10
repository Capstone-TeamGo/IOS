//
//  MypageViewModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/04/25.
//

import Foundation
import RxSwift
import RxCocoa

class MypageViewModel {
    private let disposeBag = DisposeBag()
    
    //input
    struct Input {
        let logoutTrigger : PublishSubject<Void> //로그아웃
        
    }
    //output
    struct Output {
        let logoutResult : PublishSubject<Void> //로그아웃 결과
        
    }
    //Network
    public func getRequest(input : Input) -> Output {
        //로그아웃 네트워크
        
        return Output(logoutResult: PublishSubject<Void>())
    }
}

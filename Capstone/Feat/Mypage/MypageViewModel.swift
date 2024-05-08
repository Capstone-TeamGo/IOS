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
    
    //로그아웃
    let logoutTrigger = PublishSubject<Void>()
    //분석 기록
    let listTrigger = PublishSubject<Void>()
    //피드백 보내기
    let feedbackTrigger = PublishSubject<Void>()
    
    init() {
        
    }
}

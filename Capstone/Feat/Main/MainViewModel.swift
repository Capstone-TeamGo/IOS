//
//  MainViewModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/03/27.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    private let disposeBag = DisposeBag()
    private var feelingNetwork : FeelingNetwork
    
    //일주일 감정 가져오기
    let feelingTrigger = PublishSubject<Void>()
    let feelingResult : PublishSubject<FeelingRequestModel> = PublishSubject()
    
    init() {
        let provider = NetworkProvider(endpoint: endpointURL)
        feelingNetwork = provider.feelingWeekNetwork()
        
        feelingTrigger.flatMapLatest { _ in
            return self.feelingNetwork.getFeelingWeek()
        }
        .bind(to: feelingResult)
        .disposed(by: disposeBag)
    }
}

//
//  GrowingViewModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/17.
//

import Foundation
import RxCocoa
import RxSwift

final class GrowingViewModel {
    private let disposeBag = DisposeBag()
    private var mypageNetwork : MypageNetwork
    
    //나무 키우기 수
    let growingTrigger = PublishSubject<Void>()
    let growingResult : PublishSubject<MypageResponseModel> = PublishSubject()
    init() {
        let provider = NetworkProvider(endpoint: endpointURL)
        mypageNetwork = provider.getMypage()
        
        growingTrigger.flatMapLatest { _ in
            return self.mypageNetwork.mypageNetwork(path: mypageURL)
        }
        .bind(to: growingResult)
        .disposed(by: disposeBag)
    }
}

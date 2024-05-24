//
//  AnalysisPagingViewModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/25.
//

import Foundation
import RxSwift
import RxCocoa

final class AnalysisPagingViewModel {
    private let diseposeBag = DisposeBag()
    private var analysisPagingNetwork : AnalysisPagingNetwork
    
    //페이징 조회
    let pagingTrigger = PublishSubject<Void>()
    let pagingResult : PublishSubject<AnalysisPagingResponseModel> = PublishSubject()
    init() {
        let provider = NetworkProvider(endpoint: endpointURL)
        analysisPagingNetwork = provider.analysisPagingNetwork()
        
        
    }
}

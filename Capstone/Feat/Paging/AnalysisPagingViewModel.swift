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
    private let disposeBag = DisposeBag()
    private var analysisPagingNetwork : AnalysisPagingNetwork
    
    //페이징 조회
    let pagingTrigger = PublishSubject<Void>()
    let pagingResult : PublishSubject<[AnaylsisResponseDtoList]> = PublishSubject()
    init() {
        let provider = NetworkProvider(endpoint: endpointURL)
        analysisPagingNetwork = provider.analysisPagingNetwork()
        
        pagingTrigger.subscribe { _ in
            self.analysisPagingNetwork.getPaging(path: analysisPagingURL)
                .subscribe(onNext: { [weak self] result in
                    guard let self = self else { return }
                    if let tableList = result.data.anaylsisResponseDtoList{
                        self.pagingResult.onNext(tableList)
                    }
                })
                .disposed(by: self.disposeBag)
        }
        .disposed(by: disposeBag)
    }
}

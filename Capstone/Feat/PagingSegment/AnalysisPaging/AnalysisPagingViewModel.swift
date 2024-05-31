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
    private var pageCount = 1
    private var isFetching = false
    
    //페이징 조회
    let refreshTrigger = PublishSubject<Void>()
    let nextPageTrigger = PublishSubject<Void>()
    let pagingResult : PublishSubject<[AnaylsisResponseDtoList]> = PublishSubject()
    private var allResults: [AnaylsisResponseDtoList] = []
    init() {
        let provider = NetworkProvider(endpoint: endpointURL)
        analysisPagingNetwork = provider.analysisPagingNetwork()
        
        refreshTrigger.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.pageCount = 1
            self.fetchData(isRefreshing: true)
        }).disposed(by: disposeBag)
        
        nextPageTrigger.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.fetchData(isRefreshing: false)
        }).disposed(by: disposeBag)
    }
    private func fetchData(isRefreshing: Bool) {
        guard !isFetching else { return }
        isFetching = true
        print("\(analysisPagingURL)?pageNumber=\(pageCount)")
        analysisPagingNetwork.getPaging(path: "\(analysisPagingURL)?pageNumber=\(pageCount)")
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                if let tableList = result.data.anaylsisResponseDtoList {
                    if isRefreshing {
                        self.allResults = tableList
                    } else {
                        self.allResults.append(contentsOf: tableList)
                    }
                    self.pagingResult.onNext(self.allResults)
                    self.pageCount += 1
                }
                self.isFetching = false
            }, onError: { [weak self] error in
                self?.isFetching = false
            })
            .disposed(by: disposeBag)
    }
}

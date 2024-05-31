//
//  ConsultingPagingViewModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/31.
//

import Foundation
import RxSwift
import RxCocoa

final class ConsultingPagingViewModel {
    private let disposeBag = DisposeBag()
    private var consultingPagingNetwork : ConsultingNetwork
    private var pageCount = 1
    private var isFetching = false
    
    //페이징 조회
    let refreshTrigger = PublishSubject<Void>()
    let nextPageTrigger = PublishSubject<Void>()
    let pagingResult : PublishSubject<[CounselContent]> = PublishSubject()
    private var allResults: [CounselContent] = []
    init() {
        let provider = NetworkProvider(endpoint: endpointURL)
        consultingPagingNetwork = provider.getCounsel()
        
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
        print("\(CounselURL)?pageNumber=\(pageCount)")
        consultingPagingNetwork.getConsulting(path: "\(CounselURL)?pageNumber=\(pageCount)")
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                if let tableList = result.data?.counselContent {
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

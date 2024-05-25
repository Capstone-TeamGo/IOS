//
//  AnalysisDetailViewModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/25.
//

import Foundation
import RxCocoa
import RxSwift

final class AnalysisDetailViewModel {
    private let disposeBag = DisposeBag()
    private var analysisDetailNetwork : AnalysisDetailNetwork
    
    //상세 조회하기
    let detailTrigger = PublishSubject<Int>()
    let detailResult : PublishSubject<AnalysisDetailResponseModel> = PublishSubject()
    init() {
        let provider = NetworkProvider(endpoint: endpointURL)
        analysisDetailNetwork = provider.analysisDetailNetwork()
        
        detailTrigger.flatMapLatest { id in
            return self.analysisDetailNetwork.getAnalysisDetail(path: "\(analysisPagingURL)/\(id)")
        }
        .bind(to: detailResult)
        .disposed(by: disposeBag)
    }
}


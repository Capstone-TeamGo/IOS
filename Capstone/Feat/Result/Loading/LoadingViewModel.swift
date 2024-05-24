//
//  LoadingViewModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/23.
//

import Foundation
import RxSwift
import RxCocoa

final class LoadingViewModel {
    private let disposeBag = DisposeBag()
    private var sentimentAnalysisNetwork : SentimentAnalysisNetwork
    
    //감정 분석
    let sentimentAnalysisTrigger = PublishSubject<Int>()
    let sentimentAnalysisResult : PublishSubject<SentimentAnalysisResponseModel> = PublishSubject()
    
    init() {
        let provider = NetworkProvider(endpoint: endpointURL)
        sentimentAnalysisNetwork = provider.sentimentAnalysisNetwork()
        
        sentimentAnalysisTrigger.subscribe(onNext : { [weak self] analysisId in
            guard let self = self else { return }
            let fullPath : String = "\(SentimentAnalysisURL)\(analysisId)"
            self.sentimentAnalysisNetwork.postSentimentAnalysis(path: fullPath)
                .subscribe(onNext: { [weak self] result in
                    guard let self = self else { return }
                    self.sentimentAnalysisResult.onNext(result)
                })
                .disposed(by: self.disposeBag)
        })
        .disposed(by: disposeBag)
    }
}

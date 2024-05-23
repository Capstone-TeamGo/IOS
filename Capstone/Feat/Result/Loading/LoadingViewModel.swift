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
        
        sentimentAnalysisTrigger.flatMapLatest { analysisId in
            return self.sentimentAnalysisNetwork.postSentimentAnalysis(path: "\(SentimentAnalysisURL)\(analysisId)")
        }
        .bind(to: sentimentAnalysisResult)
        .disposed(by: disposeBag)
    }
}

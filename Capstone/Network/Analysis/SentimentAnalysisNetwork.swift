//
//  SentimentAnalysisNetwork.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/23.
//

import Foundation
import RxSwift
import RxCocoa

final class SentimentAnalysisNetwork {
    let network : Network<SentimentAnalysisResponseModel>
    init(network: Network<SentimentAnalysisResponseModel>) {
        self.network = network
    }
    public func postSentimentAnalysis(path: String) -> Observable<SentimentAnalysisResponseModel> {
        return network.postSentimentNetwork(path: path)
    }
}

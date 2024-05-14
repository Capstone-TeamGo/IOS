//
//  AnalysisNetwork.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/15.
//

import Foundation
import RxSwift
import RxCocoa

final class AnalysisNetwork {
    private let network : Network<AnswerRequestModel>
    init(network: Network<AnswerRequestModel>) {
        self.network = network
    }
    public func postAnswer(analysisId : Int, questionId : Int) -> Observable<AnswerRequestModel>{
        let params : [String:Any] = [
            "questionId" : questionId
        ]
        return network.postNetwork(path: "/analysis/\(analysisId)/answer", params: params)
    }
}

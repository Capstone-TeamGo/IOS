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
    private let network : Network<AnswerResponseModel>
    init(network: Network<AnswerResponseModel>) {
        self.network = network
    }
    public func postAnswer(analysisId : Int, questionId : Int, dataURL: URL) -> Observable<AnswerResponseModel>{
        let params : [String:Any] = [
            "questionId" : questionId
        ]
        return network.formDataNetwork(path: "/analysis/\(analysisId)/answer?questionId=\(questionId)", params: params, dataURL: dataURL)
    }
}

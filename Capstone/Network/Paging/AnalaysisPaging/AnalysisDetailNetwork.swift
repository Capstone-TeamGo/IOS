//
//  AnalysisDetail.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/25.
//

import Foundation
import RxCocoa
import RxSwift

final class AnalysisDetailNetwork {
    private let network : Network<AnalysisDetailResponseModel>
    init(network: Network<AnalysisDetailResponseModel>) {
        self.network = network
    }
    public func getAnalysisDetail(path: String) -> Observable<AnalysisDetailResponseModel> {
        return network.getNetwork(path: path)
    }
}

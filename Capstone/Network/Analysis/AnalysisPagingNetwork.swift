//
//  AnalysisPagingNetwork.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/25.
//

import Foundation
import RxSwift
import RxCocoa

final class AnalysisPagingNetwork {
    private let network : Network<AnalysisPagingResponseModel>
    init(network: Network<AnalysisPagingResponseModel>) {
        self.network = network
    }
    public func getPaging(path: String) -> Observable<AnalysisPagingResponseModel> {
        return network.getNetwork(path: path)
    }
}

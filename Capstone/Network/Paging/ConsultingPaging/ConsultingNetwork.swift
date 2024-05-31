//
//  ConsultingNetwork.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/31.
//

import Foundation
import RxSwift
import RxCocoa

final class ConsultingNetwork {
    private let network : Network<ConsultingPagingResponseModel>
    init(network: Network<ConsultingPagingResponseModel>) {
        self.network = network
    }
    public func getConsulting(path: String) -> Observable<ConsultingPagingResponseModel> {
        return network.getNetwork(path: path)
    }
}

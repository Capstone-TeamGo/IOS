//
//  ConsultingDetailNetwork.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/31.
//

import Foundation
import RxSwift
import RxCocoa
final class ConsultingDetailNetwork {
    private let network : Network<ConsultingDetailResponseModel>
    init(network: Network<ConsultingDetailResponseModel>) {
        self.network = network
    }
    public func consultingDetailNetwork(path : String) -> Observable<ConsultingDetailResponseModel> {
        return network.getNetwork(path: path)
    }
}

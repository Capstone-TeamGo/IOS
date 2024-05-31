//
//  CounselNetwork.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/31.
//

import Foundation
import RxSwift
import RxCocoa

final class CounselNetwork {
    private let network : Network<CounselResponseModel>
    init(network: Network<CounselResponseModel>) {
        self.network = network
    }
    public func counselNetwork(path: String, params: [String:Any]) -> Observable<CounselResponseModel> {
        return network.postNetwork(path: path, params: params)
    }
}

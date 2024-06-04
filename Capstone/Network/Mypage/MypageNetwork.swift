//
//  MypageNetwork.swift
//  Capstone
//
//  Created by 정성윤 on 2024/06/04.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

final class MypageNetwork {
    private let network : Network<MypageResponseModel>
    init(network: Network<MypageResponseModel>) {
        self.network = network
    }
    public func mypageNetwork(path: String) -> Observable<MypageResponseModel> {
        return network.getNetwork(path: path)
    }
}

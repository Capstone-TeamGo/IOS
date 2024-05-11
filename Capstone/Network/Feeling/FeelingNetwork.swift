//
//  File.swift
//  Capstone
//
//  Created by 정성윤 on 2024/04/25.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import SwiftKeychainWrapper
final class FeelingNetwork {
    private let network : Network<FeelingRequestModel>
    init(network: Network<FeelingRequestModel>) {
        self.network = network
    }
    public func getFeelingWeek() -> Observable<FeelingRequestModel> {
        return network.getNetwork(path: feelingWeekURL)
    }
}

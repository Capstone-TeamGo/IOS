//
//  ReissueNetwork.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/21.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire
import Alamofire
import SwiftKeychainWrapper
import UIKit

final class ReissueNetwork {
    private let network : Network<ReissueResponseModel>
    init(network: Network<ReissueResponseModel>) {
        self.network = network
    }
    public func postReissue(path : String, params : [String:Any]) -> Observable<ReissueResponseModel> {
        return network.postNetwork(path: path, params: params)
    }
}

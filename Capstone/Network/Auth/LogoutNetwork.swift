//
//  LogoutNetwork.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/11.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftKeychainWrapper
final class LogoutNetwork {
    private let network : Network<LogoutResponseModel>
    init(network: Network<LogoutResponseModel>) {
        self.network = network
    }
    public func getLogout() -> Observable<LogoutResponseModel> {
        let refreshToken = KeychainWrapper.standard.string(forKey: "JWTrefreshToken") ?? ""
        let params : [String:Any] = [
            "refreshToken" : refreshToken
        ]
        return network.postNetwork(path: logoutURL, params: params)
    }
}

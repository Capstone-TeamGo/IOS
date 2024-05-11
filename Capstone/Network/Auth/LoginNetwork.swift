//
//  LoginService.swift
//  Capstone
//
//  Created by 정성윤 on 2024/04/19.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
final class LoginNetwork {
    private let network : Network<LoginResponseModel>
    init(network: Network<LoginResponseModel>) {
        self.network = network
    }
    public func getLogin(_ loginModel : LoginRequestModel) -> Observable<LoginResponseModel> {
        let params : [String:Any] = [
            "socialId" : loginModel.socialId,
            "nickname" : loginModel.nickname,
            "email" : loginModel.email ?? "Permission@Denied",
            "socialType" : loginModel.socialType
        ]
        return network.loginNetwork(path: loginURL, params: params)
    }
}

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

class LoginServie {
    static func requestLogin(_ loginModel : LoginRequestModel) -> Observable<LoginResponseModel> {
        Observable.create { observer in
            let params : [String:Any] = [
                "socialId" : loginModel.socialId,
                "nickname" : loginModel.nickname,
                "email" : loginModel.email ?? "Permission@Denied",
                "socialType" : loginModel.socialType
            ]
            AF.request("http://13.124.95.110:8080/api/v1/user/login-oauth", method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"Application/json"])
                .validate()
                .responseDecodable(of: LoginResponseModel.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                }
            return Disposables.create()
        }
    }
}

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
class FeelingService {
    static func requestFeeling() -> Observable<FeelingRequestModel> {
        Observable.create { observer in
            if let accessToken = KeychainWrapper.standard.string(forKey: "JWTaccessToken"){
                let url = "http://13.124.95.110:8080/api/v1/analysis/week"
                AF.request(url, method: .get, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Authorization":accessToken])
                    .validate()
                    .responseDecodable(of: FeelingRequestModel.self) { response in
                        switch response.result {
                        case .success(let data):
                            observer.onNext(data)
                            observer.onCompleted()
                        case .failure(let error):
                            observer.onError(error)
                        }
                    }
            }
            return Disposables.create()
        }
    }
}

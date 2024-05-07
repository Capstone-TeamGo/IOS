//
//  QuestionService.swift
//  Capstone
//
//  Created by 정성윤 on 2024/04/19.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
import SwiftKeychainWrapper
class QuestionService {
    static func requestQuestion() -> Observable<QuestionResponseModel> {
        Observable.create { observer in
            if let accessToken = KeychainWrapper.standard.string(forKey: "JWTaccessToken"){
                AF.request(questionURL, method: .post, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json", "Authorization":accessToken])
                    .validate()
                    .responseDecodable(of: QuestionResponseModel.self) { response in
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

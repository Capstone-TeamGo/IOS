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
final class QuestionNetwork {
    private let network : Network<QuestionResponseModel>
    init(network: Network<QuestionResponseModel>) {
        self.network = network
    }
    public func getQuestion() -> Observable<QuestionResponseModel> {
        return network.postNetwork(path: questionURL, params: [:])
    }
}

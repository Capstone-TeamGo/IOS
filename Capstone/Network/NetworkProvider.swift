//
//  NetworkProvider.swift
//  Capstone
//
//  Created by 정성윤 on 2024/05/11.
//

import Foundation
import RxSwift
import RxCocoa
//어떤 네트워크든지 생성할 수 있는 클래스
final class NetworkProvider {
    private let endpoint : String
    init(endpoint: String) {
        self.endpoint = endpointURL
    }
    //로그인
    public func loginNetwork() -> LoginNetwork {
        let network = Network<LoginResponseModel>(endpoint)
        return LoginNetwork(network: network)
    }
    //로그아웃
    public func logoutNetwork() -> LogoutNetwork {
        let network = Network<LogoutResponseModel>(endpoint)
        return LogoutNetwork(network: network)
    }
    //감정 분석(일주일)
    public func feelingWeekNetwork() -> FeelingNetwork {
        let network = Network<FeelingRequestModel>(endpoint)
        return FeelingNetwork(network: network)
    }
    //질문 가져오기
    public func questionNetwork() -> QuestionNetwork {
        let network = Network<QuestionResponseModel>(endpoint)
        return QuestionNetwork(network: network)
    }
    //녹음파일 전송
//    public func RecordNetwork() ->
}

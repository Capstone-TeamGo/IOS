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
    //MARK: - Auth
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
    //토큰 재발행
    public func reissueNetwork() -> ReissueNetwork {
        let network = Network<ReissueResponseModel>(endpoint)
        return ReissueNetwork(network: network)
    }
    //MARK: - Analysis
    //감정 분석(일주일)
    public func feelingWeekNetwork() -> FeelingNetwork {
        let network = Network<FeelingRequestModel>(endpoint)
        return FeelingNetwork(network: network)
    }
    //감정 분석하기
    public func sentimentAnalysisNetwork() -> SentimentAnalysisNetwork {
        let network = Network<SentimentAnalysisResponseModel>(endpoint)
        return SentimentAnalysisNetwork(network: network)
    }
    //과거기록 조회(페이징)
    public func analysisPagingNetwork() -> AnalysisPagingNetwork {
        let network = Network<AnalysisPagingResponseModel>(endpoint)
        return AnalysisPagingNetwork(network: network)
    }
    //과거기록 조회(상세)
    public func analysisDetailNetwork() -> AnalysisDetailNetwork {
        let network = Network<AnalysisDetailResponseModel>(endpoint)
        return AnalysisDetailNetwork(network: network)
    }
    //MARK: - Question
    //질문 가져오기
    public func questionNetwork() -> QuestionNetwork {
        let network = Network<QuestionResponseModel>(endpoint)
        return QuestionNetwork(network: network)
    }
    //녹음파일 전송
    public func PostRecorderNetwork() -> AnalysisNetwork {
        let network = Network<AnswerResponseModel>(endpoint)
        return AnalysisNetwork(network: network)
    }
    //MARK: - Counsel
    public func counselNetwork() -> CounselNetwork {
        let network = Network<CounselResponseModel>(endpoint)
        return CounselNetwork(network: network)
    }
}

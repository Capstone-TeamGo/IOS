//
//  MainViewModel.swift
//  Capstone
//
//  Created by 정성윤 on 2024/03/27.
//

import Foundation
import RxSwift
import RxCocoa

class MainViewModel {
    private let disposeBag = DisposeBag()
    private let feelingNetwork : FeelingNetwork
    init() {
        let provider = NetworkProvider(endpoint: endpointURL)
        feelingNetwork = provider.feelingWeekNetwork()
    }
    
    struct Input {
        let feelingTrigger : Observable<Void>
    }
    struct Output {
        let feelingResult : Observable<FeelingRequestModel>
    }
    public func requestMain(input: Input) -> Output {
        let feelingData = input.feelingTrigger.flatMapLatest { [unowned self] _ -> Observable<FeelingRequestModel> in
            return self.feelingNetwork.getFeelingWeek()
        }
        return Output(feelingResult: feelingData)
    }
}

//let tvList = input.tvTrigger.flatMapLatest { [unowned self] _ -> Observable<[TV]> in
//    return self.tvNetwork.getTopRatedList().map { $0.results ?? [] }
//}
//Observable 1,2,3 합쳐서 하나의 Observable로 바꾸고 싶다면? Observable.combineLatest
//let movieResult = input.moTrigger.flatMapLatest { [unowned self] _ -> Observable<MovieResult> in
//    return Observable.combineLatest(self.movieNetwork.getUpcomingList(), self.movieNetwork.getPopularList(), self.movieNetwork.getNowPlayingList()) { upcoming, popular, nowPlaying -> MovieResult in
//        return MovieResult(upcoming: upcoming, popular: popular, nowPlaying: nowPlaying)
//    }
//}
